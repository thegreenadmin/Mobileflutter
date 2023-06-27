import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class CreateOwnerBankAccount extends StatefulWidget {
  const CreateOwnerBankAccount({super.key});

  @override
  State<CreateOwnerBankAccount> createState() => _CreateOwnerBankAccountState();
}

class _CreateOwnerBankAccountState extends State<CreateOwnerBankAccount> {
  final WalletController walletController = Get.put(WalletController());
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
                           Get.back(id:pageIdApp.value);
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
                          StringConstants.addBankDetailsText,
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
        child: SingleChildScrollView(
          child: Form(
            key: walletController.formKeyCreateOwnerBankBalance,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height20SizedBox,
                    Text(
                      StringConstants.accountHolderNameText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height12SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        controller:
                            walletController.accountHolderNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: StringConstants.nameText,
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
                    height20SizedBox,
                    Text(
                      StringConstants.accountHolderTypeText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height12SizedBox,
                    Row(
                      children: [
                        Obx(() => CustomButton(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: walletController
                                            .accountHolderTypeText.value ==
                                        StringConstants.individualText
                                            .toLowerCase()
                                    ? [AppColors.primary, AppColors.primary]
                                    : [
                                        AppColors.primarylight,
                                        AppColors.primarylight
                                      ],
                              ),
                              onTap: () async {
                                walletController.accountHolderTypeText.value =
                                    StringConstants.individualText
                                        .toLowerCase();
                              },
                              height: 50,
                              width: WidgetConstants.screenWidth * 0.3,
                              textColor: walletController
                                          .accountHolderTypeText.value ==
                                      StringConstants.individualText
                                          .toLowerCase()
                                  ? AppColors.white
                                  : AppColors.blacklight,
                              text: StringConstants.individualText,
                              borderRadius: 12,
                              fontWeight: FontWeight.w500,
                            )),
                        width20SizedBox,
                        Obx(
                          () => CustomButton(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: walletController
                                          .accountHolderTypeText.value ==
                                      StringConstants.companyText.toLowerCase()
                                  ? [AppColors.primary, AppColors.primary]
                                  : [
                                      AppColors.primarylight,
                                      AppColors.primarylight
                                    ],
                            ),
                            onTap: () async {
                              walletController.accountHolderTypeText.value =
                                  StringConstants.companyText.toLowerCase();
                            },
                            height: 50,
                            width: WidgetConstants.screenWidth * 0.3,
                            textColor: walletController
                                        .accountHolderTypeText.value ==
                                    StringConstants.companyText.toLowerCase()
                                ? AppColors.white
                                : AppColors.blacklight,
                            text: StringConstants.companyText,
                            borderRadius: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    height20SizedBox,
                    Text(
                      StringConstants.accountNumberText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height12SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        controller:
                            walletController.accountNumberTextController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterAccountNumberText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: StringConstants.accountNumberText,
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
                    height20SizedBox,
                    Text(
                      StringConstants.routingNumberText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height12SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        controller: walletController.rountingTextController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterRoutingNumberText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: StringConstants.routingNumberText,
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
                    height20SizedBox,
                    Text(
                      StringConstants.selectCountryText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height12SizedBox,
                    Obx(
                      () => DropdownButtonFormField<String>(
                        isExpanded: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (v) {
                          if (v == null || v.trim() == '') {
                            return AlertStringConstants.pleaseSelectCountryText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorMaxLines: 3,
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
                        hint: Text(
                          StringConstants.selectTypeText,
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 14),
                        ),
                        items:
                            walletController.countryList.map((dynamic value) {
                          return DropdownMenuItem<String>(
                            value: value.abbrevation,
                            child: Text(
                              value.abbrevation + " - " + value.countryName,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          walletController.selectedCountry.value =
                              value.toString();
                        },
                      ),
                    ),
                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        walletController.validateAndSubmit(context,
                            isFromCreateOwnerBankBalance: true);
                      },
                      height: 50,
                      textColor: AppColors.white,
                      text: StringConstants.addText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    height25SizedBox,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
