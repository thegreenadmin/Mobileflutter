import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:dio/dio.dart' as mdio;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddCategoryController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  TextEditingController categoryNameTextController = TextEditingController();
  Rx<XFile> categoryImage = XFile("").obs;
  RxString categoryImageOrigionalLinkfromServer = "".obs;
  RxString categoryImageDynamicLinkfromServer = "".obs;
  RxString storeId = "".obs;
  RxString categoryId = "".obs;
  RxBool autoValidate = false.obs;
  RxBool isFeaturedCategory = false.obs;
  RxBool updateAutoValidate = false.obs;
  String? imageData;
  bool dataLoaded = false;
  RxBool isFeaturedTypeSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"] ?? "";
    categoryId.value = Get.arguments["categoryId"] ?? "";
    isFeaturedTypeSelected.value =
        Get.arguments["isFeaturedSelectedType"] ?? false;
    if (categoryId.value.isNotEmpty) {
      apiGetCategoryDetail();
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
        if (categoryImageDynamicLinkfromServer.isEmpty) {
          Utility.showToast("Please upload catagory Image");
        } else {
          await apiAddCategory();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  bool validateAndSaveUpdate() {
    final forms = updateformKey.currentState;
    if (forms!.validate()) {
      forms.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmitUpdate() async {
    if (validateAndSaveUpdate()) {
      try {
        if (categoryImageDynamicLinkfromServer.isEmpty) {
          Utility.showToast("Please upload catagory Image");
        } else {
          await apiUpdateCategory();
        }
      } catch (_) {}
    } else {
      updateAutoValidate.value = true;
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
                          categoryImage.value = pickedFile;
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
                          categoryImage.value = pickedFile;
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
          mdio.MultipartFile.fromBytes(await categoryImage.value.readAsBytes(),
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
        categoryImageOrigionalLinkfromServer.value =
            responseData['data']['urls']['orignal_url'];
        categoryImageDynamicLinkfromServer.value =
            responseData['data']['urls']['dynamic_url'];

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

  //Add Category Api
  Future apiAddCategory() async {
    debugPrint(
        "ADD CATEGORY URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createStoreCategory}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {
      "store_id": int.parse(storeId.value),
      "parent_category_id": null,
      "is_featured_category": isFeaturedTypeSelected.value,
      "category_name": categoryNameTextController.text.trim(),
      "image_url": categoryImageOrigionalLinkfromServer.value
    };
    debugPrint("ADD CATEGORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createStoreCategory,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Get.back();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Category Detail Api
  Future apiGetCategoryDetail() async {
    debugPrint(
        "GET CATEGORY DETAIL URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().storeCategoryDeatil}?store_id=${storeId.value}&category_id=${categoryId.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDeatil}?store_id=${storeId.value}&category_id=${categoryId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET CATEGORY DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        categoryNameTextController.text =
            value.body["data"]['category']['category_name'] ?? "";
        categoryImageDynamicLinkfromServer.value =
            value.body["data"]['category']['image']['dynamic_url'] ?? "";
        categoryImageOrigionalLinkfromServer.value =
            value.body["data"]['category']['image']['orignal_url'] ?? "";
        isFeaturedCategory.value =
            value.body["data"]['category']['is_featured_category'] ?? false;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Update Category Api
  Future apiUpdateCategory() async {
    debugPrint(
        "UPDATE CATEGORY  URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryEdit}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "store_id": int.parse(storeId.value),
      "category_id": int.parse(categoryId.value),
      "is_featured_category": isFeaturedCategory.value,
      "parent_category_id": null,
      "category_name": categoryNameTextController.text.trim(),
      "image_url": categoryImageOrigionalLinkfromServer.value
    };
    debugPrint("UPDATE CATEGORY BODY**********$data");
    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryEdit}",
            headers,
            showLoading: true)
        .then((value) async {
      print(value);
      debugPrint("UPDATE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Get.back();
        categoryNameTextController.clear();
        categoryImageOrigionalLinkfromServer.value = "";
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
