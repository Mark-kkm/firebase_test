
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/tab_controller.dart';

import 'operation_information_page.dart';


class StorePage extends StatelessWidget {
  StorePage({Key? key}) : super(key: key);

  final TabBarController _tabs = Get.put(TabBarController());

  List<Tab> storeTabs = [
    const Tab(text: '매장정보'),
    const Tab(text: '운영관리'),
    const Tab(text: '영업임시중지'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('매장'),
        centerTitle: true,
        bottom: TabBar(
          tabs: storeTabs,
          controller: _tabs.controller,
        ),
      ),
      body: TabBarView(
        controller: _tabs.controller,
        children: [
          OperationInformationPage(),

        ],
      ),
    );
  }
}
