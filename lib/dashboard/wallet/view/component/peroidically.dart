import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class PeriodicallyView extends StatefulWidget {
  const PeriodicallyView({Key? key}) : super(key: key);

  @override
  State<PeriodicallyView> createState() => _PeriodicallyViewState();
}

class _PeriodicallyViewState extends State<PeriodicallyView>
    with SingleTickerProviderStateMixin {
  final WalletController walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.periodicallyText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            height4SizedBox,
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
              items: <String>["Monthly", "Weekly"].map((String value) {
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
                // addCardController.selectPaymentType.value = v.toString();
                // print(addCardController.selectPaymentType.value);
              },
            ),
            height20SizedBox,
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
                onChanged: (value) {
                  //  signupController.firstName.value = value;
                },
                textInputAction: TextInputAction.next,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(40),
                ],
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                controller: walletController.amountTextController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AlertStringConstants.pleaseEnterFirstNameText;
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
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.startTimeText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: walletController.startTimeTextController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseSelectOpeningTimeText;
                            } else if (value.trim() ==
                                walletController.endTimeTextController.text) {
                              return AlertStringConstants.startTimeAlertText;
                            }
                            return null;
                          },
                          onTap: () async {
                            TimeOfDay date = TimeOfDay.now();
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = (await showTimePicker(
                              helpText: StringConstants.selectTimeText,
                              initialTime: TimeOfDay.now(),
                              context: context,
                              builder: (context, child) {
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
                            ))!;

                            walletController.startTimeTextController.text =
                                date.format(context).toString();
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 3,
                            hintText: StringConstants.startTimeText,
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 14),
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
                    ],
                  ),
                ),
                width15SizedBox,
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.endTimeText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: walletController.endTimeTextController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseSelectClosingTimeText;
                            } else if (value.trim() ==
                                walletController.startTimeTextController.text) {
                              return AlertStringConstants.endTimeAlertText;
                            }
                            return null;
                          },
                          onTap: () async {
                            TimeOfDay date = TimeOfDay.now();
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = (await showTimePicker(
                              helpText: StringConstants.selectTimeText,
                              initialTime: TimeOfDay.now(),
                              context: context,
                              builder: (context, child) {
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
                            ))!;
                            walletController.endTimeTextController.text =
                                date.format(context).toString();
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 3,
                            hintText: StringConstants.endTimeText,
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 14),
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
                    ],
                  ),
                )
              ],
            ),
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
                // addCardController.selectPaymentType.value = v.toString();
                // print(addCardController.selectPaymentType.value);
              },
            ),
            height15SizedBox,
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
            height20SizedBox,
          ],
        ),
      ),
    );
  }
}
