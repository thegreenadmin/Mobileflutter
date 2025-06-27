import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/model/quantity_list_response_model.dart'
    as quantity_model;
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class ManageStoreController extends GetxController with GlobalVarMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

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
  TextEditingController daysTextController = TextEditingController();
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  RxList selectedCategories = [].obs;
  RxBool autoValidate = false.obs;
  RxBool isFeaturedSelectedType = false.obs;
  RxBool updateAutoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isNotify = false.obs;
  RxBool isFeaturedTypeSelected = false.obs;
  RxBool isFeatured = false.obs;
  RxBool isEnabled = true.obs;
  RxBool isProductReturnable = false.obs;
  RxBool isSelectedCategory = false.obs;
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
  RxString discountValueType = "".obs;
  RxString lastProductContent = "".obs;
  RxString lastProductLink = "".obs;
  RxString quantityValue = "".obs;

  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;

  RxInt pageId = 0.obs;
  InputAddProduct inputData = InputAddProduct();
  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  RxList<StoreCategories> categoriesList = <StoreCategories>[].obs;
  late quantity_model.QuantityListResponse quantityListResponse =
      quantity_model.QuantityListResponse();
  RxList<QuantityType> quantityTypeList = <QuantityType>[].obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  RxList<dynamic> productContent = <dynamic>[].obs;
  RxList<dynamic> productLinks = <dynamic>[].obs;
  List<ProductImagesList> imagesList = <ProductImagesList>[];
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> selectedImages = <XFile>[];
  RxList<XFile>? imageFileList = <XFile>[].obs;
  RxList<ProductImagesList> imageUrlList = <ProductImagesList>[].obs;

  selectImages(clearImages) async {
    if (clearImages) imageFileList!.clear();
    selectedImages.clear();
    selectedImages = await imagePicker.pickMultiImage(
      imageQuality: 85,
      maxHeight: 200,
      maxWidth: 200,
    );
    int selectedCount = 0;
    for (int i = 0; i < imageUrlList.length; i++) {
      if (imageUrlList[i].status == "active") {
        selectedCount = selectedCount + 1;
      }
    }
    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        selectedCount = selectedCount + 1;
      }
    }
         if (selectedCount > 5) {
      return Utility.showAlertMessage(
          AlertStringConstants.only5MaximumImagesCanSelectText);
    } else {
      imageFileList!.addAll(selectedImages);
      apiUploadMultipleImage(imageUrlList.length);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPage();
  }

  getPage() async {
    role?.value = roleApp.value;
    isFeaturedTypeSelected.value = false;
    if (Get.parameters["storeId"] != "") {
      storeId.value = Get.parameters["storeId"] ?? "";
    }
    if (Get.parameters["storeName"] != "") {
      storeName.value = Get.parameters["storeName"] ?? "";
    }
    if (Get.parameters["storeLocation"] != "") {
      storeLocation.value = Get.parameters["storeLocation"] ?? "";
    }
    if (Get.parameters["categoryName"] != "") {
      categoryName.value = Get.parameters["categoryName"] ?? "";
    }
    if (Get.parameters["categoryId"] != "") {
      categoryId.value = Get.parameters["categoryId"] ?? "";
    }

    await apiGetCategoriesList();
    apiGetQuantityList();
    if (Get.parameters["productId"] != "" && Get.parameters["storeId"] != "") {
      storeId.value = Get.parameters["storeId"] ?? "";
      productId.value = Get.parameters["productId"] ?? "";
      apiGetStoreProducts();
      apiGetProductDetails();
    }
  }

  RxList<Map<String, dynamic>> weekDaysList = <Map<String, dynamic>>[
    {"isSelected": false, "day": StringConstants.mondayText},
    {"isSelected": false, "day": StringConstants.tuesdayText},
    {"isSelected": false, "day": StringConstants.wednesdayText},
    {"isSelected": false, "day": StringConstants.thursdayText},
    {"isSelected": false, "day": StringConstants.fridayText},
    {"isSelected": false, "day": StringConstants.saturdayText},
    {"isSelected": false, "day": StringConstants.sundayText},
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
        if (categoryId.value == "") {
          isLoading.value = false;
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectCategoriesText);
        } else {
          isLoading.value = true;
          apiCreateProduct();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
      isLoading.value = false;
    }
  }

  void resetForm() {
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
    imageUrlList.clear();
    isEnabled.value = true;
    isProductReturnable.value = false;
    discountType.value = "";
    isFeatured.value = false;
    selectedCategories.value = [];
  }

  bool validateAndSaveUpdateProduct() {
    final forms = updateFormKey.currentState;
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
        for (int i = 0; i < categoriesList.length; i++) {
          bool isHaving = false;
          for (int j = 0; j < selectedCategories.length; j++) {
            if (selectedCategories[j]["category"]["category_id"] ==
                categoriesList[i].categoryId) {
              isHaving = true;
              selectedCategories[j]['status'] =
                  categoriesList[i].isSelected == true ? "active" : "deleted";
            }
          }
          if (!isHaving && categoriesList[i].isSelected == true) {
            selectedCategories.add({
              "category": {"category_id": categoriesList[i].categoryId},
              'status': "active"
            });
          }
        }
        var data = selectedCategories
            .where((element) => element["status"] == 'active');
        if (data.isEmpty) {
          isLoading.value = false;
          Utility.showAlertMessage("Please select categories");
        } else {
          isLoading.value = true;
          apiUpdateStoreProductDetail();
        }
      } catch (_) {}
    } else {
      isLoading.value = false;
      updateAutoValidate.value = true;
    }
  }

  /// Api upload image to server
  Future<Future<bool?>?> apiUploadMultipleImage(length) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(ServerCommunicator.baseUrl +
            ServerCommunicator.fileUploadMultiple));

    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    for (var i = 0; i < imageFileList!.length; i++) {
      request.files.add(http.MultipartFile(
          'files',
          File(imageFileList![i].path).readAsBytes().asStream(),
          File(imageFileList![i].path).lengthSync(),
          filename: basename(imageFileList![i].path.split("/").last)));
      request.headers.addAll(headers);
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
             imagesList.clear();
      for (int i = 0; i < jsonDecode(value)['data']['files'].length; i++) {
        var imageData = jsonDecode(value)['data']['files'][i];
        imagesList.add(ProductImagesList(
            imageUrl: imageData['orignal_url'],
            order: length + 1 + i,
            status: 'active',
            dynamicImageUrl: imageData['dynamic_url']));
      }
      imageUrlList.addAll(imagesList);
      inputData.productImages = imageUrlList.isEmpty ? [] : imageUrlList;
      imageUrlList.refresh();
    });

    return null;
  }

  /// Get Categories Api
  Future apiGetCategoriesList() async {
    categoriesList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.categoryList}?store_id=${storeId.value}&is_featured_category=${isFeaturedTypeSelected.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        getCategoriesModel = GetCategoriesModel.fromJson(value?.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
        for (int i = 0; i < categoriesList.length; i++) {
          for (int j = 0; j < selectedCategories.length; j++) {
            if (categoriesList[i].categoryId.toString() ==
                selectedCategories[j]['category']['category_id'].toString()) {
              categoriesList[i].isSelected = true;
            }
          }
          if (categoriesList[i].categoryId.toString() == categoryId.value) {
            categoriesList[i].isSelected = true;
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Get Quantity List Api
  Future apiGetQuantityList() async {
    quantityTypeList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeQuantityTypeList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        quantityListResponse =
            quantity_model.QuantityListResponse.fromJson(value?.body);
        quantityTypeList.value = quantityListResponse.data?.quantityTypes ?? [];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Create Product Api
  Future apiCreateProduct() async {
    isLoading.value = true;
    inputData.storeId = int.parse(storeId.value);
    InputProduct product = InputProduct();
    product.quantityTypeId = int.parse(quantityValue.value);
    product.quantity = double.parse(quantityTextController.text.trim());
    product.isFeaturedProduct = isFeatured.value;
    product.productName = productNameTextController.text.trim();
    product.description = shortDescriptionTextController.text.trim();
    product.productPrice = double.parse(pricePerUnitTextController.text.trim());
    product.sellingPrice = double.parse(pricePerUnitTextController.text.trim());
    product.discountType = discountType.value.isEmpty
        ? "amount"
        : discountType.value.toLowerCase();
    product.discountValue = double.parse(
        discountOrOfferTextController.text.trim().isEmpty
            ? "0"
            : discountOrOfferTextController.text.trim());
    product.isProductReturnable = isProductReturnable.value;
    product.returnDaysCount = daysTextController.text.trim().isEmpty
        ? 0
        : int.parse(daysTextController.text.trim());
    product.length = double.parse(lengthTextController.text.trim().isEmpty
        ? "0.0"
        : lengthTextController.text.trim());
    product.width = double.parse(breadthTextController.text.trim().isEmpty
        ? "0.0"
        : breadthTextController.text.trim());
    product.height = double.parse(heightTextController.text.trim().isEmpty
        ? "0.0"
        : heightTextController.text.trim());
    product.weight = double.parse(weightTextController.text.trim());
    product.isEnabled = isEnabled.value;
    inputData.product = product;
    List<ProductCategories> listProductCategory = <ProductCategories>[];
    listProductCategory.add(ProductCategories(categoryId: categoryId.value));
    inputData.productCategories = listProductCategory;
    inputData.productLinks = <ProductLink>[
      ProductLink(
          name: "Product link 1",
          link: additionalLinkTextController.text.trim(),
          order: 1)
    ];
    inputData.productContents = <ProductContent>[
      ProductContent(
          heading: "Demo heading 1",
          paragraph: contentsAndStrainsTextController.text.trim(),
          order: 1)
    ];
    inputData.productImages ??= [];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            inputData,
            ServerCommunicator.baseUrl + ServerCommunicator.createProduct,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        Get.back(id: pageIdApp.value);
        Get.back(id: pageIdApp.value);
        await apiGetCategoriesList();
        resetForm();
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Get store products List Api
  Future apiGetStoreProducts() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 1000,
      "order_by": "product_id",
      "order_type": "ASC",
      "category_id": categoryId.value,
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeProductList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
                    if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getStoreProductList = GetStoreProductList.fromJson(value?.body);
        storeProductList.value = getStoreProductList.data!.products!;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Api to get details of one product
  Future apiGetProductDetails() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeProductDetail}?store_id=${storeId.value}&product_id=${productId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        productNameTextController.text =
            value?.body["data"]['product']["product_name"] ?? "";
        discountType.value =
            value?.body["data"]['product']["discount_type"] ?? "";
        if (discountType.value == "amount") {
          discountValueType.value = "Amount";
        } else {
          discountValueType.value = "Percentage";
        }
        imageUrlList.clear();
        for (int i = 0;
            i < value?.body["data"]['product']['product_images'].length;
            i++) {
          var image = value?.body["data"]['product']['product_images'][i];
          imageUrlList.add(ProductImagesList(
              productImageId: image['product_image_id'],
              imageUrl: image["image"]["orignal_url"],
              dynamicImageUrl: image["image"]["dynamic_url"],
              order: image["order"],
              status: image["status"]));
        }
        List<ProductImagesList> imagesList2 = [];
        for (var img in imageUrlList) {
          if (img.status != 'deleted') {
            imagesList2.add(img);
          }
        }
        inputData.productImages = imageUrlList;
        discountOrOfferTextController.text =
            value?.body["data"]['product']["discount_value"].toString()??"";
        quantityValue.value =
            value?.body["data"]['product']["quantity_type_id"].toString()??"";
        quantityTextController.text =
            value?.body["data"]['product']["quantity"].toString()??"";

        pricePerUnitTextController.text =
            value?.body["data"]['product']["product_price"].toString()??"";
        shortDescriptionTextController.text =
            value?.body["data"]['product']["description"] ?? "";
        isFeatured.value = value?.body["data"]['product']["is_featured_product"];
        if (isFeatured.value) {
          selectedFeaturedType.value = "Yes";
        } else {
          selectedFeaturedType.value = "No";
        }
        daysTextController.text =
            value?.body["data"]['product']["return_days_count"].toString()??"";
        isProductReturnable.value =
            value?.body["data"]['product']["is_product_returnable"];
        if (isProductReturnable.value) {
          selectedProductReturnableType.value = "Yes";
        } else {
          selectedProductReturnableType.value = "No";
        }
        lengthTextController.text =
            value?.body["data"]['product']["length"].toString()??"";
        breadthTextController.text =
            value?.body["data"]['product']["width"].toString()??"";
        heightTextController.text =
            value?.body["data"]['product']["height"].toString()??"";
        weightTextController.text =
            value?.body["data"]['product']["weight"].toString()??"";
        selectedCategories.value =
            value?.body["data"]['product']['product_categories'] ?? [];
                 isSelectedCategory.value = false;
        for (int i = 0; i < categoriesList.length; i++) {
          for (int j = 0; j < selectedCategories.length; j++) {
            if (categoriesList[i].categoryId.toString() ==
                selectedCategories[j]['category']['category_id'].toString()) {
              categoriesList[i].isSelected = true;
            }
          }
        }
        isSelectedCategory.value = true;
        productContent.value =
            value?.body["data"]['product']["product_contents"] ?? [];
        productLinks.value =
            value?.body["data"]['product']["product_links"] ?? [];
        if (productContent.isNotEmpty) {
          for (int i = 0; i < productContent.length; i++) {
            contentsAndStrainsTextController.text =
                productContent[i]['paragraph'];
            lastProductContent.value = productContent[i]['paragraph'];
          }
        }
        if (productLinks.isNotEmpty) {
          for (int i = 0; i < productLinks.length; i++) {
            additionalLinkTextController.text = productLinks[i]['link'];
            lastProductLink.value = productLinks[i]['link'];
          }
        }
        isEnabled.value = value?.body["data"]['product']["is_enabled"] ?? false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Update  Store Product Api
  Future apiUpdateStoreProductDetail() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    inputData.storeId = int.parse(storeId.value);
    InputProduct product = InputProduct();
    product.productId = int.parse(productId.value);
    product.quantityTypeId = int.parse(quantityValue.value);
    product.quantity = double.parse(quantityTextController.text.trim());
    product.isFeaturedProduct = isFeatured.value;
    product.productName = productNameTextController.text.trim();
    product.description = shortDescriptionTextController.text.trim();
    product.productPrice = double.parse(pricePerUnitTextController.text.trim());
    product.sellingPrice = double.parse(pricePerUnitTextController.text.trim());
    product.discountType = discountType.value.isEmpty
        ? "amount"
        : discountType.value.toLowerCase();
    product.discountValue = double.parse(
        discountOrOfferTextController.text.trim().isEmpty
            ? "0"
            : discountOrOfferTextController.text.trim());
    product.isProductReturnable = isProductReturnable.value;
    product.returnDaysCount = daysTextController.text.trim().isEmpty
        ? 0
        : int.parse(daysTextController.text.trim());
    product.length = double.parse(lengthTextController.text.trim().isEmpty
        ? "0.0"
        : lengthTextController.text.trim());
    product.width = double.parse(breadthTextController.text.trim().isEmpty
        ? "0.0"
        : breadthTextController.text.trim());
    product.height = double.parse(heightTextController.text.trim().isEmpty
        ? "0.0"
        : heightTextController.text.trim());
    product.weight = double.parse(weightTextController.text.trim());
    product.isEnabled = isEnabled.value;
    inputData.product = product;
    List<ProductCategories> listProductCategory = <ProductCategories>[];
    for (int i = 0; i < selectedCategories.length; i++) {
      ProductCategories productCategory = ProductCategories();
      productCategory.status = selectedCategories[i]['status'];
      productCategory.categoryId =
          selectedCategories[i]['category']["category_id"];
      productCategory.productCategoryId =
          selectedCategories[i]['product_category_id'];
      productCategory.category = Category(
          categoryId: selectedCategories[i]['category']["category_id"]);
      listProductCategory.add(productCategory);
    }
    inputData.productCategories = listProductCategory.cast<ProductCategories>();
    inputData.productLinks = <ProductLink>[
      ProductLink(
          name: "Product link 1",
          link: lastProductLink.value != additionalLinkTextController.text
              ? additionalLinkTextController.text
              : lastProductLink.value,
          order: 1,
          status: lastProductLink.value != additionalLinkTextController.text
              ? "active"
              : "deleted",
          productLinkId:
              lastProductLink.value != additionalLinkTextController.text
                  ? null
                  : "1")
    ];
    inputData.productContents = <ProductContent>[
      ProductContent(
        heading: "Demo heading 1",
        paragraph:
            lastProductContent.value != contentsAndStrainsTextController.text
                ? contentsAndStrainsTextController.text
                : lastProductContent.value,
        order: 1,
        productContentId:
            lastProductContent.value != contentsAndStrainsTextController.text
                ? null
                : "1",
        status: lastProductContent.value != additionalLinkTextController.text
            ? "active"
            : "deleted",
      )
    ];

         UserProvider()
        .putWithHeadersApi(
            inputData,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeProductEdit}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);

        resetForm();

        if (Get.parameters['isFromHome'] == "true") {
          Get.delete<ManageStoreController>();
        }
        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();

        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Api Delete Product
  Future apiDeleteProduct() async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {"store_id": storeId.value, "product_id": productId.value};
         UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeProductDelete}",
            headers,
            showLoading: false)
        .then((value) async {   isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        await apiGetStoreProducts();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);
        await apiGetStoreProducts();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Api Delete Category
  Future apiDeleteCategory() async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {"store_id": storeId.value, "category_id": categoryId.value};
         UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeCategoryDelete}",
            headers,
            showLoading: false)
        .then((value) async {   isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        await apiGetCategoriesList();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);
        await apiGetCategoriesList();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
