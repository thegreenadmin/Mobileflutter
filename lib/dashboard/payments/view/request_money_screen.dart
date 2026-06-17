import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';

/// "Request money" — a customer asks a specific person to pay them. They enter
/// the person's mobile number + amount, then either generate a scannable code
/// (amount baked in) or text the request via the backend SMS service.
class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen> {
  final PaymentController c = Get.find<PaymentController>();
  final _phoneController = TextEditingController();
  final _amountCtrl = TextEditingController();

  // Matches the registration/login flow: digits in the field, dial code via flag.
  String _phoneNumber = '';
  String _countryCode = '+1';
  bool _sending = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountCtrl.text.trim()) ?? 0;

  String get _phone =>
      _phoneNumber.isNotEmpty ? _phoneNumber : _phoneController.text.trim();

  /// Generating a code only needs the amount — the code is "pay me $X".
  void _generateBarcode() {
    if (_amount <= 0) {
      Utility.showToast('Enter a valid amount');
      return;
    }
    Get.toNamed(
      PaymentRoutes.merchantCode,
      id: PaymentRoutes.navId,
      arguments: {
        'actor_type': 'user',
        'amount': _amount,
        'title': 'Request \$${_amount.toStringAsFixed(2)}',
        'subtitle': 'Let them scan to pay you',
      },
    );
  }

  /// Texting the request needs both the mobile number and the amount.
  Future<void> _sendText() async {
    if (_phone.isEmpty || _amount <= 0) {
      Utility.showToast('Enter a mobile number and amount');
      return;
    }
    setState(() => _sending = true);
    final ok = await c.sendPaymentRequestSms(
      phone: _phone,
      phoneCode: _countryCode,
      amount: _amount,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      Utility.showToast('Payment request sent');
      Get.back(id: PaymentRoutes.navId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        children: [
          const PayAppBar(
            title: 'Request money',
            subtitle: 'Ask someone to pay you',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: PayTheme.hPad, vertical: PayTheme.sectionGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mobile number', style: PayTheme.label),
                  const SizedBox(height: 8),
                  IntlPhoneField(
                    initialCountryCode: StringConstants.usText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _phoneController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    showDropdownIcon: false,
                    flagsButtonMargin: const EdgeInsets.all(10),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(ImageConstants.calling),
                      alignLabelWithHint: true,
                      hintText: StringConstants.mobileText,
                      hintStyle: const TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            const BorderSide(color: AppColors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.0),
                      ),
                    ),
                    onCountryChanged: (value) {
                      setState(() => _countryCode = "+${value.dialCode}");
                    },
                    onChanged: (phone) {
                      _phoneNumber = phone.number;
                      _countryCode = phone.countryCode;
                    },
                  ),
                  const SizedBox(height: PayTheme.sectionGap),
                  const Text('Amount', style: PayTheme.label),
                  const SizedBox(height: 8),
                  PayCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: PayTheme.itemGap, vertical: 4),
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: PayTheme.primaryText),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: PayTheme.primaryText),
                        hintText: '0.00',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Generate a code for them to scan, or text the request to their mobile number.',
                    style: PayTheme.caption,
                  ),
                  const SizedBox(height: PayTheme.sectionGap),
                  PayButton(
                    text: 'Generate barcode',
                    onTap: _amount > 0 ? _generateBarcode : null,
                  ),
                  const SizedBox(height: PayTheme.itemGap),
                  _SecondaryButton(
                    text: 'Send text',
                    loading: _sending,
                    onTap: (_phone.isNotEmpty && _amount > 0) ? _sendText : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Outlined secondary CTA, matching the primary [PayButton] dimensions.
class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool loading;
  const _SecondaryButton(
      {required this.text, this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !loading;
    return SizedBox(
      width: double.infinity,
      height: PayTheme.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: PayTheme.accent,
          side: BorderSide(
              color: enabled
                  ? PayTheme.accent
                  : PayTheme.accent.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        icon: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: PayTheme.accent),
              )
            : const Icon(Icons.sms_outlined, size: 20),
        label: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
