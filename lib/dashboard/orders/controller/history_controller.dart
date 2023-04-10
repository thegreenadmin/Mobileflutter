import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/orders/model/get_owner_order_history_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_user_order_history_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class HistoryController extends GetxController {
  GetUserOrderHistoryModel getUserOrderHistoryModel =
      GetUserOrderHistoryModel();
  RxList<Order>? userOrderHistoryList = <Order>[].obs;

  GetOwnerOrderHistoryModel getOwnerOrderHistoryModel =
      GetOwnerOrderHistoryModel();
  RxList<Orders>? ownerOrderHistoryList = <Orders>[].obs;

  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxString? storeId = "".obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    isCurrentMonthSelected.value = true;
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserOrderHistory();
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetOwnerOrderHistory();
    }
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void onIndexChange(int i) async {
    selectedIndex.value = i;
    switch (i) {
      case 0: //Jan
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-01-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-01-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}");
        }
        break;

      case 1: //Feb
        {
          int year = DateTime.now().year;
          debugPrint(selectedIndex.value.toString());
          bool isLeapYear(int year) =>
              (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-02-01",
                  endDateOfMonth: isLeapYear(year)
                      ? "${DateTime.now().year}-02-29"
                      : "${DateTime.now().year}-02-28")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-02-01",
                  endDateOfMonth: isLeapYear(year)
                      ? "${DateTime.now().year}-02-29"
                      : "${DateTime.now().year}-02-28");
        }
        break;
      case 2: //March
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-03-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-03-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-03-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-03-${daysInMonth(DateTime.now())}");
        }
        break;
      case 3: //April
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-04-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-04-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-04-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-04-${daysInMonth(DateTime.now())}");
        }
        break;
      case 4: //May
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-05-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-05-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-05-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-05-${daysInMonth(DateTime.now())}");
        }
        break;
      case 5: //june
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-06-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-06-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-06-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-06-${daysInMonth(DateTime.now())}");
        }
        break;
      case 6: //july
        {
          debugPrint(selectedIndex.value.toString());

          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-07-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-07-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-07-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-07-${daysInMonth(DateTime.now())}");
        }
        break;
      case 7: //aug
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-08-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-08-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-08-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-08-${daysInMonth(DateTime.now())}");
        }
        break;
      case 8: //sept
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-09-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-09-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-09-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-09-${daysInMonth(DateTime.now())}");
        }
        break;
      case 9: //oct
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-10-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-10-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-10-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-10-${daysInMonth(DateTime.now())}");
        }
        break;
      case 10: //Nov
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-11-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-11-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-11-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-11-${daysInMonth(DateTime.now())}");
        }
        break;
      case 11: //Dec
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-12-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-12-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth: "${DateTime.now().year}-12-01",
                  endDateOfMonth:
                      "${DateTime.now().year}-12-${daysInMonth(DateTime.now())}");
        }
        break;

      default:
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderHistory(
                  startDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}",
                  endDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderHistory(
                  startDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}",
                  endDateOfMonth:
                      "${DateTime.now().year}-01-${daysInMonth(DateTime.now())}");
        }
        break;
    }
  }

  RxList horizontalTabList = [
    StringConstants.janText,
    StringConstants.febText,
    StringConstants.marchText,
    StringConstants.aprilText,
    StringConstants.mayText,
    StringConstants.juneText,
    StringConstants.julyText,
    StringConstants.augText,
    StringConstants.sepText,
    StringConstants.octText,
    StringConstants.novText,
    StringConstants.decText,
  ].obs;

  //Api get current and past history of [USER]
  Future apiGetUserOrderHistory(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    isLoading.value = true;
    debugPrint(
        "USER ORDER HISTORY API URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    String currentMonth =
        "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";

    Map body = {
      "store_id": null,
      "page": null,
      "page_size": null,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": startDateOfMonth == "" || startDateOfMonth.isEmpty
          ? "${DateTime.now().year}-$currentMonth-01"
          : startDateOfMonth,
      "to_date": endDateOfMonth == "" || endDateOfMonth.isEmpty
          ? "${DateTime.now().year}-$currentMonth-${daysInMonth(DateTime.now())}"
          : endDateOfMonth,
      "only_active_orders": true,
      "order_statuses": []
    };
    debugPrint("USER ORDER HISTORY API BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().orderList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("USER ORDER HISTORY URL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getUserOrderHistoryModel =
            GetUserOrderHistoryModel.fromJson(value.body);
        userOrderHistoryList!.value = getUserOrderHistoryModel.data!.orders!;
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Api get current and past history of [OWNER]
  Future apiGetOwnerOrderHistory(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    isLoading.value = true;
    debugPrint(
        "OWNER ORDER HISTORY URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    String currentMonth =
        "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";

    Map body = {
      "store_id": null,
      "page": null,
      "page_size": null,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": startDateOfMonth == "" || startDateOfMonth.isEmpty
          ? "${DateTime.now().year}-$currentMonth-01"
          : startDateOfMonth,
      "to_date": endDateOfMonth == "" || endDateOfMonth.isEmpty
          ? "${DateTime.now().year}-$currentMonth-${daysInMonth(DateTime.now())}"
          : endDateOfMonth,
      "only_active_orders": true,
      "order_statuses": []
    };
    debugPrint("OWNER ORDER HISTORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().storeOrderList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER ORDER HISTORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOwnerOrderHistoryModel =
            GetOwnerOrderHistoryModel.fromJson(value.body);
        ownerOrderHistoryList!.value = getOwnerOrderHistoryModel.data!.orders!;
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
