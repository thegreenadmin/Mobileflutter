import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/model/feature_product_response_model.dart'
    as feature_product;
import 'package:thegreenmall/dashboard/home/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart'
    as nearby;
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
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreHomeMainController extends GetxController {
  Rx<nearby.StoreAddress> storeAddress = nearby.StoreAddress().obs;

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

  RxInt selectedIndex = 0.obs;
  RxInt activeStep = 0.obs;
  RxInt itemsCount = 1.obs;
  RxDouble walletBalance = 0.0.obs;
  RxString storeDeliveryServiceId = "0".obs;
  RxString userAddressId = "0".obs;
  RxString productId = "".obs;
  RxBool isFromHome = false.obs;
  RxBool isFavouriteStore = false.obs;
  RxBool isDeleteCartItem = false.obs;
  RxBool isFavouriteProduct = false.obs;
  RxString orderStatus = "".obs;

  RxBool isLoading = false.obs;
  RxString storeId = "".obs;
  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          // apiGetStoreCategoriesApi();
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.parameters == null ? false : Get.parameters['isFromHome'] != "false") {
      isFromHome.value = Get.parameters["isFromHome"]=="true"?true:false;

      productId.value =
          Get.parameters == null ? "" : Get.parameters["productId"] ?? "";
    }
    storeId.value =
    Get.parameters == null ? "" : Get.parameters["storeId"] ?? "";
    apiGetUserDetailsApi();
    if (isFromHome.value) {
      nearby.Store store = nearby.Store();
      store.storeId = storeId.value;
      storeAddress.value.store = store;
      isFavouriteStore.value = store.isFavouriteStore ?? false;
      apiGetStoreDetailsApi();
      apiGetCartListApi();
      setupScrollController(Get.context);
      apiGetShopProductDetailApi();
    } else {
      nearby.Store store = nearby.Store();
      store.storeId = storeId.value;
      storeAddress.value.store = store;
      isFavouriteStore.value = store.isFavouriteStore ?? false;
      // storeAddress.value = Get.arguments["storeAddress"] ?? {};
      // isFavouriteStore.value =
      //     storeAddress.value.store?.isFavouriteStore ?? false;
      setupScrollController(Get.context);
      apiGetStoreDetailsApi();
      onIndexChange(0);
    }
    apiGetUserWalletBalance();
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
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}?store_id=${storeAddress.value.store?.storeId}&is_featured_category=false",
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Cart List Api
  Future apiGetCartListApi() async {
    isLoading.value = true;
    debugPrint(
        "GET CART LIST STORE DELIVERY SERVICE ID********** ${storeDeliveryServiceId.value.toString() == "0"}");
    debugPrint(
        "GET CART LIST URL**********${storeDeliveryServiceId.value.toString() == "0" && selectedUserAddress.value.userAddressId == null ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}" : storeDeliveryServiceId.value.toString() != "0" && selectedUserAddress.value.userAddressId == null ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}" : "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}"}");
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
                ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}"
                : storeDeliveryServiceId.value.toString() != "0" &&
                        selectedUserAddress.value.userAddressId == null
                    ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}"
                    : "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CART LIST BODY *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        cartListResponse = cart.CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
        cartData.value = cartListResponse.data ?? cart.Data();
        if (isDeleteCartItem.value == true &&
            cartListResponse.data!.cartItems!.isEmpty) {
          isDeleteCartItem.value = false;
          Get.offAll(BottomNavigation());
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Place Order Api
  Future apiPlaceOrder() async {
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
      "store_id":
          int.parse(storeAddress.value.store?.storeId.toString() ?? "0"),
      "store_delivery_service_id": int.parse(storeDeliveryServiceId.value),
      "user_address_id": selectedUserAddress.value.userAddressId != null
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
        Get.to(() => const OrderConfirmationScreen(), arguments: {
          "storeId": storeAddress.value.store?.storeId.toString() ?? "0",
          "orderStatus": orderStatus.value,
          "isFromTransaction": false,
          "isFromNotification": false
        });
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value?.body == null) {
        Utility.showToast(AlertStringConstants.somethingWentWrongText);
      } else {
        Utility.showToast(value?.body['message']);
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
        apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Delete Cart Api
  Future apiDeleteCart({int cartItemId = 0}) async {
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
        apiGetCartListApi();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  void addToCartDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
                    Get.back();
                    Get.back();
                    Get.back();
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
                  onTap: () async {
                    Get.back();
                    await apiGetCartListApi();
                    Get.to(const CartScreen());
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
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeAddress.value.store?.storeId}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersList}?store_id=${storeAddress.value.store?.storeId}",
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
      debugPrint("User Wallet Balance *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        walletBalance.value = value?.body["data"]["balance"];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Store Details Api
  Future apiGetStoreDetailsApi() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeAddress.value.store?.storeId}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeAddress.value.store?.storeId}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      log("STORE DETAILS *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        debugPrint("isFavouriteStore before *******${isFavouriteStore.value}");
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
        debugPrint(
            "isFavouriteStore before 222*******${storeDetailsResponse.value.data?.store?.isFavouriteStore}");
        isFavouriteStore.value =
            storeDetailsResponse.value.data?.store?.isFavouriteStore ?? false;
        debugPrint("isFavouriteStore after*******${isFavouriteStore.value}");
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Shop  Product Detail Api
  Future apiGetShopProductDetailApi() async {
    isLoading.value = true;
    debugPrint("Product Shop Detail  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeAddress.value.store?.storeId}&product_id=${productId.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeAddress.value.store?.storeId}&product_id=${productId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Product Shop Detail  *******${value?.body}");
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
      "store_id": storeAddress.value.store?.storeId,
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
                                          ? Image.asset(
                                              ImageConstants.whitetick,
                                              scale: 3.5,
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
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {},
                        height: 50,
                        text: StringConstants.changeText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 16,
                      ),
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
        storeAddress.value.store?.isFavouriteStore = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
        storeAddress.value.store?.isFavouriteStore = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }
}
