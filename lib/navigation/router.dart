import 'package:get/get.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';

import 'package:thegreenmall/authentication/signup/view/signup_screen.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_main_screen.dart';

class Routers {
  static final route = [
    GetPage(
      name: '/splashView',
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: '/onboardView',
      page: () => const OnBoardMainScreen(),
    ),
    GetPage(
      name: '/startJourneyScreen',
      page: () => const StartJourneyScreen(),
    ),
    GetPage(
      name: '/registerView',
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: '/otpVerificationView',
      page: () => const OtpVerificationScreen(),
    ),
  ];
}
