import 'dart:ui' as ui;

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';

/// Fetches the per-country feature config (munchies / herbs / payments) the
/// backend resolves from call metadata. The UI flags are cosmetic only —
/// every gated action is enforced again server-side.
class AppConfigService {
  /// Device region (e.g. "US") sent as X-Device-Country so the backend can
  /// resolve the caller's country ahead of IP geolocation.
  static String? get deviceCountryCode =>
      ui.PlatformDispatcher.instance.locale.countryCode;

  /// Refresh the global feature flags. Safe to call without a session
  /// (guests get the country-level features, licensee stays false). Keeps
  /// previous values on network failure rather than flickering the UI.
  static Future<void> refresh() async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      if (!isGuest.value && authToken.value.isNotEmpty) {
        headers[StringConstants.authorizationText] =
            "${StringConstants.bearerText} ${authToken.value}";
      }

      // Background refresh: never surface network/parse errors to the user
      // (e.g. an HTML error page from the gateway would otherwise alert).
      final response = await UserProvider().getWithHeadersApi(
        ServerCommunicator.baseUrl + ServerCommunicator.appConfig,
        headers,
        showError: false,
      );

      final data = response?.body?['data'];
      final features = data?['features'];
      if (features is Map) {
        munchiesEnabled.value = features['munchies'] == true;
        herbsEnabled.value = features['herbs'] == true;
        paymentsEnabled.value = features['payments'] == true;
        isHerbsLicensee.value = data?['is_herbs_licensee'] == true;
        // Present only when the country has a single herbs store (else null);
        // drives the Herbs pill deep-link in HomeScreen._openStores.
        herbsStoreId.value = data?['herbs_store_id']?.toString() ?? "";
      }
    } catch (_) {
      // keep the last known flags; the backend still enforces everything
    }
  }
}
