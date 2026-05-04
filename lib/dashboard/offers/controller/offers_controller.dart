import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/model/owner_featured_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_featured_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_offers_model.dart';
import 'package:thegreenmall/dashboard/offers/model/offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OffersController extends GetxController with GlobalVarMixin{
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();

  RxString? nickName = "".obs;
  RxString? email = "".obs;
  RxString? phone = "".obs;
  Rx<Offer> offerObj = Offer().obs;
  RxString? storeId = "".obs;
  RxString? offerId = "".obs;

  RxBool isLoading = false.obs;
  RxString role = "".obs;
  RxInt pageId = 0.obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());
  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferList = <OffersList>[].obs;

  late GetUserOfferListModel getUserOffersListModel = GetUserOfferListModel();
  RxList<UserOfferStores> getUserOfferList = <UserOfferStores>[].obs;

  late DeleteOfferRequestModel deleteOfferRequestModel =
      DeleteOfferRequestModel();

  late OwnerFeaturedProductModel ownerFeaturedProductModel =
      OwnerFeaturedProductModel();
  RxList<ProductsList> ownerFeatureProductList = <ProductsList>[].obs;

  UserFeaturedProductModel userFeaturedProductModel =
      UserFeaturedProductModel();
  RxList<ProductsList> featuredUserProductList = <ProductsList>[].obs;
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  RxBool isFromNotification = false.obs;
  RxInt totalCount = 0.obs;
  RxInt page = 1.obs;
  ScrollController scrollController = ScrollController();

  RxInt totalCountCustomer = 0.obs;
  RxInt pageCustomer = 1.obs;
  ScrollController scrollController1 = ScrollController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
      role.value = roleData;
      if (Get.parameters["isController"] != "no") {
        if (role.value == Role.customerRoleText) {
          searchStoreUserController.apiActiveCartApi();
        }
        // isFromNotification.value =
        //     Get.parameters["isFromNotification"] == "true" ? true : false;
        getData();
      }
    });
  }

  getData() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";
    phone?.value =
        await SharedPreferenceStorage.getData("userPhone") ?? "";

    var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
    role.value = roleData;
    if (role.value == Role.customerRoleText) {
      await getCurrentLocation();
    } else {
      page.value = 1;
      await apiGetOwnerOffersList();
      await setupScrollController();
    }
  }

  getCurrentLocation() async {
    if (phone?.value == "0000000000") {
      lat = 36.1627; // Nashville, Tennessee latitude
      lng = -86.7816; // Nashville, Tennessee longitude
    } else {
      Position currentLocation = await Utility.fetchCurrentLocation();
      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
    }
    apiGetUserOffersList();
    setupScrollController1();
  }

  setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (getOwnerOfferList.length < totalCount.value) {
          page.value++;
          apiGetOwnerOffersList();
        }
      }
    });
  }

  setupScrollController1() {
    scrollController1.addListener(() {
      if (scrollController1.position.pixels >=
          scrollController1.position.maxScrollExtent - 10) {
        if (getUserOfferList.length < totalCountCustomer.value) {
          pageCustomer.value++;
          apiGetUserOffersList();
        }
      }
    });
  }

  ///Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    if (page.value == 1) {
      isLoading.value = true;
      getOwnerOfferList.clear();
    }
    getOwnerOffersListModel = GetOwnerOffersListModel();

         Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         Map body = {
      "store_id": null,
      "page": page.value,
      "page_size": 3,
      "order_by": "offer_id",
      "order_type": "DESC",
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl + ServerCommunicator.storeOfferList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
                    if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value?.body);
        totalCount.value = getOwnerOffersListModel.data?.totalCount ?? 0;
        List<OffersList>? offerListNewList = [];
        offerListNewList = getOwnerOffersListModel.data?.offers ?? [];
        if (offerListNewList.isNotEmpty) {
          if (page.value == 1) {
            getOwnerOfferList.value = [];
          }
          getOwnerOfferList.addAll(offerListNewList);
        }
        getOwnerOfferList.value = getOwnerOfferList.toSet().toList();
        isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        isLoading.value = false;
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Offers List Api [USER]
  Future apiGetUserOffersList() async {
    if (pageCustomer.value == 1) {
      isLoading.value = true;
      getUserOfferList.clear();
    }
    getUserOffersListModel = GetUserOfferListModel();

     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopOffersList}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserOffersListModel = GetUserOfferListModel.fromJson(value?.body);
        totalCountCustomer.value = getUserOffersListModel.data?.totalCount ?? 0;
        List<UserOfferStores>? offerUserNewList = [];
        offerUserNewList = getUserOffersListModel.data?.stores ?? [];
        if (offerUserNewList.isNotEmpty) {
          if (page.value == 1) {
            getUserOfferList.value = [];
          }
          getUserOfferList.addAll(offerUserNewList);
        }
        getUserOfferList.toSet().toList();
        isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();  isLoading.value = false;
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {  isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Offer
  Future apiDeleteOffer() async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    deleteOfferRequestModel.storeId = int.parse(storeId!.value);
    deleteOfferRequestModel.offerId = int.parse(offerId!.value);
         UserProvider()
        .deleteWithHeadersApi(
            deleteOfferRequestModel,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeOfferDelete}",
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        page.value = 1;
        apiGetOwnerOffersList();
        isLoading.value = false;
        Utility.showToast(value?.body['message']);
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);  isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();  isLoading.value = false;
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {  isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api Get offers products
  Future apiGetOffersProducts(
      {String storeId = "", String offerId = ""}) async {
    isLoading.value = true;
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
              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeFeatureProductList,
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        isLoading.value = false;
        featuredUserProductList.value =
            userFeaturedProductModel.data?.products ??[];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Get.offAll(const StartJourneyScreen());
      } else { isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
