import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/more/controller/more_controller.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/main.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class BottomNavController extends GetxController with GlobalVarMixin{
  final selectedIndex = 0.obs;
  final lastSelectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool hasPermission = false.obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialRemoteMessage != null) {
        PushNotificationService.handleNotification(NotificationResponse(
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
      Future.delayed(Duration.zero, () async {
        // Skip initialization for guest users
        if (isGuest.value == true) {
          return;
        }
        getRole();
        apiGetPermissions();
      });
      onItemTapped(0);
    });
  }

  getRole() async {
    var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
    // Skip API call for guest users
    if (isGuest.value == true) {
      roleApp.value = Role.customerRoleText;
      storeList.clear();
      return;
    }
    // Only update roleApp if we got a valid non-empty role from SharedPrefs
    // Avoids overwriting the correctly-set global roleApp during a race condition
    if (roleData.isNotEmpty) {
      roleApp.value = roleData;
    }
    if ((roleData.isNotEmpty ? roleData : roleApp.value) == Role.customerRoleText) {
      storeList.clear();
    } else {
      isLoading.value = true;
      apiGetStoreList();
    }
  }

  ///Get Store List Api
  apiGetStoreList() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
          isLoading.value = true;
          Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}"
    };

          UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.storeList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
              if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value?.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
        if (storeList.length == 1) {
          Get.parameters["storeId"] = storeList.first.storeId;
          Get.parameters["storeCount"] = storeList.length.toString();
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///GET STORE PERMISSIONS
  Future apiGetPermissions() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
          Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}"
    };
          UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl +
                ServerCommunicator.storePermissionsList,
            headers,
            showLoading: false)
        .then((value) async {
              if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getPermissionsModel = GetPermissionsModel.fromJson(value?.body);
        permissionStoreList.value = getPermissionsModel.data!.stores!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        // Skip alert and redirect for guest users
        if (isGuest.value == true) {
          return;
        }
        Utility.showAlertMessage(value?.body['message']);
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }


  onItemTapped(int index) async {
    // Block account-restricted tabs (Wallet/Orders) for guest users
    // Allow guests to access More tab
    if (isGuest.value == true && (index == 1 || index == 2)) {
      GuestAccessModal.show(
        title: "Login Required",
        message: "Please login to access this feature",
        onContinueAsGuest: () {
          // Allow guest to continue - just close modal and stay on current tab
          // Don't navigate to the restricted tab
        },
      );
      return;
    }
    var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
    if (isGuest.value == true) {
      roleApp.value = Role.customerRoleText;
    } else if (roleData.isNotEmpty) {
      // Only update if non-empty to avoid overwriting during SharedPrefs write race condition
      roleApp.value = roleData;
    }
    Get.delete<StoreHomeMainController>();
    if (!isLoading.value) {
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
          Future.delayed(Duration.zero, () {
            pageIdApp.value = 0;
          });

      } else if (selectedIndex.value == 1) {
        Get.parameters["isController"] = "yes";

          Future.delayed(Duration.zero, () {
            pageIdApp.value = 1;
            Get.put(WalletController()).refreshWallet();
          });

      } else if (selectedIndex.value == 2) {
        Get.parameters["isController"] = "yes";
          if (roleApp.value == Role.customerRoleText) {
            pageIdApp.value = 4;
          } else {
            apiGetStoreList();
          }
          Future.delayed(const Duration(milliseconds: 100), () {
            if (roleApp.value == Role.storeOwnerRoleText) {
              if (storeList.length > 1 || storeList.isEmpty) {
                Get.put(OrdersController()).onInit();
                pageIdApp.value = 2;
              } else {
                Get.put(OrdersHomeMainController()).onInit();
                pageIdApp.value = 3;
              }
            } else {
              Get.put(OrdersController()).onInit();
              pageIdApp.value = 4;
            }
          });

      } else if (selectedIndex.value == 3) {
        Get.parameters["isController"] = "yes";
          Future.delayed(Duration.zero, () async {
            pageIdApp.value = 5;
            OffersController offersController = Get.put(OffersController());
            offersController.onInit();
          });

      } else if (selectedIndex.value == 4) {
        Get.parameters["isController"] = "yes";

          Future.delayed(Duration.zero, () async {
            pageIdApp.value = 6;
            Get.put(MoreController()).onInit();
          });

      }
    }
  }

  /*Widget get selectedTab =>
      selectedIndex.value == 0 ? const HomeScreen() : tabs[selectedIndex.value];*/
}
