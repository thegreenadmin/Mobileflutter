import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/account_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class HomeController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;

  @override
  void onInit() {
    super.onInit();
    apiGetUserDetail();
    Future.delayed(const Duration(milliseconds: 200), () {});
  }

  List<PopupMenuEntry<String>>? userTypeOptionsPopUpList(context) {
    return List.generate(2, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                    Get.to(const AccountScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.userProfileText,
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.to(const AccountScreen());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.storeProfileText,
                    style:
                        const TextStyle(color: AppColors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return null!;
    });
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
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
