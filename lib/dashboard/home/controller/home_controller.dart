import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
import 'package:thegreenmall/dashboard/offers/model/get_owner_offers_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class HomeController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? email = "".obs;
  RxString? productId = "".obs;
  RxString? storeId = "".obs;
  RxString? currentUserId = "".obs;
  RxInt pageId = 0.obs;
  RxBool? isLoading = false.obs;

  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  //Get.find<SearchStoreUserController>().onInit();

  late GetUserOfferModel userOffersModel = GetUserOfferModel();
  RxList<UserOffers> userOfferList = <UserOffers>[].obs;

  late OwnerFeaturedProductModel ownerFeaturedProductModel =
      OwnerFeaturedProductModel();
  RxList<ProductsList> ownerFeatureProductList = <ProductsList>[].obs;

  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  RxList<UserOffers> userCarouselImgList = <UserOffers>[].obs;
  RxList<String> ownerCarouselImgList = <String>[].obs;

  RxString? role = "".obs;

  late GetOwnerOffersListModel getOwnerOffersListModel =
      GetOwnerOffersListModel();
  RxList<OffersList> getOwnerOfferList = <OffersList>[].obs;

  UserFeaturedProductModel userFeaturedProductModel =
      UserFeaturedProductModel();
  RxList<DataList> featuredUserProductList = <DataList>[].obs;
  dynamic lat = 0.0;
  dynamic lng = 0.0;
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());
  @override
  void onInit() {
    super.onInit();
    searchStoreUserController.onInit();
    apiGetUserDetail();
    getPage();
    getCurrentLocation();
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;

    debugPrint("HomeCController pageId ************${pageId.value} $roleVal");
  }

  getCurrentLocation() async {
    Position currentLocation = await Utility.fetchCurrentLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
    debugPrint("CURRENT LAT AND LNG ************$lat $lng");
    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    if (roleVal == Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      await apiGetUserOffersList();
      await apiGetUserFeaturedProducts();
    } else {
      role!.value = Role.storeOwnerRoleText;
      await apiGetOwnerOffersList();
      await apiGetOwnerFeaturedProducts();
    }
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
                    /*Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AccountScreen(),
                    ));*/
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

  ///Get User Detail Info Api
  Future apiGetUserDetail() async {
    debugPrint(
        "GET USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDetail}");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().userDetail,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET USER DETAIL RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        firstName!.value = getUserDetailModel.data?.user?.firstName ?? "";
        lastName!.value = getUserDetailModel.data?.user?.lastName ?? "";
        email!.value = getUserDetailModel.data?.user?.email ?? "";
        currentUserId!.value = getUserDetailModel.data?.user?.userId ?? "";
        hasStoreAccess!.value =
            getUserDetailModel.data?.user?.hasStoreAccess ?? false;
        SharedPreferenceStorage.setData(StringConstants.firstNameText,
            getUserDetailModel.data?.user?.firstName ?? "");
        SharedPreferenceStorage.setData(
            StringConstants.lastNameText, lastName!.value);
        SharedPreferenceStorage.setData(
            StringConstants.emailText, email!.value);
        SharedPreferenceStorage.setData(
            StringConstants.currentUserIdText, currentUserId!.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      }
    });
  }

  ///Get Nearby Stores Api [USER]
  Future apiGetUserOffersList() async {
    userCarouselImgList.clear();
    debugPrint(
      "GET USER OFFER STORES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreHomeOffers}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
    );

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreHomeOffers}?longitude=$lng&latitude=$lat&mileage=1000&page=1&page_size=20",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET USER OFFER STORES RESPONSE *******${value?.body}");
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
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Feature ProductList Store Api [USER OLD]
  Future apiGetUserFeaturedProductsOLD() async {
    isLoading!.value = true;
    debugPrint("USER FEATURED PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    Map data = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 5,
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

    debugPrint("TOKEN ********** $headers");
    debugPrint("USER FEATURED PRODUCT BODY ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeFeatureProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER FEATURED PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Feature ProductList Store Api [USER NEW]
  Future apiGetUserFeaturedProducts() async {
    isLoading!.value = true;
    String url =
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreHomeProducts}?longitude=${lng.toString()}&latitude=${lat.toString()}&mileage=1000&page=1&page_size=5";
    debugPrint("USER FEATURED PRODUCT URL**********$url");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    Map data = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 5,
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

    debugPrint("TOKEN ********** $headers");
    debugPrint("USER FEATURED PRODUCT BODY ********** ${data.toString()}");
    UserProvider()
        .getWithHeadersApi(url, headers, showLoading: false)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("USER FEATURED PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        userFeaturedProductModel =
            UserFeaturedProductModel.fromJson(value?.body);
        featuredUserProductList.value =
            userFeaturedProductModel.data!.products!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Offers List Api [OWNER]
  Future apiGetOwnerOffersList() async {
    ownerCarouselImgList.clear();
    isLoading!.value = true;
    debugPrint(
        "GET OWNER OFFERS LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOfferList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "store_id": null,
      "page": 1,
      "page_size": 10,
      "order_by": "offer_name",
      "order_type": "DESC",
      "filters": []
    };
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOfferList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("OWNER OFFERS LIST BODY ******* $body");
      log("OWNER OFFERS LIST RESPONSE *******${value?.body}");
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
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Feature ProductList Store Api [Owner]
  Future apiGetOwnerFeaturedProducts() async {
    isLoading!.value = true;
    debugPrint("OWNER FEATURED PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeProductList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");

    Map<String, dynamic> body = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 10,
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
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeProductList,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("OWNER FEATURED PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        ownerFeaturedProductModel =
            OwnerFeaturedProductModel.fromJson(value?.body);
        ownerFeatureProductList.value =
            ownerFeaturedProductModel.data?.products ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
