import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/model/user_inbox_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class UserInboxController extends GetxController {
  RxBool isNotify = false.obs;
  RxBool isInboxSelected = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController messageTextController = TextEditingController();
  late UserInboxModel inboxModel = UserInboxModel();
  RxList<MessageHead> inboxList = <MessageHead>[].obs;
  RxString? role = "".obs;
  RxBool showPreviousMessages = false.obs;
  final scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt pageId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    isInboxSelected.value = true;
    showPreviousMessages.value = false;
    apiGetInboxList();
    role?.value = roleApp.value;
  }

  ///Get Inbox message heads List Api
  Future apiGetInboxList() async {
    isLoading.value = true;

    RxString url = "".obs;
    if (showPreviousMessages.value) {
      url.value =
          "${ServerCommunicator().baseUrl}${ServerCommunicator().messageInboxList}?page=1&page_size=10&show_previous_messages=${showPreviousMessages.value}";
    } else {
      url.value =
          "${ServerCommunicator().baseUrl}${ServerCommunicator().messageInboxList}?page=1&page_size=10";
    }

    debugPrint("GET OWNER INBOX URL**********${url.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().messageInboxList}?page=1&page_size=10&show_previous_messages=${showPreviousMessages.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      log("GET INBOX RESPONSE *******${jsonEncode(value!.body)}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        inboxModel = UserInboxModel.fromJson(value.body);
        inboxList.value = inboxModel.data?.messageHeads ?? [];
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Delete USER messages
  Future apiDeleteUserMessages({String messageHeadId = ""}) async {
    debugPrint(
        "DELETE USER MSGS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().messageDelete}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "message_head_id": messageHeadId,
    };
    debugPrint("DELETE USER MSGS BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().messageDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE USER MSGS RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetInboxList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetInboxList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
