// Critical-path UI journey, ported from the Maestro flows in .maestro/flows/
// (launch_app, login_navigation, login_with_test_account, store_search_tabs,
// order_history_tabs, wallet_explore) so it can run as an instrumentation
// test on Firebase Test Lab.
//
// Uses the staging review account (phone 0000000000 / static OTP 0000), so
// the app must be built against the BETA env (assets/env/api_key.env).
//
// Run locally:  flutter test integration_test/app_test.dart -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thegreenmall/main.dart' as app;

const _testPhone = '0000000000';
const _testOtp = '0000';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // One app launch for the whole journey: main() initialises Firebase, GetX
  // and storage globally, so re-launching per test is not safe.
  testWidgets('critical journey: launch, login, stores, orders, wallet',
      (tester) async {
    // main() installs Crashlytics error handlers; the test binding requires
    // FlutterError.onError to be restored before the test ends.
    final originalOnError = FlutterError.onError;
    addTearDown(() => FlutterError.onError = originalOnError);

    await _step('launch screen', () async {
      app.main();
      await _waitFor(tester, find.text('Continue as Guest'),
          timeout: const Duration(seconds: 60));
      expect(find.text('Login your account'), findsWidgets);
      expect(find.text('Create an account'), findsWidgets);
    });

    await _step('login screen', () async {
      await _tap(tester, find.text('Login your account'));
      await _waitFor(tester, find.text('Send Confirmation Code'));
      expect(find.text('Enter mobile number to login your account'),
          findsOneWidget);
    });

    await _step('login with test account', () async {
      await tester.enterText(
          find.descendant(
              of: find.byType(IntlPhoneField),
              matching: find.byType(EditableText)),
          _testPhone);
      await _pumpFor(tester, const Duration(milliseconds: 500));
      await _tap(tester, find.text('Send Confirmation Code'));

      await _waitFor(tester, find.byType(PinCodeTextField));
      await _pumpFor(tester, const Duration(seconds: 1));
      await tester.enterText(
          find.descendant(
              of: find.byType(PinCodeTextField),
              matching: find.byType(EditableText)),
          _testOtp);

      await _waitFor(tester, find.text('Munchies'));
      expect(find.text('Stores'), findsWidgets);
      expect(find.text('Herbs'), findsWidgets);
      expect(find.text('Payments'), findsWidgets);
    });

    await _step('store search tabs', () async {
      await _tap(tester, find.text('Stores'));
      await _waitFor(tester, find.text('Search for stores'));
      for (final tab in ['Nearby', 'Previous', 'Favorite', 'Nearby']) {
        await _tap(tester, find.text(tab));
        await _pumpFor(tester, const Duration(seconds: 2));
      }
      // Android back button -> home.
      await tester.binding.handlePopRoute();
      await _waitFor(tester, find.text('Munchies'));
    });

    await _step('order history tabs', () async {
      await _tap(tester, find.text('Orders'));
      await _waitFor(tester, find.text('Cancelled'));
      for (final tab in ['Complete', 'Cancelled', 'Active']) {
        await _tap(tester, find.text(tab));
        await _pumpFor(tester, const Duration(seconds: 2));
      }
    });

    await _step('wallet', () async {
      await _tap(tester, find.text('Wallet'));
      await _waitFor(tester, find.text('Total Balance'));
    });

    FlutterError.onError = originalOnError;
  }, timeout: const Timeout(Duration(minutes: 8)));
}

/// Labels each stage in the device log so a Test Lab failure names the step.
Future<void> _step(String name, Future<void> Function() body) async {
  debugPrint('[journey] >>> $name');
  try {
    await body();
  } catch (e) {
    debugPrint('[journey] FAILED at "$name"');
    rethrow;
  }
  debugPrint('[journey] <<< $name ok');
}

/// Pumps frames until [finder] matches. The app has looping animations and
/// spinners, so pumpAndSettle would never return.
Future<void> _waitFor(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out after ${timeout.inSeconds}s waiting for $finder');
}

Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Taps the first match, mirroring Maestro's `tapOn: "<text>"`.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await _waitFor(tester, finder);
  await tester.tap(finder.first, warnIfMissed: false);
  await tester.pump(const Duration(milliseconds: 300));
}
