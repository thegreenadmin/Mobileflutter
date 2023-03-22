import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/model/get_offers_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class OffersController extends GetxController {
  RxList offersList = [
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store",
    "Click & Collect",
    "Happy Shop",
    "Ambrosia Store"
  ].obs;

  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? email = "".obs;
  RxString? phone = "".obs;

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  late GetOffersListModel getOffersListModel = GetOffersListModel();
  RxList<Offers> getofferlist = <Offers>[].obs;

  @override
  void onInit() {
    super.onInit();
    apiGetUserDetail();
    apiGetOffersList();
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

  //Get Offers List Api
  Future apiGetOffersList() async {
    debugPrint(
        "GET OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferLists}");

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
            ServerCommunicator().baseUrl + ServerCommunicator().storeOfferLists,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("OFFERS LIST BODY ******* $body");
      debugPrint("OFFERS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getOffersListModel = GetOffersListModel.fromJson(value.body);
        getofferlist.value = getOffersListModel.data!.offers!;
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
