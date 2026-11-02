import 'dart:ui' as ui;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/dashboard/payments/view/component/pay_theme.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/app_config.dart';
import 'package:thegreenmall/utils/app_logger.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/constants_overrides.g.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';

/// Fetches the app config the backend resolves from call metadata:
///  * per-country feature flags (munchies / herbs / payments). These UI flags
///    are cosmetic only — every gated action is enforced again server-side.
///  * the admin-managed theme / branding / behavior / UI text ([AppConfig]).
///    The last config is cached so a cold start (even offline) renders with
///    it immediately instead of flashing the shipped defaults.
class AppConfigService {
  static const _cacheKey = 'app_config_cache_v1';

  /// Device region (e.g. "US") sent as X-Device-Country so the backend can
  /// resolve the caller's country ahead of IP geolocation.
  static String? get deviceCountryCode =>
      ui.PlatformDispatcher.instance.locale.countryCode;

  /// Apply the cached config synchronously. Call after GetStorage.init() and
  /// before runApp so the first frame already uses it.
  static void loadCached() {
    try {
      final cached = GetStorage().read(_cacheKey);
      if (cached is Map) {
        _apply(AppConfig.fromJson(Map<String, dynamic>.from(cached)));
      }
    } catch (e) {
      AppLogger.error('Ignoring unreadable cached app config', error: e);
    }
  }

  /// Refresh the feature flags and app config. Safe to call without a session
  /// (guests get the country-level features, licensee stays false). Keeps
  /// previous values on network failure rather than flickering the UI.
  ///
  /// When the config version changed, the new config is applied and cached;
  /// with [rebuild] the whole widget tree is rebuilt so colors, images and
  /// text update in place. Returns true when a response was received.
  static Future<bool> refresh({bool rebuild = true}) async {
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
      if (data is! Map) return false;

      final features = data['features'];
      if (features is Map) {
        munchiesEnabled.value = features['munchies'] == true;
        herbsEnabled.value = features['herbs'] == true;
        paymentsEnabled.value = features['payments'] == true;
        isHerbsLicensee.value = data['is_herbs_licensee'] == true;
        // Present only when the country has a single herbs store (else null);
        // drives the Herbs pill deep-link in HomeScreen._openStores.
        herbsStoreId.value = data['herbs_store_id']?.toString() ?? "";
      }

      // Older backends don't send config_version; keep the current config.
      if (data['config_version'] != null) {
        final config = AppConfig.fromJson(Map<String, dynamic>.from(data));
        if (config.version != AppConfig.current.version) {
          _apply(config);
          await GetStorage().write(_cacheKey, config.toJson());
          if (rebuild) await Get.forceAppUpdate();
        }
      }
      return true;
    } catch (_) {
      // keep the last known flags/config; the backend still enforces everything
      return false;
    }
  }

  static void _apply(AppConfig config) {
    AppConfig.current = config;
    AppColors.apply(config);
    PayTheme.apply(config);
    applyStringOverrides(config.strings);
  }
}
