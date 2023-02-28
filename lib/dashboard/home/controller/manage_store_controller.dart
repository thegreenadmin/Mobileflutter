import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/constants.dart';

class ManageStoreController extends GetxController {
  RxBool isNotify = false.obs;
  RxBool isMenuSelected = false.obs;
  RxList menuList = [
    "Oh What a fun it is to buy @ Store 1",
    "Oh What a fun it is to buy @ Store 1",
    "Oh What a fun it is to buy @ Store 1"
  ].obs;

  @override
  void onInit() {}
}
