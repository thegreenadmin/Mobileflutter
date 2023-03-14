import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/home/view/search_store_owner_screen.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController storeNameTextController = TextEditingController();
  TextEditingController einTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController addressLine1TextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController townOrCityTextController = TextEditingController();
  TextEditingController postalCodeTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();

  RxBool isScreenLockNotify = false.obs;
  RxBool isInboxMessagesNotify = false.obs;
  RxBool isTippingNotify = false.obs;

  RxBool autoValidate = false.obs;
  RxBool isEnabledStore = false.obs;

  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString? storeAddressId = "".obs;

  RxString countryDropdownValue = "Afghanistan".obs;
  RxString? countryId = "".obs;

  RxString stateDropdownValue = "Andaman and Nicobar Islands".obs;
  RxString stateId = "".obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;

  RxBool isLoading = false.obs;
  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString storeLocation = "".obs;
  RxString storeImage = "".obs;
  RxInt? addressListIndex = 0.obs;

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;
  RxList<Addresses> address = <Addresses>[].obs;
  RxList<dynamic> storeAddresses = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    firstName!.value = Get.arguments["firstName"] ?? "";
    lastName!.value = Get.arguments["lastName"] ?? "";
    apiGetStoreList();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        apiUpdateStoreDetail();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Get Store List Api
  Future apiGetStoreList() async {
    storeList.clear();
    isLoading.value = true;
    debugPrint(
        "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().storeList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get particular store api
  Future apiGetParticularStore() async {
    debugPrint(
        "GET PARTICULAR STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetails}?store_id=$storeId");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetails}?store_id=$storeId",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET PARTICULAR STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        storeId.value = value.body["data"]['store']['store_id'] ?? "";
        storeNameTextController.text =
            value.body["data"]['store']['store_name'] ?? "";
        einTextController.text = value.body["data"]['store']['store_ein'] ?? "";
        nickNameTextController.text =
            value.body["data"]['store']['store_nick_name'] ?? "";
        phoneTextController.text =
            value.body["data"]['store']['store_phone'] ?? "";
        emailTextController.text =
            value.body["data"]['store']['store_email'] ?? "";
        einTextController.text = value.body["data"]['store']['store_ein'] ?? "";
        storeAddresses.value =
            value.body["data"]['store']['store_addresses'] ?? [];
        addressLine1TextController.text =
            storeAddresses[0]["address_line_1"] ?? "";
        addressLine2TextController.text =
            storeAddresses[0]["address_line_2"] ?? "";
        addressLine1TextController.text =
            storeAddresses[0]["address_line_1"] ?? "";
        townOrCityTextController.text = storeAddresses[0]["city"] ?? "";
        countryTextController.text =
            storeAddresses[0]["state"]['country']['country_name'] ?? "";
        countryId!.value =
            storeAddresses[0]["state"]['country']['country_id'] ?? "";
        storeAddressId!.value = storeAddresses[0]["store_address_id"] ?? "";
        await apiGetCountries();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Update Store Details Api
  Future apiUpdateStoreDetail() async {
    debugPrint(
        "UPDATE STORE DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetailsEdit}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "store_id": storeId.value,
      "store": {
        "store_name": storeNameTextController.text.trim(),
        "store_ein": einTextController.text.trim(),
        "image_url": null,
        "store_nick_name": nickNameTextController.text.trim(),
        "store_email": emailTextController.text.trim(),
        "store_phone": phoneTextController.text.trim(),
        "is_enabled": true
      },
      "store_address": {
        "store_address_id": storeAddressId!.value,
        "state_id": 1853,
        "address_name": "home",
        "longitude": 37.0902,
        "latitude": 95.7129,
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "landmark": "",
        "city": townOrCityTextController.text.trim()
      }
    };
    debugPrint("UPDATE STORE DETAIL BODY**********$data");
    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetailsEdit}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE USER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Get.back();
        Get.back();
        apiGetStoreList();
        storeNameTextController.clear();
        einTextController.clear();
        nickNameTextController.clear();
        emailTextController.clear();
        phoneTextController.clear();
        addressLine1TextController.clear();
        addressLine2TextController.clear();
        townOrCityTextController.clear();
        postalCodeTextController.clear();
        stateTextController.clear();
        countryTextController.clear();
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Countries Api
  Future apiGetCountries() async {
    countriesList.clear();
    debugPrint(
        "GET COUNTRIES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().countries,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET COUNTRIES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getCountriesModel = GetCountriesModel.fromJson(value.body);
        countriesList.addAll(
            getCountriesModel.data!.countries as Iterable<CountriesList>);
        //for (int i = 0; i < countriesList.length; i++) {
        //}
        apiGetState();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get States Api
  Future apiGetState() async {
    statesList.clear();
    debugPrint(
        "GET STATES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET STATES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getStateModel = GetStatesModel.fromJson(value.body);
        statesList.addAll(getStateModel.data!.states as Iterable<StatesList>);
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
