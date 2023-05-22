import 'dart:convert';

import 'package:dio/dio.dart' as mdio;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/delivery_services_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../model/categories_model.dart';

class AddNewStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  TextEditingController storeNameTextController = TextEditingController();
  TextEditingController einTextController = TextEditingController();
  TextEditingController storeNickNameTextController = TextEditingController();
  TextEditingController storeEmailTextController = TextEditingController();
  TextEditingController storePhoneTextController = TextEditingController();
  TextEditingController addressLine1TextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController townOrCityTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController workingDaysTextController = TextEditingController();
  TextEditingController deliveryServicesTextController =
      TextEditingController();
  TextEditingController termsTextController = TextEditingController();
  TextEditingController privacyTextController = TextEditingController();

  var kGoogleApiKey = "";
  late GlobalConfigs secureData;

  RxBool autoValidate = false.obs;
  RxBool isStoreLogoSelected = false.obs;

  RxBool is247Time = false.obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late DeliveryServicesResponse deliveryServicesResponse =
      DeliveryServicesResponse();
  RxList<DeliveryService> deliveryServices = <DeliveryService>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;

  RxString countryDropdownValue = "".obs;
  RxString? countryId = "".obs;
  RxString storeIdValue = "".obs;
  RxString stateDropdownValue = "".obs;
  RxString stateId = "".obs;
  RxInt radioGroupValue = 0.obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  Rx<XFile> storeImage = XFile("").obs;
  Rx<XFile> storeLogo = XFile("").obs;

  RxString storeImageOrigionalLinkfromServer = "".obs;
  RxString storeImageDynamicLinkfromServer = "".obs;

  RxString storeLogoOrigionalLinkfromServer = "".obs;
  RxString storeLogoDynamicLinkfromServer = "".obs;

  RxList<dynamic> selectedWeekDaysList = [].obs;

  RxList<Categories> weekDaysList = [
    Categories(id: 1, name: "Monday", isSelected: false),
    Categories(id: 2, name: "Tuesday", isSelected: false),
    Categories(id: 3, name: "Wednesday", isSelected: false),
    Categories(id: 4, name: "Thursday", isSelected: false),
    Categories(id: 5, name: "Friday", isSelected: false),
    Categories(id: 6, name: "Saturday", isSelected: false),
    Categories(id: 7, name: "Sunday", isSelected: false),
  ].obs;

  RxList<dynamic> storeTimmingList = <dynamic>[].obs;
  RxList<dynamic> deliveryServicesList = <dynamic>[].obs;

  dynamic lat = 0.0;
  dynamic lng = 0.0;
  ShortDynamicLink? shortLink;
  String? dynamicLink;
  @override
  void onInit() {
    super.onInit();
    getGkey();
    apiGetDeliveryServices();
  }

  Future<void> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://thegreenmall.page.link',
      link: Uri.parse(dynamicLink!),
      androidParameters: const AndroidParameters(
        packageName: 'com.app.thegreenmall',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.thegreenmall',
      ),
    );
    shortLink = await dynamicLinks.buildShortLink(parameters);
    debugPrint("PARAMETERS **************${shortLink!.shortUrl}");
  }

  getGkey() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];
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

  void validateAndSubmit(BuildContext ctx) async {
    if (validateAndSave()) {
      try {
        if (storeLogoDynamicLinkfromServer.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectLogoText);
        } else if (storeImageDynamicLinkfromServer.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectBannerText);
        } else {
          apiCreateStore(ctx);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      // Get.back();
      // Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        if (isStoreLogoSelected.value) {
          storeLogo.value = pickedFile;
          await apiUploadImage();
          update();
        } else {
          storeImage.value = pickedFile;
          await apiUploadImage();
          update();
        }
      } else {
        // api();
      }
    }, onCameraClick: () async {
      // Get.back();
      // Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        if (isStoreLogoSelected.value) {
          storeLogo.value = pickedFile;
          await apiUploadImage();
          update();
        } else {
          storeImage.value = pickedFile;
          await apiUploadImage();
          update();
        }
      } else {
        // api();
      }
    });
  }

  //Api upload image to server
  Future apiUploadImage() async {
    try {
      final dio = mdio.Dio();
      mdio.FormData formData = mdio.FormData.fromMap({});
      Map<String, String> headers = {
        'Authorization':
            "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
      };
      formData.files.add(MapEntry(
          "file",
          mdio.MultipartFile.fromBytes(
              isStoreLogoSelected.value
                  ? await storeLogo.value.readAsBytes()
                  : await storeImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(
          ServerCommunicator().baseUrl + ServerCommunicator().fileUpload,
          data: formData,
          options: mdio.Options(headers: headers));
      final responseData = res.data;
      debugPrint(
          "IMAGE UPLOAD URL LINK ******* ${ServerCommunicator().baseUrl}${ServerCommunicator().fileUpload}");
      debugPrint("IMAGE UPLOAD URL RESPONSE *******$responseData");
      if (res.statusCode == ApiConstants.statusCode200 ||
          res.statusCode == ApiConstants.statusCode201) {
        if (isStoreLogoSelected.value) {
          storeLogoOrigionalLinkfromServer.value =
              responseData['data']['urls']['orignal_url'];
          storeLogoDynamicLinkfromServer.value =
              responseData['data']['urls']['dynamic_url'];
          isStoreLogoSelected.value = false;
        } else {
          storeImageOrigionalLinkfromServer.value =
              responseData['data']['urls']['orignal_url'];
          storeImageDynamicLinkfromServer.value =
              responseData['data']['urls']['dynamic_url'];
        }

        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode401) {
        Utility.showAlertMessage(responseData['message'].toString());
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      if (e is mdio.DioError) {
        if (e.type == mdio.DioErrorType.badResponse) {
          debugPrint("${e.response?.data ?? ""}");
          final responseData =
              json.decode(e.response?.data) as Map<String, dynamic>;
          return responseData;
        }
      }
      throw Exception('Failed to load data ! $e');
    }
  }

  //Create Store Api
  Future apiCreateStore(BuildContext contextt) async {
    Map data = {
      "store": {
        "store_name": storeNameTextController.text.trim(),
        "store_ein": einTextController.text.trim(),
        "image_url": storeImageOrigionalLinkfromServer.value,
        "logo_url": storeLogoOrigionalLinkfromServer.value,
        "store_nick_name": storeNickNameTextController.text.trim(),
        "store_email": storeEmailTextController.text.trim(),
        "store_phone": phoneNumber.value,
        "store_phone_code": countryCode.value
      },
      "store_address": {
        // "state_id": stateId.value.trim(),
        "state": stateTextController.text.trim(),
        "country": countryTextController.text.trim(),
        "address_name": "home",
        "longitude": lng,
        "latitude": lat,
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "landmark": "",
        "city": townOrCityTextController.text.trim(),
        "postal_code": zipCodeTextController.text.trim()
      },
      "is_24_hours_active": is247Time.value,
      "store_timings": is247Time.value == true ? [] : storeTimmingList,
      "store_delivery_services": deliveryServicesList,
      "store_pages": [
        {
          "store_page_type": "terms",
          "store_page_content": termsTextController.text.trim()
        },
        {
          "store_page_type": "privacy",
          "store_page_content": privacyTextController.text.trim()
        }
      ]
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE STORE BODY********** $data");
    debugPrint(
        "CREATE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createStore}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().createStore,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        // Get.back();
        openingTimeTextController.clear();
        closingTimeTextController.clear();
        deliveryServicesTextController.clear();
        workingDaysTextController.clear();

        storeNameTextController.clear();
        einTextController.clear();
        storeNickNameTextController.clear();
        storeEmailTextController.clear();
        storePhoneTextController.clear();
        addressLine1TextController.clear();
        addressLine2TextController.clear();
        townOrCityTextController.clear();
        zipCodeTextController.clear();
        stateTextController.clear();
        countryTextController.clear();
        stateTextController.clear();
        countryTextController.clear();
        storeImageOrigionalLinkfromServer.value = "";
        storeLogoOrigionalLinkfromServer.value = "";
        storeImageDynamicLinkfromServer.value = "";
        storeLogoDynamicLinkfromServer.value = "";
        deliveryServicesList.clear();
        deliveryServices.clear();
        weekDaysList.clear();
        privacyTextController.clear();
        storeTimmingList.clear();
        termsTextController.clear();
        //storeIdValue.value = value.body["status"]
        storeIdValue.value = value.body["data"]['store_id'].toString();
        dynamicLink =
            ServerCommunicator().baseUrlWithoutApi + storeIdValue.value;
        Navigator.of(contextt).pop();
        await createDynamicLink();
        await apiDynamicLink();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(contextt).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

  //Dynamic link
  Future apiDynamicLink() async {
    debugPrint(
        "DYNAMIC URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeDynamicLinkUpdate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "store_id": int.parse(storeIdValue.value),
      "dynamic_link": shortLink!.shortUrl.toString(),
    };
    debugPrint("DYNAMIC LINK BODY**********$data");

    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDynamicLinkUpdate}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("DYNAMIC LINK RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.pop(Get.context!);
        // Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
        //   builder: (_) => const StartJourneyScreen(),
        // ));
      } else {}
    });
  }

  //Get DeliveryServices Api
  Future apiGetDeliveryServices() async {
    deliveryServices.clear();
    debugPrint(
        "GET DELIVERY LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().deliveryServiceList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl +
                ServerCommunicator().deliveryServiceList,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET DELIVERY LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        deliveryServicesResponse =
            DeliveryServicesResponse.fromJson(value.body);
        deliveryServices.value =
            deliveryServicesResponse.data!.deliveryServices!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getCountriesModel = GetCountriesModel.fromJson(value.body);
        countriesList.value = getCountriesModel.data!.countries!;
        if (countryId!.value.isEmpty) {
          countryId!.value = countriesList[0].countryId!;
        }
        apiGetStates();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

  //Get States Api
  Future apiGetStates() async {
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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStateModel = GetStatesModel.fromJson(value.body);
        statesList.value = getStateModel.data!.states!;
        if (stateId.value.isNotEmpty) {
          for (int i = 0; i < statesList.length; i++) {
            if (stateId.value == statesList[i].stateId) {
              stateId.value = statesList[i].stateId.toString();
            }
          }
        } else {
          stateId.value = statesList[0].stateId.toString();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }
}
