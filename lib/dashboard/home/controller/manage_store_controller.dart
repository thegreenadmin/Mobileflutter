import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:thegreenmall/dashboard/home/model/get_categories_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/quantity_list_response_model.dart'
    as quantity_model;
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class ManageStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  TextEditingController productNameTextController = TextEditingController();
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController pricePerUnitTextController = TextEditingController();
  TextEditingController shortDescriptionTextController = TextEditingController();
  TextEditingController discountOrOfferTextController = TextEditingController();
  TextEditingController additionalLinkTextController = TextEditingController();
  TextEditingController contentsAndStrainsTextController = TextEditingController();
  TextEditingController lengthTextController = TextEditingController();
  TextEditingController breadthTextController = TextEditingController();
  TextEditingController heightTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();
  TextEditingController daysTextController = TextEditingController();

  RxList<Map> selectedCategories = <Map>[].obs;
  RxBool autoValidate = false.obs;
  RxBool isFeaturedSelectedType = false.obs;
  RxBool updateAutoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isNotify = false.obs;
  RxBool isFeaturedTypeSelected = false.obs;
  RxBool isFeatured = false.obs;
  RxBool isEnabled = false.obs;
  RxBool isProductReturnable = false.obs;
  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString storeLocation = "".obs;
  RxString categoryName = "".obs;
  RxString categoryId = "".obs;
  RxString discountType = "".obs;
  RxString productId = "".obs;
  RxString categoryDropdownValue = "Andaman and Nicobar Islands".obs;
  RxString selectedFeaturedType = "No".obs;
  RxString selectedProductReturnableType = "No".obs;
  RxString discountValueType = "percentage".obs;
  RxString lastProductContent = "".obs;
  RxString lastProductLink = "".obs;
  RxString quantityValue = "".obs;
  Map data = {};

  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  RxList<Categories> categoriesList = <Categories>[].obs;
  late quantity_model.QuantityListResponse quantityListResponse = quantity_model.QuantityListResponse();
  RxList<quantity_model.QuantityType> quantityTypeList = <quantity_model.QuantityType>[].obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  RxList<dynamic> productContent = <dynamic>[].obs;
  RxList<dynamic> productLinks = <dynamic>[].obs;

  final ImagePicker imagePicker = ImagePicker();
  RxList<XFile>? imageFileList = <XFile>[].obs;

  selectImages() async {
    imageFileList!.clear();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      apiUploadMultipleImage();
    }
  }

  @override
  void onInit() {
    super.onInit();
    isFeaturedTypeSelected.value = false;
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    storeLocation.value = Get.arguments["storeLocation"] ?? "";
    apiGetCategoriesList();
    apiGetQuantityList();
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

  bool validateAndSaveUpdateProduct() {
    final forms = updateformKey.currentState;
    if (forms!.validate()) {
      forms.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmitUpdateProduct() async {
    if (validateAndSaveUpdateProduct()) {
      try {
        if (selectedCategories.isEmpty) {
          Utility.showToast("Please select categories");
        } else {
          apiUpdateStoreProductDetail();
        }
      } catch (_) {}
    } else {
      updateAutoValidate.value = true;
    }
  }

  //Api upload image to server
  Future<Future<bool?>?> apiUploadMultipleImage() async {
    // create multipart request
    var request = http.MultipartRequest(
        'POST', Uri.parse(ServerCommunicator().baseUrl + ServerCommunicator().fileUploadMultiple));
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    if (imageFileList!.length > 0) {
      for (var i = 0; i < imageFileList!.length; i++) {
        request.files.add(http.MultipartFile(
            'files', File(imageFileList![i].path).readAsBytes().asStream(), File(imageFileList![i].path).lengthSync(),
            filename: basename(imageFileList![i].path.split("/").last)));
        request.headers.addAll(headers);
      }
      // send
      var response = await request.send();
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        debugPrint(value);
        List imagesList = [];
        for (int i = 0; i < jsonDecode(value)['data']['files'].length; i++) {
          var imageData = jsonDecode(value)['data']['files'][i];
          imagesList.add({"image_url": imageData['orignal_url'], "order": "${i + 1}"});
        }
        data['product_images'] = imagesList;
      });
    } else {
      Utility.showToast("Please Select atleast one image");
    }
  }

  //Get Categories Api
  Future apiGetCategoriesList() async {
    categoriesList.clear();
    isLoading.value = true;
    debugPrint(
        "GET CATEGORIES URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}&is_featured_category=${isFeaturedTypeSelected.value}"}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}&is_featured_category=${isFeaturedTypeSelected.value}",
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

  //Get Quantity List Api
  Future apiGetQuantityList() async {
    quantityTypeList.clear();
    isLoading.value = true;
    debugPrint(
        "GET QuantityList URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeQuantityTypeList}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi("${ServerCommunicator().baseUrl}${ServerCommunicator().storeQuantityTypeList}", headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET Quantity LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        quantityListResponse = quantity_model.QuantityListResponse.fromJson(value?.body);
        quantityTypeList.value = quantityListResponse.data?.quantityTypes ?? [];
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Products List Api
  Future apiGetProductList() async {
    categoriesList.clear();
    isLoading.value = true;
    debugPrint("GET PRODUCT LIST URL **********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}", headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
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
    data['store_id'] = storeId.value;
    data['product'] = {
      "quantity_type_id": int.parse(quantityValue.value),
      "quantity": quantityTextController.text.trim(),
      "is_featured_product": isFeatured.value,
      "product_name": productNameTextController.text.trim(),
      "description": shortDescriptionTextController.text.trim(),
      "product_price": pricePerUnitTextController.text.trim(),
      "selling_price": pricePerUnitTextController.text.trim(),
      "discount_type": discountType.value.toLowerCase(),
      "discount_value": discountOrOfferTextController.text.trim(),
      "is_product_returnable": isProductReturnable.value,
      "return_days_count": int.parse(daysTextController.text.trim()),
      "length": lengthTextController.text.trim(),
      "width": breadthTextController.text.trim(),
      "height": heightTextController.text.trim(),
      "weight": weightTextController.text.trim(),
      "is_enabled": isEnabled.value
    };
    data['product_categories'] = selectedCategories;
    data['product_links'] = [
      {"name": "Product link 1", "link": additionalLinkTextController.text.trim(), "order": 1},
    ];
    data['product_contents'] = [
      {"heading": "Demo heading 1", "paragraph": contentsAndStrainsTextController.text.trim(), "order": 1},
    ];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE STORE BODY********** $data");
    debugPrint("CREATE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createProduct}");
    UserProvider()
        .postWithHeadersApi(data, ServerCommunicator().baseUrl + ServerCommunicator().createProduct, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        Utility.showToast(value?.body['message']);
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
        daysTextController.clear();
        weightTextController.clear();
        isEnabled.value = false;
        discountType.value = "";
        isFeatured.value = false;
        selectedCategories.value = [];
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

//Get store products List Api
  Future apiGetStoreProducts() async {
    isLoading.value = true;
    debugPrint(
      "GET STORE PRODUCTS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 10,
      "order_by": "product_id",
      "order_type": "ASC",
      "category_id": categoryId.value,
      "filters": [
        // {
        //   "filter_by": "is_featured_product",
        //   "filter_value": false,
        //   "operation": "eq"
        // }
      ]
    };
    UserProvider()
        .postWithHeadersApi(body, "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}", headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE PRODUCTS LIST BODY *******$body");
      debugPrint("GET STORE PRODUCTS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getStoreProductList = GetStoreProductList.fromJson(value.body);
        storeProductList.value = getStoreProductList.data!.products!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Api to get details of one product
  Future apiGetProductDetails() async {
    isLoading.value = true;
    debugPrint(
      "GET PRODUCTS DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDetail}?store_id=${storeId.value}&product_id=${productId.value}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDetail}?store_id=${storeId.value}&product_id=${productId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET PRODUCTS DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        productNameTextController.text = value.body["data"]['product']["product_name"] ?? "";
        discountType.value = value.body["data"]['product']["discount_type"] ?? "";
        if (discountType.value == "amount") {
          discountValueType.value = "Amount";
        } else {
          discountValueType.value = "Percentage";
        }
        discountOrOfferTextController.text = value.body["data"]['product']["discount_value"].toString();
        quantityValue.value = value.body["data"]['product']["quantity_type_id"].toString();
        quantityTextController.text = value.body["data"]['product']["quantity"].toString();

        pricePerUnitTextController.text = value.body["data"]['product']["product_price"].toString();
        shortDescriptionTextController.text = value.body["data"]['product']["description"] ?? "";
        isFeatured.value = value.body["data"]['product']["is_featured_product"];
        if (isFeatured.value) {
          selectedFeaturedType.value = "Yes";
        } else {
          selectedFeaturedType.value = "No";
        }
        daysTextController.text = value.body["data"]['product']["return_days_count"].toString();
        isProductReturnable.value = value.body["data"]['product']["is_product_returnable"];
        if (isProductReturnable.value) {
          selectedProductReturnableType.value = "Yes";
        } else {
          selectedProductReturnableType.value = "No";
        }

        lengthTextController.text = value.body["data"]['product']["length"].toString();
        breadthTextController.text = value.body["data"]['product']["width"].toString();
        heightTextController.text = value.body["data"]['product']["height"].toString();
        weightTextController.text = value.body["data"]['product']["weight"].toString();
        productContent.value = value.body["data"]['product']["product_contents"] ?? [];
        productLinks.value = value.body["data"]['product']["product_links"] ?? [];
        if (productContent.isNotEmpty) {
          for (int i = 0; i < productContent.length; i++) {
            contentsAndStrainsTextController.text = productContent[i]['paragraph'];
            lastProductContent.value = productContent[i]['paragraph'];
          }
        }
        if (productLinks.isNotEmpty) {
          for (int i = 0; i < productLinks.length; i++) {
            additionalLinkTextController.text = productLinks[i]['link'];
            lastProductLink.value = productLinks[i]['link'];
          }
        }
        isEnabled.value = value.body["data"]['product']["is_enabled"] ?? false;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Update  Store Product Api
  Future apiUpdateStoreProductDetail() async {
    debugPrint(
        "UPDATE STORE PRODUCT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductEdit}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "store_id": storeId.value,
      "product": {
        "product_id": productId.value,
        "quantity_type_id": int.parse(quantityValue.value),
        "quantity": quantityTextController.text.trim(),
        "is_featured_product": isFeatured.value,
        "product_name": productNameTextController.text.trim(),
        "description": shortDescriptionTextController.text.trim(),
        "product_price": double.parse(pricePerUnitTextController.text.trim()),
        "selling_price": double.parse(pricePerUnitTextController.text.trim()),
        "discount_type": discountValueType.value.toLowerCase(),
        "discount_value": discountOrOfferTextController.text.trim(),
        "is_product_returnable": isProductReturnable.value,
        "return_days_count": int.parse(daysTextController.text.trim()),
        "length": lengthTextController.text.trim(),
        "width": breadthTextController.text.trim(),
        "height": heightTextController.text.trim(),
        "weight": weightTextController.text.trim(),
        "is_enabled": isEnabled.value
      },
      // "product_categories": [
      //   {
      //     "product_category_id": "1",
      //     "status": "active",
      //     "category": {"category_id": "3"}
      //   }
      // ],
      "product_images": [
        // {
        //   "product_image_id": "1",
        //   "image_url":
        //       "https://sdd-citizen-app-bucket.s3.ap-south-1.amazonaws.com/100377077211-Screenshot-1.png",
        //   "order": 1,
        //   "status": "active"
        // },
        // {
        //   "product_image_id": "2",
        //   "image_url":
        //       "https://sdd-citizen-app-bucket.s3.ap-south-1.amazonaws.com/100377077211-Screenshot-1.png",
        //   "order": 2,
        //   "status": "deleted"
        // }
      ],
      "product_contents": [
        {
          "product_content_id": lastProductContent.value != contentsAndStrainsTextController.text ? null : "1",
          "heading": "Heading",
          "paragraph": lastProductContent.value != contentsAndStrainsTextController.text
              ? contentsAndStrainsTextController.text
              : lastProductContent.value,
          "order": 1,
          "status": lastProductContent.value != additionalLinkTextController.text ? "active" : "deleted"
        },
      ],
      "product_links": [
        {
          "product_link_id": lastProductLink.value != additionalLinkTextController.text ? null : "1",
          "name": "Product link",
          "link": lastProductLink.value != additionalLinkTextController.text
              ? additionalLinkTextController.text
              : lastProductLink.value,
          "order": 1,
          "status": lastProductLink.value != additionalLinkTextController.text ? "active" : "deleted"
        },
      ]
    };
    debugPrint("UPDATE STORE PRODUCT BODY********************$data");
    UserProvider()
        .putWithHeadersApi(data, "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductEdit}", headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE STORE PRODUCT RESPONSE *******${value!.body}");
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
        daysTextController.clear();
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

//Api Delete Product
  Future apiDeleteProduct() async {
    debugPrint("DELETE PRODUCT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"store_id": storeId.value, "product_id": productId.value};
    debugPrint("DELETE PRODUCT BODY ************* $data");
    UserProvider()
        .deleteWithHeadersApi(
            data, "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDelete}", headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE PRODUCT RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        await apiGetProductList();
      } else if (value.body["status"] == 409) {
        Utility.showToast(value.body['message']);
        await apiGetProductList();
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Api Delete Category
  Future apiDeleteCategory() async {
    debugPrint(
        "DELETE CATEGORY URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"store_id": storeId.value, "category_id": categoryId.value};
    debugPrint("DELETE CATEGORY BODY ************* $data");
    UserProvider()
        .deleteWithHeadersApi(
            data, "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDelete}", headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        await apiGetCategoriesList();
      } else if (value.body["status"] == 409) {
        Utility.showToast(value.body['message']);
        await apiGetCategoriesList();
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
