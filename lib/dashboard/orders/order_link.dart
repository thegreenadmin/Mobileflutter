import 'dart:convert';

/// Helpers for the pickup/order universal link
/// `https://thegreenmall.net/order/<token>`.
///
/// Mirrors [PaymentLink] (`/pay/<token>`). The customer's "ready for pickup" QR
/// now carries this URL instead of a bare JSON string: a store phone with the
/// app installed opens it straight into the order's fulfil screen (iOS
/// Universal Link / Android App Link), and a phone without the app lands on the
/// website's "Get the app" page. The `<token>` is exactly the JSON the QR used
/// to embed (`{"type":"order","order_id":..,"store_id":..}`), percent-encoded
/// into one path segment, so the scanner's decode is unchanged — it just
/// unwraps the URL first.
///
/// NOTE: for iOS to open the app instead of Safari, the `/order/*` path must be
/// published in the `apple-app-site-association` file served from
/// thegreenmall.net (the same file that already lists `/pay/*`). Without that,
/// the link resolves to the website — which is the symptom this replaces.
class OrderLink {
  OrderLink._();

  static const _base = 'https://thegreenmall.net';

  /// Hosts we accept an `/order/<token>` link from.
  static const _hosts = {'thegreenmall.net', 'www.thegreenmall.net'};

  /// Builds the universal link a "ready for pickup" QR should encode.
  static String build({required String orderId, required String storeId}) {
    final token = Uri.encodeComponent(jsonEncode({
      'type': 'order',
      'order_id': orderId,
      'store_id': storeId,
    }));
    return '$_base/order/$token';
  }

  /// Returns the embedded JSON payload from an `/order/<token>` link, or null
  /// when [value] isn't such a link (e.g. a legacy bare-JSON QR, a `/pay` link,
  /// or an unrelated URL).
  static String? extractPayload(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;
    if (!_hosts.contains(uri.host.toLowerCase())) return null;
    // `pathSegments` is already percent-decoded by Uri, so the segment is the
    // original JSON token. No second decode — that would double-decode.
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length < 2 || segments.first.toLowerCase() != 'order') {
      return null;
    }
    final payload = segments.sublist(1).join('/');
    return payload.isEmpty ? null : payload;
  }

  /// What to hand the order decoder for a scanned value: the unwrapped JSON when
  /// it's an `/order/<token>` link, otherwise the raw value unchanged so legacy
  /// bare-JSON QR codes keep working.
  static String payloadFromScan(String raw) =>
      extractPayload(raw) ?? raw.trim();

  /// True when [value] is an `/order/<token>` universal link.
  static bool isOrderLink(String value) => extractPayload(value) != null;
}
