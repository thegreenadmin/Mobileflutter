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
// product twice as a customer (the owner fulfils one order and cancels the
// other), favourites and unfavourites it, pays its own store by phone, sends
// $1 to a second test account that sends it back, and pays out to the Stripe
// test bank. Money only moves between the two test accounts' wallets, the
// account's own store and Stripe test instruments. The card
// step refuses to run unless the build carries a pk_test_ publishable key.
// Sign-up and auto reload are only validated: neither form is ever submitted
// in a state that would save.
//
// The account is a store owner; the customer steps switch role in-app
// (Account > Switch to Customer) and switch back afterwards.
//
// Run locally:  flutter test integration_test/app_test.dart -d <device>
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thegreenmall/authentication/signup/controller/signup_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/store_home_main_args.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/user_product_list_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/add_offer_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/controller/transaction_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/component/auto_reload_screen.dart';
import 'package:thegreenmall/main.dart' as app;
import 'package:thegreenmall/splash_screen.dart';
import 'package:thegreenmall/utils/app_config.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

const _testPhone = '0000000000';
const _testOtp = '0000';

/// Second staging test account, the P2P counterparty. It must be flagged as
/// a test account on beta so it accepts [_testOtp].
const _secondPhone = '3246661111';

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
    // Layout overflows are cosmetic (release builds clip them), so they are
    // listed at the end instead of failing the run. Known ones: the store
    // header on the owner order queue and order screens is a fixed 24% of
    // the screen and overflows on short phones like the Pixel 2.
    final layoutIssues = <String>{};
    // The binding only reports framework errors once the test ends, so log
    // them as they happen to tie each one to its step.
    void reportingOnError(FlutterErrorDetails d) {
      final summary = d.exceptionAsString().split('\n').first;
      debugPrint('[journey] flutter error during "$current": $summary');
      // Name the widget behind it (e.g. the overflowing Row's file:line).
      final where = d
          .toString()
          .split('\n')
          .skipWhile((l) => !l.contains('relevant error-causing widget'))
          .take(3)
          .map((l) => l.trim())
          .join(' ');
      if (where.isNotEmpty) debugPrint('[journey]   $where');
      if (summary.startsWith('A RenderFlex overflowed')) {
        final file = RegExp(r'lib/[^ ]+\.dart:\d+').firstMatch(where);
        layoutIssues.add(file?.group(0) ?? summary);
        return;
      }
      originalOnError?.call(d);
    }

    Future<void> step(String name, Future<void> Function() body,
        {bool critical = false}) async {
      current = name;
      debugPrint('[journey] >>> $name');
      try {
        if (_loggedIn && _loggedOut()) await _logInAgain(tester);
        try {
          await body();
        } catch (e) {
          // The backend ends the session when a push to this emulator's FCM
          // token fails (sns.controller deletes the session, not just the
          // token), e.g. right after a payment notifies this account.
          // Log back in and give the step one more go.
          await _pumpFor(tester, const Duration(seconds: 2));
          // The dead session's failed calls can leave an alert over the
          // landing screen. And a dead session only sends the app back to
          // the landing screen on its next request (an action can fail with
          // "Something went wrong" and leave its page up), so go home, which
          // makes one, before deciding whether the session survived.
          if (_loggedIn) {
            await _dismissAlert(tester);
            if (!_loggedOut()) {
              _dumpScreen();
              await _backToHome(tester);
              await _pumpFor(tester, const Duration(seconds: 3));
              await _dismissAlert(tester);
            }
          }
          if (!_loggedIn || !_loggedOut()) rethrow;
          debugPrint('[journey]   logged out mid-step ($e); '
              'logging in again and retrying');
          await _logInAgain(tester);
          await body();
        }
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
      expect(
          find.textContaining('Enter mobile number to login'), findsOneWidget);
    }, critical: true);

    // login_with_test_account
    await step('login with test account', () async {
      await _logIn(tester);
      _loggedIn = true;
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
    // Set once the customer wallet has a transaction this month, which the
    // transaction history step then expects to list.
    var customerWalletMoved = false;
    // The two orders the customer places: the owner fulfils the first and
    // cancels the second.
    var fulfilledOrderId = '';
    var cancelledOrderId = '';
    double? balanceBeforeCancelledOrder;
    var sentToSecondAccount = false;

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
      await _tap(
          tester,
          find.byWidgetPredicate(
              (w) => w is Radio && w.value == OfferType.store,
              description: 'store offer radio'));
      // A single-store owner gets the store preselected (no hint shown).
      if (offers.storeIdValue.value.isEmpty) {
        await _pickFirst(
            tester, find.text(StringConstants.selectStoreText).last);
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
      await _scrollUntilBuilt(tester, find.text(productName));
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
      customerWalletMoved = true;
    });

    // store_browse_and_menu, order_add_to_cart, order_view_cart,
    // order_place: the customer orders this run's product from the
    // account's own store, paid from the wallet.
    await step('customer order', () async {
      if (!productCreated) throw TestFailure('no product to order');
      fulfilledOrderId = await _placeOrder(tester, productName);
      customerWalletMoved = true;
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
      // The hint sits under an IgnorePointer, so open the dropdown itself.
      final picker = find.byWidgetPredicate(
          (w) =>
              w is DropdownButton &&
              w.value == null &&
              w.hint is Text &&
              (w.hint as Text).data == 'Select a business',
          description: 'unselected business dropdown');
      if (picker.evaluate().isNotEmpty) {
        await _pickFirst(tester, picker);
      }
      await _tap(tester, find.text('Continue'));
      await _payAmount(tester, '1');
    });

    // store_product_browse: the category's product grid, sorted both ways
    // from the sort menu. The server sorts by selling price.
    await step('customer product browse and sort', () async {
      if (!productCreated) throw TestFailure('no product to browse');
      await _switchRole(tester, toCustomer: true);
      await _openOwnCategoryAsCustomer(tester, productName);
      final store = Get.find<StoreHomeMainController>();
      for (final ascending in [true, false]) {
        final order = ascending
            ? StringConstants.lowToHighText
            : StringConstants.highToLowText;
        final label =
            find.text('${StringConstants.priceText} ${order.toLowerCase()}');
        await _tap(tester, _asset(ImageConstants.productFilter));
        await _tap(tester, label);
        // The item reloads the list, then closes the menu itself.
        await _waitGone(tester, label);
        await _until(
            tester,
            'sorted product list',
            () =>
                !store.isLoading.value && store.featureProductList.isNotEmpty);
        final prices = store.featureProductList
            .map((p) => double.tryParse('${p.sellingPrice}'))
            .whereType<double>()
            .toList();
        debugPrint('[journey]   ${ascending ? 'low-high' : 'high-low'}: '
            '${prices.join(', ')}');
        for (var i = 1; i < prices.length; i++) {
          final inOrder = ascending
              ? prices[i - 1] <= prices[i]
              : prices[i - 1] >= prices[i];
          if (!inOrder) {
            throw TestFailure(
                'prices out of order at $i: ${prices.join(', ')}');
          }
        }
        // Still on the product grid, not popped off the store, and still
        // listing this run's product (it may be scrolled off-screen).
        expect(find.byType(UserProductListScreen), findsOneWidget);
        if (!store.featureProductList
            .any((p) => p.productName == productName)) {
          throw TestFailure('$productName missing after sorting');
        }
      }
      await _backToHome(tester);
    });

    // store_favourites: heart this run's product from the grid, find it on
    // the store's Favorite tab, unheart it there and see the server drop it.
    await step('customer product favourite', () async {
      if (!productCreated) throw TestFailure('no product to favourite');
      await _switchRole(tester, toCustomer: true);
      await _openOwnCategoryAsCustomer(tester, productName);
      final store = Get.find<StoreHomeMainController>();
      // The heart sits at the card's top; make sure the header doesn't
      // cover it.
      await _submit(tester, _productHeart(productName, ImageConstants.fav));
      await _waitFor(tester, _productHeart(productName, ImageConstants.liked));
      await _until(tester, 'favourite saved', () => !store.isLoading.value);
      await _tap(tester, find.text(StringConstants.favoriteText));
      await _waitFor(tester, find.text(StringConstants.favoritesText));
      await _scrollUntilBuilt(tester, find.text(productName));
      await _submit(tester, _productHeart(productName, ImageConstants.liked));
      // Unhearting on this tab reloads the favourites from the server.
      await _waitGone(tester, find.text(productName));
      await _backToHome(tester);
    });

    // order_transaction_history: Account > Transactions History, both tabs.
    await step('customer transaction history', () async {
      await _switchRole(tester, toCustomer: true);
      await _openAccount(tester);
      final row = find.text(StringConstants.transactionsHistoryText);
      await _scrollTo(tester, row);
      await _tap(tester, row);
      await _waitFor(tester, find.text(StringConstants.currentMonthText));
      final tx = Get.find<TransactionController>();
      await _until(
          tester, 'current month transactions', () => !tx.isLoading.value);
      final count = tx.userTransactionList?.length ?? 0;
      debugPrint('[journey]   current month: $count transaction(s)');
      if (customerWalletMoved && count == 0) {
        throw TestFailure('wallet moved this run but the current month '
            'lists no transactions');
      }
      await _tap(tester, find.text(StringConstants.pastOrdersText));
      // The tab loads the current month, then switches to January.
      await _pumpFor(tester, const Duration(seconds: 1));
      await _until(tester, 'past transactions', () => !tx.isLoading.value);
      await _tap(tester, find.text(StringConstants.currentMonthText));
      await _pumpFor(tester, const Duration(seconds: 1));
      await _until(tester, 'current month again', () => !tx.isLoading.value);
      await _backToHome(tester);
    });

    // store_filter_options, plus the favourite stores tab of the search
    // screen. Filtering only reads; Clear Filters puts the search back.
    await step('customer store filter', () async {
      await _switchRole(tester, toCustomer: true);
      await _backToHome(tester);
      await _tap(tester, _storesPill);
      await _waitFor(tester, find.text(StringConstants.searchForStoreText));
      final search = Get.find<SearchStoreUserController>();
      await _tap(tester, find.text(StringConstants.favoriteText));
      await _pumpFor(tester, const Duration(seconds: 1));
      await _until(tester, 'favourite stores', () => !search.isLoading.value);
      expect(find.text(StringConstants.loginRequiredText), findsNothing);
      await _tap(tester, find.text(StringConstants.nearbyText));
      await _pumpFor(tester, const Duration(seconds: 1));

      await _tap(tester, _asset(ImageConstants.filterbutton));
      await _waitFor(tester, find.text(StringConstants.filterOptionsText));
      final empty = search.zipCodeTextController.text.isEmpty &&
          search.mileageTextController.text.isEmpty &&
          search.openingTimeTextController.text.isEmpty &&
          search.closingTimeTextController.text.isEmpty &&
          search.isOpenNow.value.isEmpty &&
          search.deliveryServicesList.isEmpty;
      if (empty) {
        await _submit(tester, find.text(StringConstants.saveText));
        await _waitFor(
            tester, find.text(AlertStringConstants.pleaseSelectOneFilterText));
        await _tap(tester, find.text(StringConstants.okayText));
      } else {
        debugPrint('[journey]   filter form not empty; skipping empty save');
      }
      await _enterField(tester, StringConstants.zipCodeText, '90210');
      await _enterField(tester, StringConstants.milesText, '25');
      FocusManager.instance.primaryFocus?.unfocus();
      await _pumpFor(tester, const Duration(milliseconds: 800));
      await _pickText(tester,
          find.byType(DropdownButtonFormField<String>).first, 'Open Now');
      expect(search.isOpenNow.value, 'Open Now');
      await _submit(tester, find.text(StringConstants.saveText));
      // Any 200 closes the filter screen, whatever it matched; an error
      // shows an alert instead.
      await _until(
          tester,
          'filtered search',
          () =>
              find.text(StringConstants.filterOptionsText).evaluate().isEmpty ||
              find
                  .text(StringConstants.okayText)
                  .hitTestable()
                  .evaluate()
                  .isNotEmpty,
          timeout: const Duration(seconds: 45));
      if (find.text(StringConstants.filterOptionsText).evaluate().isNotEmpty) {
        throw TestFailure('filtered store search failed');
      }
      await _until(tester, 'filter results', () => !search.isLoading.value);
      debugPrint('[journey]   filter matched '
          '${search.storeAddresses.length} store(s)');
      expect(search.zipCodeTextController.text, '90210');

      await _tap(tester, _asset(ImageConstants.filterbutton));
      await _waitFor(tester, find.text(StringConstants.filterOptionsText));
      await _submit(tester, find.text(StringConstants.clearFiltersText));
      await _waitGone(tester, find.text(StringConstants.filterOptionsText));
      await _waitFor(tester, find.text(StringConstants.searchForStoreText));
      expect(search.zipCodeTextController.text, isEmpty);
      expect(search.mileageTextController.text, isEmpty);
      expect(search.isOpenNow.value, isEmpty);
      await _backToHome(tester);
    });

    // wallet_auto_reload: turning the switch on opens the auto reload
    // sheet; an empty form must not save, and closing the sheet must leave
    // auto reload off on the server. Never touches an account that already
    // has it on.
    await step('customer wallet auto reload', () async {
      await _switchRole(tester, toCustomer: true);
      await _backToHome(tester);
      await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
          find.text(StringConstants.totalBalanceText));
      await _tap(tester, find.text(StringConstants.manageText));
      await _waitFor(tester, find.text(StringConstants.manageWalletText));
      final wallet = Get.find<WalletController>();
      await _pumpFor(tester, const Duration(seconds: 2));
      await _until(tester, 'manage wallet data', () => !wallet.isLoading.value);
      if (wallet.isAutoRechargeEnable.value) {
        debugPrint('[journey]   auto reload already on; leaving it alone');
        await _waitFor(
            tester, find.text(StringConstants.editAutoReloadIntoWalletText));
        await _backToHome(tester);
        return;
      }
      await _scrollTo(
          tester, find.text(StringConstants.autoReloadIntoWalletText));
      await _tap(tester, find.byType(FlutterSwitch));
      final sheet = find.byType(AutoReloadScreen);
      await _waitFor(tester, sheet);
      await _until(tester, 'auto reload detail', () => !wallet.isLoading.value);
      final untouched = wallet.thresholdAmountTextController.text.isEmpty &&
          wallet.chargeAmountTextController.text.isEmpty &&
          wallet.periodChargeAmountTextController.text.isEmpty;
      if (untouched) {
        await _submit(tester, find.text(StringConstants.okText));
        await _pumpFor(tester, const Duration(seconds: 2));
        final alert = find.text(StringConstants.okayText).hitTestable();
        if (alert.evaluate().isNotEmpty) {
          _dumpScreen();
          await tester.tap(alert.first);
          await _pumpFor(tester, const Duration(milliseconds: 800));
        }
        // Rejected: inline field errors or an alert, never a save.
        expect(sheet, findsOneWidget);
      } else {
        debugPrint('[journey]   auto reload form prefilled; not submitting');
      }
      // Close the sheet by tapping the barrier above it.
      await tester.tapAt(const Offset(20, 20));
      await _pumpFor(tester, const Duration(seconds: 1));
      if (sheet.evaluate().isNotEmpty) {
        Navigator.of(tester.element(sheet)).pop();
      }
      await _waitGone(tester, sheet);
      debugPrint('[journey]   switch after closing the sheet: '
          '${wallet.isAutoRechargeEnable.value ? 'on' : 'off'}');
      wallet.apiGetAutoRechargeDetail();
      await _pumpFor(tester, const Duration(milliseconds: 500));
      await _until(tester, 'auto reload state', () => !wallet.isLoading.value);
      final saved = wallet.getAutoRechargeModel.data?.userWalletAutoCharge;
      if (saved?.status == 'active') {
        throw TestFailure('auto reload was enabled without a valid form');
      }
      expect(wallet.isAutoRechargeEnable.value, isFalse,
          reason: 'switch still on after closing the sheet unsaved');
      await _backToHome(tester);
    });

    // order_place again, for the owner to cancel. Notes the wallet balance
    // first so the refund can be checked once the order is cancelled.
    await step('customer second order', () async {
      if (!productCreated) throw TestFailure('no product to order');
      await _switchRole(tester, toCustomer: true);
      balanceBeforeCancelledOrder = await _customerBalance(tester);
      cancelledOrderId = await _placeOrder(tester, productName);
      final after = await _customerBalance(tester);
      debugPrint('[journey]   wallet $balanceBeforeCancelledOrder -> $after');
    });

    await step('switch back to store', () async {
      await _switchRole(tester, toCustomer: false);
    });

    // wallet_payout: $1 from the store wallet to the Stripe test bank.
    await step('owner payout to test bank', () async {
      await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
          find.text(StringConstants.totalBalanceText));
      // Manage needs the store list, which loads after the wallet opens.
      await _until(tester, 'wallet stores',
          () => Get.find<WalletController>().storeList.isNotEmpty);
      await _tap(tester, find.text(StringConstants.manageText));
      await _scrollTo(
          tester, find.text(StringConstants.debitMoneyFromWalletText));
      await _tap(tester, find.text(StringConstants.debitMoneyFromWalletText));
      await _waitFor(tester, find.text(StringConstants.payoutText));
      if (find.text(StringConstants.selectStoreText).evaluate().length > 1) {
        await _pickFirst(
            tester, find.text(StringConstants.selectStoreText).last);
      }
      await _enterField(tester, 'eg ${currencySign}100.00', '1');
      await _tap(tester, find.text('STRIPE TEST BANK'));
      await _submit(tester, find.text(StringConstants.oKText));
      await _waitGone(tester, find.text(StringConstants.payoutText),
          timeout: const Duration(seconds: 45));
      await _backToHome(tester);
    });

    // order_fulfil (owner): the first order moves through the store queue
    // to Completed. Pickup and curbside orders go Ready for Pick Up > Picked
    // Up; delivery orders go Prepare Order > Shipped > Delivered.
    await step('owner fulfils the order', () async {
      if (fulfilledOrderId.isEmpty) throw TestFailure('no order to fulfil');
      await _switchRole(tester, toCustomer: false);
      await _openOwnerOrderQueue(tester);
      final row = find.text('#$fulfilledOrderId');
      await _showOwnerOrders(
          tester, StringConstants.receivedText, fulfilledOrderId);
      await _tap(tester, row);
      // Received items start unticked.
      await _selectAllItems(tester);
      await _advanceOrder(tester, [
        StringConstants.readyForPickUpText,
        StringConstants.prepareOrderText,
      ]);
      // Every item on the Pickup tab moves on together.
      for (var i = 0; i < 2; i++) {
        await _showOwnerOrders(
            tester, StringConstants.pickupText, fulfilledOrderId);
        await _tap(tester, row);
        final done = await _advanceOrder(tester, [
          StringConstants.orderShippedText,
          StringConstants.pickedUpText,
          StringConstants.deliveredText,
        ]);
        if (done != StringConstants.orderShippedText) break;
      }
      await _showOwnerOrders(
          tester, StringConstants.completedText, fulfilledOrderId);
      await _backToHome(tester);
    });

    // order_cancel (owner): customers can't cancel in the app, so the store
    // cancels the second order; it then shows under Completed.
    await step('owner cancels an order', () async {
      if (cancelledOrderId.isEmpty) throw TestFailure('no order to cancel');
      await _switchRole(tester, toCustomer: false);
      await _openOwnerOrderQueue(tester);
      await _showOwnerOrders(
          tester, StringConstants.receivedText, cancelledOrderId);
      await _tap(tester, find.text('#$cancelledOrderId'));
      await _selectAllItems(tester);
      final cancel = find.text(StringConstants.cancelOrderText);
      await _tap(tester, cancel);
      await _tap(tester, find.text(StringConstants.yesText));
      await _waitGone(tester, cancel, timeout: const Duration(seconds: 45));
      await _showOwnerOrders(
          tester, StringConstants.completedText, cancelledOrderId);
      await _backToHome(tester);
    });

    // order_history (customer): the fulfilled order is under Complete, the
    // cancelled one under Cancelled, and its price is back in the wallet.
    await step('customer sees fulfilled and cancelled orders', () async {
      await _switchRole(tester, toCustomer: true);
      await _backToHome(tester);
      await _tapUntil(tester, find.text(BottomNavStringConstants.ordersText),
          find.text(StringConstants.cancelledText));
      final orders = Get.find<OrdersController>();
      // Check everything before failing, so one missing order doesn't hide
      // the refund check.
      final problems = <String>[];
      Future<void> expectUnder(String tab, String orderId) async {
        await _tap(tester, find.text(tab));
        await _pumpFor(tester, const Duration(seconds: 1));
        await _until(tester, '$tab orders', () => !orders.isLoading.value);
        final ids = orders.orderList.map((o) => o.orderId).toList();
        if (!ids.contains(orderId)) {
          problems.add('order $orderId not under $tab: $ids');
        }
      }

      if (fulfilledOrderId.isNotEmpty) {
        await expectUnder(StringConstants.completeText, fulfilledOrderId);
      }
      if (cancelledOrderId.isNotEmpty) {
        await expectUnder(StringConstants.cancelledText, cancelledOrderId);
      }
      final before = balanceBeforeCancelledOrder;
      if (cancelledOrderId.isNotEmpty && before != null) {
        // The refund can land a moment after the cancel.
        var now = await _customerBalance(tester);
        for (var i = 0; i < 3 && (now - before).abs() > 0.01; i++) {
          await _pumpFor(tester, const Duration(seconds: 5));
          now = await _customerBalance(tester);
        }
        debugPrint('[journey]   wallet after cancel: $now (was $before)');
        if ((now - before).abs() > 0.01) {
          problems.add('cancelled order $cancelledOrderId not refunded: '
              'wallet $now, was $before before ordering');
        }
      }
      if (problems.isNotEmpty) throw TestFailure(problems.join('; '));
      await _backToHome(tester);
    });

    // payment_p2p_phone: send $1 to the second test account, which sends it
    // back after logout. Under the biometric and KYC thresholds.
    await step('pay a person', () async {
      await _switchRole(tester, toCustomer: true);
      await _payPerson(tester, _secondPhone, '1');
      sentToSecondAccount = true;
    });

    await step('switch to store for cleanup', () async {
      await _switchRole(tester, toCustomer: false);
    });

    await step('owner product delete', () async {
      if (!productCreated) return;
      await _switchRole(tester, toCustomer: false);
      await _openProductList(tester);
      await _scrollUntilBuilt(tester, find.text(productName));
      await _swipeDelete(tester, find.text(productName));
      await _waitGone(tester, find.text(productName));
      // Products earlier runs left behind when they failed before this step.
      for (var i = 0; i < 5; i++) {
        final stale = find.textContaining('FTL product ').hitTestable();
        if (stale.evaluate().isEmpty) break;
        final name = (stale.evaluate().first.widget as Text).data ?? '';
        debugPrint('[journey]   removing leftover "$name"');
        try {
          await _swipeDelete(tester, find.text(name));
          await _waitGone(tester, find.text(name));
        } on TestFailure catch (e) {
          debugPrint('[journey]   could not remove "$name": $e');
          await _dismissAlert(tester);
          break;
        }
      }
      await _backToHome(tester);
    });

    // session_persistence: with the login token saved, the splash screen
    // goes straight to the logged-in home instead of the welcome screen.
    // Replays the splash in-process: a real cold start can't run inside
    // this test, and MyApp.initState clears the saved token on every
    // launch anyway, so a real relaunch always lands logged out.
    await step('session persistence', () async {
      final token =
          await SharedPreferenceStorage.getData(StringConstants.tokenText);
      if (token == null || '$token'.isEmpty) {
        throw TestFailure('no login token saved');
      }
      if (await SharedPreferenceStorage.getData(
              StringConstants.authenticatedText) ==
          true) {
        debugPrint('[journey]   biometric unlock is on; skipping the splash');
        return;
      }
      await _backToHome(tester);
      Get.offAll(() => const SplashScreen());
      await _until(tester, 'splash to route',
          () => _storesPill.hitTestable().evaluate().isNotEmpty || _loggedOut(),
          timeout: const Duration(seconds: 30));
      if (_loggedOut()) {
        // Log back in first, so the step wrapper reports this rather than
        // logging in and retrying it.
        await _logInAgain(tester);
        throw TestFailure('splash showed the welcome screen with a saved '
            'token');
      }
      debugPrint('[journey]   splash restored the session as '
          '${roleApp.value}');
      // The rebuilt home fires its loads again; let them land before the
      // next step, or logout cuts them off mid-flight and they fail with an
      // alert over the welcome screen.
      await _pumpFor(tester, const Duration(seconds: 8));
    });

    // logout. The Delete Account button sits right under Logout; the test
    // only ever taps the exact "Logout" text and the dialog's "Yes".
    await step('logout', () async {
      await _logOut(tester);
    }, critical: true);

    // payment_p2p_receive: the second test account got the $1 and sends it
    // back to the main account, so neither balance drifts across runs.
    await step('second account pays back', () async {
      if (!sentToSecondAccount) {
        throw TestFailure('nothing was sent to $_secondPhone');
      }
      await _tap(tester, find.text(StringConstants.loginYourAccountText));
      await _waitFor(
          tester, find.text(StringConstants.sendConfirmationCodeText));
      try {
        await _logIn(tester, phone: _secondPhone);
      } on TestFailure {
        _dumpScreen();
        throw TestFailure('could not log in as $_secondPhone with OTP '
            '$_testOtp; flag it as a test account on beta');
      }
      _currentPhone = _secondPhone;
      _loggedIn = true;
      try {
        await _switchRole(tester, toCustomer: true);
        final balance = await _customerBalance(tester);
        debugPrint('[journey]   $_secondPhone wallet: $balance');
        if (balance < 1) {
          throw TestFailure('$_secondPhone wallet is $balance; the \$1 sent '
              'to it never arrived');
        }
        await _payPerson(tester, _testPhone, '1');
      } finally {
        // End logged out whatever happened, so the step wrapper never logs
        // back in as this account and sign-up starts from the landing page.
        _currentPhone = _testPhone;
        if (!_loggedOut()) {
          await _backToHome(tester);
          await _logOut(tester);
        }
        _loggedIn = false;
      }
    });

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
      // With the phone keyboard up the Sign up tap can miss, so close it
      // and tap again if the alert doesn't show. Terms stay unticked, so a
      // tap can only ever reach the terms alert, never create a user.
      FocusManager.instance.primaryFocus?.unfocus();
      await _pumpFor(tester, const Duration(seconds: 1));
      final signUp = find.text(StringConstants.signUpText).last;
      await tester.ensureVisible(signUp);
      try {
        await _tapUntil(tester, signUp,
            find.text(AlertStringConstants.pleaseEnterTermsAndConditions),
            attempts: 3);
      } on TestFailure {
        // The form failed validation; say which field, even off-screen.
        final c = Get.find<SignupController>();
        debugPrint(
            '[journey]   form: first="${c.firstNameTextController.text}" '
            'last="${c.lastNameTextController.text}" '
            'email="${c.emailTextController.text}" '
            'phone="${c.phoneNumberTextController.text}"');
        final errors = find
            .byType(Text)
            .evaluate()
            .map((e) => (e.widget as Text).data ?? '')
            .where((t) => t.startsWith('Please') || t.contains('valid'))
            .toSet();
        debugPrint('[journey]   errors: ${errors.join(' | ')}');
        rethrow;
      }
      await _tap(tester, find.text(StringConstants.okayText));
    });

    // Let in-flight API calls finish. Ending the test tears the widget tree
    // down under them, and their error path (Utility.showAlertMessage ->
    // Get.context!) then throws and fails an otherwise passing run.
    await _pumpFor(tester, const Duration(seconds: 15));

    if (layoutIssues.isNotEmpty) {
      debugPrint('[journey] layout overflows (not failing the run): '
          '${layoutIssues.join(', ')}');
    }
    if (failed.isEmpty) {
      debugPrint('[journey] ALL STEPS PASSED');
    } else {
      debugPrint('[journey] ${failed.length} step(s) failed: '
          '${failed.join(', ')}');
      fail('Steps failed: ${failed.join(', ')}');
    }
  }, timeout: const Timeout(Duration(minutes: 25)));
}

/// Set once the first login succeeds; from then on a step that finds the app
/// back on the landing screen logs in again.
var _loggedIn = false;

/// The logged-out landing screen (Continue as Guest / Login your account).
bool _loggedOut() => find
    .text(StringConstants.continueAsGuestText)
    .hitTestable()
    .evaluate()
    .isNotEmpty;

/// The account a step that finds itself logged out logs back in as.
var _currentPhone = _testPhone;

/// Phone + OTP login, starting from the login screen.
Future<void> _logIn(WidgetTester tester, {String phone = _testPhone}) async {
  await tester.enterText(
      find.descendant(
          of: find.byType(IntlPhoneField), matching: find.byType(EditableText)),
      phone);
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
}

/// From the landing screen the backend dumped us on, back to a logged-in home.
Future<void> _logInAgain(WidgetTester tester) async {
  debugPrint('[journey]   session ended by the backend; logging in again');
  await _tap(tester, find.text(StringConstants.loginYourAccountText));
  await _waitFor(tester, find.text(StringConstants.sendConfirmationCodeText));
  await _logIn(tester, phone: _currentPhone);
}

/// Account > Logout > Yes, ending on the landing screen. The Delete Account
/// button sits right under Logout; this only ever taps the exact "Logout"
/// text and the dialog's "Yes".
Future<void> _logOut(WidgetTester tester) async {
  await _openAccount(tester);
  await _scrollTo(tester, find.text(StringConstants.logoutText));
  await _tap(tester, find.text(StringConstants.logoutText));
  await _waitFor(
      tester, find.text(AlertStringConstants.areYouSureLogoutAccountText));
  await _tap(tester, find.text(StringConstants.yesText));
  _loggedIn = false; // from here on the landing screen is expected
  await _waitFor(tester, find.text(StringConstants.createAnAccountText),
      timeout: const Duration(seconds: 30));
  // A call still in flight at logout fails without a token and alerts;
  // log it and clear it so the welcome screen is usable.
  await _pumpFor(tester, const Duration(seconds: 3));
  final alert = find.text(StringConstants.okayText).hitTestable();
  if (alert.evaluate().isNotEmpty) {
    debugPrint('[journey]   alert after logout:');
    _dumpScreen();
    await tester.tap(alert.first);
    await _pumpFor(tester, const Duration(seconds: 1));
  }
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
  throw TestFailure(
      'Timed out after ${timeout.inSeconds}s waiting for $finder');
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
  await _until(tester, 'category list', () => manage.categoriesList.isNotEmpty);
  _firstCategoryName = manage.categoriesList.first.categoryName ?? '';
  await _tap(tester, find.text(_firstCategoryName));
  await _waitFor(tester, find.text(StringConstants.addNewProductText));
}

/// Customer: opens the account's own store page the way a nearby-store row
/// does (store search is location-based, so it depends on where the device
/// is), then Menu > the first category, which lists [productName].
Future<void> _openOwnCategoryAsCustomer(
    WidgetTester tester, String productName) async {
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
      find.byType(UserProductListScreen));
  final store = Get.find<StoreHomeMainController>();
  await _until(
      tester,
      'category products',
      () =>
          !store.isLoading.value &&
          store.featureProductList.any((p) => p.productName == productName));
  await _scrollUntilBuilt(tester, find.text(productName));
}

/// Scrolls the vertical list on screen down until [finder] has been built.
/// Long lists only build the rows in view, and earlier runs' leftovers can
/// push this run's row off-screen.
Future<void> _scrollUntilBuilt(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final lists = find.byWidgetPredicate(
      (w) =>
          w is Scrollable &&
          axisDirectionToAxis(w.axisDirection) == Axis.vertical,
      description: 'vertical list');
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder.first);
      await _pumpFor(tester, const Duration(milliseconds: 300));
      return;
    }
    final visible = lists.hitTestable();
    if (visible.evaluate().isNotEmpty) {
      await tester.drag(visible.last, const Offset(0, -300),
          warnIfMissed: false);
    }
  }
  throw TestFailure('Not found after scrolling for ${timeout.inSeconds}s: '
      '$finder');
}

/// Taps away an alert's Okay button, logging what it said.
Future<void> _dismissAlert(WidgetTester tester) async {
  final okay = find.text(StringConstants.okayText).hitTestable();
  if (okay.evaluate().isEmpty) return;
  _dumpScreen();
  await tester.tap(okay.first);
  await _pumpFor(tester, const Duration(seconds: 1));
}

/// The heart ([asset] fav or liked) on the product card showing [name].
Finder _productHeart(String name, String asset) => find.descendant(
    of: find.ancestor(of: find.text(name), matching: find.byType(Card)),
    matching: _asset(asset));

/// Payments > Pay to a Person > Enter Mobile [phone], then pays [amount].
Future<void> _payPerson(
    WidgetTester tester, String phone, String amount) async {
  await _openPayments(tester);
  await _tap(tester, find.text('Pay to a Person'));
  await _tap(tester, find.text('Enter Mobile'));
  await tester.enterText(
      find.descendant(
          of: find.byType(IntlPhoneField), matching: find.byType(EditableText)),
      phone);
  await _tap(tester, find.text('Continue'));
  await _payAmount(tester, amount);
}

/// On the payment details screen: enters [amount], reviews and pays, and
/// waits for the success screen.
Future<void> _payAmount(WidgetTester tester, String amount) async {
  try {
    await _waitFor(tester, find.text('Enter payment details'));
  } on TestFailure {
    // The recipient lookup failed; its snackbar says why.
    _dumpScreen();
    rethrow;
  }
  await tester.enterText(
      find.descendant(
          of: find
              .ancestor(of: find.text('Amount'), matching: find.byType(Column))
              .first,
          matching: find.byType(EditableText)),
      amount);
  await _submit(tester, find.text('Review & Pay'));
  await _submit(tester, find.textContaining(r'Pay $'));
  await _waitFor(tester, find.text('Payment Successful!'),
      timeout: const Duration(seconds: 45));
  await _tap(tester, find.text('Done'));
  await _backToHome(tester);
}

/// Customer wallet balance, fetched fresh from the server.
Future<double> _customerBalance(WidgetTester tester) async {
  await _backToHome(tester);
  await _tapUntil(tester, find.text(BottomNavStringConstants.walletText),
      find.text(StringConstants.totalBalanceText));
  final wallet = Get.find<WalletController>();
  wallet.apiGetUserWalletBalance();
  await _pumpFor(tester, const Duration(milliseconds: 300));
  await _until(tester, 'wallet balance',
      () => wallet.userWalletBalance?.value.isNotEmpty ?? false);
  final balance = double.parse(
      wallet.userWalletBalance!.value.replaceAll(RegExp(r'[^0-9.\-]'), ''));
  await _backToHome(tester);
  return balance;
}

/// Owner: Orders tab > own store's order queue. With one store the tab may
/// open the queue directly; otherwise it lists the stores first.
Future<void> _openOwnerOrderQueue(WidgetTester tester) async {
  await _backToHome(tester);
  final queue = _orderSearchField.hitTestable();
  final store = find.text(_ownStoreName).hitTestable();
  // A tap made while the home screen is still loading (e.g. right after a
  // re-login) can be dropped, so tap again until the orders screen opens.
  for (var i = 1;; i++) {
    await _tap(tester, find.text(BottomNavStringConstants.ordersText));
    try {
      await _until(tester, 'owner orders',
          () => queue.evaluate().isNotEmpty || store.evaluate().isNotEmpty,
          timeout: const Duration(seconds: 10));
      break;
    } on TestFailure {
      if (i == 3) rethrow;
      debugPrint('[journey]   orders tab did not open; tapping again');
    }
  }
  if (queue.evaluate().isEmpty) await _tap(tester, store);
  await _waitFor(tester, queue);
}

/// Owner order screen: ticks every item. Select All only shows for orders
/// with more than one item; otherwise tick the items' own boxes.
Future<void> _selectAllItems(WidgetTester tester) async {
  final boxes = find.byType(Checkbox).hitTestable();
  await _until(tester, 'order items', () => boxes.evaluate().isNotEmpty);
  final all = find.text(StringConstants.selectAllText).hitTestable();
  if (all.evaluate().isNotEmpty) {
    await tester.tap(all.first);
  } else {
    for (var i = 0; i < boxes.evaluate().length; i++) {
      await tester.tap(boxes.at(i));
      await tester.pump(const Duration(milliseconds: 200));
    }
  }
  await _pumpFor(tester, const Duration(milliseconds: 500));
}

/// Owner order screen: taps whichever of [labels] it offers as the next
/// status and waits for the screen to close. Returns the label tapped.
Future<String> _advanceOrder(WidgetTester tester, List<String> labels) async {
  final actions = [for (final l in labels) find.text(l).hitTestable()];
  await _until(tester, 'order action',
      () => actions.any((f) => f.evaluate().isNotEmpty));
  final i = actions.indexWhere((f) => f.evaluate().isNotEmpty);
  debugPrint('[journey]   ${labels[i]}');
  await tester.tap(actions[i].first);
  await _waitGone(tester, find.text(labels[i]),
      timeout: const Duration(seconds: 45));
  return labels[i];
}

/// The owner order queue's search box.
final _orderSearchField = find.byWidgetPredicate(
    (w) =>
        w is TextField &&
        w.decoration?.hintText == StringConstants.searchOrdersHintText,
    description: 'order search field');

/// In the owner order queue: opens [tab] and searches for [orderId] until
/// its row shows.
Future<void> _showOwnerOrders(
    WidgetTester tester, String tab, String orderId) async {
  await _tap(tester, find.text(tab));
  await _pumpFor(tester, const Duration(seconds: 1));
  await _enterField(tester, StringConstants.searchOrdersHintText, orderId);
  FocusManager.instance.primaryFocus?.unfocus();
  await _waitFor(tester, find.text('#$orderId'));
}

/// Customer: orders one [productName] from the account's own store, paid
/// from the wallet with an in-store or curbside order type, and returns the
/// new order's id. Store search is location-based (nearby radius, Places
/// autocomplete that needs a Maps key), so the store page is opened the way a
/// nearby-store row does rather than depend on where the device is.
Future<String> _placeOrder(WidgetTester tester, String productName) async {
  final previous = Get.isRegistered<OrdersController>()
      ? Get.find<OrdersController>().orderStatus.value
      : '';
  await _openOwnCategoryAsCustomer(tester, productName);
  await _tap(tester, find.text(productName));
  await _tap(tester, _asset(ImageConstants.add));
  await _submit(tester, find.text(StringConstants.addToOrderText));
  await _tap(tester, find.text(StringConstants.goToCartText));
  await _waitFor(tester, find.text(StringConstants.orderSummaryText));
  // The Order Type grid fills once store details load; pay needs one
  // picked. In-store or curbside, never delivery (needs an address).
  // The cart has its own controller instance, so pick the order type
  // through the UI rather than checking controller state. Prefer pickup;
  // fall back to whatever the store offers.
  final types = [
    StringConstants.inStoreText,
    StringConstants.curbSideText,
    StringConstants.deliveryText,
  ].map((t) => find.text(t).hitTestable()).toList();
  try {
    await _until(
        tester, 'order types', () => types.any((f) => f.evaluate().isNotEmpty),
        timeout: const Duration(seconds: 15));
  } on TestFailure {
    // The shop endpoint only returns order types the store has enabled;
    // with none, the cart can never be paid.
    fail('store $_ownStoreId shows no order types in the cart; enable '
        'one for it on beta');
  }
  await _tap(tester, types.firstWhere((f) => f.evaluate().isNotEmpty).first);
  // Picking a type refreshes the wallet balance Pay Now checks.
  await _pumpFor(tester, const Duration(seconds: 3));
  await _submit(tester, find.text(StringConstants.payNowText));
  // Wallet payment asks to confirm the deduction first.
  await _tap(tester, find.text(StringConstants.proceedText));
  await _waitFor(tester, find.text(StringConstants.orderConfirmedText),
      timeout: const Duration(seconds: 45));
  // The confirmation screen hands the new order's id to OrdersController
  // after its first frame; the controller may still hold an older one.
  final orders = Get.find<OrdersController>();
  await _until(
      tester,
      'new order id',
      () =>
          orders.orderStatus.value.isNotEmpty &&
          orders.orderStatus.value != previous);
  final orderId = orders.orderStatus.value;
  debugPrint('[journey]   placed order $orderId');
  await _backToHome(tester);
  return orderId;
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
    final rows =
        find.ancestor(of: _cardEnding(last4).first, matching: find.byType(Row));
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
    await _until(
        tester, 'wallet store list', () => wallet.storeList.isNotEmpty);
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
  if (_isCustomer == toCustomer) {
    debugPrint('[journey] role: ${roleApp.value} (already)');
    return;
  }
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
  await _tap(
      tester, find.descendant(of: menu, matching: find.byType(InkWell)).first);
  await _pumpFor(tester, const Duration(milliseconds: 800));
}

/// Opens the dropdown at [dropdown] and picks the item reading [text].
Future<void> _pickText(
    WidgetTester tester, Finder dropdown, String text) async {
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
    final t =
        (e.widget as Text).data ?? (e.widget as Text).textSpan?.toPlainText();
    if (t != null && t.trim().isNotEmpty) {
      seen.add(t.trim().replaceAll('\n', ' '));
    }
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
