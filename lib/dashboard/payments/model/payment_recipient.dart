/// Resolved payee for a P2P or P2B payment (from QR decode or manual lookup).
class PaymentRecipient {
  /// 'p2p' (a user) or 'p2b' (a store/merchant)
  final String type;
  final int? userId;
  final int? storeId;
  final String name;
  final String? phone;
  final String? phoneCode;
  final String? image;

  /// Session id carried from a scanned dynamic QR (replay-guarded server side).
  final String? sessionId;

  PaymentRecipient({
    required this.type,
    this.userId,
    this.storeId,
    required this.name,
    this.phone,
    this.phoneCode,
    this.image,
    this.sessionId,
  });

  bool get isMerchant => type == 'p2b';

  // Backend may return ids as either String or int.
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  factory PaymentRecipient.fromJson(Map<String, dynamic> json) {
    return PaymentRecipient(
      type: json['type'] ?? 'p2p',
      userId: _toInt(json['user_id']),
      storeId: _toInt(json['store_id']),
      name: json['name'] ?? '',
      phone: json['phone'],
      phoneCode: json['phone_code'],
      image: json['image'],
      sessionId: json['session_id'],
    );
  }
}
