import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/feature_product_response_model.dart' as feature_product;
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart' as nearby;
import 'package:thegreenmall/dashboard/home/model/store_categories_list_model.dart' as categories;
import 'package:thegreenmall/dashboard/home/model/store_offers_list_model.dart' as offers;
import 'package:thegreenmall/dashboard/home/model/user_product_detail_model.dart' as product;
import 'package:thegreenmall/dashboard/home/model/cart_list_model.dart' as cart;
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart' as store;
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreHomeMainController extends GetxController {
  Rx<nearby.StoreAddress> storeAddress = nearby.StoreAddress().obs;

  late store.StoreDetailsResponse storeDetailsResponse = store.StoreDetailsResponse();
  late offers.StoreOffersListResponse offersListResponse = offers.StoreOffersListResponse();
  RxList<offers.Offer> offersList = <offers.Offer>[].obs;

  late categories.StoreCategoriesListResponse categoriesListResponse =
  categories.StoreCategoriesListResponse();
  RxList<categories.Category> categoriesList = <categories.Category>[].obs;
  Rx<categories.Category> category = categories.Category().obs;

  Rx<product.ShopProductDetailResponse>productDetailResponse =
  product.ShopProductDetailResponse().obs;
  late cart.CartListResponse cartListResponse = cart.CartListResponse();
  RxList<cart.CartItem> cartItems = <cart.CartItem>[].obs;

  late feature_product.FeatureProductListResponse featureProductListResponse =
  feature_product.FeatureProductListResponse();
  RxList<feature_product.Product> featureProductList = <feature_product.Product>[].obs;

  RxInt selectedIndex = 0.obs;
  RxInt quantity = 0.obs;
  RxString productId = "".obs;

  RxBool isLoading = false.obs;

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
    storeAddress.value = Get.arguments["storeAddress"];
    // setupScrollController(Get.context);
    apiGetStoreDetailsApi();
    onIndexChange(0);
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
    debugPrint("GET Store Categories URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        categoriesListResponse =
            categories.StoreCategoriesListResponse.fromJson(value?.body);
        categoriesList.value = categoriesListResponse.data?.categories ?? [];
      } else if (value?.body["status"] == 403) {
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
    debugPrint("GET Cart List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=${storeAddress.value.store?.storeId}&is_featured_category=false",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET  Cart List  *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        cartListResponse = cart.CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  // Add To CartApi
  Future apiAddToCart( BuildContext context,) async {
    isLoading.value = true;
    debugPrint("Add To Cart  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "product_id": int.parse(productDetailResponse.value.data?.product?.productId??"0"),
      "quantity": quantity.value
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

      debugPrint("Add To Cart  *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        quantity.value = 0;
        addToCartDailogue(context);
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Update Cart Api
  Future apiUpdateCart({int cartItemId = 0,quantity=0}) async {
    isLoading.value = true;
    debugPrint("Update Cart  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().updateCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data ={
      "cart_item_id": cartItemId,
      "quantity": quantity
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

      debugPrint("Update Cart  *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        apiGetCartListApi();
      } else if (value?.body["status"] == 403) {
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
    debugPrint("Delete Cart  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().deleteItemFromCart}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data ={
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
      debugPrint("Delete Cart  *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        apiGetCartListApi();
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }


  void addToCartDailogue(
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
                'assets/tick.png',
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
            const SizedBox(
              height: 15,
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
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
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 120.0,
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
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async{
                    Get.back();
                    await apiGetCartListApi();
                    Get.to(const CartScreen());

                  },
                  child: Container(
                    height: 50.0,
                    width: 120.0,
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
            headers, showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Offers *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        offersListResponse = offers.StoreOffersListResponse.fromJson(value?.body);
        offersList.value = offersListResponse.data?.offers ?? [];
      } else if (value?.body["status"] == 403) {
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
    debugPrint("  Store Details URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeAddress.value.store?.storeId}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeAddress.value.store?.storeId}",
            headers, showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("  Store Details*******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        storeDetailsResponse = store.StoreDetailsResponse.fromJson(value?.body);
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Shop  Product Detail Api
  Future apiGetShopProductDetailApi({String productId=""}) async {
    isLoading.value = true;
    debugPrint("Product Shop Detail  URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeAddress.value.store?.storeId}&product_id=$productId");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopProductDetails}?store_id=${storeAddress.value.store?.storeId}&product_id=$productId",
            headers, showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Product Shop Detail  *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        productDetailResponse.value = product.ShopProductDetailResponse.fromJson(value?.body);
       update();
      } else if (value?.body["status"] == 403) {
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
      "order_by": "product_id",
      "order_type": "DESC",
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
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Feature ProductList Store *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        featureProductListResponse =
            feature_product.FeatureProductListResponse.fromJson(value?.body);
        featureProductList.value =
            featureProductListResponse.data?.products ?? [];
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }
}
