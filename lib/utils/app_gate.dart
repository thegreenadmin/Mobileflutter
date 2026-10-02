import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/app_config.dart';
import 'package:thegreenmall/utils/app_config_service.dart';
import 'package:thegreenmall/utils/brand_image.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Admin-driven app gates (Settings → App behavior): maintenance mode, a
/// forced minimum version, and an optional "update available" prompt.
class AppGate {
  static String? _installedVersion;

  static Future<String> installedVersion() async {
    return _installedVersion ??= (await PackageInfo.fromPlatform()).version;
  }

  /// The screen that must replace the app right now, or null to continue.
  static Future<Widget?> blockingScreen() async {
    final config = AppConfig.current;
    if (config.maintenanceEnabled) return const AppBlockedScreen.maintenance();
    final min = config.minVersion;
    if (min.isNotEmpty &&
        compareVersions(await installedVersion(), min) < 0) {
      return const AppBlockedScreen.forceUpdate();
    }
    return null;
  }

  /// Routes to the blocking screen if one applies. Returns true if it did.
  static Future<bool> enforce() async {
    final screen = await blockingScreen();
    if (screen == null) return false;
    Get.offAll(() => screen);
    return true;
  }

  /// Dismissible prompt when a newer (but not required) version exists.
  static Future<void> maybePromptOptionalUpdate() async {
    final config = AppConfig.current;
    final latest = config.latestVersion;
    if (latest.isEmpty || config.storeUrl.isEmpty) return;
    if (compareVersions(await installedVersion(), latest) >= 0) return;
    Get.dialog(
      AlertDialog(
        title: Text(StringConstants.updateAvailableTitleText),
        content: Text(StringConstants.updateAvailableMessageText),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(StringConstants.notNowText,
                style: TextStyle(color: AppColors.black)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openStore();
            },
            child: Text(StringConstants.updateNowText,
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  static Future<void> openStore() async {
    final url = AppConfig.current.storeUrl;
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

/// Full-screen block for maintenance mode or a required update.
class AppBlockedScreen extends StatefulWidget {
  const AppBlockedScreen.maintenance({super.key}) : forceUpdate = false;
  const AppBlockedScreen.forceUpdate({super.key}) : forceUpdate = true;

  final bool forceUpdate;

  @override
  State<AppBlockedScreen> createState() => _AppBlockedScreenState();
}

class _AppBlockedScreenState extends State<AppBlockedScreen> {
  bool _checking = false;

  Future<void> _retry() async {
    setState(() => _checking = true);
    await AppConfigService.refresh(rebuild: false);
    if (!mounted) return;
    setState(() => _checking = false);
    if (await AppGate.blockingScreen() == null) {
      Get.offAll(() => const SplashScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.forceUpdate
        ? StringConstants.updateRequiredTitleText
        : StringConstants.maintenanceTitleText;
    final message = widget.forceUpdate
        ? StringConstants.updateRequiredMessageText
        : AppConfig.current.maintenanceMessage;
    final canOpenStore =
        widget.forceUpdate && AppConfig.current.storeUrl.isNotEmpty;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: BrandImage.asset(ImageConstants.greenmall420,
                      fit: BoxFit.contain),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppColors.blackMedium),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _checking
                        ? null
                        : (canOpenStore ? AppGate.openStore : _retry),
                    child: _checking
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.white))
                        : Text(canOpenStore
                            ? StringConstants.updateNowText
                            : StringConstants.tryAgainText),
                  ),
                ),
                if (canOpenStore)
                  TextButton(
                    onPressed: _checking ? null : _retry,
                    child: Text(StringConstants.tryAgainText,
                        style: TextStyle(color: AppColors.primary)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
