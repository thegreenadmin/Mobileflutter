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
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/utils.dart';

RemoteMessage? initialRemoteMessage;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // ✅ Initialize services in sequence to avoid socket spikes
  await dotenv.load(fileName: 'assets/env/api_key.env');
  await Firebase.initializeApp();
  await GetStorage.init();


  // Start network monitoring (singleton, not recreated each time)
  NetworkService().startMonitoring();

  // ✅ Notifications
  await _initNotifications();

  // ✅ Dynamic Links (handled later inside app state)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initial push message if app opened from terminated state
  initialRemoteMessage = await checkForInitialFirebaseMessage();

  runApp(const MyApp());

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

/*

  NetworkService().startMonitoring();

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
*/

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light));
}

Future<void> _initNotifications() async {
  // Your push notification service
  PushNotificationService notificationService = PushNotificationService();

  // Firebase messaging permissions
  await initialize();
  await notificationPermission();

  // Background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Local notifications plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ✅ Create Android channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Foreground notification presentation (iOS / Android)
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // ✅ Initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('notification_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // ✅ Register callbacks
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse:
    PushNotificationService.handleNotification,
    onDidReceiveNotificationResponse:
    PushNotificationService.handleNotification,
  );

  // ✅ Keep your custom notification handlers
  getNotificationOpenedApp();
  getNotification();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ Don’t clear storage blindly at startup (optional)
    clearData();
  }

  clearData() async {
    SharedPreferenceStorage.getData('onboardingCompleted');
    SharedPreferenceStorage storage = SharedPreferenceStorage();

    storage.clearData();
    Get.parameters.clear();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // ✅ Cleanup global clients to avoid leaks
    UserProvider.disposeClient(); // <-- close IOClient safely
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstants.theGreenMallTitleText,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: StringConstants.interFamilyText,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      getPages: Routers.route,
      themeMode: ThemeMode.system,
      initialRoute: '/splashView',
    );
  }
}
/*

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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // ✅ Cleanup global clients to avoid leaks
    UserProvider.disposeClient(); // <-- close IOClient safely
    super.dispose();
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
*/
