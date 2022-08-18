import 'package:firebase_test/store_tab_page/store_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Widget navigationDrawerWidget(BuildContext context) {
  return Drawer(
    child: Container(
      height: double.infinity,
      width: Get.width * 0.7,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 30),
          headerSection(context),
          const SizedBox(height: 30),
          buildMenuItem(text: '매장', onClicked: () => Get.to(() => StorePage())),
        ],
      ),
    ),
  );
}

Widget buildMenuItem({required String text, VoidCallback? onClicked}) {
  return ListTile(
    onTap: onClicked,
    title: Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    trailing: const Icon(
      Icons.keyboard_arrow_right,
      color: Colors.white,
    ),
  );
}

Widget headerSection(BuildContext context) {
  return SizedBox(
    height: 80,
    width: Get.width * 0.7,
    child: Row(
      children: [
        CircleAvatar(
            backgroundColor: Colors.grey,
            child: Container(
              height: 80,
            )),
        const Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            '가게 이름',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        )),
      ],
    ),
  );
}
