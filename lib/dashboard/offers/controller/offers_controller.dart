import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  RxString email = "".obs;
  RxString phone = "".obs;

  @override
  void onInit() {
    super.onInit();
    apiGetUserDetail();
    Future.delayed(const Duration(milliseconds: 200), () {});
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
        firstName!.value = value.body["data"]["user"]['first_name'] ?? "";
        lastName!.value = value.body["data"]["user"]['last_name'] ?? "";
        nickName!.value = value.body["data"]["user"]['nick_name'] ?? "-";
        email.value = value.body["data"]["user"]['email'] ?? "";
        phone.value = value.body["data"]["user"]['phone'] ?? "";
      } else {
        Utility.showMessage(
            StringConstants.alertText, value.body['message'].toString());
      }
    });
  }
}
