import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/notification_list_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class NotificationListController extends GetxController {
  RxBool isLoading = false.obs;
  late NotificationListModel notificationListModel = NotificationListModel();
  RxList<Notifications> notificationList = <Notifications>[].obs;
  RxString? role = "".obs;

  final scrollController = ScrollController();
  RxInt page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetNotificationList(false);
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetNotificationList(true);
    }
  }

  //Get Notification List Api
  Future apiGetNotificationList(bool isForStore) async {
    isLoading.value = true;
    debugPrint("GET NOTIFICATION LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().notificationListUrl}?is_notification_for_store=$isForStore&page=1&page_size=20");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().notificationListUrl}?is_notification_for_store=$isForStore&page=1&page_size=20",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET NOTIFICATION LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        notificationListModel = NotificationListModel.fromJson(value.body);
        notificationList.value =
            notificationListModel.data?.notifications ?? [];

        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }
}
