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
// Writes to beta, whose Stripe account is in test mode: the journey creates
// and deletes an offer and a product, adds and removes the Stripe test card
// 5555 5555 5555 4444, tops up the wallets from a saved card, orders its own
// product as a customer, pays its own store by phone and pays out to the
// Stripe test bank. Money only moves between the account's own wallet, its
// own store and Stripe test instruments. The card step refuses to run unless
// the build carries a pk_test_ publishable key. Sign-up is only validated:
// the form is never submitted with the terms accepted.
//
// The account is a store owner; the customer steps switch role in-app
// (Account > Switch to Customer) and switch back afterwards.
//
// Run locally:  flutter test integration_test/app_test.dart -d <device>
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/store_home_main_args.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/add_offer_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/main.dart' as app;
import 'package:thegreenmall/utils/app_config.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';

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
        _dumpScreen();
        if (critical) rethrow;
        failed.add(name);
        await _backToHome(tester);
      }
    }

    // launch_app
    await step('launch screen', () async {
      ImagePickerPlatform.instance = _FakeImagePicker();
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
      await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
          find.text(StringConstants.totalBalanceText));
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

    // Names are unique per run so a leftover from an aborted run never
    // matches, and cleanup can find what this run made.
    final stamp = DateTime.now().millisecondsSinceEpoch % 1000000;
    final offerName = 'FTL offer $stamp';
    final productName = 'FTL product $stamp';
    var productCreated = false;

    // offer_create, offer_delete
    await step('owner offer create and delete', () async {
      await _tapUntil(tester, find.text(BottomNavStringConstants.offersText),
          find.text(StringConstants.addNewOfferText));
      await _tap(tester, find.text(StringConstants.addNewOfferText));
      await _waitFor(tester, find.text(StringConstants.enterOfferNameText));
      await _tap(tester, find.text(StringConstants.uploadImageText));
      await _tap(tester, find.text(StringConstants.galleryText));
      final offers = Get.find<AddOffersController>();
      await _until(tester, 'offer image upload',
          () => offers.offerImageOriginalLinkFromServer.value.isNotEmpty);
      await _enterField(tester, StringConstants.enterOfferNameText, offerName);
      await _tap(tester, find.byWidgetPredicate(
          (w) => w is Radio && w.value == OfferType.store,
          description: 'store offer radio'));
      // A single-store owner gets the store preselected (no hint shown).
      if (offers.storeIdValue.value.isEmpty) {
        await _pickFirst(tester, find.text(StringConstants.selectStoreText).last);
      }
      final discountHint = find.descendant(
          of: find.byType(DropdownButtonFormField<DiscountType>),
          matching: find.text(StringConstants.selectTypeText));
      if (discountHint.evaluate().isNotEmpty) {
        await _pickFirst(tester, discountHint);
      }
      await _enterField(tester, StringConstants.enterValueText, '5');
      await _submit(tester, find.text(StringConstants.addOfferText).last);
      await _waitFor(tester, find.text(offerName));

      await _swipeDelete(tester, find.text(offerName));
      await _waitGone(tester, find.text(offerName));
    });

    // product_create: Stores > store > Manage Store > Manage Products >
    // first category > Add New Product. Kept until the customer has ordered
    // it, then deleted by 'owner product delete'.
    await step('owner product create', () async {
      await _openProductList(tester);
      await _tap(tester, find.text(StringConstants.addNewProductText));
      await _waitFor(tester, find.text(StringConstants.enterProductNameText));
      await _enterField(
          tester, StringConstants.enterProductNameText, productName);
      // Dropdowns in form order: quantity unit, discount, featured, return.
      final dropdowns = find.byType(DropdownButtonFormField<String>);
      await _pickFirst(tester, dropdowns.at(0));
      await _enterField(tester, StringConstants.enterQuantityText, '1');
      await _enterField(tester, StringConstants.enterPriceText, '1');
      await _pickText(tester, dropdowns.at(2), StringConstants.noText);
      await _enterField(tester, StringConstants.weightText, '1');
      await _pickText(tester, dropdowns.at(3), StringConstants.noText);
      await _submit(tester, find.text(StringConstants.saveText));
      // Save pops back to the category list; reopen the product list.
      await _waitGone(tester, find.text(StringConstants.enterProductNameText));
      productCreated = true;
      await _backToHome(tester);
      await _openProductList(tester);
      await _waitFor(tester, find.text(productName));
    });

    // card_add_valid, card_delete. 4242 is already on the account and the
    // form refuses a duplicate last4, so this uses the Mastercard test card
    // and first removes one a previous run may have left behind.
    await step('add and remove test card', () async {
      if (!ServerCommunicator.stripePublishableKey.startsWith('pk_test_')) {
        throw TestFailure('build has no pk_test_ Stripe key; refusing to '
            'enter a card');
      }
      await _openCardList(tester);
      await _deleteCardEnding(tester, '4444');
      await _tap(tester, find.text(StringConstants.addNewCardText));
      await _waitFor(tester, find.text(StringConstants.cardNumberText));
      await _enterField(tester, StringConstants.x4Text, '5555555555554444');
      await _enterField(tester, StringConstants.x2Text, '12/34');
      await _enterField(tester, StringConstants.x1Text, '123');
      await _enterField(tester, StringConstants.enterNameText, 'FTL Test');
      final billing = {
        StringConstants.addressLine1Text: '1 Test St',
        StringConstants.cityText: 'Austin',
        StringConstants.zipCodeText: '78701',
        StringConstants.stateText: 'TX',
        StringConstants.countryText: 'US',
      };
      for (final e in billing.entries) {
        await _enterField(tester, e.key, e.value, optional: true);
      }
      await _submit(tester, find.text(StringConstants.addCardText).last);
      await _waitFor(tester, _cardEnding('4444'),
          timeout: const Duration(seconds: 45));
      await _deleteCardEnding(tester, '4444');
      expect(_cardEnding('4444'), findsNothing);
    });

    // wallet_add_money (owner): store wallet from the saved 4242 card.
    await step('owner wallet top-up', () async {
      await _topUp(tester, '1');
    });

    await step('switch to customer', () async {
      await _switchRole(tester, toCustomer: true);
    });

    // wallet_add_money (customer)
    await step('customer wallet top-up', () async {
      await _topUp(tester, '5');
    });

    // store_browse_and_menu, order_add_to_cart, order_view_cart,
    // order_place: the customer orders this run's product from the
    // account's own store, paid from the wallet.
    await step('customer order', () async {
      if (!productCreated) throw TestFailure('no product to order');
      // Store search is location-based (nearby radius, Places autocomplete
      // that needs a Maps key), so open the store page the way a nearby-store
      // row does rather than depend on where the device is.
      await _backToHome(tester);
      Get.to(
          () => StoreHomeMainScreen(
              args: StoreHomeMainArgs(
                  storeId: _ownStoreId,
                  isFromMenu: false,
                  isFromFav: false,
                  isFromHome: true,
                  isFromOptions: false)),
          id: pageIdApp.value);
      await _tap(tester, find.text(StringConstants.menuText));
      await _tapUntil(tester, find.text(_firstCategoryName),
          find.text(productName));
      await _tap(tester, find.text(productName));
      await _tap(tester, _asset(ImageConstants.add));
      await _submit(tester, find.text(StringConstants.addToOrderText));
      await _tap(tester, find.text(StringConstants.goToCartText));
      await _waitFor(tester, find.text(StringConstants.orderSummaryText));
      final inStore = find.text(StringConstants.inStoreText);
      if (inStore.hitTestable().evaluate().isNotEmpty) {
        await _tap(tester, inStore);
      }
      await _submit(tester, find.text(StringConstants.payNowText));
      // Wallet payment asks to confirm the deduction first.
      await _tap(tester, find.text(StringConstants.proceedText));
      await _waitFor(tester, find.text(StringConstants.orderConfirmedText),
          timeout: const Duration(seconds: 45));
      await _backToHome(tester);
    });

    // payment_p2b_phone: pay the account's own store $1 by phone. P2B to
    // one's own store is allowed (only P2P blocks self-payment), and $1 is
    // under the biometric threshold.
    await step('pay own business by phone', () async {
      await _openPayments(tester);
      await _tap(tester, find.text('Pay to a Business'));
      await _tap(tester, find.text('Enter Phone'));
      await tester.enterText(
          find.descendant(
              of: find.byType(IntlPhoneField),
              matching: find.byType(EditableText)),
          _testPhone);
      await _tap(tester, find.text('Continue'));
      await _waitFor(tester, find.text('Select Business'));
      // A number with a single business has it preselected.
      final pickBusiness = find.text('Select a business');
      if (pickBusiness.hitTestable().evaluate().isNotEmpty) {
        await _pickFirst(tester, pickBusiness);
      }
      await _tap(tester, find.text('Continue'));
      await _waitFor(tester, find.text('Enter payment details'));
      await tester.enterText(
          find.descendant(
              of: find.ancestor(
                  of: find.text('Amount'), matching: find.byType(Column))
                  .first,
              matching: find.byType(EditableText)),
          '1');
      await _submit(tester, find.text('Review & Pay'));
      await _submit(tester, find.textContaining(r'Pay $'));
      await _waitFor(tester, find.text('Payment Successful!'),
          timeout: const Duration(seconds: 45));
      await _tap(tester, find.text('Done'));
      await _backToHome(tester);
    });

    await step('switch back to store', () async {
      await _switchRole(tester, toCustomer: false);
    });

    // wallet_payout: $1 from the store wallet to the Stripe test bank.
    await step('owner payout to test bank', () async {
      await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
          find.text(StringConstants.totalBalanceText));
      await _tap(tester, find.text(StringConstants.manageText));
      await _scrollTo(
          tester, find.text(StringConstants.debitMoneyFromWalletText));
      await _tap(tester, find.text(StringConstants.debitMoneyFromWalletText));
      await _waitFor(tester, find.text(StringConstants.payoutText));
      if (find.text(StringConstants.selectStoreText).evaluate().length > 1) {
        await _pickFirst(tester, find.text(StringConstants.selectStoreText).last);
      }
      await _enterField(tester, 'eg ${currencySign}100.00', '1');
      await _tap(tester, find.text('STRIPE TEST BANK'));
      await _submit(tester, find.text(StringConstants.oKText));
      await _waitGone(tester, find.text(StringConstants.payoutText),
          timeout: const Duration(seconds: 45));
      await _backToHome(tester);
    });

    await step('owner product delete', () async {
      if (!productCreated) return;
      await _openProductList(tester);
      await _swipeDelete(tester, find.text(productName));
      await _waitGone(tester, find.text(productName));
      await _backToHome(tester);
    });

    // logout. The Delete Account button sits right under Logout; the test
    // only ever taps the exact "Logout" text and the dialog's "Yes".
    await step('logout', () async {
      await _openAccount(tester);
      await _scrollTo(tester, find.text(StringConstants.logoutText));
      await _tap(tester, find.text(StringConstants.logoutText));
      await _waitFor(
          tester, find.text(AlertStringConstants.areYouSureLogoutAccountText));
      await _tap(tester, find.text(StringConstants.yesText));
      await _waitFor(tester, find.text(StringConstants.createAnAccountText),
          timeout: const Duration(seconds: 30));
    }, critical: true);

    // signup_validation: empty submit shows the field errors; filled fields
    // without the terms box stop at the terms alert, so no user is created.
    await step('sign-up form validation', () async {
      await _tap(tester, find.text(StringConstants.createAnAccountText));
      await _waitFor(tester, find.text(StringConstants.createAccountText));
      await _submit(tester, find.text(StringConstants.signUpText).last);
      await _waitFor(
          tester, find.text(AlertStringConstants.pleaseEnterFirstNameText));
      expect(find.text(AlertStringConstants.pleaseEnterLastNameText),
          findsOneWidget);
      await _enterField(tester, StringConstants.firstNameText, 'Ftl');
      await _enterField(tester, StringConstants.lastNameText, 'Test');
      await tester.enterText(
          find.descendant(
              of: find.byType(IntlPhoneField),
              matching: find.byType(EditableText)),
          '5125550100');
      await _submit(tester, find.text(StringConstants.signUpText).last);
      await _waitFor(tester,
          find.text(AlertStringConstants.pleaseEnterTermsAndConditions));
      await _tap(tester, find.text(StringConstants.okayText));
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
  }, timeout: const Timeout(Duration(minutes: 25)));
}

bool get _isCustomer => roleApp.value == Role.customerRoleText;

/// The home stores shortcut. Admins can rename it (staging says "Store").
final _storesPill = find.byWidgetPredicate(
    (w) => w is Text && (w.data == 'Store' || w.data == 'Stores'),
    description: 'stores shortcut pill');

Future<void> _openPayments(WidgetTester tester) async {
  await _tapUntil(tester, find.text(BottomNavStringConstants.homeText),
      _storesPill.hitTestable());
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
    // A confirm dialog a failed step left open; Cancel never changes data.
    final cancel = find.text(StringConstants.cancelText).hitTestable();
    if (okay.evaluate().isNotEmpty) {
      await tester.tap(okay.first);
    } else if (cancel.evaluate().isNotEmpty) {
      await tester.tap(cancel.first);
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

/// Taps [finder] until [expected] shows up. A tab tap made while the
/// previous screen is still loading can be dropped, so one tap isn't enough.
Future<void> _tapUntil(WidgetTester tester, Finder finder, Finder expected,
    {int attempts = 4}) async {
  for (var i = 1; i <= attempts; i++) {
    await _tap(tester, finder);
    try {
      await _waitFor(tester, expected, timeout: const Duration(seconds: 10));
      return;
    } on TestFailure {
      if (i == attempts) rethrow;
      debugPrint('[journey]   no $expected after tap $i; tapping again');
    }
  }
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

/// Store and category the product steps use, read from the owner screens'
/// controllers and kept for the customer steps (the controllers are torn
/// down on a role switch).
var _ownStoreName = '';
var _ownStoreId = '';
var _firstCategoryName = '';

/// Owner: Stores > own store > Manage Store > Manage Products > first
/// category, which lists that category's products. Store, category and
/// product rows are all swipe-to-delete, so these are only ever tapped.
Future<void> _openProductList(WidgetTester tester) async {
  await _backToHome(tester);
  await _tap(tester, _storesPill);
  await _waitFor(tester, find.text(StringConstants.addANewStoreText));
  final stores = Get.find<OwnerStoresController>();
  await _until(tester, 'owner store list', () => stores.storeList.isNotEmpty);
  _ownStoreName = stores.storeList.first.storeName ?? '';
  _ownStoreId = stores.storeList.first.storeId ?? '';
  await _tap(tester, find.text(_ownStoreName));
  await _tap(tester, find.text(StringConstants.manageStoreText));
  await _tap(tester, find.text(StringConstants.manageProductsText));
  final manage = Get.find<ManageStoreController>();
  await _until(
      tester, 'category list', () => manage.categoriesList.isNotEmpty);
  _firstCategoryName = manage.categoriesList.first.categoryName ?? '';
  await _tap(tester, find.text(_firstCategoryName));
  await _waitFor(tester, find.text(StringConstants.addNewProductText));
}

Future<void> _openCardList(WidgetTester tester) async {
  await _backToHome(tester);
  await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
      find.text(StringConstants.totalBalanceText));
  await _tap(tester, find.text(StringConstants.manageText));
  await _scrollTo(tester, find.text(StringConstants.addCardPaymentMethodsText));
  await _tap(tester, find.text(StringConstants.addCardPaymentMethodsText));
  await _waitFor(tester, find.text(StringConstants.addNewCardText));
}

Finder _cardEnding(String last4) => find.text('**** **** **** **** $last4');

/// Deletes every saved card ending in [last4] from the card list screen.
Future<void> _deleteCardEnding(WidgetTester tester, String last4) async {
  await _pumpFor(tester, const Duration(seconds: 2));
  while (_cardEnding(last4).evaluate().isNotEmpty) {
    final rows = find.ancestor(
        of: _cardEnding(last4).first, matching: find.byType(Row));
    Finder? icon;
    for (var i = 0; i < rows.evaluate().length; i++) {
      final candidate = find.descendant(
          of: rows.at(i), matching: _asset(ImageConstants.deleteicon));
      if (candidate.evaluate().isNotEmpty) {
        icon = candidate;
        break;
      }
    }
    if (icon == null) throw TestFailure('no delete icon for card $last4');
    final before = _cardEnding(last4).evaluate().length;
    await _tap(tester, icon);
    await _tap(tester, find.text(StringConstants.deleteText));
    await _until(tester, 'card $last4 deleted',
        () => _cardEnding(last4).evaluate().length < before);
  }
}

/// Wallet tab > add money > [amount] from the saved 4242 test card.
Future<void> _topUp(WidgetTester tester, String amount) async {
  await _backToHome(tester);
  await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
      find.text(StringConstants.totalBalanceText));
  // The owner's add-money button refuses until the store list has loaded.
  if (!_isCustomer) {
    final wallet = Get.find<WalletController>();
    await _until(tester, 'wallet store list', () => wallet.storeList.isNotEmpty);
  }
  await _tap(tester, _asset(ImageConstants.addMoney));
  await _waitFor(tester, find.text(StringConstants.paymentText));
  // Never below the server-configured minimum top-up.
  final min = AppConfig.current.minWalletTopup;
  if (double.parse(amount) < min) amount = min.toStringAsFixed(2);
  await _enterField(tester, StringConstants.amountText, amount);
  FocusManager.instance.primaryFocus?.unfocus();
  await _pumpFor(tester, const Duration(milliseconds: 800));
  await _tap(tester, find.text(StringConstants.cardText));
  await _submit(tester, _cardEnding('4242'));
  await _submit(tester, find.text(StringConstants.addText).last);
  await _waitGone(tester, find.text(StringConstants.paymentText),
      timeout: const Duration(seconds: 45));
  await _backToHome(tester);
}

Future<void> _openAccount(WidgetTester tester) async {
  await _backToHome(tester);
  await _tap(tester, _asset(ImageConstants.user));
  await _waitFor(tester, find.textContaining('Switch to'));
}

/// Account > Switch to Customer / Store. Local only: no API call.
Future<void> _switchRole(WidgetTester tester,
    {required bool toCustomer}) async {
  await _openAccount(tester);
  final label = find.text(toCustomer
      ? StringConstants.switchToCustomerText
      : StringConstants.switchToStoreText);
  await _scrollTo(tester, label);
  await _tap(tester, label);
  await _until(tester, 'role switch', () => _isCustomer == toCustomer);
  await _waitFor(tester, _storesPill.hitTestable());
  debugPrint('[journey] role: ${roleApp.value}');
}

/// Matches Image.asset(name), with or without an explicit scale.
Finder _asset(String name) => find.byWidgetPredicate(
    (w) =>
        w is Image &&
        ((w.image is AssetImage && (w.image as AssetImage).assetName == name) ||
            (w.image is ExactAssetImage &&
                (w.image as ExactAssetImage).assetName == name)),
    description: 'asset $name');

/// The text field whose hint or label is [hint].
Future<void> _enterField(WidgetTester tester, String hint, String text,
    {bool optional = false}) async {
  final field = find.byWidgetPredicate(
      (w) =>
          w is TextField &&
          (w.decoration?.hintText == hint || w.decoration?.labelText == hint),
      description: 'field "$hint"');
  if (optional && field.evaluate().isEmpty) return;
  await _waitFor(tester, field);
  await tester.ensureVisible(field.first);
  await _pumpFor(tester, const Duration(milliseconds: 300));
  await tester.enterText(field.first, text);
  await tester.pump(const Duration(milliseconds: 300));
}

/// Opens the dropdown at [dropdown] and picks its first item.
Future<void> _pickFirst(WidgetTester tester, Finder dropdown) async {
  await _submit(tester, dropdown);
  await _pumpFor(tester, const Duration(milliseconds: 800));
  // The open menu wraps each item in a private InkWell row.
  final menu = find.byWidgetPredicate(
      (w) => w.runtimeType.toString().startsWith('_DropdownMenu<'),
      description: 'open dropdown menu');
  await _tap(tester,
      find.descendant(of: menu, matching: find.byType(InkWell)).first);
  await _pumpFor(tester, const Duration(milliseconds: 800));
}

/// Opens the dropdown at [dropdown] and picks the item reading [text].
Future<void> _pickText(WidgetTester tester, Finder dropdown, String text) async {
  await _submit(tester, dropdown);
  await _pumpFor(tester, const Duration(milliseconds: 800));
  await _tap(tester, find.text(text));
  await _pumpFor(tester, const Duration(milliseconds: 800));
}

/// Scrolls [finder] into view, then taps it.
Future<void> _submit(WidgetTester tester, Finder finder) async {
  await _waitFor(tester, finder);
  await tester.ensureVisible(finder.first);
  await _pumpFor(tester, const Duration(milliseconds: 500));
  await _tap(tester, finder);
}

/// Swipes the Dismissible row holding [finder] left and confirms Delete.
Future<void> _swipeDelete(WidgetTester tester, Finder finder) async {
  await _waitFor(tester, finder);
  await tester.ensureVisible(finder.first);
  await _pumpFor(tester, const Duration(milliseconds: 500));
  await tester.drag(finder.first, const Offset(-600, 0));
  await _waitFor(tester, find.text(AlertStringConstants.areYouSureText));
  await _tap(tester, find.text(StringConstants.deleteText));
}

Future<void> _waitGone(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isEmpty) return;
  }
  throw TestFailure('Still showing after ${timeout.inSeconds}s: $finder');
}

Future<void> _until(WidgetTester tester, String what, bool Function() done,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (done()) return;
  }
  throw TestFailure('Timed out after ${timeout.inSeconds}s waiting for $what');
}

/// Logs the text a user could see, so a failed step shows where it was.
void _dumpScreen() {
  final seen = <String>{};
  for (final e in find.byType(Text).hitTestable().evaluate()) {
    final t = (e.widget as Text).data ?? (e.widget as Text).textSpan?.toPlainText();
    if (t != null && t.trim().isNotEmpty) seen.add(t.trim().replaceAll('\n', ' '));
  }
  debugPrint('[journey]   screen: ${seen.take(40).join(' | ')}');
}

/// Hands image_picker a generated PNG instead of opening the gallery.
class _FakeImagePicker extends ImagePickerPlatform {
  @override
  Future<XFile?> getImageFromSource(
      {required ImageSource source,
      ImagePickerOptions options = const ImagePickerOptions()}) async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFF2E7D32));
    final image = await recorder.endRecording().toImage(300, 300);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ftl_test_image.png');
    await file.writeAsBytes(png!.buffer.asUint8List());
    return XFile(file.path);
  }
}
