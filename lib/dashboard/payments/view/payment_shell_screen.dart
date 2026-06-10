import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/app_bottom_nav_bar.dart';

import '../payment_routes.dart';
import 'barcode_scanner_screen.dart';
import 'component/pay_theme.dart';
import 'merchant_barcode_display_screen.dart';
import 'payment_details_screen.dart';
import 'payments_home_screen.dart';
import 'review_pay_screen.dart';

/// Persistent shell for the payments flow.
///
/// The bottom navigation bar lives here, on a single Scaffold, while the
/// individual payment screens render inside a nested [Navigator]. Because the
/// bar is mounted once on this Scaffold (and the Scaffold does not resize for
/// the keyboard), it stays perfectly static as inner screens push/pop and as
/// the keyboard opens — instead of re-animating with every full-screen route.
///
/// Inner navigation uses GetX's nested navigation (`id: PaymentRoutes.navId`),
/// e.g. `Get.toNamed(PaymentRoutes.scanner, id: PaymentRoutes.navId)`.
///
/// The locked terminal screens (processing / success) are intentionally pushed
/// on the ROOT navigator so they cover the bar.
class PaymentShell extends StatelessWidget {
  const PaymentShell({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final nav = Get.nestedKey(PaymentRoutes.navId)?.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop(); // step back through the inner flow first
        } else {
          Get.back(); // at the flow root -> leave the shell entirely
        }
      },
      child: Scaffold(
        backgroundColor: PayTheme.background,
        // Bar is owned here and must not be pushed up by the keyboard.
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const AppBottomNavBar(),
        body: Navigator(
          key: Get.nestedKey(PaymentRoutes.navId),
          initialRoute: PaymentRoutes.home,
          // Force a single initial route. The default splits a slashed name
          // ("/paymentsHome") into multiple segments and would stack two home
          // screens.
          onGenerateInitialRoutes: (navigator, initialRoute) => [
            GetPageRoute(
              settings: const RouteSettings(name: PaymentRoutes.home),
              page: () => const PaymentsHomeScreen(),
            ),
          ],
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case PaymentRoutes.scanner:
                page = const BarcodeScannerScreen();
                break;
              case PaymentRoutes.details:
                page = const PaymentDetailsScreen();
                break;
              case PaymentRoutes.review:
                page = const ReviewPayScreen();
                break;
              case PaymentRoutes.merchantCode:
                page = const MerchantBarcodeDisplayScreen();
                break;
              case PaymentRoutes.home:
              default:
                page = const PaymentsHomeScreen();
            }
            return GetPageRoute(settings: settings, page: () => page);
          },
        ),
      ),
    );
  }
}
