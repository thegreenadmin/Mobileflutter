import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OwnerInboxController extends GetxController with GlobalVarMixin {
  RxBool isNotify = false.obs;
  RxBool isInboxSelected = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController messageTextController = TextEditingController();
  late OwnerInboxModel inboxModel = OwnerInboxModel();
  RxList<MessageHead> inboxList = <MessageHead>[].obs;
  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;
  RxBool showPreviousMessages = false.obs;
  final scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt pageId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getPage();
  }
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  getPage() async {
    firstName.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
    isInboxSelected.value = true;
    showPreviousMessages.value = false;
    await apiGetInboxList();
  }

  ///Get Inbox message heads List Api
  Future apiGetInboxList({showLoading = true}) async {
    //isLoading.value = true;
    RxString url = "".obs;
    if (showPreviousMessages.value) {
      url.value =
          "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageInbox}?page=1&page_size=10&show_previous_messages=${showPreviousMessages.value}";
    } else {
      url.value =
          "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageInbox}?page=1&page_size=10";
    }
    debugPrint("GET OWNER INBOX URL********** ${url.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(url.value, headers, showLoading: showLoading)
        .then((value) async {
      //isLoading.value = false;
      log("GET OWNER INBOX RESPONSE *******${jsonEncode(value?.body)}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        inboxModel = OwnerInboxModel.fromJson(value?.body);
        inboxList.value = inboxModel.data?.messageHeads ?? [];

        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Store messages
  Future apiDeleteStoreMessages(
      {String messageHeadId = "", String storeId = ""}) async {
    debugPrint(
        "DELETE STORE MSGS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageDelete}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map body = {"message_head_id": messageHeadId, "store_id": storeId};
    debugPrint("DELETE STORE MSGS BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE STORE MSGS RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        await apiGetInboxList();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);
        await apiGetInboxList();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
