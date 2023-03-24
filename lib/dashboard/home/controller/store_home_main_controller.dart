import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/feature_product_response_model.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/dashboard/home/model/store_categories_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/store_offers_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreHomeMainController extends GetxController {
  Rx<StoreAddress> storeAddress = StoreAddress().obs;

  late StoreOffersListResponse offersListResponse = StoreOffersListResponse();
  RxList<Offer> offersList = <Offer>[].obs;
  late StoreCategoriesListResponse categoriesListResponse =
      StoreCategoriesListResponse();
  RxList<Category> categoriesList = <Category>[].obs;
  Rx<Category> category = Category().obs;
  late FeatureProductListResponse featureProductListResponse =
      FeatureProductListResponse();
  RxList<Product> featureProductList = <Product>[].obs;

  RxInt selectedIndex = 0.obs;

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
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        categoriesListResponse =
            StoreCategoriesListResponse.fromJson(value?.body);
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
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Offers *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        offersListResponse = StoreOffersListResponse.fromJson(value?.body);
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
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Feature ProductList Store *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        featureProductListResponse =
            FeatureProductListResponse.fromJson(value?.body);
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
