import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/store_offer_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreOfferDetailController extends GetxController {
  StoreOfferDetailModel storeOfferDetailModel = StoreOfferDetailModel();
  RxList<Products> storeOfferDetailList = <Products>[].obs;
  RxString storeId = "".obs;
  RxString offerId = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.parameters["storeId"] ?? "";
    offerId.value = Get.parameters["offerId"] ?? "";
    apiGetStoreOffersDetail();
  }

  //Get store offer detail
  Future apiGetStoreOffersDetail() async {
    isLoading.value = true;
    debugPrint("STORE FEATURED PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "q": "",
      "store_id": storeId.value,
      "page": 1,
      "page_size": 5,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": false,
      "offer_id": offerId.value,
      "filters": [
        {
          "filter_by": "is_featured_product",
          "filter_value": true,
          "operation": "eq"
        }
      ]
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("STORE FEATURED PRODUCT BODY ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeFeatureProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE FEATURED PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeOfferDetailModel = StoreOfferDetailModel.fromJson(value?.body);
        storeOfferDetailList.value = storeOfferDetailModel.data!.products!;
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
}
