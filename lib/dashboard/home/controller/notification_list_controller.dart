import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/model/notification_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class NotificationListController extends GetxController with GlobalVarMixin {
  RxBool isLoading = false.obs;
  late NotificationListModel notificationListModel = NotificationListModel();
  RxList<Notifications> notificationList = <Notifications>[].obs;
  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;
  RxInt pageId = 0.obs;
  final scrollController = ScrollController();
  RxInt page = 1.obs;

  @override
  void onInit() {
    super.onInit();

    getPage();
  }
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";
    role?.value = roleApp.value;
    if (role?.value == Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetNotificationList(false);
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetNotificationList(true);
    }
  }

  ///Get Notification List Api
  Future apiGetNotificationList(bool isForStore) async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.notificationListUrl}?is_notification_for_store=$isForStore&page=1&page_size=1000",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        notificationListModel = NotificationListModel.fromJson(value?.body);
        notificationList.value =
            notificationListModel.data?.notifications ?? [];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
