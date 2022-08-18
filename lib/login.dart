
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/sns_sign_in_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SnsLoginController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.5,
                ),
                snsLoginButton(
                  SnsLoginController.instance.signInWithGoogle,
                  'kakaotalk_icon.svg',
                  'KaKao로 시작하기',
                  const Color(0xffFEE500),
                  Colors.black87,
                ),
                const SizedBox(
                  height: 10,
                ),
                snsLoginButton(
                  SnsLoginController.instance.signInWithGoogle,
                  'google_logo_icon_169090.svg',
                  'Google로 시작하기',
                  const Color(0xffffffff),
                  Colors.black54,
                ),
                const SizedBox(
                  height: 10,
                ),
                appleLoginButton(
                  SnsLoginController.instance.signInWithApple,
                  'Apple_icon-icons.com_68994.svg',
                  'Apple로 시작하기',
                  Colors.black,
                  Colors.white,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var result = await SnsLoginController.instance.signInWithGoogle();
                      if (result == null) {
                        print('없음');
                      } else {
                        print('성공: ${result.uid}');
                        print('성공: ${result.name}');
                        print('성공: ${result.email}');
                        print('성공: ${result.photoUrl}');
                        print('성공: ${result.phoneNumber}');
                      }
                    },
                    child: Text('sdfasdf'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------- 구글, 카카오 로그인 버튼 -------------- //
  Widget snsLoginButton(
      Function() method,
      String snsLogo,
      String text,
      Color backgroundColor,
      Color textColor,
      ) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        fixedSize: Size(Get.width * 0.7, Get.height * 0.07),
        primary: backgroundColor,
        onPrimary: textColor,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              'images/$snsLogo',
              height: 22,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(text),
          ),
        ],
      ),
    );
  }

  // -------------- 애플 로그인 버튼 -------------- //

  Widget appleLoginButton(
      Function() method,
      String snsLogo,
      String text,
      Color backgroundColor,
      Color textColor,
      ) {
    return ElevatedButton(
      onPressed: () {
        method;
        print(SnsLoginController.instance.signInWithGoogle);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        fixedSize: Size(Get.width * 0.7, Get.height * 0.07),
        primary: backgroundColor,
        onPrimary: textColor,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              'images/$snsLogo',
              color: Colors.white,
              height: 22,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
