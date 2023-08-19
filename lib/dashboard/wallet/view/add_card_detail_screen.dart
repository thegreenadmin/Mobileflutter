import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
    addCardController.apiGetCardList();
    // addCardController.apiGetCountries();
    addCardController.apiGetUserDetailApi();
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
                            Get.back(id: pageIdApp.value);
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
                        hintStyle: TextStyle(color: AppColors.blacklight),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: TextStyle(color: AppColors.blacklight),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText:
                            StringConstants.expiryDateText, //'Expired Date',
                        hintText: StringConstants.x2Text, //'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: TextStyle(color: AppColors.blacklight),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: StringConstants.cvvText, //'CVV',
                        hintText: StringConstants.x1Text, //'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: TextStyle(color: AppColors.blacklight),
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
                                onTap: () async {
                                  Prediction? p = await PlacesAutocomplete.show(
                                      offset: 0,
                                      radius: 1000,
                                      types: [],
                                      strictbounds: false,
                                      context: context,
                                      apiKey: addCardController.kGoogleApiKey,
                                      mode: Mode.overlay,
                                      language: "en",
                                      components: []);
                                  if (p?.description != null) {
                                    int idx = p?.description?.indexOf(",") ?? 0;
                                    List parts = [
                                      p?.description?.substring(0, idx).trim(),
                                      p?.description?.substring(idx + 1).trim()
                                    ];
                                    addCardController.addressLine1TextController
                                        .text = parts[0].toString();
                                  }

                                  ///ADDRESSES BY GoogleMapsGeocoding

                                  final geocoding = GoogleMapsGeocoding(
                                      apiKey: addCardController.kGoogleApiKey);

                                  GeocodingResponse response =
                                      await geocoding.searchByAddress(
                                          p?.description.toString() ?? "");

                                  final result = response.results.isNotEmpty
                                      ? response.results.first
                                      : null;

                                  if (result != null) {
                                    addCardController.cityTextController.text =
                                        Utility.extractLocality(
                                            result, "locality");

                                    addCardController.selectedCountry.value =
                                        Utility.extractLocality(
                                            result, "country",
                                            isShortName: true);
                                    addCardController
                                            .countryTextController.text =
                                        Utility.extractLocality(
                                            result, "country");
                                    addCardController
                                            .zipCodeTextController.text =
                                        Utility.extractLocality(
                                            result, "postal_code");
                                    addCardController.stateTextController.text =
                                        Utility.extractLocality(result,
                                            "administrative_area_level_1");

                                    addCardController.lng = response
                                        .results.first.geometry.location.lng;
                                    addCardController.lat = response
                                        .results.first.geometry.location.lat;
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                minLines: 1,
                                maxLines: 5,
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
                                readOnly: true,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
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
                                  labelText: StringConstants.addressLine1Text,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                  hintText: StringConstants.addressLine1Text,
                                  hintStyle: const TextStyle(
                                      color: AppColors.grey, fontSize: 14),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
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
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
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
                                    addCardController.countryTextController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterCountryText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: StringConstants.countryText,
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

                            /*Obx(
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
                            ),*/
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
