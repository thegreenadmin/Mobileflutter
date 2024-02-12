import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'payment_configurations.dart' as payment_configurations;

class AddMoneyToWalletOwner extends StatefulWidget {
  const AddMoneyToWalletOwner({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return AddMoneyToWalletOwnerState();
  }
}

class AddMoneyToWalletOwnerState extends State<AddMoneyToWalletOwner> {
  final AddCardController addCardController = Get.put(AddCardController());
  final WalletController walletController = Get.put(WalletController());
  late Pay _payClient;
  bool _hasApplePay = false;
  bool _hasGooglePay = false;

  @override
  void initState() {
    super.initState();
    addCardController.apiGetCardList();
    _payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(
          payment_configurations.defaultGooglePay),
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
          payment_configurations.defaultApplePay),
    });

    _checkIfGooglePayInstalled();
    _checkIfApplePayInstalled();
  }

  Future<void> _checkIfApplePayInstalled() async {
    _hasApplePay = await _payClient.userCanPay(PayProvider.apple_pay);
    if (_hasApplePay) {
      debugPrint('Apple Pay is available on this device!');
    } else {
      debugPrint('Apple Pay is not available on this device!');
    }
  }

  Future<void> _checkIfGooglePayInstalled() async {
    _hasGooglePay = await _payClient.userCanPay(PayProvider.google_pay);
    if (_hasGooglePay) {
      debugPrint('Google Pay is available on this device!');
    } else {
      debugPrint('Google Pay is not available on this device!');
    }
  }

  void onApplePayResult(paymentResult) {
    debugPrint("APPLE PAYMENT RESULT *************$paymentResult");
    try {
      //final token = paymentResult['token'];
      //final tokenJson = Map.castFrom(json.decode(token));
      //debugPrint("transactionIdentifierJson *************$tokenJson");
      addCardController.apiPaymentIntent("Apple pay");
      //final transactionId = paymentResult['token']['transactionId'];
      //  final transactionIdentifierJson =
      // Map.castFrom(json.decode(transactionIdentifier));

      // final tokenJson = Map.castFrom(json.decode(token));
      //final transactionIdJson = Map.castFrom(json.decode(transactionId));
      //debugPrint("tokenJson *************$tokenJson");
      // debugPrint(
      //  "transactionIdentifierJson *************$transactionIdentifierJson");
      // debugPrint(
      //     "transactionIdJson *************$transactionIdJson");
      //Send token to a server or to Google or Apple for confirmation
    } catch (e) {
      debugPrint("APPLE PAYMENT error *************${e.toString()}");
      Utility.showAlertMessage(e.toString());
    }
  }

  Future<void> onGooglePayResult(paymentResult) async {
    debugPrint("GOOGLE PAYMENT RESULT *************000000");
    debugPrint("GOOGLE PAYMENT RESULT *************$paymentResult");
    try {
      final token =
      paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      debugPrint("GOOGLE PAYMENT RESULT tokenJson *************$tokenJson");
      //Send token to a server or to Google or Apple for confirmation
    } catch (e) {
      debugPrint("GOOGLE PAYMENT error *************${e.toString()}");
      //An error has occurred
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConstants.screenWidth * 2.1),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 20, top: 50, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back(id: pageIdApp.value);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            const Flexible(
                              child: Text(
                                "Add money to store wallet",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageConstants.homeMall,
                        scale: 4,
                      )
                    ])),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: addCardController.formKey3,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height15SizedBox,
                  Text(
                    StringConstants.amountText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  height12SizedBox,
                  CustomInputField(
                    isBorderOutline: false,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    autofocus: false,
                    hintText: StringConstants.amountText,
                    textCapitalization: TextCapitalization.words,
                    controller: addCardController.ownerAmountTextController,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return AlertStringConstants.pleaseEnterAmountText;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      addCardController.paymentItems.clear();
                      addCardController.paymentItems.add(PaymentItem(
                        label: StringConstants.totalText,
                        amount: value ?? "",
                        status: PaymentItemStatus.unknown,
                      ));
                    },
                  ),
                  height20SizedBox,
                  Text(
                    StringConstants.paymentText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  height25SizedBox,
                  Obx(
                        () =>
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  addCardController.paymentType!.value =
                                      StringConstants.cardText.toLowerCase();
                                  addCardController.selectPaymentType.value =
                                      StringConstants.cardText.toLowerCase();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.white,
                                      border: Border.all(
                                        color:
                                        addCardController.paymentType!.value ==
                                            StringConstants.cardText
                                                .toLowerCase()
                                            ? AppColors.primary
                                            : AppColors.blacklight,
                                      )),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      addCardController.paymentType!.value ==
                                          StringConstants.cardText.toLowerCase()
                                          ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.circleunfill,
                                            scale: 4,
                                          ),
                                          Image.asset(
                                            ImageConstants.circle,
                                            scale: 7,
                                          ),
                                        ],
                                      )
                                          : Image.asset(
                                        ImageConstants.circleBlackUnFill,
                                        scale: 2.8,
                                      ),
                                      width8SizedBox,
                                      Text(
                                        StringConstants.cardText,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            width20SizedBox,
                            Platform.isAndroid
                                ? Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  addCardController.paymentType!.value =
                                      StringConstants.gPayText;

                                  addCardController.selectPaymentType.value =
                                      StringConstants.gPayText;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: addCardController
                                            .paymentType!.value ==
                                            StringConstants.gPayText
                                            ? AppColors.primary
                                            : AppColors.blacklight,
                                      )),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      addCardController.paymentType!.value ==
                                          StringConstants.gPayText
                                          ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.circleunfill,
                                            scale: 4,
                                          ),
                                          Image.asset(
                                            ImageConstants.circle,
                                            scale: 7,
                                          ),
                                        ],
                                      )
                                          : Image.asset(
                                        ImageConstants
                                            .circleBlackUnFill,
                                        scale: 2.8,
                                      ),
                                      width8SizedBox,
                                      Text(
                                        StringConstants.gPayText,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                : Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  addCardController.paymentType!.value =
                                      StringConstants.applePaysText;
                                  addCardController.selectPaymentType.value =
                                      StringConstants.applePaysText;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: addCardController
                                            .paymentType!.value ==
                                            StringConstants.applePaysText
                                            ? AppColors.primary
                                            : AppColors.blacklight,
                                      )),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      addCardController.paymentType!.value ==
                                          StringConstants.applePaysText
                                          ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.circleunfill,
                                            scale: 4,
                                          ),
                                          Image.asset(
                                            ImageConstants.circle,
                                            scale: 7,
                                          ),
                                        ],
                                      )
                                          : Image.asset(
                                        ImageConstants
                                            .circleBlackUnFill,
                                        scale: 2.8,
                                      ),
                                      width8SizedBox,
                                      Text(
                                        StringConstants.applePayText,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),
                  height15SizedBox,
                  Obx(
                        () =>
                    addCardController.selectPaymentType.value ==
                        StringConstants.gPayText
                        ? GooglePayButton(
                      onError: (Object? error) {
                        debugPrint(
                            "GooglePayButton error:*****************");
                        debugPrint(error.toString());
                      },
                      paymentConfiguration:
                      PaymentConfiguration.fromJsonString(
                          payment_configurations.defaultGooglePay),
                      paymentItems: addCardController.paymentItems,
                      type: GooglePayButtonType.pay,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : addCardController.selectPaymentType.value ==
                        StringConstants.applePaysText
                        ? ApplePayButton(
                      width: WidgetConstants.screenWidth,
                      height: 45,
                      paymentConfiguration:
                      PaymentConfiguration.fromJsonString(
                          payment_configurations.defaultApplePay),
                      paymentItems: addCardController.paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 0.0),
                      onPaymentResult: onApplePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : addCardController.selectPaymentType.value ==
                        StringConstants.cardText.toLowerCase()
                        ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
                      child: addCardController.cardList.isEmpty
                          ? addCardController.isLoading.value ==
                          true
                          ? height0SizedBox
                          : Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              ImageConstants.nodata,
                              scale: 8,
                              color: AppColors.primary,
                            ),
                          ),
                          height4SizedBox,
                          Center(
                            child: Text(
                              "${StringConstants.noCardsFoundText}\n${StringConstants.pleaseAddCardFirstText}!",
                              style: const TextStyle(
                                  fontStyle:
                                  FontStyle.italic,
                                  fontSize: 16),
                            ),
                          ),
                          height20SizedBox,
                          Align(
                            alignment:
                            Alignment.bottomRight,
                            child: CustomButton(
                              gradient:
                              const LinearGradient(
                                begin:
                                Alignment.topCenter,
                                end: Alignment
                                    .bottomCenter,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary
                                ],
                              ),
                              onTap: () async {
                                await Get.to(
                                    const AddCardDetailScreen(),
                                    id: pageIdApp
                                        .value)
                                    ?.then((value) {
                                  addCardController
                                      .apiGetCardList();
                                });
                              },
                              height: 50,
                              width: WidgetConstants
                                  .screenWidth *
                                  0.3,
                              text: StringConstants
                                  .addCardText,
                              borderRadius: 12,
                              fontWeight:
                              FontWeight.w500,
                              iconL: false,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                          : ListView.separated(
                          separatorBuilder:
                              (BuildContext context,
                              int index) {
                            return height15SizedBox;
                          },
                          itemCount: addCardController
                              .cardList.length,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,
                              int index) {
                            debugPrint(
                                "userStripeCardId:--------------->>>>>>");
                            debugPrint(addCardController
                                .userStripeCardId!.value);

                            if (addCardController
                                .userStripeCardId!
                                .value
                                .isEmpty) {
                              addCardController
                                  .userStripeCardId
                                  ?.value =
                                  addCardController
                                      .cardList[0]
                                      .userStripeCardId
                                      .toString();
                              debugPrint(
                                  "userStripeCardId:--------------->>>>>>");
                              debugPrint(addCardController
                                  .userStripeCardId!.value);
                            }
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                  top: 15,
                                  bottom: 15),
                              color: addCardController
                                  .selectedIndex!
                                  .value ==
                                  index
                                  ? AppColors.primary
                                  : AppColors.primarylight,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    addCardController
                                        .selectedIndex!
                                        .value = index;

                                    addCardController
                                        .userStripeCardId!
                                        .value =
                                        addCardController
                                            .cardList[index]
                                            .userStripeCardId
                                            .toString();
                                    debugPrint(
                                        addCardController
                                            .userStripeCardId!
                                            .value);
                                  });
                                },
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                top: 8.0),
                                            child:
                                            Image.asset(
                                              addCardController
                                                  .cardList[
                                              index]
                                                  .card!
                                                  .brand ==
                                                  StringConstants
                                                      .visaText
                                                  ? ImageConstants
                                                  .visacard
                                                  : addCardController.cardList[index].card!.brand ==
                                                  StringConstants
                                                      .masterCardText
                                                  ? ImageConstants
                                                  .mastercard
                                                  : addCardController.cardList[index].card!.brand ==
                                                  StringConstants.americanExpressText
                                                  ? ImageConstants.americanexpress
                                                  : addCardController.cardList[index].card!.brand == StringConstants.discoverText
                                                  ? ImageConstants.discovecard
                                                  : ImageConstants.card,
                                              height: 20,
                                            ),
                                          ),
                                          width15SizedBox,
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                addCardController
                                                    .cardList[
                                                index]
                                                    .card!
                                                    .brand
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: addCardController
                                                        .selectedIndex!.value ==
                                                        index
                                                        ? AppColors
                                                        .white
                                                        : AppColors
                                                        .blacklight,
                                                    fontSize:
                                                    15,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                              height10SizedBox,
                                              Text(
                                                "**** **** **** **** ${addCardController.cardList[index].card!.last4}",
                                                style: TextStyle(
                                                    color: addCardController
                                                        .selectedIndex!.value ==
                                                        index
                                                        ? AppColors
                                                        .white
                                                        : AppColors
                                                        .blacklight,
                                                    fontSize:
                                                    15,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            );
                          }),
                    )
                        : height20SizedBox,
                  ),
                  height20SizedBox,
                  Obx(() {
                    return Visibility(
                      visible: addCardController.selectPaymentType!.value !=
                          StringConstants.applePaysText,
                      child: CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          addCardController.validateAndSubmitFunctionOwner(context,
                              ownerStoreId:
                              walletController.ownerSelectedStore.value);
                        },
                        height: 50,
                        text: StringConstants.addText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 16,
                      ),
                    );
                  }),
                  height20SizedBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
