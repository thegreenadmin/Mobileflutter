import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_categories_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class ManageStoreController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isNotify = false.obs;
  RxBool isMenuSelected = false.obs;
  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString storeLocation = "".obs;
  RxString categoryName = "".obs;

  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  RxList<Categories> categoriesList = <Categories>[].obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    storeLocation.value = Get.arguments["storeLocation"] ?? "";
    getCategoriesApi();
  }

  //Get Categories Api
  Future getCategoriesApi() async {
    categoriesList.clear();
    isLoading.value == true;
    debugPrint(
        "GET CATEGORIES URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value == false;
      debugPrint("GET CATEGORIES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getCategoriesModel = GetCategoriesModel.fromJson(value.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
