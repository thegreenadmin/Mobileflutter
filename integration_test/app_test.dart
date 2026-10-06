// Critical-path UI journey, ported from the Maestro flows in .maestro/flows/
// (launch_app, login_navigation, login_with_test_account, store_search_tabs,
// order_history_tabs, wallet_explore) so it can run as an instrumentation
// test on Firebase Test Lab.
//
// Uses the staging review account (phone 0000000000 / static OTP 0000), so
// the app must be built against the BETA env (assets/env/api_key.env).
//
// Screen text comes from StringConstants, which constants_overrides.g.dart
// can rewrite, so the test reads the constants rather than literals.
//
// Run locally:  flutter test integration_test/app_test.dart -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thegreenmall/main.dart' as app;
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';

const _testPhone = '0000000000';
const _testOtp = '0000';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // One app launch for the whole journey: main() initialises Firebase, GetX
  // and storage globally, so re-launching per test is not safe.
  testWidgets('critical journey: launch, login, stores, orders, wallet',
      (tester) async {
    // main() swaps FlutterError.onError for its Crashlytics handler, which
    // swallows test failures and hangs the run. Put the test binding's
    // handler back as soon as the app has started.
    final originalOnError = FlutterError.onError;
    addTearDown(() => FlutterError.onError = originalOnError);

    await _step('launch screen', () async {
      app.main();
      await _waitFor(tester, find.text(StringConstants.continueAsGuestText),
          timeout: const Duration(seconds: 60));
      FlutterError.onError = originalOnError;
      expect(find.text(StringConstants.loginYourAccountText), findsWidgets);
      expect(find.text(StringConstants.createAnAccountText), findsWidgets);
    });

    await _step('login screen', () async {
      await _tap(tester, find.text(StringConstants.loginYourAccountText));
      await _waitFor(tester, find.text(StringConstants.sendConfirmationCodeText));
      // The subtitle wraps with a hard line break, so match the phone field.
      expect(find.byType(IntlPhoneField), findsOneWidget);
    });

    await _step('login with test account', () async {
      await tester.enterText(
          find.descendant(
              of: find.byType(IntlPhoneField),
              matching: find.byType(EditableText)),
          _testPhone);
      await _pumpFor(tester, const Duration(milliseconds: 500));
      await _tap(tester, find.text(StringConstants.sendConfirmationCodeText));

      await _waitFor(tester, find.byType(PinCodeTextField));
      await _pumpFor(tester, const Duration(seconds: 1));
      await tester.enterText(
          find.descendant(
              of: find.byType(PinCodeTextField),
              matching: find.byType(EditableText)),
          _testOtp);

      // Shortcut pill labels come from the admin app config, and Munchies /
      // Herbs / Payments are country-gated, so only the stores pill is checked.
      await _waitFor(tester, _storesPill);
    });

    await _step('store search tabs', () async {
      await _tap(tester, _storesPill);
      await _waitFor(tester, find.text(StringConstants.searchForStoreText));
      // The stores pill opens a different screen per role: customers get the
      // Nearby / Previous / Favorite search, owners get their own store list.
      // The staging review account is currently a store owner.
      debugPrint('[journey] role: ${roleApp.value}');
      if (roleApp.value == Role.customerRoleText) {
        for (final tab in [
          StringConstants.nearbyText,
          StringConstants.previousText,
          StringConstants.favoriteText,
          StringConstants.nearbyText,
        ]) {
          await _tap(tester, find.text(tab));
          await _pumpFor(tester, const Duration(seconds: 2));
        }
      } else {
        await _waitFor(tester, find.text(StringConstants.addANewStoreText));
      }
      // Android back button -> home.
      await tester.binding.handlePopRoute();
      await _waitFor(tester, _storesPill);
    });

    await _step('order history', () async {
      await _tap(tester, find.text(BottomNavStringConstants.ordersText));
      if (roleApp.value == Role.customerRoleText) {
        await _waitFor(tester, find.text(StringConstants.cancelledText));
        for (final tab in [
          StringConstants.completeText,
          StringConstants.cancelledText,
          StringConstants.activeText,
        ]) {
          await _tap(tester, find.text(tab));
          await _pumpFor(tester, const Duration(seconds: 2));
        }
      } else {
        // Owners get a store picker (several stores or none) or, with one
        // store, that store's Received / Pickup / Completed queue.
        await _waitFor(
            tester,
            find.byWidgetPredicate(
                (w) =>
                    w is Text &&
                    (w.data == StringConstants.scanOrderBarcodeText ||
                        w.data == StringConstants.noOrdersFoundText ||
                        w.data == StringConstants.receivedText),
                description: 'owner orders screen'));
      }
    });

    await _step('wallet', () async {
      await _tap(tester, find.text(BottomNavStringConstants.walletText));
      await _waitFor(tester, find.text(StringConstants.totalBalanceText));
    });
  }, timeout: const Timeout(Duration(minutes: 8)));
}

/// The home stores shortcut. Admins can rename it (staging says "Store").
final _storesPill = find.byWidgetPredicate(
    (w) => w is Text && (w.data == 'Store' || w.data == 'Stores'),
    description: 'stores shortcut pill');

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

/// Taps the first match that can receive the tap, mirroring Maestro's
/// `tapOn: "<text>"`. Inactive tabs keep their widgets alive, so plain
/// `finder.first` can land on text the user cannot see.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  final target = finder.hitTestable();
  await _waitFor(tester, target);
  await tester.tap(target.first);
  await tester.pump(const Duration(milliseconds: 300));
}
