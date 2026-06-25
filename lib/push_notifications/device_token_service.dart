import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_logger.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';

/// Keeps the backend's record of this device's FCM token in sync.
///
/// Historically the token was only sent to the server once, during OTP verify
/// ([OtpVerificationController]). FCM rotates tokens (app update, restore,
/// storage clear, periodic refresh), so a long-lived logged-in session ends up
/// with a dead token on the server and silently stops receiving push. This
/// service closes that gap by:
///   - listening for [FirebaseMessaging.onTokenRefresh] and re-registering, and
///   - re-syncing the current token whenever the app resolves a logged-in user
///     (cold start with a saved token, and after a fresh login).
class DeviceTokenService {
  DeviceTokenService._();

  static final DeviceTokenService instance = DeviceTokenService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _refreshListenerAttached = false;

  /// `GCM` for Android, `APNS` for iOS — matches the values the backend stores
  /// in `user_sessions.device_type` and routes on.
  String get _deviceType =>
      Platform.isAndroid ? StringConstants.gcmText : StringConstants.apnsText;

  /// Attach the token-refresh listener exactly once. Safe to call on every
  /// launch; only forwards to the backend when a user is logged in.
  void init() {
    if (_refreshListenerAttached) return;
    _refreshListenerAttached = true;
    _messaging.onTokenRefresh.listen((token) {
      AppLogger.info('FCM token refreshed');
      _registerToken(token);
    }, onError: (e) {
      AppLogger.error('onTokenRefresh error', error: e);
    });
  }

  /// Resolve the current FCM token, waiting for the APNs token on iOS.
  ///
  /// On iOS `getToken()` returns null until the APNs token is available, which
  /// is why the OTP flow occasionally registered an empty token. Poll briefly
  /// for the APNs token before requesting the FCM token.
  Future<String?> getCurrentToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        var attempts = 0;
        while (apnsToken == null && attempts < 5) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _messaging.getAPNSToken();
          attempts++;
        }
        if (apnsToken == null) {
          AppLogger.error('APNs token unavailable; skipping FCM token fetch');
          return null;
        }
      }
      final token = await _messaging.getToken();
      AppLogger.info(
          'FCM token resolved (len=${token?.length ?? 0}): '
          '${token == null ? "null" : "${token.substring(0, token.length < 12 ? token.length : 12)}..."}');
      return token;
    } catch (e) {
      AppLogger.error('getCurrentToken failed', error: e);
      return null;
    }
  }

  /// Fetch the current token and push it to the backend if logged in.
  Future<void> syncToken() async {
    if (!_isLoggedIn) return;
    final token = await getCurrentToken();
    if (token == null || token.isEmpty) return;
    await _registerToken(token);
  }

  bool get _isLoggedIn => !isGuest.value && authToken.value.isNotEmpty;

  Future<void> _registerToken(String token) async {
    if (!_isLoggedIn) return;
    try {
      final headers = {
        'Content-Type': 'application/json',
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
      };
      final body = {
        "device_token": token.trim(),
        "device_type": _deviceType,
      };
      final res = await UserProvider().postWithHeadersApi(
        body,
        ServerCommunicator.baseUrl + ServerCommunicator.updateDeviceToken,
        headers,
        showLoading: false,
        showError: false,
      );
      final status = res?.body["status"];
      if (status == ApiConstants.statusCode200 ||
          status == ApiConstants.statusCode201) {
        AppLogger.info('Device token registered with backend');
      } else {
        AppLogger.error('Device token registration failed: $status');
      }
    } catch (e) {
      AppLogger.error('registerToken failed', error: e);
    }
  }
}
