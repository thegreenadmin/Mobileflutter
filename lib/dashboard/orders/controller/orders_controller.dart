import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/categories_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_list_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_status_list_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_store_order_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
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
  RxString orderStatus = "".obs;
  RxString storeId = "0".obs;
  RxInt page = 1.obs;
  RxInt activeStep = 0.obs;
  RxInt orderStatusId = 2.obs;
  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  late StoreOrderListResponse storeOrderListResponse = StoreOrderListResponse();
  late OrderListResponse orderListResponse = OrderListResponse();
  late OrderStatusListResponse orderStatusListResponse = OrderStatusListResponse();
  RxList<OrderStatusList> orderStatusList = <OrderStatusList>[].obs;
  RxList<Order> orderList = <Order>[].obs;
  RxList<StoreOrder> storeOrderList = <StoreOrder>[].obs;
  RxBool isFavouriteStore = false.obs;

  RxList<Categories> stepInd = [
    Categories(id: 0, name: "Received", isSelected: false),
    Categories(id: 1, name: "InProgress", isSelected: false),
    Categories(id: 2, name: "Ready to Pick", isSelected: false),
    Categories(id: 3, name: "Complete", isSelected: false),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    orderStatus.value =
        Get.arguments == null ? "" : Get.arguments["orderStatus"] ?? "";
    if( Get.arguments["storeId"] != null){
      storeId.value =  Get.arguments["storeId"] ?? "";
    }
    isActiveOrders.value = true;
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetOrderListApi();
      page.value = 1;
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetStoreOrderListApi();
      page.value = 1;
    }
    apiGetStoreDetailsApi();
    apiGetOrderStatusListApi();
    setupScrollController(Get.context);
  }

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          if (role!.value == Role.customerRoleText) {
            apiGetOrderListApi();
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
  Future apiGetOrderListApi() async {
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
      "only_active_orders":
          orderStatusId.value != 5 ? isActiveOrders.value : null,
      "order_statuses": orderStatusId.value == 5
          ? [
              {"order_status_id": orderStatusId.value, "as": "orders"}
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
        orders = orderListResponse.data!.orders ?? [];
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
  Future apiGetStoreOrderListApi() async {
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
      "page_size": 10,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": null,
      "order_statuses": [
        {"order_status_id": orderStatusId.value}
      ]
    };

    debugPrint("PARAMETERS ********** ${jsonEncode(data)}");
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
        storeOrderListResponse = StoreOrderListResponse.fromJson(value?.body);
        List<StoreOrder>? orders = [];
        orders = storeOrderListResponse.data!.orders ?? [];
        if (orders.isNotEmpty) {
          if (page.value == 1) {
            storeOrderList.value = [];
          }
          storeOrderList.addAll(orders);
        }
        storeOrderList.toSet().toList();
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

  //Get Store Details Api
  Future apiGetStoreDetailsApi() async {
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
      debugPrint("Store Details*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        debugPrint("isFavouriteStore before *******${isFavouriteStore.value}");
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

  //Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().removeFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = false;
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
