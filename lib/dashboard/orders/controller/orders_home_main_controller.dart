import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/model/get_owner_order_history_model.dart'
    as owner_order_history;
import 'package:thegreenmall/dashboard/orders/view/component/order_status_enum.dart';
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
  RxString orderStatusId = "".obs;
  RxString orderId = "".obs;
  RxString customerName = "".obs;
  RxString orderDate = "".obs;
  RxString orderAmount = "".obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  owner_order_history.GetOwnerOrderHistoryModel getOwnerOrderHistoryModel =
      owner_order_history.GetOwnerOrderHistoryModel();
  RxList<owner_order_history.Orders>? ownerOrderHistoryList =
      <owner_order_history.Orders>[].obs;

  Rx<orderdetail.GetStoreOrderDetailModel> getStoreOrderDetailModel =
      orderdetail.GetStoreOrderDetailModel().obs;
  RxList<orderdetail.OrderItems> getOrderItems = <orderdetail.OrderItems>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 0;
    orderId.value = Get.arguments == null ? "" : Get.arguments["orderId"] ?? "";
    storeId.value = Get.arguments["storeId"] ?? "";
    apiGetStoreDetails();
    role!.value = Role.storeOwnerRoleText;
    apiGetOwnerOrderHistory();
    apiGetStoreOrderDetail();
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
          apiGetOwnerOrderHistory();
        }
        break;
      case 3: //Completed Orders
        {
          debugPrint(selectedIndex.value.toString());
          apiGetOwnerOrderHistory(orderStatus: {
            "order_status_name": OrderStatus.delivered.statusName
          });
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
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
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
                  {
                    "order_status_name": OrderStatus.confirmed.statusName
                  }, //"confirmed"
                  {
                    "order_status_name": OrderStatus.shipped.statusName
                  }, //"shipped"
                  {
                    "order_status_name": OrderStatus.pickupRequest.statusName
                  }, //"pickup request"
                  {
                    "order_status_name": OrderStatus.cancelRequest.statusName
                  } //"cancel request"
                ]
              : selectedIndex.value == 2
                  ? [
                      {
                        "order_status_name": OrderStatus.shipped.statusName
                      }, //"shipped"
                      {
                        "order_status_name": OrderStatus.readyPickup.statusName
                      } //ready pickup
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
            owner_order_history.GetOwnerOrderHistoryModel.fromJson(value.body);
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
      log("STORE ORDER DETAIL RESPONSE **********${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStoreOrderDetailModel.value =
            orderdetail.GetStoreOrderDetailModel.fromJson(value.body);
        customerName.value =
            getStoreOrderDetailModel.value.data!.order!.customerName.toString();
        orderDate.value = Utility.parseDateTime(
          DateTime.parse(
              getStoreOrderDetailModel.value.data!.order!.orderDate.toString()),
          secFormat: '',
        ).toString();

        orderAmount.value = getStoreOrderDetailModel
            .value.data!.order!.totalAmount
            .toStringAsFixed(2);
        orderId.value = getStoreOrderDetailModel.value.data!.order!.orderId!;
        storeId.value = getStoreOrderDetailModel.value.data!.order!.storeId!;
        orderStatusId.value = getStoreOrderDetailModel
                .value.data?.order?.orderHistories?.last.orderStatusId ??
            "0";
        getOrderItems.value =
            getStoreOrderDetailModel.value.data!.order!.orderItems!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Confirm Return Request
  apiConfirmReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER CONFIRM URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeConfirmReturnOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      orderItems.add({"order_item_id": int.parse(element.orderItemId ?? "0")});
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };

    debugPrint("RETURN ORDER CONFIRM BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeConfirmReturnOrder,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER CONFIRM RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Get.back();
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Complete Return Request
  apiCompleteReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER COMPLETE URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCompleteReturnOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };

    debugPrint("RETURN ORDER COMPLETE BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeCompleteReturnOrder,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER COMPLETE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        Get.back();
        update();
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

//Reject Return Request
  apiRejectReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER REJECT URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRejectReturnOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
    };

    debugPrint("RETURN ORDER REJECT BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeRejectReturnOrder,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER REJECT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Get.back();
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Cancel order ready
  apiCancelOrder() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER CANCEL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCancelOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };

    debugPrint("MARK ORDER CANCEL BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeCancelOrder,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER CANCEL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        Get.back();
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Mark store order ready
  apiMarkOrderReady() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER CONFIRM URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderConfirm}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };

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
        Utility.showToast(value.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Mark store order ready for Shipped
  apiMarkReadyForShipping() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER SHIPPED URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderShipped}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };
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
        Utility.showToast(value.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Mark store order ready for Pick
  apiMarkReadyForPickUp() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER PICKUP URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderPickUp}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };
    debugPrint("MARK ORDER PICKUP BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeOrderPickUp,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MARK ORDER PICKUP RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Mark store order delivered
  apiMarkDelivered() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER COMPLETE URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDelivered}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };
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
        Utility.showToast(value.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
