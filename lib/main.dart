import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';

import 'package:thegreenmall/authentication/signup/view/signup_screen.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/search_store_owner_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/search_store_user_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_detail_screen.dart';
import 'package:thegreenmall/navigation/router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
 
Future<void> main() async {
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'thegreenmall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      getPages: Routers.route,
      //initialRoute: '/welcomeView',
      home: SplashScreen(),
    );
  }
}
