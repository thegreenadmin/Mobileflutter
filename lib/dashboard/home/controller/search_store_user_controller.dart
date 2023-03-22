import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/dashboard/home/model/pagination_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:dio/dio.dart' as mdio;
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

  late NearbyStoreListResponse nearbyStoreListResponse = NearbyStoreListResponse();
  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  RxInt page = 1.obs;

  RxBool isLoading = false.obs;

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
  }

  //Get Nearby Stores Api
  Future apiGetNearByStores() async {
    isLoading.value= storeAddresses.isNotEmpty?true:false;
    debugPrint(
        "GET GET NEARBY STORES URL**********"
            "${ServerCommunicator().baseUrl}${ServerCommunicator().nearByStoreList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "q": "",
      "page": page.value,
      "page_size": 3,
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
            headers, showLoading: page.value==1)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET NEARBY STORES *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        if(nearbyStoreListResponse.data!.storeAddresses!.isNotEmpty){
          if(page.value==1) {storeAddresses.value = [];}
        storeAddresses.addAll(nearbyStoreListResponse.data!.storeAddresses as Iterable<StoreAddress>);
        }
         page.value++;
        update();
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

  //Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value= storeAddresses.isNotEmpty?true:false;
    debugPrint(
        "Create Favourite Store URL**********"
            "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "store_id": int.parse(id??"0")
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
        data,
            ServerCommunicator().baseUrl + ServerCommunicator().createFavouriteStore,
            headers, showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Store *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        Utility.showToast(value?.body['message']);
        for (var element in storeAddresses) {
          if(element.store?.storeId == id){
            element.store?.isFavouriteStore=true;
          }
        }
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value= storeAddresses.isNotEmpty?true:false;
    debugPrint(
        "Remove Favourite Store URL**********"
            "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "favourite_store_id": int.parse(id??"0")
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
        data,
            ServerCommunicator().baseUrl + ServerCommunicator().removeFavouriteStore,
            headers, showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Store *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        Utility.showToast(value?.body['message']);
        for (var element in storeAddresses) {
          if(element.store?.storeId == id){
            element.store?.isFavouriteStore=false;
          }
        }
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
