import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart' as store;
import 'package:thegreenmall/dashboard/orders/model/orders_model.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_status_enum.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OrdersHomeMainController extends GetxController {
  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxBool preventCall = false.obs;
  RxString? firstName = "".obs;
  RxString? role = "".obs;
  RxString? lastName = "".obs;
  RxInt selectedIndex = 0.obs;
  RxInt pageId = 0.obs;
  RxInt totalCount = 0.obs;
  RxInt page = 1.obs;
  RxString storeId = "".obs;
  RxString orderStatusId = "".obs;
  RxString orderId = "".obs;
  RxString customerName = "".obs;
  RxString orderDate = "".obs;
  RxString orderAmount = "".obs;
  RxString storeCount = "0".obs;
  RxBool isFromNotification = false.obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  GetOwnerOrderHistoryModel getOwnerOrderHistoryModel =
      GetOwnerOrderHistoryModel();
  RxList<Orders>? ownerOrderHistoryList = <Orders>[].obs;

  Rx<GetStoreOrderDetailModel> getStoreOrderDetailModel =
      GetStoreOrderDetailModel().obs;
  RxList<OrderItem> getOrderItems = <OrderItem>[].obs;
  RxList<OrderHistories> orderHistories = <OrderHistories>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          "OrdersHomeMainController orderId ======onInit =======${Get.parameters["orderId"]} ${Get.parameters["storeId"]} ${Get.parameters["isFromNotification"]}");
      if (Get.parameters["isController"] != "no") {
        // selectedIndex.value = 0;
        isFromNotification.value =
            Get.parameters["isFromNotification"] == "true" ? true : false;

        if (Get.parameters["storeId"] != "" &&
            Get.parameters["storeId"] != null) {
          storeId.value = Get.parameters["storeId"] ?? "";
        }
        if (Get.parameters["orderId"] != "" &&
            Get.parameters["orderId"] != null) {
          debugPrint(
              "OrdersHomeMainController orderId =============${Get.parameters["orderId"]}");
          orderId.value = Get.parameters["orderId"] ?? "";
          apiGetStoreOrderDetail();
        }
        if (Get.parameters["storeCount"] != "" &&
            Get.parameters["storeCount"] != null) {
          storeCount.value = Get.parameters["storeCount"] ?? "";
        }

        apiGetStoreDetails();
        setupScrollController();
        role!.value = Role.storeOwnerRoleText;
        apiGetOwnerOrderHistory();
        getPage();
      }
    });
  }

  final scrollController = ScrollController();
  setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        getOwnerOrderHistoryModel = GetOwnerOrderHistoryModel();
        if (ownerOrderHistoryList!.length < totalCount.value) {
          page.value++;
          apiGetOwnerOrderHistory().then((_) => preventCall.value = false);
          preventCall.value = true;
        }
      }
    });
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void onIndexChange(int i) async {
    page.value = 1;
    selectedIndex.value = i;
    switch (i) {
      case 0: //Active Orders
        {
          debugPrint(selectedIndex.value.toString());
          await apiGetOwnerOrderHistory();
        }
        break;
      case 1: //In-progress Orders
        {
          debugPrint(selectedIndex.value.toString());
          await apiGetOwnerOrderHistory();
        }
        break;
      case 2: //Pickup Orders
        {
          debugPrint(selectedIndex.value.toString());
          await apiGetOwnerOrderHistory();
        }
        break;
      case 3: //Completed Orders
        {
          debugPrint(selectedIndex.value.toString());
          await apiGetOwnerOrderHistory();
        }
        break;
      default:
        {
          debugPrint(selectedIndex.value.toString());
          await apiGetOwnerOrderHistory();
        }
        break;
    }
  }

  RxList horizontalTabList = [
    StringConstants.receivedText,
    StringConstants.inProgress,
    StringConstants.pickupText,
    StringConstants.completedText,
  ].obs;

  ///Get Store Details Api
  Future apiGetStoreDetails() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE DETAIL BODY*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api get current and past history of [OWNER]
  Future apiGetOwnerOrderHistory(
      {String startDateOfMonth = "",
      String endDateOfMonth = "",
      orderStatus = Map<String, String>}) async {
    isLoading.value = true;
    if (page.value == 1) {
      ownerOrderHistoryList!.value = [];
    }
    debugPrint(
        "OWNER ORDER HISTORY URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map body = {
      "store_id": storeId.value,
      "page": page.value,
      "page_size": 5,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": selectedIndex.value == 0 ? true : null,
      "order_statuses": selectedIndex.value == 1
          ? [
              {
                "order_status_name": OrderStatusEnum.inProgress.statusName
              }, //"confirmed"
            ]
          : selectedIndex.value == 2
              ? [
                  {
                    "order_status_name": OrderStatusEnum.inTransit.statusName
                  }, // inTransit
                  {
                    "order_status_name":
                        OrderStatusEnum.readyForPickup.statusName
                  }, // ready pickup
                ]
              : selectedIndex.value == 3
                  ? [
                      {
                        "order_status_name":
                            OrderStatusEnum.completed.statusName
                      }, // completed
                      {
                        "order_status_name":
                            OrderStatusEnum.cancelled.statusName
                      }, // cancelled
                      {
                        "order_status_name":
                            OrderStatusEnum.returnCancelled.statusName
                      }, // return Cancelled
                      {
                        "order_status_name": OrderStatusEnum.returned.statusName
                      }, // return Completed
                      {
                        "order_status_name":
                            OrderStatusEnum.cancelRequest.statusName
                      }, // cancel Request
                    ]
                  : [
                      {
                        "order_status_name":
                            OrderStatusEnum.receivedOrder.statusName
                      }, // received
                      {
                        "order_status_name":
                            OrderStatusEnum.returnRequest.statusName
                      }, // return Request
                    ]
    };
    debugPrint("OWNER ORDER HISTORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOrderList,
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER ORDER HISTORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOwnerOrderHistoryModel =
            GetOwnerOrderHistoryModel.fromJson(value.body);
        totalCount.value = getOwnerOrderHistoryModel.data!.totalCount!;
        List<Orders>? orders = [];
        orders = getOwnerOrderHistoryModel.data!.orders ?? [];
        if (orders.isNotEmpty) {
          if (page.value == 1) {
            ownerOrderHistoryList!.value = [];
          }
          ownerOrderHistoryList!.addAll(orders);
        }
        ownerOrderHistoryList!.toSet().toList();

        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Store Order Details Api
  Future apiGetStoreOrderDetail() async {
    isLoading.value = true;
    debugPrint("STORE ORDER DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDetail}?store_id=${storeId.value}&order_id=${orderId.value}");
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDetail}?store_id=${storeId.value}&order_id=${orderId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      log("STORE ORDER DETAIL RESPONSE **********${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Future.delayed(Duration.zero, () {
          getStoreOrderDetailModel.value =
              GetStoreOrderDetailModel.fromJson(value?.body);
          log("STORE ORDER DETAIL RESPONSE customerName**********${getStoreOrderDetailModel.value.data!.order!.customerName.toString()}");
          customerName.value =
              getStoreOrderDetailModel.value.data?.order?.customerName ?? "";
          orderDate.value = Utility.parseDateTime(
            DateTime.parse(getStoreOrderDetailModel.value.data!.order!.orderDate
                .toString()),
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
          orderHistories.value =
              getStoreOrderDetailModel.value.data!.order!.orderHistories!;
          getOrderItems.value =
              getStoreOrderDetailModel.value.data!.order!.orderItems!;
          log("STORE ORDER DETAIL RESPONSE customerName**********"
              "${customerName.value}*${orderAmount.value}*${orderStatusId.value}*${orderDate.value}");

          for (var element in getOrderItems) {
            element.isSelected = selectedIndex.value == 0 &&
                    element.orderItemStatus ==
                        OrderStatusEnum.receivedOrder.statusName
                ? false
                : selectedIndex.value == 1 &&
                            element.orderItemStatus ==
                                OrderStatusEnum.inProgress.statusName ||
                        selectedIndex.value == 1 &&
                            element.orderItemStatus ==
                                OrderStatusEnum.receivedOrder.statusName
                    ? false
                    : selectedIndex.value == 2 &&
                                element.orderItemStatus !=
                                    OrderStatusEnum.inTransit.statusName ||
                            selectedIndex.value == 2 &&
                                element.orderItemStatus !=
                                    OrderStatusEnum.readyForPickup.statusName
                        ? false
                        : element.orderItemStatus ==
                                OrderStatusEnum.cancelled.statusName
                            ? false
                            : true;
          }
        });
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Confirm Return Request
  Future apiConfirmReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER CONFIRM URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeConfirmReturnOrder}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Complete Return Request
  Future apiCompleteReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER COMPLETE URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCompleteReturnOrder}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true &&
          element.orderItemStatus == OrderStatusEnum.returnRequest.statusName) {
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Reject Return Request
  Future apiRejectReturnRequest() async {
    isLoading.value = true;
    debugPrint(
        "RETURN ORDER REJECT URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeRejectReturnOrder}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Cancel order ready
  Future apiCancelOrder() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER CANCEL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCancelOrder}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
        page.value == 1;
        Get.back(id: pageIdApp.value);

        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Mark store order ready
  Future apiMarkOrderReady() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER CONFIRM URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderConfirm}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true &&
          element.orderItemStatus == OrderStatusEnum.receivedOrder.statusName) {
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Mark store order ready for Shipped
  Future apiMarkReadyForShipping() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER SHIPPED URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderShipped}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true &&
              element.orderItemStatus ==
                  OrderStatusEnum.receivedOrder.statusName ||
          element.isSelected == true &&
              element.orderItemStatus ==
                  OrderStatusEnum.inProgress.statusName) {
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Mark store order ready for Pick
  Future apiMarkReadyForPickUp() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER PICKUP URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderPickUp}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];
    for (var element in getOrderItems) {
      if (element.isSelected == true &&
              element.orderItemStatus ==
                  OrderStatusEnum.receivedOrder.statusName ||
          element.isSelected == true &&
              element.orderItemStatus ==
                  OrderStatusEnum.inProgress.statusName) {
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Mark store order delivered
  Future apiMarkDelivered() async {
    isLoading.value = true;
    debugPrint(
        "MARK ORDER COMPLETE URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderDelivered}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];

    for (var element in getOrderItems) {
      if (element.isSelected == true &&
              element.orderItemStatus == OrderStatusEnum.inTransit.statusName ||
          element.isSelected == true &&
              element.orderItemStatus ==
                  OrderStatusEnum.readyForPickup.statusName) {
        orderItems
            .add({"order_item_id": int.parse(element.orderItemId ?? "0")});
      }
    }
    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
      "order_items": orderItems
    };
    debugPrint("MARK ORDER COMPLETE BODY ********** $body");
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
        page.value == 1;
        await apiGetOwnerOrderHistory();
        Get.back(id: pageIdApp.value);
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
