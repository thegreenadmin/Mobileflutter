import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_logger.dart';

class NavigationObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    AppLogger.logNavigation(
      previousRoute?.settings.name ?? 'Unknown',
      route.settings.name ?? 'Unknown',
      arguments: route.settings.arguments as Map<String, dynamic>?,
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    AppLogger.logNavigation(
      route.settings.name ?? 'Unknown',
      previousRoute?.settings.name ?? 'Unknown',
      arguments: previousRoute?.settings.arguments as Map<String, dynamic>?,
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    AppLogger.logNavigation(
      oldRoute?.settings.name ?? 'Unknown',
      newRoute?.settings.name ?? 'Unknown',
      arguments: newRoute?.settings.arguments as Map<String, dynamic>?,
    );
  }
}
