/// Named routes for the Payments module (registered in lib/navigation/router.dart).
class PaymentRoutes {
  /// Persistent shell that hosts the whole flow and owns the static bottom nav.
  static const flow = '/paymentsFlow';

  /// Nested-navigator id (GetX) used for navigation inside the shell so the
  /// bottom bar stays static while inner screens change.
  static const int navId = 7;

  static const home = '/paymentsHome';
  static const scanner = '/paymentScanner';
  static const details = '/paymentDetails';
  static const review = '/paymentReview';
  static const processing = '/paymentProcessing';
  static const success = '/paymentSuccess';
  static const merchantCode = '/paymentMerchantCode';
}
