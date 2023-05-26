import 'dart:convert';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/model/active_membership_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/home/model/membership_plan_model.dart';
import 'package:thegreenmall/dashboard/home/model/notification_status_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

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
  TextEditingController noOfDaysTextController = TextEditingController();
  RxBool isScreenLockNotify = false.obs;
  RxBool isUserInboxMessagesNotify = false.obs;
  RxBool isOwnerInboxMessagesNotify = false.obs;
  RxBool isUserTippingNotify = false.obs;
  RxBool isOwnerTippingNotify = false.obs;
  RxBool isOnwerOfferNotify = false.obs;
  RxBool isUserOfferNotify = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isFromCart = false.obs;
  RxBool isOwner = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasStoreAccess = false.obs;

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
  int? selectedIndex;
  RxString selectedMembershipPlanId = "".obs;

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

  NotificationStatusModel notificationStatusModel = NotificationStatusModel();
  RxList<NotificationSettings> notificationStatusList =
      <NotificationSettings>[].obs;

  MembershipPlanModel membershipPlanModel = MembershipPlanModel();
  RxList<MembershipPlans> membershipList = <MembershipPlans>[].obs;

  ActiveMembershipPlanModel activeMembershipPlanModel =
      ActiveMembershipPlanModel();
  RxList<ActiveMemberships> activeMembershipList = <ActiveMemberships>[].obs;

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
    // isFromCart.value = Get.arguments["isFromCart"] ?? false;
    isFromCart.value = Get.parameters["isFromCart"] == "true" ? true : false;
    debugPrint(isFromCart.value.toString());
    apiGetUserDetailApi(Get.context!);
    getGkey(Get.context!);
  }

  getGkey(context) async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];

    BioMetricAuthentication.isBioMetricAuthenticated.value =
        SharedPreferenceStorage.getData(
                StringConstants.authenticatedText.toLowerCase()) ??
            false;

    if (SharedPreferenceStorage.getData(Role.role.value).toString() ==
        Role.customerRoleText) {
      await apiGetNotificationStatus(false, context);
    } else {
      await apiGetNotificationStatus(true, context);
    }

    isOwner.value = BioMetricAuthentication.isBioMetricAuthenticated.value
        ? isScreenLockNotify.value = true
        : isScreenLockNotify.value = false;
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      // Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        idProofImage.value = pickedFile;
        await apiUploadImage(context);
        update();
      } else {
        // api();
      }
    }, onCameraClick: () async {
      //Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        idProofImage.value = pickedFile;
        await apiUploadImage(context);
        update();
      } else {
        // api();
      }
    });
  }

  storeAccessDailogue(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              Center(
                child: Image.asset(
                  ImageConstants.info,
                  color: AppColors.green,
                  scale: 2,
                ),
              ),
              height12SizedBox,
              Text(
                StringConstants.storeAccessText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              height12SizedBox,
              Text(
                StringConstants.yourAreQualifiedText,
                style: TextStyle(
                    color: AppColors.blacklight,
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
              height20SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                      apiCreateStoreAccess();
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const <Widget>[],
      ),
    );
  }

  noOfDaysForMembershipDailogue(BuildContext context, {String days = ""}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height10SizedBox,
              height12SizedBox,
              const Text(
                "Enter number of days",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              height12SizedBox,
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  controller: noOfDaysTextController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    //suffixText: "*$days Days",
                    hintText: StringConstants.numberOfDaysText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                  )),
              height20SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      if (noOfDaysTextController.text.isEmpty) {
                        Utility.showAlertMessage("Please enter days");
                      } else {
                        Get.back();
                        apiCreateMembershipPlan();
                      }
                    },
                    child: Container(
                      height: 50.0,
                      width: WidgetConstants.screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          StringConstants.okayText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: const <Widget>[],
      ),
    );
  }

  //Api upload image to server
  Future apiUploadImage(context) async {
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
        await apiAddUserIdProof(context);
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

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(context) async {
    if (validateAndSave()) {
      try {
        apiUpdateUserDetail(context);
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Get User Detail Info Api
  Future apiGetUserDetailApi(context) async {
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
        hasStoreAccess.value =
            getUserDetailModel.data!.user!.hasStoreAccess ?? false;
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
        await apiGetCountries(Get.context!);
        await apiGetMembershipList();
        await apiGetActiveMembershipList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        await apiGetCountries(context);
      } else if (value.body["status"] == 401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        if (Get.context != null) {
          Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
            builder: (_) => const StartJourneyScreen(),
          ));
        }
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message'].toString());
      }
    });
  }

  //Get Countries Api
  Future apiGetCountries(context) async {
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
        apiGetStates(context);
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Get States Api
  Future apiGetStates(context) async {
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
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Update User Detail Api
  Future apiUpdateUserDetail(context) async {
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
        "user_address_id":
            getUserDetailModel.data?.user?.userAddresses != null &&
                    getUserDetailModel.data!.user!.userAddresses!.isNotEmpty
                ? getUserDetailModel
                        .data?.user?.userAddresses?.first.userAddressId ??
                    0
                : null,
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
          // if(Get.context!=null){
          Navigator.of(context).pop();
          // }
          // Get.back();
        } else {
          // Get.back();
          // if(Get.context!=null){
          Navigator.of(context).pop();
          // }
          await apiGetUserDetailApi(context);
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        // if(Get.context!=null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // }

        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Add user id proof Api
  Future apiAddUserIdProof(context) async {
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
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Get Notification Status Api
  Future apiGetNotificationStatus(bool isOwner, BuildContext context) async {
    debugPrint(
        "GET NOTIFICATION STATUS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().notificationList}?is_for_store=$isOwner");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().notificationList}?is_for_store=$isOwner",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET NOTIFICATION STATUS RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        notificationStatusModel = NotificationStatusModel.fromJson(value.body);

        notificationStatusList.value =
            notificationStatusModel.data!.notificationSettings!;

        for (int i = 0; i < notificationStatusList.length; i++) {
          if (notificationStatusList[i].notificationType == "order") {
            if (notificationStatusList[i].isForStore == true) {
              if (notificationStatusList[i].isEnabled == true) {
                isOwnerTippingNotify.value =
                    notificationStatusList[i].isEnabled == true;
                isUserTippingNotify.value =
                    notificationStatusList[i].isEnabled != true;
              }
            } else {
              if (notificationStatusList[i].isEnabled == true) {
                isOwnerTippingNotify.value =
                    notificationStatusList[i].isEnabled != true;
                isUserTippingNotify.value =
                    notificationStatusList[i].isEnabled == true;
              }
            }
          }
          if (notificationStatusList[i].notificationType == "offer") {
            if (notificationStatusList[i].isForStore == true) {
              if (notificationStatusList[i].isEnabled == true) {
                isOnwerOfferNotify.value =
                    notificationStatusList[i].isEnabled == true;
                isUserOfferNotify.value =
                    notificationStatusList[i].isEnabled != true;
              }
            } else {
              if (notificationStatusList[i].isEnabled == true) {
                isOnwerOfferNotify.value =
                    notificationStatusList[i].isEnabled != true;
                isUserOfferNotify.value =
                    notificationStatusList[i].isEnabled == true;
              }
            }
          }
          if (notificationStatusList[i].notificationType == "message") {
            if (notificationStatusList[i].isForStore == true) {
              if (notificationStatusList[i].isEnabled == true) {
                isOwnerInboxMessagesNotify.value =
                    notificationStatusList[i].isEnabled == true;
                isUserInboxMessagesNotify.value =
                    notificationStatusList[i].isEnabled != true;
              }
            } else {
              if (notificationStatusList[i].isEnabled == true) {
                isOwnerInboxMessagesNotify.value =
                    notificationStatusList[i].isEnabled != true;
                isUserInboxMessagesNotify.value =
                    notificationStatusList[i].isEnabled == true;
              }
            }
          }
        }

        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Update Notification Status
  Future apiUpdateNotificationStatus(
    context, {
    String notificationType = "",
    bool isOwner = false,
    bool isEnabled = false,
  }) async {
    debugPrint(
        "UPDATE NOTIFICATION STATUS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().notificationSettingSave}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "notification_type": notificationType,
      "is_for_store": isOwner,
      "is_enabled": isEnabled
    };
    debugPrint("UPDATE NOTIFICATION STATUS BODY**********$data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().notificationSettingSave}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE NOTIFICATION STATUS RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        if (SharedPreferenceStorage.getData(Role.role.value).toString() ==
            Role.customerRoleText) {
          await apiGetNotificationStatus(
            false,
            context,
          );
        } else {
          await apiGetNotificationStatus(
            true,
            context,
          );
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Create store access
  Future apiCreateStoreAccess() async {
    debugPrint(
        "CREATE USER ACCESS URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStoreAccessCreate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"has_store_access": true};
    debugPrint("CREATE USER ACCESS BODY**********$data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStoreAccessCreate}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE USER ACCESS RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Get.offAll(() => BottomNavigation());
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Get membership list
  Future apiGetMembershipList() async {
    debugPrint(
      "GET MEMBERSHIP LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().utilMembershipPlans}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().utilMembershipPlans}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET MEMBERSHIP LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        membershipPlanModel = MembershipPlanModel.fromJson(value.body);
        membershipList.value = membershipPlanModel.data!.membershipPlans!;
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  apiCreateMembershipPlan() {
    debugPrint(
        "CREATE MEMBERSHIP URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userMembershipCreate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "membership_plan_id": selectedMembershipPlanId.value,
      "count": noOfDaysTextController.text.trim()
    };
    debugPrint("CREATE MEMBERSHIP BODY**********$data");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userMembershipCreate}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE MEMBERSHIP RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Get.back();
        noOfDaysTextController.clear();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        noOfDaysTextController.clear();
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Get active membership list
  Future apiGetActiveMembershipList() async {
    debugPrint(
      "GET ACTIVE MEMBERSHIP LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userMembershipList}?active_memberships=true&page=1&page_size=100&order_by=membership_id&order_type=DESC",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userMembershipList}?active_memberships=true&page=1&page_size=100&order_by=membership_id&order_type=DESC",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET ACTIVE MEMBERSHIP LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        activeMembershipPlanModel =
            ActiveMembershipPlanModel.fromJson(value.body);
        activeMembershipList.value =
            activeMembershipPlanModel.data!.memberships!;
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Delete User Account
  Future apiDeleteUserAccount() async {
    debugPrint(
        "DELETE USER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"has_store_access": true};
    debugPrint("DELETE USER BODY**********$data");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userDelete}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("DELETE USER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  clearData() async {
    SharedPreferenceStorage.clearData();
    await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
      builder: (_) => const StartJourneyScreen(),
    ));
    // await Get.offAll(const StartJourneyScreen());
  }
}
