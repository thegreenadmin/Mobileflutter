import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/model/delete_offer_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_offer_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
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
  RxString? role = "".obs;

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferlist = <OffersList>[].obs;

  late GetUserOfferListModel getUserOffersListModel = GetUserOfferListModel();
  RxList<Stores> getUserOfferlist = <Stores>[].obs;
  late DeleteOfferRequestModel deleteOfferRequestModel =
      DeleteOfferRequestModel();
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  @override
  void onInit() {
    super.onInit();

    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserOffersList();
    } else {
      apiGetOwnerOffersList();
      role!.value = Role.storeOwnerRoleText;
    }
  }

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT LAT AND LNG ************$lat $lng");
  }

  //Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    isLoading!.value = true;
    debugPrint(
        "GET OWNER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "store_id": null,
      "page": 1,
      "page_size": 10,
      "order_by": "offer_name",
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
      debugPrint("OWNER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value.body);
        getOwnerOfferlist.value = getOwnerOffersListModel.data!.offers!;
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Offers List Api [USER]
  Future apiGetUserOffersList() async {
    isLoading!.value = true;
    debugPrint(
      "GET USER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=$lng&latitude=$lng +&mileage=100&page=1&page_size=20",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");

    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=$lng&latitude=$lng +&mileage=100&page=1&page_size=20",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getUserOffersListModel = GetUserOfferListModel.fromJson(value.body);
        getUserOfferlist.value = getUserOffersListModel.data!.stores!;
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Delete Offer
  Future apiDeleteOffer() async {
    debugPrint(
        "DELETE OFFER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
