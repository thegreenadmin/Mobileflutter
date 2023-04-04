import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController {
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  late NearbyStoreListResponse nearbyStoreListResponse =
      NearbyStoreListResponse();
  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;
  RxList<StoreAddress> favStoreAddresses = <StoreAddress>[].obs;
  var kGoogleApiKey = "";
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;
  RxInt selectedIndex = 0.obs;

  RxInt page = 1.obs;
  RxInt initialIndex = 0.obs;

  RxBool isLoading = false.obs;
  RxBool isFavLoading = false.obs;
  RxBool isOpenNow = false.obs;
  RxBool isDataLoading = false.obs;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          apiGetStoresBySelectedTabs(isFilter: false, isPreviousStores: false);
        }
      }
    });
  }

  RxList horizontalTabList = [
    StringConstants.nearbyText,
    StringConstants.previousText,
    StringConstants.favoriteText,
  ].obs;

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    switch (i) {
      case 0: //Nearby
        {
          debugPrint(selectedIndex.value.toString());
          apiGetStoresBySelectedTabs(isFilter: false, isPreviousStores: false);
        }
        break;

      case 1: //Previous
        {
          debugPrint(selectedIndex.value.toString());
          apiGetStoresBySelectedTabs(isFilter: false, isPreviousStores: true);
        }
        break;
      case 2: //Fav
        {
          debugPrint(selectedIndex.value.toString());
          apiGetStoresBySelectedTabs(isFilter: false, isPreviousStores: true);
        }
        break;

      default:
        {
          debugPrint(selectedIndex.value.toString());
          apiGetStoresBySelectedTabs(isFilter: true, isPreviousStores: false);
        }
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    apiGetStoresBySelectedTabs(isFilter: false, isPreviousStores: false);
    setupScrollController(Get.context);
  }

  //Get Stores Api
  Future apiGetStoresBySelectedTabs(
      {bool isFilter = false, bool isPreviousStores = false}) async {
    isDataLoading.value = true;
    nearbyStoreListResponse = NearbyStoreListResponse();
    isLoading.value = storeAddresses.isNotEmpty ? true : false;
    isFavLoading.value = favStoreAddresses.isNotEmpty ? true : false;

    debugPrint("GET STORES BY TABS URL **********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().nearByStoreList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "q": "",
      "page": page.value,
      "page_size": 5,
      "longitude": 37.0902,
      "latitude": 95.7129,
      "postal_code":
          zipCodeTextController.text != "" ? zipCodeTextController.text : null,
      "mileage": mileageTextController.text != ""
          ? int.parse(mileageTextController.text)
          : 1000,
      "is_open_now": isOpenNow.value,
      "opening_time": openingTimeTextController.text != ""
          ? Utility.formatDateTime(openingTimeTextController.text,
              firstFormat: "hh:mm a", secFormat: "hh:mm:ss")
          : "00:00:00",
      "closing_time": closingTimeTextController.text != ""
          ? Utility.formatDateTime(closingTimeTextController.text,
              firstFormat: "hh:mm a", secFormat: "hh:mm:ss")
          : "24:00:00",
      "is_favourite_store": null,
      "show_previous_stores": isPreviousStores ? true : null
    };
    debugPrint("TOKEN ********** $headers");
    debugPrint("GET STORES BY TABS BODY ********** $data");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().nearByStoreList,
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      isLoading.value = false;
      isFavLoading.value = false;
      isDataLoading.value = false;
      debugPrint("GET STORES BY TABS RESPONSE*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        List<StoreAddress>? storeAddressesNewList = [];
        storeAddressesNewList = nearbyStoreListResponse.data!.storeAddresses;
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            storeAddresses.value = [];
            favStoreAddresses.value = [];
          }
          storeAddresses.addAll(storeAddressesNewList);
          for (var element in storeAddresses) {
            if (element.store?.isFavouriteStore == true) {
              favStoreAddresses.add(element);
            }
          }
        }
        storeAddresses.toSet().toList();
        page.value++;
        update();
        if (isFilter) {
          zipCodeTextController.clear();
          openingTimeTextController.clear();
          closingTimeTextController.clear();
          mileageTextController.clear();
          isOpenNow.value = false;
          initialIndex.value = 0;
          storeAddresses.clear();
          favStoreAddresses.clear();
          Get.back();
        }
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
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
    isLoading.value = storeAddresses.isNotEmpty ? true : false;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        for (var element in storeAddresses) {
          if (element.store?.storeId == id) {
            element.store?.isFavouriteStore = true;
            favStoreAddresses.add(element);
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
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
    isLoading.value = storeAddresses.isNotEmpty ? true : false;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().removeFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        for (var element in storeAddresses) {
          if (element.store?.storeId == id) {
            element.store?.isFavouriteStore = false;
            favStoreAddresses.remove(element);
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }
}
