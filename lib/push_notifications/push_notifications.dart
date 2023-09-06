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

FirebaseMessaging messaging = FirebaseMessaging.instance;
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'thegreenmall_notifications', // id
  'thegreenmall_notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

notificationPermission() async {
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
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }
}

getNotification() {
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    RemoteNotification? notification = message!.notification;
    debugPrint("notification data---------------${message.data}");
    //AndroidNotification android = message.notification.android?.;
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
    debugPrint("getNotificationOpenedApp data---${message!.data}");
    // getNotification();
    selectNotification(NotificationResponse(
      notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
      payload: json.encode(message.data),
    ));
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  debugPrint("firebaseMessagingBackgroundHandler data---${message!.data}");
  // getNotification();
  //await Firebase.initializeApp();
  selectNotification(NotificationResponse(
    notificationResponseType:
        NotificationResponseType.selectedNotificationAction,
    payload: json.encode(message.data),
  ));
}

Future<RemoteMessage?> checkForInitialFirebaseMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  return initialMessage;
}

void selectNotification(NotificationResponse notificationResponse) async {
  debugPrint("payload 2---------->${notificationResponse.payload}");
  RealTimeNotification notificationData = RealTimeNotification.fromJson(
      json.decode(notificationResponse.payload.toString()));
  // SharedPreferenceStorage.setData("context", Get.context!);

  //******************  ORDER ********************

  if (notificationData.type == StringConstants.orderText.toLowerCase() &&
      notificationData.senderType == StringConstants.storeText.toLowerCase()) {
    if (roleApp.value == Role.customerRoleText) {
      SharedPreferenceStorage.setData(Role.role, Role.storeOwnerRoleText);
      roleApp.value = Role.storeOwnerRoleText;
      Get.parameters["orderId"] = "";
      Get.parameters[Role.role] = Role.storeOwnerRoleText;
    }
    Future.delayed(const Duration(milliseconds: 600), () async {
      Get.parameters["isFromTransaction"] = "false";
      Get.parameters["storeId"] = notificationData.storeId.toString();
      Get.parameters["orderId"] = notificationData.orderId.toString();
      Get.parameters["isFromNotification"] = "true";
      Get.put(OrdersHomeMainController()).onInit();
      Get.to(() => const MarkOrderStatusScreen(), id: pageIdApp.value);
    });
  } else if (notificationData.type == StringConstants.orderText.toLowerCase() &&
      notificationData.senderType == StringConstants.userText.toLowerCase()) {
    if (roleApp.value == Role.storeOwnerRoleText) {
      SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
      roleApp.value = Role.customerRoleText;
      Get.parameters["orderId"] = "";
      Get.parameters[Role.role] = Role.customerRoleText;
    }
    Future.delayed(const Duration(milliseconds: 600), () async {
      Get.parameters["isFromTransaction"] = "false";
      Get.parameters["storeId"] = notificationData.storeId.toString();
      Get.parameters["orderId"] = notificationData.orderId.toString();
      Get.parameters["isFromNotification"] = "true";
      Get.to(() => const OrdersScreen(), id: pageIdApp.value);
    });
  }
  //******************  OFFER ********************

  else if (notificationData.type == "offer") {
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (roleApp.value == Role.storeOwnerRoleText) {
        SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
        roleApp.value = Role.customerRoleText;
        Get.parameters["orderId"] = "";
        Get.parameters[Role.role] = Role.customerRoleText;
      }
      Get.parameters["isFromTransaction"] = "false";
      Get.parameters["storeId"] = notificationData.storeId.toString();
      Get.parameters["orderId"] = notificationData.orderId.toString();
      Get.to(() => const OffersScreen(), id: pageIdApp.value);
    });

    //******************  MESSAGE  ********************
  } else if (notificationData.type ==
          StringConstants.messageText.toLowerCase() &&
      notificationData.senderType == StringConstants.userText.toLowerCase()) {
    if (roleApp.value == Role.customerRoleText) {
      SharedPreferenceStorage.setData(Role.role, Role.storeOwnerRoleText);
      roleApp.value = Role.storeOwnerRoleText;
      Get.parameters["orderId"] = "";
      Get.parameters[Role.role] = Role.storeOwnerRoleText;
    }
    Future.delayed(const Duration(seconds: 2), () async {
      Get.parameters["isFromTransaction"] = "false";
      Get.parameters["storeId"] = notificationData.storeId.toString();
      Get.parameters["messageHeadId"] =
          notificationData.messageHeadId.toString();
      Get.to(() => const OwnerInboxDetailScreen(), id: pageIdApp.value);
    });
  } else if (notificationData.type ==
          StringConstants.messageText.toLowerCase() &&
      notificationData.senderType == "store") {
    if (roleApp.value == Role.storeOwnerRoleText) {
      SharedPreferenceStorage.setData(Role.role, Role.customerRoleText);
      roleApp.value = Role.customerRoleText;
      Get.parameters["orderId"] = "";
      Get.parameters[Role.role] = Role.customerRoleText;
    }
    Future.delayed(const Duration(seconds: 2), () async {
      Get.parameters["isFromTransaction"] = "false";
      Get.parameters["storeId"] = notificationData.storeId.toString();
      Get.parameters["messageHeadId"] =
          notificationData.messageHeadId.toString();
      Get.to(() => const UserInboxDetailScreen(), id: pageIdApp.value);
    });
  }
}
