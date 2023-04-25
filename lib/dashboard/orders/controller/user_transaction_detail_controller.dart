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

class UserTransactionDetailController extends GetxController {
  // GetOwnerOrderHistoryModel getOwnerOrderHistoryModel =
  //     GetOwnerOrderHistoryModel();
  // RxList<Orders>? ownerOrderHistoryList = <Orders>[].obs;

  GetOwnerTransactionModel getOwnerTransactionModel =
      GetOwnerTransactionModel();
  RxList<Transactions>? ownerOrderTransactionList = <Transactions>[].obs;

  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxString? storeId = "".obs;
  RxString? userStripeCardId = "".obs;
  RxInt selectedIndex = 0.obs;
  RxString? orderId = "".obs;
  RxString? customerName = "".obs;
  RxString? orderDate = "".obs;
  RxString? orderAmount = "".obs;

  @override
  void onInit() {
    super.onInit();
    userStripeCardId!.value = Get.arguments['user_stripe_card_id'] ?? "";
    isCurrentMonthSelected.value = true;
    apiGetUserOrderTransactionHistory();
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
    debugPrint("OWNER TRANSACTION DETAIL URL **********");
    debugPrint(
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionDetail}?user_wallet_transaction_id=${userStripeCardId!.value}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionDetail}?user_wallet_transaction_id=${userStripeCardId!.value}",
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
          orderId!.value =
              value.body["data"]["transaction"]['order_transaction_id'];
          orderAmount!.value = value.body["data"]["transaction"]['net_balance']
              .toStringAsFixed(2);
          orderDate!.value = Utility.parseDateTime(
            DateTime.parse(
                value.body["data"]["transaction"]['createdAt'].toString()),
            secFormat: '',
          ).toString();
          // orderDate!.value =
          //     value.body["data"]["transaction"]['createdAt'].toString();
        }

        update();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
