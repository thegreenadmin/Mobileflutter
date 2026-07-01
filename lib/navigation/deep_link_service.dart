import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/payments/payment_link.dart';
import 'package:thegreenmall/dashboard/payments/payment_routes.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/utility.dart';

/// Handles incoming universal links — currently the payment QR link
/// `https://thegreenmall.net/pay/<token>`.
///
/// When the app is already installed, iOS / Android route the tapped or scanned
/// link straight here (cold start or while running). We unwrap the `<token>`,
/// open the payments flow, and let [PaymentsHomeScreen] consume the pending
/// token to run the normal decode -> details flow.
///
/// People without the app never reach this code: their link opens the website's
/// "Get the app" page instead (CTA A, install funnel).
class DeepLinkService {
  DeepLinkService._();

  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;

  /// A payment token waiting to be handled by the payments flow once it opens.
  static String? _pendingToken;

  /// Start listening for links. Safe to call once at app startup.
  static Future<void> init() async {
    // Link that cold-started the app. Defer to after the first frame so the
    // navigator/auth have a chance to settle before we route. If we're still
    // pre-auth, the token stays pending and the payments flow consumes it later.
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _handleUri(initial));
      }
    } catch (_) {
      // No initial link / platform not ready — ignore.
    }
    // Links delivered while the app is already running.
    _sub ??= _appLinks.uriLinkStream.listen(_handleUri, onError: (_) {});
  }

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  static void _handleUri(Uri uri) {
    final token = PaymentLink.extractToken(uri.toString());
    if (token == null) return; // not a /pay/<token> link
    _openPayment(token);
  }

  static void _openPayment(String token) {
    // Stash first so the destination screen can pick it up.
    _pendingToken = token;

    // A payment needs a signed-in user. If we're not authenticated yet, keep the
    // token pending and let the user sign in; the payments flow consumes it when
    // they next open it in this session.
    if (authToken.value.isEmpty) {
      Utility.showToast('Please sign in to complete this payment.');
      return;
    }

    // Open the payments flow on the root navigator (the shell supports being
    // hosted there when deep-linked).
    Get.toNamed(PaymentRoutes.flow);
  }

  /// Returns and clears any pending payment token. The payments home screen
  /// calls this on entry to resume a deep-linked payment.
  static String? consumePendingToken() {
    final token = _pendingToken;
    _pendingToken = null;
    return token;
  }
}
