import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/order_history_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class HistoryController extends GetxController {
  RxList<Orders>? historyList = <Orders>[].obs;
  OrderHistoryModel orderHistoryModel = OrderHistoryModel();
  OrderHistoryModel pastHistoryModel = OrderHistoryModel();
  RxBool isCurrentMonthSelected = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {
      isCurrentMonthSelected.value = true;
      apiCurrentHistory();
    });
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  //Add Category Api
  Future apiCurrentHistory() async {
    debugPrint("CURRENT_HISTORY**********${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    String currentMonth = "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";

    Map body = {
      "store_id": null,
      "page": null,
      "page_size": null,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": "${DateTime.now().year}-$currentMonth-01",
      "to_date": "${DateTime.now().year}-$currentMonth-${daysInMonth(DateTime.now())}",
      "only_active_orders": true,
      "order_statuses": []
    };
    debugPrint("ADD CATEGORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(body, ServerCommunicator().baseUrl + ServerCommunicator().orderList, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        orderHistoryModel = OrderHistoryModel.fromJson(value.body);
        historyList!.value = orderHistoryModel.data!.orders!;
        update();
        apiPastHistory();
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Add Category Api
  Future apiPastHistory() async {
    debugPrint("PAST_HISTORY**********${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    String previousMonth = "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month - 2}";
    String currentMonth = "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";
    Map body = {
      "store_id": null,
      "page": null,
      "page_size": null,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": "${DateTime.now().year}-$previousMonth-01",
      "to_date": "${DateTime.now().year}-$currentMonth-${daysInMonth(DateTime.now())}",
      "only_active_orders": true,
      "order_statuses": []
    };
    debugPrint("ADD CATEGORY BODY********** $body");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(body, ServerCommunicator().baseUrl + ServerCommunicator().orderList, headers,
            showLoading: true)
        .then((value) async {
      debugPrint("GET CATEGORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 || value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        pastHistoryModel = OrderHistoryModel.fromJson(value.body);
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
