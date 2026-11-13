/// Signed dynamic QR returned by /payment/qr/generate, rendered with qr_flutter.
class QrPayloadModel {
  final String qrString;
  final String sessionId;
  final DateTime? expiresAt;
  final int validitySeconds;

  QrPayloadModel({
    required this.qrString,
    required this.sessionId,
    this.expiresAt,
    required this.validitySeconds,
  });

  factory QrPayloadModel.fromJson(Map<String, dynamic> json) {
    return QrPayloadModel(
      qrString: json['qr_string'] ?? '',
      sessionId: json['session_id'] ?? '',
      expiresAt:
          json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt'].toString()) : null,
      validitySeconds: json['validity_seconds'] ?? 300,
    );
  }
}
