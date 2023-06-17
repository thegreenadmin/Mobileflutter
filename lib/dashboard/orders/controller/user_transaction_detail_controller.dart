import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class UserTransactionDetailController extends GetxController {
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxString? storeId = "".obs;
  RxString? userStripeCardId = "".obs;
  RxInt selectedIndex = 0.obs;
  RxInt pageId = 0.obs;
  RxString? orderId = "".obs;
  RxString? customerName = "".obs;
  RxString? orderDate = "".obs;
  RxString? orderAmount = "".obs;
  RxString? storeName = "".obs;
  RxString? storeImage = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;

  @override
  void onInit() {
    super.onInit();
    userStripeCardId!.value = Get.parameters['user_stripe_card_id'] ?? "";
    // userStripeCardId!.value = Get.arguments['user_stripe_card_id'] ?? "";
    apiGetUserOrderTransactionHistory();
    getPage();
  }
  getPage()async{
    firstName?.value = await SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
    lastName?.value = await SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
    pageId.value = await SharedPreferenceStorage.getData("pageId");
    var roleVal = await SharedPreferenceStorage.getData(Role.role.value);
    role?.value = roleVal;
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
    debugPrint("USER TRANSACTION DETAIL URL **********");
    debugPrint(
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionDetail}?user_wallet_transaction_id=${userStripeCardId!.value}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionDetail}?user_wallet_transaction_id=${userStripeCardId!.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("USER TRANSACTION DETAIL  RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        if (value.body["data"]["transaction"]['transaction'] != null) {
          orderId!.value = value.body["data"]["transaction"]['transaction_id'];
          orderAmount!.value = value.body["data"]["transaction"]['net_balance']
              .toStringAsFixed(2);
          orderDate!.value = Utility.parseDateTime(
            DateTime.parse(
                value.body["data"]["transaction"]['createdAt'].toString()),
            secFormat: '',
          ).toString();

        } else if (value.body["data"]["transaction"]['order_transaction'] !=
            null) {
          orderId!.value = value.body["data"]["transaction"]
                  ["order_transaction"]['order_id']
              .toString();
          orderAmount!.value = value.body["data"]["transaction"]
                  ["order_transaction"]['transaction']['transaction_amount']
              .toStringAsFixed(2);
          storeName!.value =
              value.body["data"]["transaction"]["store"]['store_name'] ?? "";
          storeImage!.value = value.body["data"]["transaction"]["store"]['logo']
                  ['dynamic_url'] ??
              "";
          orderDate!.value = Utility.parseDateTime(
            DateTime.parse(
                value.body["data"]["transaction"]['createdAt'].toString()),
            secFormat: '',
          ).toString();
        }
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
