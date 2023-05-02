import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
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
                            Get.back();
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
            key: walletController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      StringConstants.accountHolderTypeText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height20SizedBox,
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
                              fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),

                    // TextFormField(
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     textInputAction: TextInputAction.next,
                    //     autofocus: false,
                    //     textCapitalization: TextCapitalization.words,
                    //     inputFormatters: <TextInputFormatter>[
                    //       LengthLimitingTextInputFormatter(40),
                    //     ],
                    //     style: const TextStyle(
                    //         color: AppColors.black,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w400),
                    //     controller:
                    //         walletController.accountHolderTypeTextController,
                    //     keyboardType: TextInputType.text,
                    //     validator: (value) {
                    //       if (value == null || value.trim().isEmpty) {
                    //         return AlertStringConstants
                    //             .pleaseEnterAccountTypeText;
                    //       }
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //       isDense: true,
                    //       hintText: StringConstants.accountHolderTypeText,
                    //       hintStyle: const TextStyle(color: AppColors.grey),
                    //       fillColor: Colors.white,
                    //       border: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       errorBorder: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.grey,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //     )),
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
                      StringConstants.selectCountryText,
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
                        controller: walletController.countryTextController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterCountry;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: StringConstants.countryText,
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
                    // DropdownButtonFormField<String>(
                    //   isExpanded: true,
                    //   decoration: InputDecoration(
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.grey,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     border: UnderlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     errorBorder: UnderlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //   ),
                    //   hint: Text(
                    //     StringConstants.selectCountryText,
                    //     style: const TextStyle(
                    //       color: AppColors.grey,
                    //     ),
                    //   ),
                    //   items: walletController.countriesList.map((dynamic value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value.countryName,
                    //       child: Text(
                    //         value.countryName,
                    //         style: const TextStyle(
                    //             color: AppColors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w500),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     walletController.selectedCountry.value = value.toString();
                    //   },
                    // ),
                    height20SizedBox,
                    Text(
                      StringConstants.currencyText,
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
                        controller: walletController.currencyTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterCurrencyText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: StringConstants.currencyText,
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
                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        walletController.validateAndSubmit(
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
