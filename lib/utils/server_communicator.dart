class ServerCommunicator {
  // ******************** DEVELOPMENT SERVER ***********

  // String baseUrl = "http://54.190.192.105:3520/api/v1/";
  // String baseUrlWithoutV1 = "http://54.190.192.105:3520/api/";
  // String baseUrlWithoutApi = "http://54.190.192.105:3520/";

  // ********************** STAGING SERVER *************

  String baseUrl = "http://18.224.191.88:3520/api/v1/";
  String baseUrlWithoutV1 = "http://18.224.191.88:3520/api/";
  String baseUrlWithoutApi = "http://18.224.191.88:3520/";

  // ********************** PRODUCTION SERVER *************
  //Not yet!

//********************************* URLS ********************************************************
//A

//B
//C
  String createUser = 'user/create';
  String createItemReview = 'order/item/review/create';
  String createStore = 'store/create';
  String createStoreUser = 'store/user/create';
  String countries = 'utils/countries';
  String createStoreCategory = 'store/category/create';
  String categoryList = 'store/category/list';
  String createProduct = 'store/product/create';
  String createCart = 'shop/store/cart/item/create';
  String cartList = 'shop/store/cart/item/list';
  String createFavouriteStore = 'user/store/favourite/create';
  String createFavouriteProduct = 'user/product/favourite/create';
  String cancelOrder = 'order/cancel/create';
  String createStripeToken = 'https://api.stripe.com/v1/tokens';
  String createCard = 'user/stripe/card/create';
  String createBankToken = 'https://api.stripe.com/v1/tokens';
  String claimStoreRequest = "shop/store/claim/create";

//D
  String deleteWorker = 'store/user/delete';
  String deliveryServiceList = 'store/delivery/service/list';
  String deleteItemFromCart = 'shop/store/cart/item/delete';

//E
  String editWorker = 'store/user/edit';
//F
  String fileUpload = 'file/upload/single';
  String fileUploadMultiple = 'file/upload/multiple';
  String favouriteStoreList = 'shop/stores/list/favourite';

//G
  String generateOtp = 'user/otp/generate';
//H
//I
//J
//K
//L
  String loggedInUserDetail = 'store/user';
  String logoutUser = 'user/logout';

//M
  String messageInboxList = 'message/inbox';
  String messageList = 'message/list';
  String messageSend = 'message/send';
  String messageDelete = 'message/delete';
  String messageStore = 'message/store';

//N
  String nearByStoreList = 'shop/stores/list/nearby';
  String notificationList = 'notification/setting/list';
  String notificationListUrl = 'notification/list';

//O
  String otpVerify = 'user/otp/verify';
  String orderStatusList = 'order/status/list';
  String orderList = 'order/list';
  String orderDetail = 'order/details';
  String ownersStoreList = 'store/list/owners';

//P
  String productDetails = 'store/product/details';
  String placeOrder = 'order/create';
  String pageTerms = 'page/terms';
  String pagePolicy = 'page/privacy';
  String pageFaq = 'page/faq';
  String pageAbout = 'page/about';
  String previousStoreList = 'shop/stores/list/previous';

//Q
//R
  String readyPickup = 'order/ready/pickup';
  String returnOrder = 'order/item/return/create';
  String cancelReturnOrder = 'order/return/cancel';
  String roleList = 'store/role/list';
  String removeFavouriteStore = 'user/store/favourite/remove';
  String removeFavouriteProduct = 'user/product/favourite/delete';
//S
  String states = 'utils/states';
  String storeList = 'store/list';

  String storeDetails = 'store/details';
  String storeDetailsEdit = 'store/details/edit';
  String storeProductList = 'store/product/list';
  String storeProductDetail = 'store/product/details';
  String storeProductEdit = 'store/product/edit';
  String storeUserDetail = 'store/user/details';
  String storeProductDelete = 'store/product/delete';
  String storeCategoryDelete = 'store/category/delete';
  String storeControllerList = 'store/controller/list';
  String storeRoleList = 'store/role/list';
  String storeCategoryDetail = 'store/category/details';
  String storeCategoryEdit = 'store/category/edit';
  String storeRoleCreate = 'store/role/create';
  String storeRoleDelete = 'store/role/delete';
  String storeRoleDetail = 'store/role/details';
  String storeRoleEdit = 'store/role/edit';
  String storeQuantityTypeList = 'store/quantity_type/list';
  String storeOfferCreate = 'store/offer/create';
  String storeOfferEdit = 'store/offer/edit';
  String storeOfferList = 'store/offer/list';
  String shopOffersList = 'shop/offers/list';
  String storeOffersDetails = 'store/offer/details';
  String storeCategoryList = 'shop/store/category/list';
  String storeOffersList = 'shop/store/offers/list';
  String storeFeatureProductList = 'shop/store/product/list';
  String storeOfferDelete = 'store/offer/delete';
  String storeNonOfferProductList = 'store/offer/non_offered_products/list';
  String shopProductDetails = 'shop/store/product/details';
  String shopStoreDetails = 'shop/store/details';
  String shopHomeFeaturedProducts = 'store/home/featured_products';

  String storeOrderList = 'store/order/list';
  String storeDelete = 'store/delete';
  String shopStoreHomeOffers = 'shop/home/offers/list';
  String shopStoreHomeProducts = 'shop/home/products/list';
  String storeOrderDetail = 'store/order/details';
  String storeOrderConfirm = 'store/order/confirm/create';
  String storeOrderShipped = 'store/order/shipped/create';
  String storeOrderPickUp = 'store/order/ready/pickup/create';
  String storeOrderDelivered = 'store/order/delivered/create';
  String storeTransaction = 'store/transaction/list';
  String storeMessageInbox = 'store/message/inbox';
  String storeMessageList = 'store/message/list';
  String storeMessageSend = 'store/message/send';
  String storeMessageDelete = 'store/message/delete';
  String storeConfirmReturnOrder = 'store/order/return/confirm/create';
  String storeCompleteReturnOrder = 'store/order/return/complete/create';
  String storeRejectReturnOrder = 'store/order/return/cancel/create';
  String storeCancelOrder = 'store/order/cancel/create';
  String storeTransactionDetail = 'store/transaction/details';
  String storeWalletBalance = 'store/wallet/balance';
  String storeStripeBankAccountCreate = 'store/stripe/bank/account/create';
  String storeStripePayoutCreate = 'store/stripe/payout/create';
  String shopStoreProductList = 'shop/store/product/list';
  String storeServiceCharge = 'store/service/charge';
  String storeDynamicLinkUpdate = 'store/dynamic/link/update';
  String shopCartActive = 'shop/cart/active';

//T
//U
  String userDetail = 'user/details';
  String updateUser = 'user/details/update';
  String userStore = 'store/list';
  String updateCart = 'shop/store/cart/item/update';
  String userProof = 'user/proof/verification/create';
  String userStripeCardList = 'user/stripe/card/list';
  String userWalletRechargeStripe = 'user/wallet/recharge/stripe';
  String userWalletBalance = 'user/wallet/balance';
  String userStripeCardDelete = 'user/stripe/card/delete';
  String userStripeBankDelete = 'user/stripe/bank/delete';
  String userWalletTransactionList = 'user/wallet/transactions/list';
  String notificationSettingSave = 'notification/setting/save';
  String userWalletTransactionDetail = 'user/wallet/transaction/details';
  String utilsQueryCreate = '/utils/query/create';
  String userStripeBankCreate = 'user/stripe/bank/create';
  String userStripeBankList = 'user/stripe/bank/list';
  String userWalletAutoCharge = 'user/wallet/autocharge/create';
  String userWalletAutoChargeGet = 'user/wallet/autocharge/details';
  String userWalletAutoChargeDelete = 'user/wallet/autocharge/delete';
  String userWalletAutoChargeUpdate = 'user/wallet/autocharge/update';
  String userStoreAccessCreate = 'user/store/access/create';
  String utilMembershipPlans = 'utils/membership/plans';
  String userMembershipCreate = 'user/membership/create';
  String userMembershipList = 'user/membership/list';
  String userDelete = 'user/delete';
  String userStripeConnectedAccountDetails =
      'user/stripe/connected/account/details';

//V
//W
  String workerList = 'store/user/list';

//X
//Y
//Z
}
