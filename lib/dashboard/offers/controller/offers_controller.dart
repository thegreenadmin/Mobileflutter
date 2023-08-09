import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/model/owner_featured_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_featured_product_model.dart';
import 'package:thegreenmall/dashboard/offers/model/offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OffersController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? email = "".obs;
  RxString? phone = "".obs;

  RxString? storeId = "".obs;
  RxString? offerId = "".obs;

  RxBool? isLoading = false.obs;
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
  RxList<DataList> featuredUserProductList = <DataList>[].obs;

  dynamic lat = 0.0;
  dynamic lng = 0.0;
  RxBool isFromNotification = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (roleApp.value == Role.customerRoleText) {
        searchStoreUserController.onInit();
      }
      isFromNotification.value =
          Get.parameters["isFromNotification"] == "true" ? true : false;

      getData();
    });
  }

  getData() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    role.value = roleApp.value;
    if (role.value == Role.customerRoleText) {
      getCurrentLocation();
    } else {
      apiGetOwnerOffersList();
    }
  }

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT roleVal************${role.value} ${pageId.value}");
    apiGetUserOffersList();
  }

  ///Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    isLoading!.value = true;
    debugPrint(
        "GET OWNER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "store_id": null,
      "page": 1,
      "page_size": 10,
      "order_by": "offer_id",
      "order_type": "DESC",
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOfferList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("OWNER OFFERS LIST BODY ******* $body");
      debugPrint("OWNER OFFERS LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value?.body);
        getOwnerOfferList.value = getOwnerOffersListModel.data!.offers!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Offers List Api [USER]
  Future apiGetUserOffersList() async {
    isLoading!.value = true;
    debugPrint(
      "GET USER OFFERS LIST URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().shopOffersList}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
    );

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopOffersList}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getUserOffersListModel = GetUserOfferListModel.fromJson(value.body);
        getUserOfferList.value = getUserOffersListModel.data!.stores!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Delete Offer
  Future apiDeleteOffer() async {
    debugPrint(
        "DELETE OFFER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferDelete}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    deleteOfferRequestModel.storeId = int.parse(storeId!.value);
    deleteOfferRequestModel.offerId = int.parse(offerId!.value);
    debugPrint(
        "DELETE OFFER  BODY ************* ${deleteOfferRequestModel.toJson()}");
    UserProvider()
        .deleteWithHeadersApi(
            deleteOfferRequestModel,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE OFFER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        if (role.value == Role.customerRoleText) {
          apiGetUserOffersList();
        } else {
          apiGetOwnerOffersList();
        }
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Api Get offers products
  Future apiGetOffersProducts(
      {String storeId = "", String offerId = ""}) async {
    isLoading!.value = true;
    debugPrint("GET OFFERS PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
      isLoading!.value = false;
      debugPrint("GET OFFERS PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
