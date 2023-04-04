import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_list_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_status_list_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../../../utils/constants.dart';

class OrdersController extends GetxController {
  RxBool isActiveOrders = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString? role = "".obs;
  RxInt page = 1.obs;

  late OrderListResponse orderListResponse = OrderListResponse();
  late OrderStatusListResponse orderStatusListResponse =
      OrderStatusListResponse();
  RxList<OrderStatusList> orderStatusList = <OrderStatusList>[].obs;
  RxList<Order> orderList = <Order>[].obs;


  @override
  void onInit() {
    super.onInit();
    isActiveOrders.value = true;
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetOrderListApi(isActiveOrder: true);
      page.value = 1;
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetStoreOrderListApi(isActiveOrder: true);
      page.value = 1;
    }
    apiGetOrderStatusListApi();
    setupScrollController(Get.context);
  }

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          if (role!.value == Role.customerRoleText) {
            apiGetOrderListApi(isActiveOrder: true);
          } else {
            apiGetStoreOrderListApi();
          }
        }
      }
    });
  }

  //Get Order Status List Api
  Future apiGetOrderStatusListApi() async {
    isLoading.value = true;
    debugPrint("Order Status List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderStatusList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().orderStatusList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Order Status List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderStatusListResponse = OrderStatusListResponse.fromJson(value?.body);
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Order List Api
  Future apiGetOrderListApi(
      {bool isActiveOrder = true, int orderStatusId = 0}) async {
    isDataLoading.value = true;
    isLoading.value = orderList.isNotEmpty ? true : false;
    debugPrint("Order List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": null,
      "page": page.value,
      "page_size": 5,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": orderStatusId == 0 ? isActiveOrder : null,
      "order_statuses": orderStatusId != 0
          ? [
              {"order_status_id": orderStatusId, "as": "orders"}
            ]
          : []
    };

    debugPrint("data ********** ${jsonEncode(data)}");
    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}",
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Order List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderListResponse = OrderListResponse.fromJson(value?.body);
        List<Order>? orders = [];
        orders = orderListResponse.data!.orders?.orders ?? [];
        if (orders.isNotEmpty) {
          if (page.value == 1) {
            orderList.value = [];
          }
          orderList.addAll(orders);
        }
        orderList.toSet().toList();
        page.value++;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Store Order List Api
  Future apiGetStoreOrderListApi(
      {bool isActiveOrder = true, int orderStatusId = 0}) async {
    isLoading.value = true;
    isDataLoading.value = true;
    debugPrint("Order List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": null,
      "page": page.value,
      "page_size": 20,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "order_statuses": [
        {"order_status_id": 2},
        {"order_status_id": 3},
        {"order_status_id": 5}
      ]
    };

    debugPrint("data ********** ${jsonEncode(data)}");
    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Order  List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderListResponse = OrderListResponse.fromJson(value?.body);
        orderList.value = orderListResponse.data?.orders?.orders ?? [];
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
