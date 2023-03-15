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

//D
//E
  String editWorker = 'store/user/edit';
//F
  String fileUpload = 'file/upload/single';

//G
  String generateOtp = 'user/otp/generate';
//H
//I
//J
//K
//L
//M
//N
//O
  String otpVerify = 'user/otp/verify';
//P
//Q
//R
//S
  String states = 'utils/states';
  String storeList = 'store/list';
  String storeDetails = 'store/details';
  String storeDetailsEdit = 'store/details/edit';
  String storeProductList = 'store/product/list?';

//T
//U
  String userDetail = 'user/details';
  String updateUser = 'user/details/update';
  String userStore = 'store/list';

//V
//W
//X
//Y
//Z
}
