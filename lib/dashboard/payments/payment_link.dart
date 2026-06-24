/// Helpers for the payment universal link `https://thegreenmall.net/pay/<token>`.
///
/// One QR now carries that URL instead of a bare token: installed apps open it
/// directly (iOS Universal Link / Android App Link), and people without the app
/// land on the website's "Get the app" page. The `<token>` is exactly the signed
/// payload the backend used to put in the bare QR, so the decode endpoint is
/// unchanged — the client just unwraps the URL before calling it.
class PaymentLink {
  PaymentLink._();

  /// Hosts we accept a `/pay/<token>` link from.
  static const _hosts = {'thegreenmall.net', 'www.thegreenmall.net'};

  /// Returns the `<token>` from a `https://thegreenmall.net/pay/<token>` value,
  /// URL-decoded, or null when [value] isn't such a link (e.g. a legacy opaque
  /// QR payload, or an unrelated URL).
  static String? extractToken(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;
    if (!_hosts.contains(uri.host.toLowerCase())) return null;
    // `pathSegments` is already percent-decoded by Uri, so the segment is the
    // original signed JSON token (the backend percent-encodes it into one path
    // segment). No second decode — that would be a fragile double-decode.
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length < 2 || segments.first.toLowerCase() != 'pay') return null;
    final token = segments.sublist(1).join('/');
    return token.isEmpty ? null : token;
  }

  /// What to hand the decode endpoint for a scanned value: the unwrapped token
  /// when it's a `/pay/<token>` link, otherwise the raw value unchanged so older
  /// opaque QR codes keep working.
  static String payloadFromScan(String raw) => extractToken(raw) ?? raw.trim();
}
