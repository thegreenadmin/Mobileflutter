import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../view/store_owner/add_new_product_screen.dart';
import 'manage_store_controller.dart';

class AddNewCategoryController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController categoryNameTextController = TextEditingController();
  Rx<XFile> categoryImage = XFile("").obs;
  RxString categoryImageOriginalLinkFromServer = "".obs;
  RxString categoryImageDynamicLinkFromServer = "".obs;
  RxString storeId = "".obs;
  RxString categoryId = "".obs;
  RxBool autoValidate = false.obs;
  RxBool isFeaturedCategory = false.obs;
  RxBool updateAutoValidate = false.obs;
  String? imageData;
  bool dataLoaded = false;
  RxBool isFeaturedTypeSelected = false.obs;
  RxInt pageId = 0.obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;

  @override
  void onInit() {
    super.onInit();
    getPage();
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;

    storeId.value = Get.parameters["storeId"] ?? "";
    categoryId.value = Get.parameters["categoryId"] ?? "";
    isFeaturedTypeSelected.value =
        Get.parameters["isFeaturedSelectedType"] == "true" ? true : false;

    if (categoryId.value.isNotEmpty) {
      await apiGetCategoryDetail();
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
        if (categoryImageDynamicLinkFromServer.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseUploadCategoryImage);
        } else {
          await apiAddCategory();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  bool validateAndSaveUpdate() {
    final forms = updateFormKey.currentState;
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
        if (categoryImageDynamicLinkFromServer.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseUploadCategoryImage);
        } else {
          await apiUpdateCategory();
        }
      } catch (_) {}
    } else {
      updateAutoValidate.value = true;
    }
  }

  Future<void> showSelectionDialog(BuildContext ncontext) {
    return Utility.showSelectionMediaDialog(ncontext, onGalleryClick: () async {
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        categoryImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {}
    }, onCameraClick: () async {
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        categoryImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {}
    });
  }

  ///Api upload image to server
  Future apiUploadImage() async {
    try {
      final dio = mdio.Dio();
      mdio.FormData formData = mdio.FormData.fromMap({});

      Map<String, String> headers = {
        'Authorization': "Bearer ${authToken.value.toString()}",
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
        categoryImageOriginalLinkFromServer.value =
            responseData['data']['urls']['orignal_url'];
        categoryImageDynamicLinkFromServer.value =
            responseData['data']['urls']['dynamic_url'];

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

  ///Add Category Api
  Future apiAddCategory() async {
    debugPrint(
        "ADD CATEGORY URL*>>*********${ServerCommunicator().baseUrl}${ServerCommunicator().createStoreCategory}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("ADD CATEGORY headers********** $headers");
    debugPrint("ADD CATEGORY store_id********** ${int.parse(storeId.value)}");
    debugPrint(
        "ADD CATEGORY is_featured_category********** ${isFeaturedTypeSelected.value}");
    debugPrint(
        "ADD CATEGORY category_name********** ${categoryNameTextController.text.trim()}");
    debugPrint(
        "ADD CATEGORY image_url********** ${categoryImageOriginalLinkFromServer.value}");

    Map body = {
      "store_id": int.parse(storeId.value),
      "parent_category_id": null,
      "is_featured_category": isFeaturedTypeSelected.value,
      "category_name": categoryNameTextController.text.trim(),
      "image_url": categoryImageOriginalLinkFromServer.value
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
      log("GET CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        Get.parameters["categoryName"] = categoryNameTextController.text;
        Get.parameters["categoryId"] = value.body['data']['category_id'];
        categoryNameTextController.clear();
        categoryImageOriginalLinkFromServer.value = "";
        isFeaturedTypeSelected.value = false;
        categoryImageDynamicLinkFromServer.value = "";
        Get.find<ManageStoreController>().onInit();
        Get.to(() => const AddNewProductScreen(), id: pageIdApp.value);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Category Detail Api
  Future apiGetCategoryDetail() async {
    debugPrint(
        "GET CATEGORY DETAIL URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().storeCategoryDetail}?store_id=${storeId.value}&category_id=${categoryId.value}"}");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDetail}?store_id=${storeId.value}&category_id=${categoryId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET CATEGORY DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        categoryNameTextController.text =
            value.body["data"]['category']['category_name'] ?? "";
        categoryImageDynamicLinkFromServer.value =
            value.body["data"]['category']['image']['dynamic_url'] ?? "";
        categoryImageOriginalLinkFromServer.value =
            value.body["data"]['category']['image']['orignal_url'] ?? "";
        isFeaturedCategory.value =
            value.body["data"]['category']['is_featured_category'] ?? false;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Update Category Api
  Future apiUpdateCategory() async {
    debugPrint(
        "UPDATE CATEGORY  URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryEdit}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    Map data = {
      "store_id": int.parse(storeId.value),
      "category_id": int.parse(categoryId.value),
      "is_featured_category": isFeaturedCategory.value,
      "parent_category_id": null,
      "category_name": categoryNameTextController.text.trim(),
      "image_url": categoryImageOriginalLinkFromServer.value
    };
    debugPrint("UPDATE CATEGORY BODY**********$data");
    UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryEdit}",
            headers,
            showLoading: true)
        .then((value) async {
      (value);
      debugPrint("UPDATE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);

        Get.back(id: pageIdApp.value);

        categoryNameTextController.clear();
        categoryImageOriginalLinkFromServer.value = "";
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
