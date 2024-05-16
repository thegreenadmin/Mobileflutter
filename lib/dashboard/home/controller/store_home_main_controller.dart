import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../../offers/controller/offers_controller.dart';

class StoreHomeMainController extends GetxController {
  Rx<StoreDetailsResponse> storeDetailsResponse = StoreDetailsResponse().obs;
  late StoreOffersListResponse offersListResponse = StoreOffersListResponse();
  RxList<Offer> offersList = <Offer>[].obs;
  Rx<Offer> offerObj = Offer().obs;
  late StoreCategoriesListResponse categoriesListResponse =
      StoreCategoriesListResponse();
  RxList<Category> categoriesList = <Category>[].obs;
  Rx<ShopProductDetailResponse> productDetailResponse =
      ShopProductDetailResponse().obs;

  late CartListResponse cartListResponse = CartListResponse();
  RxList<CartItem> cartItems = <CartItem>[].obs;
  Rx<CartListData> cartData = CartListData().obs;
  late FeatureProductListResponse featureProductListResponse =
      FeatureProductListResponse();

  RxList<FeatureProduct> featureProductList = <FeatureProduct>[].obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();
  RxList<UserAddresses> userAddress = <UserAddresses>[].obs;
  Rx<UserAddresses> selectedUserAddress = UserAddresses().obs;

  final OffersController offersController = Get.put(OffersController());
  UserFeaturedProductModel userFeaturedProductModel =
      UserFeaturedProductModel();
  RxList<ProductsList> featuredUserProductList = <ProductsList>[].obs;

  late PreviousOrdersModel previousOrdersModel = PreviousOrdersModel();
  RxList<PreviousOrdersProducts> previousOrderList =
      <PreviousOrdersProducts>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt currentIndexProducts = 0.obs;
  RxString storeLocation = "".obs;
  RxInt listIndex = 2.obs;
  RxInt cartCount = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxInt invokedIndex = 0.obs;
  RxInt lastSelectedIndex = 0.obs;
  RxInt popUpIndex = 1.obs;
  RxInt activeStep = 0.obs;
  RxInt pageId = 0.obs;
  RxInt itemsCount = 1.obs;
  RxDouble walletBalance = 0.0.obs;
  RxString storeDeliveryServiceId = "0".obs;
  RxString userAddressId = "0".obs;
  RxString productId = "".obs;
  RxString categoryId = "".obs;
  RxString categoryName = "".obs;
  RxBool isFromHome = false.obs;
  RxBool isFromFav = false.obs;
  RxBool isFromMenu = false.obs;
  RxBool isFavouriteStore = false.obs;
  RxBool isVerifiedStore = false.obs;
  RxBool isDeleteCartItem = false.obs;
  RxBool isFavouriteProduct = false.obs;
  RxString orderStatus = "".obs;
  RxBool? isInsufficientBalance = false.obs;
  RxBool isValidAddress = false.obs;
  RxBool isOrderDeliverable = false.obs;
  RxString storeIdValue = "".obs;
  RxBool isLoading = false.obs;
  RxBool showLoading = true.obs;
  RxBool isPlaceOrder = true.obs;
  RxBool isFromOptions = false.obs;
  RxString storeId = "".obs;
  RxString selectedDeliveryService = "".obs;
  RxString storeAddressId = "".obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxDouble cartTotalPrice = 0.0.obs;

  // final scrollController = ScrollController();
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  ActiveCartModel activeCartModel = ActiveCartModel();
  RxList<ProductImage>? productIm = <ProductImage>[].obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeId.value = Get.parameters["storeId"] ?? "";
      productId.value = Get.parameters["productId"] ?? "";
      categoryName.value = Get.parameters["categoryName"] ?? "";
      categoryId.value = Get.parameters["categoryId"] ?? "";
      isFromHome.value = Get.parameters["isFromHome"] == "true";
      isFromFav.value = Get.parameters["isFromFav"] == "true";
      isFromMenu.value = Get.parameters["isFromMenu"] == "true";
      // invokedIndex.value = int.parse(Get.parameters["invokedIndex"]??"0") ;

        getCurrentLocation();
        apiGetUserDetailsApi();
        if (storeId.value != "" && productId.value != "") {
          apiGetShopProductDetailApi();
        }
        if (isFromMenu.value) {
          selectedIndex.value = 1;
          invokedIndex.value = 2;
          lastSelectedIndex.value = 1;
          // onIndexChange(1);
        }
        if (isFromFav.value) {
          selectedIndex.value = 2;
          lastSelectedIndex.value = 2;
          showLoading.value = false;
          apiFeatureProductListApi(isFeaturedProduct: true);

          // onIndexChange(2);
        }
        if (isFromHome.value) {
          selectedIndex.value = 0;
          lastSelectedIndex.value = 0;
          showLoading.value = false;
          invokedIndex.value = 0;
          apiGetStoreOffersApi();
          apiFeatureProductListApi(isFeaturedProduct: true);
          // onIndexChange(0);
        }
        if (isFromOptions.value) {
          selectedIndex.value = 3;
          lastSelectedIndex.value = 3;
          showLoading.value = false;
          // onIndexChange(3);
        }
        apiGetUserWalletBalance();

    });
  }

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT LAT AND LNG ***${storeId.value}*********$lat $lng");
    if (storeId.value != "") {
      await apiGetStoreDetailsApi(latitude: lat, longitude: lng);
    }
  }

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    lastSelectedIndex.value = i;
    if (invokedIndex.value > 0) {
      invokedIndex.value = 0;
      // invokedIndex.value--;
    }

    if (i == 0) {
      await apiGetStoreOffersApi();
      await apiFeatureProductListApi(isFeaturedProduct: true);
    } else if (i == 1) {
      await apiGetStoreCategoriesApi();
      if (Get.parameters["categoryId"] != "") {
        apiFeatureProductListApi(
            categoryId: Get.parameters["categoryId"] ?? "0");
      }
    } else if (i == 2) {
      await apiFeatureProductListApi(isFavouriteProducts: true);
    } else if (i == 3) {
      await apiGetPreviousOrders();
    }
  }

  void popUpMenuChange(int i) async {
    popUpIndex.value = i;
    Get.parameters["isFromOptions"] = "false";
    isFromOptions.value = false;
    if (i == 0) {
      apiGetPreviousOrders();
    } else if (i == 1) {
      await apiGetStoreCategoriesApi();
      if (Get.parameters["categoryId"] != "") {
        apiFeatureProductListApi(
            categoryId: Get.parameters["categoryId"] ?? "0");
      }
    } else if (i == 2) {
      if (storeDetailsResponse.value.data!.store!.storePages!
          .any((element) => element.storePageType != "privacy")) {
        Utility.showToast(StringConstants.noPrivacyFoundText);
      } else {
        debugPrint("CURRENT listIndex ***${listIndex.value}*********");
        if (storeDetailsResponse
                    .value.data!.store!.storePages![0].storePageType ==
                "privacy" ||
            storeDetailsResponse
                    .value.data!.store!.storePages![1].storePageType ==
                "privacy") {}
      }
    } else if (i == 3) {
      if (storeDetailsResponse.value.data!.store!.storePages!
          .any((element) => element.storePageType != "terms")) {
        Utility.showToast(StringConstants.noTermsFoundText);
      } else {
        debugPrint("CURRENT listIndex ***${listIndex.value}*********");
        if (storeDetailsResponse
                    .value.data!.store!.storePages![0].storePageType ==
                "terms" ||
            storeDetailsResponse
                    .value.data!.store!.storePages![1].storePageType ==
                "terms") {}
      }
    }
  }

  void termsAndPrivacyDialog(BuildContext context,
      {String content = "", String contentType = ""}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              Center(
                child: Image.asset(
                  ImageConstants.info,
                  color: AppColors.green,
                  scale: 1.8,
                ),
              ),
              height12SizedBox,
              Text(
                contentType == "terms"
                    ? StringConstants.termsAndConditionsText
                    : StringConstants.privacyPolicyText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              height15SizedBox,
              Text(
                content,
                style: TextStyle(
                    color: AppColors.blacklight,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
              height25SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const <Widget>[],
      ),
    );
  }

  void moneyDeductFromCartDialog(BuildContext ctx, {String amount = ""}) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                ImageConstants.info,
                color: AppColors.green,
                scale: 1.5,
              ),
            ),
            height12SizedBox,
            Text(
              StringConstants.paymentConfirmatinText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              "\$$amount ${StringConstants.amountWillBeDeductedText}",
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.cancelText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    if (isPlaceOrder.value == true) {
                      await apiPlaceOrder();
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.proceedText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  void discardCartItems(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.replaceCartItemsText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              StringConstants.cartItemReplaceText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primarylight,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.noText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                width20SizedBox,
                InkWell(
                  onTap: () {
                    if (itemsCount.value != 0) {
                      Get.back();

                      apiAddToCart(context);
                    } else {
                      Utility.showToast(
                          AlertStringConstants.pleaseAddAtLeastOneItemText);
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.yesText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  ///Get Active Cart Api
  Future apiActiveCartApi() async {
    isLoading.value = true;
    debugPrint(
        "ACTIVE CART URL ********** ${ServerCommunicator().baseUrl}${ServerCommunicator().shopCartActive}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopCartActive}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("ACTIVE CART RESPONSE*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
        debugPrint(
            "ACTIVE CART activeCartModel*******${int.parse(activeCartModel.data?.storeId.toString() ?? "0") == 0}");
        debugPrint(
            "ACTIVE CART activeCartModel1*******${activeCartModel.data!.cartItems!.isEmpty}");
        debugPrint(
            "ACTIVE CART activeCartModel2*******${activeCartModel.data!.cartItems}");

        if (int.parse(activeCartModel.data?.storeId.toString() ?? "0") == 0 &&
            activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = 0;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
        } else {
          cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
          if (cartListResponse.data?.cartTotalPrice is int ||
              cartListResponse.data?.cartTotalPrice is String) {
            cartTotalPrice.value = double.parse(
                cartListResponse.data?.cartTotalPrice.toString() ?? "0.0");
          } else {
            cartTotalPrice.value = cartListResponse.data?.cartTotalPrice ?? 0.0;
          }

          debugPrint("CART TOTAL VALUE${cartTotalPrice.value}");
          isValidAddress.value = activeCartModel.data!.isValidAddress!;
          isOrderDeliverable.value = activeCartModel.data!.isOrderDeliverable!;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api Contact store
  Future apiContactStore() async {
    isLoading.value = true;
    debugPrint("CONTACT STORE URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().messageStore}?store_id=${storeId.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().messageStore}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CONTACT STORE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Get.back(id: pageIdApp.value);
        Get.parameters["storeName"] = value?.body["data"]["store_name"] ?? "";
        Get.parameters["storeId"] = value?.body["data"]["store_id"] ?? "";
        Get.parameters["messageHeadId"] =
            value?.body["data"]["message_head_id"] ?? "";
        // SharedPreferenceStorage.setData("context", ctx);
        await Get.to(() => const UserInboxDetailScreen(), id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Categories Api
  Future apiGetStoreCategoriesApi() async {
    isLoading.value = true;
    debugPrint("GET STORE CATEGORIES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}?store_id=${storeId.value}&is_featured_category=false");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;

      debugPrint("GET  Store Categories  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        categoriesListResponse =
            StoreCategoriesListResponse.fromJson(value?.body);
        categoriesList.value = categoriesListResponse.data?.categories ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get User detail Api
  Future apiGetUserDetailsApi() async {
    isLoading.value = true;
    debugPrint(
        "GET USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDetail}");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().userDetail,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;

      debugPrint("GET USER DETAIL *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        userAddress.value = getUserDetailModel.data!.user!.userAddresses!;
        if (userAddress.isNotEmpty) {
          selectedUserAddress.value = userAddress.first;
        }
        getCurrentLocation();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Cart List Api
  Future apiGetCartListApi({bool isShowLoading = false}) async {
    isLoading.value = true;

    debugPrint(
        "GET CART LIST STORE DELIVERY SERVICE ID********** ${storeDeliveryServiceId.value.toString() == "0"}");
    debugPrint(
        "GET CART LIST URL 00000000*******${storeDeliveryServiceId.value.toString() == "0" && selectedUserAddress.value.userAddressId == null ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId" : storeDeliveryServiceId.value.toString() != "0" && selectedUserAddress.value.userAddressId == null ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}" : "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}"}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");

    UserProvider()
        .getWithHeadersApi(
            storeDeliveryServiceId.value.toString() == "0" &&
                    selectedUserAddress.value.userAddressId == null
                ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}"
                : storeDeliveryServiceId.value.toString() != "0" &&
                        selectedUserAddress.value.userAddressId == null
                    ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}"
                    : "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}",
            headers,
            showLoading: isShowLoading)
        .then((value) async {
      isLoading.value = false;
      log("GET CART LIST RESPONSE 123*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        cartListResponse = CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
        cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
        log("cartDeliveryServiceCharge *******${cartData.value.cartDeliveryServiceCharge}");

        if (cartListResponse.data?.cartTotalPrice is int ||
            cartListResponse.data?.cartTotalPrice is String) {
          cartTotalPrice.value = double.parse(
              cartListResponse.data?.cartTotalPrice.toString() ?? "0.0");
        } else {
          cartTotalPrice.value = cartListResponse.data?.cartTotalPrice ?? 0.0;
        }
        debugPrint("CART TOTAL VALUE ${cartTotalPrice.value}");
        debugPrint("CART isDeleteCartItem.value${isDeleteCartItem.value}");
        debugPrint(
            "CART TOTAL VALUE${cartListResponse.data!.cartItems!.isEmpty}");
        debugPrint("CART isFromHome.value ${isFromHome.value}");
        cartData.value = cartListResponse.data ?? CartListData();
        if (cartData.value.isOrderDeliverable == false) {
          Utility.showAlertMessage(AlertStringConstants.orderNotDeliverable);
        }
        if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == true) {
          isDeleteCartItem.value = false;
          Get.until((route) => route.isFirst, id: pageIdApp.value);
        } else if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == false) {
          Get.parameters["storeId"] = storeId.value;
          isDeleteCartItem.value = false;
          // Get.parameters["isAddToOrderScreen"]=="false";
          await Get.to(() => const StoreHomeMainScreen(), id: pageIdApp.value);
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Place Order Api
  Future apiPlaceOrder() async {
    isPlaceOrder.value = false;
    isLoading.value = true;
    debugPrint("API PLACE ORDER URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().placeOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    List selectedItems = [];
    for (var element in cartItems) {
      selectedItems.add({
        "cart_item_id": int.parse(element.cartItemId.toString()),
        "items_count": element.itemsCount,
      });
    }

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value.toString()),
      "store_delivery_service_id": int.parse(storeDeliveryServiceId.value),
      "user_address_id": selectedDeliveryService.value == "1" ||
              selectedDeliveryService.value == "3"
          ? int.parse(storeAddressId.value)
          : selectedUserAddress.value.userAddressId != null
              ? int.parse(selectedUserAddress.value.userAddressId.toString())
              : null,
      "cart_items": selectedItems
    };
    debugPrint("TOKEN ********** $headers");
    debugPrint("API PLACE ORDER BODY ********** $data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().placeOrder}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("API PLACE ORDER RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        itemsCount.value = 1;
        orderStatus.value = value?.body["data"]["order_id"];
        isPlaceOrder.value = true;
        debugPrint("API PLACE ORDER isPlaceOrder ********** $isPlaceOrder");
        Get.parameters["storeId"] = storeId.value.toString();
        Get.parameters["orderStatus"] = value?.body["data"]["order_id"] ?? "";
        Get.parameters["isFromTransaction"] = "false";
        Get.parameters["isFromNotification"] = "false";
        Get.parameters["isHome"] = "true";
        isInsufficientBalance!.value = false;

        Get.to(() => const OrderConfirmationScreen(),
            id: pageIdApp.value,
            arguments: {
              "storeId": storeId.value.toString(),
              "orderStatus": orderStatus.value,
              "isFromTransaction": false,
              "isFromNotification": false
            });
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isPlaceOrder.value = true;

        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        isPlaceOrder.value = true;
        if (value?.body["message"] == "Insufficient balance") {
          isInsufficientBalance!.value = true;
        } else {
          isInsufficientBalance!.value = false;

          Utility.showAlertMessage(value?.body['message']);
        }
      } else if (value?.body == null) {
        isPlaceOrder.value = true;
        Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
      }
    });
  }

  /// Add To CartApi
  Future apiAddToCart(
    BuildContext context,
  ) async {
    isLoading.value = true;
    debugPrint("ADD TO CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createCart}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "product_id": int.parse(
          productDetailResponse.value.data?.product?.productId ?? "0"),
      "items_count": itemsCount.value
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** $data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().createCart}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;

      debugPrint("ADD TO CART RESPONSE  *******${value?.body}");

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        itemsCount.value = 1;
        addToCartDialog(context);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Update Cart Api
  Future apiUpdateCart({int cartItemId = 0, quantity = 0}) async {
    isLoading.value = true;
    debugPrint("UPDATE CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().updateCart}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "cart_item_id": cartItemId,
      "items_count": quantity
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().updateCart}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("UPDATE CART RESPONSE  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isDeleteCartItem.value = true;
        apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Cart Api
  Future apiDeleteCart({int cartItemId = 0}) async {
    isLoading.value = true;
    debugPrint("DELETE CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().deleteItemFromCart}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map<String, dynamic> data = {
      "cart_item_id": cartItemId,
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().deleteItemFromCart}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("DELETE CART RESPONSE  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isDeleteCartItem.value = true;
        apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  void addToCartDialog(
    BuildContext ctx,
  ) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                ImageConstants.tick,
                scale: 3,
              ),
            ),
            height10SizedBox,
            Text(
              StringConstants.itemAddedInCart,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Center(
              child: Text(
                StringConstants.whatWouldLikeNowText,
                style: TextStyle(
                    color: AppColors.blacklight,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
            ),
            height25SizedBox,
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    Get.back();
                    Get.parameters["storeId"] = storeId.value;

                    // Get.parameters["isAddToOrderScreen"]=="false";
                    await Get.to(() => const StoreHomeMainScreen(),
                        id: pageIdApp.value);
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.35,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.continueShoppingText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                width8SizedBox,
                InkWell(
                  onTap: () async {
                    Get.back();
                    apiGetUserWalletBalance();
                    Get.to(() => const CartScreen(),
                        id: pageIdApp.value)?.then((value) =>  onInit());
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.goToCartText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Get Store Offers Api
  Future apiGetStoreOffersApi() async {
    offersList.clear();
    isLoading.value = true;
    debugPrint("Store Offers URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeId.value}");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Offers *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        offersListResponse = StoreOffersListResponse.fromJson(value?.body);
        offersList.value = offersListResponse.data?.offers ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get User Wallet Balance Api
  Future apiGetUserWalletBalance() async {
    isLoading.value = true;
    debugPrint("User Wallet Balance URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("USER WALLET BALANCE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        if (value?.body["data"]["balance"] is int ||
            value?.body["data"]["balance"] is String) {
          walletBalance.value =
              double.parse(value?.body["data"]["balance"].toString() ?? "");
          debugPrint("USER WALLET BALANCE 1*******${walletBalance.value}");
        } else if (value?.body["data"]["balance"] is double) {
          walletBalance.value = value?.body["data"]["balance"] ?? 0.0;
          debugPrint("USER WALLET BALANCE 2*******${walletBalance.value}");
        }
        if (storeId.value != "") {
          apiGetCartListApi(isShowLoading: true);
          await apiActiveCartApi();
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Store Details Api
  Future apiGetStoreDetailsApi(
      {dynamic latitude = 0.0, dynamic longitude = 0.0}) async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=$latitude&longitude=$longitude");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=$latitude&longitude=$longitude",
            headers,
            showLoading: showLoading.value)
        .then((value) async {
      isLoading.value = false;
      showLoading.value = false;
      log("STORE DETAILS RESPONSE*******${value?.body}");
      debugPrint(
          "storeLocation  *******${json.encode(value?.body["data"]["store"]["store_addresses"][0])}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value = StoreDetailsResponse.fromJson(value?.body);
        storeLocation.value =
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.addressLine1 ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.city ?? ""},"
            "${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.stateName ?? ""},${storeDetailsResponse.value.data?.store?.storeAddresses?.first.state?.country?.countryName ?? ""}";
        debugPrint("isFavouriteStore before *******${isFavouriteStore.value}");

        debugPrint(
            "store response before *******${storeDetailsResponse.value.data?.store?.storePages}");

        debugPrint(
            "isFavouriteStore before *******${storeDetailsResponse.value.data?.store?.isFavouriteStore}");
        isVerifiedStore.value =
            storeDetailsResponse.value.data?.store?.isVerified ?? false;
        isFavouriteStore.value =
            storeDetailsResponse.value.data?.store?.isFavouriteStore ?? false;

        debugPrint("CURRENT listIndex ***${listIndex.value}*********");

        debugPrint("isFavouriteStore after*******${isFavouriteStore.value}");
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Shop  Product Detail Api
  Future apiGetShopProductDetailApi() async {
    isLoading.value = true;
    debugPrint("Product Shop Detail  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeId.value}&product_id=${productId.value}&latitude=$lat&longitude=$lng");

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeId.value}&product_id=${productId.value}&latitude=$lat&longitude=$lng",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      log("Product Shop Detail  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        productDetailResponse.value =
            ShopProductDetailResponse.fromJson(value?.body);
        productIm!.clear();
        if (productDetailResponse
            .value.data!.product!.productImages!.isNotEmpty) {
          for (int i = 0;
              i <
                  productDetailResponse
                      .value.data!.product!.productImages!.length;
              i++) {
            if (i >= 5) {
              break;
            }

            productIm!.add(ProductImage(
                image: Images(
                    dynamicUrl: productDetailResponse.value.data!.product!
                        .productImages![i].image!.dynamicUrl!)));
          }
        }
        update();
        isFavouriteProduct.value =
            productDetailResponse.value.data?.product?.isFavouriteProduct ??
                false;
        if (productDetailResponse.value.data!.product!.cartItems!.isNotEmpty) {
          // itemsCount.value = productDetailResponse
          //     .value.data!.product!.cartItems!.first.itemsCount!;
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Feature ProductList Store Api
  Future apiFeatureProductListApi(
      {bool isFavouriteProducts = false,
      isFeaturedProduct = false,
      String orderBy = "1",
      String orderType = "1",
      String categoryId = "0"}) async {
    featureProductList.clear();
    isLoading.value = true;
    debugPrint("FeatureProductList URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 100,
      "order_by": orderBy == "1" ? "product_id" : "selling_price",
      "order_type": orderType == "1" ? "DESC" : "ASC",
      "category_id": isFeaturedProduct == false && categoryId != "0"
          ? int.parse(categoryId)
          : null,
      "is_favourite_products": isFavouriteProducts,
      "filters": isFeaturedProduct
          ? [
              {
                "filter_by": "is_featured_product",
                "filter_value": isFeaturedProduct,
                "operation": "eq"
              }
            ]
          : []
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeFeatureProductList,
            headers,
            showLoading: false /*showLoading.value*/)
        .then((value) async {
      isLoading.value = false;
      log("Feature ProductList Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        featureProductListResponse =
            FeatureProductListResponse.fromJson(value?.body);
        featureProductList.value =
            featureProductListResponse.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  bottomSheetChangePickupLocation(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              StringConstants.selectLocationText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                ImageConstants.cross,
                                scale: 3,
                              ))
                        ],
                      ),
                      height15SizedBox,
                      ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return height12SizedBox;
                          },
                          itemCount: userAddress.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                selectedUserAddress.value = userAddress[index];
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                    color: AppColors.greylight,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    )),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "${userAddress[index].addressLine1},${userAddress[index].city},"
                                              "${userAddress[index].state?.stateName},${userAddress[index].state?.country?.countryName},",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      userAddress[index].userAddressId ==
                                              selectedUserAddress
                                                  .value.userAddressId
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  ImageConstants.circlefull,
                                                  scale: 4,
                                                ),
                                                Image.asset(
                                                  ImageConstants.whitetick,
                                                  color: AppColors.white,
                                                  scale: 3.5,
                                                ),
                                              ],
                                            )
                                          : Image.asset(
                                              ImageConstants.circleunfill,
                                              scale: 4,
                                            ),
                                    ],
                                  ),
                                ]),
                              ),
                            );
                          }),
                      height10SizedBox,
                    ],
                  ),
                ),
              ],
            );
          });
        }).then((value) => {});
  }

  ///Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().removeFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Favourite Product Api
  Future apiCreateFavouriteProduct(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Product URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteProduct}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"product_id": int.parse(id ?? "0")};

    debugPrint("Create Favourite Product body ********** $data");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createFavouriteProduct,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Product *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        apiFeatureProductListApi();
        isFavouriteProduct.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Remove Favourite Product Api
  Future apiRemoveFavouriteProduct(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Product URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteProduct}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"product_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().removeFavouriteProduct,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Product *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);

        apiFeatureProductListApi();
        isFavouriteProduct.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Previous orders ProductList Api
  Future apiGetPreviousOrders() async {
    isLoading.value = true;
    debugPrint("PREVIOUS ORDERS URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreProductList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 100,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": false,
      "is_previous_products": true,
      "filters": [
        // {
        //     "filter_by": "is_featured_product",
        //     "filter_value": true,
        //     "operation": "eq"
        // }
      ]
    };
    debugPrint("TOKEN ********** $headers");
    debugPrint("PREVIOUS ORDERS BODY ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().shopStoreProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("PREVIOUS ORDERS RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        previousOrdersModel = PreviousOrdersModel.fromJson(value?.body);
        previousOrderList.value = previousOrdersModel.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api Get offers products
  Future apiGetOffersProducts(
      {String storeId = "", String offerId = ""}) async {
    featuredUserProductList.clear();
    isLoading.value = true;
    debugPrint("GET OFFERS PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {
      "q": "",
      "store_id": storeId,
      "page": 1,
      "page_size": 1000,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": null,
      "is_previous_products": null,
      "offer_id": offerId,
      "filters": []
    };
    debugPrint("TOKEN ********** $headers");
    debugPrint("GET OFFERS PRODUCT BODY ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeFeatureProductList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET OFFERS PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
