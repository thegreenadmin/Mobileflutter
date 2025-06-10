import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/main.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class SearchStoreUserController extends GetxController with GlobalVarMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController storeOpeningTextController = TextEditingController();
  TextEditingController openingTimeTextController = TextEditingController();
  TextEditingController closingTimeTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController deliveryServicesController = TextEditingController();
  TextEditingController einNumberTextController = TextEditingController();
  late NearbyStoreListResponse nearbyStoreListResponse = NearbyStoreListResponse();
  late PreviousStoreResponse previousStoreListResponse = PreviousStoreResponse();
  late FavouriteStoreResponse favouriteStoreListResponse = FavouriteStoreResponse();
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  RxList<StoreDetails> favouriteStore = <StoreDetails>[].obs;
  RxList<StoreDetails> previousStore = <StoreDetails>[].obs;
  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  late CartListResponse cartListResponse = CartListResponse();
  RxList<CartItems> cartItems = <CartItems>[].obs;

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
  RxInt totalCount = 0.obs;
  RxInt initialIndex = 0.obs;

  RxInt pageId = 0.obs;
  RxString storeId = "".obs;
  RxString miles = "50".obs;

  RxBool isLoading = false.obs;
  RxBool isFavLoading = false.obs;
  RxString isOpenNow = "".obs;

  RxBool isDataLoading = false.obs;
  RxBool isClicked = false.obs;
  RxBool isFilter = false.obs;
  RxBool isSearch = false.obs;
  RxInt type = 0.obs;
  final nearByStoresScrollController = ScrollController();
  final previousStoresScrollController = ScrollController();
  final favouriteStoresScrollController = ScrollController();

  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;
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


   setupNearByStoresScrollController() {
    nearByStoresScrollController.addListener(() {
      if (nearByStoresScrollController.position.pixels >=
          nearByStoresScrollController.position.maxScrollExtent - 50) {

        // Check if there's more data to load and not currently loading
        bool hasMore = storeAddresses.length < totalCount.value;
        bool canLoad = !isClicked.value;
        int maxPage = (totalCount.value / 5).ceil();

        log("page.value scroll position: ${storeAddresses.length} ${totalCount.value} ${isLoading.value} ${page.value}");
        log("📦 Scroll Check: Loaded=${storeAddresses.length}, Total=${totalCount.value}, Page=${page.value}");

        if (hasMore && canLoad) {
          if (page.value >= maxPage) {
            log("🚫 Max page reached. No more data to fetch.");
            return;
          }
          isClicked.value = true; // PREVENT DOUBLE API CALLS!
          page.value++;
          log("page.value scroll position: ${page.value}");

          apiGetNearByStores();
        }
      }
    });
  }

  void setupPreviousStoresScrollController() {
    previousStoresScrollController.addListener(() {
      if (previousStoresScrollController.position.pixels >=
          previousStoresScrollController.position.maxScrollExtent - 10) {
        if (previousStore.length < totalCount.value && !isLoading.value) {
          page.value++;
          apiGetPreviousStores();
        }
      }
    });
  }

  void setupFavoriteStoresScrollController() {
    favouriteStoresScrollController.addListener(() {
      log("Favorite scroll position: ${favouriteStoresScrollController.position.pixels}");
      if (favouriteStoresScrollController.position.pixels >=
          favouriteStoresScrollController.position.maxScrollExtent - 10) {
        if (favouriteStore.length < totalCount.value && !isLoading.value) {
          page.value++;
          apiGetFavoriteStores();
        }
      }
    });
  }


  Rx<permission.PermissionStatus> permissionStatus = permission.PermissionStatus.denied.obs;

  Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    // zoom: 14.4746,
    zoom: 50.4746,
  );
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    setupNearByStoresScrollController();
    setupPreviousStoresScrollController();
    setupFavoriteStoresScrollController();
    _listenForPermissionStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {


      getPage();
      log("🧪 type value onInit: ${type.value}");

    });
  }

  void updateMap(latitude, longitude, {isSearchVal = false}) async {
    CameraPosition kLake =
        CameraPosition(bearing: 192.8334901395799, target: LatLng(latitude, longitude), tilt: 0.0, zoom: 14.15);
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
    lat.value = latitude;
    lng.value = longitude;
    type.value = 0;
    if (!isSearchVal) {
      // placeId.value = "";
    }
    await apiGetNearByStores(isSearch: isSearchVal);
    updateMarker(lat.value, lng.value);
  }

  void updateMarker(latitude, longitude) async {
    const MarkerId markerId = MarkerId("12345");
    final Uint8List markerIcon = await getBytesFromAsset(ImageConstants.marker, 20);
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.bytes(markerIcon),
      position: LatLng(latitude, longitude),
    );
    markers[markerId] = marker;
  }

  late GlobalConfigs secureData;

  void updateCurrentLocation() async {
    // secureData = await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    // kGoogleApiKey = secureData.configs['kGoogleApiKey'];

    print("updateCurrentLocation-----------------");

    kGoogleApiKey = ServerCommunicator.kGoogleApiKey;
    print("updateCurrentLocation-----------------");

    Position currentLocation = await Utility.fetchCurrentLocation();
    print("updateCurrentLocation-----------------");
    print(currentLocation.latitude);
    print(currentLocation.longitude);
    print("updateCurrentLocation-----------------");

    updateMap(currentLocation.latitude, currentLocation.longitude);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _listenForPermissionStatus() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var status = await permission.Permission.location.request();
      permissionStatus.value = status;
      if (permissionStatus.value == permission.PermissionStatus.denied ||
          permissionStatus.value == permission.PermissionStatus.permanentlyDenied) {
        Utility.showConfirmAlertMessage(AlertStringConstants.alertText,
            description: Platform.isAndroid
                ? AlertStringConstants.locationAndroidAlertText
                : AlertStringConstants.locationAlertText,
            okay: StringConstants.settingsText,
            cancelText: StringConstants.notNowText, okayTap: () async {
          await permission.openAppSettings();
          await permission.Permission.location.request();
          await getPage();
          if (roleApp.value == Role.customerRoleText) {
            switch (type.value) {
              case 0:
                setupNearByStoresScrollController();
                break;
              case 1:
                setupPreviousStoresScrollController();
                break;
              case 2:
                setupFavoriteStoresScrollController();
                break;
            }

            apiActiveCartApi();
          }
          Get.back();
        });
      }
    });
  }

  getPage() async {
    firstName?.value = await SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
    lastName?.value = await SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
    searchController.clear();


  }

  ///Get Active Cart Api
  Future apiActiveCartApi() async {
    isLoading.value = true;
         Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi("${ServerCommunicator.baseUrl}${ServerCommunicator.shopCartActive}", headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
                          cartCount.value = activeCartModel.data!.cartItems!.length;
        // cartItems.value = activeCartModel.data!.cartItems??[];
        if (int.parse(activeCartModel.data!.storeId.toString()) == 0 && activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = 0;
        } else {
          isValidAddress.value = activeCartModel.data!.isValidAddress!;
          isOrderDeliverable.value = activeCartModel.data!.isOrderDeliverable!;
          storeIdValue.value = activeCartModel.data!.storeId.toString();
        }
        isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        isLoading.value = false;
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
               isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get User Wallet Balance Api
  Future apiGetUserWalletBalance() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi("${ServerCommunicator.baseUrl}${ServerCommunicator.userWalletBalance}", headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        if (value?.body["data"]["balance"] is int || value?.body["data"]["balance"] is String) {
          walletBalance.value = double.parse(value?.body["data"]["balance"].toString() ?? "");
                   } else if (value?.body["data"]["balance"] is double) {
          walletBalance.value = value?.body["data"]["balance"];
                   }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
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
              style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.w600),
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
                  style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w400),
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
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.white),
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

  clearNearbyPArms() {
    page.value = 1;
    city.value = "";
    country.value = "";
    state.value = "";
    placeId.value = "";

    zipCodeTextController.clear();
    miles.value = '50';
    type.value = 0;
    openingTimeTextController.clear();
    closingTimeTextController.clear();
    mileageTextController.clear();
    deliveryServicesController.clear();
    isOpenNow.value = "";
    deliveryServicesList.clear();
    // updateCurrentLocation();
  }

  ///Get Nearby Stores Api Old working scenario
  Future apiGetNearByStores({
    bool isFilter = false,
    bool isSearch = false,
  }) async
  {

    isClicked.value = true;

    if (isFilter || isSearch || page.value == 1) {
      page.value = 1 ;
      storeAddresses.clear();
      isLoading.value =  true ;
    }
     if (isFilter || isSearch || page.value > 1) {
       isDataLoading.value = true;
    }
    nearbyStoreListResponse = NearbyStoreListResponse();
    if ((zipCodeTextController.text == "" && (lng.value == 0.0 || lat.value == 0.0))) {
      Utility.showAlertMessage("Location or postal code is required.");
      return;
    }
/*
     if(zipCodeTextController.text == "" || (lng.value ==0.0 && lat.value == 0.0)){
       Utility.showAlertMessage("Location permissions are permanently denied, we cannot request permissions.");
     }*/

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {
      "q": "",
      "page": page.value,
      "page_size": 5,
      "longitude": zipCodeTextController.text != ""  ? null : lng.value,
      "latitude": zipCodeTextController.text != ""  ? null : lat.value,
      "city":  city.value,
      "place_id":  placeId.value,
      "state":  state.value,
      "country":  country.value,
      "postal_code":  zipCodeTextController.text != "" ? zipCodeTextController.text : null,
      "mileage": miles.value,
      "is_open_now": isOpenNow.value == ""
          ? null
          : isOpenNow.value == "Open Now"
              ? true
              : false,
      "opening_time": openingTimeTextController.text != ""
          ? Utility.formatDateTime(openingTimeTextController.text, firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      "closing_time": closingTimeTextController.text != ""
          ? Utility.formatDateTime(closingTimeTextController.text, firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      // "is_favourite_store": type.value == 2 ? true : null,
      // "show_previous_stores": type.value == 1 ? true : null,
      "delivery_services": deliveryServicesList
    };


    /*  Map data = {
      "q": "",
      "page": page.value,
      "page_size": 5,
      // "longitude": zipCodeTextController.text != "" || isFilter ? null : lng.value,
      // "latitude": zipCodeTextController.text != "" || isFilter ? null : lat.value,
      "longitude": zipCodeTextController.text != "" || isFilter ? null : lng.value,
      "latitude": zipCodeTextController.text != "" || isFilter ? null : lat.value,
      "city": isFilter && !isSearch ? "" : city.value,
      "place_id": isFilter && !isSearch? "" : placeId.value,
      "state": isFilter && !isSearch ? "" : state.value,
      "country": isFilter && !isSearch ? "" : country.value,
      "postal_code": !isSearch  && zipCodeTextController.text != "" ? zipCodeTextController.text : null,
      "mileage": miles.value,
      "is_open_now": isOpenNow.value == ""
          ? null
          : isOpenNow.value == "Open Now"
              ? true
              : false,
      "opening_time": openingTimeTextController.text != ""
          ? Utility.formatDateTime(openingTimeTextController.text, firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      "closing_time": closingTimeTextController.text != ""
          ? Utility.formatDateTime(closingTimeTextController.text, firstFormat: "hh:mm a", secFormat: "HH:mm:ss")
          : null,
      "is_favourite_store": type.value == 2 ? true : null,
      "show_previous_stores": type.value == 1 ? true : null,
      "delivery_services": isFilter ? [] : deliveryServicesList
    };*/

    UserProvider()
        .postWithHeadersApi(data, ServerCommunicator.baseUrl + ServerCommunicator.nearByStoreList, headers,
            showLoading: false)
        .then((value) async {


              if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {

        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        totalCount.value = nearbyStoreListResponse.data?.totalCount ?? 0;
        List<StoreAddress>? storeAddressesNewList = [];
        storeAddressesNewList = nearbyStoreListResponse.data!.storeAddresses?.where((s) => s.store?.isVerified == true).toList();

        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            storeAddresses.value = [];
          }
          // storeAddresses.addAll(storeAddressesNewList);
        }
        // storeAddresses.value = storeAddresses.toSet().toList();

        for (var newStore in storeAddressesNewList) {
          if (!storeAddresses.any((existing) => existing.store?.storeId == newStore.store?.storeId)) {
            storeAddresses.add(newStore);
          }
        }

        isClicked.value = false;
        isLoading.value = false;
        isFavLoading.value = false;
        isDataLoading.value = false;
        if (totalCount.value > 0 && storeAddresses.length
            >= totalCount.value) {
          // clearNearbyPArms();
        }

        if (isFilter) {
          if (totalCount.value > 0 && storeAddresses.length
              >= totalCount.value) {
            // clearNearbyPArms();
            initialIndex.value = 0;
            for (var element in deliveryServices) {
              element.isSelected = false;
            }
          }
          update();
          Get.back(id: pageIdApp.value);
        }

        if (totalCount.value > 0 && isSearch && storeAddresses.length >= totalCount.value) {
          // clearNearbyPArms();
          initialIndex.value = 0;
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
                isClicked.value = false;
                isLoading.value = false;
                isFavLoading.value = false;
                isDataLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
                isClicked.value = false;
                isLoading.value = false;
                isFavLoading.value = false;
                isDataLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }






  ///Get Previous Stores Api
  Future apiGetPreviousStores({
    bool isFilter = false,
  }) async
  {
    isClicked.value = true;
    isDataLoading.value = true;
    if (page.value == 1) {
      previousStore.clear();
      isLoading.value =  true ;
    }
    if (page.value > 1) {
      isDataLoading.value = true;
    }
    previousStoreListResponse = PreviousStoreResponse();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.previousStoreList}?page=${page.value.toString()}&page_size=5",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      isFavLoading.value = false;
      isDataLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        isClicked.value = false;
        previousStoreListResponse = PreviousStoreResponse.fromJson(value?.body);
        totalCount.value = previousStoreListResponse.data?.totalCount ?? 0;
        List<StoreDetails>? storeAddressesNewList = [];
        storeAddressesNewList =
            previousStoreListResponse.data!.previousStores?.where((s) => s.isVerified == true).toList();
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            previousStore.value = [];
          }
          previousStore.addAll(storeAddressesNewList);
        }
        previousStore.toSet().toList();
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isClicked.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
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
    if (page.value == 1) {
      favouriteStore.clear();
      isLoading.value =  true ;
    }
    if ( page.value > 1) {
      isDataLoading.value = true;
    }

    favouriteStoreListResponse = FavouriteStoreResponse();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.favouriteStoreList}?page=${page.value.toString()}&page_size=5",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      isFavLoading.value = false;
      isDataLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        isClicked.value = false;
        favouriteStoreListResponse = FavouriteStoreResponse.fromJson(value?.body);
        totalCount.value = favouriteStoreListResponse.data?.totalCount ?? 0;
        List<StoreDetails>? storeAddressesNewList = [];
        storeAddressesNewList =
            favouriteStoreListResponse.data!.favouriteStores?.where((s) => s.isVerified == true).toList();
        if (storeAddressesNewList!.isNotEmpty) {
          if (page.value == 1) {
            favouriteStore.value = [];
          }
          favouriteStore.addAll(storeAddressesNewList);
        }
        favouriteStore.toSet().toList();
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        isClicked.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
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
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

         UserProvider()
        .postWithHeadersApi(data, ServerCommunicator.baseUrl + ServerCommunicator.createFavouriteStore, headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        if (type.value == 2) {
          favouriteStore.clear();
          page.value = 1;
          apiGetFavoriteStores();
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (type.value == 2) {
          favouriteStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = false;
        } else if (type.value == 0) {
          storeAddresses.where((p0) => p0.store!.storeId == id).first.store?.isFavouriteStore?.value = false;
        } else if (type.value == 1) {
          previousStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = false;
        }

        Utility.showAlertMessage(value?.body['message']);

        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (type.value == 2) {
          favouriteStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = false;
        } else if (type.value == 0) {
          storeAddresses.where((p0) => p0.store!.storeId == id).first.store?.isFavouriteStore?.value = false;
        } else if (type.value == 1) {
          previousStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = false;
        }
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

              UserProvider()
        .deleteWithHeadersApi(data, ServerCommunicator.baseUrl + ServerCommunicator.removeFavouriteStore, headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        if (type.value == 2) {
          favouriteStore.clear();
          page.value = 1;
          apiGetFavoriteStores();
        } /* else if (type.value == 0) {
          storeAddresses.clear();
          page.value = 1;
          placeId.value = "";
          apiGetNearByStores();
        } else if (type.value == 1) {
          previousStore.clear();
          page.value = 1;
          apiGetPreviousStores();
        }*/
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        if (type.value == 2) {
          favouriteStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = true;
        } else if (type.value == 0) {
          storeAddresses.where((p0) => p0.store!.storeId == id).first.store?.isFavouriteStore?.value = true;
        } else if (type.value == 1) {
          previousStore.clear();
          previousStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = true;
        }

        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (type.value == 2) {
          favouriteStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = true;
        } else if (type.value == 0) {
          storeAddresses.where((p0) => p0.store!.storeId == id).first.store?.isFavouriteStore?.value = true;
        } else if (type.value == 1) {
          previousStore.clear();
          previousStore.where((p0) => p0.storeId == id).first.isFavouriteStore?.value = true;
        }
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
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText: "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {"store_id": int.parse(storeId), "store_ein": einNumberTextController.text.trim()};
              UserProvider()
        .postWithHeadersApi(data, ServerCommunicator.baseUrl + ServerCommunicator.claimStoreRequest, headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 || value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        einNumberTextController.clear();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  @override
  void onClose() {
    nearByStoresScrollController.dispose();
    previousStoresScrollController.dispose();
    favouriteStoresScrollController.dispose();
    super.onClose();
  }
}
