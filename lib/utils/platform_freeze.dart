import 'package:dio/dio.dart' as mdio;
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_gate.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/utility.dart';

/// Platform freeze, set by an admin (Admin panel → Freeze Platform).
///
/// While frozen the server answers app requests with HTTP 503 and
/// `{"code": "PLATFORM_FROZEN", "mode": ..., "message": ...}`:
/// - `full`: every app request is refused, so the app shows its maintenance
///   screen with the server's message until the freeze is lifted.
/// - `money_only`: only payments, deposits, payouts and orders are refused;
///   the app shows the message and carries on.
class PlatformFreeze {
  static const code = 'PLATFORM_FROZEN';

  static bool _screenShown = false;
  static DateTime? _lastAlertAt;

  /// The server's message for the current full freeze, for the screen.
  static String? message;

  /// True when [statusCode] and [body] are a freeze response.
  static bool isFrozenResponse(int? statusCode, dynamic body) =>
      statusCode == 503 && body is Map && body['code'] == code;

  /// Reacts to a freeze response. Returns true when it was one, so the caller
  /// stops handling the response (it has already been shown to the person).
  static bool handle(int? statusCode, dynamic body) {
    if (!isFrozenResponse(statusCode, body)) return false;
    final map = body as Map;
    final text = map['message']?.toString();
    if (map['mode'] == 'full') {
      message = text;
      _showScreen();
    } else {
      _alert(text);
    }
    return true;
  }

  /// Adds freeze handling to a Dio client used for uploads.
  static void attach(mdio.Dio dio) {
    dio.interceptors.add(mdio.InterceptorsWrapper(
      onResponse: (response, handler) {
        handle(response.statusCode, response.data);
        handler.next(response);
      },
      onError: (error, handler) {
        handle(error.response?.statusCode, error.response?.data);
        handler.next(error);
      },
    ));
  }

  /// Whether the platform is still fully frozen. Asks the server with a
  /// light request that a full freeze refuses (the app config is always
  /// served, so it can't tell).
  static Future<bool> stillFrozen() async {
    final res = await UserProvider().getWithHeadersApi(
        ServerCommunicator.baseUrl + ServerCommunicator.countries, {},
        showError: false, checkFreeze: false);
    if (res == null) return true; // No answer: stay on the screen.
    if (isFrozenResponse(res.statusCode, res.body)) {
      message = (res.body as Map)['message']?.toString() ?? message;
      return true;
    }
    return false;
  }

  /// Called by the screen once the freeze is over.
  static void lifted() {
    _screenShown = false;
    message = null;
  }

  static void _showScreen() {
    if (_screenShown) return;
    _screenShown = true;
    // offAll also closes any open dialog or loader.
    Get.offAll(() => const AppBlockedScreen.frozen());
  }

  static void _alert(String? text) {
    // Several money calls can fail at once (wallet, cards, balance); show
    // one alert, not a stack of them.
    final now = DateTime.now();
    if (_lastAlertAt != null &&
        now.difference(_lastAlertAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastAlertAt = now;
    Utility.showAlertMessage(
        text ?? 'Payments are paused for a short while. Please try again later.',
        title: 'Payments paused');
  }
}
