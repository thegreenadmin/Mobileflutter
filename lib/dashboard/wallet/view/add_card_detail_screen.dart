import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

class AddCardDetailScreen extends StatefulWidget {
  const AddCardDetailScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddCardDetailScreenState();
  }
}

class AddCardDetailScreenState extends State<AddCardDetailScreen> {
  final AddCardController addCardController = Get.put(AddCardController());
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 1.0,
      ),
    );
    addCardController.apiGetUserWalletBalance();
    addCardController.apiGetCardList(context);
    addCardController.apiGetCountries();
    addCardController.apiGetUserDetailApi(Get.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                           Get.back(id:addCardController.pageId.value);
                                  // Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.black,
                            size: 24.0,
                          ),
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.addCardText,
                          style: const TextStyle(
                              fontSize: 22,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: <Widget>[
            Obx(
              () => CreditCardWidget(
                cardNumber: addCardController.cardNumber.value,
                expiryDate: addCardController.expiryDate.value,
                cardHolderName: addCardController.cardHolderName.value,
                cvvCode: addCardController.cvvCode.value,
                showBackView: addCardController.isCvvFocused.value,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: Colors.lightBlue,
                // backgroundImage:
                //     useBackgroundImage ? 'assets/card_bg.png' : null,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: CardType.mastercard,
                    cardImage: Image.asset(
                      ImageConstants.mastercard,
                      height: 48,
                      width: 48,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: addCardController.cardNumber.value,
                      cvvCode: addCardController.cvvCode.value,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: addCardController.cardHolderName.value,
                      expiryDate: addCardController.expiryDate.value,
                      themeColor: Colors.blue,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: StringConstants.cardNumberText, // 'Number',
                        hintText:
                            StringConstants.x4Text, //'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText:
                            StringConstants.expiryDateText, //'Expired Date',
                        hintText: StringConstants.x2Text, //'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: StringConstants.cvvText, //'CVV',
                        hintText: StringConstants.x1Text, //'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        hintText: StringConstants.enterNameText,
                        labelText:
                            StringConstants.cardHolderNameText, //'Card Holder',
                      ),
                      onCreditCardModelChange:
                          addCardController.onCreditCardModelChange,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 21, right: 21, top: 10),
                      child: Form(
                        key: addCardController.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConstants.billingAddressText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            height20SizedBox,
                            TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller: addCardController
                                    .addressLine1TextController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterAddressText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringConstants.addressLine1Text,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                )),
                            height20SizedBox,
                            TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller: addCardController
                                    .addressLine2TextController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: StringConstants.addressLine2Text,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                )),
                            height20SizedBox,
                            TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller:
                                    addCardController.cityTextController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterTownOrCityText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringConstants.cityText,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                )),
                            height20SizedBox,
                            TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller:
                                    addCardController.zipCodeTextController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterZipCodeText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringConstants.zipCodeText,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                )),

                            height20SizedBox,
                            TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller:
                                    addCardController.stateTextController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterStateText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringConstants.stateText,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                )),

                            height20SizedBox,
                            Obx(
                              () => DropdownButtonFormField<String>(
                                value: addCardController
                                                .selectedCountry.value !=
                                            "" &&
                                        addCardController.countryId.value != ""
                                    ? addCardController.countryList
                                        .firstWhere((element) =>
                                            element.countryId.toString() ==
                                            addCardController.countryId.value)
                                        .countryId
                                    : null,
                                isExpanded: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  if (v == null || v.trim() == '') {
                                    return AlertStringConstants
                                        .pleaseSelectCountryText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                hint: Text(
                                  StringConstants.selectCountryText,
                                  style: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                ),
                                items: addCardController.countryList
                                    .map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value.countryId,
                                    child: Text(
                                      value.abbrevation +
                                          " - " +
                                          value.countryName,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  addCardController.selectedCountry.value =
                                      value.toString();
                                  // addCardController.countryId.value =
                                  //     value.toString();
                                  // addCardController.apiGetStates();
                                },
                              ),
                            ),
                            height20SizedBox,
                            // Obx(
                            //   () => DropdownButtonFormField<String>(
                            //     value: addCardController.selectedState.value != ""
                            //         ? addCardController.statesList
                            //             .firstWhere((element) =>
                            //                 element.stateId ==
                            //                 addCardController.stateId.value)
                            //             .stateId
                            //         : null,
                            //     isExpanded: true,
                            //     autovalidateMode:
                            //         AutovalidateMode.onUserInteraction,
                            //     validator: (v) {
                            //       if (v == null || v.trim() == '') {
                            //         return AlertStringConstants
                            //             .pleaseSelectStateText;
                            //       }
                            //       return null;
                            //     },
                            //     decoration: InputDecoration(
                            //       errorMaxLines: 3,
                            //       enabledBorder: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       focusedBorder: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       errorBorder: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //     ),
                            //     hint: Text(
                            //       StringConstants.selectStateText,
                            //       style: const TextStyle(
                            //           color: AppColors.black, fontSize: 16),
                            //     ),
                            //     items: addCardController.statesList
                            //         .map((dynamic value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value.stateId,
                            //         child: Text(
                            //           value.stateName,
                            //           style: const TextStyle(
                            //               color: AppColors.black,
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w500),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     onChanged: (value) {
                            //       addCardController.selectedState.value =
                            //           value.toString();
                            //     },
                            //   ),
                            // ),
                            height20SizedBox,
                          ],
                        ),
                      ),
                    ),
                    height20SizedBox,
                    CustomButton(
                      width: WidgetConstants.screenWidth * 0.9,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () async {
                        if (addCardController.cardHolderName.isEmpty) {
                          Utility.showAlertMessage(
                              AlertStringConstants.pleaseFillAllDetailsText);
                        } else if (formKey.currentState!.validate()) {
                          // addCardController.apiCreateStripeToken(context);
                          addCardController.validateAndSubmitCard(context);
                        }
                      },
                      height: 50,
                      textColor: AppColors.white,
                      text: StringConstants.addCardText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
