import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class ThresholdView extends StatefulWidget {
  const ThresholdView({Key? key}) : super(key: key);

  @override
  State<ThresholdView> createState() => _ThresholdViewState();
}

class _ThresholdViewState extends State<ThresholdView>  with SingleTickerProviderStateMixin{
  final WalletController walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              // controller: signupController.firstNameTextController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AlertStringConstants
                      .pleaseEnterFirstNameText;
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
          height15SizedBox,
          Text(
            StringConstants.whenBalanceBelowText,
            style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          height12SizedBox,
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
              // controller: signupController.firstNameTextController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AlertStringConstants
                      .pleaseEnterFirstNameText;
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
              )), height15SizedBox,
          Text(
            StringConstants.paymentText,
            style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          height12SizedBox,
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
              // controller: signupController.firstNameTextController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AlertStringConstants
                      .pleaseEnterFirstNameText;
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
        ],
      ),
    );
  }
}
