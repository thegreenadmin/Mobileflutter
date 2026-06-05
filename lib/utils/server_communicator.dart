import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerCommunicator {

  // ******************** DEVELOPMENT SERVER ***********

  // String baseUrl = "http://172.24.0.202:8080/api/v1/";
  // String baseUrlWithoutV1 = "http://172.24.0.202:8080/api/";
  // String baseUrlWithoutApi = "http://172.24.0.202:8080/";

  // ********************** STAGING SERVER *************

  // String baseUrl = "http://18.224.191.88:3520/api/v1/";
  // String baseUrlWithoutV1 = "http://18.224.191.88:3520/api/";
  // String baseUrlWithoutApi = "http://18.224.191.88:3520/";

  // ********************** PRODUCTION SERVER *************
  static String get baseUrlWithoutApi => dotenv.env['BASE_URL_WO_API'] ?? 'http://172.24.0.53:8080/';
  static String get baseUrl => '${baseUrlWithoutApi}api/v1/';
  static String get baseUrlWithoutV1 => '${baseUrlWithoutApi}api/';
  static String get kGoogleApiKey => dotenv.env['GOOGLE_MAP_KEY'] ?? '';
  static String get stripeCardBasicAuth => dotenv.env['STRIPE_CARD_BASIC_AUTH'] ?? '';
  static String get stripeBankBasicAuth => dotenv.env['STRIPE_BANK_BASIC_AUTH'] ?? '';
  static String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';


  // String baseUrl = "https://cn3m3t9wyd.execute-api.us-east-1.amazonaws.com/api/v1/";
  // String baseUrlWithoutV1 = "https://cn3m3t9wyd.execute-api.us-east-1.amazonaws.com/api/";
  // String baseUrlWithoutApi = "https://cn3m3t9wyd.execute-api.us-east-1.amazonaws.com/";

//********************************* URLS **********************

  // Staging API URL:    https://tfq2tvvrsc.execute-api.us-east-1.amazonaws.com
  // Prod API URL:    https://cn3m3t9wyd.execute-api.us-east-1.amazonaws.com
  // Local API URL:    http://172.24.0.53:8080
//A

//B
//C
  static const createUser = 'user/create';
  static const createItemReview = 'order/item/review/create';
  static const hereNotification = 'order/iamherenotification';
  static const createStore = 'store/create';
  static const createStoreUser = 'store/user/create';
  static const countries = 'utils/countries';
  static const createStoreCategory = 'store/category/create';
  static const categoryList = 'store/category/list';
  static const createProduct = 'store/product/create';
  static const createCart = 'shop/store/cart/item/create';
  static const cartList = 'shop/store/cart/item/list';
  static const createFavouriteStore = 'user/store/favourite/create';
  static const createFavouriteProduct = 'user/product/favourite/create';
  static const cancelOrder = 'order/cancel/create';
  static String get createStripeToken => dotenv.env['STRIPE_API_URL'] ?? 'https://api.stripe.com/v1/tokens';
  static const createCard = 'user/stripe/card/create';
  static String get createBankToken => dotenv.env['STRIPE_API_URL'] ?? 'https://api.stripe.com/v1/tokens';
  static const claimStoreRequest = "shop/store/claim/create";

//D
  static const deleteWorker = 'store/user/delete';
  static const deliveryServiceList = 'store/delivery/service/list';
  static const deleteItemFromCart = 'shop/store/cart/item/delete';

//E
  static const editWorker = 'store/user/edit';
//F
  static const fileUpload = 'file/upload/single';
  static const fileUploadMultiple = 'file/upload/multiple';
  static const favouriteStoreList = 'shop/stores/list/favourite';

//G
  static const generateOtp = 'user/otp/generate';
//H
//I
//J
//K
//L
  static const loggedInUserDetail = 'store/user';
  static const logoutUser = 'user/logout';

//M
  static const messageInboxList = 'message/inbox';
  static const messageList = 'message/list';
  static const messageSend = 'message/send';
  static const messageDelete = 'message/delete';
  static const messageStore = 'message/store';

//N
  static const nearByStoreList = 'shop/stores/list/nearby';
  static const notificationList = 'notification/setting/list';
  static const notificationListUrl = 'notification/list';

//O
  static const otpVerify = 'user/otp/verify';
  static const orderStatusList = 'order/status/list';
  static const orderList = 'order/list';
  static const orderDetail = 'order/details';
  static const ownersStoreList = 'store/list/owners';
  static const ownerWalletRechargeStripe = 'store/stripe/recharge';

//P
  static const productDetails = 'store/product/details';
  static const placeOrder = 'order/create';
  static const pageTerms = 'page/terms';
  static const pagePolicy = 'page/privacy';
  static const pageFaq = 'page/faq';
  static const pageAbout = 'page/about';
  static const previousStoreList = 'shop/stores/list/previous';
  static const paymentIntent = 'user/wallet/recharge/paymentMethod';

//Q
//R
  static const readyPickup = 'order/ready/pickup';
  static const returnOrder = 'order/item/return/create';
  static const cancelReturnOrder = 'order/return/cancel';
  static const roleList = 'store/role/list';
  static const removeFavouriteStore = 'user/store/favourite/remove';
  static const removeFavouriteProduct = 'user/product/favourite/delete';
//S
  static const states = 'utils/states';
  static const storeList = 'store/list';

  static const storePermissionsList = 'store/permissions';

  static const storeDetails = 'store/details';
  static const storeDetailsEdit = 'store/details/edit';
  static const storeProductList = 'store/product/list';
  static const storeProductDetail = 'store/product/details';
  static const storeProductEdit = 'store/product/edit';
  static const storeUserDetail = 'store/user/details';
  static const storeProductDelete = 'store/product/delete';
  static const storeCategoryDelete = 'store/category/delete';
  static const storeControllerList = 'store/controller/list';
  static const storeRoleList = 'store/role/list';
  static const storeCategoryDetail = 'store/category/details';
  static const storeCategoryEdit = 'store/category/edit';
  static const storeRoleCreate = 'store/role/create';
  static const storeRoleDelete = 'store/role/delete';
  static const storeRoleDetail = 'store/role/details';
  static const storeRoleEdit = 'store/role/edit';
  static const storeQuantityTypeList = 'store/quantity_type/list';
  static const storeOfferCreate = 'store/offer/create';
  static const storeOfferEdit = 'store/offer/edit';
  static const storeOfferList = 'store/offer/list';
  static const shopOffersList = 'shop/offers/list';
  static const storeOffersDetails = 'store/offer/details';
  static const storeCategoryList = 'shop/store/category/list';
  static const storeOffersList = 'shop/store/offers/list';
  static const storeFeatureProductList = 'shop/store/product/list';
  static const storeOfferDelete = 'store/offer/delete';
  static const storeNonOfferProductList = 'store/offer/non_offered_products/list';
  static const shopProductDetails = 'shop/store/product/details';
  static const shopStoreDetails = 'shop/store/details';
  static const shopHomeFeaturedProducts = 'store/home/featured_products';

  static const storeOrderList = 'store/order/list';
  static const storeDelete = 'store/delete';
  static const shopStoreHomeOffers = 'shop/home/offers/list';
  static const shopStoreHomeProducts = 'shop/home/products/list';
  static const storeOrderDetail = 'store/order/details';
  static const storeOrderConfirm = 'store/order/confirm/create';
  static const storeOrderShipped = 'store/order/shipped/create';
  static const storeOrderPickUp = 'store/order/ready/pickup/create';
  static const storeOrderDelivered = 'store/order/delivered/create';
  static const storeTransaction = 'store/transaction/list';
  static const storeMessageInbox = 'store/message/inbox';
  static const storeMessageList = 'store/message/list';
  static const storeMessageSend = 'store/message/send';
  static const storeMessageDelete = 'store/message/delete';
  static const storeConfirmReturnOrder = 'store/order/return/confirm/create';
  static const storeCompleteReturnOrder = 'store/order/return/complete/create';
  static const storeRejectReturnOrder = 'store/order/return/cancel/create';
  static const storeCancelOrder = 'store/order/cancel/create';
  static const storeTransactionDetail = 'store/transaction/details';
  static const storeWalletBalance = 'store/wallet/balance';
  static const storeStripeBankAccountCreate = 'store/stripe/bank/account/create';
  static const storeStripePayoutCreate = 'store/stripe/payout/create';
  static const shopStoreProductList = 'shop/store/product/list';
  static const storeServiceCharge = 'store/service/charge';
  static const storeDynamicLinkUpdate = 'store/dynamic/link/update';
  static const shopCartActive = 'shop/cart/active';

//T
//U
  static const unclaimedStoreList = 'store/unclaimed';
  static const userDetail = 'user/details';
  static const updateUser = 'user/details/update';
  static const userStore = 'store/list';
  static const updateCart = 'shop/store/cart/item/update';
  static const userProof = 'user/proof/verification/create';
  static const userStripeCardList = 'user/stripe/card/list';
  static const userWalletRechargeStripe = 'user/wallet/recharge/stripe';
  static const userWalletBalance = 'user/wallet/balance';
  static const userStripeCardDelete = 'user/stripe/card/delete';
  static const userStripeBankDelete = 'user/stripe/bank/delete';
  static const userWalletTransactionList = 'user/wallet/transactions/list';
  static const notificationSettingSave = 'notification/setting/save';
  static const userWalletTransactionDetail = 'user/wallet/transaction/details';
  static const utilsQueryCreate = 'utils/query/create';
  static const userStripeBankCreate = 'user/stripe/bank/create';
  static const userStripeBankList = 'user/stripe/bank/list';
  static const userWalletAutoCharge = 'user/wallet/autocharge/create';
  static const userWalletAutoChargeGet = 'user/wallet/autocharge/details';
  static const userWalletAutoChargeDelete = 'user/wallet/autocharge/delete';
  static const userWalletAutoChargeUpdate = 'user/wallet/autocharge/update';
  static const userStoreAccessCreate = 'user/store/access/create';
  static const utilMembershipPlans = 'utils/membership/plans';
  static const userMembershipCreate = 'user/membership/create';
  static const userMembershipList = 'user/membership/list';
  static const userDelete = 'user/delete';
  static const userStripeConnectedAccountDetails = 'user/stripe/connected/account/details';
  static const userPaymentMethod = "user/wallet/recharge/paymentMethod";

  // P2P & P2B barcode payments
  static const paymentRecipientLookup = 'user/payment/recipient/lookup';
  static const paymentQrGenerate = 'user/payment/qr/generate';
  static const paymentQrDecode = 'user/payment/qr/decode';
  static const paymentCreate = 'user/payment/create';
  static const paymentConfirm = 'user/payment/confirm';
  static const paymentCancel = 'user/payment/cancel';
  static const paymentStatus = 'user/payment/status';

//V
//W
  static const workerList = 'store/user/list';

//X
//Y
//Z
}
