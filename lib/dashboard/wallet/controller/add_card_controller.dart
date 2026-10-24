import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
// import 'package:google_maps_webservice/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/dashboard/offers/model/get_user_detail_model.dart';
import 'package:thegreenmall/dashboard/wallet/model/wallet_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/stripe_error_mapper.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class AddCardController extends GetxController with GlobalVarMixin{

  SharedPreferenceStorage storage = SharedPreferenceStorage();

  // RxString? firstName = "".obs;
  RxString? paymentType = "".obs;
  // RxString? lastName = "".obs;
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
  RxBool isStoreLoading = false.obs;
  RxInt? selectedIndex = 0.obs;
  RxInt? selectedBankAccountIndex = 0.obs;
  RxString selectedCountry = "".obs;
  RxString selectedState = "".obs;
  RxString selectedStore = "".obs;
  RxString storeNameValue = "".obs;
  RxString? ownerWalletBalance = "0.00".obs;
  RxString stateId = "".obs;
  RxString role = "".obs;
  var kGoogleApiKey = "";
  dynamic lat = 0.0;
  dynamic lng = 0.0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  TextEditingController amountTextController = TextEditingController();
  TextEditingController ownerAmountTextController = TextEditingController();
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
  RxList<Datum> storeList = <Datum>[].obs;

  RxList<dynamic> selectedCards = <dynamic>[].obs;

  late BankAccountListModel bankAccountListModel = BankAccountListModel();
  RxList<Banks> bankAccountList = <Banks>[].obs;

  late GetStatesModel getStateModel = GetStatesModel();
  RxList<StatesList> statesList = <StatesList>[].obs;
  RxList<PaymentItem> paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '0.0',
      status: PaymentItemStatus.unknown,
    )
  ].obs;
  RxString countryId = "".obs;
  RxString capability = "".obs;
  RxBool payouts = false.obs;
  RxString accountLink = "".obs;
  late GlobalConfigs secureData;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      kGoogleApiKey = ServerCommunicator.kGoogleApiKey;
      getApiData();
    });

  }

  getGKey() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    // kGoogleApiKey = secureData.configs['kGoogleApiKey'];

  }

  getApiData() async {
    firstName.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role.value = roleVal;
    getGKey();
    await apiGetUserWalletBalance();

    if (roleApp.value == Role.storeOwnerRoleText) {

      await apiGetStoreList();
    }
    await apiGetCardList();
    await apiGetBankAccountList();
    await apiGetUserDetailApi();
    // await apiGetCountries();
    await apiGetAccountDetails();
  }

  //Get User Detail Info Api
  Future apiGetUserDetailApi() async {
    isLoading.value= true;
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            ServerCommunicator.baseUrl + ServerCommunicator.userDetail,
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        getUserDetailModel = GetUserDetailModel.fromJson(value?.body);
        List<UserAddresses> userAddress = <UserAddresses>[];
        userAddress = getUserDetailModel.data!.user!.userAddresses!;
        if (userAddress.isNotEmpty) {
          userAddress = getUserDetailModel.data!.user!.userAddresses!;
          for (int i = 0; i < userAddress.length; i++) {
            countryId.value = userAddress[i].state!.country!.countryId ?? "";
            countryTextController.text =
                userAddress[i].state!.country!.countryName ?? "";
            if (userAddress[i].state?.country?.countryName != null) {
              final geocoding = GoogleMapsGeocoding(apiKey: kGoogleApiKey);

              GeocodingResponse response = await geocoding.searchByAddress(
                  userAddress[i].state?.country?.countryName ?? "");

              final result =
                  response.results.isNotEmpty ? response.results.first : null;

              if (result != null) {
                selectedCountry.value = Utility.extractLocality(
                    result, "country",
                    isShortName: true);
              }
            }
            stateTextController.text = userAddress[i].state!.stateName ?? "";
            selectedState.value = userAddress[i].state!.stateName ?? "";
            addressLine1TextController.text = userAddress[i].addressLine1 ?? "";
            addressLine2TextController.text = userAddress[i].addressLine2 ?? "";
            cityTextController.text = userAddress[i].city ?? "";
            zipCodeTextController.text = userAddress[i].postalCode ?? "";
            // await apiGetCountries();
          }
        }
        isLoading.value= false;
      } else if (value?.body["status"] == 401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        isLoading.value= false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
               isLoading.value= false;
        Utility.showAlertMessage(value?.body['message'].toString());
      }
    });
  }


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

  bool validateAndSave3() {
    final form = formKey3.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // Fields Validation Method
  validateAndSubmitFunctionOwner(BuildContext context,
      {bool isFromPayout = false, String ownerStoreId = ""}) {
    if (validateAndSave3()) {
      try {
        if (selectPaymentType.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectPaymentTypeText);
        } else if (selectPaymentType.value == "Cards" &&
            userStripeCardId!.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
        } else {
          apiAddMoneyToOwnerWallet(ownerStoreId: ownerStoreId);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
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
  validateAndSubmitFunction(BuildContext context, {bool isFromPayout = false}) {
    if (validateAndSave1()) {
      try {
        if (selectPaymentType.isEmpty) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectPaymentTypeText);
        } else if (selectPaymentType.value == "Cards" &&
            userStripeCardId!.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
        } else {
          apiAddMoneyToWallet();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  validateAndSavePayOut() {
    if (validateAndSave2()) {
      try {
        final double? amount =
            double.tryParse(payoutAmountTextController.text.trim());
        if (selectedStore.value.isEmpty) {
          Utility.showAlertMessage(AlertStringConstants.pleaseSelectStore);
        } else if (userStripeBankId!.value.isEmpty) {
          //NO BANK CONNECTED/SELECTED YET - PAYOUT HAS NOWHERE TO GO
          Utility.showAlertMessage(
              AlertStringConstants.pleaseSelectBankAccountText);
        } else if (amount == null || amount <= 0) {
          Utility.showAlertMessage(
              AlertStringConstants.pleaseEnterValidAmountText);
        } else {
          apiCreatePayout();
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

  ///Get Countries Api
  Future apiGetCountries() async {
    countryList.clear();
    isLoading.value= true;
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
               isLoading.value= false;
        countryListModel = CountryListModel.fromJson(value?.body);
        countryList.value = countryListModel.data!.countries!;
      } else if (value?.body["status"] == ApiConstants.statusCode401)
      {
        isLoading.value= false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
               isLoading.value= false;
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  ///Get States Api
  Future apiGetStates() async {
    statesList.clear();
    isLoading.value= true;
    Map<String, String> headers = {
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.states}?country_id=$countryId",
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
               isLoading.value= false;
        getStateModel = GetStatesModel.fromJson(value?.body);
        statesList.value = getStateModel.data!.states!;
        if (stateId.value.isNotEmpty) {
          for (int i = 0; i < statesList.length; i++) {
            if (stateId.value == statesList[i].stateId) {
              stateId.value = statesList[i].stateId.toString();
            }
          }
        } else {
          isLoading.value= false;
          stateId.value = statesList[0].stateId.toString();
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();isLoading.value= false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value= false;
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  ///Credit Card Model Change
  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  ///Get Store List Api
  Future apiGetStoreList() async {
    isStoreLoading.value = true;
    isLoading.value= true;
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
      isStoreLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {isLoading.value= false;
        getStoreListModel = GetOwnerStoresResponse.fromJson(value?.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data as Iterable<Datum>);

        Get.parameters["storeCount"] = storeList.length.toString();
        if (storeList.length == 1) {isLoading.value= false;
          // selectedStore.value = storeList[0].storeId.toString();
          storeId?.value = storeList[0].storeId.toString();
          apiGetOwnerWalletBalance();
        } else {isLoading.value= false;
          if (storeList.isNotEmpty) {
            storeNameValue.value = storeList[0].storeName.toString();
            // selectedStore.value = storeList[0].storeId.toString();
            storeId?.value = storeList[0].storeId.toString();
            apiGetOwnerWalletBalance();
          } else if (value?.body["status"] == ApiConstants.statusCode401) {
            Utility.showAlertMessage(value?.body['message']);
            storage.clearData();
            Get.parameters.clear();
            Utility.handle401Error();
          }
        }
      } else {isLoading.value= false;
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Create Stripe Token - Send card details to backend instead of direct Stripe call
  Future<void> apiCreateStripeToken(context) async {
    print('🟢 DEBUG: apiCreateStripeToken called');
    var str = expiryDate.value;
    var parts = str.split('/');
    var month = parts[0].trim();
    var year = parts[1].trim();
    try {
      isLoading.value = true;
      print('🟢 DEBUG: About to call Stripe API');
      var headers = {
        StringConstants.authorizationText:
            'Bearer ${ServerCommunicator.stripePublishableKey}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request(
          'POST', Uri.parse(ServerCommunicator.createStripeToken));
      request.followRedirects = true;
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
      print('🟢 DEBUG: Stripe URL: ${ServerCommunicator.createStripeToken}');
      print('🟢 DEBUG: Stripe request body: ${request.bodyFields}');
      http.StreamedResponse response = await request.send();
      print('🟢 DEBUG: Stripe response status: ${response.statusCode}');
      var streamResponse = await http.Response.fromStream(response);
      print('🟢 DEBUG: Stripe response body: ${streamResponse.body}');
      if (response.statusCode == 200) {
        var parsed = jsonDecode(streamResponse.body);
        stripeToken.value = parsed['id'].toString();
        await apiCreateCard();
      } else {
        isLoading.value = false;
        Utility.showAlertMessage(StripeErrorMapper.fromResponseBody(
            streamResponse.body,
            fallback: StripeErrorMapper.defaultCardMessage));
      }
    } catch (error) {
      isLoading.value = false;
      Utility.showAlertMessage(StripeErrorMapper.defaultCardMessage);
    }
  }

  ///Update User Detail Api
  Future apiUpdateUserDetail() async {
    isLoading.value= true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    Map data = {
      "user": {
        "first_name": getUserDetailModel.data?.user?.firstName ?? "",
        "last_name": getUserDetailModel.data?.user?.lastName ?? "",
        "nick_name": getUserDetailModel.data?.user?.nickName ?? "",
      },
      "address": {
        "user_address_id":
            getUserDetailModel.data?.user?.userAddresses != null &&
                    getUserDetailModel.data!.user!.userAddresses!.isNotEmpty
                ? getUserDetailModel
                        .data?.user?.userAddresses?.first.userAddressId ??
                    0
                : null,
        "state": stateTextController.text.trim(),
        "country": countryTextController.text.trim(),
        "address_name": "home",
        "address_line_1": addressLine1TextController.text.trim(),
        "address_line_2": addressLine2TextController.text.trim(),
        "city": cityTextController.text.trim(),
        "postal_code": zipCodeTextController.text.trim()
      }
    };
         UserProvider()
        .putWithHeadersApi(
            data,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.updateUser}",
            headers,
            showLoading: false)
        .then((value) async {
             if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {isLoading.value= false;
                 // Utility.showToast(value?.body['message']);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value= false;
               } else {isLoading.value= false;
        if (value?.body['message'] != null) {isLoading.value= false;
                     // Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Api Create Card
  Future apiCreateCard() async {
         Map body = {"token_id": stripeToken.value};
         isLoading.value= true;
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
      if (value != null) {isLoading.value= false;
                 if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          Utility.showToast(value.body['message']);
          await apiGetCardList();
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
          Get.back(id: pageIdApp.value);
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);isLoading.value= false;
        } else {isLoading.value= false;
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Get Card List Api
  Future apiGetCardList() async {
    userStripeCardId?.value = "";

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
      if (cardList.isNotEmpty) {
        cardList.clear();
      }
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        cardListModel = CardListModel.fromJson(value?.body);
        cardList.value = cardListModel.data?.cards ?? [];
        isLoading.value = false;
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();isLoading.value= false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value= false;
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
  apiAddMoneyToWallet() {
    final String finalStripeCardId = userStripeCardId?.value.toString().trim() ?? "";
    if (finalStripeCardId.isEmpty) {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
      return;
    }

         Map body = {
      "user_stripe_card_id": finalStripeCardId,
      "amount": amountTextController.text.trim()
    };
         isLoading.value= true;
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
        .then((value) {
      if (value != null) {isLoading.value= false;
                 if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
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
        } else if (value.statusCode == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value.body['message']);isLoading.value= false;
        } else {isLoading.value= false;
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  apiAddMoneyToOwnerWallet({String ownerStoreId = ""}) {
    final String finalStoreId = ownerStoreId.toString().trim();
    final String finalStripeCardId = userStripeCardId?.value.toString().trim() ?? "";

    if (finalStoreId.isEmpty || finalStoreId == "0") {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectStore);
      return;
    }

    if (finalStripeCardId.isEmpty) {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectCardText);
      return;
    }

         Map body = {
      "store_id": int.parse(finalStoreId),
      "user_stripe_card_id": finalStripeCardId,
      "amount": ownerAmountTextController.text.trim()
    };isLoading.value= true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.ownerWalletRechargeStripe,
            headers,
            showLoading: false)
        .then((value) {
      if (value != null) {isLoading.value= false;
                 if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
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
        } else if (value.statusCode == ApiConstants.statusCode401) {isLoading.value= false;
          Utility.showAlertMessage(value.body['message']);
        } else {isLoading.value= false;
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  ///Get Card List Api
  Future apiGetUserWalletBalance() async {
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
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
               final balance = value?.body['data']['balance'];
               userWalletBalance!.value = balance != null
                   ? balance.toStringAsFixed(2)
                   : "0.00"; // or handle however you want
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

  ///Delete Card api
  Future apiDeleteCard({String userStripeCardId = ""}) async {
    isLoading.value= true;
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
          value?.body["status"] == ApiConstants.statusCode200) {isLoading.value= false;
        Utility.showToast(value?.body['message']);
        await apiGetCardList();
      } else if (value?.body["status"] == ApiConstants.statusCode409) {isLoading.value= false;
        Utility.showAlertMessage(value?.body['message']);
        await apiGetCardList();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {isLoading.value= false;
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value= false;
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
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        bankAccountListModel = BankAccountListModel.fromJson(value?.body);
        bankAccountList.value = bankAccountListModel.data?.banks ?? [];
        //KEEP THE HIGHLIGHTED ROW AND THE ID WE POST IN SYNC - THE PAYOUT SCREEN
        //SHOWS THE FIRST ACCOUNT AS SELECTED, SO SEED IT HERE INSTEAD OF DURING BUILD
        if (bankAccountList.isEmpty) {
          selectedBankAccountIndex!.value = 0;
          userStripeBankId!.value = "";
        } else {
          if (selectedBankAccountIndex!.value < 0 ||
              selectedBankAccountIndex!.value >= bankAccountList.length) {
            selectedBankAccountIndex!.value = 0;
          }
          userStripeBankId!.value = bankAccountList[
                  selectedBankAccountIndex!.value]
              .userStripeBankId
              .toString();
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
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

  ///Api create payout
  Future apiCreatePayout() async {
    final int? storeIdValue = int.tryParse(selectedStore.value);
    final int? bankIdValue = int.tryParse(userStripeBankId!.value);
    final double? amountValue =
        double.tryParse(payoutAmountTextController.text.trim());
    if (storeIdValue == null) {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectStore);
      return;
    }
    if (bankIdValue == null) {
      Utility.showAlertMessage(AlertStringConstants.pleaseSelectBankAccountText);
      return;
    }
    if (amountValue == null || amountValue <= 0) {
      Utility.showAlertMessage(AlertStringConstants.pleaseEnterValidAmountText);
      return;
    }
         Map body = {
      "store_id": storeIdValue,
      "user_stripe_bank_id": bankIdValue,
      "amount": amountValue
    };
         isLoading.value= true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl +
                ServerCommunicator.storeStripePayoutCreate,
            headers,
            showLoading: false)
        .then((value) async {
      if (value != null) {
        if (value.body['success'] == true ||
            value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          userStripeBankId!.value = "";isLoading.value= false;
          payoutAmountTextController.clear();
          userStripeBankId!.value = "";
          payoutAmountTextController.clear();
          ownerWalletBalance!.value = "0.00";
          Get.back(id: pageIdApp.value);
          Utility.showToast(value.body['message']);
        } else if (value.body["status"] == ApiConstants.statusCode401) {isLoading.value= false;
          Utility.showAlertMessage(value.body['message']);
          storage.clearData();
          Get.parameters.clear();
          Utility.handle401Error();
        } else if (value.body["status"] == ApiConstants.statusCode409) {isLoading.value= false;
          Utility.showAlertMessage(value.body['message']);
        } else {isLoading.value= false;
          if (value.body['message'] != null) {
            Utility.showAlertMessage(value.body['message']);
          }
        }
      }
    });
  }

  ///Get Store service charge
  Future apiGetStoreServiceCharge() async {
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeServiceCharge}?store_id=${storeId!.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        if (value?.body['data']['service_charge_value'] is int ||
            value?.body['data']['service_charge_value'] is String) {
          storeServiceCharge.value = double.parse(
              value?.body['data']['service_charge_value'].toString() ?? "");
        } else {
          storeServiceCharge.value =
              value?.body['data']['service_charge_value'];
        }
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();isLoading.value= false;
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value= false;
        String msg = value?.body["message"].toString().toLowerCase() ?? "";
        if (msg.contains("store not found")) {
          Utility.showAlertMessage("Please select store");
        } else {
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
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
            "${ServerCommunicator.baseUrl}${ServerCommunicator.storeWalletBalance}?store_id=${selectedStore.value}",
            headers,
            showLoading: false)
        .then((value) async {

             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {isLoading.value = false;
        if (value?.body['data']['balance'] != null) {
          ownerWalletBalance!.value =
              value?.body['data']['balance'].toStringAsFixed(2) ?? "0.00";
        } else {
          ownerWalletBalance!.value = "0.00";
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);isLoading.value = false;
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {isLoading.value = false;
        //DON'T KEEP SHOWING THE PREVIOUS STORE'S BALANCE WHEN THIS ONE FAILED TO LOAD
        ownerWalletBalance!.value = "0.00";
        String msg = value?.body["message"].toString().toLowerCase() ?? "";
        if (msg.contains("store not found")) {
          Utility.showAlertMessage("Please select store");
        } else {
          if (value?.body['message'] != null) {
            Utility.showAlertMessage(value?.body['message']);
          }
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
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        capability.value =
            value?.body["data"]['account']['capabilities']['transfers'];
        payouts.value = value?.body["data"]['account']['payouts_enabled'];
        accountLink.value = value?.body["data"]['accountLink']['url'];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        Utility.showAlertMessage(value?.body['message']);
      }
    });
  }

  /// Add Money to stripe wallet
  Future apiPaymentIntent(String type) async {
    isLoading.value = true;
         Map body = {
      "payment_service_name": type,
      "amount": double.parse(amountTextController.text) * 100
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
              UserProvider()
        .postWithHeadersApi(
            body,
            ServerCommunicator.baseUrl + ServerCommunicator.paymentIntent,
            headers,
            showLoading: false)
        .then((value) async {
      if (value != null) {isLoading.value = false;
                 if (value.body['status'] == ApiConstants.statusCode201 ||
            value.body['status'] == ApiConstants.statusCode200) {
          Utility.showToast(value.body['message']);
        } else if (value.statusCode == ApiConstants.statusCode401) {isLoading.value = false;
          Utility.showAlertMessage(value.body['message']);
        } else {isLoading.value = false;
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
