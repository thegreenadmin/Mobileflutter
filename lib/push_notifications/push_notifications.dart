import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/push_notifications/model/realtime_notification_model.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_controller.dart';


  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {

    final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

    // Request permission for iOS devices
    await messaging.requestPermission();
    getNotification();
    getNotificationOpenedApp();
  }

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey(debugLabel: "Main Navigator");

   AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'thegreenmall_notifications', // id
    'thegreenmall_notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> notificationPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  getNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      if (notification != null) {
        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description!,
                  color: AppColors.primary,
                  icon: 'notification_icon',
                ),
              ),
              payload: json.encode(message.data));
        }
      }
    });
  }

  getNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      // getNotification();
      PushNotificationService pushNotificationService=PushNotificationService();
      pushNotificationService.selectNotification(NotificationResponse(
        notificationResponseType:
        NotificationResponseType.selectedNotificationAction,
        payload: json.encode(message.data),
      ));
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
    PushNotificationService pushNotificationService=PushNotificationService();
    pushNotificationService.selectNotification(NotificationResponse(
      notificationResponseType:
      NotificationResponseType.selectedNotificationAction,
      payload: json.encode(message?.data),
    ));
  }

  Future<RemoteMessage?> checkForInitialFirebaseMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    return initialMessage;
  }
class PushNotificationService  with GlobalVarMixin{

  static void handleNotification(NotificationResponse notificationResponse) {
    // Create an instance of NotificationService and call the instance method
    final notificationService = PushNotificationService();
    notificationService.selectNotification(notificationResponse);
  }
  void selectNotification(NotificationResponse notificationResponse) async {
    WidgetsFlutterBinding.ensureInitialized();


    Get.parameters["isController"] = "yes";
    RealTimeNotification notificationData = RealTimeNotification.fromJson(
        json.decode(notificationResponse.payload.toString()));

    //****************************  ORDER *************************************

    if (notificationData.type == StringConstants.orderText.toLowerCase() &&
        notificationData.senderType == StringConstants.storeText.toLowerCase()) {
      if (roleApp.value == Role.customerRoleText) {
        SharedPreferenceStorage.setData(Role.role, Role.storeOwnerRoleText);

        // roleApp(Role.storeOwnerRoleText);
        // roleApp.value = Role.storeOwnerRoleText;
        Get.parameters["orderId"] = "";
        Get.parameters[Role.role] = Role.storeOwnerRoleText;
      }
      Future.delayed(const Duration(milliseconds: 200), () async {
        Get.put(OrdersHomeMainController()).onInit();

        await Get.to(() =>  MarkOrderStatusScreen(
          orderId: notificationData.orderId.toString(),
          storeId: notificationData.storeId.toString(),
            isFromNotification:true
        ), id: pageIdApp.value);
      });
    } else if (notificationData.type == StringConstants.orderText.toLowerCase() &&
        notificationData.senderType == StringConstants.userText.toLowerCase()) {
      if (roleApp.value == Role.storeOwnerRoleText) {
        await SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
        // roleApp(Role.customerRoleText);
        // roleApp.value = Role.customerRoleText;
        // Get.parameters["orderId"] = "";
        // Get.parameters[Role.role] = Role.customerRoleText;
      }

      // Get.parameters["isFromTransaction"] = "false";
      // Get.parameters["storeId"] = notificationData.storeId.toString();
      // Get.parameters["orderId"] = notificationData.orderId.toString();
      // Get.parameters["isFromNotification"] = "true";

      Future.delayed(const Duration(milliseconds: 600), () async {});

      await  Get.to(() =>  OrdersScreen(
          orderId:
          roleApp.value == Role.storeOwnerRoleText?"":notificationData.orderId.toString(),
          isFromTransaction:false,
          isFromNotification: true,
          storeId:notificationData.storeId.toString()
      ), id: pageIdApp.value);

    }
    //******************  OFFER ********************

    else if (notificationData.type == "offer") {
      await Future.delayed(const Duration(milliseconds: 200));

      if (roleApp.value == Role.storeOwnerRoleText) {
        SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
        // roleApp(Role.customerRoleText);
        // roleApp.value = Role.customerRoleText;
        // Get.parameters["orderId"] = "";
        // Get.parameters[Role.role] = Role.customerRoleText;
      }
      // Get.parameters["isFromTransaction"] = "false";
      // Get.parameters["storeId"] = notificationData.storeId.toString();
      // Get.parameters["orderId"] = notificationData.orderId.toString();
      await Get.to(() => OffersScreen(orderId:
      roleApp.value == Role.storeOwnerRoleText?"":notificationData.orderId.toString(),
          isFromTransaction:false,
          storeId:notificationData.storeId.toString()
      ), id: pageIdApp.value,);


      //******************  MESSAGE  ********************
    } else if (notificationData.type ==
        StringConstants.messageText.toLowerCase() &&
        notificationData.senderType == StringConstants.userText.toLowerCase()) {
      if (roleApp.value == Role.customerRoleText) {
        SharedPreferenceStorage.setData(Role.role, Role.storeOwnerRoleText);
        // roleApp(Role.storeOwnerRoleText);
        // roleApp.value = Role.storeOwnerRoleText;
        Get.parameters["orderId"] = "";
        Get.parameters[Role.role] = Role.storeOwnerRoleText;
      }
      Future.delayed(const Duration(seconds: 2), () async {
        // Get.parameters["isFromTransaction"] = "false";
        // Get.parameters["storeId"] = notificationData.storeId.toString();
        // Get.parameters["messageHeadId"] =
        //     notificationData.messageHeadId.toString();
        await  Get.to(() =>  OwnerInboxDetailScreen(
          storeId: notificationData.storeId.toString(),
          messageHeadId: notificationData.messageHeadId.toString(),
        ), id: pageIdApp.value);
      });
    } else if (notificationData.type ==
        StringConstants.messageText.toLowerCase() &&
        notificationData.senderType == "store") {
      if (roleApp.value == Role.storeOwnerRoleText) {
        SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
        // roleApp(Role.customerRoleText);
        // roleApp.value = Role.customerRoleText;
        Get.parameters["orderId"] = "";
        Get.parameters[Role.role] = Role.customerRoleText;
      }
      Future.delayed(const Duration(seconds: 2), () async {
        // Get.parameters["isFromTransaction"] = "false";
        // Get.parameters["storeId"] = notificationData.storeId.toString();
        // Get.parameters["messageHeadId"] =
        //     notificationData.messageHeadId.toString();

        await Get.to(() =>  UserInboxDetailScreen(
          storeId: notificationData.storeId.toString() ??
              "",
          messageHeadId: notificationData.messageHeadId.toString() ??
              "",
        ), id: pageIdApp.value);
      });
    }
  }
}

