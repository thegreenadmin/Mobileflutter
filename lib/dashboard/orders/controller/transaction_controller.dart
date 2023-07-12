import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/model/orders_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

class TransactionController extends GetxController {
  GetUserTransactionModel getUserTransactionModel = GetUserTransactionModel();
  RxList<Transactionss>? userTransactionList = <Transactionss>[].obs;

  GetOwnerTransactionModel getOwnerTransactionModel =
      GetOwnerTransactionModel();
  RxList<Transactions>? ownerOrderTransactionList = <Transactions>[].obs;

  RxBool isCurrentMonthSelected = true.obs;
  RxBool isLoading = true.obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? storeId = "".obs;
  RxInt selectedIndex = 0.obs;
  RxInt pageId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getPage();
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
    isCurrentMonthSelected.value = true;
    if (roleVal == Role.customerRoleText) {
      role!.value = Role.customerRoleText;
      apiGetUserOrderTransactionHistory();
    } else {
      role!.value = Role.storeOwnerRoleText;
      apiGetOwnerOrderTransactionHistory();
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
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/01/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/01/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}");
        }
        break;

      case 1: //Feb
        {
          int year = DateTime.now().year;
          debugPrint(selectedIndex.value.toString());
          bool isLeapYear(int year) =>
              (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/02/01",
                  endDateOfMonth: isLeapYear(year)
                      ? "${DateTime.now().year}/02/29"
                      : "${DateTime.now().year}/02/28")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/02/01",
                  endDateOfMonth: isLeapYear(year)
                      ? "${DateTime.now().year}/02/29"
                      : "${DateTime.now().year}/02/28");
        }
        break;
      case 2: //March
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/03/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/03/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/03/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/03/${daysInMonth(DateTime.now())}");
        }
        break;
      case 3: //April
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/04/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/04/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/04/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/04/${daysInMonth(DateTime.now())}");
        }
        break;
      case 4: //May
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/05/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/05/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/05/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/05/${daysInMonth(DateTime.now())}");
        }
        break;
      case 5: //june
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/06/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/06/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/06/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/06/${daysInMonth(DateTime.now())}");
        }
        break;
      case 6: //july
        {
          debugPrint(selectedIndex.value.toString());

          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/07/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/07/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/07/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/07/${daysInMonth(DateTime.now())}");
        }
        break;
      case 7: //aug
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/08/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/08/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/08/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/08/${daysInMonth(DateTime.now())}");
        }
        break;
      case 8: //sept
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/09/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/09/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/09/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/09/${daysInMonth(DateTime.now())}");
        }
        break;
      case 9: //oct
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/10/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/10/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/10/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/10/${daysInMonth(DateTime.now())}");
        }
        break;
      case 10: //Nov
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/11/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/11/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/11/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/11/${daysInMonth(DateTime.now())}");
        }
        break;
      case 11: //Dec
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/12/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/12/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth: "${DateTime.now().year}/12/01",
                  endDateOfMonth:
                      "${DateTime.now().year}/12/${daysInMonth(DateTime.now())}");
        }
        break;

      default:
        {
          debugPrint(selectedIndex.value.toString());
          role!.value == Role.customerRoleText
              ? apiGetUserOrderTransactionHistory(
                  startDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}",
                  endDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}")
              : apiGetOwnerOrderTransactionHistory(
                  startDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}",
                  endDateOfMonth:
                      "${DateTime.now().year}/01/${daysInMonth(DateTime.now())}");
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

  ///Api get current and past transaction history of [USER]
  Future apiGetUserOrderTransactionHistory(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    ownerOrderTransactionList!.clear();
    isLoading.value = true;
    String currentMonth =
        "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";
    debugPrint("USER ORDER HISTORY URL **********");
    debugPrint(
      (startDateOfMonth == "" || startDateOfMonth.isEmpty) &&
              (endDateOfMonth == "" || endDateOfMonth.isEmpty)
          ? "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionList}?page=1&page_size=10&from_date=${DateTime.now().year}/$currentMonth/01&to_date=${DateTime.now().year}/$currentMonth/${daysInMonth(DateTime.now())}"
          : "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionList}?page=1&page_size=10&from_date=$startDateOfMonth&to_date=$endDateOfMonth",
    );

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            (startDateOfMonth == "" || startDateOfMonth.isEmpty) &&
                    (endDateOfMonth == "" || endDateOfMonth.isEmpty)
                ? "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionList}?page=1&page_size=10&from_date=${DateTime.now().year}/$currentMonth/01&to_date=${DateTime.now().year}/$currentMonth/${daysInMonth(DateTime.now())}"
                : "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletTransactionList}?page=1&page_size=10&from_date=$startDateOfMonth&to_date=$endDateOfMonth",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("USER ORDER HISTORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getUserTransactionModel = GetUserTransactionModel.fromJson(value.body);
        userTransactionList!.value =
            getUserTransactionModel.data!.transactions!.cast<Transactionss>();
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Api get current and past transaction history of [OWNER]
  Future apiGetOwnerOrderTransactionHistory(
      {String startDateOfMonth = "", String endDateOfMonth = ""}) async {
    ownerOrderTransactionList!.clear();
    isLoading.value = true;
    String currentMonth =
        "${DateTime.now().month < 9 ? "0" : ""}${DateTime.now().month}";
    debugPrint("OWNER ORDER HISTORY URL **********");
    debugPrint(
      (startDateOfMonth == "" || startDateOfMonth.isEmpty) &&
              (endDateOfMonth == "" || endDateOfMonth.isEmpty)
          ? "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransaction}?page=1&page_size=10&from_date=${DateTime.now().year}-$currentMonth-01&to_date=${DateTime.now().year}/$currentMonth/${daysInMonth(DateTime.now())}"
          : "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransaction}?page=1&page_size=10&from_date=$startDateOfMonth&to_date=$endDateOfMonth",
    );

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            (startDateOfMonth == "" || startDateOfMonth.isEmpty) &&
                    (endDateOfMonth == "" || endDateOfMonth.isEmpty)
                ? "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransaction}?page=1&page_size=10&from_date=${DateTime.now().year}/$currentMonth/01&to_date=${DateTime.now().year}/$currentMonth/${daysInMonth(DateTime.now())}"
                : "${ServerCommunicator().baseUrl}${ServerCommunicator().storeTransaction}?page=1&page_size=10&from_date=$startDateOfMonth&to_date=$endDateOfMonth",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("OWNER ORDER HISTORY RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getOwnerTransactionModel =
            GetOwnerTransactionModel.fromJson(value.body);
        ownerOrderTransactionList!.value =
            getOwnerTransactionModel.data!.transactions!;
        update();
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
