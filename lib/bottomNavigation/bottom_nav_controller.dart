import 'dart:convert';
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

class BottomNavController extends GetxController {
  final selectedIndex = 0.obs;
  RxString roleInApp = "".obs;
  RxBool isLoading = false.obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  @override
  void onReady() {
    super.onReady();
    if (initialRemoteMessage != null) {
      selectNotification(NotificationResponse(
        notificationResponseType:
            NotificationResponseType.selectedNotificationAction,
        payload: json.encode(initialRemoteMessage!.data),
      ));
      initialRemoteMessage = null;
    }
    selectedIndex.value = Get.parameters["currentIndex"] != null
        ? int.parse(Get.parameters["currentIndex"].toString())
        : 0;

    getRole();
  }

  getRole() async {
    SharedPreferenceStorage.setData("pageId", 0);
    roleInApp.value = await SharedPreferenceStorage.getData(Role.role.value);
  }

  //Get Store List Api
  Future apiGetStoreList() async {
    isLoading.value = true;
    debugPrint(
        "GET BottomNav  STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider().getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().storeList,
            headers, showLoading: false).then((value) async {
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
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
  HomeController homeController = Get.put(HomeController());
  WalletController walletController = Get.put(WalletController());
  OrdersController ordersController = Get.put(OrdersController());
  OffersController offersController = Get.put(OffersController());
  MoreController moreController = Get.put(MoreController());


  late int getCurrentNavKey;

  List<Widget> tabs = [
    const HomeScreen(),
    const WalletScreen(),
    const OrdersScreen(),
    const OffersScreen(),
    const MoreScreen(),
  ];

  onItemTapped(int index) async {

    roleInApp.value = await SharedPreferenceStorage.getData(Role.role.value);
    selectedIndex.value = index;
    SharedPreferenceStorage.setData("pageId", index);
    Get.until((route) => route.isFirst,id:selectedIndex.value);
    if (selectedIndex.value == 0) {
      try {
        HomeController controller = Get.put(HomeController());
        controller.onInit();
        // HomeController controller = Get.put(HomeController());
        Get.delete<WalletController>();
        Get.delete<OrdersController>();
        Get.delete<OffersController>();
        Get.delete<MoreController>();
        homeController.onInit();

      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 1) {
      try {
        WalletController controller = Get.put(WalletController());
        // controller.onInit();
        Get.delete<HomeController>();
        Get.delete<OrdersController>();
        Get.delete<OffersController>();
        Get.delete<MoreController>();
        walletController.onInit();

      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 2) {
      try {
        if (roleInApp.value == Role.customerRoleText) {
          storeList.clear();
        } else {
          await apiGetStoreList();
        }
        OrdersController controller = Get.put(OrdersController());
        // controller.onInit();

        Get.delete<HomeController>();
        Get.delete<WalletController>();
        Get.delete<OffersController>();
        Get.delete<MoreController>();
        ordersController.onInit();
      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 3) {
      try {
        OffersController controller = Get.put(OffersController());
        Get.delete<HomeController>();
        Get.delete<WalletController>();
        Get.delete<OrdersController>();
        Get.delete<MoreController>();
        offersController.onInit();
        // controller.onInit();
      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 4) {
      try {
        MoreController controller = Get.put(MoreController());
        Get.delete<HomeController>();
        Get.delete<WalletController>();
        Get.delete<OrdersController>();
        Get.delete<OffersController>();
        moreController.onInit();
        // controller.onInit();
      } catch (e) {
        //Pass
      }
    }
  }

  Widget get selectedTab =>
      selectedIndex.value == 0 ? const HomeScreen() : tabs[selectedIndex.value];
}
