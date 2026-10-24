import 'dart:convert';

/// Maps Stripe API error responses to app-defined user-facing messages,
/// so raw Stripe messages are never shown directly in the UI.
class StripeErrorMapper {
  StripeErrorMapper._();

  static const String defaultCardMessage =
      'Unable to add your card. Please check the details and try again.';
  static const String defaultBankMessage =
      'Unable to add your bank account. Please check the details and try again.';
  static const String serviceUnavailableMessage =
      'Payments are temporarily unavailable. Please try again later.';

  /// Keyed by Stripe error `code` (https://stripe.com/docs/error-codes).
  static const Map<String, String> _codeMessages = {
    // Card number
    'incorrect_number': 'The card number is incorrect. Please re-enter it.',
    'invalid_number': 'The card number is invalid. Please re-enter it.',
    // Expiry
    'invalid_expiry_month': 'The card expiry month is invalid.',
    'invalid_expiry_year': 'The card expiry year is invalid.',
    'expired_card': 'This card has expired. Please use a different card.',
    // CVV
    'invalid_cvc': 'The security code (CVV) is invalid.',
    'incorrect_cvc': 'The security code (CVV) is incorrect.',
    // Declines / processing
    'card_declined': 'Your card was declined. Please use a different card.',
    'processing_error':
        'We could not process your card right now. Please try again.',
    'rate_limit': 'Too many attempts. Please wait a moment and try again.',
    // Address
    'incorrect_zip': 'The ZIP code does not match your card. Please check it.',
    // Bank account
    'routing_number_invalid': 'The routing number is invalid. Please check it.',
    'account_number_invalid': 'The account number is invalid. Please check it.',
    'bank_account_unusable':
        'This bank account cannot be used. Please try a different account.',
    'bank_account_exists': 'This bank account has already been added.',
  };

  /// Returns the app message for a failed Stripe token response body.
  /// [fallback] should be [defaultCardMessage] or [defaultBankMessage].
  static String fromResponseBody(String responseBody, {required String fallback}) {
    try {
      final parsed = jsonDecode(responseBody);
      final error = parsed['error'];
      if (error is! Map) return fallback;

      final mapped = _codeMessages[error['code']];
      if (mapped != null) return mapped;

      // Key/auth problems are our misconfiguration, not the user's input.
      final type = error['type']?.toString();
      if (type == 'authentication_error' || type == 'api_error') {
        return serviceUnavailableMessage;
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }
}
