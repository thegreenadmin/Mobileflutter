import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'payment_configurations.dart' as payment_configurations;
import 'package:thegreenmall/utils/shared_prefrences.dart';

class AddMoneyToWallet extends StatefulWidget {
  const AddMoneyToWallet({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddMoneyToWalletState();
  }
}

class AddMoneyToWalletState extends State<AddMoneyToWallet> {
  final AddCardController addCardController = Get.put(AddCardController());

  final _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  late Pay _payClient;
  bool _hasApplePay = false;
  bool _hasGooglePay = false;

  @override
  void initState() {
    super.initState();
    addCardController.apiGetCardList(Get.context!);
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
      setState(() {
        // Write here your code..
      });
      debugPrint('Apple Pay is available on this device!');
    } else {
      debugPrint('Apple Pay is not available on this device!');
    }
  }

  Future<void> _checkIfGooglePayInstalled() async {
    _hasGooglePay = await _payClient.userCanPay(PayProvider.google_pay);
    if (_hasGooglePay) {
      setState(() {
        // Write here your code..
      });
      debugPrint('Google Pay is available on this device!');
    } else {
      debugPrint('Google Pay is not available on this device!');
    }
  }

  void onApplePayResult(paymentResult) {
    debugPrint("APPLE PAYMENT RESULT *************$paymentResult");
  }

  Future<void> onGooglePayResult(paymentResult) async {
    debugPrint("GOOGLE PAYMENT RESULT *************$paymentResult");
    if (await paymentResult
        .userCanPay(PayProvider.google_pay /*Or apple_pay*/)) {
      // final paymentResult = await payClient.showPaymentSelector(
      //   provider: PayProvider.google_pay, //Or apple_pay
      //   paymentItems: _paymentItems,
      // );
      try {
        final token =
            paymentResult['paymentMethodData']['tokenizationData']['token'];
        final tokenJson = Map.castFrom(json.decode(token));
        var tokenId = tokenJson['id'];
        //Send token to a server or to Google or Apple for confirmation
      } catch (e) {
        //An error has occured
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Get.back();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.addMoneyToMyWalletText,
                            style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
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
            key: addCardController.formKey1,
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
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {},
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(40),
                      ],
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      controller: addCardController.amountTextController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AlertStringConstants.pleaseEnterAmountText;
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: StringConstants.amountText,
                        hintStyle: const TextStyle(color: AppColors.grey),
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                      )),
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
                        () => Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              addCardController.paymentType!.value = "card";
                              addCardController.selectPaymentType.value =
                              "card";
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.white,
                                  border: Border.all(
                                    color:
                                    addCardController.paymentType!.value ==
                                        "card"
                                        ? AppColors.primary
                                        : AppColors.blacklight,
                                  )),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addCardController.paymentType!.value == "card"
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
                              "G-Pay";
                              addCardController.selectPaymentType.value =
                              "G-Pay";
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.white,
                                  border: Border.all(
                                    color: addCardController
                                        .paymentType!.value ==
                                        "G-Pay"
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
                                      "G-Pay"
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
                              "applePay";
                              addCardController.selectPaymentType.value =
                              "applePay";
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.white,
                                  border: Border.all(
                                    color: addCardController
                                        .paymentType!.value ==
                                        "applePay"
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
                                      "applePay"
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
                  height30SizedBox,
                  Obx(
                        () => addCardController.selectPaymentType.value == "G-Pay"
                        ? GooglePayButton(
                      onError: (Object? error) {
                        debugPrint('error');
                      },
                      paymentConfiguration:
                      PaymentConfiguration.fromJsonString(
                          payment_configurations.defaultGooglePay),
                      paymentItems: _paymentItems,
                      type: GooglePayButtonType.pay,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : addCardController.selectPaymentType.value ==
                        "applePay"
                        ? ApplePayButton(
                      width: WidgetConstants.screenWidth,
                      height: 45,
                      paymentConfiguration:
                      PaymentConfiguration.fromJsonString(
                          payment_configurations.defaultApplePay),
                      paymentItems: _paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 0.0),
                      onPaymentResult: onApplePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : addCardController.selectPaymentType.value ==
                        "card"
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
                              onTap: () {
                                SharedPreferenceStorage
                                    .setData("context",
                                    context);
                                Navigator.of(context)
                                    .push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const AddCardDetailScreen(),
                                    ))
                                    .then((value) {
                                  addCardController
                                      .apiGetCardList(
                                      context);
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
                                            child: Image.asset(
                                                ImageConstants
                                                    .mastercard,
                                                fit: BoxFit
                                                    .cover,
                                                scale: 5),
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
                                                    .funding
                                                    .toString(),
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
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await addCardController
                          .validateAndSubmitFunction(context);
                    },
                    height: 50,
                    text: StringConstants.okText,
                    borderRadius: 12,
                    fontWeight: FontWeight.w500,
                    iconL: false,
                    fontSize: 16,
                  ),
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
