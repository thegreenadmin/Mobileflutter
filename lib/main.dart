import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegreenmall/navigation/router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/provider/network_service.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/utils.dart';

RemoteMessage? initialRemoteMessage;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  NetworkService().startMonitoring();
  await Firebase.initializeApp();
  await GetStorage.init();
  await dotenv.load(fileName: 'assets/env/api_key.env');
  PushNotificationService notificationService = PushNotificationService();
  await initialize();
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

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: PushNotificationService.handleNotification,
    onDidReceiveNotificationResponse: PushNotificationService.handleNotification,
  );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onDidReceiveBackgroundNotificationResponse: notificationService.selectNotification,
  //     onDidReceiveNotificationResponse: notificationService.selectNotification);

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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> handleDeepLink() async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          // Set up the `onLink` event listener next as it may be received here
          final Uri deepLink = pendingDynamicLinkData.link;
          // Example of using the dynamic link to push the user to a different screen
          Navigator.pushNamed(context, deepLink.path);
        },
      );
    } on PlatformException {
//Pass
    } on FormatException {
//Pass
    } catch (e) {
//Pass-++
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
  void initState() {
    super.initState();

    clearData();
  }

  clearData() async {
    SharedPreferenceStorage.getData('onboardingCompleted');
    SharedPreferenceStorage storage = SharedPreferenceStorage();

    storage.clearData();
    Get.parameters.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: GlobalKey<NavigatorState>(),
      title: StringConstants.theGreenMallTitleText, // The Green Mall
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: StringConstants.interFamilyText, //Inter Font Family,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // theme: Themes.light,
      // darkTheme: Themes.dark,
      home: const SplashScreen(),
      getPages: Routers.route, themeMode: ThemeMode.system,
      initialRoute: '/splashView',
    );
  }
}
