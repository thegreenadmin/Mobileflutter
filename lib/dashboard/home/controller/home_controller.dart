
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, Position;
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class HomeController extends GetxController with GlobalVarMixin {
  RxString? email = "".obs;
  RxString? productId = "".obs;
  RxString? storeId = "".obs;
  RxString? currentUserId = "".obs;
  RxString? currentUserPhone = "".obs;
  RxString? offerProductId = "".obs;
  RxString? storeIdValue = "".obs;
  RxInt pageId = 0.obs;
  RxInt cartCount = 0.obs;
  RxBool isLoading = false.obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  //Get.find<SearchStoreUserController>().onInit();

  late GetUserOfferModel userOffersModel = GetUserOfferModel();
  RxList<OffersList> userOfferList = <OffersList>[].obs;

  late OwnerFeaturedProductModel ownerFeaturedProductModel =
      OwnerFeaturedProductModel();
  RxList<ProductsList> ownerFeatureProductList = <ProductsList>[].obs;

  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  RxList<OffersList> userCarouselImgList = <OffersList>[].obs;
  RxList<String> ownerCarouselImgList = <String>[].obs;

  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferList = <OffersList>[].obs;

  UserFeaturedProductModel userFeaturedProductModel =
      UserFeaturedProductModel();
  RxList<ProductsList> featuredUserProductList = <ProductsList>[].obs;
  RxList<ProductsList> offerProductList = <ProductsList>[].obs;

  dynamic lat = 0.0;
  dynamic lng = 0.0;
  // final SearchStoreUserController searchStoreUserController =
  //     Get.put(SearchStoreUserController());
  ActiveCartModel activeCartModel = ActiveCartModel();
  bool _roleDataPending = false;
  
  @override
  void onInit() {
    super.onInit();

    // Fires only once: when user logs in from guest mode (isGuest: true → false)
    ever(isGuest, (bool guestStatus) async {
      if (!guestStatus && authToken.value.isNotEmpty) {
        await refreshUserData();
      }
    });

    // Fallback: fires when roleApp becomes available after an async SharedPrefs read
    // (race condition where _loadHomeData ran before roleApp was set from prefs).
    // _roleDataPending gates this so changes from other controllers (BottomNavController,
    // SplashScreen, OtpVerificationController) don't trigger spurious loads.
    ever(roleApp, (String role) async {
      print("DEBUG: ever(roleApp) fired - role=$role, _roleDataPending=$_roleDataPending, isGuest=${isGuest.value}, authToken empty=${authToken.value.isEmpty}");
      if (_roleDataPending && role.isNotEmpty && !isGuest.value && authToken.value.isNotEmpty) {
        print("DEBUG: ever(roleApp) conditions met, calling _loadRoleSpecificData");
        _roleDataPending = false;
        await _loadRoleSpecificData();
      }
    });

    // Refresh cart count whenever home tab becomes active (pageIdApp == 0)
    ever(pageIdApp, (int page) async {
      if (page == 0 && !isGuest.value && authToken.value.isNotEmpty) {
        await apiActiveCartApi();
      }
    });

    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    print("DEBUG: _loadHomeData starting... isGuest=${isGuest.value}, roleApp=${roleApp.value}");

    // Set location before making API calls
    await getCurrentLocation();
    print("DEBUG: _loadHomeData location loaded lat=$lat, lng=$lng");

    // Skip user-specific API calls for guest users
    if (isGuest.value == true) {
      await apiGetUserOffersList();
      await apiGetUserFeaturedProducts();
      return;
    }

    // User is authenticated (not a guest)
    await apiGetUserDetail();

    // Load role-specific data if role is already available.
    // If roleApp is still empty (SharedPrefs write race condition), the
    // ever(roleApp, ...) listener in onInit() will trigger this once role arrives.
    if (roleApp.value.isNotEmpty) {
      await _loadRoleSpecificData();
    } else {
      _roleDataPending = true;
      print("DEBUG: _loadHomeData roleApp empty, will reload via ever(roleApp) when it arrives");
    }
  }

  Future<void> _loadRoleSpecificData() async {
    print("DEBUG: _loadRoleSpecificData role=${roleApp.value}");
    if (roleApp.value == Role.customerRoleText) {
      await apiGetUserOffersList();
      await apiGetUserFeaturedProducts();
      await apiActiveCartApi();
    } else if (roleApp.value == Role.storeOwnerRoleText) {
      await apiGetOwnerOffersList();
      await apiGetOwnerFeaturedProducts();
    }
  }

  // Method to refresh user data after login
  Future<void> refreshUserData() async {
    isLoading.value = true;
    try {
      await getCurrentLocation();
      if (roleApp.value.isEmpty) {
        final roleData = await SharedPreferenceStorage.getData(Role.role) ?? "";
        if (roleData.isNotEmpty) roleApp.value = roleData;
      }
      await apiGetUserDetail();
      await _loadRoleSpecificData();

      // Refresh store details if StoreHomeMainController is registered
      if (Get.isRegistered<StoreHomeMainController>()) {
        final storeController = Get.find<StoreHomeMainController>();
        if (storeController.storeId.value.isNotEmpty && storeController.storeId.value != "0") {
          await storeController.getCurrentLocation();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  getCurrentLocation() async {
    // Nashville is the safe default — APIs start immediately without waiting for GPS.
    lat = 36.1627;
    lng = -86.7816;
    try {
      if (currentUserPhone!.value == "0000000000") {
        // Nashville already set above
      } else if (isGuest.value == true) {
        // Nashville already set above
      } else {
        Position currentLocation = await Utility.fetchCurrentLocation()
            .timeout(const Duration(seconds: 5), onTimeout: () {
          print("DEBUG: getCurrentLocation timed out, using Nashville default");
          throw Exception("Location timeout");
        });
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      }

    } catch (e) {
      // Fall back to Nashville default on any error (denied permission, timeout, etc.)
      print("DEBUG: getCurrentLocation error: $e, using Nashville default");
    }
  }


  ///Api Get offers products
   apiGetOffersProducts(
      {String storeId = "", String offerId = ""}) async {
    isLoading.value = true;
    offerProductList.clear();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
      "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {
      "q": "",
      "store_id": storeId,
      "page": 1,
      "page_size": 1000,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": null,
      "is_previous_products": null,
      "offer_id": offerId,
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
        data,
        ServerCommunicator.baseUrl +
            ServerCommunicator.storeFeatureProductList,
        headers,
        showLoading: false)
        .then((value) async {
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel = UserFeaturedProductModel.fromJson(value?.body);
        isLoading.value = false;
        offerProductId?.value = userFeaturedProductModel.data?.products?[0].productId ??"";
        offerProductList.value = userFeaturedProductModel.data?.products ??[];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else { isLoading.value = false;
      if (value?.body['message'] != null) {
        Utility.showAlertMessage(value?.body['message']);
      }

      }
    });
  }

  List<PopupMenuEntry<String>>? userTypeOptionsPopUpList(context) {
    return List.generate(2, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    // Check if user is guest - show modal for account-based features
                    if (isGuest.value == true) {
                      GuestAccessModal.show(
                        title: "Login Required",
                        message: "Please login to access account settings",
                        onContinueAsGuest: () {
                          // Allow guest to continue - just close modal
                        },
                      );
                      return;
                    }
                    
                    Get.back(id: pageIdApp.value);
                    await Get.to(() => const AccountScreen(),
                        id: int.parse(SharedPreferenceStorage.getData("pageId")
                            .toString()));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.userProfileText,
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () async {
                // Check if user is guest - show modal for account-based features
                if (isGuest.value == true) {
                  GuestAccessModal.show(
                    title: "Login Required",
                    message: "Please login to access account settings",
                    onContinueAsGuest: () {
                      // Allow guest to continue - just close modal
                    },
                  );
                  return;
                }
                
                Get.back(id: pageIdApp.value);
                await Get.to(() => const AccountScreen(),
                    id: int.parse(
                        SharedPreferenceStorage.getData("pageId").toString()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.storeProfileText,
                    style:
                        const TextStyle(color: AppColors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }


  ///Get Active Cart Api
  Future apiActiveCartApi() async {
    if (isGuest.value == true || authToken.value.isEmpty) return;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    try {
      final value = await UserProvider()
          .getWithHeadersApi("${ServerCommunicator.baseUrl}${ServerCommunicator.shopCartActive}", headers,
              showLoading: false);
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
        final int parsedStoreId = int.tryParse(activeCartModel.data?.storeId?.toString() ?? "0") ?? 0;
        if (parsedStoreId == 0 && (activeCartModel.data?.cartItems?.isEmpty ?? true)) {
          cartCount.value = 0;
        } else {
          storeIdValue?.value = activeCartModel.data!.storeId.toString();
          cartCount.value = activeCartModel.data?.cartItems?.length ?? 0;
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      }
    } catch (error) {
      // silent
    }
  }
  ///Get User Detail Info Api
  Future apiGetUserDetail() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    try {
      final value = await UserProvider().getWithHeadersApi(
          ServerCommunicator.baseUrl + ServerCommunicator.userDetail,
          headers,
          showLoading: false);
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        email!.value = getUserDetailModel.data?.user?.email ?? "";
        currentUserId!.value = getUserDetailModel.data?.user?.userId ?? "";
        currentUserPhone!.value = getUserDetailModel.data?.user?.phone ?? "";
        SharedPreferenceStorage.setData("userData", getUserDetailModel.data);
        SharedPreferenceStorage.setData(StringConstants.firstNameText,
            getUserDetailModel.data?.user?.firstName ?? "");
        SharedPreferenceStorage.setData(
            StringConstants.lastNameText, getUserDetailModel.data?.user?.lastName ?? "");
        SharedPreferenceStorage.setData(
            StringConstants.emailText, email!.value);
        SharedPreferenceStorage.setData(
            StringConstants.currentUserIdText, currentUserId!.value);
        SharedPreferenceStorage.setData("userPhone", currentUserPhone!.value);
        firstName.value = getUserDetailModel.data?.user?.firstName ?? "";
        lastName.value = getUserDetailModel.data?.user?.lastName ?? "";
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      }
    } catch (e) {
      // handle error silently
    }
  }

  ///logout user account
  Future apiLogOutUser() async {
         Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.logoutUser}",
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        clearData();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        clearData();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  clearData() async {
    storage.clearData();
    Get.parameters.clear();
    Get.offAll(() => const LoginScreen());
  }

  ///Get Nearby Stores Api [USER]
  Future apiGetUserOffersList() async {
    userCarouselImgList.clear();
    userOfferList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header if token exists (not for guests)
    if (authToken.value != null && authToken.value!.isNotEmpty) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }

    try {
      final value = await UserProvider()
          .getWithHeadersApi(
              "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreHomeOffers}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
              headers,
              showLoading: false);

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userOffersModel = GetUserOfferModel.fromJson(value?.body);
        if (userOffersModel.data?.offers != null) {
          userOfferList.value = userOffersModel.data!.offers!;
        } else {
          final List<OffersList> extractedOffers = [];
          final storesJson = value?.body["data"]?["stores"];
          if (storesJson != null && storesJson is List) {
            for (var storeJson in storesJson) {
              final offersJson = storeJson["offers"];
              if (offersJson != null && offersJson is List) {
                for (var offerJson in offersJson) {
                  if (offerJson["store"] == null && storeJson != null) {
                    offerJson["store"] = storeJson;
                  }
                  extractedOffers.add(OffersList.fromJson(offerJson));
                }
              }
            }
          }
          userOfferList.value = extractedOffers;
        }

        for (int i = 0; i < userOfferList.length; i++) {
          storeId!.value = userOfferList[i].storeId.toString();
          if (i >= 5) {
            break;
          }
          userCarouselImgList.add(userOfferList[i]);
        }
        isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();  isLoading.value = false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {  isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    } catch (e, stackTrace) {
      print("ERROR: apiGetUserOffersList failed: $e\n$stackTrace");
      isLoading.value = false;
    }
  }

  ///Feature ProductList Store Api [USER OLD]
  Future apiGetUserFeaturedProductsOLD() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header if token exists (not for guests)
    if (authToken.value != null && authToken.value!.isNotEmpty) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }
    Map data = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 3,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": false,
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

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;  isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();  isLoading.value = false;
        Utility.handle401Error();
      } else {  isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Feature ProductList Store Api [USER NEW]
  Future apiGetUserFeaturedProducts() async {
    featuredUserProductList.clear();
    isLoading.value = true;
    String url =
        "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreHomeProducts}?longitude=${lng.toString()}&latitude=${lat.toString()}&mileage=1000&page=1&page_size=5";
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header if token exists (not for guests)
    if (authToken.value != null && authToken.value!.isNotEmpty) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }
    Map data = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 3,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": false,
      "filters": [
        {
          "filter_by": "is_featured_product",
          "filter_value": true,
          "operation": "eq"
        }
      ]
    };

    try {
      final value = await UserProvider()
          .getWithHeadersApi(url, headers, showLoading: false);

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data?.products ?? [];
        isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else { isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    } catch (e, stackTrace) {
      print("ERROR: apiGetUserFeaturedProducts failed: $e\n$stackTrace");
      isLoading.value = false;
    }
  }

  ///Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    getOwnerOfferList.clear();
    isLoading.value = true;
    ownerCarouselImgList.clear();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header if token exists (not for guests)
    if (authToken.value != null && authToken.value!.isNotEmpty) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }
         Map body = {
      "store_id": null,
      "page": 1,
      "page_size": 3,
      "order_by": "offer_name",
      "order_type": "DESC",
      "filters": []
    };
    try {
      final value = await UserProvider()
          .postWithHeadersApi(
              body,
              ServerCommunicator.baseUrl + ServerCommunicator.storeOfferList,
              headers,
              showLoading: false);

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getOwnerOffersListModel = GetOwnerOffersListModel.fromJson(value?.body);
        getOwnerOfferList.value = getOwnerOffersListModel.data!.offers!;
        if (getOwnerOfferList.isNotEmpty) {
          for (int i = 0; i < getOwnerOfferList.length; i++) {
            if (i >= 5) {
              break;
            }
            ownerCarouselImgList.add(getOwnerOfferList[i].image!.dynamicUrl!);
          }
        }
        isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        isLoading.value = false;
        Utility.handle401Error();
      } else {
        isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    } catch (error, stackTrace) {
      print("ERROR: apiGetOwnerOffersList failed: $error\n$stackTrace");
      isLoading.value = false;
    }
  }

  ///Feature ProductList Store Api [Owner]
  Future apiGetOwnerFeaturedProducts() async {
    ownerFeatureProductList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Only include authorization header if token exists (not for guests)
    if (authToken.value != null && authToken.value!.isNotEmpty) {
      headers[StringConstants.authorizationText] =
          "${StringConstants.bearerText} ${authToken.value}";
    }
     
    Map<String, dynamic> body = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 3,
      "order_by": "product_id",
      "order_type": "ASC",
      "category_id": null,
      "filters": [
        {
          "filter_by": "is_featured_product",
          "filter_value": true,
          "operation": "eq"
        }
      ]
    };
    try {
      final value = await UserProvider()
          .postWithHeadersApi(
              body,
              ServerCommunicator.baseUrl +
                  ServerCommunicator.storeProductList,
              headers,
              showLoading: false);

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        ownerFeaturedProductModel =
            OwnerFeaturedProductModel.fromJson(value?.body);
        ownerFeatureProductList.value =
            ownerFeaturedProductModel.data?.products ?? [];
        isLoading.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else { isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    } catch (e, stackTrace) {
      print("ERROR: apiGetOwnerFeaturedProducts failed: $e\n$stackTrace");
      isLoading.value = false;
    }
  }
}
