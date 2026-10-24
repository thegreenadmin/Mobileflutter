import 'dart:developer' as developer;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
      noBoxingByDefault: false,
    ),
    filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    level: kDebugMode ? Level.debug : Level.error,
  );

  // Enable/disable logging globally
  static bool _isLoggingEnabled = kDebugMode;

  static void setLoggingEnabled(bool enabled) {
    _isLoggingEnabled = enabled;
  }

  // Debug level - detailed information for debugging
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isLoggingEnabled) {
      _logger.d(message, error: error, stackTrace: stackTrace);
      developer.log(message, level: 500, error: error, stackTrace: stackTrace);
    }
  }

  // Info level - general informational messages
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isLoggingEnabled) {
      _logger.i(message, error: error, stackTrace: stackTrace);
      developer.log(message, level: 800, error: error, stackTrace: stackTrace);
    }
  }

  // Warning level - warning messages
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isLoggingEnabled) {
      _logger.w(message, error: error, stackTrace: stackTrace);
      developer.log(message, level: 900, error: error, stackTrace: stackTrace);
    }
  }

  // Error level - error messages
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isLoggingEnabled) {
      _logger.e(message, error: error, stackTrace: stackTrace);
      developer.log(message, level: 1000, error: error, stackTrace: stackTrace);
    }
    // Always forward to Crashlytics (not gated by _isLoggingEnabled) so
    // crashes — including backend/database call failures reported through
    // this method — still reach the dashboard even when verbose local
    // logging has been turned off.
    _recordToCrashlytics(message, error: error, stackTrace: stackTrace, fatal: false);
  }

  // Fatal level - critical errors.
  // Note: main.dart's top-level FlutterError.onError / PlatformDispatcher.onError
  // handlers call this AND report to Crashlytics themselves (via
  // recordFlutterFatalError / recordError) using the full error context, so
  // this method only logs locally to avoid double-reporting the same crash.
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isLoggingEnabled) {
      _logger.wtf(message, error: error, stackTrace: stackTrace);
      developer.log(message, level: 2000, error: error, stackTrace: stackTrace);
    }
  }

  // Sends a non-fatal error report to Firebase Crashlytics. Wrapped in a
  // try/catch since Crashlytics may not be initialized yet (e.g. very early
  // startup errors, or when Firebase.initializeApp() itself fails).
  static void _recordToCrashlytics(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    required bool fatal,
  }) {
    try {
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
        fatal: fatal,
      );
    } catch (_) {
      // Crashlytics not available yet — don't let logging crash the app.
    }
  }

  // API Request logging
  static void logApiRequest(String method, String url, Map<String, dynamic>? data) {
    if (_isLoggingEnabled) {
      _logger.d('🌐 API REQUEST',
        error: 'Method: $method\nURL: $url\nData: ${data?.toString()}');
    }
  }

  // API Response logging
  static void logApiResponse(String method, String url, int statusCode, dynamic response) {
    if (_isLoggingEnabled) {
      if (statusCode >= 200 && statusCode < 300) {
        _logger.i('✅ API RESPONSE',
          error: 'Method: $method\nURL: $url\nStatus: $statusCode\nResponse: ${response?.toString()}');
      } else {
        _logger.e('❌ API RESPONSE',
          error: 'Method: $method\nURL: $url\nStatus: $statusCode\nResponse: ${response?.toString()}');
      }
    }
  }

  // Navigation logging
  static void logNavigation(String from, String to, {Map<String, dynamic>? arguments}) {
    if (_isLoggingEnabled) {
      _logger.i('🧭 NAVIGATION',
        error: 'From: $from\nTo: $to\nArguments: ${arguments?.toString()}');
    }
  }

  // Performance logging
  static void logPerformance(String operation, Duration duration) {
    if (_isLoggingEnabled) {
      _logger.d('⏱️ PERFORMANCE',
        error: 'Operation: $operation\nDuration: ${duration.inMilliseconds}ms');
    }
  }

  // State change logging
  static void logStateChange(String widget, String state, dynamic value) {
    if (_isLoggingEnabled) {
      _logger.d('🔄 STATE CHANGE',
        error: 'Widget: $widget\nState: $state\nValue: ${value.toString()}');
    }
  }

  // User action logging
  static void logUserAction(String action, {Map<String, dynamic>? details}) {
    if (_isLoggingEnabled) {
      _logger.i('👤 USER ACTION',
        error: 'Action: $action\nDetails: ${details?.toString()}');
    }
  }
}

// Custom filter for development
class DevelopmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true; // Log everything in development
  }
}

// Custom filter for production
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Only log errors and warnings in production
    return event.level.index >= Level.warning.index;
  }
}
