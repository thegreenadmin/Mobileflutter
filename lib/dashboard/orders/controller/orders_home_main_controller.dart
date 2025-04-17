import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart' as store;
import 'package:thegreenmall/dashboard/orders/model/orders_model.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_status_enum.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OrdersHomeMainController extends GetxController with GlobalVarMixin{
  SharedPreferenceStorage storage = SharedPreferenceStorage();

  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxBool isDataLoading = true.obs;
  RxBool preventCall = false.obs;
  RxString? firstName = "".obs;
  RxString? role = "".obs;
  RxString? lastName = "".obs;
  RxInt selectedIndex = 0.obs;
  RxInt pageId = 0.obs;
  RxInt totalCount = 0.obs;
  RxInt page = 1.obs;
  RxInt count = 0.obs;
  RxString storeId = "".obs;
  RxString orderStatusId = "".obs;
  RxString orderId = "".obs;
  RxString customerName = "".obs;
  RxString orderDate = "".obs;
  RxString orderAmount = "".obs;
  RxString storeLocation = "".obs;
  RxString storeCount = "0".obs;
  RxBool isFromNotification = false.obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse = store.StoreDetailsResponse().obs;
  GetOwnerOrderHistoryModel getOwnerOrderHistoryModel = GetOwnerOrderHistoryModel();
  RxList<Orders>? ownerOrderHistoryList = <Orders>[].obs;

  Rx<GetStoreOrderDetailModel> getStoreOrderDetailModel = GetStoreOrderDetailModel().obs;
  RxList<OrderItem> getOrderItems = <OrderItem>[].obs;
  RxList<OrderHistories> orderHistories = <OrderHistories>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
      role!.value = roleData;

      if (Get.parameters["isController"] != "no") {
        isFromNotification.value = Get.parameters["isFromNotification"] == "true" ? true : false;

        if (Get.parameters["storeId"] != "" && Get.parameters["storeId"] != null) {
          storeId.value = Get.parameters["storeId"] ?? "";
        }
        if (Get.parameters["orderId"] != "" && Get.parameters["orderId"] != null) {

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
                                await apiGetOwnerOrderHistory();
        }
        break;
      case 1: //In-progress Orders
        {
                                await apiGetOwnerOrderHistory();
        }
        break;
      case 2: //Pickup Orders
        {
                                await apiGetOwnerOrderHistory();
        }
        break;
      case 3: //Completed Orders
        {
                                await apiGetOwnerOrderHistory();
        }
        break;
      default:
        {
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
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreDetails}?store_id=${storeId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
        storeLocation.value =
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.addressLine1 ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.city ?? ""},"
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.stateName ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.country?.countryName ?? ""}";
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
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

  ///Api get current and past history of [OWNER]
  Future apiGetOwnerOrderHistory(
      {String startDateOfMonth = "",
      String endDateOfMonth = "",
      orderStatus = Map<String, String>}) async {

    if (page.value == 1) {
      isLoading.value = true;
      ownerOrderHistoryList!.value = [];
    }
      if (page.value > 1) {
        isDataLoading.value =true;
    }

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
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl + ServerCommunicator.storeOrderList,
            headers,
            showLoading: false)
        .then((value) async {

      isLoading.value = false;
      isDataLoading.value = false;

              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getOwnerOrderHistoryModel =
            GetOwnerOrderHistoryModel.fromJson(value?.body);
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
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Store Order Details Api
  Future apiGetStoreOrderDetail() async {
    isLoading.value = true;
         Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeOrderDetail}?store_id=${storeId.value}&order_id=${orderId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Future.delayed(Duration.zero, () {
          getStoreOrderDetailModel.value =
              GetStoreOrderDetailModel.fromJson(value?.body);
                      customerName.value =
              getStoreOrderDetailModel.value.data?.order?.customerName ?? "";
          orderDate.value = Utility.parseDateTime(
            DateTime.parse(getStoreOrderDetailModel.value.data!.order!.orderDate
                .toString()),
            secFormat: '',
          ).toString();
          // orderAmount.value = getStoreOrderDetailModel
          //     .value.data!.order!.totalAmount
          //     .toStringAsFixed(2);

          orderId.value = getStoreOrderDetailModel.value.data!.order!.orderId!;
          storeId.value = getStoreOrderDetailModel.value.data!.order!.storeId!;
          orderStatusId.value = getStoreOrderDetailModel
                  .value.data?.order?.orderHistories?.last.orderStatusId ??
              "0";
          orderHistories.value =
              getStoreOrderDetailModel.value.data!.order!.orderHistories!;
          getOrderItems.value =
              getStoreOrderDetailModel.value.data!.order!.orderItems!;
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

  ///Confirm Return Request
  Future apiConfirmReturnRequest() async {
    isLoading.value = true;
     
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

              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeConfirmReturnOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
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

  ///Complete Return Request
  Future apiCompleteReturnRequest() async {
    isLoading.value = true;
     
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

          
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeCompleteReturnOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
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
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map body = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderId.value),
    };

              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeRejectReturnOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
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

  ///Cancel order ready
  Future apiCancelOrder() async {
    isLoading.value = true;
     
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

              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeCancelOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        for (var element in getOrderItems) {
          element.isSelected = false;
        }
        page.value == 1;
        Get.back(id: pageIdApp.value);

        update();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Mark store order ready
  Future apiMarkOrderReady() async {
    isLoading.value = true;
     
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

              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeOrderConfirm,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
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

  ///Mark store order ready for Shipped
  Future apiMarkReadyForShipping() async {
    isLoading.value = true;
     
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
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeOrderShipped,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
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

  ///Mark store order ready for Pick
  Future apiMarkReadyForPickUp() async {
    isLoading.value = true;
     
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
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeOrderPickUp,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
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

  ///Mark store order delivered
  Future apiMarkDelivered() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<dynamic> orderItems = [];

    for (var element in getOrderItems) {
                                  if (element.isSelected == true &&
          element.orderItemStatus == OrderStatusEnum.receivedOrder.statusName ||element.isSelected == true &&
          element.orderItemStatus == OrderStatusEnum.inProgress.statusName || element.isSelected == true &&
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
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeOrderDelivered,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
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
}
