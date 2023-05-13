import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/bank_account_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/get_cardlist_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:http/http.dart' as http;
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddCardController extends GetxController {
  RxString? firstName = "".obs;
  RxString? paymentType = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxInt amount = 0.obs;
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
  RxInt amount = 0.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController amountTextController = TextEditingController();
  TextEditingController payoutAmountTextController = TextEditingController();

  late CardListModel cardListModel = CardListModel();
  RxList<Cards> cardList = <Cards>[].obs;

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  RxList<dynamic> selectedCards = <dynamic>[].obs;

  late BankAccountListModel bankAccountListModel = BankAccountListModel();
  RxList<Banks> bankAccountList = <Banks>[].obs;

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    await apiGetUserWalletBalance();
    await apiGetCardList();
    await apiGetBankAccountList();
    await apiGetStoreList();
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
  void validateAndSubmit(context,{bool isFromPayout = false}) async {
    if (validateAndSave()) {
      try {
        if (isFromPayout == false) {
          if (selectPaymentType.isEmpty) {
            Utility.showToast(AlertStringConstants.pleaseSelectPaymentTypeText);
          } else if (selectPaymentType.value == "Cards" &&
              userStripeCardId!.value.isEmpty) {
            Utility.showToast(AlertStringConstants.pleaseSelectCardText);
          } else {
            await apiAddMoneyToWallet(context);
          }
        } else {
          if (storeId!.value.isEmpty) {
            Utility.showToast(AlertStringConstants.pleaseSelectStore);
          } else {
            apiCreatePayout();
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

  //Get Store List Api
  Future apiGetStoreList() async {
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
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
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
        Utility.showToast(AlertStringConstants.pleaseEnterValidCardText);
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
        // if (value.body['success'] == true ||
        //  value.body['code'] == ApiConstants.statusCode201 ||
        //             value.body['code'] == ApiConstants.statusCode200) {
        if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
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

          // Get.back();
          Navigator.of(context).pop();
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showToast(value.body['message']);
        } else {
          Utility.showToast(value.body['message']);
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetCardList(context) async {
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
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET CARD LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        cardListModel = CardListModel.fromJson(value.body);
        cardList.value = cardListModel.data!.cards ?? [];

        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
         await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (!value.body['message']
            .toString()
            .toLowerCase()
            .contains("stripe")) {
          Utility.showToast(value.body['message']);
        }
      }
    });
  }

// Add Money to stripe wallet
  apiAddMoneyToWallet(context) {
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
        if (value.body['success'] == true ||
            value.body['code'] == ApiConstants.statusCode201 ||
            value.body['code'] == ApiConstants.statusCode200) {
          userStripeCardId!.value = "";
          amountTextController.clear();
          selectPaymentType.value = "";
          selectPaymentType.value.isEmpty;
          userStripeCardId!.value.isEmpty;
          // Get.back();
          Navigator.of(context).pop();
          Utility.showToast(value.body['message']);
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showToast(value.body['message']);
        } else {
          Utility.showToast(value.body['message']);
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
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().userWalletBalance}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET USER WALLET BALANCE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        userWalletBalance!.value =
            value.body['data']['balance'].toStringAsFixed(2);
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
         await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

//Delete Card api
  Future apiDeleteCard({String userStripeCardId = ""}) async {
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
        await apiGetCardList(Get.context!);
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
        await apiGetCardList(Get.context!);
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
         await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
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
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET BANK ACCOUNT LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        bankAccountListModel = BankAccountListModel.fromJson(value.body);
        bankAccountList.value = bankAccountListModel.data?.banks ?? [];
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        if (!value.body['message']
            .toString()
            .toLowerCase()
            .contains("stripe")) {
          Utility.showToast(value.body['message']);
        }
      }
    });
  }

//Api create payout
  apiCreatePayout() {
    debugPrint(
        "CREATE PAYOUT API *******${ServerCommunicator().baseUrl + ServerCommunicator().storeStripePayoutCreate}");
    Map body = {
      "store_id": storeId!.value,
      "user_stripe_bank_id": userStripeBankId!.value,
      "amount": payoutAmountTextController.text.trim()
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
            value.body['code'] == ApiConstants.statusCode201 ||
            value.body['code'] == ApiConstants.statusCode200) {
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          Get.back();
          Utility.showToast(value.body['message']);
        } else if (value.body["status"] == ApiConstants.statusCode401) {
          Utility.showToast(value.body['message']);
          SharedPreferenceStorage.clearData();
          await Get.offAll(const StartJourneyScreen());
        } else if (value.body["status"] == ApiConstants.statusCode409) {
          Utility.showToast(value.body['message']);
        } else {
          Utility.showToast(value.body['message']);
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
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
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
          storeServiceCharge.value =
              double.parse(value?.body['data']['service_charge_value']);
        } else {
          storeServiceCharge.value =
              value?.body['data']['service_charge_value'];
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        String msg = value!.body["message"].toString().toLowerCase();
        if (msg.contains("store not found")) {
          Utility.showToast("Please select store");
        } else {
          Utility.showToast(value.body['message'].toString());
        }
      }
    });
  }
}
