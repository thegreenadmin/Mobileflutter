import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController {
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController einNumberTextController = TextEditingController();
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
  RxInt type = 0.obs;
  final scrollController = ScrollController();
  dynamic lat = 0.0;
  dynamic lng = 0.0;

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
    setupScrollController(Get.context);
  }

//Alert

  void enterEinNumberAlert(context, String storeId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.enterEinNumberText,
              style: const TextStyle(
                  color: AppColors.primarydark,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                autofocus: false,
                textCapitalization: TextCapitalization.words,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(40),
                ],
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                controller: einNumberTextController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: StringConstants.enterEinNumberText,
                  hintStyle: const TextStyle(color: AppColors.grey),
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 1.0,
                    ),
                  ),
                )),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (einNumberTextController.text.isEmpty) {
                      Utility.showToast(
                          AlertStringConstants.pleaseEnterEinText);
                    } else {
                      Get.back();
                      apiClaimStore(storeId: storeId);
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.okayText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  //Get Nearby Stores Api
  Future apiGetNearByStores({
    bool isFilter = false,
  }) async {
    isDataLoading.value = true;
    nearbyStoreListResponse = NearbyStoreListResponse();
    isLoading.value = storeAddresses.isNotEmpty ? true : false;
    debugPrint("GET GET NEARBY STORES URL**********"
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
      "longitude": lng,
      "latitude": lat,
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
      "is_favourite_store": type.value == 2 ? true : null,
      "show_previous_stores": type.value == 1 ? true : null
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("GET NEARBY STORES BOSY*******$data");
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
      debugPrint("GET NEARBY STORES *******${value?.body}");
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
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
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
        if (type.value == 2) {
          storeAddresses.clear();
          page.value = 1;
          apiGetNearByStores();
        } else {
          for (var element in storeAddresses) {
            if (element.store?.storeId == id) {
              element.store?.isFavouriteStore = true;
              favStoreAddresses.add(element);
            }
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
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
        if (type.value == 2) {
          storeAddresses.clear();
          page.value = 1;
          apiGetNearByStores();
        } else {
          for (var element in storeAddresses) {
            if (element.store?.storeId == id) {
              element.store?.isFavouriteStore = false;
              favStoreAddresses.remove(element);
            }
          }
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  apiClaimStore({
    String storeId = "",
  }) {
    debugPrint("CLAIM STORE API URL **********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().claimStoreRequest}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "store_id": int.parse(storeId),
      "store_ein": einNumberTextController.text.trim()
    };
    debugPrint("CLAIM STORE BODY **********"
        "$data");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().claimStoreRequest,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CLAIM STORE API BODY *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }
}
