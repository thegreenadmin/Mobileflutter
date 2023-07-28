import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/more/controller/more_controller.dart';
import 'package:thegreenmall/dashboard/more/view/more_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/wallet_screen.dart';
import 'package:thegreenmall/main.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../dashboard/home/model/get_store_list_model.dart';
import '../utils/constants.dart';
import '../utils/global_share_data.dart';

class BottomNavController extends GetxController {
  final selectedIndex = 0.obs;
  final lastSelectedIndex = 0.obs;
  RxString roleInApp = "".obs;
  RxBool isLoading = false.obs;
  RxBool hasPermission = false.obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialRemoteMessage != null) {
        selectNotification(NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotificationAction,
          payload: json.encode(initialRemoteMessage!.data),
        ));
        initialRemoteMessage = null;
      }

      lastSelectedIndex.value = selectedIndex.value =
          Get.parameters["currentIndex"] != null
              ? int.parse(Get.parameters["currentIndex"].toString())
              : 0;
      Future.delayed(Duration.zero, () {
        getRole();
        if (permissionStoreList.isEmpty) {
          apiGetPermissions();
        }
      });
      onItemTapped(0);
    });
  }

  getRole() async {
    roleApp.value = await SharedPreferenceStorage.getData(Role.role);
    roleInApp.value = await SharedPreferenceStorage.getData(Role.role);
    if (roleInApp.value == Role.customerRoleText) {
      storeList.clear();
    } else {
      apiGetStoreList();
    }
  }

  ///Get Store List Api
  Future apiGetStoreList() async {
    isLoading.value = true;
    debugPrint(
        "GET BottomNav  STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().storeList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET BottomNav STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
        if (storeList.length == 1) {
          Get.parameters["storeId"] = storeList.first.storeId;
          Get.parameters["storeCount"] = storeList.length.toString();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///GET STORE PERMISSIONS
  Future apiGetPermissions() async {
    debugPrint(
        "GET STORE PERMISSIONS URL BOTTOM**********${ServerCommunicator().baseUrl}${ServerCommunicator().storePermissionsList}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl +
                ServerCommunicator().storePermissionsList,
            headers,
            showLoading: false)
        .then((value) async {
      log("GET STORE PERMISSIONS RESPONSE BOTTOM*******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getPermissionsModel = GetPermissionsModel.fromJson(value.body);
        permissionStoreList.value = getPermissionsModel.data!.stores!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  List<Widget> tabs = [
    const HomeScreen(),
    const WalletScreen(),
    const OrdersScreen(),
    const OffersScreen(),
    const MoreScreen(),
  ];

  onItemTapped(int index) {
    getRole();
    if (roleApp.value == Role.storeOwnerRoleText &&
        index == 2 &&
        (!hasStoreAccess.value ||
            permissionStoreList.isNotEmpty &&
                !permissionStoreList.any((element) =>
                    element.isStoreOwner == true ||
                    element.controllers!.any((ele) =>
                        ele.controllerKey ==
                        PermissionKey.manageOrders.statusName)))) {
      Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
    } else {
      selectedIndex.value = index;
    }

    Get.until((route) => route.isFirst, id: pageIdApp.value);
    SharedPreferenceStorage.removeData("pageId");
    if (selectedIndex.value == 0) {
      try {
        Future.delayed(Duration.zero, () {
          pageIdApp.value = 0;
          HomeController homeController = Get.put(HomeController());
          homeController.onInit();
        });
      } catch (e) {
        debugPrint("Bottom Nav  Home Error:-----------${e.toString()}");
      }
    } else if (selectedIndex.value == 1) {
      try {
        Future.delayed(Duration.zero, () {
          pageIdApp.value = 1;
          WalletController walletController = Get.put(WalletController());
          walletController.onInit();
        });
      } catch (e) {
        debugPrint("Bottom Nav  Wallet Error:-----------${e.toString()}");
      }
    } else if (selectedIndex.value == 2) {
      try {
        if (roleInApp.value == Role.customerRoleText) {
          storeList.clear();
        } else {
          apiGetStoreList();
        }

        Future.delayed(const Duration(milliseconds: 200), () {
          if (roleInApp.value == Role.storeOwnerRoleText) {
            if (storeList.length > 1 || storeList.isEmpty) {
              pageIdApp.value = 2;
            } else {
              pageIdApp.value = 3;
            }
          } else {
            pageIdApp.value = 4;
          }

          debugPrint("Bottom Nav  Page Id:-----------${pageIdApp.value}");
          debugPrint(
              "Bottom Nav  storeList.length:-----------${storeList.length}");
          OrdersController ordersController = Get.put(OrdersController());
          ordersController.onInit();
        });
      } catch (e) {
        debugPrint("Bottom Nav  Order Error:-----------${e.toString()}");
      }
    } else if (selectedIndex.value == 3) {
      try {
        Future.delayed(Duration.zero, () async {
          pageIdApp.value = 5;
          OffersController offersController = Get.put(OffersController());
          offersController.onInit();
        });
      } catch (e) {
        debugPrint("Bottom Nav  Offer Error:-----------${e.toString()}");
      }
    } else if (selectedIndex.value == 4) {
      try {
        Future.delayed(Duration.zero, () async {
          pageIdApp.value = 6;
          MoreController moreController = Get.put(MoreController());
          moreController.onInit();
        });
      } catch (e) {
        debugPrint("Bottom Nav  More Error:-----------${e.toString()}");
      }
    }
  }

  Widget get selectedTab =>
      selectedIndex.value == 0 ? const HomeScreen() : tabs[selectedIndex.value];
}
