import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../payment_routes.dart';
import 'barcode_scanner_screen.dart';
import 'business_select_screen.dart';
import 'component/pay_theme.dart';
import 'merchant_barcode_display_screen.dart';
import 'payment_details_screen.dart';
import 'payments_home_screen.dart';
import 'request_money_screen.dart';
import 'review_pay_screen.dart';

/// Persistent shell for the payments flow.
///
/// Pushed inside the home tab's nested navigator (`id: pageIdApp.value`) like
/// every other screen, so the dashboard's own bottom bar stays visible and
/// static while the individual payment screens render inside a nested
/// [Navigator] here.
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
          // At the flow root -> pop the shell off whichever navigator hosts
          // it (the home tab's nested navigator, or root when deep-linked).
          // Plain pop(): maybePop() would re-consult this PopScope
          // (canPop: false) and recurse forever.
          final host = Navigator.of(context);
          if (host.canPop()) {
            host.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: PayTheme.background,
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
              case PaymentRoutes.businessSelect:
                page = const BusinessSelectScreen();
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
              case PaymentRoutes.requestMoney:
                page = const RequestMoneyScreen();
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
