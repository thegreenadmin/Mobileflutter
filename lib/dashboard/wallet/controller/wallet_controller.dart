import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_list_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/get_cardlist_model.dart';
import 'package:thegreenmall/dashboard/wallet/view/webview_screen.dart';
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
  RxBool isCvvFocused = false.obs;
  RxString request = "".obs;
  RxString eventId = "".obs;
  RxString requestId = "".obs;
  RxString postalCode = "".obs;
  RxBool isCashWithdrawal = false.obs;
  RxBool isAcceptReqCase = false.obs;
  RxBool isPaymentDone = false.obs;
  RxBool autoValidate = false.obs;
  RxBool isLoading = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? type = 0.obs;
  RxString ownerSelectedStore = "".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();

  late CardListModel cardListModel = CardListModel();
  RxList<Cards> cardList = <Cards>[].obs;

  RxList<dynamic> selectedCards = <dynamic>[].obs;

  RxString selectPaymentType = "".obs;
  RxString? userStripeCardId = "".obs;
  RxString? userWalletBalance = "".obs;
  RxString? ownerWalletBalance = "0.00".obs;
  RxString? storeNameValue = "".obs;

  late GetStoreListModel getStoreListModel = GetStoreListModel();
  RxList<Stores> storeList = <Stores>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      apiGetCardList();
      apiGetUserWalletBalance();
    } else {
      apiGetStoreList();
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
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (selectPaymentType.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectPaymentTypeText);
        } else if (selectPaymentType.value == "Cards" &&
            userStripeCardId!.value.isEmpty) {
          Utility.showToast(AlertStringConstants.pleaseSelectCardText);
        } else {
          await apiAddMoneyToWallet();
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
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<Stores>);
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  Future<void> apiCreateStripeToken() async {
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
        await apiCreateCard();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

//Api Create Card
  Future apiCreateCard() async {
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
            value.body['code'] == ApiConstants.statusCode201 ||
            value.body['code'] == ApiConstants.statusCode200) {
          Get.back();
          await apiGetCardList();
        } else if (value.statusCode == ApiConstants.statusCode403) {
          Utility.showToast(value.body['message']);
        } else {
          Utility.showToast(value.body['message']);
        }
      }
    });
  }

  //Get Card List Api
  Future apiGetCardList() async {
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
        cardList.value = cardListModel.data?.cards ?? [];
        update();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
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

// Add Money to stripe wallet
  apiAddMoneyToWallet() {
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
            Get.back();
          Utility.showToast(value.body['message']);
        } else if (value.statusCode == ApiConstants.statusCode403) {
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
      debugPrint("GET USER WALLET BALANCE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        userWalletBalance!.value =
            value?.body['data']['balance'].toStringAsFixed(2);
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
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
        await apiGetCardList();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showToast(value.body['message']);
        await apiGetCardList();
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
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
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET OWNER WALLET BALANCE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        ownerWalletBalance!.value =
            value?.body['data']['balance'].toStringAsFixed(2);
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  apiCreateStoreStripeAccount() {
    isLoading.value = true;
    debugPrint(
        "CREATE STRIPE ACCOUNT URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeStripeAccountCreate}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map<String, String> body = {"store_id": ownerSelectedStore.value};
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator().baseUrl +
                ServerCommunicator().storeStripeAccountCreate,
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CREATE STRIPE ACCOUNT BODY ******* $body");
      debugPrint("CREATE STRIPE ACCOUNT BODY ******* $value");
      debugPrint("CREATE STRIPE ACCOUNT RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        String url = value.body["data"]['link'] ?? "";
        await Get.to(WebViewExample(
          url: url,
        ));
        ownerSelectedStore.value = "";
      } else if (value.body["status"] == ApiConstants.statusCode403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
