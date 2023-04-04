import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thegreenmall/utils/app_colors.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'roomie_notifications', // id
  'roomie notifications', // title
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
    debugPrint("notification data---------------" + message.data.toString());
    debugPrint("notification data 123 ---------------" +
        message.notification.toString());
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
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("getNotificationOpenedApp data---" + message.data.toString());
    selectNotification(json.encode(message.data) as NotificationResponse);
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "firebaseMessagingBackgroundHandler data---" + message.data.toString());
  // await Firebase.initializeApp();
  selectNotification(json.encode(message.data) as NotificationResponse);
}

Future<RemoteMessage?> checkForInitialFirebaseMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  return initialMessage;
}

void selectNotification(NotificationResponse payload) async {
  // debugPrint("selectNotification" + json.decode(payload!).toString());
  // RealTimeNotification notificationData =
  //     RealTimeNotification.fromJson(json.decode(payload));
  // if (notificationData.type == "sendRequest") {
  //   Get.to(() => const EventsScreen(
  //       isDrawerInvitationOpen: false,
  //       isFromNotification: true,
  //       isSent: false));
  // } else if (notificationData.type == "acceptRequest") {
  //   Get.to(() => const EventsScreen(
  //       isDrawerInvitationOpen: false, isFromNotification: true, isSent: true));
  // } else if (notificationData.type == "sendGroupMessage") {
  //   Future.delayed(const Duration(milliseconds: 1400), () async {
  //     Get.to(
  //         GroupChatDetailScreen(
  //           groupId: notificationData.groupId.toString(),
  //           groupName: notificationData.groupName.toString(),
  //         ),
  //         arguments: {
  //           "groupId": notificationData.groupId.toString(),
  //           "groupName": notificationData.groupName.toString(),
  //         });
  //   });
  // } else if (notificationData.type == "sendMessage") {
  //   Future.delayed(const Duration(milliseconds: 1400), () async {
  //     Get.to(
  //         () => PersonalChatDetailScreen(
  //               groupId: "",
  //               messageSenderLastName: "",
  //               messageSenderName: notificationData.senerName.toString(),
  //               requestReceiverId: notificationData.senderId.toString(),
  //               requestSenderId: notificationData.recieverId.toString(),
  //             ),
  //         arguments: {
  //           "isPersonal": true,
  //           "groupId": "",
  //           "messageSenderLastName": "",
  //           "messageSenderName": notificationData.senerName.toString(),
  //           "requestReceiverId": notificationData.senderId.toString(),
  //           "requestSenderId": notificationData.recieverId.toString(),
  //         });
  //   });
  // } else if (notificationData.type == "isArchieve" &&
  //     notificationData.isGroup == "false") {
  //   Future.delayed(const Duration(milliseconds: 1400), () async {
  //     Get.to(
  //         () => PersonalChatDetailScreen(
  //               messageSenderLastName: "",
  //               messageSenderName: notificationData.senerName.toString(),
  //               requestReceiverId: notificationData.senderId.toString(),
  //               requestSenderId: notificationData.recieverId.toString(),
  //             ),
  //         arguments: {
  //           "isPersonal": true,
  //           "messageSenderLastName": "",
  //           "messageSenderName": notificationData.senerName.toString(),
  //           "requestReceiverId": notificationData.senderId.toString(),
  //           "requestSenderId": notificationData.recieverId.toString(),
  //         });
  //   });
  // } else if (notificationData.type == "isArchieve" &&
  //     notificationData.isGroup == "true") {
  //   Future.delayed(const Duration(milliseconds: 1400), () async {
  //     Get.to(
  //         GroupChatDetailScreen(
  //           groupId: notificationData.groupId.toString(),
  //           groupName: notificationData.groupName.toString(),
  //         ),
  //         arguments: {
  //           "groupId": notificationData.groupId.toString(),
  //           "groupName": notificationData.groupName.toString(),
  //         });
  //   });
  // }
}
