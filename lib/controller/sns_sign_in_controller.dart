import 'dart:math';
import 'package:firebase_test/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import '../home.dart';
import '../login.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

class SnsLoginController extends GetxController {
  static SnsLoginController instance = Get.find();
  late Rx<User?> dbuser;

  // 파이어베이스 인증관련 기능을 authentication 를 통해서 사용하겠다
  FirebaseAuth authentication = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    // _user에 파이어베이스의 현재 사용자 정보가 담길것이고
    // _user가 로그인을 하든 로그아웃을 하든
    dbuser = Rx<User?>(authentication.currentUser);
    //뭔 행동을 하는지 추적관찰하기 위해서 실시간 형태로 행동을 주시한다
    // bind 한 이후 Stream은 유저의 실시간 행동 데이터를 전달해주는데
    // userChanges는 [authStateChanges] 및 [idTokenChanges] 등 을 초월한 최 상위의 집합체로서
    // 유저가 로그인 하는지 로그아웃 하는지 또는 다른 행동변화를 전달해준다
    dbuser.bindStream(authentication.userChanges());

    // 행동 변화를 전달 받았다면 이제 앱에서 직접 처리해줘야하는 부분이 있어야하기에
    // ever를 사용해서 리스너는 _user이고 콜백함수는 _moveToPage를 실행해준다
    ever(dbuser, _moveToPage);
  }

  UserModel? userFromFirebaseUser(User? dbuser) {
    return dbuser != null
        ? UserModel(
            name: dbuser.displayName.toString(),
            uid: dbuser.uid.toString(),
            email: dbuser.email.toString(),
            photoUrl: dbuser.photoURL.toString(),
            phoneNumber: dbuser.phoneNumber.toString(),
          )
        : null;
  }

  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => Home());
    }
  }

  void logout() async {
    // 각각 로그아웃 구현하고
    // 마지막에 파이어베이스 로그아웃 구현
    await authentication.signOut();

    try {
      await kakao.UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  // -------------------------------구글로 시작하기 ---------------------------------------- //

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential

    final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    User? dbuser = authResult.user;
    return userFromFirebaseUser(dbuser);
  }

  // -------------------------------카카오로 시작하기 ---------------------------------------- //

  singInWithKakao() async {
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  // -------------------------------애플로 시작하기 ---------------------------------------- //

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      // firebase auth로 인증절차 (firebase auth를 사용안할 경우 아래 작업은 안해도 된다.)
      // credential 안에 애플 정보는 담겨 있다. (email, fullName 등)
      final authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // 인증 완료되면 firebaseUser 값으로 반환
      final firebaseUser = authResult.user;

      final displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';
      print(displayName);

      await firebaseUser?.updateDisplayName(displayName);
      await firebaseUser?.updateEmail(userEmail);
      return firebaseUser;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

// - apple_sign_in : 실제로 애플 로그인이 동작하기 위해 필요한 패키지
// - firebase_auth : 애플 로그인시 idToken을 이용하여 firebase 의 authentication 인증에 사용되는 패키지 (선택사항)
// - flutter_secure_storage : 최초 애플 로그인 이후 자동로그인 설정을 하기 위한 패키지

//
// // 2.  로그아웃
// Future<void> signOutGoogle() async {
//   // Firebase 로그아웃
//   await authentication.signOut();
// }
//
// // 3. 회원 탈퇴
// void deleteUserFromFirebase(BuildContext context) async {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   users.doc(docId).delete();
//   User? user = authentication.currentUser;
//   user!.delete();
//   await signOutGoogle(); // 위(2번 로그아웃 샘플코드)에서 정의한 함수입니다.
// }
//
// //4. 번외> UID를 이용하여 유저가 DB(firestore)에 있는지 확인하는 함수
// Future<Map<String, dynamic>> findUserByUid(String uid) async {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();
//   if (data.size == 0) {
//     return null;
//   } else {
//     docId = data.docs[0].id;
//     return userData;
//   }
// }
