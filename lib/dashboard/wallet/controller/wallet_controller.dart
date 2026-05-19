import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/model/categories_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
import 'package:thegreenmall/dashboard/wallet/model/wallet_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class WalletController extends GetxController with GlobalVarMixin{
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;

  SharedPreferenceStorage storage = SharedPreferenceStorage();

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
  RxString? userWalletBalance = "0.00".obs;
  RxString? ownerWalletBalance = "0.00".obs;
  RxString? storeNameValue = "".obs;
  RxString autoChargeType = "threshold".obs;
  RxString? startFormattedDate = "".obs;
  RxString? endFormattedDate = "".obs;
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
  RxBool isOwnerWalletBalanceLoading = false.obs;
  RxBool isStoresLoading = false.obs;
  RxBool isAutoRechargeEnable = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? type = 0.obs;

  RxBool isFromCartScreen = false.obs;
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());
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

  TextEditingController routingTextController = TextEditingController();
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
    Categories(id: 1, name: StringConstants.mondayText, isSelected: false),
    Categories(id: 2, name: StringConstants.tuesdayText, isSelected: false),
    Categories(id: 3, name: StringConstants.wednesdayText, isSelected: false),
    Categories(id: 4, name: StringConstants.thursdayText, isSelected: false),
    Categories(id: 5, name: StringConstants.fridayText, isSelected: false),
    Categories(id: 6, name: StringConstants.saturdayText, isSelected: false),
    Categories(id: 7, name: StringConstants.sundayText, isSelected: false),
  ].obs;

  RxString capability = "".obs;
  RxBool payouts = false.obs;
  RxString accountLink = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Skip API calls for guest users
      if (isGuest.value == true) {
        return;
      }
      if (Get.parameters["isController"] != "no") {
        if (roleApp.value == Role.customerRoleText) {
          searchStoreUserController.apiActiveCartApi();
        }

        getPage();
      }
    });
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";
    role?.value = roleApp.value;
    autoChargeType.value = "threshold";
    if (role?.value == Role.customerRoleText) {
      // if (Get.parameters['isFromCartScreen'] != "false") {
      //   isFromCartScreen.value =
      //       Get.parameters["isFromCartScreen"] == "true" ? true : false;
      // }
      getApiData();
    } else {
      await apiGetCardList();
      await apiGetBankAccountList();
      await apiGetStoreList();
      await apiGetAccountDetails();
    }
    update();
  }

  getApiData() async {
    await apiGetCardList();
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
  void validateAndSubmit(
      {bool isFromCreateOwnerBankBalance = false,
      bool updateAutoData = false,
      isFromAutoRecharge = false}) async {
    if (isFromAutoRecharge == true) {
      if (validateAndSaveAutoCharge()) {
        try {
          if (autoChargeType.value.isEmpty) {
            Utility.showAlertMessage(
                AlertStringConstants.pleaseSelectAutoReloadText);
          } else if (autoChargeType.value ==
                  StringConstants.thresholdText.toLowerCase() &&
              chargeAmountTextController.text.isEmpty) {
            Utility.showAlertMessage(
                AlertStringConstants.pleaseEnterChargeAmountText);
          } else if (autoChargeType.value ==
                  StringConstants.thresholdText.toLowerCase() &&
              thresholdAmountTextController.text.isEmpty) {
            Utility.showAlertMessage(
                AlertStringConstants.pleaseEnterAmountText);
          } else if (autoChargeType.value !=
                  StringConstants.thresholdText.toLowerCase() &&
              selectedFrequency.value.isEmpty) {
            Utility.showAlertMessage(
                AlertStringConstants.pleaseSelectPaymentTypeText);
          } else if (autoChargeType.value !=
                  StringConstants.thresholdText.toLowerCase() &&
              day.value.isEmpty) {
            Utility.showAlertMessage(AlertStringConstants.pleaseSelectDayText);
          } else if (userStripeCardId!.value.isEmpty) {
            Utility.showAlertMessage(AlertStringConstants.pleaseAddCardText);
          } else if (updateAutoData == true) {
            apiUpdateAutoRecharge();
          } else {
            apiCreateAutoRecharge();
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
          await apiAddMoneyToWallet();
        }
      } else {
        autoValidate.value = true;
      }
    } else {
      if (accountHolderTypeText.isEmpty) {
        Utility.showAlertMessage(
            AlertStringConstants.pleaseSelectAccountHolderTypeText);
      } else {
        apiCreateBankToken();
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

  ///Get Store Details Api
  Future apiGetStoreDetailsApi() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.shopStoreDetails}?store_id=${ownerSelectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
        dynamicLink.value =
            storeDetailsResponse.value.data!.store!.dynamicLink.toString();
               } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Countries Api
  Future apiGetCountries() async {
    countryList.clear();
     
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.countries,
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        countryListModel = CountryListModel.fromJson(value?.body);
        countryList.value = countryListModel.data!.countries!;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Store List Api
  Future apiGetStoreList() async {
    storeList.clear();
    isStoresLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.ownersStoreList,
            headers,
            showLoading: false)
        .then((value) async {
      isStoresLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetOwnerStoresResponse.fromJson(value?.body);
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
            apiGetOwnerWalletBalance();
          }
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Crate Stripe Token
  Future<void> apiCreateStripeToken() async {
    var str = expiryDate.value;
    var parts = str.split('/');
    var month = parts[0].trim();
    var year = parts[1].trim();
    try {
      isLoading.value = true;
      var headers = {
        StringConstants.authorizationText:
            'Basic ${ServerCommunicator.stripeCardBasicAuth}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request(
          'POST', Uri.parse(ServerCommunicator.createStripeToken));
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
        await apiCreateCard();
      } else {
        isLoading.value = false;
        var parsed = jsonDecode(streamResponse.body);
        String errorMessage = parsed['error']?['message'] ?? 'Failed to create Stripe token';
        Utility.showAlertMessage(errorMessage);
      }
    } catch (error) {
      isLoading.value = false;
      Utility.showAlertMessage('Failed to create Stripe token: ${error.toString()}');
    }
  }

  ///Api Create Card
  Future apiCreateCard() async {
         Map body = {"token_id": stripeToken.value};

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl + ServerCommunicator.createCard,
            headers,
            showLoading: false)
        .then((value) async {
      if (value != null) {
                 if (value.body['success'] == true ||
            value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          Utility.showToast(value.body['message']);
          Get.back(id: pageIdApp.value);
          await apiGetCardList();
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
        } else {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Card List Api
  Future apiGetCardList() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userStripeCardList}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        cardListModel = CardListModel.fromJson(value?.body);
        cardList.value = cardListModel.data?.cards ?? [];
        isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear(); isLoading.value = false;
        Utility.handle401Error();
      } else { isLoading.value = false;
        if (value?.body['message']
                .toString()
                .toLowerCase()
                .contains("stripe") !=
            true) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  /// Add Money to stripe wallet
  Future apiAddMoneyToWallet() async {
    final String finalStripeCardId = userStripeCardId?.value.toString().trim() ?? "";
    if (finalStripeCardId.isEmpty) {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
      return;
    }

    isLoading.value = true;
         Map body = {
      "user_stripe_card_id": finalStripeCardId,
      "amount": amountTextController.text.trim()
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.userWalletRechargeStripe,
            headers,
            showLoading: false)
        .then((value) async {
      if (value != null) {

                 if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          userStripeCardId!.value = "";
          amountTextController.clear();
          selectPaymentType.value = "";
          selectPaymentType.value.isEmpty;
          isLoading.value = false;
          userStripeCardId!.value.isEmpty;
          Future.delayed(const Duration(seconds: 1), () {
            Get.back(id: pageIdApp.value);
          });
          Utility.showToast(value.body['message']);
        } else if (value.statusCode == ApiConstants.statusCode401) {
                   isLoading.value = false;
          Utility.showAlertMessage(value.body['message']);
        } else {
                   isLoading.value = false;
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Card List Api
  Future apiGetUserWalletBalance() async {
    userWalletBalance!.value = "";
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {isLoading.value = false;

             final balance = value?.body['data']['balance'];
             userWalletBalance!.value = balance != null
                 ? balance.toStringAsFixed(2)
                 : "0.00"; // or handle however you want
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();isLoading.value = false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Card api
  Future apiDeleteCard({String userStripeCardId = ""}) async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {"user_stripe_card_id": userStripeCardId};

         UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userStripeCardDelete}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) { isLoading.value = false;
        Utility.showToast(value?.body['message']);
        await apiGetCardList();
      } else if (value?.body["status"] == ApiConstants.statusCode409) { isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        await apiGetCardList();
      } else if (value?.body["status"] == ApiConstants.statusCode401) { isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else { isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Owner Balance Api
  Future apiGetOwnerWalletBalance() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeWalletBalance}?store_id=${ownerSelectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {  isLoading.value = false;
             final balance = value?.body['data']['balance'];
             ownerWalletBalance!.value =
             balance != null ? balance.toStringAsFixed(2) : '0.00';

             update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {  isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        String msg = value?.body["message"].toString().toLowerCase() ?? "";
        if (msg.contains("store not found")) {  isLoading.value = false;
          Utility.showAlertMessage("Please select store");
        } else {  isLoading.value = false;
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
        }
      }
    });
  }

  /// Create Bank Token
  Future<void> apiCreateBankToken() async {
    isLoading.value = true;
    try {
      var headers = {
        StringConstants.authorizationText:
            'Basic ${ServerCommunicator.stripeBankBasicAuth}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request =
          http.Request('POST', Uri.parse(ServerCommunicator.createBankToken));
      request.bodyFields = {
        'bank_account[country]': selectedCountry.value.trim(),
        'bank_account[currency]': "USD",
        'bank_account[account_holder_name]':
            accountHolderNameTextController.text.trim(),
        'bank_account[account_holder_type]': accountHolderTypeText.value,
        'bank_account[routing_number]': routingTextController.text.trim(),
        'bank_account[account_number]': accountNumberTextController.text.trim()
      };
             request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var streamResponse = await http.Response.fromStream(response);
                     
      if (response.statusCode == 200) {
        var parsed = jsonDecode(streamResponse.body);

        bankToken.value = parsed['id'].toString();
        isLoading.value = false;
        apiCreateStoreStripeAccount();
      } else if (response.statusCode == 400) {  isLoading.value = false;
        var parsed = jsonDecode(streamResponse.body);
        Utility.showAlertMessage(parsed['error']['message'].toString());
      } else {  isLoading.value = false;
        var parsed = jsonDecode(streamResponse.body);
        Utility.showAlertMessage(parsed['error']['message'].toString());
      }
    } catch (error) {  isLoading.value = false;
           }
  }

  Future apiCreateStoreStripeAccount() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map<String, String> body = {
      "token_id": bankToken.value,
    };
         UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.userStripeBankCreate,
            headers,
            showLoading: false)
        .then((value) async {

                    if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value?.body['message']);
        selectedCountry.value = "";
        currencyTextController.clear();
        accountHolderNameTextController.clear();
        accountHolderTypeText.value = "";
        routingTextController.clear();
        accountNumberTextController.clear();
        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();isLoading.value = false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get BANK ACCOUNT List Api
  Future apiGetBankAccountList() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userStripeBankList}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {  isLoading.value = false;
        bankAccountListModel = BankAccountListModel.fromJson(value?.body);
        bankAccountList.value = bankAccountListModel.data?.banks ?? [];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {  isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {  isLoading.value = false;
        if (value?.body['message']
                .toString()
                .toLowerCase()
                .contains("stripe") !=
            true) {  isLoading.value = false;
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete Card api
  Future apiDeleteBankAccounts({String userStripeBankId = ""}) async {
    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {"user_stripe_bank_id": userStripeBankId};

         UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userStripeBankDelete}",
            headers,
            showLoading: false)
        .then((value) async {  isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        await apiGetBankAccountList();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {  isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        await apiGetBankAccountList();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {  isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {  isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Auto Recharge
  Future apiCreateAutoRecharge() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.userWalletAutoCharge,
            headers,
            showLoading: false)
        .then((value) async {

                    if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) { isLoading.value = false;
        Utility.showToast(value?.body['message']);
        routingTextController.clear();
        startDateTextController.clear();
        endDateTextController.clear();
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        periodChargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        routingTextController.clear();
        accountNumberTextController.clear();
        await apiGetAutoRechargeDetail();
        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode401) { isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) { isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      } else { isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Auto recharge
  Future apiGetAutoRechargeDetail() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userWalletAutoChargeGet}",
            headers,
            showLoading: false)
        .then((value) async {

              if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {isLoading.value = false;
        getAutoRechargeModel = GetAutoRechargeModel.fromJson(value?.body);

        if (getAutoRechargeModel.data?.userWalletAutoCharge != null) {isLoading.value = false;
          if (getAutoRechargeModel.data?.userWalletAutoCharge?.status ==
              "active") {
            isAutoRechargeEnable.value = true;
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
            if (getAutoRechargeModel.data?.userWalletAutoCharge?.frequency ==
                7) {
              frequencyTextController.text = "7";
              selectedFrequency.value = "7";
            } else {
              selectedFrequency.value = "30";
              frequencyTextController.text = "30";
            }

            if (getAutoRechargeModel
                    .data!.userWalletAutoCharge!.thresholdAmount ==
                null) {
              autoChargeType.value = "cyclic";
            } else {
              autoChargeType.value = "threshold";
            }

            day.value =
                getAutoRechargeModel.data?.userWalletAutoCharge?.day != null
                    ? getAutoRechargeModel.data?.userWalletAutoCharge?.day
                            .toString() ??
                        ""
                    : "";

            userWalletAutoChargeId.value = getAutoRechargeModel
                .data!.userWalletAutoCharge!.userWalletAutoChargeId
                .toString();

            accountNumberTextController.clear();
          }
        } else {
          isAutoRechargeEnable.value = false;
        }isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Update Auto Recharge
  Future apiUpdateAutoRecharge() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
         UserProvider()
        .putWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.userWalletAutoChargeUpdate,
            headers,
            showLoading: false)
        .then((value) async {

                    if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value?.body['message']);
        selectedFrequency.value = "";
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        periodChargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        autoChargeType.value = "";
        routingTextController.clear();
        accountNumberTextController.clear();
        startDateTextController.clear();
        endDateTextController.clear();
        Get.back(id: pageIdApp.value);
        isLoading.value = false;
        await apiGetAutoRechargeDetail();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Delete autoCharge api
  Future apiDisableAutoRecharge() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map body = {
      "user_wallet_auto_charge_id": getAutoRechargeModel
          .data!.userWalletAutoCharge!.userWalletAutoChargeId
          .toString()
    };
         UserProvider()
        .deleteWithHeadersApi(
            body,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userWalletAutoChargeDelete}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {isLoading.value = false;
        Utility.showToast(value?.body['message']);
        await apiGetAutoRechargeDetail();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        await apiGetAutoRechargeDetail();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value = false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Get Account Details
  Future apiGetAccountDetails() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.userStripeConnectedAccountDetails}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {isLoading.value = false;
        capability.value =
            value?.body["data"]['account']['capabilities']['transfers'];
        payouts.value = value?.body["data"]['account']['payouts_enabled'];
        accountLink.value = value?.body["data"]['accountLink']['url'];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value = false;
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }
}
