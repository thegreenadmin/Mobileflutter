import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/categories_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/bank_account_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/country_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/get_auto_recharge_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/get_cardlist_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
import 'package:thegreenmall/dashboard/wallet/model/owners_stores_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:http/http.dart' as http;
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class WalletController extends GetxController {
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString? role = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString day = "".obs;
  RxInt amount = 0.obs;
  RxString userName = "".obs;
  RxString phoneNumber = "".obs;
  RxString withoutCodeNumber = "".obs;
  RxString customerId = "".obs;
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxString selectPaymentType = "".obs;
  RxString? userStripeCardId = "".obs;
  RxString? userWalletBalance = "".obs;
  RxString? ownerWalletBalance = "0.00".obs;
  RxString? storeNameValue = "".obs;
  RxString autoChargeType = "threshold".obs;
  RxString? startformattedDate = "".obs;
  RxString? endformattedDate = "".obs;
  RxString stripeToken = "".obs;
  RxString selectedCountry = "".obs;
  RxString accountHolderTypeText = "".obs;
  RxString dynamicLink = "".obs;
  RxString userWalletAutoChargeId = "".obs;
  RxString selectedFrequency = "".obs;
  RxString ownerSelectedStore = "".obs;
  RxString bankToken = "".obs;
  RxInt pageId = 0.obs;
  late RxString dateOfEvent = "".obs;
  late RxString timeOfEvent = "".obs;

  RxBool isCvvFocused = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isStoresLoading = false.obs;
  RxBool isautoRechargeEnable = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? type = 0.obs;

  RxBool isFromCartScreen = false.obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;

  final GlobalKey<FormState> formKeyAutoCharge = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyCreateOwnerBankBalance =
      GlobalKey<FormState>();
  TextEditingController amountTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();
  TextEditingController accountHolderNameTextController =
      TextEditingController();

  TextEditingController rountingTextController = TextEditingController();
  TextEditingController accountNumberTextController = TextEditingController();
  TextEditingController currencyTextController = TextEditingController();

  TextEditingController thresholdAmountTextController = TextEditingController();
  TextEditingController chargeAmountTextController = TextEditingController();
  TextEditingController periodChargeAmountTextController =
      TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  TextEditingController frequencyTextController = TextEditingController();

  late CardListModel cardListModel = CardListModel();
  RxList<Cards> cardList = <Cards>[].obs;

  late BankAccountListModel bankAccountListModel = BankAccountListModel();
  RxList<Banks> bankAccountList = <Banks>[].obs;

  RxList<dynamic> selectedCards = <dynamic>[].obs;
  late CountryListModel countryListModel = CountryListModel();
  RxList<Countries> countryList = <Countries>[].obs;

  late GetOwnerStoresResponse getStoreListModel = GetOwnerStoresResponse();
  late GetAutoRechargeModel getAutoRechargeModel = GetAutoRechargeModel();

  RxList<Datum> storeList = <Datum>[].obs;
  RxList<String> monthDayList = <String>[].obs;
  RxList<Categories> weekDaysList = [
    Categories(id: 1, name: "Monday", isSelected: false),
    Categories(id: 2, name: "Tuesday", isSelected: false),
    Categories(id: 3, name: "Wednesday", isSelected: false),
    Categories(id: 4, name: "Thursday", isSelected: false),
    Categories(id: 5, name: "Friday", isSelected: false),
    Categories(id: 6, name: "Saturday", isSelected: false),
    Categories(id: 7, name: "Sunday", isSelected: false),
  ].obs;

  RxString capability = "".obs;
  RxBool payouts = false.obs;
  RxString accountLink = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPage();
    });
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    pageId.value = await SharedPreferenceStorage.getData("pageId");

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    debugPrint(
        "WalletController:----- ${firstName?.value} ---${pageId.value} --$roleVal --------");
    debugPrint(
        "WalletController:----- ${firstName?.value} ---${pageId.value} --$roleVal --------");

    role?.value = roleVal;
    autoChargeType.value = "threshold";
    if (role?.value == Role.customerRoleText) {
      if (Get.parameters['isFromCartScreen'] != "false") {
        isFromCartScreen.value =
            Get.parameters["isFromCartScreen"] == "true" ? true : false;
      }
      getApiData();
    } else {
      await apiGetBankAccountList();
      await apiGetStoreList();
      await apiGetCountries();
      await apiGetAccountDetails();
    }
    update();
  }

  getApiData() async {
    await apiGetCardList(Get.context!);
    await apiGetUserWalletBalance();
    await apiGetAutoRechargeDetail();
  }

  monthDays() {
    monthDayList.clear();
    for (int i = 1; i <= 31; i++) {
      monthDayList.add(i.toString());
    }
  }

  bool validateAndSaveAutoCharge() {
    final form = formKeyAutoCharge.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateAndSaveCreateOwnerBankBalance() {
    final form = formKeyCreateOwnerBankBalance.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

// Fields Validation Method
  void validateAndSubmit(BuildContext mcontext,
      {bool isFromCreateOwnerBankBalance = false,
      bool updateAutoData = false,
      isFromautorecharge = false}) async {
    if (isFromautorecharge == true) {
      if (validateAndSaveAutoCharge()) {
        try {
          if (autoChargeType.value.isEmpty) {
            Utility.showAlertMessage("Please select auto-reload type");
          } else if (autoChargeType.value == "threshold" &&
              chargeAmountTextController.text.isEmpty) {
            Utility.showAlertMessage("Please enter charge amount");
          } else if (autoChargeType.value == "threshold" &&
              thresholdAmountTextController.text.isEmpty) {
            Utility.showAlertMessage("Please enter amount");
          } else if (autoChargeType.value != "threshold" &&
              selectedFrequency.value.isEmpty) {
            Utility.showAlertMessage("Please select payment type");
          } else if (autoChargeType.value != "threshold" && day.value.isEmpty) {
            Utility.showAlertMessage("Please select day");
          } else if (userStripeCardId!.value.isEmpty) {
            Utility.showAlertMessage("Please add card");
          } else if (updateAutoData == true) {
            apiUpdateAutoRecharge(mcontext);
          } else {
            apiCreateAutoRecharge(mcontext);
          }
        } catch (_) {}
      } else {
        autoValidate.value = true;
      }
    } else if (isFromCreateOwnerBankBalance == false) {
      if (validateAndSaveCreateOwnerBankBalance()) {
        if (selectPaymentType.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectPaymentTypeText);
        } else if (selectPaymentType.value == "Cards" &&
            userStripeCardId!.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
        } else {
          await apiAddMoneyToWallet(mcontext);
        }
      } else {
        autoValidate.value = true;
      }
    } else {
      if (accountHolderTypeText.isEmpty) {
        Utility.showAlertMessage("Please select account holder type");
      } else {
        apiCreateBankToken(mcontext);
      }
    }
    /* if (validateAndSaveAutoCharge()) {
      try {
        if (isFromautorecharge == true) {
          if (autoChargeType.value.isEmpty) {
            Utility.showAlertMessage("Please select auto-reload type");
          } else {
            apiCreateAutoRecharge(mcontext);
          }
        } else if (isFromCreateOwnerBankBalance == false) {
          if (selectPaymentType.isEmpty) {
            Utility.showAlertMessage(
                AlertStringConstants.pleaseSelectPaymentTypeText);
          } else if (selectPaymentType.value == "Cards" &&
              userStripeCardId!.value.isEmpty) {
            Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
          } else {
            await apiAddMoneyToWallet(mcontext);
          }
        } else {
          if (accountHolderTypeText.isEmpty) {
            Utility.showAlertMessage("Please select account holder type");
          } else {
            apiCreateBankToken(mcontext);
          }
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }*/
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  //Get Store Details Api
  Future apiGetStoreDetailsApi() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${ownerSelectedStore.value}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${ownerSelectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("STORE DETAILS RESPONSE*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
        dynamicLink.value =
            storeDetailsResponse.value.data!.store!.dynamicLink.toString();
        debugPrint("DEEP LINK ***********${dynamicLink.value}");
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Countries Api
  Future apiGetCountries() async {
    countryList.clear();
    debugPrint(
        "GET COUNTRIES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().countries,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET COUNTRIES RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        countryListModel = CountryListModel.fromJson(value.body);
        countryList.value = countryListModel.data!.countries!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Store List Api
  Future apiGetStoreList() async {
    storeList.clear();
    isStoresLoading.value = true;
    debugPrint(
        "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().ownersStoreList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().ownersStoreList,
            headers,
            showLoading: true)
        .then((value) async {
      isStoresLoading.value = false;
      log("GET STORE RESPONSE *******${jsonEncode(value!.body)}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetOwnerStoresResponse.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data as Iterable<Datum>);
        Get.parameters["storeCount"] = storeList.length.toString();
        if (storeList.length == 1) {
          ownerSelectedStore.value = storeList[0].storeId.toString();
          apiGetOwnerWalletBalance();
        } else {
          if (storeList.isNotEmpty) {
            storeNameValue!.value = storeList[0].storeName.toString();
            ownerSelectedStore.value = storeList[0].storeId.toString();
          }
        }
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  Future<void> apiCreateStripeToken(context) async {
    var str = expiryDate.value;
    var parts = str.split('/');
    var month = parts[0].trim();
    var year = parts[1].trim();
    try {
      var headers = {
        'Authorization':
            'Basic cGtfdGVzdF81MU1uYUpkRlZuTW1IaGtHWW55ZFp2bENoMVhXMlhzNUllczhVc3hiajdNWVhQcUdQTkRuV3BBaDIzR1cyTUg3WUcxRnhjM0p6M2pUYjZkZlRuMjRsSjE0VTAwU3hETEJwSnI6',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request(
          'POST', Uri.parse(ServerCommunicator().createStripeToken));
      request.bodyFields = {
        'card[number]': cardNumber.value,
        'card[exp_month]': month,
        'card[exp_year]': year,
        'card[cvc]': cvvCode.value
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var streamResponse = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var parsed = jsonDecode(streamResponse.body);
        stripeToken.value = parsed['id'].toString();
        await apiCreateCard(context);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

//Api Create Card
  Future apiCreateCard(context) async {
    debugPrint(
        "CREATE CARD URL *******${ServerCommunicator().baseUrl + ServerCommunicator().createCard}");
    Map body = {"token_id": stripeToken.value};
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("CREATE CARD BODY *******$body");
    debugPrint("CREATE CARD HEADERS *******$headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl + ServerCommunicator().createCard,
            headers,
            showLoading: true)
        .then((value) async {
      if (value != null) {
        debugPrint("CREATE CARD  RESPONSE *******${value.body}");
        if (value.body['success'] == true ||
            value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          Utility.showToast(value.body['message']);
          // Get.back();
          Get.back(id: pageIdApp.value);
          // Navigator.of(context).pop();
          await apiGetCardList(context);
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
        } else {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetCardList(BuildContext context) async {
    isLoading.value = true;
    debugPrint("GET CARD LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CARD LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        cardListModel = CardListModel.fromJson(value.body);
        cardList.value = cardListModel.data?.cards ?? [];
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (!value.body['message']
            .toString()
            .toLowerCase()
            .contains("stripe")) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

// Add Money to stripe wallet
  apiAddMoneyToWallet(BuildContext ctx) async {
    debugPrint(
        "ADD MONEY TO WALLET URL *******${ServerCommunicator().baseUrl + ServerCommunicator().userWalletRechargeStripe}");
    Map body = {
      "user_stripe_card_id": userStripeCardId!.value,
      "amount": amountTextController.text.trim()
    };
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("ADD MONEY TO WALLET BODY *******$body");
    debugPrint("ADD MONEY TO WALLET HEADERS *******$headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().userWalletRechargeStripe,
            headers,
            showLoading: true)
        .then((value) async {
      if (value != null) {
        debugPrint("ADD MONEY TO WALLET RESPONSE *******${value.body}");
        if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          userStripeCardId!.value = "";
          amountTextController.clear();
          selectPaymentType.value = "";
          selectPaymentType.value.isEmpty;
          userStripeCardId!.value.isEmpty;
          Get.back(id: pageIdApp.value);
          // Navigator.of(ctx).pop();
          Utility.showToast(value.body['message']);
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
        } else {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetUserWalletBalance() async {
    userWalletBalance!.value = "";
    isLoading.value = true;
    debugPrint("GET USER WALLET BALANCE URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET USER WALLET BALANCE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        userWalletBalance!.value =
            value?.body['data']['balance'].toStringAsFixed(2);
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

//Delete Card api
  Future apiDeleteCard(context, {String userStripeCardId = ""}) async {
    debugPrint(
        "DELETE CARD URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardDelete}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map body = {"user_stripe_card_id": userStripeCardId};

    debugPrint("DELETE CARD BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE CARD RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetCardList(context);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetCardList(context);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Owner Balance Api
  Future apiGetOwnerWalletBalance() async {
    isLoading.value = true;
    debugPrint(
        "GET OWNER WALLET BALANCE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeWalletBalance}?store_id=${ownerSelectedStore.value}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeWalletBalance}?store_id=${ownerSelectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET OWNER WALLET BALANCE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        ownerWalletBalance!.value =
            value?.body['data']['balance'].toStringAsFixed(2);
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
      } else {
        String msg = value!.body["message"].toString().toLowerCase();
        if (msg.contains("store not found")) {
          Utility.showAlertMessage("Please select store");
        } else {
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  Future<void> apiCreateBankToken(BuildContext ctxx) async {
    try {
      var headers = {
        'Authorization':
            'Basic c2tfdGVzdF81MU1uYUpkRlZuTW1IaGtHWTFQU3dCRkZGakdGT29EWUt0Z2Z0aVNtUkdKdDJzY0lTSlBaT1o2YXkyeWlMSmlMMW5Kb2cyaEFpZDRDNU5SNGFTMVZVZmZvNDAwN3hBVG03eU46',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request =
          http.Request('POST', Uri.parse(ServerCommunicator().createBankToken));
      request.bodyFields = {
        'bank_account[country]': selectedCountry.value.trim(),
        'bank_account[currency]': "USD",
        'bank_account[account_holder_name]':
            accountHolderNameTextController.text.trim(),
        'bank_account[account_holder_type]': accountHolderTypeText.value,
        'bank_account[routing_number]': rountingTextController.text.trim(),
        'bank_account[account_number]': accountNumberTextController.text.trim()
      };
      debugPrint("BANK ACCOUNT TOKEN BODY **********${request.bodyFields}");
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var streamResponse = await http.Response.fromStream(response);
      debugPrint("BANK ACCOUNT RESPONSE ************${streamResponse.body}");
      debugPrint(response.statusCode.toString());
      debugPrint(response.reasonPhrase);

      if (response.statusCode == 200) {
        var parsed = jsonDecode(streamResponse.body);

        bankToken.value = parsed['id'].toString();

        apiCreateStoreStripeAccount(ctxx);
      } else if (response.statusCode == 400) {
        var parsed = jsonDecode(streamResponse.body);
        Utility.showAlertMessage(parsed['error']['message'].toString());
      } else {
        var parsed = jsonDecode(streamResponse.body);
        Utility.showAlertMessage(parsed['error']['message'].toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  apiCreateStoreStripeAccount(BuildContext ctxx) async {
    isLoading.value = true;
    debugPrint(
        "CREATE OWNER STRIPE BANK ACCOUNT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankCreate}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map<String, String> body = {
      "token_id": bankToken.value,
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().userStripeBankCreate,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CREATE OWNER STRIPE BANK ACCOUNT BODY ******* $body");
      debugPrint(
          "CREATE OWNER STRIPE BANK ACCOUNT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        selectedCountry.value = "";
        currencyTextController.clear();
        accountHolderNameTextController.clear();
        accountHolderTypeText.value = "";
        rountingTextController.clear();
        accountNumberTextController.clear();
        Get.back(id: pageIdApp.value);
        // Navigator.of(ctxx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get BANK ACCOUNT List Api
  Future apiGetBankAccountList() async {
    isLoading.value = true;
    debugPrint("GET BANK ACCOUNT LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankList}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET BANK ACCOUNT LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        bankAccountListModel = BankAccountListModel.fromJson(value.body);
        bankAccountList.value = bankAccountListModel.data?.banks ?? [];
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (!value.body['message']
            .toString()
            .toLowerCase()
            .contains("stripe")) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

//Delete Card api
  Future apiDeleteBankAccounts({String userStripeBankId = ""}) async {
    debugPrint(
        "DELETE BANK ACCOUNT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankDelete}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map body = {"user_stripe_bank_id": userStripeBankId};

    debugPrint("DELETE BANK ACCOUNT BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DELETE BANK ACCOUNT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetBankAccountList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetBankAccountList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  apiCreateAutoRecharge(BuildContext ctxx) async {
    isLoading.value = true;
    debugPrint(
        "CREATE AUTO RECHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoCharge}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map<String, String> body = {
      "auto_charge_type": autoChargeType.value,
      "user_stripe_card_id": userStripeCardId!.value,
      "threshold_amount": thresholdAmountTextController.text.trim(),
      "charge_amount": autoChargeType.value == "threshold"
          ? chargeAmountTextController.text.trim()
          : periodChargeAmountTextController.text.trim(),
      "start_date": DateTime.now().toString(),

      // "end_date": autoChargeType.value == "threshold"
      //     ? DateTime(date.year + 1, date.month, date.day).toString()
      //     : endDateTextController.text.trim(),
      "day": day.value,
      "frequency":
          autoChargeType.value == "threshold" ? "1" : selectedFrequency.value
    };
    debugPrint("TOKEN ********** $headers");
    debugPrint("CREATE AUTO RECHARGE BODY ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().userWalletAutoCharge,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CREATE AUTO RECHARGE BODY ******* $body");
      debugPrint("CREATE AUTO RECHARGE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        selectedFrequency.value = "";
        rountingTextController.clear();
        startDateTextController.clear();
        endDateTextController.clear();
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        periodChargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        rountingTextController.clear();
        accountNumberTextController.clear();
        await apiGetAutoRechargeDetail();
        Get.back(id: pageIdApp.value);
        // Navigator.of(ctxx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Auto recharge
  Future apiGetAutoRechargeDetail() async {
    isLoading.value = true;
    debugPrint("GET AUTO RECHARGE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoChargeGet}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoChargeGet}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      log("GET AUTO RECHARGE DETAIL RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        getAutoRechargeModel = GetAutoRechargeModel.fromJson(value?.body);

        if (getAutoRechargeModel.data?.userWalletAutoCharge != null) {
          if (getAutoRechargeModel.data?.userWalletAutoCharge?.status ==
              "active") {
            isautoRechargeEnable.value = true;
            autoChargeType.value = getAutoRechargeModel
                .data!.userWalletAutoCharge!.autoChargeType!;

            thresholdAmountTextController.text = getAutoRechargeModel
                        .data!.userWalletAutoCharge!.thresholdAmount ==
                    null
                ? ""
                : getAutoRechargeModel
                    .data!.userWalletAutoCharge!.thresholdAmount
                    .toString();
            if (getAutoRechargeModel
                    .data!.userWalletAutoCharge!.thresholdAmount ==
                null) {
              periodChargeAmountTextController.text = getAutoRechargeModel
                      .data?.userWalletAutoCharge?.chargeAmount
                      .toString() ??
                  "";
            } else {
              chargeAmountTextController.text = getAutoRechargeModel
                      .data?.userWalletAutoCharge?.chargeAmount
                      .toString() ??
                  "";
            }

            if (getAutoRechargeModel
                    .data!.userWalletAutoCharge!.thresholdAmount ==
                null) {
              if (getAutoRechargeModel.data!.userWalletAutoCharge!.frequency ==
                  7) {
                frequencyTextController.text = "7";
                selectedFrequency.value = "7";
              } else {
                selectedFrequency.value = "30";
                frequencyTextController.text = "30";
              }
            }

            if (getAutoRechargeModel
                    .data!.userWalletAutoCharge!.thresholdAmount ==
                null) {
              autoChargeType.value = "cyclic";
            } else {
              autoChargeType.value = "threshold";
            }
            frequencyTextController.text = getAutoRechargeModel
                .data!.userWalletAutoCharge!.frequency
                .toString();

            day.value = getAutoRechargeModel.data?.userWalletAutoCharge?.day
                    .toString() ??
                "";

            userWalletAutoChargeId.value = getAutoRechargeModel
                .data!.userWalletAutoCharge!.userWalletAutoChargeId
                .toString();

            accountNumberTextController.clear();
          }
        } else {
          isautoRechargeEnable.value = false;
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  apiUpdateAutoRecharge(BuildContext ctxx) async {
    var date = DateTime.now();
    isLoading.value = true;
    debugPrint(
        "UPDATE AUTO RECHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoChargeUpdate}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map<String, String> body = {
      "user_wallet_auto_charge_id": userWalletAutoChargeId.value,
      "auto_charge_type": autoChargeType.value,
      "user_stripe_card_id": userStripeCardId!.value,
      "threshold_amount": thresholdAmountTextController.text.trim(),
      "charge_amount": autoChargeType.value == "threshold"
          ? chargeAmountTextController.text.trim()
          : periodChargeAmountTextController.text.trim(),
      "start_date": DateTime.now().toString(),
      // "end_date": autoChargeType.value == "threshold"
      //     ? DateTime(date.year + 1, date.month, date.day).toString()
      //     : endDateTextController.text.trim(),
      "day": day.value,
      "frequency": autoChargeType.value == "threshold"
          ? "1"
          : selectedFrequency.value.isEmpty
              ? frequencyTextController.text
              : selectedFrequency.value
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .putWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().userWalletAutoChargeUpdate,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("UPDATE AUTO RECHARGE BODY ******* $body");
      debugPrint("UPDATE AUTO RECHARGE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        selectedFrequency.value = "";
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        periodChargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        autoChargeType.value = "";
        rountingTextController.clear();
        accountNumberTextController.clear();
        startDateTextController.clear();
        endDateTextController.clear();
        Get.back(id: pageIdApp.value);
        // Navigator.of(ctxx).pop(ctxx);
        await apiGetAutoRechargeDetail();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

//Delete autocahrge api
  Future apiDisableAutoRecharge() async {
    debugPrint(
        "DISABLE AUTO CHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoChargeDelete}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    Map body = {
      "user_wallet_auto_charge_id": getAutoRechargeModel
          .data!.userWalletAutoCharge!.userWalletAutoChargeId
          .toString()
    };
    debugPrint("DISABLE AUTO CHARGE BODY ************* $body");
    UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutoChargeDelete}",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("DISABLE AUTO CHARGE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        await apiGetAutoRechargeDetail();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetAutoRechargeDetail();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  apiGetAccountDetails() async {
    isLoading.value = true;
    debugPrint("GET STRIPE CONNECTED ACCOUNT DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeConnectedAccountDetails}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeConnectedAccountDetails}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint(
          "GET STRIPE CONNECTED ACCOUNT DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        capability.value =
            value.body["data"]['account']['capabilities']['transfers'];
        payouts.value = value.body["data"]['account']['payouts_enabled'];
        accountLink.value = value.body["data"]['accountLink']['url'];
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }
}
