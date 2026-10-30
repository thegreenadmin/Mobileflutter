/// Resolved payee for a P2P or P2B payment (from QR decode or manual lookup).
class PaymentRecipient {
  /// 'p2p' (a user) or 'p2b' (a store/merchant)
  final String type;
  final int? userId;
  final int? storeId;

  /// Per-store merchant code, when this payee is a business. Used as the payee
  /// reference for /payment/create (same key a merchant-id lookup would set).
  final int? merchantId;
  final String name;
  final String? phone;
  final String? phoneCode;
  final String? image;

  /// Session id carried from a scanned dynamic QR (replay-guarded server side).
  final String? sessionId;

  /// Fixed amount baked into a merchant "request" code, if any. When set, the
  /// payer cannot change the amount (it is enforced server side).
  final double? fixedAmount;

  PaymentRecipient({
    required this.type,
    this.userId,
    this.storeId,
    this.merchantId,
    required this.name,
    this.phone,
    this.phoneCode,
    this.image,
    this.sessionId,
    this.fixedAmount,
  });

  bool get isMerchant => type == 'p2b';

  /// True when the merchant baked a positive amount into the code.
  bool get hasFixedAmount => fixedAmount != null && fixedAmount! > 0;

  // Backend may return ids as either String or int.
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  // Backend sends image as either a plain URL string or an object
  // {orignal_url, dynamic_url} (the S3 signed-url shape).
  static String? _toImageUrl(dynamic v) {
    if (v == null) return null;
    if (v is String) return v.isEmpty ? null : v;
    if (v is Map) return v['dynamic_url'] ?? v['orignal_url'];
    return null;
  }

  factory PaymentRecipient.fromJson(Map<String, dynamic> json) {
    return PaymentRecipient(
      type: json['type'] ?? 'p2p',
      userId: _toInt(json['user_id']),
      storeId: _toInt(json['store_id']),
      merchantId: _toInt(json['merchant_id']),
      name: json['name'] ?? '',
      phone: json['phone'],
      phoneCode: json['phone_code'],
      image: _toImageUrl(json['image']),
      sessionId: json['session_id'],
      fixedAmount: _toDouble(json['amount']),
    );
  }
}
