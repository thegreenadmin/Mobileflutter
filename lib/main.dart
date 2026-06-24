import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegreenmall/navigation/deep_link_service.dart';
import 'package:thegreenmall/navigation/router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/provider/network_service.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/utils/app_logger.dart';
import 'package:thegreenmall/utils/navigation_observer.dart';

RemoteMessage? initialRemoteMessage;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Global error handling
  FlutterError.onError = (details) {
    AppLogger.fatal('Flutter Error', error: details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };


  // ✅ Initialize services in sequence to avoid socket spikes
  await dotenv.load(fileName: 'assets/env/api_key.env');
  await Firebase.initializeApp();
  await GetStorage.init();

  // Test logging
  AppLogger.info('App initialized successfully');
  AppLogger.debug('Debug mode enabled');


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

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
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

    // Country feature flags (munchies/herbs/payments availability).
    AppConfigService.refresh();

    // Universal links (payment QR: https://thegreenmall.net/pay/<token>).
    DeepLinkService.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Re-fetch on resume so an admin kill switch reaches live users without
    // an app restart.
    if (state == AppLifecycleState.resumed) {
      AppConfigService.refresh();
    }
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
    DeepLinkService.dispose();
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
      navigatorObservers: [NavigationObserver()],
    );
  }
}

