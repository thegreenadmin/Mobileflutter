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
import 'package:thegreenmall/push_notifications/push_notifications.dart';

class BottomNavController extends GetxController {
  final selectedIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    if (initialRemoteMessage != null) {
      debugPrint("initMessageReceived");
      // selectNotification(json.encode(initialRemoteMessage?.data));
      selectNotification(NotificationResponse(
        notificationResponseType:
            NotificationResponseType.selectedNotificationAction,
        payload: json.encode(initialRemoteMessage!.data),
      ));
      initialRemoteMessage = null;
    }
    selectedIndex.value = Get.arguments!=null ?Get.arguments["currentIndex"]??0: 0;
  }

  List<Widget> tabs = [
    const HomeScreen(),
    const WalletScreen(),
    const OrdersScreen(),
    const OffersScreen(),
    const MoreScreen(),
  ];

  onItemTapped(int index) {
    // print(index);
    selectedIndex.value = index;
    if (selectedIndex.value == 0) {
      // print(index);
      try {
        HomeController controller = Get.find<HomeController>();
        controller.onInit();
      } catch (e) {
        //Pass
      }
    } else if (selectedIndex.value == 1) {
      try {
        WalletController controller = Get.find<WalletController>();
        controller.onInit();
      } catch (e) {
        print("11" + index.toString());
        //Pass
      }
    } else if (selectedIndex.value == 2) {
      // print(index);
      try {
        OrdersController controller = Get.find<OrdersController>();
        controller.onInit();
      } catch (e) {
        //Pass
      }
    } else if (selectedIndex.value == 3) {
      //  print(index);
      try {
        OffersController controller = Get.find<OffersController>();
        controller.onInit();
      } catch (e) {
        //Pass
      }
    } else if (selectedIndex.value == 4) {
      print(index);
      try {
        MoreController controller = Get.find<MoreController>();
        controller.onInit();
      } catch (e) {
        //Pass
      }
    }
  }

  Widget get selectedTab =>
      selectedIndex.value == 0 ? const HomeScreen() : tabs[selectedIndex.value];
}
