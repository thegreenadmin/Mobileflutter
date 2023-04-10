import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/model/get_owner_order_history_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_store_order_detail_model.dart'
    as orderdetail;
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OrdersHomeMainController extends GetxController {
  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxInt selectedIndex = 0.obs;
  RxString storeId = "".obs;
  RxString orderId = "".obs;
  RxString customerName = "".obs;
  RxString orderDate = "".obs;
  RxString orderAmount = "".obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  GetOwnerOrderHistoryModel getOwnerOrderHistoryModel =
      GetOwnerOrderHistoryModel();
  RxList<Orders>? ownerOrderHistoryList = <Orders>[].obs;

  Rx<orderdetail.GetStoreOrderDetailModel> getStoreOrderDetailModel =
      orderdetail.GetStoreOrderDetailModel().obs;
  RxList<orderdetail.OrderItems> getOrderItems = <orderdetail.OrderItems>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 0;
    storeId.value = Get.arguments["storeId"] ?? "";
    apiGetStoreDetails();
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetOwnerOrderHistory();
    }
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    switch (i) {
      case 0: //Active Orders
        {
          debugPrint(selectedIndex.value.toString());
          apiGetOwnerOrderHistory();
        }
        break;
      case 1: //Inprogress Orders
        {
          debugPrint(selectedIndex.value.toString());
          apiGetOwnerOrderHistory();
        }
        break;
      case 2: //Pickup Orders
        {
          debugPrint(selectedIndex.value.toString());
          apiGetOwnerOrderHistory(orderStatus: {"order_status_id": "6"});
        }
        break;
      case 3: //Completed Orders
        {
          debugPrint(selectedIndex.value.toString());
          apiGetOwnerOrderHistory(orderStatus: {"order_status_id": "5"});
        }
        break;
      default:
        {
          debugPrint(selectedIndex.value.toString());
        }
        break;
    }
  }

  RxList horizontalTabList = [
    StringConstants.activeText,
    StringConstants.inProgress,
    StringConstants.pickupText,
    StringConstants.completedText,
  ].obs;

  //Get Store Details Api
  Future apiGetStoreDetails() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE DETAIL BODY*******${value?.body}");
      debugPrint("STORE DETAIL BODY*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Api get current and past history of [OWNER]
  Future apiGetOwnerOrderHistory(
      {String startDateOfMonth = "",
      String endDateOfMonth = "",
      orderStatus = Map<String, String>}) async {
    isLoading.value = true;
    debugPrint(
        "OWNER ORDER HISTORY URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map body = {
      "store_id": storeId.value,
      "page": null,
      "page_size": null,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": null,
      "order_statuses": selectedIndex.value == 0
          ? []
          : selectedIndex.value == 1
              ? [
                  {"order_status_id": "4"}, //"confirmed"
                  {"order_status_id": "6"}, //"shipped"
                  {"order_status_id": "9"}, //"pickup request"
                  {"order_status_id": "8"} //"cancel request"
                ]
              : [orderStatus]
    };
    debugPrint("OWNER ORDER HISTORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOrderList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER ORDER HISTORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOwnerOrderHistoryModel =
            GetOwnerOrderHistoryModel.fromJson(value.body);
        ownerOrderHistoryList!.value = getOwnerOrderHistoryModel.data!.orders!;
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Store Order Details Api
  Future apiGetStoreOrderDetail() async {
    isLoading.value = true;
    debugPrint("STORE ORDER DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDetail}?store_id=${storeId.value}&order_id=${orderId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDetail}?store_id=${storeId.value}&order_id=${orderId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE ORDER DETAIL RESPONSE **********${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStoreOrderDetailModel.value =
            orderdetail.GetStoreOrderDetailModel.fromJson(value.body);
        customerName.value =
            getStoreOrderDetailModel.value.data!.order!.customerName.toString();
        orderDate.value =
            //  getStoreOrderDetailModel.value.data!.order!.orderDate.toString();
            Utility.parseDateTime(
          DateTime.parse(
              getStoreOrderDetailModel.value.data!.order!.orderDate.toString()),
          secFormat: '',
        ).toString();
        print(" orderDate.value ------->" + orderDate.value.toString());
        orderAmount.value = getStoreOrderDetailModel
            .value.data!.order!.totalAmount
            .toStringAsFixed(2);
        orderId.value = getStoreOrderDetailModel.value.data!.order!.orderId!;
        storeId.value = getStoreOrderDetailModel.value.data!.order!.storeId!;
        getOrderItems.value =
            getStoreOrderDetailModel.value.data!.order!.orderItems!;
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Mark store order ready
  apiMarkOrderReady({String storeId = "", String orderId = ""}) async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER CONFIRM URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderConfirm}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {"store_id": storeId, "order_id": orderId};
    debugPrint("MARK ORDER CONFIRM BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeOrderConfirm,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER CONFIRM RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Mark store order ready for Pick
  apiMarkReadyForPick({String storeId = "", String orderId = ""}) async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER SHIPPED URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderShipped}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {"store_id": storeId, "order_id": orderId};
    debugPrint("MARK ORDER SHIPPED BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeOrderShipped,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER SHIPPED RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Mark store order delivered
  apiMarkDelivered({String storeId = "", String orderId = ""}) async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER COMPLETE URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDelivered}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {"store_id": storeId, "order_id": orderId};
    debugPrint("MARK ORDER COMPLETE BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeOrderDelivered,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER COMPLETE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
