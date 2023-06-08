import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/offers/model/add_offer_request_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_offer_detail_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_store_non_offer_product_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:dio/dio.dart' as mdio;

class AddOffersController extends GetxController {
  TextEditingController offerNameTextController = TextEditingController();
  TextEditingController discountOrOfferTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString discountValueType = "percentage".obs;
  RxString discountType = "".obs;
  RxString storeIdValue = "".obs;
  RxBool isLoading = false.obs;
  //RxBool isStoreOffer = false.obs;
  RxString radioValue = "store".obs;
  RxBool autoValidate = true.obs;
  Rx<XFile> categoryImage = XFile("").obs;
  RxString offerImageOrigionalLinkfromServer = "".obs;
  RxString offerImageDynamicLinkfromServer = "".obs;

  RxString storeId = "".obs;
  RxString offerId = "".obs;
  RxString isFrom = "".obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;
  RxList<dynamic> selectedProducts = <dynamic>[].obs;
  late GetStoreNonOfferProductList getStoreProductList =
      GetStoreNonOfferProductList();
  RxList<ProductsList> storeProductList = <ProductsList>[].obs;

  late AddOfferRequestModel addOfferRequestModel = AddOfferRequestModel();
  late GetOfferDetailModel getOfferDetailModel = GetOfferDetailModel();
  List<OfferProduct> offerProducts = <OfferProduct>[];

  RxList<OfferProduct> productMergedList = <OfferProduct>[].obs;

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      // Get.back();
//Navigator.of(context).pop();
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
//Navigator.of(context).pop();
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
        offerImageOrigionalLinkfromServer.value =
            responseData['data']['urls']['orignal_url'];
        offerImageDynamicLinkfromServer.value =
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

  @override
  void onInit() {
    super.onInit();
    apiGetStoreList();
    // isFrom.value = Get.arguments["isFrom"] ?? "";
    isFrom.value = Get.parameters["isFrom"] ?? "";
    if (isFrom.value == StringConstants.addOfferText) {
    } else {
      storeId.value = Get.parameters["storeId"] ?? "";
      offerId.value = Get.parameters["offerId"] ?? "";

      if (storeId.value.isNotEmpty && offerId.value.isNotEmpty) {
        apiGetOffersDetail();
      }
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

  void validateAndSubmit(isValidateFromAddOffer, context) async {
    if (validateAndSave()) {
      try {
        if (offerImageDynamicLinkfromServer.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseUploadImageText);
        } else if (discountType.value.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectDiscountType);
        } else {
          isValidateFromAddOffer
              ? await apiAddOffer(context)
              : await apiUpdateOffer(context);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Add Offer Api
  Future apiAddOffer(context) async {
    debugPrint(
        "ADD OFFER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferCreate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
    offer.imageUrl = offerImageOrigionalLinkfromServer.value;
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
        // Get.back();
        Navigator.of(context).pop();
        offerNameTextController.clear();
        storeIdValue.value = "";
        offerImageOrigionalLinkfromServer.value = "";
        offerImageDynamicLinkfromServer.value = "";
        discountOrOfferTextController.clear();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Store List Api
  Future apiGetStoreList() async {
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
        if (storeIdValue.value.isEmpty && storeList.isNotEmpty) {
          storeIdValue.value = storeList[0].storeId.toString();
          apiGetStoreProducts();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

//Get store products have no offer
  Future apiGetStoreProducts() async {
    isLoading.value = true;
    debugPrint(
      "GET STORE PRODUCTS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeNonOfferProductList}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
                //   quantityTypeId: storeProductList[i].quantity,
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

//Get Offers Detail List Api
  Future apiGetOffersDetail() async {
    debugPrint(
      "GET OFFER DETAIL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersDetails}?store_id=${storeId.value}&offer_id=${offerId.value}",
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOffersDetails}?store_id=${storeId.value}&offer_id=${offerId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET OFFER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOfferDetailModel = GetOfferDetailModel.fromJson(value.body);
        offerNameTextController.text = getOfferDetailModel.data!.offerName!;
        discountOrOfferTextController.text =
            getOfferDetailModel.data!.offerValue!.toString();
        offerImageDynamicLinkfromServer.value =
            getOfferDetailModel.data!.image!.dynamicUrl ?? "";
        offerImageOrigionalLinkfromServer.value =
            getOfferDetailModel.data!.image!.orignalUrl ?? "";
        if (getOfferDetailModel.data!.isOfferForStore == true) {
          radioValue.value = "store";
        } else {
          radioValue.value = "product";
        }
        storeIdValue.value =
            getOfferDetailModel.data!.store!.storeId.toString();
        discountType.value = getOfferDetailModel.data!.offerType!;

        await apiGetStoreProducts();

        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Update Offer Api
  Future apiUpdateOffer(context) async {
    selectedProducts.clear();
    for (int i = 0; i < productMergedList.length; i++) {
      selectedProducts.add({
        "offer_product_id": productMergedList[i].offerProductId!,
        "product_id": productMergedList[i].product!.productId,
        "status": productMergedList[i].product!.status
      });
    }
    debugPrint(
        "UPDATE OFFER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferEdit}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map body = {
      "store_id": storeIdValue.value,
      "offer": {
        "offer_id": offerId.value,
        "offer_name": offerNameTextController.text.trim(),
        "image_url": offerImageOrigionalLinkfromServer.value.trim(),
        "offer_value": double.parse(discountOrOfferTextController.text.trim()),
        //"is_expired": false
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
        // Get.back();
        Navigator.of(context).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
