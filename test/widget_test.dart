// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_test/main.dart';

void main() async{


  // firestore는 [Collection reference][Document reference][Document snapshot]
  // 세단계로 접근하여 최종적으로 데이터를 얻을 수 있다.

  // firestore는 [Collection reference][Query][QuerySnapshot][QueryDocument snapshot]
  // 네단계로 접근하여 최종적인 데이터를 얻을 수 있다.

  // 두 데이터는 동일하다

  // [Query] 단계에서 .where('' : '') 조건문을 써서 [QuerySnapshot]을 생성할 수 있다

  // [Document snapshot] 과 [QueryDocument snapshot] 이 결국 최종 데이터 값인데 이것에 접근하기 위해서는
  // 반드시 [Document reference] 또는 [QuerySnapshot] 단계를 거쳐야한다.

  //--------------------FireStore 사용법 [Document reference]----------------------//
  // [Collection reference]를 얻는다.

  FirebaseFirestore.instance.collection('user');

  // [Collection reference]를 얻은 후 doc을 통해 [Document reference]를 얻는다.
  FirebaseFirestore.instance.collection('user').doc('asdfsadf');

  // [Collection reference] [Document reference] 를 얻은 후 get을 통해 최종 데이터 값인 [DocumentSnapshot]을 가져온다.
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('user').doc('asdfsadf').get();

  // 최종값 documentSnapshot에 data() 메소드를 이용하면 Map 형태의 {키 : 밸류} 값으로 리턴해준다.
  // data가 있으면 Map 형태로 return, 데이터가 없으면 null return
  documentSnapshot.data();

  // add() :새로운 Document 추가 기능
  // doc() : [Document reference]를 return 해준다... [Document reference] 얻기 위해 사용하는 구문
  // [Collection reference]에 add를 사용하여 Document 값을 주면 새로운 Document 가 생성된다
  FirebaseFirestore.instance.collection('videos').add({'video_title': 'fullName'});

  // 데이터를 갱신해준다(엎어쓰기도 한다)
  FirebaseFirestore.instance.collection('users').doc('docId').set({'name': 'jhon'});

  // 데이터를 갱신해준다. 찾아서 이름을 바꿔준다. set과 거의 유사하다. 그러나 set을 더 많이 쓴다
  FirebaseFirestore.instance.collection('users').doc('docId').update({'name': 'jhon'});

  // 해당 docId 를 삭제해준다
  FirebaseFirestore.instance.collection('users').doc('docId').delete();

  // collection doc 반복하며 계속된 자료 저장 구조를 만들수도 있다.
  FirebaseFirestore.instance
      .collection('users')
      .doc('docId')
      .collection('user')
      .doc('docId')
      .collection('use')
      .doc('docId');

  FirebaseFirestore.instance.collection('users').doc('8768uyfgu876').get();

  // documentSnapshot 최종 값을 얻은 후 data() 메소드를 사용하면 Map 형태로 값을 리턴 해준다

  //--------------------FireStore 사용법 [Query reference]----------------------//

  // 특정 조건의 데이터를 가져올때 Query 라는걸 써서 가져오는데 Query를 얻는 조건은 아래와 같다
  // Collection reference]에서 where 조건문을 쓰면 query 라는 객체를 리턴해준다. [QueryDocument reference] 단계임
  Query query1 = FirebaseFirestore.instance.collection('user').where('age', isGreaterThan: 20);
  QuerySnapshot query2 = await FirebaseFirestore.instance.collection('user').get();

  FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapchot) {
    querySnapchot.docs.forEach((doc) {
      print(doc['first.name']);
    });
  });

  // query를 얻은 후 최종 데이터값[QueryDocument snapshot]을 가져오기 위해 get()을 사용하고
  // 이후 then((value) {})를 사용하여 어떤 함수를 실행해줘도 된다
  query1.get().then((value) {});

  // [Collection reference에서 where를 쓰면 Query를 리턴해줌]에서 get() 사용하면
  // [QuerySnapshot (= DocumentSnapshot 사실상 같은개념임)]을 바로 얻을 수 있다.
  // Query에서 get() 메소드를 쓰면 QuerySnapshot을 리턴한다
  QuerySnapshot querySnapshot1 = await query1.get();

  // Query 에서 snapShot() 메소드를 쓰면 QuerySnapshot을 리턴해준다.
  Stream<QuerySnapshot> querySnapshot2 = query1.snapshots();

  // 최종값 documentSnapshot에 data() 메소드를 이용하면 Map 형태의 {키 : 밸류} 값으로 리턴해준다.

  //--------------------FireStore 사용법 [stream]----------------------//

  // 실시간으로 데이터를 받아오는 형태로 firestore를 사용하려면 snapshot() 메소드로 접근한다.

  // [Collection reference] 단계에서 snapshots() 메소드를 사용하면 실시간 스트림용 QuerySnapshot을 구할 수 있다.
  FirebaseFirestore.instance.collection('users').snapshots();

  // [Collection reference] 이후 [Document reference] 단계에서 snapshots()를 사용하면 실시간 스트림용 DocumentSnapshot을 구할 수 있다.
  FirebaseFirestore.instance.collection('users').doc('docId').snapshots();

  // [Collection reference] 이후 Query 값에서 snapshots()을 사용하면 실시간 스트림용 QuerySnapshot을 구할 수 있다
  FirebaseFirestore.instance.collection('users').where('age', isGreaterThan: 20).snapshots();

  //--------------------최종----------------------//

  // [DocumentSnapshot] 나 [QureyDocumentSnapshot] 이 거의 동일한데
  // [QureyDocumentSnapshot]은 null 없이 값이 없더라도 빈 값인 '' 형태로 리턴해준다
  // querySnapshot.exist로 검사할때도 true가 리턴된다
  // QureyDocumentSnapshot.data() 로 데이터를 구하더라도 항상 빈 값이라도 리턴해준다.

  // 아래는 최종 데이터값인 QueryDocumentSnapshot을 구하는 방법이다.
  FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs;
  });

  // 이후 최종 데이터에서 각각의 doc 즉 도큐먼트를 접근하여 도큐먼트 안에 요소를 출력해 볼 수 있다
  FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc['first_name']);
    });
  });

  // 최종 관문인 queryDoucumentSnapshot에 도착하기 위해 먼저 querySnapshot 을 구한다
  QuerySnapshot querySnapshot3 = await FirebaseFirestore.instance.collection('users').get();

  // 리스트 형태의 QueryDocumentSnapshot 을 구하기 위해 querySnapshot3.docs를 한다
  List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot3.docs;

  // QueryDocumentSnapshot 값의 첫번째 데이터를 호출해본다
  print(queryDocumentSnapshot[0].data());

  queryDocumentSnapshot.forEach((doc) {
    doc['first_name'];
  });


}
