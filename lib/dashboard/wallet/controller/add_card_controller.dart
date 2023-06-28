import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:http/http.dart' as http;
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/wallet_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddCardController extends GetxController {
  RxString? firstName = "".obs;
  RxString? paymentType = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxInt amount = 0.obs;
  RxInt pageId = 0.obs;
  RxString userName = "".obs;
  RxString phoneNumber = "".obs;
  RxString withoutCodeNumber = "".obs;
  RxString customerId = "".obs;
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxString cardId = ''.obs;
  RxString stripeToken = "".obs;
  RxString selectPaymentType = "".obs;
  RxString? userStripeCardId = "".obs;
  RxString? userWalletBalance = "".obs;
  RxString? userStripeBankId = "".obs;
  RxString? selectedStoreName = "".obs;
  RxString? storeId = "".obs;
  RxString selectedPaymentForFrequency = "".obs;
  RxDouble storeServiceCharge = 0.0.obs;
  RxDouble totalWithdrawAmount = 0.0.obs;
  RxBool isCvvFocused = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? selectedBankAccountIndex = 0.obs;
  RxString selectedCountry = "".obs;
  RxString selectedState = "".obs;
  RxString selectedStore = "".obs;
  RxString? ownerWalletBalance = "0.00".obs;
  RxString stateId = "".obs;
  RxString role = "".obs;
  var kGoogleApiKey = "";
  dynamic lat = 0.0;
  dynamic lng = 0.0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  TextEditingController amountTextController = TextEditingController();
  TextEditingController payoutAmountTextController = TextEditingController();
  TextEditingController addressLine1TextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  late CountryListModel countryListModel = CountryListModel();
  RxList<Countries> countryList = <Countries>[].obs;
  late CardListModel cardListModel = CardListModel();
  RxList<Cards> cardList = <Cards>[].obs;
  late GetUserDetailModel getUserDetailModel = GetUserDetailModel();
  late GetOwnerStoresResponse getStoreListModel = GetOwnerStoresResponse();
  RxList<Stores> storeList = <Stores>[].obs;

  RxList<dynamic> selectedCards = <dynamic>[].obs;

  late BankAccountListModel bankAccountListModel = BankAccountListModel();
  RxList<Banks> bankAccountList = <Banks>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;
  RxString countryId = "".obs;
  RxString capability = "".obs;
  RxBool payouts = false.obs;
  RxString accountLink = "".obs;
  late GlobalConfigs secureData;
  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getGKey() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    kGoogleApiKey = secureData.configs['kGoogleApiKey'];
  }

  getApiData() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
    getGKey();
    await apiGetUserWalletBalance();
    await apiGetCardList(Get.context!);
    await apiGetBankAccountList();
    // await apiGetStoreList();
    await apiGetUserDetailApi(Get.context);
    await apiGetCountries();
    await apiGetAccountDetails();

    // pageId.value =
    //     int.parse(SharedPreferenceStorage.getData("pageId").toString());
  }

  //Get User Detail Info Api
  Future apiGetUserDetailApi(context) async {
    debugPrint(
        "GET USER DETAIL URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userDetail}");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().userDetail,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET USER DETAIL RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getUserDetailModel = GetUserDetailModel.fromJson(value.body);
        List<UserAddresses> userAddress = <UserAddresses>[];
        userAddress = getUserDetailModel.data!.user!.userAddresses!;
        if (userAddress.isNotEmpty) {
          userAddress = getUserDetailModel.data!.user!.userAddresses!;
          for (int i = 0; i < userAddress.length; i++) {
            countryId.value = userAddress[i].state!.country!.countryId ?? "";
            print("countryId.value ----->" + countryId.value);
            // countryDropdownValue.value =
            //     userAddress[i].state!.country!.countryName ?? "";
            selectedCountry.value =
                userAddress[i].state!.country!.countryName ?? "";
            print("selectedCountry.value ----->" + selectedCountry.value);
            // countryTextController.text = countryDropdownValue.value;
            stateTextController.text = userAddress[i].state!.stateName ?? "";
            selectedState.value = userAddress[i].state!.stateName ?? "";
            addressLine1TextController.text = userAddress[i].addressLine1 ?? "";
            //   addressLine1.value = addressLine1TextController.text;
            addressLine2TextController.text = userAddress[i].addressLine2 ?? "";
            //addressLine2.value = addressLine2TextController.text;
            cityTextController.text = userAddress[i].city ?? "";
            print("city.value ----->" + cityTextController.text);
            // city.value = townOrCityTextController.text;
            zipCodeTextController.text = userAddress[i].postalCode ?? "";
            // postalCode.value = postalCodeTextController.text;
            await apiGetCountries();
          }
        }
      } else if (value.body["status"] == 401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message'].toString());
      }
    });
  }

  String token1 =
      "Basic cGtfdGVzdF81MU1uYUpkRlZuTW1IaGtHWW55ZFp2bENoMVhXMlhzNUllczhVc3hiajdNWVhQcUdQTkRuV3BBaDIzR1cyTUg3WUcxRnhjM0p6M2pUYjZkZlRuMjRsSjE0VTAwU3hETEJwSnI6";

  bool validateAndSave() {
    final form = formKey1.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateAndSave2() {
    final form = formKey2.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateAndSave1() {
    final form = formKey1.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

// Fields Validation Method
  Future validateAndSubmitFunction(BuildContext context,
      {bool isFromPayout = false}) async {
    if (validateAndSave1()) {
      try {
        if (selectPaymentType.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectPaymentTypeText);
        } else if (selectPaymentType.value == "Cards" &&
            userStripeCardId!.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
        } else {
          await apiAddMoneyToWallet(context);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  validateAndSavePayOut(BuildContext ctxx) {
    if (validateAndSave2()) {
      try {
        if (storeId!.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectStore);
        } else {
          apiCreatePayout(ctxx);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  bool validateAndSaveCard() {
    final form1 = formKey.currentState;
    if (form1!.validate()) {
      form1.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmitCard(BuildContext ctx) async {
    if (validateAndSaveCard()) {
      try {
        apiCreateStripeToken(ctx);
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Get Countries Api
  Future apiGetCountries() async {
    countryList.clear();
    debugPrint(
        "GET COUNTRIES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().countries}");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        // apiGetStates();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

  //Get States Api
  Future apiGetStates() async {
    statesList.clear();
    debugPrint(
        "GET STATES URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId");

    Map<String, String> headers = {
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().states}?country_id=$countryId",
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET STATES RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        getStateModel = GetStatesModel.fromJson(value.body);
        statesList.value = getStateModel.data!.states!;
        if (stateId.value.isNotEmpty) {
          for (int i = 0; i < statesList.length; i++) {
            if (stateId.value == statesList[i].stateId) {
              stateId.value = statesList[i].stateId.toString();
            }
          }
        } else {
          stateId.value = statesList[0].stateId.toString();
        }
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  // //Get Store List Api
  // Future apiGetStoreList() async {
  //   isLoading.value = true;
  //   debugPrint(
  //       "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().ownersStoreList}");
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': "Bearer ${authToken.value.toString()}",
  //   };
  //   debugPrint("TOKEN ********** $headers");
  //   UserProvider()
  //       .getWithHeadersApi(
  //           ServerCommunicator().baseUrl + ServerCommunicator().ownersStoreList,
  //           headers,
  //           showLoading: false)
  //       .then((value) async {
  //     isLoading.value = false;
  //     debugPrint("GET STORE RESPONSE *******${value!.body}");
  //     if (value.body["status"] == ApiConstants.statusCode200 ||
  //         value.body["status"] == ApiConstants.statusCode201) {
  //       getStoreListModel = GetOwnerStoresResponse.fromJson(value.body);
  //       storeList.clear();
  //       storeList.addAll(getStoreListModel.data as Iterable<Stores>);
  //       Get.parameters["storeCount"] = storeList.length.toString();
  //     } else if (value.body["status"] == ApiConstants.statusCode401) {
  //       Utility.showAlertMessage(value.body['message']);
  //       SharedPreferenceStorage.clearData();
  //       await Get.offAll(const StartJourneyScreen());
  //       // await Get.offAll(const StartJourneyScreen());
  //     } else {
  //       if (value.body['message'] != null) {
  //         Utility.showAlertMessage(value.body['message']);
  //       }
  //     }
  //   });
  // }

  Future<void> apiCreateStripeToken(context) async {
    var str = expiryDate.value;
    var parts = str.split('/');
    var month = parts[0].trim();
    var year = parts[1].trim();
    try {
      var headers = {
        'Authorization': token1,
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request(
          'POST', Uri.parse(ServerCommunicator().createStripeToken));
      request.bodyFields = {
        'card[number]': cardNumber.value,
        'card[exp_month]': month,
        'card[exp_year]': year,
        'card[cvc]': cvvCode.value,
        'card[address_line1]': addressLine1TextController.text.trim(),
        'card[address_line2]': addressLine2TextController.text.trim(),
        'card[address_city]': cityTextController.text.trim(),
        'card[address_zip]': zipCodeTextController.text.trim(),
        'card[address_state]': selectedState.value,
        'card[address_country]': selectedCountry.value
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var streamResponse = await http.Response.fromStream(response);
      debugPrint("Create Stripe Token Response:--------");
      debugPrint(response.statusCode.toString());
      debugPrint(response.reasonPhrase);
      if (response.statusCode == 200) {
        var parsed = jsonDecode(streamResponse.body);
        stripeToken.value = parsed['id'].toString();
        await apiCreateCard(context);
        str = "";
        parts = [];
        month = "";
        year = "";
      } else if (response.statusCode == 402) {
        Utility.showAlertMessage(AlertStringConstants.pleaseEnterValidCardText);
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
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        // if (value.body['success'] == true ||
        //  value.body['status'] == ApiConstants.statusCode201 ||
        //             value.body['status'] == ApiConstants.statusCode200) {
        if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          Utility.showToast(value.body['message']);
          await apiGetCardList(context);
          cardNumber.value = "";
          expiryDate.value = "";
          cardHolderName.value = "";
          cvvCode.value = "";
          isCvvFocused.value = false;
          amount = 0.obs;
          userName = "".obs;
          phoneNumber = "".obs;
          withoutCodeNumber = "".obs;
          customerId = "".obs;
          cardNumber = ''.obs;
          expiryDate = ''.obs;
          cardHolderName = ''.obs;
          cvvCode = ''.obs;
          cardId = ''.obs;
          stripeToken.value = "";
          isCvvFocused = false.obs;
          addressLine1TextController.clear();
          addressLine2TextController.clear();
          cityTextController.clear();
          zipCodeTextController.clear();
          stateTextController.clear();
          selectedCountry.value = "";
          selectedState.value = "";
          countryId.value = "";
          stateId.value = "";
          // Get.back();
          Get.back(id: pageIdApp.value);
          // Navigator.of(context).pop();
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
        } else {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetCardList(context) async {
    userStripeCardId?.value = "";
    cardList.clear();
    isLoading.value = true;
    debugPrint("GET CARD LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardList}",
            headers,
            showLoading: true)
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
        Get.offAll(const StartJourneyScreen());
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

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
          // Navigator.pop(ctx);
          Get.back(id: pageIdApp.value);
          userStripeCardId!.value = "";
          amountTextController.clear();
          selectPaymentType.value = "";
          selectPaymentType.value.isEmpty;
          userStripeCardId!.value.isEmpty;
          paymentType!.value = "";
          paymentType!.value.isEmpty;

          update();
          Utility.showToast(value.body['message']);
          // return true;
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
        } else {
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetUserWalletBalance() async {
    isLoading.value = true;
    debugPrint("GET USER WALLET BALANCE URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET USER WALLET BALANCE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        userWalletBalance!.value =
            value.body['data']['balance'].toStringAsFixed(2);
        update();
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

//Delete Card api
  Future apiDeleteCard({String userStripeCardId = ""}) async {
    debugPrint(
        "DELETE CARD URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeCardDelete}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        await apiGetCardList(Get.context!);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetCardList(Get.context!);
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

  //Get BANK ACCOUNT List Api
  Future apiGetBankAccountList() async {
    isLoading.value = true;
    debugPrint("GET BANK ACCOUNT LIST URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeBankList}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        Get.offAll(const StartJourneyScreen());
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

//Api create payout
  apiCreatePayout(BuildContext ctxxx) async {
    debugPrint(
        "CREATE PAYOUT API *******${ServerCommunicator().baseUrl + ServerCommunicator().storeStripePayoutCreate}");
    Map body = {
      "store_id": int.parse(storeId!.value),
      "user_stripe_bank_id": int.parse(userStripeBankId!.value),
      "amount": double.parse(payoutAmountTextController.text.trim())
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("CREATE PAYOUT API BODY *******$body");
    debugPrint("CREATE PAYOUT API HEADERS *******$headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeStripePayoutCreate,
            headers,
            showLoading: true)
        .then((value) async {
      if (value != null) {
        debugPrint("CREATE PAYOUT API RESPONSE *******${value.body}");
        if (value.body['success'] == true ||
            value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          ownerWalletBalance!.value = "";
          storeId!.value = "";
          Get.back(id: pageIdApp.value);
          // Navigator.of(ctxxx).pop();
          Utility.showToast(value.body['message']);
        } else if (value.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);
          SharedPreferenceStorage.clearData();
          Get.offAll(const StartJourneyScreen());
        } else if (value.body["status"] == ApiConstants.statusCode409) {
          Utility.showAlertMessage(value.body['message']);
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          ownerWalletBalance!.value = "";
          storeId!.value = "";
        } else {
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  //Get Store service charge
  Future apiGetStoreServiceCharge() async {
    isLoading.value = true;
    debugPrint(
        "GET STORE SERVICE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeServiceCharge}?store_id=${storeId!.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeServiceCharge}?store_id=${storeId!.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE SERVICE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        if (value?.body['data']['service_charge_value'] is int ||
            value?.body['data']['service_charge_value'] is String) {
          storeServiceCharge.value = double.parse(
              value!.body['data']['service_charge_value'].toString());
        } else {
          storeServiceCharge.value =
              value?.body['data']['service_charge_value'];
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
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

  //Get Owner Balance Api
  Future apiGetOwnerWalletBalance() async {
    isLoading.value = true;
    debugPrint(
        "GET OWNER WALLET BALANCE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeWalletBalance}?store_id=${selectedStore.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeWalletBalance}?store_id=${selectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET OWNER WALLET BALANCE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        if (value?.body['data']['balance'] != null) {
          ownerWalletBalance!.value =
              value?.body['data']['balance'].toStringAsFixed(2);
        } else {
          ownerWalletBalance!.value = "0.00";
        }

        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
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

  apiGetAccountDetails() async {
    isLoading.value = true;
    debugPrint("GET STRIPE CONNECTED ACCOUNT DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().userStripeConnectedAccountDetails}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${authToken.value.toString()}",
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
        Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value.body['message']);
      }
    });
  }
}
