import 'payment_recipient.dart';

/// Mirrors the backend payment_intent record returned by /payment/create and
/// /payment/confirm.
class PaymentIntentModel {
  final int? id;
  final String? idempotencyKey;
  final String type; // 'p2p' | 'p2b'
  final double amount;
  final double fee;
  final double total;
  final String currency;
  final String status; // created | processing | succeeded | failed | cancelled | expired
  final bool biometricRequired;
  final String? note;
  final int? transactionId;

  /// Sender wallet balance after a successful confirm (confirm response only).
  final double? walletBalance;

  /// Present on the create response.
  final PaymentRecipient? recipient;

  PaymentIntentModel({
    this.id,
    this.idempotencyKey,
    required this.type,
    required this.amount,
    required this.fee,
    required this.total,
    required this.currency,
    required this.status,
    required this.biometricRequired,
    this.note,
    this.transactionId,
    this.walletBalance,
    this.recipient,
  });

  bool get isSucceeded => status == 'succeeded';

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  // BIGINT ids come back from the backend as either String or int.
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      id: _toInt(json['id']),
      idempotencyKey: json['idempotency_key'],
      type: json['type'] ?? 'p2p',
      amount: _toDouble(json['amount']),
      fee: _toDouble(json['fee']),
      total: _toDouble(json['total']),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'created',
      biometricRequired: json['biometric_required'] == true,
      note: json['note'],
      transactionId: _toInt(json['transaction_id']),
      walletBalance:
          json['wallet_balance'] != null ? _toDouble(json['wallet_balance']) : null,
      recipient: json['recipient'] != null
          ? PaymentRecipient.fromJson(Map<String, dynamic>.from(json['recipient']))
          : null,
    );
  }
}
