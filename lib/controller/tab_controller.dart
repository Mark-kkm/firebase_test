import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController controller;
  var selectedStoreState = ''.obs;

  @override
  void onInit() {
    controller = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  onChangedValue(var value) {
    selectedStoreState.value = value;
  }
}


//
// List<Tab> productsTabs = [
//   const Tab(
//     text: '상품등록',
//   ),
//   const Tab(
//     text: '상품변경',
//   ),
//   const Tab(
//     text: '상품옵션',
//   )
// ];
//
// List<Tab> evaluationTabs = [
//   const Tab(
//     text: '리뷰현황',
//   ),
//   const Tab(
//     text: '좋아요 유저',
//   ),
//   const Tab(
//     text: '사장님공지',
//   )
// ];
//
// List<Tab> couponTabs = [
//   const Tab(
//     text: '쿠폰등록',
//   ),
//   const Tab(
//     text: '쿠폰내역',
//   ),
//   const Tab(
//     text: '사용할쿠폰',
//   )
// ];