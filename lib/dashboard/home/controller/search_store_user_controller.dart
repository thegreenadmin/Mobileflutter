import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'dart:convert';
import 'package:dio/dio.dart' as mdio;
import 'package:http_parser/http_parser.dart';
import '../model/categories_model.dart';

class SearchStoreUserController extends GetxController {
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

  RxBool isScreenLockNotify = false.obs;
  RxBool isInboxMessagesNotify = false.obs;
  RxBool isTippingNotify = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isEnabledStore = false.obs;
  RxBool isLoading = false.obs;
  RxBool is247Time = false.obs;
  RxBool isEnabled = false.obs;

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
  RxInt? addressListIndex = 0.obs;
  RxBool isStoreLogoSelected = false.obs;
  RxInt selectedIndex = 0.obs;

  RxString countryDropdownValue = "".obs;
  RxString? countryId = "".obs;

  RxString stateDropdownValue = "".obs;
  CountriesList? selectedValue;
  RxString stateId = "".obs;

  late GetCountriesModel getCountriesModel = GetCountriesModel();
  RxList<CountriesList> countriesList = <CountriesList>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  RxList<StoreAddresses> address = <StoreAddresses>[].obs;
  RxList<dynamic> storeAddresses = <dynamic>[].obs;

  RxList<dynamic> storeTimings = <dynamic>[].obs;
  RxList<dynamic> storeTimmingList = <dynamic>[].obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  RxString editStoreImageOrigionalLinkfromServer = "".obs;
  RxString editStoreImageDynamicLinkfromServer = "".obs;

  RxString editStoreLogoOrigionalLinkfromServer = "".obs;
  RxString editStoreLogoDynamicLinkfromServer = "".obs;

  Rx<XFile> editStoreImage = XFile("").obs;
  Rx<XFile> editStoreLogo = XFile("").obs;

  RxInt radioGroupValue = 0.obs;

  RxList<Categories> weekDaysList = [
    Categories(id: 1, name: "Monday", isSelected: false),
    Categories(id: 2, name: "Tuesday", isSelected: false),
    Categories(id: 3, name: "Wednesday", isSelected: false),
    Categories(id: 4, name: "Thursday", isSelected: false),
    Categories(id: 5, name: "Friday", isSelected: false),
    Categories(id: 6, name: "Saturday", isSelected: false),
    Categories(id: 7, name: "Sunday", isSelected: false),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 0;
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
      try {} catch (_) {}
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
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
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
      if (res.statusCode == 200 || res.statusCode == 201) {
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
}
