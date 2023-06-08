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
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
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

  late RxString dateOfEvent = "".obs;
  late RxString timeOfEvent = "".obs;

  RxBool isCvvFocused = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxBool isautoRechargeEnable = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? type = 0.obs;

  RxBool isFromCartScreen = false.obs;

  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  late GetAutoRechargeModel getAutoRechargeModel = GetAutoRechargeModel();

  RxList<Stores> storeList = <Stores>[].obs;
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
    autoChargeType.value = "threshold";
    firstName?.value =
        SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
    lastName?.value =
        SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
    role?.value = SharedPreferenceStorage.getData(Role.role.value);
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      if (Get.parameters == null
          ? false
          : Get.parameters['isFromCartScreen'] != "false") {
        isFromCartScreen.value =
            Get.parameters["isFromCartScreen"] == "true" ? true : false;
      }
      getApiData();
    } else {
      apiGetBankAccountList();
      apiGetStoreList();
      apiGetCountries();
      apiGetAccountDetails();
    }
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

  bool validateAndSave() {
    final form = formKey.currentState;
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
      isFromautorecharge = false}) async {
    if (validateAndSave()) {
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
    }
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
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  //Get Countries Api
  Future apiGetCountries() async {
    countryList.clear();
    debugPrint(
        "GET COUNTRIES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
    isLoading.value = true;
    debugPrint(
        "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().storeList,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
          // Get.back();
          Navigator.of(context).pop();
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
  apiAddMoneyToWallet(BuildContext ctx) {
    debugPrint(
        "ADD MONEY TO WALLET URL *******${ServerCommunicator().baseUrl + ServerCommunicator().userWalletRechargeStripe}");
    Map body = {
      "user_stripe_card_id": userStripeCardId!.value,
      "amount": amountTextController.text.trim()
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
          Navigator.of(ctx).pop();
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

//Delete Card api
  Future apiDeleteCard(context, {String userStripeCardId = ""}) async {
    debugPrint(
        "DELETE CARD URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
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

  apiCreateStoreStripeAccount(BuildContext ctxx) {
    isLoading.value = true;
    debugPrint(
        "CREATE OWNER STRIPE BANK ACCOUNT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankCreate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        // Get.back();
        Navigator.of(ctxx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(ctxx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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

  //Get BANK ACCOUNT List Api
  Future apiGetBankAccountList() async {
    isLoading.value = true;
    debugPrint("GET BANK ACCOUNT LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  apiCreateAutoRecharge(BuildContext ctxx) {
    var date = DateTime.now();
    isLoading.value = true;
    debugPrint(
        "CREATE AUTO RECHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutocharge}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map<String, String> body = {
      "auto_charge_type": autoChargeType.value,
      "user_stripe_card_id": userStripeCardId!.value,
      "threshold_amount": thresholdAmountTextController.text.trim(),
      "charge_amount": chargeAmountTextController.text.trim(),
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
                ServerCommunicator().userWalletAutocharge,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CREATE AUTO RECHARGE BODY ******* $body");
      debugPrint("CREATE AUTO RECHARGE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        autoChargeType.value = "";
        rountingTextController.clear();
        accountNumberTextController.clear();
        await apiGetAutoRechargeDetail();
        // Get.back();
        Navigator.of(ctxx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(ctxx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutochargeGet}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutochargeGet}",
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

            chargeAmountTextController.text = getAutoRechargeModel
                        .data!.userWalletAutoCharge!.chargeAmount ==
                    null
                ? ""
                : getAutoRechargeModel.data!.userWalletAutoCharge!.chargeAmount
                    .toString();

            if (getAutoRechargeModel.data!.userWalletAutoCharge!.frequency ==
                1) {
              frequencyTextController.text = "7";
            }
            selectedFrequency.value = frequencyTextController.text =
                getAutoRechargeModel.data!.userWalletAutoCharge!.frequency
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
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  apiUpdateAutoRecharge(BuildContext ctxx) {
    var date = DateTime.now();
    isLoading.value = true;
    debugPrint(
        "UPDATE AUTO RECHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutochargeUpdate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map<String, String> body = {
      "user_wallet_auto_charge_id": userWalletAutoChargeId.value,
      "auto_charge_type": autoChargeType.value,
      "user_stripe_card_id": userStripeCardId!.value,
      "threshold_amount": thresholdAmountTextController.text.trim(),
      "charge_amount": chargeAmountTextController.text.trim(),
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
                ServerCommunicator().userWalletAutochargeUpdate,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("UPDATE AUTO RECHARGE BODY ******* $body");
      debugPrint("UPDATE AUTO RECHARGE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        thresholdAmountTextController.clear();
        chargeAmountTextController.clear();
        accountHolderNameTextController.clear();
        autoChargeType.value = "";
        rountingTextController.clear();
        accountNumberTextController.clear();
        startDateTextController.clear();
        endDateTextController.clear();
        Navigator.of(ctxx).pop(ctxx);
        await apiGetAutoRechargeDetail();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(ctxx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
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
        "DISABLE AUTO CHARGE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutochargeDelete}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletAutochargeDelete}",
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
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  apiGetAccountDetails() {
    isLoading.value = true;
    debugPrint("GET STRIPE CONNECTED ACCOUNT DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeConnectedAccountDetails}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }
}
