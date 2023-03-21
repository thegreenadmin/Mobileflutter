import 'dart:convert';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../model/categories_model.dart';

class AddNewStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController storeNameTextController = TextEditingController();
  TextEditingController einTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
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

  RxBool autoValidate = false.obs;
  RxBool isStoreLogoSelected = false.obs;

  RxBool is247Time = false.obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;

  RxString countryDropdownValue = "".obs;
  RxString? countryId = "".obs;

  RxString stateDropdownValue = "".obs;
  RxString stateId = "".obs;
  RxInt radioGroupValue = 0.obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;

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

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {
      apiGetCountries();
    });
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
        if (storeLogoDynamicLinkfromServer.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectLogoText);
        } else if (storeImageDynamicLinkfromServer.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectBannerText);
        } else {
          apiCreateStore();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "From where do you want to take the photo?",
                style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_sharp,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Gallery", style: TextStyle(color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(imageQuality: 50, source: ImageSource.gallery, maxWidth: 900, maxHeight: 900);
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
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Camera", style: TextStyle(color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(imageQuality: 50, source: ImageSource.camera, maxWidth: 900, maxHeight: 900);
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
        'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
      };
      formData.files.add(MapEntry(
          "file",
          mdio.MultipartFile.fromBytes(
              isStoreLogoSelected.value ? await storeLogo.value.readAsBytes() : await storeImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(ServerCommunicator().baseUrl + ServerCommunicator().fileUpload,
          data: formData, options: mdio.Options(headers: headers));
      final responseData = res.data;
      debugPrint("IMAGE UPLOAD URL LINK ******* ${ServerCommunicator().baseUrl}${ServerCommunicator().fileUpload}");
      debugPrint("IMAGE UPLOAD URL RESPONSE *******$responseData");
      if (res.statusCode == 200 || res.statusCode == 201) {
        if (isStoreLogoSelected.value) {
          storeLogoOrigionalLinkfromServer.value = responseData['data']['urls']['orignal_url'];
          storeLogoDynamicLinkfromServer.value = responseData['data']['urls']['dynamic_url'];
          isStoreLogoSelected.value = false;
        } else {
          storeImageOrigionalLinkfromServer.value = responseData['data']['urls']['orignal_url'];
          storeImageDynamicLinkfromServer.value = responseData['data']['urls']['dynamic_url'];
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
          final responseData = json.decode(e.response?.data) as Map<String, dynamic>;
          return responseData;
        }
      }
      throw Exception('Failed to load data ! $e');
    }
  }

  //Create Store Api
  Future apiCreateStore() async {
    Map data = {
      "store": {
        "store_name": storeNameTextController.text.trim(),
        "store_ein": einTextController.text.trim(),
        "image_url": storeImageOrigionalLinkfromServer.value,
        "logo_url": storeLogoOrigionalLinkfromServer.value,
        "store_nick_name": storeNickNameTextController.text.trim(),
        "store_email": storeEmailTextController.text.trim(),
        "store_phone": storePhoneTextController.text.trim()
      },
      "store_address": {
        "state_id": stateId.value.trim(),
        "address_name": "home",
        "longitude": 37.0902,
        "latitude": 95.7129,
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "landmark": "",
        "city": townOrCityTextController.text.trim()
      },
      "store_timings": is247Time.value == true
          ? [
              {"is_24_hours_active": is247Time.value, "day_of_week": "", "opening_time": "", "closing_time": ""}
            ]
          : storeTimmingList
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE STORE BODY********** $data");
    debugPrint("CREATE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createStore}");
    UserProvider()
        .postWithHeadersApi(data, ServerCommunicator().baseUrl + ServerCommunicator().createStore, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back();
        });
        storeNameTextController.clear();
        einTextController.clear();
        nickNameTextController.clear();
        storeNickNameTextController.clear();
        storeEmailTextController.clear();
        storePhoneTextController.clear();
        addressLine1TextController.clear();
        addressLine2TextController.clear();
        townOrCityTextController.clear();
        zipCodeTextController.clear();
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
    debugPrint("GET COUNTRIES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(ServerCommunicator().baseUrl + ServerCommunicator().countries, headers, showLoading: false)
        .then((value) async {
      debugPrint("GET COUNTRIES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getCountriesModel = GetCountriesModel.fromJson(value.body);
        countriesList.value = getCountriesModel.data!.countries!;
        if (countryId!.value.isEmpty) {
          countryId!.value = countriesList[0].countryId!;
        }
        apiGetStates();
      } else if (value.body["status"] == 403) {
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
    statesList.clear();
    debugPrint(
        "GET STATES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId", headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET STATES RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
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
