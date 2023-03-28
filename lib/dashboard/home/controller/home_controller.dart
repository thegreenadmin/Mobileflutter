import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/feature_product_response_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart';
import 'package:thegreenmall/dashboard/home/view/account_screen.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class HomeController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? email = "".obs;
  RxBool? isLoading = false.obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();

  late NearbyStoreListResponse nearbyStoreListResponse =
      NearbyStoreListResponse();

  RxList<StoreAddress> storeAddresses = <StoreAddress>[].obs;

  RxList<String> userCrouselImgList = <String>[].obs;

  RxString? role = "".obs;

  late GetStoreProductList getStoreProductList = GetStoreProductList();
  RxList<Products> storeProductList = <Products>[].obs;

  late FeatureProductListResponse featureProductListResponse =
      FeatureProductListResponse();
  RxList<Product> featuredUserProductList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    apiGetUserDetail();
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserNearByStores();
      apiGetUserFeaturedProducts();
    } else {
      role!.value = Role.storeOwnerRoleText;
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
                    Get.back();
                    Get.to(const AccountScreen());
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
      }
      if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.to(const AccountScreen());
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

      return null!;
    });
  }

  //Get User Detail Info Api
  Future apiGetUserDetail() async {
    debugPrint(
        "GET USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDetail}");

    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().userDetail,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET USER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getUserDetailModel = GetUserDetailModel.fromJson(value.body);
        firstName!.value = getUserDetailModel.data!.user!.firstName ?? "";
        lastName!.value = getUserDetailModel.data!.user!.lastName ?? "";
        email!.value = getUserDetailModel.data!.user!.email ?? "";
        SharedPreferenceStorage.setData(
            StringConstants.firstNameText, firstName!.value);
        SharedPreferenceStorage.setData(
            StringConstants.lastNameText, lastName!.value);
        SharedPreferenceStorage.setData(
            StringConstants.emailText, email!.value);
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Get Nearby Stores Api [USER]
  Future apiGetUserNearByStores({bool isFilter = false}) async {
    nearbyStoreListResponse = NearbyStoreListResponse();
    debugPrint("GET GET NEARBY STORES URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().nearByStoreList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map data = {
      "q": "",
      "page": 1,
      "page_size": 10,
      "longitude": 37.0902,
      "latitude": 95.7129,
      "postal_code": "",
      "mileage": 100,
      "is_open_now": "",
      "opening_time": "00:00:00",
      "closing_time": "24:00:00",
      "is_favourite_store": null
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().nearByStoreList,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET NEARBY STORES *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        nearbyStoreListResponse = NearbyStoreListResponse.fromJson(value?.body);
        storeAddresses.value = nearbyStoreListResponse.data!.storeAddresses!;
        if (storeAddresses.isNotEmpty) {
          for (int i = 0; i < storeAddresses.length; i++) {
            if (i == 5) {
              break;
            }
            userCrouselImgList
                .add(storeAddresses[i].store!.image!.dynamicUrl!.toString());
          }
        }
        update();
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Feature ProductList Store Api [USER]
  Future apiGetUserFeaturedProducts() async {
    isLoading!.value = true;
    debugPrint("FEATURED PRODUCT URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeFeatureProductList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {
      "q": "",
      "store_id": null,
      "page": 1,
      "page_size": 100,
      "order_by": "product_id",
      "order_type": "DESC",
      "category_id": null,
      "is_favourite_products": true,
      "filters": [
        {
          "filter_by": "is_featured_product",
          "filter_value": true,
          "operation": "eq"
        }
      ]
    };

    debugPrint("TOKEN ********** $headers");
    debugPrint("FEATURED PRODUCT BODY ********** ${data.toString()}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeFeatureProductList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading!.value = false;
      debugPrint("FEATURED PRODUCT RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        featureProductListResponse =
            FeatureProductListResponse.fromJson(value?.body);
        featuredUserProductList.value =
            featureProductListResponse.data?.products ?? [];
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
