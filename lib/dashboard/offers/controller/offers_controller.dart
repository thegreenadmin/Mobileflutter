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
  RxBool isFromNotification = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters == null
        ? false
        : Get.parameters['isFromNotification'] != "false") {
      isFromNotification.value =
      Get.parameters["isFromNotification"]=="true"?true:false;
    }
    firstName?.value = SharedPreferenceStorage.getData(StringConstants.firstNameText)??"";
    lastName?.value = SharedPreferenceStorage.getData(StringConstants.lastNameText)??"";
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserOffersList(Get.context!);
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetOwnerOffersList(Get.context!);
    }
  }

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT LAT AND LNG ************$lat $lng");
  }

  //Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList(BuildContext context) async {
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
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

  //Get Offers List Api [USER]
  Future apiGetUserOffersList(BuildContext context) async {
    isLoading!.value = true;
    debugPrint(
      "GET USER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=37.0902&latitude=95.7129&mileage=1000&page=1&page_size=20",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");

    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=37.0902&latitude=95.7129&mileage=1000&page=1&page_size=20",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getUserOffersListModel = GetUserOfferListModel.fromJson(value.body);
        getUserOfferlist.value = getUserOffersListModel.data!.stores!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

//Delete Offer
  Future apiDeleteOffer(BuildContext context) async {
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        if (role!.value == Role.customerRoleText) {
          apiGetUserOffersList(context);
        } else {
          apiGetOwnerOffersList(context);
        }
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }
}
