import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:thegreenmall/dashboard/home/model/get_categories_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/input_add_product.dart';
import 'package:thegreenmall/dashboard/home/model/quantity_list_response_model.dart'
    as quantity_model;
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
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

  RxList selectedCategories = [].obs;
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
  RxString discountValueType = "".obs;
  RxString lastProductContent = "".obs;
  RxString lastProductLink = "".obs;
  RxString quantityValue = "".obs;
  InputAddProduct inputData = InputAddProduct();
  List<XFile> selectedImages = <XFile>[];
  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  RxList<Categories> categoriesList = <Categories>[].obs;
  late quantity_model.QuantityListResponse quantityListResponse =
      quantity_model.QuantityListResponse();
  RxList<quantity_model.QuantityType> quantityTypeList =
      <quantity_model.QuantityType>[].obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  RxList<dynamic> productContent = <dynamic>[].obs;
  RxList<dynamic> productLinks = <dynamic>[].obs;

  final ImagePicker imagePicker = ImagePicker();
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
    if (selectedImages.isNotEmpty) {
      if (selectedImages.length >= 5) {
        return Utility.showAlertMessage(
            AlertStringConstants.only5MaximumImagesCanSelectText);
      }
      //else {
      imageFileList!.addAll(selectedImages);
      apiUploadMultipleImage(imageUrlList.length);
      // }
    }
  }

  @override
  void onInit() {
    super.onInit();
    isFeaturedTypeSelected.value = false;
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    storeLocation.value = Get.parameters["storeLocation"] ?? "";
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

  void validateAndSubmit(BuildContext bCntx) async {
    if (validateAndSave()) {
      try {
        if (imageFileList!.length < 1) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseUploadAtLeastOneImageText);
        } else if (selectedCategories.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectCategoriesText);
        } else {
          apiCreateProduct(bCntx);
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

  void validateAndSubmitUpdateProduct(BuildContext ctx) async {
    if (validateAndSaveUpdateProduct()) {
      try {
        var data = selectedCategories
            .where((element) => element["status"] == 'active');
        if (data.isEmpty) {
          Utility.showAlertMessage("Please select categories");
        } else {
          apiUpdateStoreProductDetail(ctx);
        }
      } catch (_) {}
    } else {
      updateAutoValidate.value = true;
    }
  }

  //Api upload image to server
  Future<Future<bool?>?> apiUploadMultipleImage(length) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(ServerCommunicator().baseUrl +
            ServerCommunicator().fileUploadMultiple));
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    if (imageFileList!.isNotEmpty) {
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
        debugPrint(value);
        List<ProductImagesList> imagesList = <ProductImagesList>[];
        for (int i = 0; i < jsonDecode(value)['data']['files'].length; i++) {
          var imageData = jsonDecode(value)['data']['files'][i];
          imagesList.add(ProductImagesList(
              imageUrl: imageData['orignal_url'],
              order: length + 1 + i,
              status: 'active',
              dynamicImageUrl: imageData['dynamic_url']));
        }
        imageUrlList.addAll(imagesList);
        inputData.productImages = imagesList;
        imageUrlList.refresh();
      });
    } else {
      Utility.showAlertMessage("Please Select atleast one image");
    }
    return null;
  }

  //Get Categories Api
  Future apiGetCategoriesList() async {
    categoriesList.clear();
    isLoading.value = true;
    debugPrint(
        "GET CATEGORIES URL**********${ServerCommunicator().baseUrl}${"${ServerCommunicator().categoryList}?store_id=${storeId.value}&is_featured_category=${isFeaturedTypeSelected.value}"}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}&is_featured_category=${isFeaturedTypeSelected.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CATEGORIES LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getCategoriesModel = GetCategoriesModel.fromJson(value.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
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

  //Get Quantity List Api
  Future apiGetQuantityList() async {
    quantityTypeList.clear();
    isLoading.value = true;
    debugPrint(
        "GET QuantityList URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeQuantityTypeList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeQuantityTypeList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET Quantity LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        quantityListResponse =
            quantity_model.QuantityListResponse.fromJson(value?.body);
        quantityTypeList.value = quantityListResponse.data?.quantityTypes ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Products List Api
  Future apiGetProductList(BuildContext bctxx) async {
    categoriesList.clear();
    isLoading.value = true;
    debugPrint("GET PRODUCT LIST URL **********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().categoryList}?store_id=${storeId.value}");
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
      debugPrint("GET PRODUCT LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getCategoriesModel = GetCategoriesModel.fromJson(value.body);
        categoriesList.value = getCategoriesModel.data!.categories!;
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

  //Create Product Api
  Future apiCreateProduct(BuildContext cntx) async {
    inputData.storeId = int.parse(storeId.value);
    Product product = Product();
    product.quantityTypeId = int.parse(quantityValue.value);
    product.quantity = int.parse(quantityTextController.text.trim());
    product.isFeaturedProduct = isFeatured.value;
    product.productName = productNameTextController.text.trim();
    product.description = shortDescriptionTextController.text.trim();
    product.productPrice = int.parse(pricePerUnitTextController.text.trim());
    product.sellingPrice = int.parse(pricePerUnitTextController.text.trim());
    product.discountType = discountType.value.isEmpty
        ? "amount"
        : discountType.value.toLowerCase();
    product.discountValue = int.parse(
        discountOrOfferTextController.text.trim().isEmpty
            ? "0"
            : discountOrOfferTextController.text.trim());
    product.isProductReturnable = isProductReturnable.value;
    product.returnDaysCount = daysTextController.text.trim().isEmpty
        ? 0
        : int.parse(daysTextController.text.trim());
    product.length = int.parse(lengthTextController.text.trim());
    product.width = int.parse(breadthTextController.text.trim());
    product.height = int.parse(heightTextController.text.trim());
    product.weight = int.parse(weightTextController.text.trim());
    product.isEnabled = isEnabled.value;
    inputData.product = product;
    List<ProductCategory> listProductCategory = <ProductCategory>[];
    for (int i = 0; i < selectedCategories.length; i++) {
      listProductCategory.add(ProductCategory(
          categoryId: int.parse(selectedCategories[i]["category_id"])));
    }
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

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("CREATE PRODUCT BODY********** ${inputData.toJson()}");
    debugPrint(
        "CREATE PRODUCT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createProduct}");
    UserProvider()
        .postWithHeadersApi(
            inputData,
            ServerCommunicator().baseUrl + ServerCommunicator().createProduct,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        Navigator.of(cntx).pop();
        Navigator.of(cntx).pop();
        await apiGetCategoriesList();
        update();
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
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
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
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE PRODUCTS LIST BODY *******$body");
      debugPrint("GET STORE PRODUCTS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStoreProductList = GetStoreProductList.fromJson(value.body);
        storeProductList.value = getStoreProductList.data!.products!;
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

//Api to get details of one product
  Future apiGetProductDetails() async {
    isLoading.value = true;
    debugPrint(
      "GET PRODUCTS DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDetail}?store_id=${storeId.value}&product_id=${productId.value}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDetail}?store_id=${storeId.value}&product_id=${productId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET PRODUCTS DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        productNameTextController.text =
            value.body["data"]['product']["product_name"] ?? "";
        discountType.value =
            value.body["data"]['product']["discount_type"] ?? "";
        if (discountType.value == "amount") {
          discountValueType.value = "Amount";
        } else {
          discountValueType.value = "Percentage";
        }
        imageUrlList.clear();
        for (int i = 0;
            i < value.body["data"]['product']['product_images'].length;
            i++) {
          var image = value.body["data"]['product']['product_images'][i];
          imageUrlList.add(ProductImagesList(
              productImageId: image['product_image_id'],
              imageUrl: image["image"]["orignal_url"],
              dynamicImageUrl: image["image"]["dynamic_url"],
              order: image["order"],
              status: image["status"]));
        }
        inputData.productImages = imageUrlList;
        discountOrOfferTextController.text =
            value.body["data"]['product']["discount_value"].toString();
        quantityValue.value =
            value.body["data"]['product']["quantity_type_id"].toString();
        quantityTextController.text =
            value.body["data"]['product']["quantity"].toString();

        pricePerUnitTextController.text =
            value.body["data"]['product']["product_price"].toString();
        shortDescriptionTextController.text =
            value.body["data"]['product']["description"] ?? "";
        isFeatured.value = value.body["data"]['product']["is_featured_product"];
        if (isFeatured.value) {
          selectedFeaturedType.value = "Yes";
        } else {
          selectedFeaturedType.value = "No";
        }
        daysTextController.text =
            value.body["data"]['product']["return_days_count"].toString();
        isProductReturnable.value =
            value.body["data"]['product']["is_product_returnable"];
        if (isProductReturnable.value) {
          selectedProductReturnableType.value = "Yes";
        } else {
          selectedProductReturnableType.value = "No";
        }
        lengthTextController.text =
            value.body["data"]['product']["length"].toString();
        breadthTextController.text =
            value.body["data"]['product']["width"].toString();
        heightTextController.text =
            value.body["data"]['product']["height"].toString();
        weightTextController.text =
            value.body["data"]['product']["weight"].toString();
        selectedCategories.value =
            value.body["data"]['product']['product_categories'] ?? [];
        for (int i = 0; i < categoriesList.length; i++) {
          for (int j = 0; j < selectedCategories.length; j++) {
            if (categoriesList[i].categoryId ==
                selectedCategories[j]['category']['category_id']) {
              categoriesList[i].isSelected = true;
            }
          }
        }
        productContent.value =
            value.body["data"]['product']["product_contents"] ?? [];
        productLinks.value =
            value.body["data"]['product']["product_links"] ?? [];
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
        isEnabled.value = value.body["data"]['product']["is_enabled"] ?? false;
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

//Update  Store Product Api
  Future apiUpdateStoreProductDetail(BuildContext ctxx) async {
    debugPrint(
        "UPDATE STORE PRODUCT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductEdit}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    inputData.storeId = int.parse(storeId.value);
    Product product = Product();
    product.productId = int.parse(productId.value);
    product.quantityTypeId = int.parse(quantityValue.value);
    product.quantity = int.parse(quantityTextController.text.trim());
    product.isFeaturedProduct = isFeatured.value;
    product.productName = productNameTextController.text.trim();
    product.description = shortDescriptionTextController.text.trim();
    product.productPrice = int.parse(pricePerUnitTextController.text.trim());
    product.sellingPrice = int.parse(pricePerUnitTextController.text.trim());
    product.discountType = discountType.value.isEmpty
        ? "amount"
        : discountType.value.toLowerCase();
    product.discountValue = int.parse(
        discountOrOfferTextController.text.trim().isEmpty
            ? "0"
            : discountOrOfferTextController.text.trim());
    product.isProductReturnable = isProductReturnable.value;
    product.returnDaysCount = daysTextController.text.trim().isEmpty
        ? 0
        : int.parse(daysTextController.text.trim());
    product.length = int.parse(lengthTextController.text.trim());
    product.width = int.parse(breadthTextController.text.trim());
    product.height = int.parse(heightTextController.text.trim());
    product.weight = int.parse(weightTextController.text.trim());
    product.isEnabled = isEnabled.value;
    inputData.product = product;
    List<ProductCategory> listProductCategory = <ProductCategory>[];
    for (int i = 0; i < selectedCategories.length; i++) {
      ProductCategory productCategory = ProductCategory();
      productCategory.status = selectedCategories[i]['status'];
      productCategory.productCategoryId =
          selectedCategories[i]['product_category_id'];
      productCategory.category = Categorys(
          categoryId:
              int.parse(selectedCategories[i]['category']["category_id"]));
      listProductCategory.add(productCategory);
    }
    inputData.productCategories = listProductCategory;
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

    debugPrint(
        "UPDATE STORE PRODUCT BODY********************${inputData.toJson()}");
    UserProvider()
        .putWithHeadersApi(
            inputData,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductEdit}",
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE STORE PRODUCT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        // Get.back();
        Navigator.of(ctxx).pop();
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
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(ctxx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

//Api Delete Product
  Future apiDeleteProduct(BuildContext buildCtxt) async {
    debugPrint(
        "DELETE PRODUCT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"store_id": storeId.value, "product_id": productId.value};
    debugPrint("DELETE PRODUCT BODY ************* $data");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE PRODUCT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetProductList(buildCtxt);
        update();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetProductList(buildCtxt);
        update();
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

//Api Delete Category
  Future apiDeleteCategory() async {
    debugPrint(
        "DELETE CATEGORY URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {"store_id": storeId.value, "category_id": categoryId.value};
    debugPrint("DELETE CATEGORY BODY ************* $data");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeCategoryDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetCategoriesList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetCategoriesList();
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
}
