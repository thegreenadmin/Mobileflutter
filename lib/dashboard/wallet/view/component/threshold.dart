import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pay/pay.dart';

class ThresholdView extends StatefulWidget {
  const ThresholdView({Key? key}) : super(key: key);

  @override
  State<ThresholdView> createState() => _ThresholdViewState();
}

class _ThresholdViewState extends State<ThresholdView>
    with SingleTickerProviderStateMixin {
      
  final WalletController walletController = Get.put(WalletController());
  final AddCardController addCardController = Get.put(AddCardController());
  String? formattedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.amountText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            height4SizedBox,
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(100),
                ],
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                controller: walletController.chargeAmountTextController,
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
                  labelText: StringConstants.amountText,
                  labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blacklight,
                      decoration: TextDecoration.none),
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
              StringConstants.whenBalanceBelowText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            height4SizedBox,
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(40),
                ],
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                controller: walletController.thresholdAmountTextController,
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
                  labelText: StringConstants.amountText,
                  labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blacklight,
                      decoration: TextDecoration.none),
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
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.startDateText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height10SizedBox,
                      InkWell(
                        onTap: () async {
                          DateTime date = DateTime.now();
                          FocusScope.of(context).requestFocus(FocusNode());
                          date = (await showDatePicker(
                            helpText: StringConstants.selectDateText,
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(1200, 1, 1),
                            lastDate: DateTime.now(),
                          ))!;
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          formattedDate = formatter.format(date);
                          walletController.startDateTextController.text =
                              formattedDate!;
                          walletController.dateOfEvent.value =
                              date.toIso8601String();
                        },
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done,
                          enabled: false,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          controller: walletController.startDateTextController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            hintText: StringConstants.startDateText,
                            hintStyle: const TextStyle(color: AppColors.grey),
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
                            disabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                width20SizedBox,
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.endDateText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height10SizedBox,
                      InkWell(
                        onTap: () async {
                          DateTime date = DateTime.now();
                          FocusScope.of(context).requestFocus(FocusNode());
                          date = (await showDatePicker(
                            helpText: StringConstants.selectDateText,
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(1200, 1, 1),
                            lastDate: DateTime.now(),
                          ))!;
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          formattedDate = formatter.format(date);
                          walletController.endDateTextController.text =
                              formattedDate!;
                          walletController.dateOfEvent.value =
                              date.toIso8601String();
                        },
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done,
                          enabled: false,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          controller: walletController.endDateTextController,
                          decoration: InputDecoration(
                            labelText: StringConstants.endDateText,
                            labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blacklight,
                                decoration: TextDecoration.none),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            hintText: StringConstants.endDateText,
                            hintStyle: const TextStyle(color: AppColors.grey),
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
                            disabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            height20SizedBox,
            Text(
              StringConstants.frequencyText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            height4SizedBox,
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(100),
                ],
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                controller: walletController.frequencyTextController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AlertStringConstants.pleaseEnterFrequencyText;
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: StringConstants.frequencyText,
                  hintStyle: const TextStyle(color: AppColors.grey),
                  labelText: StringConstants.frequencyText,
                  labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blacklight,
                      decoration: TextDecoration.none),
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
            height6SizedBox,
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: AppColors.grey,
                    width: 1.0,
                  ),
                ),
                border: UnderlineInputBorder(
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
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.0,
                  ),
                ),
              ),
              isExpanded: true,
              hint: Text(
                StringConstants.selectTypeText,
                style: const TextStyle(
                  color: AppColors.grey,
                ),
              ),
              items: <String>["Google Pay", "Cards"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (v) {
                addCardController.selectPaymentType.value = v.toString();
                print(addCardController.selectPaymentType.value);
              },
            ),
            Obx(
              () =>
                  // addCardController.selectPaymentType.value == "Google Pay"
                  //     ? ApplePayButton(
                  //         width: WidgetConstants.screenWidth,
                  //         height: 45,
                  //         paymentConfiguration: PaymentConfiguration.fromJsonString(
                  //             payment_configurations.defaultApplePay),
                  //         paymentItems: _paymentItems,
                  //         style: ApplePayButtonStyle.black,
                  //         type: ApplePayButtonType.buy,
                  //         margin: const EdgeInsets.only(top: 0.0),
                  //         onPaymentResult: onApplePayResult,
                  //         loadingIndicator: const Center(
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       )
                  // : addCardController.selectPaymentType.value == "Apple Pay"
                  //     ? ApplePayButton(
                  //         width: WidgetConstants.screenWidth,
                  //         height: 45,
                  //         paymentConfiguration:
                  //             PaymentConfiguration.fromJsonString(
                  //                 payment_configurations.defaultApplePay),
                  //         paymentItems: _paymentItems,
                  //         style: ApplePayButtonStyle.black,
                  //         type: ApplePayButtonType.buy,
                  //         margin: const EdgeInsets.only(top: 0.0),
                  //         onPaymentResult: onApplePayResult,
                  //         loadingIndicator: const Center(
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       )
                  //     :
                  addCardController.selectPaymentType.value == "Cards"
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: addCardController.cardList.isEmpty
                              ? addCardController.isLoading.value == true
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
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16),
                                          ),
                                        ),
                                        height20SizedBox,
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: CustomButton(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.primary,
                                                AppColors.primary
                                              ],
                                            ),
                                            onTap: () {
                                              SharedPreferenceStorage.setData("context", context);
                                              Navigator.of(context).push(MaterialPageRoute(
                                                builder: (_) => const AddCardDetailScreen(),
                                              ));
                                              // Get.to(() => AddCardDetailScreen());
                                            },
                                            height: 50,
                                            width: WidgetConstants.screenWidth *
                                                0.3,
                                            text: StringConstants.addCardText,
                                            borderRadius: 12,
                                            fontWeight: FontWeight.w500,
                                            iconL: false,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                              : ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return height15SizedBox;
                                  },
                                  itemCount: addCardController.cardList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (addCardController
                                        .userStripeCardId!.value.isEmpty) {
                                      addCardController
                                              .userStripeCardId!.value =
                                          addCardController
                                              .cardList[0].userStripeCardId
                                              .toString();
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
                                                  .selectedIndex!.value ==
                                              index
                                          ? AppColors.primary
                                          : AppColors.primarylight,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            addCardController
                                                .selectedIndex!.value = index;

                                            addCardController
                                                    .userStripeCardId!.value =
                                                addCardController
                                                    .cardList[index]
                                                    .userStripeCardId
                                                    .toString();
                                            debugPrint(addCardController
                                                .userStripeCardId!.value);
                                          });
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Image.asset(
                                                        ImageConstants
                                                            .mastercard,
                                                        fit: BoxFit.cover,
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
                                                            .cardList[index]
                                                            .card!
                                                            .funding
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: addCardController
                                                                        .selectedIndex!
                                                                        .value ==
                                                                    index
                                                                ? AppColors
                                                                    .white
                                                                : AppColors
                                                                    .blacklight,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      height10SizedBox,
                                                      Text(
                                                        "**** **** **** **** ${addCardController.cardList[index].card!.last4}",
                                                        style: TextStyle(
                                                            color: addCardController
                                                                        .selectedIndex!
                                                                        .value ==
                                                                    index
                                                                ? AppColors
                                                                    .white
                                                                : AppColors
                                                                    .blacklight,
                                                            fontSize: 15,
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
            // height15SizedBox,
            CustomButton(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primary],
              ),
              onTap: () {},
              height: 50,
              text: StringConstants.okText,
              borderRadius: 12,
              fontWeight: FontWeight.w500,
              iconL: false,
              fontSize: 16,
            ),
            height20SizedBox
          ],
        ),
      ),
    );
  }
}
