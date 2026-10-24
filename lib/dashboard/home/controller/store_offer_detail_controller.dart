import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class StoreOfferDetailController extends GetxController with GlobalVarMixin {
  StoreOfferDetailModel storeOfferDetailModel = StoreOfferDetailModel();
  RxList<StoreOfferProducts> storeOfferDetailList = <StoreOfferProducts>[].obs;
  RxString storeId = "".obs;
  RxString offerId = "".obs;
  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;
  RxBool isLoading = false.obs;
  RxInt pageId = 0.obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeParams();
  }

  @override
  void onReady() {
    super.onReady();
    _loadOfferDetail();
  }

  // --- Params Setup ---
  void _initializeParams() {
    final params = Get.parameters;
    storeId.value = params["storeId"] ?? "0";
    offerId.value = params["offerId"] ?? "0";
    role?.value = roleApp.value;
  }

  // --- Initial Data Load ---
  Future<void> _loadOfferDetail() async {
    await apiGetStoreOffersDetail();
  }
  ///Get store offer detail
  Future apiGetStoreOffersDetail() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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

              UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeFeatureProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeOfferDetailModel = StoreOfferDetailModel.fromJson(value?.body);
        storeOfferDetailList.value = storeOfferDetailModel.data!.products!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
