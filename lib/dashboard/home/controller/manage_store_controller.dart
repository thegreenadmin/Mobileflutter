import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_categories_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class ManageStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressLine1TextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController townOrCityTextController = TextEditingController();
  TextEditingController postalCodeTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();

  RxBool autoValidate = false.obs;
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
    isMenuSelected.value = true;
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    storeLocation.value = Get.arguments["storeLocation"] ?? "";
    apiGetCategoriesList();
  }

  //Get Categories Api
  Future apiGetCategoriesList() async {
    categoriesList.clear();
    isLoading.value = true;
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
      isLoading.value = false;
      debugPrint("GET CATEGORIES LIST RESPONSE *******${value!.body}");
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

  //Get Products List Api
  Future apiGetProductList() async {
    categoriesList.clear();
    isLoading.value == true;
    debugPrint(
        "GET PRODUCT LIST URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value == false;
      debugPrint("GET PRODUCT LIST RESPONSE *******${value!.body}");
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
