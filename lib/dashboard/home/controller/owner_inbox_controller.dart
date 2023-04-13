import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/owner_inbox_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_inbox_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OwnerInboxController extends GetxController {
  RxBool isNotify = false.obs;
  RxBool isInboxSelected = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController messageTextController = TextEditingController();
  late OwnerInboxModel inboxModel = OwnerInboxModel();
  RxList<MessageHead> inboxList = <MessageHead>[].obs;
  RxString? role = "".obs;
  RxBool showPreviousMessages = false.obs;
  final scrollController = ScrollController();
  RxInt page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    isInboxSelected.value = true;
    showPreviousMessages.value = false;
    apiGetInboxList();
  }

  //Get Inbox message heads List Api
  Future apiGetInboxList() async {
    isLoading.value = true;
    debugPrint("GET OWNER INBOX URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageInbox}?page=1&page_size=10&show_previous_messages=${showPreviousMessages.value}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageInbox}?page=1&page_size=10&show_previous_messages=${showPreviousMessages.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET OWNER INBOX RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        inboxModel = OwnerInboxModel.fromJson(value.body);
        inboxList.value = inboxModel.data?.messageHeads ?? [];

        update();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Delete Store messages
  Future apiDeleteStoreMessages(
      {String messageHeadId = "", String storeId = ""}) async {
    debugPrint(
        "DELETE STORE MSGS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
      debugPrint("DELETE STORE MSGS RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetInboxList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
        await apiGetInboxList();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
