import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/active_cart_items_model.dart';
import 'package:thegreenmall/dashboard/home/model/feature_product_response_model.dart'
    as feature_product;
import 'package:thegreenmall/dashboard/home/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart'
    as nearby;
import 'package:thegreenmall/dashboard/home/model/previous_orders_model.dart';
import 'package:thegreenmall/dashboard/home/model/store_categories_list_model.dart'
    as categories;
import 'package:thegreenmall/dashboard/home/model/store_offers_list_model.dart'
    as offers;
import 'package:thegreenmall/dashboard/home/model/user_product_detail_model.dart'
    as product;
import 'package:thegreenmall/dashboard/home/model/cart_list_model.dart' as cart;
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreHomeMainController extends GetxController {
  // Rx<nearby.StoreAddress> storeAddress = nearby.StoreAddress().obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  late offers.StoreOffersListResponse offersListResponse =
      offers.StoreOffersListResponse();

  RxList<offers.Offer> offersList = <offers.Offer>[].obs;

  late categories.StoreCategoriesListResponse categoriesListResponse =
      categories.StoreCategoriesListResponse();
  RxList<categories.Category> categoriesList = <categories.Category>[].obs;
  Rx<categories.Category> category = categories.Category().obs;

  Rx<product.ShopProductDetailResponse> productDetailResponse =
      product.ShopProductDetailResponse().obs;

  late cart.CartListResponse cartListResponse = cart.CartListResponse();
  RxList<cart.CartItem> cartItems = <cart.CartItem>[].obs;
  Rx<cart.Data> cartData = cart.Data().obs;
  late feature_product.FeatureProductListResponse featureProductListResponse =
      feature_product.FeatureProductListResponse();

  RxList<feature_product.Product> featureProductList =
      <feature_product.Product>[].obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();
  RxList<UserAddresses> userAddress = <UserAddresses>[].obs;
  Rx<UserAddresses> selectedUserAddress = UserAddresses().obs;

  late PreviousOrdersModel previousOrdersModel = PreviousOrdersModel();
  RxList<Products> previousOrderList = <Products>[].obs;
  RxInt cartCount = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxInt activeStep = 0.obs;
  RxInt itemsCount = 1.obs;
  RxDouble walletBalance = 0.0.obs;
  RxString storeDeliveryServiceId = "0".obs;
  RxString userAddressId = "0".obs;
  RxString productId = "".obs;
  RxBool isFromHome = false.obs;
  RxBool isFromFav = false.obs;
  RxBool isFromMenu = false.obs;
  RxBool isFavouriteStore = false.obs;
  RxBool isDeleteCartItem = false.obs;
  RxBool isFavouriteProduct = false.obs;
  RxString orderStatus = "".obs;
  RxBool? isInsufficientBalance = false.obs;
  RxBool isValidAddress = false.obs;
  RxBool isOrderDeliverable = false.obs;
  RxString storeIdValue = "".obs;
  RxBool isLoading = false.obs;
  RxString storeId = "".obs;
  RxString selectedDeliveryService = "".obs;
  RxString storeAddressId = "".obs;
  final scrollController = ScrollController();
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  ActiveCartModel activeCartModel = ActiveCartModel();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {});
    if (storeId.value != Get.parameters["storeId"]) {
      storeId.value = Get.parameters["storeId"] ?? "";
      getCurrentLocation();
    }

    if (Get.parameters['isFromHome'] != false) {
      isFromHome.value = Get.parameters["isFromHome"] == "true" ? true : false;

      productId.value = Get.parameters["productId"] == null
          ? ""
          : Get.parameters["productId"] ?? "";
    }

    isFromFav.value = Get.parameters["isFromFav"] == "true" ? true : false;
    isFromMenu.value = Get.parameters["isFromMenu"] == "true" ? true : false;
    print("isFromMenu--------${isFromFav.value}");
    print("isFromFav-------${isFromMenu.value}");
    print("PRODUCT ID--------${Get.parameters["productId"]}");

    apiGetUserDetailsApi();
    if (isFromMenu.value) {
      selectedIndex.value = 1;
    }
    if (isFromFav.value) {
      selectedIndex.value = 2;
    }
    if (isFromHome.value) {
      selectedIndex.value = 0;
      apiGetShopProductDetailApi();
    } else {
      onIndexChange(0);
    }
    apiGetUserWalletBalance();
    apiGetCartListApi(Get.context);
    apiActiveCartApi(Get.context);
  }

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    if (i == 0) {
      await apiGetStoreOffersApi();
      await apiFeatureProductListApi(isFeaturedProduct: true);
    } else if (i == 1) {
      await apiGetStoreCategoriesApi();
    } else if (i == 2) {
      await apiFeatureProductListApi(isFavouriteProducts: true);
    } else if (i == 3) {}
  }

  void termsAndPrivacyDailogue(BuildContext context,
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

  void moneydeductFromCartDailogue(BuildContext context, {String amount = ""}) {
    showDialog(
      context: context,
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
                    Navigator.pop(_);
                    // Get.back();
                    await apiPlaceOrder(context);
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
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            const Text(
              "Replace cart item?",
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            const Text(
              "Your cart contains items. Do you want to discard the selection and add new items?",
              style: TextStyle(
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
                    // Get.back();
                    Navigator.of(ctx).pop();
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
                height25SizedBox,
                InkWell(
                  onTap: () {
                    // Get.back();
                    if (itemsCount.value != 0) {
                      Navigator.of(ctx).pop();
                      apiAddToCart(context);
                    } else {
                      Utility.showToast(
                          AlertStringConstants.pleaseAddAtleastOneItemText);
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

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT LAT AND LNG ************$lat $lng");
    await apiGetStoreDetailsApi();
  }

  //Get Active Cart Api
  Future apiActiveCartApi(context) async {
    isLoading.value = true;
    debugPrint(
        "ACTIVE CART URL ********** ${ServerCommunicator().baseUrl}${ServerCommunicator().shopCartActive}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        if (int.parse(activeCartModel.data!.storeId.toString()) == 0 ||
            activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
        } else {
          cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
          isValidAddress.value = activeCartModel.data!.isValidAddress!;
          isOrderDeliverable.value = activeCartModel.data!.isOrderDeliverable!;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
          print("STORE ID VALUE" + storeIdValue.value.toString());
          // await apiGetCartListApi(context,
          //     storeId: activeCartModel.data!.storeId.toString());
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Api Contact store
  Future apiContactStore(BuildContext ctx) async {
    isLoading.value = true;
    debugPrint("CONTACT STORE URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().messageStore}?store_id=${storeId.value}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Navigator.of(ctx).pop();
        Get.parameters["storeName"] = value!.body["data"]["store_name"] ?? "";
        Get.parameters["storeId"] = value.body["data"]["store_id"] ?? "";
        Get.parameters["messageHeadId"] =
            value.body["data"]["message_head_id"] ?? "";
        SharedPreferenceStorage.setData("context", ctx);
        Navigator.of(ctx).push(MaterialPageRoute(
          builder: (_) => const UserInboxDetailScreen(),
        ));
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Categories Api
  Future apiGetStoreCategoriesApi() async {
    isLoading.value = true;
    debugPrint("GET STORE CATEGORIES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}?store_id=${storeId.value}&is_featured_category=false",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;

      debugPrint("GET  Store Categories  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        categoriesListResponse =
            categories.StoreCategoriesListResponse.fromJson(value?.body);
        categoriesList.value = categoriesListResponse.data?.categories ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get User detail Api
  Future apiGetUserDetailsApi() async {
    isLoading.value = true;
    debugPrint(
        "GET USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDetail}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Cart List Api
  Future apiGetCartListApi(context) async {
    isLoading.value = true;

    debugPrint(
        "GET CART LIST STORE DELIVERY SERVICE ID********** ${storeDeliveryServiceId.value.toString() == "0"}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CART LIST RESPONSE 123*******${value?.body}");
      debugPrint(
          "GET CART LIST URL 1*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}");
      debugPrint(
          "GET CART LIST URL 2*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}");
      debugPrint(
          "GET CART LIST URL 3*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeId.value}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}");

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        cartListResponse = cart.CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
        cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
        cartData.value = cartListResponse.data ?? cart.Data();
        if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == true) {
          isDeleteCartItem.value = false;
          // Navigator.of(Get.context!).popUntil((route) => route.isFirst);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty &&
            isFromHome.value == false) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Place Order Api
  Future apiPlaceOrder(context) async {
    isLoading.value = true;
    debugPrint("API PLACE ORDER URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().placeOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    List selectedItems = [];
    for (var element in cartItems) {
      selectedItems.add({
        "cart_item_id": int.parse(element.cartItemId.toString()),
        "items_count": element.itemsCount,
      });
    }

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value.toString() ?? "0"),
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
        orderStatus.value = value?.body["data"]["order_id"];
        SharedPreferenceStorage.setData("context", context);
        Get.parameters["storeId"] = storeId.value.toString() ?? "0";
        Get.parameters["orderStatus"] = orderStatus.value;
        Get.parameters["isFromTransaction"] = "false";
        Get.parameters["isFromNotification"] = "false";
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const OrderConfirmationScreen(),
        ));

        /* Get.to(() => const OrderConfirmationScreen(), arguments: {
          "storeId": storeId.value.toString() ?? "0",
          "orderStatus": orderStatus.value,
          "isFromTransaction": false,
          "isFromNotification": false
        });*/
        update();
        isInsufficientBalance!.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        if (value?.body["message"] == "Insufficient balance") {
          isInsufficientBalance!.value = true;
        } else {
          isInsufficientBalance!.value = false;
          Utility.showAlertMessage(value?.body['message']);
        }
      } else if (value?.body == null) {
        Utility.showAlertMessage(AlertStringConstants.somethingWentWrongText);
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  // Add To CartApi
  Future apiAddToCart(
    BuildContext context,
  ) async {
    isLoading.value = true;
    debugPrint("ADD TO CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "product_id": int.parse(
          productDetailResponse.value.data?.product?.productId ?? "0"),
      "items_count": itemsCount.value
    };

    debugPrint("TOKEN ********** $headers");
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
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Update Cart Api
  Future apiUpdateCart({int cartItemId = 0, quantity = 0}) async {
    isLoading.value = true;
    debugPrint("UPDATE CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().updateCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        apiGetCartListApi(Get.context);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Delete Cart Api
  Future apiDeleteCart(context, {int cartItemId = 0}) async {
    isLoading.value = true;
    debugPrint("DELETE CART URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().deleteItemFromCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        apiGetCartListApi(context);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  void addToCartDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
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
            Text(
              "Please continue shopping with thegreenmall",
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
                  onTap: () {
                    Navigator.of(_).pop();
                    Navigator.of(_).pop();
                    Navigator.of(_).pop();
                    // Get.back();
                    // Get.back();
                    // Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        'More Product',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(_).pop();
                    // Get.back();
                    apiGetCartListApi(Get.context);
                    apiGetUserWalletBalance();
                    SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ));
                    // Get.to(const CartScreen());
                  },
                  child: Container(
                    height: 50.0,
                    width: WidgetConstants.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Go to Cart',
                        style: TextStyle(
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
        actions: const <Widget>[],
      ),
    );
  }

  //Get Store Offers Api
  Future apiGetStoreOffersApi() async {
    isLoading.value = true;
    debugPrint("Store Offers URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Offers *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        offersListResponse =
            offers.StoreOffersListResponse.fromJson(value?.body);
        offersList.value = offersListResponse.data?.offers ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get User Wallet Balance Api
  Future apiGetUserWalletBalance() async {
    isLoading.value = true;
    debugPrint("User Wallet Balance URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        if (value!.body["data"]["balance"] is int ||
            value.body["data"]["balance"] is String) {
          walletBalance.value =
              double.parse(value.body["data"]["balance"].toString());
          debugPrint("USER WALLET BALANCE 1*******${walletBalance.value}");
        } else if (value.body["data"]["balance"] is double) {
          walletBalance.value = value.body["data"]["balance"] ?? 0.0;
          debugPrint("USER WALLET BALANCE 2*******${walletBalance.value}");
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Store Details Api
  Future apiGetStoreDetailsApi() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=$lat&longitude=$lng");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=$lat&longitude=$lng",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE DETAILS RESPONSE*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        debugPrint("isFavouriteStore before *******${isFavouriteStore.value}");
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);

        debugPrint("isFavouriteStore before *******${isFavouriteStore.value}");

        debugPrint(
            "store response before *******${storeDetailsResponse.value.data?.store?.storePages}");

        debugPrint(
            "isFavouriteStore before *******${storeDetailsResponse.value.data?.store?.isFavouriteStore}");
        isFavouriteStore.value =
            storeDetailsResponse.value.data?.store?.isFavouriteStore ?? false;

        debugPrint("isFavouriteStore after*******${isFavouriteStore.value}");
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Shop  Product Detail Api
  Future apiGetShopProductDetailApi() async {
    isLoading.value = true;
    debugPrint("Product Shop Detail  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeId.value}&product_id=${productId.value}&latitude=$lat&longitude=$lng");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
            product.ShopProductDetailResponse.fromJson(value?.body);
        isFavouriteProduct.value =
            productDetailResponse.value.data?.product?.isFavouriteProduct ??
                false;
        if (productDetailResponse.value.data!.product!.cartItems!.isNotEmpty) {
          itemsCount.value = productDetailResponse
              .value.data!.product!.cartItems!.first.itemsCount!;
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Feature ProductList Store Api
  Future apiFeatureProductListApi(
      {bool isFavouriteProducts = false,
      isFeaturedProduct = false,
      String orderBy = "1",
      String orderType = "1",
      String categoryId = "0"}) async {
    isLoading.value = true;
    debugPrint("FeatureProductList URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
            showLoading: true) //orderBy == "2" ? true : false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Feature ProductList Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        featureProductListResponse =
            feature_product.FeatureProductListResponse.fromJson(value?.body);
        featureProductList.value =
            featureProductListResponse.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
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

  //Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        // storeAddress.value.store?.isFavouriteStore = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

//Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        // storeAddress.value.store?.isFavouriteStore = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Create Favourite Product Api
  Future apiCreateFavouriteProduct(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Product URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteProduct}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Remove Favourite Product Api
  Future apiRemoveFavouriteProduct(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Product URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteProduct}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Previous orders ProductList Api
  Future apiGetPreviousOrders() async {
    isLoading.value = true;
    debugPrint("PREVIOUS ORDERS URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
      // "offer_id":
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
            showLoading: true) //orderBy == "2" ? true : false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("PREVIOUS ORDERS BODY *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        previousOrdersModel = PreviousOrdersModel.fromJson(value?.body);
        previousOrderList.value = previousOrdersModel.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }
}
