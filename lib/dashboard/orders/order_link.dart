import 'dart:convert';

/// Helpers for the pickup/order universal link
/// `https://thegreenmall.net/order/<token>`.
///
/// Mirrors [PaymentLink] (`/pay/<token>`). The customer's "ready for pickup" QR
/// carries this URL instead of a bare JSON string: a store phone with the app
/// installed opens it straight into the order's fulfil screen (iOS Universal
/// Link / Android App Link), and a phone without the app lands on the website's
/// "Get the app" page. The `<token>` is exactly the JSON the QR embeds
/// (`{"type":"order","order_id":..,"store_id":..}`), percent-encoded into one
/// path segment, so the scanner's decode is unchanged — it just unwraps the URL
/// first (see [payloadFromScan]).
///
/// For backward compatibility we also accept the earlier query-string form
/// (`/order?store_id=..&order_id=..`, T2-452) that shipped to internal testing,
/// so a customer on that build and a store on this one keep working, plus the
/// legacy bare-JSON payload from the first cut.
///
/// NOTE: for iOS to open the app instead of Safari, the `/order/*` path must be
/// published in the `apple-app-site-association` file served from
/// thegreenmall.net (the same file that already lists `/pay/*`). Without that,
/// the link resolves to the website — the symptom this replaces.
class OrderLink {
  OrderLink._();

  static const _base = 'https://thegreenmall.net';

  /// Hosts we accept an order link from.
  static const _hosts = {'thegreenmall.net', 'www.thegreenmall.net'};

  /// Builds the universal link a "ready for pickup" QR should encode.
  /// [storeId] / [orderId] may be `int` or `String`; both encode cleanly.
  static String build({required Object storeId, required Object orderId}) {
    final token = Uri.encodeComponent(jsonEncode({
      'type': 'order',
      'order_id': orderId,
      'store_id': storeId,
    }));
    return '$_base/order/$token';
  }

  /// Returns the JSON order payload carried by [value] — for the path form
  /// (`/order/<token>`), the query form (`/order?store_id=..&order_id=..`), or
  /// null when [value] isn't one of our order links (e.g. a `/pay` link or an
  /// unrelated URL). The result is a JSON string the scanner already knows how
  /// to decode.
  static String? extractPayload(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;
    if (!_hosts.contains(uri.host.toLowerCase())) return null;

    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty || segments.first.toLowerCase() != 'order') return null;

    // Path form: the segment after "order" is already percent-decoded by Uri,
    // so it is the original JSON token. No second decode.
    if (segments.length >= 2) {
      final payload = segments.sublist(1).join('/');
      return payload.isEmpty ? null : payload;
    }

    // Query form (legacy internal build): rebuild the JSON from the query.
    final storeId = uri.queryParameters['store_id'];
    final orderId = uri.queryParameters['order_id'];
    if (storeId == null ||
        storeId.isEmpty ||
        orderId == null ||
        orderId.isEmpty) {
      return null;
    }
    return jsonEncode({
      'type': 'order',
      'order_id': orderId,
      'store_id': storeId,
    });
  }

  /// What to hand the order decoder for a scanned value: the unwrapped JSON when
  /// it's one of our order links, otherwise the raw value unchanged so legacy
  /// bare-JSON QR codes keep working.
  static String payloadFromScan(String raw) =>
      extractPayload(raw) ?? raw.trim();

  /// True when [value] is one of our order universal links.
  static bool isOrderLink(String value) => extractPayload(value) != null;
}
