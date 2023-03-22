import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;

  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firstName!.value = Get.arguments["firstName"] ?? "";
    lastName!.value = Get.arguments["lastName"] ?? "";
  }

  //Get Nearby Stores Api
  Future apiGetNearByStores() async {
    debugPrint("GET GET NEARBY STORES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(ServerCommunicator().baseUrl + ServerCommunicator().countries, headers, showLoading: false)
        .then((value) async {
      debugPrint("GET COUNTRIES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        // getCountriesModel = GetCountriesModel.fromJson(value.body);
        // countriesList.addAll(
        //     getCountriesModel.data!.countries as Iterable<CountriesList>);
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
