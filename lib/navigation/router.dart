import 'package:get/get.dart';
import 'package:thegreenmall/authentication/otpverification/view/otp_verification_screen.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_main_screen.dart';
import 'package:thegreenmall/dashboard/payments/binding/payment_binding.dart';
import 'package:thegreenmall/dashboard/payments/payment_routes.dart';
import 'package:thegreenmall/dashboard/payments/view/payment_shell_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/payments_home_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/barcode_scanner_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/payment_details_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/review_pay_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/payment_processing_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/payment_success_screen.dart';
import 'package:thegreenmall/dashboard/payments/view/merchant_barcode_display_screen.dart';

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
      name: '/bottomNavigation',
      page: () => const BottomNavigation(),
    ),
    GetPage(
      name: '/otpVerificationView',
      page: () => const OtpVerificationScreen(),
    ),
    GetPage(
      name: '/homeView',
      page: () => const HomeScreen(),
    ),
    // P2P & P2B barcode payments — share one PaymentController across the flow.
    // The shell owns the static bottom nav and hosts the screens below in a
    // nested navigator (id: PaymentRoutes.navId).
    GetPage(
      name: PaymentRoutes.flow,
      page: () => const PaymentShell(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.home,
      page: () => const PaymentsHomeScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.scanner,
      page: () => const BarcodeScannerScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.details,
      page: () => const PaymentDetailsScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.review,
      page: () => const ReviewPayScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.processing,
      page: () => const PaymentProcessingScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.success,
      page: () => const PaymentSuccessScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: PaymentRoutes.merchantCode,
      page: () => const MerchantBarcodeDisplayScreen(),
      binding: PaymentBinding(),
    ),
  ];
}
