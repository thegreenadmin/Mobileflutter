import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/dashboard/home/model/pagination_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;

  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  late NearbyStoreListResponse nearbyStoreListResponse = NearbyStoreListResponse();
  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  RxInt page = 1.obs;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          apiGetNearByStores();
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    firstName!.value = Get.arguments["firstName"] ?? "";
    lastName!.value = Get.arguments["lastName"] ?? "";
    apiGetNearByStores();
  }

  //Get Nearby Stores Api
  Future apiGetNearByStores() async {
    debugPrint(
        "GET GET NEARBY STORES URL**********"
            "${ServerCommunicator().baseUrl}${ServerCommunicator().nearByStoreList}");
    Map<String, String> headers = {
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "q": "",
      "page": 1,
      "page_size": 10,
      "longitude": 37.0902,
      "latitude": 95.7129,
      "postal_code": null,
      "mileage": 100,
      "is_open_now": false,
      "opening_time": "00:00:00",
      "closing_time": "24:00:00",
      "is_favourite_store": null
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
        data,
            ServerCommunicator().baseUrl + ServerCommunicator().nearByStoreList,
            headers, showLoading: false)
        .then((value) async {
      debugPrint("GET NEARBY STORES *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        storeAddresses.addAll(nearbyStoreListResponse.data!.storeAddresses as Iterable<StoreAddress>);
        page++;
        // storeAddresses.addAll(storeAddresses);
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }
}
