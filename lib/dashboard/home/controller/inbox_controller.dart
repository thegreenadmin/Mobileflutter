import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/constants.dart';

class InboxController extends GetxController {
  RxBool isNotify = false.obs;
  RxBool isInboxSelected = false.obs;
  RxList inboxList = [
    "Oh What a fun it is to buy @ Store 1",
    "Oh What a fun it is to buy @ Store 1",
    "Oh What a fun it is to buy @ Store 1"
  ].obs;

  @override
  void onInit() {}
}
