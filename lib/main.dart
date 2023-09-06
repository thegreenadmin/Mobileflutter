import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegreenmall/navigation/router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/utils/utils.dart';

RemoteMessage? initialRemoteMessage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await notificationPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('notification_icon');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: selectNotification,
      onDidReceiveNotificationResponse: selectNotification);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: selectNotification,
      onDidReceiveNotificationResponse: selectNotification);

  getNotificationOpenedApp();
  getNotification();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initialRemoteMessage = (await checkForInitialFirebaseMessage());
  // final PendingDynamicLinkData? initialLink =
  //     await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    // handleDeepLink();
  }

  Future<void> handleDeepLink() async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          // Set up the `onLink` event listener next as it may be received here
          if (pendingDynamicLinkData != null) {
            final Uri deepLink = pendingDynamicLinkData.link;
            // Example of using the dynamic link to push the user to a different screen
            Navigator.pushNamed(context, deepLink.path);
          }
        },
      );
    } on PlatformException {
//Pass
    } on FormatException {
//Pass
    } catch (e) {
//Pass
    }
  }

  // Future<void> initDynamicLinks() async {
  //   dynamicLinks.onLink.listen((dynamicLinkData) {
  //     print("HELLOOOOO ******** " + dynamicLinks.onLink.toString());
  //     // Navigator.pushNamed(context, dynamicLinkData.link.path);
  //   }).onError((error) {
  //     print('onLink error');
  //     print(error.message);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstants.theGreenMallTitleText, // The Green Mall
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: StringConstants.interFamilyText, //Inter Font Family,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      getPages: Routers.route,
      initialRoute: '/splashView',
    );
  }
}
