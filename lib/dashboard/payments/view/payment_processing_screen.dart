import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet_customer.dart';
import 'package:thegreenmall/utils/global_share_data.dart';

import '../controller/payment_controller.dart';
import '../model/payment_intent_model.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// Shows the processing state while the backend authorizes the payment
/// (spec 5.5). Runs biometric (if required) + confirm, with safe retries.
class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  final PaymentController c = Get.find<PaymentController>();
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  Future<void> _process() async {
    setState(() => _failed = false);
    final PaymentIntentModel? result = await c.confirmPayment();
    if (!mounted) return;
    if (result != null && result.isSucceeded) {
      Get.offNamed(PaymentRoutes.success, arguments: {'intent': result});
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _failed, // don't allow back-swipe mid-authorization
      child: Scaffold(
        backgroundColor: PayTheme.background,
        body: _failed
            ? Column(
                children: [
                  PayAppBar(title: 'Payment', onBack: () => Get.back()),
                  Expanded(child: _buildFailed()),
                ],
              )
            : _buildProcessing(),
      ),
    );
  }

  Widget _buildProcessing() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            height: 64,
            width: 64,
            child: CircularProgressIndicator(strokeWidth: 4, color: PayTheme.accent),
          ),
          SizedBox(height: PayTheme.sectionGap),
          Text('Processing your payment', style: PayTheme.cardTitle),
          SizedBox(height: 8),
          Text('Secured with 256-bit encryption', style: PayTheme.bodyMuted),
        ],
      ),
    );
  }

  /// Insufficient balance is recoverable: send the payer to the top-up screen
  /// (like cart checkout), then retry with a FRESH intent — the failed one is
  /// terminal server-side, so re-confirming it only yields INTENT_NOT_PAYABLE
  /// ("no longer valid").
  Future<void> _addMoneyAndRetry() async {
    await Get.to(() => const AddMoneyToWalletUser(isFromCartScreen: true),
        id: pageIdApp.value);
    if (!mounted) return;
    c.startNewAttempt();
    final status = await c.createPayment();
    if (!mounted) return;
    if (status == 'OK') {
      _process();
    } else {
      // createPayment set errorMessage (e.g. a consumed single-use QR session);
      // stay on the failure view with the fresh reason.
      setState(() => _failed = true);
    }
  }

  Widget _buildFailed() {
    // Store-funded sends can't be topped up from this screen; owners add money
    // to a store wallet from the wallet tab.
    final canAddMoney = c.errorCode.value == 'INSUFFICIENT_BALANCE' &&
        c.sourceStore.value == null;
    return PayMessageView(
      icon: Icons.error_outline,
      iconColor: PayTheme.error,
      title: 'Payment not completed',
      message: c.errorMessage.value.isEmpty
          ? 'Something went wrong. Please try again.'
          : c.errorMessage.value,
      actionText: canAddMoney ? 'Add Money to Wallet' : 'Try Again',
      onAction: canAddMoney ? _addMoneyAndRetry : _process,
    );
  }
}
