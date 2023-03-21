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
  String storeCategoryDeatil = 'store/category/details';
  String storeCategoryEdit = 'store/category/edit';
  String storeRoleList = 'store/role/list';
  String storeRoleCreate = 'store/role/create';

//D
  String deleteWorker = 'store/user/delete';
//E
  String editWorker = 'store/user/edit';
//F
  String fileUpload = 'file/upload/single';
  String fileUploadMultiple = 'file/upload/multiple';

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
  String storeProductList = 'store/product/list';
  String storeProductDetail = 'store/product/details';
  String storeProductEdit = 'store/product/edit';
  String storeUserDetail = 'store/user/details';
  String storeProductDelete = 'store/product/delete';
  String storeCategoryDelete = 'store/category/delete';
  String storeControllerList = 'store/controller/list';

//T
//U
  String userDetail = 'user/details';
  String updateUser = 'user/details/update';
  String userStore = 'store/list';

//V
//W
  String workerList = 'store/user/list';

//X
//Y
//Z
}
