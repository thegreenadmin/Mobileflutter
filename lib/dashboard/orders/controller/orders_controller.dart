import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_list_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OrdersController extends GetxController {
  RxBool isActiveOrders = false.obs;
  RxBool isLoading = false.obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;

  late OrderListResponse orderListResponse = OrderListResponse();
  RxList<OrderList> orderList = <OrderList>[].obs;

  RxList orderListData = [
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store",
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store"
  ].obs;

  @override
  void onInit() {
    super.onInit();
    apiGetOrderListApi();
  }

  //Get Order List Api
  Future apiGetOrderListApi() async {
    isLoading.value = true;
    debugPrint("Order List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Authorization':
      "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}",
        headers,
        showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Order List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        orderListResponse = OrderListResponse.fromJson(value?.body);
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

}
