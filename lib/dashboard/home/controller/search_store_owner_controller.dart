import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/delivery_services_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../model/categories_model.dart';

class OwnerStoresController extends GetxController {
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
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController workingDaysTextController = TextEditingController();
  TextEditingController deliveryServicesTextController =
      TextEditingController();
  TextEditingController storePrivacyTextController = TextEditingController();
  TextEditingController storeTermsTextController = TextEditingController();

  var kGoogleApiKey = "";
  late GlobalConfigs secureData;

  RxBool isScreenLockNotify = false.obs;
  RxBool isInboxMessagesNotify = false.obs;
  RxBool isTippingNotify = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isEnabledStore = false.obs;
  RxBool isLoading = false.obs;
  RxBool is247Time = false.obs;
  RxBool isEnabled = false.obs;
  RxBool isStoreLogoSelected = false.obs;

  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString? storeAddressId = "".obs;
  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString storeLocation = "".obs;
  RxString? storeImage = "".obs;
  RxString? storeLogo = "".obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;
  RxString countryDropdownValue = "".obs;
  RxString? countryId = "".obs;
  RxString stateDropdownValue = "".obs;
  CountriesList? selectedValue;
  RxString stateId = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;

  RxInt? addressListIndex = 0.obs;
  RxInt stateIndex = 0.obs;
  RxInt countryIndex = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxInt radioGroupValue = 0.obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  late DeliveryServicesResponse deliveryServicesResponse =
      DeliveryServicesResponse();
  RxList<DeliveryService> deliveryServices = <DeliveryService>[].obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferlist = <OffersList>[].obs;

  RxList<StoreAddresses> address = <StoreAddresses>[].obs;

  RxList<dynamic> storeAddresses = <dynamic>[].obs;
  RxList<dynamic> storeTimings = <dynamic>[].obs;
  RxList<dynamic> storeDeliveryServices = <dynamic>[].obs;
  RxList<dynamic> storeTimmingList = <dynamic>[].obs;
  RxList<dynamic> deliveryServicesList = <dynamic>[].obs;

  RxString editStoreImageOrigionalLinkfromServer = "".obs;
  RxString editStoreImageDynamicLinkfromServer = "".obs;

  RxString editStoreLogoOrigionalLinkfromServer = "".obs;
  RxString editStoreLogoDynamicLinkfromServer = "".obs;

  Rx<XFile> editStoreImage = XFile("").obs;
  Rx<XFile> editStoreLogo = XFile("").obs;

  RxList<Categories> weekDaysList = [
    Categories(id: 1, name: "Monday", isSelected: false),
    Categories(id: 2, name: "Tuesday", isSelected: false),
    Categories(id: 3, name: "Wednesday", isSelected: false),
    Categories(id: 4, name: "Thursday", isSelected: false),
    Categories(id: 5, name: "Friday", isSelected: false),
    Categories(id: 6, name: "Saturday", isSelected: false),
    Categories(id: 7, name: "Sunday", isSelected: false),
  ].obs;
  dynamic lat = 0.0;
  dynamic lng = 0.0;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 0;
    getApiData();
    getGkey();
    if (Get.arguments['isFromHome'] == true) {
      storeId.value = Get.arguments['storeId'] ?? "";
      apiGetParticularStore();
    }
  }

  getGkey() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];
  }

  getApiData() async {
    await apiGetStoreList();
    await apiGetDeliveryServices();
    await apiGetOwnerOffersList();
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

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        if (isStoreLogoSelected.value) {
          editStoreLogo.value = pickedFile;
          await apiUploadImage();
          update();
        } else {
          editStoreImage.value = pickedFile;
          await apiUploadImage();
          update();
        }
      } else {
        // api();
      }
    }, onCameraClick: () async {
      Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        if (isStoreLogoSelected.value) {
          editStoreLogo.value = pickedFile;
          await apiUploadImage();
          update();
        } else {
          editStoreImage.value = pickedFile;
          await apiUploadImage();
          update();
        }
      } else {
        // api();
      }
    });
  }

  //Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    isLoading.value = true;
    debugPrint(
        "GET OWNER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "store_id": storeId.value,
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
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER OFFERS LIST BODY ******* $body");
      debugPrint("OWNER OFFERS LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value?.body);
        getOwnerOfferlist.value = getOwnerOffersListModel.data!.offers!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

//Get featured products List Api
  Future apiGetFeaturedProducts() async {
    isLoading.value = true;
    debugPrint(
      "GET FEATURED PRODUCTS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 10,
      "order_by": "product_id",
      "order_type": "ASC",
      "category_id": null,
      "filters": [
        {
          "filter_by": "is_featured_product",
          "filter_value": true,
          "operation": "eq"
        }
      ]
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET FEATURED PRODUCTS LIST BODY *******$body");
      debugPrint("GET FEATURED PRODUCTS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreProductList = GetStoreProductList.fromJson(value.body);
        storeProductList.value = getStoreProductList.data!.products!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
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
                  ? await editStoreLogo.value.readAsBytes()
                  : await editStoreImage.value.readAsBytes(),
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
          editStoreLogoOrigionalLinkfromServer.value =
              responseData['data']['urls']['orignal_url'];
          editStoreLogoDynamicLinkfromServer.value =
              responseData['data']['urls']['dynamic_url'];
          isStoreLogoSelected.value = false;
        } else {
          editStoreImageOrigionalLinkfromServer.value =
              responseData['data']['urls']['orignal_url'];
          editStoreImageDynamicLinkfromServer.value =
              responseData['data']['urls']['dynamic_url'];
        }
        return responseData;
      } else if (res.statusCode == 403) {
        Utility.showToast(responseData['message'].toString());
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

  //Get Store List Api
  Future apiGetStoreList() async {
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
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
      debugPrint("GET DELIVERY LIST  RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        deliveryServicesResponse =
            DeliveryServicesResponse.fromJson(value.body);
        deliveryServices.value =
            deliveryServicesResponse.data?.deliveryServices ?? [];
      } else if (value.body["status"] == ApiConstants.statusCode401) {
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
      log("GET PARTICULAR STORE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        storeId.value = value?.body["data"]['store']['store_id'] ?? "";
        editStoreImageDynamicLinkfromServer.value =
            value?.body["data"]['store']['image']["dynamic_url"] ?? "";
        editStoreLogoDynamicLinkfromServer.value =
            value?.body["data"]['store']['logo']["dynamic_url"] ?? "";
        editStoreImageOrigionalLinkfromServer.value =
            value?.body["data"]['store']['image']["orignal_url"] ?? "";
        editStoreLogoOrigionalLinkfromServer.value =
            value?.body["data"]['store']['logo']["orignal_url"] ?? "";
        storeNameTextController.text =
            value?.body["data"]['store']['store_name'] ?? "";
        einTextController.text =
            value?.body["data"]['store']['store_ein'] ?? "";
        nickNameTextController.text =
            value?.body["data"]['store']['store_nick_name'] ?? "";
        phoneTextController.text =
            value?.body["data"]['store']['store_phone'] ?? "";
        phoneNumber.value = phoneTextController.text;
        countryCode.value =
            value?.body["data"]['store']['store_phone_code'] ?? "";
        emailTextController.text =
            value?.body["data"]['store']['store_email'] ?? "";
        einTextController.text =
            value?.body["data"]['store']['store_ein'] ?? "";
        storeAddresses.value =
            value?.body["data"]['store']['store_addresses'] ?? [];
        storeTimings.value =
            value?.body["data"]['store']['store_timings'] ?? [];
        storeDeliveryServices.value =
            value?.body["data"]['store']['store_delivery_services'] ?? [];
        isEnabled.value = value?.body["data"]['store']['is_enabled'] ?? [];
        if (storeAddresses.isNotEmpty) {
          for (int i = 0; i < storeAddresses.length; i++) {
            addressLine1TextController.text =
                storeAddresses[i]["address_line_1"] ?? "";
            addressLine2TextController.text =
                storeAddresses[i]["address_line_2"] ?? "";
            addressLine1TextController.text =
                storeAddresses[i]["address_line_1"] ?? "";
            townOrCityTextController.text = storeAddresses[i]["city"] ?? "";
            stateTextController.text =
                storeAddresses[i]["state"]['state_name'] ?? "";
            countryTextController.text =
                storeAddresses[i]["state"]['country']['country_name'] ?? "";
            countryId!.value =
                storeAddresses[i]["state"]['country']['country_id'] ?? "";
            countryDropdownValue.value =
                storeAddresses[i]["state"]['country']['country_name'] ?? "";
            stateId.value = storeAddresses[i]["state"]['state_id'] ?? "";
            stateDropdownValue.value =
                storeAddresses[i]["state"]['state_name'] ?? "";
            storeAddressId!.value = storeAddresses[i]["store_address_id"] ?? "";
            postalCodeTextController.text =
                storeAddresses[i]["postal_code"] ?? "";
          }
        }
        if (storeTimings.isNotEmpty) {
          for (int i = 0; i < storeTimings.length; i++) {
            is247Time.value = storeTimings[i]["is_24_hours_active"] ?? false;
            if (is247Time.value == true) {
              radioGroupValue.value = 1;
            } else {
              radioGroupValue.value = 0;
              openingTimeTextController.text = Utility.formatDateTime(
                      storeTimings[i]["opening_time"] ?? '',
                      firstFormat: "hh:mm:ss",
                      secFormat: "hh:mm a")
                  .toString();
              openingTime.value = openingTimeTextController.text;
              closingTimeTextController.text = Utility.formatDateTime(
                      storeTimings[i]["closing_time"] ?? '',
                      firstFormat: "hh:mm:ss",
                      secFormat: "hh:mm a")
                  .toString();
              closingTime.value = closingTimeTextController.text;
            }
          }
        } else {
          is247Time.value = true;
        }
        if (is247Time.value == false) {
          for (var sData in storeTimings) {
            for (var element in weekDaysList) {
              if (sData["day_of_week"] == element.id) {
                element.isSelected = true;
              }
            }
          }
        }
        debugPrint(
            "deliveryServices isNotEmpty: ===== ${deliveryServices.isNotEmpty}");

        if (storeDeliveryServices.isNotEmpty) {
          for (var sData in storeDeliveryServices) {
            for (var element in deliveryServices) {
              if (element.id == sData["delivery_service_id"]) {
                element.isSelected = sData["is_enabled"];
              }
            }
          }
        }
        List storePages = value?.body["data"]['store_pages'] ?? [];
        if (storePages.isNotEmpty) {
          for (int i = 0; i < storePages.length; i++) {
            if (storePages[i]['store_page_type'] == "terms") {
              storeTermsTextController.text =
                  storePages[i]['store_page_content'];
            } else {
              storePrivacyTextController.text =
                  storePages[i]['store_page_content'];
            }
          }
        }

        //  await apiGetCountries();
      } else {
        Utility.showToast(value?.body['message']);
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
      "store_id": int.parse(storeId.value),
      "store": {
        "store_name": storeNameTextController.text.trim(),
        "store_ein": einTextController.text.trim(),
        "image_url": editStoreImageOrigionalLinkfromServer.value,
        "logo_url": editStoreLogoOrigionalLinkfromServer.value,
        "store_nick_name": nickNameTextController.text.trim(),
        "store_email": emailTextController.text.trim(),
        "store_phone": phoneNumber.value,
        "store_phone_code": countryCode.value,
        "is_enabled": isEnabled.value
      },
      "store_address": {
        "store_address_id": int.parse(storeAddressId!.value),
        // "state_id": stateId.value,
        "state": stateTextController.text.trim(),
        "country": countryTextController.text.trim(),
        "address_name": "home",
        "longitude": lng,
        "latitude": lat,
        "postal_code": postalCodeTextController.text.trim(),
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "landmark": "",
        "city": townOrCityTextController.text.trim()
      },
      "is_24_hours_active": is247Time.value,
      "store_timings": is247Time.value == true
          ? []
          : storeTimmingList.isNotEmpty
              ? storeTimmingList
              : storeTimings,
      "store_delivery_services": deliveryServicesList,
      "store_pages": [
        {
          "store_page_type": "terms",
          "store_page_content": storeTermsTextController.text
        },
        {
          "store_page_type": "privacy",
          "store_page_content": storePrivacyTextController.text
        }
      ]
    };
    debugPrint("UPDATE STORE DETAIL BODY**********$data");

    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetailsEdit}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE STORE DETAIL RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        Get.back();
        Get.back();
        await apiGetStoreList();
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
        countryCode.value = "";
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getCountriesModel = GetCountriesModel.fromJson(value.body);
        countriesList.clear();
        countriesList.addAll(
            getCountriesModel.data!.countries as Iterable<CountriesList>);
        if (countryId!.value.isEmpty) {
          countryId!.value = countriesList[0].countryId!;
          countryIndex.value = 0;
        } else {
          for (int i = 0; i < countriesList.length; i++) {
            if (countryId!.value == countriesList[i].countryId) {
              countryIndex.value = i;
            }
          }
        }
        apiGetState();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get States Api
  Future apiGetState() async {
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
        statesList.clear();
        statesList.addAll(getStateModel.data!.states as Iterable<StatesList>);
        if (stateId.value.isNotEmpty) {
          for (int i = 0; i < statesList.length; i++) {
            if (stateId.value == statesList[i].stateId) {
              stateIndex.value = i;
              stateId.value = statesList[i].stateId.toString();
            }
          }
        } else {
          stateIndex.value = 0;
          stateId.value = statesList[0].stateId.toString();
        }
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Delete Store api
  Future apiDeleteStore({String storeId = ""}) async {
    debugPrint(
        "DELETE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {"store_id": storeId};

    debugPrint("DELETE STORE BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetStoreList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
        await apiGetStoreList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
