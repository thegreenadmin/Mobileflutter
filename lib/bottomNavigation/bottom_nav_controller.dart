import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/more/controller/more_controller.dart';
import 'package:thegreenmall/dashboard/more/view/more_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/wallet_screen.dart';
import 'package:thegreenmall/main.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/push_notifications/push_notifications.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import '../dashboard/home/model/get_store_list_model.dart';
import '../utils/constants.dart';
import '../utils/global_share_data.dart';

class BottomNavController extends GetxController {
  final selectedIndex = 0.obs;
  RxString roleInApp = "".obs;
  RxBool isLoading = false.obs;
  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_){

      if (initialRemoteMessage != null) {
        selectNotification(NotificationResponse(
          notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
          payload: json.encode(initialRemoteMessage!.data),
        ));
        initialRemoteMessage = null;
      }

      selectedIndex.value = Get.parameters["currentIndex"] != null
          ? int.parse(Get.parameters["currentIndex"].toString())
          : 0;
      SharedPreferenceStorage.removeData("pageId");
      Future.delayed(Duration.zero, () {
        SharedPreferenceStorage.setData("pageId", 0);
        getRole();
      });
      onItemTapped(0);
    });
  }

  getRole() async {
    roleApp.value = await SharedPreferenceStorage.getData(Role.role);
    // pageIdApp.value = await SharedPreferenceStorage.getData("pageId");
    roleInApp.value = await SharedPreferenceStorage.getData(Role.role);
    print("Bottom nav cont roleInApp:--------${roleInApp.value}");
    print(roleInApp.value);
  }

  //Get Store List Api
  Future apiGetStoreList() async {
    isLoading.value = true;
    debugPrint(
        "GET BottomNav  STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider().getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().storeList,
            headers, showLoading: false).then((value) async {
      isLoading.value = false;
      debugPrint("GET BottomNav STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
        if (storeList.length == 1) {
          Get.parameters["storeId"] = storeList.first.storeId;
          Get.parameters["storeCount"] = storeList.length.toString();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  late int getCurrentNavKey;

  List<Widget> tabs = [
    const HomeScreen(),
    const WalletScreen(),
    const OrdersScreen(),
    const OffersScreen(),
    const MoreScreen(),
  ];

  onItemTapped(int index) async {
    getRole();
      selectedIndex.value = index;
    // debugPrint("Bottom pageId:---------$pageId---");
    // if(Get.routing. > 1){
      Get.until((route) => route.isFirst,id:pageIdApp.value);
    // }


      SharedPreferenceStorage.removeData("pageId");

    if (selectedIndex.value == 0) {
      try {
        // Get.delete<HomeController>();
        Future.delayed(Duration.zero, () {
          pageIdApp.value = 0;
          SharedPreferenceStorage.setData("pageId", 0);
          HomeController homeController = Get.put(HomeController());
          homeController.onInit();
        });
      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 1) {
      try {

        // Get.delete<WalletController>();
        Future.delayed(Duration.zero, () async{
          pageIdApp.value = 1;
          SharedPreferenceStorage.setData("pageId", 1);
          WalletController walletController = Get.put(WalletController());

          var pageId = await SharedPreferenceStorage.getData("pageId");
          debugPrint("Bottom WalletController pageId:---------$pageId---");
          walletController.onInit();
        });
      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 2) {
      try {
        // Get.delete<OrdersController>();
        Future.delayed(Duration.zero, ()async {
          if (roleInApp.value == Role.customerRoleText) {
            storeList.clear();
          } else {
            await apiGetStoreList();
          }

          if(roleInApp.value == Role.storeOwnerRoleText){
            if( storeList.length > 1 || storeList.isEmpty){
              pageIdApp.value = 2;
              SharedPreferenceStorage.setData("pageId", 2);
            }else{
              pageIdApp.value = 3;
              SharedPreferenceStorage.setData("pageId", 3);
            }
          }else{
            pageIdApp.value = 4;
            SharedPreferenceStorage.setData("pageId", 4);
          }
          // roleInApp.value == Role.storeOwnerRoleText ?
          // storeList.length > 1 || storeList.isEmpty
          //     ? SharedPreferenceStorage.setData("pageId", 2)
          //     : SharedPreferenceStorage.setData("pageId", 3)
          //     : SharedPreferenceStorage.setData("pageId", 4);
          OrdersController ordersController = Get.put(OrdersController());
          ordersController.onInit();
        });

      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 3) {
      try {
        Future.delayed(Duration.zero, () async{
          pageIdApp.value = 5;
          SharedPreferenceStorage.setData("pageId", 5);
          // Get.delete<OffersController>();
          OffersController offersController = Get.put(OffersController());

          offersController.onInit();
        });
      } catch (e) {
        //Pass
      }
    }
    else if (selectedIndex.value == 4) {
      try {
        Future.delayed(Duration.zero, () async{
          pageIdApp.value = 6;
          SharedPreferenceStorage.setData("pageId", 6);
          // Get.delete<MoreController>();
          MoreController moreController = Get.put(MoreController());

          moreController.onInit();
        });

      } catch (e) {
        //Pass
      }
    }
  }

  Widget get selectedTab =>
      selectedIndex.value == 0 ? const HomeScreen() : tabs[selectedIndex.value];
}
