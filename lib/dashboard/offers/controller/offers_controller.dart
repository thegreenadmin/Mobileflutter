import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_offer_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

import '../../../welcome/startjourney/view/start_journey_screen.dart';

class OffersController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? email = "".obs;
  RxString? phone = "".obs;

  RxBool? isLoading = false.obs;
  RxString? role = "".obs;

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferlist = <OffersList>[].obs;

  late GetUserOfferListModel getUserOffersListModel = GetUserOfferListModel();
  RxList<Stores> getUserOfferlist = <Stores>[].obs;

  @override
  void onInit() {
    super.onInit();
    apiGetUserDetail();
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserOffersList();
    } else {
      apiGetOwnerOffersList();
      role!.value = Role.storeOwnerRoleText;
    }
  }

  //Get User Detail Info Api
  Future apiGetUserDetail() async {
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
            showLoading: true)
        .then((value) async {
      debugPrint("GET USER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value.body);
        firstName!.value = getUserDetailModel.data!.user!.firstName!;
        lastName!.value = getUserDetailModel.data!.user!.lastName!;
        nickName!.value = getUserDetailModel.data!.user!.nickName!;
        email!.value = getUserDetailModel.data!.user!.email!;
        phone!.value = getUserDetailModel.data!.user!.phone!;
      } else {
        Utility.showMessage(
            StringConstants.alertText, value.body['message'].toString());
      }
    });
  }

  //Get Offers List of OWNER Api
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
      debugPrint("OWNER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value.body);
        getOwnerOfferlist.value = getOwnerOffersListModel.data!.offers!;
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Offers List of USER Api
  Future apiGetUserOffersList() async {
    isLoading!.value = true;
    debugPrint(
      "GET USER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=37.0902&latitude=95.7129&mileage=100&page=1&page_size=20",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");

    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopeOffersList}?longitude=37.0902&latitude=95.7129&mileage=100&page=1&page_size=20",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getUserOffersListModel = GetUserOfferListModel.fromJson(value.body);
        getUserOfferlist.value = getUserOffersListModel.data!.stores!;
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
