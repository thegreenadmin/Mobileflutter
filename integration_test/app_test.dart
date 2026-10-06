// UI journey ported from the Maestro flows in .maestro/flows/ so it can run as
// an instrumentation test on Firebase Test Lab. Each step names the flow(s) it
// mirrors.
//
// Uses the staging review account (phone 0000000000 / static OTP 0000), so
// the app must be built against the BETA env (assets/env/api_key.env).
//
// Screen text comes from StringConstants, which constants_overrides.g.dart
// can rewrite, so the test reads the constants rather than literals. The
// Payments screens hard-code their copy, so those steps use literals.
//
// Nothing here moves money or calls Stripe: payment screens are opened but no
// code is generated, and the add-card form is only submitted empty, which is
// rejected client-side.
//
// Not ported:
//  - session_persistence: integration_test cannot kill and relaunch the app.
//  - flows that need a cart, store menu or wallet top-up (order_add_to_cart,
//    order_view_cart, store_browse_and_menu, store_product_browse,
//    store_filter_options, store_favourites, wallet_add_money,
//    wallet_auto_reload): customer-only, and the staging review account is a
//    store owner. Steps that differ by role branch on roleApp instead.
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
  // and storage globally, so re-launching per test is not safe. Steps after
  // login are non-fatal: a failure is logged, the app is walked back to the
  // home screen, and the next step runs. The test fails at the end if any
  // step did.
  testWidgets('maestro journey', (tester) async {
    // main() swaps FlutterError.onError for its Crashlytics handler, which
    // swallows test failures and hangs the run. Put the test binding's
    // handler back as soon as the app has started.
    final originalOnError = FlutterError.onError;
    addTearDown(() => FlutterError.onError = originalOnError);
    final failed = <String>[];
    var current = 'launch screen';
    // The binding only reports framework errors once the test ends, so log
    // them as they happen to tie each one to its step.
    void reportingOnError(FlutterErrorDetails d) {
      debugPrint('[journey] flutter error during "$current": '
          '${d.exceptionAsString().split('\n').first}');
      // Name the widget behind it (e.g. the overflowing Row's file:line).
      final where = d
          .toString()
          .split('\n')
          .skipWhile((l) => !l.contains('relevant error-causing widget'))
          .take(3)
          .map((l) => l.trim())
          .join(' ');
      if (where.isNotEmpty) debugPrint('[journey]   $where');
      originalOnError?.call(d);
    }

    Future<void> step(String name, Future<void> Function() body,
        {bool critical = false}) async {
      current = name;
      debugPrint('[journey] >>> $name');
      try {
        await body();
        debugPrint('[journey] <<< $name ok');
      } catch (e) {
        debugPrint('[journey] FAILED at "$name": $e');
        if (critical) rethrow;
        failed.add(name);
        await _backToHome(tester);
      }
    }

    // launch_app
    await step('launch screen', () async {
      app.main();
      await _waitFor(tester, find.text(StringConstants.continueAsGuestText),
          timeout: const Duration(seconds: 60));
      FlutterError.onError = reportingOnError;
      expect(find.text(StringConstants.loginYourAccountText), findsWidgets);
      expect(find.text(StringConstants.createAnAccountText), findsWidgets);
    }, critical: true);

    // guest_navigation
    await step('guest home', () async {
      await _tap(tester, find.text(StringConstants.continueAsGuestText));
      await _tap(tester, find.text("Yes, I'm 18 or older"),
          timeout: const Duration(seconds: 20));
      await _waitFor(tester, _storesPill);
      // Munchies / Herbs / Payments are country-gated pills; staging has them.
      expect(find.text('Payments'), findsWidgets);
    }, critical: true);

    // login_navigation, reached the way a guest would: a members-only
    // feature prompts for login.
    await step('guest gate to login screen', () async {
      await _tap(tester, find.text('Payments'));
      await _tap(tester, find.text(StringConstants.loginYourAccountText));
      await _waitFor(
          tester, find.text(StringConstants.sendConfirmationCodeText));
      expect(find.byType(IntlPhoneField), findsOneWidget);
      // The subtitle has a hard line break, so match its first words.
      expect(find.textContaining('Enter mobile number to login'),
          findsOneWidget);
    }, critical: true);

    // login_with_test_account
    await step('login with test account', () async {
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
      await _waitFor(tester, find.text(BottomNavStringConstants.walletText));
      await _waitFor(tester, _storesPill);
      debugPrint('[journey] role: ${roleApp.value}');
    }, critical: true);

    // store_search_tabs (customer) / owner store list
    await step('stores', () async {
      await _tap(tester, _storesPill);
      await _waitFor(tester, find.text(StringConstants.searchForStoreText));
      if (_isCustomer) {
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
      await _tap(tester, find.byIcon(Icons.arrow_back));
      await _waitFor(tester, _storesPill.hitTestable());
    });

    // order_history_tabs (customer) / order_store_list (owner)
    await step('orders', () async {
      await _tap(tester, find.text(BottomNavStringConstants.ordersText));
      if (_isCustomer) {
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
        // A store picker (several stores or none) or, with one store, that
        // store's Received / Pickup / Completed queue.
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

    // wallet_explore, wallet_manage_screen
    await step('wallet and manage wallet', () async {
      await _tap(tester, find.text(BottomNavStringConstants.walletText));
      await _waitFor(tester, find.text(StringConstants.totalBalanceText));
      await _tap(tester, find.text(StringConstants.manageText));
      await _waitFor(tester, find.text(StringConstants.manageWalletText));
      await _scrollTo(
          tester, find.text(StringConstants.addCardPaymentMethodsText));
    });

    // card_validation_invalid, minus the Stripe round trip: submit the empty
    // form and expect the client-side rejection.
    await step('add card form validation', () async {
      await _tap(tester, find.text(StringConstants.addCardPaymentMethodsText));
      await _tap(tester, find.text(StringConstants.addNewCardText));
      await _waitFor(tester, find.text(StringConstants.cardNumberText));
      expect(find.text(StringConstants.cvvText), findsWidgets);
      // The screen title says "Add Card" too; the submit button is last.
      final submit = find.text(StringConstants.addCardText).last;
      await _scrollTo(tester, submit);
      await tester.tap(submit);
      await _waitFor(
          tester, find.text(AlertStringConstants.pleaseFillAllDetailsText));
      await _tap(tester, find.text(StringConstants.okayText));
      // Form -> card list -> manage wallet -> wallet.
      for (var i = 0; i < 3; i++) {
        await _tap(tester, find.byIcon(Icons.arrow_back));
        await _pumpFor(tester, const Duration(seconds: 1));
      }
      await _waitFor(tester, find.text(StringConstants.manageText));
    });

    // payment_merchant_barcode, payment_request_money
    await step('payments receive', () async {
      await _openPayments(tester);
      await _tap(tester, find.text('Receive'));
      await _waitFor(tester, find.text('Get paid'));
      if (_isCustomer) {
        await _tap(tester, find.text('Show my code'));
        await _waitFor(tester, find.textContaining('My Payment Code'));
        await _tap(tester, find.byIcon(Icons.arrow_back));
        await _tap(tester, find.text('Request money'));
        await _waitFor(tester, find.text('Generate barcode'));
        expect(find.textContaining('Mobile number'), findsWidgets);
        expect(find.textContaining('Amount'), findsWidgets);
      } else {
        await _tap(tester, find.text('Receive to my business'));
        // Opening the screen does not generate a code; that needs a tap.
        await _waitFor(tester, find.textContaining('Generate a payment code'));
        expect(find.text('Generate code'), findsWidgets);
      }
      await _backToHome(tester);
    });

    // payment_scanner. Last, because mobile_scanner kills the app on a
    // device without a usable camera.
    await step('payments scanner', () async {
      await _openPayments(tester);
      await _tap(tester, find.text('Pay to a Business'));
      await _waitFor(tester, find.text('Scan Barcode'));
      await _tap(tester, find.text('Enter Phone'));
      await _waitFor(tester, find.text('Continue'));
      await _backToHome(tester);
    });

    // Let in-flight API calls finish. Ending the test tears the widget tree
    // down under them, and their error path (Utility.showAlertMessage ->
    // Get.context!) then throws and fails an otherwise passing run.
    await _pumpFor(tester, const Duration(seconds: 15));

    if (failed.isEmpty) {
      debugPrint('[journey] ALL STEPS PASSED');
    } else {
      debugPrint('[journey] ${failed.length} step(s) failed: '
          '${failed.join(', ')}');
      fail('Steps failed: ${failed.join(', ')}');
    }
  }, timeout: const Timeout(Duration(minutes: 12)));
}

bool get _isCustomer => roleApp.value == Role.customerRoleText;

/// The home stores shortcut. Admins can rename it (staging says "Store").
final _storesPill = find.byWidgetPredicate(
    (w) => w is Text && (w.data == 'Store' || w.data == 'Stores'),
    description: 'stores shortcut pill');

Future<void> _openPayments(WidgetTester tester) async {
  await _tap(tester, find.text(BottomNavStringConstants.homeText));
  await _waitFor(tester, _storesPill.hitTestable());
  await _tap(tester, find.text('Payments'));
  await _waitFor(tester, find.text('Pay to a Business'));
}

/// Walks back to the home tab root after a step, or after a failed one left
/// the app on some inner screen. Uses the screens' own back arrows: the
/// Android back button (handlePopRoute) is not forwarded to the tabs' nested
/// Navigators, so it backgrounds the app and the test stalls waiting for
/// frames.
Future<void> _backToHome(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await _pumpFor(tester, const Duration(milliseconds: 800));
    final okay = find.text(StringConstants.okayText).hitTestable();
    final back = find.byIcon(Icons.arrow_back).hitTestable();
    final home = find.text(BottomNavStringConstants.homeText).hitTestable();
    if (okay.evaluate().isNotEmpty) {
      await tester.tap(okay.first);
    } else if (back.evaluate().isNotEmpty) {
      await tester.tap(back.first);
    } else if (_storesPill.hitTestable().evaluate().isNotEmpty) {
      return;
    } else if (home.evaluate().isNotEmpty) {
      await tester.tap(home.first);
    }
  }
  debugPrint('[journey] could not get back to home');
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

/// Scrolls [finder]'s first match into view, like Maestro's scroll-and-assert.
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await _waitFor(tester, finder);
  await tester.ensureVisible(finder.first);
  await _pumpFor(tester, const Duration(milliseconds: 500));
}

/// Taps the first match that can receive the tap, mirroring Maestro's
/// `tapOn: "<text>"`. Inactive tabs keep their widgets alive, so plain
/// `finder.first` can land on text the user cannot see.
Future<void> _tap(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final target = finder.hitTestable();
  await _waitFor(tester, target, timeout: timeout);
  await tester.tap(target.first);
  await tester.pump(const Duration(milliseconds: 300));
}
