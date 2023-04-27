import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/orders/model/get_owner_order_history_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_owner_transaction_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_user_order_history_model.dart';

import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class TransactionDetailController extends GetxController {
  GetOwnerTransactionModel getOwnerTransactionModel =
      GetOwnerTransactionModel();
  RxList<Transactions>? ownerOrderTransactionList = <Transactions>[].obs;

  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxString? storeId = "".obs;
  RxString? storeWalletTransactionId = "".obs;
  RxInt selectedIndex = 0.obs;
  RxString? orderId = "".obs;
  RxString? customerName = "".obs;
  RxString? orderDate = "".obs;
  RxString? orderAmount = "".obs;

  @override
  void onInit() {
    super.onInit();
    storeWalletTransactionId!.value =
        Get.arguments['store_wallet_transaction_id'] ?? "";
    storeId!.value = Get.arguments['store_id'] ?? "";
    isCurrentMonthSelected.value = true;
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      // apiGetUserOrderTransactionHistory();
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetOwnerTransactionDetail();
    }
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
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

  //Api get current and past transaction history of [USER]
  Future apiGetUserOrderTransactionHistory(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    isLoading.value = true;
    debugPrint(
        "USER ORDER HISTORY API URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content/Type': 'application/json',
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
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Api get transaction detail of owner [OWNER]
  Future apiGetOwnerTransactionDetail(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    isLoading.value = true;
    debugPrint("OWNER TRANSACTION DETAIL URL **********");
    debugPrint(
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransactionDetail}?store_wallet_transaction_id=${storeWalletTransactionId!.value}&store_id=${storeId!.value}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransactionDetail}?store_wallet_transaction_id=${storeWalletTransactionId!.value}&store_id=${storeId!.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER TRANSACTION DETAIL  RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        if (value.body["data"]["transaction"]['order_transaction'] != null) {
          customerName!.value = value.body["data"]["transaction"]
              ['order_transaction']['order']["customer_name"];
          orderId!.value = value.body["data"]["transaction"]
              ['order_transaction']['order_id'];
          orderAmount!.value = value.body["data"]["transaction"]
                  ['order_transaction']['transaction']['transaction_amount']
              .toStringAsFixed(2);
          orderDate!.value = Utility.parseDateTime(
            DateTime.parse(
                value.body["data"]["transaction"]['createdAt'].toString()),
            secFormat: '',
          ).toString();
        } else if (value.body["data"]["transaction"]['transaction'] != null) {
          orderId!.value = value.body["data"]["transaction"]
              ['order_transaction']['order_id'];
          orderAmount!.value = value.body["data"]["transaction"]
                  ['order_transaction']['transaction']['transaction_amount']
              .toStringAsFixed(2);
          orderDate!.value = Utility.parseDateTime(
            DateTime.parse(
                value.body["data"]["transaction"]['createdAt'].toString()),
            secFormat: '',
          ).toString();
        }
        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
