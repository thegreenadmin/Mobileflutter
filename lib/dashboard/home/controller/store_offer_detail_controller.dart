import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/store_offer_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

import '../../../utils/constants.dart';

class StoreOfferDetailController extends GetxController {
  StoreOfferDetailModel storeOfferDetailModel = StoreOfferDetailModel();
  RxList<Products> storeOfferDetailList = <Products>[].obs;
  RxString storeId = "".obs;
  RxString offerId = "".obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxBool isLoading = false.obs;
  RxInt pageId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.parameters["storeId"] ?? "";
    offerId.value = Get.parameters["offerId"] ?? "";
    apiGetStoreOffersDetail();
    getPage();

  }
  getPage()async{
    firstName?.value = await SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
    lastName?.value = await SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
    pageId.value = await SharedPreferenceStorage.getData("pageId");
    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
  }
  //Get store offer detail
  Future apiGetStoreOffersDetail() async {
    isLoading.value = true;
    debugPrint("STORE FEATURED PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${token.toString()}",
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
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
