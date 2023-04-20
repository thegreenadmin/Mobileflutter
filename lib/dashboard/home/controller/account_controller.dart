import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:dio/dio.dart' as mdio;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class AccountController extends GetxController {
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

  RxBool isScreenLockNotify = false.obs;
  RxBool isInboxMessagesNotify = false.obs;
  RxBool isTippingNotify = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isFromCart = false.obs;

  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString addressLine1 = "".obs;
  RxString addressLine2 = "".obs;
  RxString city = "".obs;
  RxString postalCode = "".obs;
  RxString country = "".obs;
  RxString state = "".obs;

  RxString countryDropdownValue = "".obs;
  RxString? countryId = "".obs;
  RxString? userId = "".obs;

  RxString stateDropdownValue = "".obs;
  RxString stateId = "".obs;
  RxInt countryIndex = 0.obs;
  RxInt stateIndex = 0.obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;
  List userAddress = [];

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  Rx<XFile> idProofImage = XFile("").obs;
  RxString idProofImageOrigionalLinkfromServer = "".obs;
  RxString idProofImageDynamicLinkfromServer = "".obs;

  var kGoogleApiKey = "";
  late GlobalConfigs secureData;

  @override
  void onInit() {
    super.onInit();
    isFromCart.value = Get.arguments["isFromCart"] ?? false;
    apiGetUserDetailApi();
    getGkey();
    Future.delayed(const Duration(milliseconds: 200), () {});
  }

  getGkey() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];

    // BioMetricAuthentication.isBioMetricAuthenticated.value =
    //     SharedPreferenceStorage.getData(
    //         StringConstants.authenticatedText.toLowerCase());

    // BioMetricAuthentication.isBioMetricAuthenticated.value
    //     ? isScreenLockNotify.value = true
    //     : isScreenLockNotify.value = false;
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "From where do you want to take the photo?",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_sharp,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Gallery",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(
                                imageQuality: 50,
                                source: ImageSource.gallery,
                                maxWidth: 900,
                                maxHeight: 900);
                        if (pickedFile != null) {
                          idProofImage.value = pickedFile;
                          await apiUploadImage();
                          update();
                        } else {
                          // api();
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Camera",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(
                                imageQuality: 50,
                                source: ImageSource.camera,
                                maxWidth: 900,
                                maxHeight: 900);
                        if (pickedFile != null) {
                          idProofImage.value = pickedFile;
                          await apiUploadImage();
                          update();
                        } else {
                          // api();
                        }
                      },
                    )
                  ],
                ),
              ));
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
          mdio.MultipartFile.fromBytes(await idProofImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(
          ServerCommunicator().baseUrl + ServerCommunicator().fileUpload,
          data: formData,
          options: mdio.Options(headers: headers));
      final responseData = res.data;
      debugPrint(
          "IMAGE UPLOAD URL LINK ******* ${ServerCommunicator().baseUrl}${ServerCommunicator().fileUpload}");
      debugPrint("IMAGE UPLOAD URL LINK *******$responseData");
      if (res.statusCode == 200 || res.statusCode == 201) {
        idProofImageOrigionalLinkfromServer.value =
            responseData['data']['urls']['orignal_url'];
        idProofImageDynamicLinkfromServer.value =
            responseData['data']['urls']['dynamic_url'];
        await apiAddUserIdProof();
        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode403) {
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
        apiUpdateUserDetail();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Get User Detail Info Api
  Future apiGetUserDetailApi() async {
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getUserDetailModel = GetUserDetailModel.fromJson(value.body);
        userId!.value = getUserDetailModel.data!.user!.userId ?? "";
        firstName!.value = getUserDetailModel.data!.user!.firstName ?? "";
        firstNameTextController.text = firstName!.value;
        lastName!.value = getUserDetailModel.data!.user!.lastName ?? "";
        lastNameTextController.text = lastName!.value;
        nickName!.value = getUserDetailModel.data!.user!.nickName ?? "";
        nickNameTextController.text = nickName!.value;
        email.value = getUserDetailModel.data!.user!.email ?? "";
        emailTextController.text = email.value;
        phone.value = getUserDetailModel.data!.user!.phone ?? "";
        List<UserAddresses> userAddress = <UserAddresses>[];
        userAddress = getUserDetailModel.data!.user!.userAddresses!;
        if (userAddress.isNotEmpty) {
          userAddress = getUserDetailModel.data!.user!.userAddresses!;
          for (int i = 0; i < userAddress.length; i++) {
            countryId!.value = userAddress[i].state!.country!.countryId ?? "";
            countryDropdownValue.value =
                userAddress[i].state!.country!.countryName ?? "";
            countryTextController.text = countryDropdownValue.value;
            stateId.value = userAddress[i].state!.stateId ?? "";
            stateDropdownValue.value = userAddress[i].state!.stateName ?? "";
            stateTextController.text = stateDropdownValue.value;
            country.value = countryDropdownValue.value;
            state.value = stateDropdownValue.value;
            addressLine1TextController.text = userAddress[i].addressLine1 ?? "";
            addressLine1.value = addressLine1TextController.text;
            addressLine2TextController.text = userAddress[i].addressLine2 ?? "";
            addressLine2.value = addressLine2TextController.text;
            townOrCityTextController.text = userAddress[i].city ?? "";
            city.value = townOrCityTextController.text;
            postalCodeTextController.text = userAddress[i].postalCode ?? "";
            postalCode.value = postalCodeTextController.text;
          }
          if (getUserDetailModel.data!.userProof != null) {
            idProofImageDynamicLinkfromServer.value =
                getUserDetailModel.data!.userProof!.image!.dynamicUrl ?? "";
          }
        }
        await apiGetCountries();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message'].toString());
      }
    });
  }

  //Get Countries Api
  Future apiGetCountries() async {
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
        if (userAddress.isEmpty && countryId!.value.isEmpty) {
          countryId!.value = countriesList[0].countryId!;
          countryIndex.value = 0;
        } else {
          for (int i = 0; i < countriesList.length; i++) {
            if (countryId!.value == countriesList[i].countryId) {
              countryIndex.value = i;
            }
          }
        }
        apiGetStates();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get States Api
  Future apiGetStates() async {
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
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Update User Detail Api
  Future apiUpdateUserDetail() async {
    debugPrint(
        "UPDATE USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().updateUser}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "user": {
        "first_name": firstNameTextController.text.trim(),
        "last_name": lastNameTextController.text.trim(),
        "nick_name": nickNameTextController.text.trim(),
      },
      "address": {
        "user_address_id": null,
        // "state_id": stateId.value,
        "state": stateTextController.text.trim(),
        "country": countryTextController.text.trim(),
        "address_name": "home",
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "city": townOrCityTextController.text,
        "postal_code": postalCodeTextController.text.trim()
      }
    };
    debugPrint("UPDATE USER DETAIL BODY**********$data");
    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().updateUser}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE USER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        firstNameTextController.clear();
        lastNameTextController.clear();
        nickNameTextController.clear();
        emailTextController.clear();
        addressLine1TextController.clear();
        addressLine2TextController.clear();
        townOrCityTextController.clear();
        postalCodeTextController.clear();
        stateTextController.clear();
        countryTextController.clear();
        if (isFromCart.value) {
          Get.back();
        } else {
          Get.back();
          await apiGetUserDetailApi();
          // await Get.offAll(BottomNavigation());
        }
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Add user id proof Api
  Future apiAddUserIdProof() async {
    debugPrint(
        "ID PROOF DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userProof}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "proof_type_id": 1,
      "proof_value": "123456",
      "image_url": idProofImageOrigionalLinkfromServer.value,
      "expiredAt": ""
    };
    debugPrint("ID PROOF DETAIL BODY**********$data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userProof}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("ID PROOF DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
