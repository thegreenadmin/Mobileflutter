import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_categories_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class ManageStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController productNameTextController = TextEditingController();
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController pricePerUnitTextController = TextEditingController();
  TextEditingController shortDescriptionTextController =
      TextEditingController();
  TextEditingController discountOrOfferTextController = TextEditingController();
  TextEditingController additionalLinkTextController = TextEditingController();
  TextEditingController contentsAndStrainsTextController =
      TextEditingController();
  TextEditingController lengthTextController = TextEditingController();
  TextEditingController breadthTextController = TextEditingController();
  TextEditingController heightTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();

  RxList<Map> selectedCategories = <Map>[].obs;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isNotify = false.obs;
  RxBool isMenuSelected = false.obs;
  RxBool isFeatured = false.obs;
  RxBool isEnabled = false.obs;
  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString storeLocation = "".obs;
  RxString categoryName = "".obs;
  RxString discountType = "".obs;
  RxString categoryDropdownValue = "Andaman and Nicobar Islands".obs;
  RxString categoryId = "".obs;

  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  RxList<Categories> categoriesList = <Categories>[].obs;

  final ImagePicker imagePicker = ImagePicker();
  RxList<XFile>? imageFileList = <XFile>[].obs;

  selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
  }

  @override
  void onInit() {
    super.onInit();
    isMenuSelected.value = true;
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    storeLocation.value = Get.arguments["storeLocation"] ?? "";
    apiGetCategoriesList();
    apiGetStoreCategories();
  }

  RxList<Map<String, dynamic>> weekDaysList = <Map<String, dynamic>>[
    {"isSelected": false, "day": "Monday"},
    {"isSelected": false, "day": "Tuesday"},
    {"isSelected": false, "day": "Wednesday"},
    {"isSelected": false, "day": "Thursday"},
    {"isSelected": false, "day": "Friday"},
    {"isSelected": false, "day": "Saturday"},
    {"isSelected": false, "day": "Sunday"},
  ].obs;

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
        if (selectedCategories.isEmpty) {
          Utility.showToast("Please select categories");
        } else {
          apiCreateProduct();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Get Categories Api
  Future apiGetCategoriesList() async {
    categoriesList.clear();
    isLoading.value = true;
    debugPrint(
        "GET CATEGORIES URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CATEGORIES LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getCategoriesModel = GetCategoriesModel.fromJson(value.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Products List Api
  Future apiGetProductList() async {
    categoriesList.clear();
    isLoading.value == true;
    debugPrint(
        "GET PRODUCT LIST URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value == false;
      debugPrint("GET PRODUCT LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getCategoriesModel = GetCategoriesModel.fromJson(value.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Create Product Api
  Future apiCreateProduct() async {
    Map data = {
      "store_id": storeId.value,
      "product": {
        "quantity_type_id": 1,
        "quantity": quantityTextController.text.trim(),
        "is_featured_product": isFeatured.value,
        "product_name": productNameTextController.text.trim(),
        "description": shortDescriptionTextController.text.trim(),
        "product_price": pricePerUnitTextController.text.trim(),
        "selling_price": pricePerUnitTextController.text.trim(),
        "discount_type": discountType.value.toLowerCase(),
        "discount_value": discountOrOfferTextController.text.trim(),
        "is_product_returnable": false,
        "return_days_count": 0,
        "length": lengthTextController.text.trim(),
        "width": breadthTextController.text.trim(),
        "height": heightTextController.text.trim(),
        "weight": weightTextController.text.trim(),
        "is_enabled": isEnabled.value
      },
      "product_categories": selectedCategories,
      "product_images": [
        {
          "image_url":
              "https://sdd-citizen-app-bucket.s3.ap-south-1.amazonaws.com/100377077211-Screenshot-1.png",
          "order": 1
        },
        {
          "image_url":
              "https://sdd-citizen-app-bucket.s3.ap-south-1.amazonaws.com/100377077211-Screenshot-1.png",
          "order": 2
        }
      ],
      "product_contents": [
        {
          "heading": "Demo heading 1",
          "paragraph": contentsAndStrainsTextController.text.trim(),
          "order": 1
        },
      ],
      "product_links": [
        {
          "name": "Product link 1",
          "link": additionalLinkTextController.text.trim(),
          "order": 1
        },
      ]
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE STORE BODY********** $data");
    debugPrint(
        "CREATE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createProduct}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().createProduct,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.back();
        });
        productNameTextController.clear();
        quantityTextController.clear();
        pricePerUnitTextController.clear();
        shortDescriptionTextController.clear();
        discountOrOfferTextController.clear();
        additionalLinkTextController.clear();
        contentsAndStrainsTextController.clear();
        lengthTextController.clear();
        breadthTextController.clear();
        heightTextController.clear();
        weightTextController.clear();
        isEnabled.value = false;
        discountType.value = "";
        isFeatured.value = false;
        selectedCategories.value = [];
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  Future apiGetStoreCategories() async {
    isLoading.value == true;
    debugPrint(
        "GET STORE PRODUCTS LIST URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().storeProductList}}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {
      "": "",
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value == false;
      debugPrint("GET STORE PRODUCTS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
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
