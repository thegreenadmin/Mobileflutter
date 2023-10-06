import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/offers/model/offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddOffersController extends GetxController {
  TextEditingController offerNameTextController = TextEditingController();
  TextEditingController discountOrOfferTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString discountValueType = "percentage".obs;
  RxString discountType = "".obs;
  RxString storeIdValue = "".obs;
  RxBool isLoading = false.obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString radioValue = "store".obs;
  RxBool autoValidate = true.obs;
  Rx<XFile> categoryImage = XFile("").obs;
  RxString offerImageOriginalLinkFromServer = "".obs;
  RxString offerImageDynamicLinkFromServer = "".obs;
  RxInt pageId = 0.obs;
  RxString offerId = "".obs;
  RxString isFrom = "".obs;
  RxString storeName = "".obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;
  RxList<dynamic> selectedProducts = <dynamic>[].obs;
  late GetStoreNonOfferProductList getStoreProductList =
      GetStoreNonOfferProductList();
  RxList<NonOfferProductsList> storeProductList = <NonOfferProductsList>[].obs;

  late AddOfferRequestModel addOfferRequestModel = AddOfferRequestModel();
  late GetOfferDetailModel getOfferDetailModel = GetOfferDetailModel();

  List<OfferProduct> offerProducts = <OfferProduct>[];
  RxList<OfferProduct> offerProductDetail = <OfferProduct>[].obs;
  RxList<OfferProduct> productMergedList = <OfferProduct>[].obs;

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
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

  Future apiUploadImage() async {
    try {
      final dio = mdio.Dio();
      mdio.FormData formData = mdio.FormData.fromMap({});

      Map<String, String> headers = {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
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
      if (res.statusCode == ApiConstants.statusCode200 ||
          res.statusCode == ApiConstants.statusCode201) {
        offerImageOriginalLinkFromServer.value =
            responseData['data']['urls']['orignal_url'];
        offerImageDynamicLinkFromServer.value =
            responseData['data']['urls']['dynamic_url'];

        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode403) {
        Utility.showToast(responseData['message'].toString());
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      if (e is mdio.DioException) {
        if (e.type == mdio.DioExceptionType.badResponse) {
          debugPrint("${e.response?.data ?? ""}");
          final responseData =
              json.decode(e.response?.data) as Map<String, dynamic>;
          return responseData;
        }
      }
      throw Exception('Failed to load data ! $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    apiGetStoreList();

    isFrom.value = Get.parameters["isFrom"] ?? "";
    if (isFrom.value == StringConstants.addOfferText) {
    } else {
      storeIdValue.value = Get.parameters["storeId"] ?? "";
      offerId.value = Get.parameters["offerId"] ?? "";

      if (storeIdValue.value.isNotEmpty && offerId.value.isNotEmpty) {
        apiGetStoreProducts();
      }
    }
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

  void validateAndSubmit(isValidateFromAddOffer, context) async {
    if (validateAndSave()) {
      try {
        if (offerImageDynamicLinkFromServer.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseUploadImageText);
        } else if (discountType.value.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectDiscountType);
        } else if (radioValue.value != "store" && storeProductList.isEmpty) {
          Utility.showAlertMessage(
              "There are no product in the store. Please add product first");
        } else if (radioValue.value != "store" &&
            (selectedProducts.isEmpty ||
                selectedProducts
                    .every((element) => element["status"] == "deleted"))) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectProductToProceedText);
        } else {
          isValidateFromAddOffer ? await apiAddOffer() : await apiUpdateOffer();
        }
      } catch (_) {
        Utility.showAlertMessage("Something went wrong!");
      }
    } else {
      autoValidate.value = true;
    }
  }

  ///Add Offer Api
  Future apiAddOffer() async {
    debugPrint(
        "ADD OFFER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferCreate}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    List<OfferProducts> offerProductList = <OfferProducts>[];
    Offer offer = Offer();

    for (int i = 0; i < selectedProducts.length; i++) {
      offerProductList.add(OfferProducts(
          productId: int.parse(selectedProducts[i]['product_id'])));
    }
    addOfferRequestModel.storeId = storeIdValue.value;
    addOfferRequestModel.offerProducts =
        radioValue.value == "store" ? [] : offerProductList;
    offer.isOfferForStore = radioValue.value == "store" ? true : false;
    offer.offerName = offerNameTextController.text.trim();
    offer.imageUrl = offerImageOriginalLinkFromServer.value;
    offer.offerType = discountType.value.toLowerCase();
    offer.offerValue = double.parse(discountOrOfferTextController.text.trim());
    addOfferRequestModel.offer = offer;
    debugPrint("ADD OFFER BODY********** ${addOfferRequestModel.toJson()}");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            addOfferRequestModel,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeOfferCreate,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("ADD OFFER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        radioValue.value = "";
        offerNameTextController.clear();
        storeIdValue.value = "";
        offerImageOriginalLinkFromServer.value = "";
        offerImageDynamicLinkFromServer.value = "";
        discountOrOfferTextController.clear();
        Get.back(id: pageIdApp.value);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Store List Api
  Future apiGetStoreList() async {
    isLoading.value = true;
    debugPrint(
        "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
        Get.parameters["storeCount"] = storeList.length.toString();
        if (storeIdValue.value.isEmpty && storeList.isNotEmpty) {
          if (isFrom.value != StringConstants.editOfferText) {
            storeIdValue.value = storeList[0].storeId.toString();
            apiGetStoreProducts();
          }
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  /// Get store products List Api
  Future apiGetStoreProducts() async {
    isLoading.value = true;
    debugPrint(
      "GET STORE PRODUCTS LIST URL ADD**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "q": "",
      "store_id": storeIdValue.value,
      "page": 1,
      "page_size": 1000,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "filters": []
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
        getStoreProductList = GetStoreNonOfferProductList.fromJson(value.body);
        storeProductList.value = getStoreProductList.data!.products!;
        if (isFrom.value == StringConstants.editOfferText) {
          apiGetOffersDetail();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get store products have no offer
  Future apiGetStoreNonOfferProducts() async {
    isLoading.value = true;
    debugPrint(
      "GET STORE PRODUCTS LIST URL**********"
      "${ServerCommunicator().baseUrl}${ServerCommunicator().storeNonOfferProductList}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "q": "",
      "store_id": storeIdValue.value,
      "page": 1,
      "page_size": 10,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeNonOfferProductList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE PRODUCTS LIST BODY *******$body");
      debugPrint("GET STORE PRODUCTS LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStoreProductList = GetStoreNonOfferProductList.fromJson(value.body);
        storeProductList.value = getStoreProductList.data!.products!;
        if (isFrom.value == StringConstants.editOfferText) {
          productMergedList.clear();
          offerProducts.clear();
          offerProducts.addAll(getOfferDetailModel.data!.offerProducts!);
          productMergedList.addAll(offerProducts);
          for (int i = 0; i < storeProductList.length; i++) {
            productMergedList.add(OfferProduct(
              offerProductId: storeProductList[i].productId,
              product: Product(
                description: storeProductList[i].description,
                discountType: storeProductList[i].discountType,
                discountValue: storeProductList[i].discountValue,
                isEnabled: storeProductList[i].isEnabled,
                height: storeProductList[i].height,
                isFeaturedProduct: storeProductList[i].isFeaturedProduct,
                length: storeProductList[i].length,
                storeId: storeProductList[i].storeId,
                isProductReturnable: storeProductList[i].isProductReturnable,
                productId: storeProductList[i].productId,
                productName: storeProductList[i].productName,
                quantity: storeProductList[i].quantity,
                productPrice: storeProductList[i].productPrice,
                returnDaysCount: storeProductList[i].returnDaysCount,
                weight: storeProductList[i].weight,
                width: storeProductList[i].width,
                status: "deleted",
                createdAt: storeProductList[i].createdAt,
                updatedAt: storeProductList[i].updatedAt,
              ),
            ));
          }
        } else {
          if (storeProductList.isEmpty && radioValue.value == "product") {
            Utility.showToast(AlertStringConstants.noProductFoundForThisStore);
          }
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Offers Detail List Api
  Future apiGetOffersDetail() async {
    debugPrint(
      "GET OFFER DETAIL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersDetails}?store_id=${storeIdValue.value}&offer_id=${offerId.value}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersDetails}?store_id=${storeIdValue.value}&offer_id=${offerId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      log("GET OFFER DETAIL RESPONSE *******${jsonEncode(value!.body)}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOfferDetailModel = GetOfferDetailModel.fromJson(value.body);
        offerNameTextController.text = getOfferDetailModel.data!.offerName!;
        discountOrOfferTextController.text =
            getOfferDetailModel.data!.offerValue!.toString();
        offerImageDynamicLinkFromServer.value =
            getOfferDetailModel.data!.image!.dynamicUrl ?? "";
        offerImageOriginalLinkFromServer.value =
            getOfferDetailModel.data!.image!.orignalUrl ?? "";

        offerProductDetail.value =
            getOfferDetailModel.data?.offerProducts ?? [];
        if (getOfferDetailModel.data!.isOfferForStore == true) {
          radioValue.value = "store";
        } else {
          radioValue.value = "product";

          for (var product in storeProductList) {
            for (var element in offerProductDetail) {
              if (product.productId == element.productId) {
                product.offerStatus = element.status;
                product.offerProductId = element.offerProductId;
                selectedProducts.add({
                  "offer_product_id": element.offerProductId,
                  "product_id": element.productId,
                  "status": element.status
                });
              }
            }
          }
        }

        storeIdValue.value =
            getOfferDetailModel.data!.store!.storeId.toString();
        discountType.value = getOfferDetailModel.data!.offerType!;
        storeName.value = getOfferDetailModel.data!.store!.storeName!;

        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Update Offer Api
  Future apiUpdateOffer() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "store_id": storeIdValue.value,
      "offer": {
        "offer_id": offerId.value,
        "offer_name": offerNameTextController.text.trim(),
        "image_url": offerImageOriginalLinkFromServer.value.trim(),
        "offer_value": double.parse(discountOrOfferTextController.text.trim()),
      },
      "offer_products": selectedProducts
    };
    debugPrint("UPDATE OFFER BODY**********$body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .putWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOfferEdit,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("UPDATE OFFER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        radioValue.value = "";

        Get.back(id: pageIdApp.value);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
