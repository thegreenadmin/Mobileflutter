import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:dio/dio.dart' as mdio;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddNewCategoryController extends GetxController {
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
    print("storeName:------>>>>>>" );
    print(Get.parameters["storeName"] );
    print( Get.parameters["storeId"] );
    storeId.value = Get.parameters["storeId"] ?? "";
    categoryId.value = Get.parameters["categoryId"] ?? "";
    isFeaturedTypeSelected.value =
        Get.parameters["isFeaturedSelectedType"] == "true" ? true : false;
    print(Get.parameters["isFeaturedSelectedType"]);
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

  void validateAndSubmit(BuildContext nCon) async {
    if (validateAndSave()) {
      try {
        if (categoryImageDynamicLinkfromServer.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseUploadCategoryImage);
        } else {
          await apiAddCategory(nCon);
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

  void validateAndSubmitUpdate(BuildContext cntext) async {
    if (validateAndSaveUpdate()) {
      try {
        if (categoryImageDynamicLinkfromServer.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseUploadCategoryImage);
        } else {
          await apiUpdateCategory(cntext);
        }
      } catch (_) {}
    } else {
      updateAutoValidate.value = true;
    }
  }

  Future<void> showSelectionDialog(BuildContext ncontext) {
    return Utility.showSelectionMediaDialog(ncontext, onGalleryClick: () async {
      // Get.back();
      // Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
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
    }, onCameraClick: () async {
      // Get.back();
      // Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
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

  //Add Category Api
  Future apiAddCategory(BuildContext nContext) async {
    debugPrint(
        "ADD CATEGORY URL*>>*********${ServerCommunicator().baseUrl}${ServerCommunicator().createStoreCategory}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("ADD CATEGORY headers********** $headers");
    print("ADD CATEGORY store_id********** ${int.parse(storeId.value)}");
    print("ADD CATEGORY is_featured_category********** ${isFeaturedTypeSelected.value}");
    print("ADD CATEGORY category_name********** ${categoryNameTextController.text.trim()}");
    print("ADD CATEGORY image_url********** ${categoryImageOrigionalLinkfromServer.value}");

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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        categoryNameTextController.clear();
        categoryImageOrigionalLinkfromServer.value = "";
        isFeaturedTypeSelected.value = false;
        categoryImageDynamicLinkfromServer.value = "";
        // Get.back();
        Navigator.of(nContext).pop();
        // Navigator.of(Get.context!).pop();
      } else {
        Utility.showAlertMessage(value.body['message']);
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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        categoryNameTextController.text =
            value.body["data"]['category']['category_name'] ?? "";
        categoryImageDynamicLinkfromServer.value =
            value.body["data"]['category']['image']['dynamic_url'] ?? "";
        categoryImageOrigionalLinkfromServer.value =
            value.body["data"]['category']['image']['orignal_url'] ?? "";
        isFeaturedCategory.value =
            value.body["data"]['category']['is_featured_category'] ?? false;
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

  //Update Category Api
  Future apiUpdateCategory(BuildContext contextt) async {
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
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        // Get.back();
        Navigator.of(contextt).pop();
        categoryNameTextController.clear();
        categoryImageOrigionalLinkfromServer.value = "";
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
}
