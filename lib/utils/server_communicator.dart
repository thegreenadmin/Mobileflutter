class ServerCommunicator {
  String baseUrl = "http://54.190.192.105:3520/api/v1/";
  String baseUrlWithoutV1 = "http://54.190.192.105:3520/api/";

//A
//B
//C
  String createUser = 'user/create';
  String createStore = 'store/create';
  String createStoreUser = 'store/user/create';
  String countries = 'utils/countries';
  String createStoreCategory = 'store/category/create';
  String categoryList = 'store/category/list';
  String createProduct = 'store/product/create';
  String createCart = 'shop/store/cart/item/create';
  String cartList = 'shop/store/cart/item/list';

//D
  String deleteWorker = 'store/user/delete';
  String deliveryServiceList = 'store/delivery/service/list';
  String deleteItemFromCart = 'shop/store/cart/item/delete';
//E
  String editWorker = 'store/user/edit';
//F
  String fileUpload = 'file/upload/single';
  String fileUploadMultiple = 'file/upload/multiple';
  String createFavouriteStore = 'user/store/favourite/create';

//G
  String generateOtp = 'user/otp/generate';
//H
//I
//J
//K
//L
//M
//N
  String nearByStoreList = 'shop/stores/list/nearby';
//O
  String otpVerify = 'user/otp/verify';
//P

  String productDetails = 'store/product/details';
//Q
//R

  String roleList = 'store/role/list';
  String removeFavouriteStore = 'user/store/favourite/remove';
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
  String storeCategoryDeatil = 'store/category/details';
  String storeCategoryEdit = 'store/category/edit';
  String storeRoleCreate = 'store/role/create';
  String storeRoleDelete = 'store/role/delete';
  String storeRoleDetail = 'store/role/details';
  String storeRoleEdit = 'store/role/edit';
  String storeQuantityTypeList = 'store/quantity_type/list';
  String storeOfferCreate = 'store/offer/create';
  String storeOfferList = 'store/offer/list';
  String shopeOffersList = 'shop/offers/list';
  String storeOffersDetails = 'store/offer/details';
  String storeCategoryList = 'shop/store/category/list';
  String storeOffersList = 'shop/store/offers/list';
  String storeFeatureProductList = 'shop/store/product/list';
  String storeOfferDelete = 'store/offer/delete';
  String shopProductDetails = 'shop/store/product/details';
  String shopStoreDetails = 'shop/store/details';

//T
//U
  String userDetail = 'user/details';
  String updateUser = 'user/details/update';
  String userStore = 'store/list';
  String updateCart = 'shop/store/cart/item/update';

//V
//W
  String workerList = 'store/user/list';

//X
//Y
//Z
}
