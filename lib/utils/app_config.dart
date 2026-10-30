import 'dart:io' show Platform;

import 'package:flutter/material.dart';

/// Admin-managed app configuration (theme, branding, behavior, UI text)
/// served by GET utils/app/config and edited in the admin panel under
/// Settings → App appearance / App text / App behavior.
///
/// Every accessor falls back to the value the app hardcoded before this
/// existed, so a missing or partial payload never changes behavior.
class AppConfig {
  AppConfig({
    this.version = '',
    Map<String, dynamic>? theme,
    Map<String, dynamic>? branding,
    Map<String, dynamic>? behavior,
    Map<String, dynamic>? layout,
    Map<String, String>? strings,
  })  : theme = theme ?? const {},
        branding = branding ?? const {},
        behavior = behavior ?? const {},
        layout = layout ?? const {},
        strings = strings ?? const {};

  /// Config currently applied to the app.
  static AppConfig current = AppConfig();

  final String version;
  final Map<String, dynamic> theme;
  final Map<String, dynamic> branding;
  final Map<String, dynamic> behavior;
  final Map<String, dynamic> layout;
  final Map<String, String> strings;

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> map(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
    final rawStrings = json['strings'];
    final strings = <String, String>{};
    if (rawStrings is Map) {
      rawStrings.forEach((k, v) {
        if (v is String) strings[k.toString()] = v;
      });
    }
    return AppConfig(
      version: json['config_version']?.toString() ?? '',
      theme: map(json['theme']),
      branding: map(json['branding']),
      behavior: map(json['behavior']),
      layout: map(json['layout']),
      strings: strings,
    );
  }

  Map<String, dynamic> toJson() => {
        'config_version': version,
        'theme': theme,
        'branding': branding,
        'behavior': behavior,
        'layout': layout,
        'strings': strings,
      };

  // ------------------------------------------------------------- theme

  /// Parses "#RRGGBB" / "#AARRGGBB" from [theme], else [fallback].
  Color color(String key, Color fallback) {
    final raw = theme[key];
    if (raw is! String) return fallback;
    var hex = raw.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) return fallback;
    final value = int.tryParse(hex, radix: 16);
    return value == null ? fallback : Color(value);
  }

  static const bundledFonts = ['Inter', 'Montaga'];

  String get fontFamily {
    final f = theme['font_family'];
    return f is String && bundledFonts.contains(f) ? f : 'Inter';
  }

  // ---------------------------------------------------------- branding

  /// Remote image URL for a branding slot, or null to use the bundled asset.
  String? image(String key) {
    final v = branding[key];
    return v is String && v.startsWith('https://') ? v : null;
  }

  // ------------------------------------------------------------ layout

  /// Home shortcut pills in display order (Settings → Home screen). Unknown
  /// ids are dropped and any missing id is appended with its default, so a
  /// malformed payload can never lose a pill.
  List<HomeShortcut> get homeShortcuts {
    final raw = layout['home_shortcuts'];
    final result = <HomeShortcut>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is! Map) continue;
        final id = item['id']?.toString() ?? '';
        if (!HomeShortcut.ids.contains(id) || result.any((s) => s.id == id)) {
          continue;
        }
        final label = item['label']?.toString().trim() ?? '';
        result.add(HomeShortcut(
          id: id,
          label: label.isNotEmpty ? label : HomeShortcut.defaults[id]!.label,
          icon: item['icon']?.toString() ?? HomeShortcut.defaults[id]!.icon,
          visible: item['visible'] != false,
          color: _parseHex(item['color']),
        ));
      }
    }
    for (final id in HomeShortcut.ids) {
      if (!result.any((s) => s.id == id)) result.add(HomeShortcut.defaults[id]!);
    }
    return result;
  }

  static Color? _parseHex(dynamic raw) {
    if (raw is! String || raw.isEmpty) return null;
    var hex = raw.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    final value = hex.length == 8 ? int.tryParse(hex, radix: 16) : null;
    return value == null ? null : Color(value);
  }

  // ---------------------------------------------------------- behavior

  String _string(String key, String fallback) {
    final v = behavior[key];
    return v is String ? v : fallback;
  }

  num _num(String key, num fallback) {
    final v = behavior[key];
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? fallback;
    return fallback;
  }

  bool _bool(String key, bool fallback) {
    final v = behavior[key];
    return v is bool ? v : fallback;
  }

  String get minVersion => _string(
      Platform.isIOS ? 'min_version_ios' : 'min_version_android', '');
  String get latestVersion => _string(
      Platform.isIOS ? 'latest_version_ios' : 'latest_version_android', '');
  String get storeUrl =>
      _string(Platform.isIOS ? 'store_url_ios' : 'store_url_android', '');

  bool get maintenanceEnabled => _bool('maintenance_enabled', false);
  String get maintenanceMessage => _string('maintenance_message',
      "We're making some improvements. Please check back shortly.");

  String get supportEmail => _string('support_email', '');
  String get supportPhone => _string('support_phone', '');
  String get instagramUrl => _string('social_instagram_url', '');
  String get facebookUrl => _string('social_facebook_url', '');
  String get xUrl => _string('social_x_url', '');

  String get currencySymbol => _string('currency_symbol', r'$');
  double get minWalletTopup => _num('min_wallet_topup', 10).toDouble();

  int get homeSearchRadiusMiles => _num('home_search_radius_miles', 1000).toInt();
  int get homeOffersPageSize => _num('home_offers_page_size', 20).toInt();
  int get homeFeaturedProductsPageSize =>
      _num('home_featured_products_page_size', 5).toInt();

  int get biometricMaxAttempts => _num('biometric_max_attempts', 3).toInt();
}

/// Formats [amount] with the admin-configured currency symbol, e.g. "$12.50".
String formatMoney(num? amount, {int decimals = 2}) {
  final value = (amount ?? 0).toStringAsFixed(decimals);
  return '${AppConfig.current.currencySymbol}$value';
}

/// Compares dotted versions ("1.10.0" vs "1.9.3"). Returns <0, 0 or >0.
int compareVersions(String a, String b) {
  List<int> parts(String v) =>
      v.split('+').first.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final pa = parts(a), pb = parts(b);
  for (var i = 0; i < 3; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x - y;
  }
  return 0;
}

/// Admin-configured currency symbol for display, e.g. "$".
String get currencySign => AppConfig.current.currencySymbol;

/// One home-screen shortcut pill. [id] fixes what the pill does; the rest is
/// admin-controlled presentation.
class HomeShortcut {
  const HomeShortcut({
    required this.id,
    required this.label,
    required this.icon,
    this.visible = true,
    this.color,
  });

  final String id;
  final String label;
  final String icon;
  final bool visible;

  /// Pill accent; null = theme primary.
  final Color? color;

  static const ids = ['stores', 'munchies', 'herbs', 'payments'];

  static const defaults = {
    'stores': HomeShortcut(id: 'stores', label: 'Stores', icon: 'storefront'),
    'munchies':
        HomeShortcut(id: 'munchies', label: 'Munchies', icon: 'lunch_dining'),
    'herbs': HomeShortcut(id: 'herbs', label: 'Herbs', icon: 'local_florist'),
    'payments':
        HomeShortcut(id: 'payments', label: 'Payments', icon: 'payments'),
  };

  /// Icon names the admin panel offers (backend SHORTCUT_ICONS).
  static const _icons = <String, IconData>{
    'storefront': Icons.storefront_outlined,
    'store': Icons.store_outlined,
    'shopping_bag': Icons.shopping_bag_outlined,
    'lunch_dining': Icons.lunch_dining_outlined,
    'restaurant': Icons.restaurant_outlined,
    'local_cafe': Icons.local_cafe_outlined,
    'local_florist': Icons.local_florist_outlined,
    'spa': Icons.spa_outlined,
    'eco': Icons.eco_outlined,
    'grass': Icons.grass_outlined,
    'local_pharmacy': Icons.local_pharmacy_outlined,
    'payments': Icons.payments_outlined,
    'account_balance_wallet': Icons.account_balance_wallet_outlined,
    'local_offer': Icons.local_offer_outlined,
    'favorite': Icons.favorite_outline,
    'star': Icons.star_outline,
  };

  IconData get iconData =>
      _icons[icon] ?? _icons[defaults[id]!.icon] ?? Icons.circle_outlined;
}
