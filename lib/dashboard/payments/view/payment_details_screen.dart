import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/home/model/get_user_store_list_model.dart';

import '../controller/payment_controller.dart';
import '../payment_routes.dart';
import 'component/pay_theme.dart';
import 'component/pay_widgets.dart';
import 'kyc_required_sheet.dart';

/// Enter the amount and an optional note before review (spec 5.3).
class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final PaymentController c = Get.find<PaymentController>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  static const int _noteMax = 50; // configurable server-side; mirrored for UX

  @override
  void initState() {
    super.initState();
    _amount.text = c.amountText.value;
    _note.text = c.note.value;
    // A store owner paying a person or business picks which of their stores
    // funds the send. Make sure the store list is loaded, then default to the
    // first one.
    if (_showSourcePicker) {
      if (c.ownerStores.isEmpty) {
        c.fetchOwnerStores().then((_) => _defaultSourceStore());
      } else {
        _defaultSourceStore();
      }
    }
  }

  /// The "Pay from" store selector is owner-only, shown for both P2P (paying a
  /// person) and P2B (paying another business) so the owner can choose which of
  /// their stores funds the send.
  bool get _showSourcePicker => c.isStoreOwner;

  void _defaultSourceStore() {
    if (!mounted) return;
    if (c.sourceStore.value == null && c.ownerStores.isNotEmpty) {
      c.sourceStore.value = c.ownerStores.first;
    }
  }

  Future<void> _reviewAndPay() async {
    c.amountText.value = _amount.text.trim();
    c.note.value = _note.text.trim();
    if (c.amount <= 0) {
      _toast('Enter a valid amount');
      return;
    }
    // Owners must pick a funding store when they have one.
    if (_showSourcePicker &&
        c.ownerStores.isNotEmpty &&
        c.sourceStore.value == null) {
      _toast('Select which store to pay from');
      return;
    }

    final result = await c.createPayment();
    if (!mounted) return;
    if (result == 'OK') {
      Get.toNamed(PaymentRoutes.review, id: PaymentRoutes.navId);
    } else if (result == 'KYC_REQUIRED') {
      showKycRequiredSheet(context, message: c.errorMessage.value);
    } else {
      _toast(c.errorMessage.value);
    }
  }

  Widget _buildSourceStorePicker() {
    return Obx(() {
      if (c.storesLoading.value && c.ownerStores.isEmpty) {
        return const PayCard(
          child: Row(
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: PayTheme.accent),
              ),
              SizedBox(width: 12),
              Text('Loading your stores…', style: PayTheme.bodyMuted),
            ],
          ),
        );
      }
      if (c.ownerStores.isEmpty) return const SizedBox.shrink();
      // Keep the selection valid if the list reloads.
      final selected = c.sourceStore.value != null &&
              c.ownerStores
                  .any((s) => s.storeId == c.sourceStore.value!.storeId)
          ? c.sourceStore.value
          : null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pay from', style: PayTheme.label),
          const SizedBox(height: 8),
          PayCard(
            padding: const EdgeInsets.symmetric(horizontal: PayTheme.itemGap),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserStoresList>(
                isExpanded: true,
                value: selected,
                hint: const Text('Choose a store', style: PayTheme.bodyMuted),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: PayTheme.secondaryText),
                items: c.ownerStores
                    .map((s) => DropdownMenuItem<UserStoresList>(
                          value: s,
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_wallet_outlined,
                                  color: PayTheme.accent, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  s.storeName ?? 'Store',
                                  overflow: TextOverflow.ellipsis,
                                  style: PayTheme.body,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (s) => c.sourceStore.value = s,
              ),
            ),
          ),
        ],
      );
    });
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(m),
        backgroundColor: PayTheme.error,
        behavior: SnackBarBehavior.floating,
      ));

  @override
  Widget build(BuildContext context) {
    final r = c.recipient.value;
    return Scaffold(
      backgroundColor: PayTheme.background,
      body: Column(
        children: [
          PayAppBar(
            title: r?.isMerchant == true ? 'Pay to a Business' : 'Pay to a Person',
            subtitle: 'Enter payment details',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: PayTheme.hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Recipient
                  Column(
                    children: [
                      PayAvatar(imageUrl: r?.image, name: r?.name ?? '', size: 72),
                      const SizedBox(height: 12),
                      Text(r?.name ?? '', style: PayTheme.cardTitle),
                      if (r?.phone != null && r!.phone!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('${r.phoneCode ?? ''} ${r.phone}'.trim(),
                              style: PayTheme.bodyMuted),
                        ),
                    ],
                  ),
                  const SizedBox(height: PayTheme.sectionGap),
                  // Pay from (store owners only): choose the funding store.
                  if (_showSourcePicker) ...[
                    _buildSourceStorePicker(),
                    const SizedBox(height: PayTheme.itemGap),
                  ],
                  // Amount
                  PayCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amount', style: PayTheme.label),
                            if (r?.hasFixedAmount == true)
                              Row(
                                children: const [
                                  Icon(Icons.lock_outline,
                                      size: 14, color: PayTheme.secondaryText),
                                  SizedBox(width: 4),
                                  Text('Set by merchant', style: PayTheme.caption),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text('\$ ', style: PayTheme.largeHeader),
                            Expanded(
                              child: TextField(
                                controller: _amount,
                                readOnly: r?.hasFixedAmount == true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                style: PayTheme.largeHeader,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                ],
                                decoration: const InputDecoration(
                                  hintText: '0.00',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: PayTheme.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('USD', style: PayTheme.label),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PayTheme.itemGap),
                  // Note
                  PayCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Add a note (optional)', style: PayTheme.label),
                            ValueListenableBuilder(
                              valueListenable: _note,
                              builder: (_, value, __) => Text(
                                '${value.text.length} / $_noteMax',
                                style: PayTheme.caption,
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          controller: _note,
                          maxLength: _noteMax,
                          maxLines: 2,
                          buildCounter: (_,
                                  {required currentLength, required isFocused, maxLength}) =>
                              null,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Dinner',
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(PayTheme.hPad),
              child: PayButton(text: 'Review & Pay', onTap: _reviewAndPay),
            ),
          ),
        ],
      ),
    );
  }
}
