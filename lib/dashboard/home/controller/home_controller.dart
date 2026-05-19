
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
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
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Skip API calls for guest users
      if (isGuest.value == true) {
        return;
      }
      await apiGetUserDetail();
      if (roleApp.value == Role.customerRoleText) {
        await apiActiveCartApi();
      }
    });
  }

  getCurrentLocation() async {
    try {
      // Check if user is 0000000000, use Nashville, Tennessee coordinates
      if (currentUserPhone!.value == "0000000000") {
        lat = 36.1627; // Nashville, Tennessee latitude
        lng = -86.7816; // Nashville, Tennessee longitude
      } else {
        Position currentLocation = await Utility.fetchCurrentLocation();
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      }

      if (roleApp.value == Role.customerRoleText) {
        await apiGetUserOffersList();
        await apiGetUserFeaturedProducts();

        await apiActiveCartApi();
      } else {
        await apiGetOwnerOffersList();
        await apiGetOwnerFeaturedProducts();
      }
    } catch (e) {
      // Handle denied permission
      Utility.showToast('Please enable location permission in settings.');
    } finally {
      isLoading.value = false; // Stop loader in any case
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
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    isLoading.value = true;
         Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi("${ServerCommunicator.baseUrl}${ServerCommunicator.shopCartActive}", headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        activeCartModel = ActiveCartModel.fromJson(value?.body);
        if (int.parse(activeCartModel.data!.storeId.toString()) == 0 &&
            activeCartModel.data!.cartItems!.isEmpty) {
          cartCount.value = 0;
        } else {
          storeIdValue?.value = activeCartModel.data!.storeId.toString();
          cartCount.value = activeCartModel.data!.cartItems!.length;
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        isLoading.value = false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    }).catchError((error, stackTrace) {
      isLoading.value = false;
    });
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
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.userDetail,
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        email!.value = getUserDetailModel.data?.user?.email ?? "";
        currentUserId!.value = getUserDetailModel.data?.user?.userId ?? "";
        currentUserPhone!.value = getUserDetailModel.data?.user?.phone ?? "";
        SharedPreferenceStorage
            .setData("userData", getUserDetailModel.data);
        SharedPreferenceStorage.setData(StringConstants.firstNameText,
            getUserDetailModel.data?.user?.firstName ?? "");
        SharedPreferenceStorage.setData(
            StringConstants.lastNameText, lastName.value);
        SharedPreferenceStorage.setData(
            StringConstants.emailText, email!.value);
        SharedPreferenceStorage.setData(
            StringConstants.currentUserIdText, currentUserId!.value);
        SharedPreferenceStorage.setData("userPhone", currentUserPhone!.value);
        firstName.value = getUserDetailModel.data?.user?.firstName ?? "";
        lastName.value = getUserDetailModel.data?.user?.lastName ?? "";

        await getCurrentLocation();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      }
    });
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
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    userCarouselImgList.clear();
    userOfferList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreHomeOffers}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userOffersModel = GetUserOfferModel.fromJson(value?.body);
        userOfferList.value = userOffersModel.data!.offers!;
        for (int i = 0; i < userOfferList.length; i++) {
          storeId!.value = userOfferList[i].storeId.toString();
          if (i >= 5) {
            return;
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
    });
  }

  ///Feature ProductList Store Api [USER OLD]
  Future apiGetUserFeaturedProductsOLD() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
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
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    featuredUserProductList.clear();
    isLoading.value = true;
    String url =
        "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreHomeProducts}?longitude=${lng.toString()}&latitude=${lat.toString()}&mileage=1000&page=1&page_size=5";
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
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
        .getWithHeadersApi(url, headers, showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data?.products ??[]; isLoading.value = false;
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

  ///Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    getOwnerOfferList.clear();
    isLoading.value = true;
    ownerCarouselImgList.clear();
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         Map body = {
      "store_id": null,
      "page": 1,
      "page_size": 3,
      "order_by": "offer_name",
      "order_type": "DESC",
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl + ServerCommunicator.storeOfferList,
            headers,
            showLoading: false)
        .then((value) async {

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
        }    isLoading.value = false;
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
    });
  }

  ///Feature ProductList Store Api [Owner]
  Future apiGetOwnerFeaturedProducts() async {
    // Skip API call for guest users
    if (isGuest.value == true) {
      return;
    }
    ownerFeatureProductList.clear();
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
     
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
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeProductList,
            headers,
            showLoading: false)
        .then((value) async {

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
        Get.parameters.clear();isLoading.value = false;
        Utility.handle401Error();
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
