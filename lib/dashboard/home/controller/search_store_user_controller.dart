import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController deliveryServicesController = TextEditingController();
  TextEditingController einNumberTextController = TextEditingController();
  late NearbyStoreListResponse nearbyStoreListResponse =
      NearbyStoreListResponse();
  late PreviousStoreResponse previousStoreListResponse =
      PreviousStoreResponse();
  late FavouriteStoreResponse favouriteStoreListResponse =
      FavouriteStoreResponse();

  RxList<FavouriteStore> favouriteStore = <FavouriteStore>[].obs;
  RxList<PreviousStore> previousStore = <PreviousStore>[].obs;
  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  late CartListResponse cartListResponse = CartListResponse();
  RxList<CartItem> cartItems = <CartItem>[].obs;

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();
  RxList<UserAddresses> userAddress = <UserAddresses>[].obs;
  Rx<UserAddresses> selectedUserAddress = UserAddresses().obs;

  ActiveCartModel activeCartModel = ActiveCartModel();
  RxBool autoValidate = false.obs;
  var kGoogleApiKey = "";
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? role = "".obs;
  RxString openingTime = "".obs;
  RxString closingTime = "".obs;
  RxString placeId = "".obs;
  RxString city = "".obs;
  RxString state = "".obs;
  RxString country = "".obs;
  RxInt selectedIndex = 0.obs;
  RxString storeDeliveryServiceId = "0".obs;
  RxString userAddressId = "0".obs;
  RxInt page = 1.obs;
  RxInt initialIndex = 0.obs;

  RxInt pageId = 0.obs;
  RxString storeId = "".obs;

  RxBool isLoading = false.obs;
  RxBool isFavLoading = false.obs;
  RxString isOpenNow = "".obs;

  RxBool isDataLoading = false.obs;
  RxBool isClicked = false.obs;
  RxInt type = 0.obs;
  final scrollController = ScrollController();
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  RxInt cartCount = 0.obs;
  RxDouble walletBalance = 0.0.obs;
  RxString storeAddressId = "".obs;
  RxBool isValidAddress = false.obs;
  RxBool isOrderDeliverable = false.obs;
  RxString storeIdValue = "".obs;
  Rx<StoreAddress> storeAddress = StoreAddress().obs;
  RxList<dynamic> deliveryServicesList = <dynamic>[].obs;
  RxList<Categories> deliveryServices = [
    Categories(id: 1, name: "In store", isSelected: false),
    Categories(id: 2, name: "Delivery", isSelected: false),
    Categories(id: 3, name: "Curb side", isSelected: false),
  ].obs;

  void setupScrollController() {
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
    getPage();
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = roleApp.value;
    role?.value = roleVal;
    searchController.clear();
    page.value = 1;
    if (roleApp.value == Role.customerRoleText) {
      setupScrollController();
      apiActiveCartApi();
    }
  }

  ///Get Active Cart Api
  Future apiActiveCartApi() async {
    isLoading.value = true;
    debugPrint(
        "ACTIVE CART URL ********** ${ServerCommunicator().baseUrl}${ServerCommunicator().shopCartActive}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopCartActive}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("ACTIVE CART RESPONSE*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
        debugPrint(
            "ACTIVE CART cartCount*******${activeCartModel.data!.cartItems!.isEmpty}");
        debugPrint(
            "ACTIVE CART storeId*******${int.parse(activeCartModel.data!.storeId.toString()) == 0}");
        debugPrint(
            "ACTIVE CART storeId* check******${int.parse(activeCartModel.data!.storeId.toString()) == 0 && activeCartModel.data!.cartItems!.isEmpty}");
        if (int.parse(activeCartModel.data!.storeId.toString()) == 0 &&
            activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = 0;
        } else {
          isValidAddress.value = activeCartModel.data!.isValidAddress!;
          isOrderDeliverable.value = activeCartModel.data!.isOrderDeliverable!;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
          await apiGetCartListApi(
              storeId: activeCartModel.data!.storeId.toString());
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Cart List Api
  Future apiGetCartListApi({String storeId = ""}) async {
    isLoading.value = true;
    debugPrint(
        "GET CART LIST STORE DELIVERY SERVICE ID********** ${storeDeliveryServiceId.value.toString() == "0"}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            storeDeliveryServiceId.value.toString() == "0" &&
                    selectedUserAddress.value.userAddressId == null
                ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId"
                : storeDeliveryServiceId.value.toString() != "0" &&
                        selectedUserAddress.value.userAddressId == null
                    ? "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}"
                    : "${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CART LIST RESPONSE  123*******${value?.body}");
      debugPrint(
          "GET CART LIST URL 1*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId");
      debugPrint(
          "GET CART LIST URL 2*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}");
      debugPrint(
          "GET CART LIST URL 3*******${ServerCommunicator().baseUrl}${ServerCommunicator().cartList}?store_id=$storeId&store_delivery_service_id=${storeDeliveryServiceId.value.toString()}&user_address_id=${selectedUserAddress.value.userAddressId.toString()}");

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        cartListResponse = CartListResponse.fromJson(value?.body);
        cartItems.value = cartListResponse.data?.cartItems ?? [];
        cartCount.value = cartListResponse.data?.cartItems?.length ?? 0;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get User Wallet Balance Api
  Future apiGetUserWalletBalance() async {
    isLoading.value = true;
    debugPrint("User Wallet Balance URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("USER WALLET BALANCE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        if (value!.body["data"]["balance"] is int ||
            value.body["data"]["balance"] is String) {
          walletBalance.value =
              double.parse(value.body["data"]["balance"].toString());
          debugPrint("USER WALLET BALANCE *******${walletBalance.value}");
        } else if (value.body["data"]["balance"] is double) {
          walletBalance.value = value.body["data"]["balance"];
          debugPrint("USER WALLET BALANCE *******${walletBalance.value}");
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Alert
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
            Form(
              key: formKey,
              child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(40),
                  ],
                  validator: (v) {
                    if (v!.isEmpty) {
                      return AlertStringConstants.pleaseEnterEinText;
                    }
                    return null;
                  },
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
            ),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    validateAndSubmit(storeId: storeId);
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

  ///Get Nearby Stores Api
  Future apiGetNearByStores({
    bool isFilter = false,
    bool isSearch = false,
  }) async {
    isClicked.value = true;
    debugPrint("GET GET NEARBY STORES isSearch********** $isSearch");

    if (isFilter || isSearch) {
      page.value = 1;
      storeAddresses.clear();
    }
    isDataLoading.value = true;
    nearbyStoreListResponse = NearbyStoreListResponse();
    isLoading.value = storeAddresses.isNotEmpty ? true : false;
    debugPrint("GET GET NEARBY STORES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().nearByStoreList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };

    Map data = {
      "q": "",
      "page": page.value,
      "page_size": 5,
      "longitude": zipCodeTextController.text != "" || isFilter ? null : lng,
      "latitude": zipCodeTextController.text != "" || isFilter ? null : lat,
      "city": city.value,
      "place_id": placeId.value,
      "state": state.value,
      "country": country.value,
      "postal_code":
          zipCodeTextController.text != "" ? zipCodeTextController.text : null,
      "mileage": mileageTextController.text != ""
          ? int.parse(mileageTextController.text)
          : 500,
      "is_open_now": isOpenNow.value == ""
          ? null
          : isOpenNow.value == "Open Now"
              ? true
              : false,
      "opening_time": openingTimeTextController.text != ""
          ? Utility.formatDateTime(openingTimeTextController.text,
              firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      "closing_time": closingTimeTextController.text != ""
          ? Utility.formatDateTime(closingTimeTextController.text,
              firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      "is_favourite_store": type.value == 2 ? true : null,
      "show_previous_stores": type.value == 1 ? true : null,
      "delivery_services": deliveryServicesList
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("GET NEARBY STORES BODY*******$data");
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
      log("GET NEARBY STORES *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isClicked.value = false;
        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        List<StoreAddress>? storeAddressesNewList = [];
        storeAddressesNewList = nearbyStoreListResponse.data!.storeAddresses;
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            storeAddresses.value = [];
          }
          storeAddresses.addAll(storeAddressesNewList);
          for (var element in storeAddresses) {
            if (element.store?.isFavouriteStore == true) {}
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
          deliveryServicesController.clear();
          isOpenNow.value = "";
          deliveryServicesList.clear();
          initialIndex.value = 0;
          for (var element in deliveryServices) {
            element.isSelected = false;
          }

          Get.back(id: pageIdApp.value);
        }
        if (isSearch) {
          zipCodeTextController.clear();
          openingTimeTextController.clear();
          closingTimeTextController.clear();
          mileageTextController.clear();
          isOpenNow.value = "";
          initialIndex.value = 0;
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isClicked.value = false;
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        isClicked.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Previous Stores Api
  Future apiGetPreviousStores({
    bool isFilter = false,
  }) async {
    isClicked.value = true;
    isDataLoading.value = true;
    previousStoreListResponse = PreviousStoreResponse();
    isLoading.value = previousStore.isNotEmpty ? true : false;
    debugPrint("GET GET PREVIOUS STORES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().previousStoreList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().previousStoreList}?page=${page.value.toString()}&page_size=5",
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      isLoading.value = false;
      isFavLoading.value = false;
      isDataLoading.value = false;
      debugPrint("GET PREVIOUS STORES *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isClicked.value = false;
        previousStoreListResponse = PreviousStoreResponse.fromJson(value?.body);
        List<PreviousStore>? storeAddressesNewList = [];
        storeAddressesNewList = previousStoreListResponse.data!.previousStores;
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            previousStore.value = [];
          }
          previousStore.addAll(storeAddressesNewList);
          for (var element in storeAddresses) {
            if (element.store?.isFavouriteStore == true) {}
          }
        }
        previousStore.toSet().toList();
        page.value++;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isClicked.value = false;
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        isClicked.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Favorite Stores Api
  Future apiGetFavoriteStores({
    bool isFilter = false,
  }) async {
    isClicked.value = true;
    isDataLoading.value = true;
    favouriteStoreListResponse = FavouriteStoreResponse();
    isLoading.value = favouriteStore.isNotEmpty ? true : false;
    debugPrint("GET GET FAVOURITE STORES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().favouriteStoreList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().favouriteStoreList}?page=${page.value.toString()}&page_size=5",
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      isLoading.value = false;
      isFavLoading.value = false;
      isDataLoading.value = false;
      debugPrint("GET FAVOURITE STORES *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        isClicked.value = false;
        favouriteStoreListResponse =
            FavouriteStoreResponse.fromJson(value?.body);
        List<FavouriteStore>? storeAddressesNewList = [];
        storeAddressesNewList =
            favouriteStoreListResponse.data!.favouriteStores;
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            favouriteStore.value = [];
          }
          favouriteStore.addAll(storeAddressesNewList);
          for (var element in storeAddresses) {
            if (element.store?.isFavouriteStore == true) {}
          }
        }
        favouriteStore.toSet().toList();
        page.value++;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isClicked.value = false;
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        isClicked.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
          favouriteStore.clear();
          page.value = 1;
          apiGetFavoriteStores();
        } else if (type.value == 0) {
          debugPrint("Create Favourite Store *******${type.value}");
          debugPrint("Create Favourite Store *******${type.value}");
          storeAddresses.clear();
          page.value = 1;
          apiGetNearByStores();
        } else if (type.value == 1) {
          previousStore.clear();
          page.value = 1;
          apiGetPreviousStores();
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
          favouriteStore.clear();
          page.value = 1;
          apiGetFavoriteStores();
        } else if (type.value == 0) {
          storeAddresses.clear();
          page.value = 1;
          apiGetNearByStores();
        } else if (type.value == 1) {
          previousStore.clear();
          page.value = 1;
          apiGetPreviousStores();
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
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

  void validateAndSubmit({
    String storeId = "",
  }) async {
    if (validateAndSave()) {
      try {
        await apiClaimStore(storeId: storeId);
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  apiClaimStore({
    String storeId = "",
  }) async {
    debugPrint("CLAIM STORE API URL **********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().claimStoreRequest}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        einNumberTextController.clear();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
