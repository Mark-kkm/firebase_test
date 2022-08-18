import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller/tab_controller.dart';

class OperationInformationPage extends GetView<TabBarController> {
  OperationInformationPage({Key? key}) : super(key: key);

  TabBarController tabBarController = Get.put(TabBarController());

  @override
  Widget build(BuildContext context) {
    var divider = SizedBox(
      width: Get.width,
      height: Get.height * 0.01,
    );

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.grey,
        child: Column(
          children: [
            storeState(),
            divider,
          ],
        ),
      ),
    );
  }

  Widget storeState() {
    return Container(
      color: Colors.white,
      width: Get.width,
      height: Get.height * 0.2,
      child: Column(
        children: [
          Text('가게상태'),
          radioListtile()
        ],
      ),
    );
  }

  Widget radioListtile(){
    return Obx( () =>
      Column(
        children: [
          RadioListTile(
            title: const Text(
              '영업중',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            value: '영업중',
            groupValue: controller.selectedStoreState.value,
            onChanged: (value) {
              controller.onChangedValue(value);
            },
          ),
          RadioListTile(
            title: const Text(
              '준비중',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            value: '준비중',
            groupValue: controller.selectedStoreState.value,
            onChanged: (value) {
              controller.onChangedValue(value);
            },
          ),
        ],
      ),
    );
  }

}
