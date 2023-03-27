import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletController walletController = Get.put(WalletController());

  bottomSheetToAddMoney(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              StringConstants.addMoneyToMyWalletText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                "assets/cross.png",
                                scale: 3,
                              ))
                        ],
                      ),
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
                ),
              ],
            );
          });
        }).then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, ${SharedPreferenceStorage.getData(StringConstants.firstNameText) + " " + SharedPreferenceStorage.getData(StringConstants.lastNameText)}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        Text(
                          StringConstants.walletText,
                          style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Image.asset(
                      "assets/homeMall.png",
                      scale: 4,
                    )
                  ])),
        ),
      ),
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/walletCard.png"),
              height20SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/dollar.png",
                    scale: 3.4,
                  ),
                  width15SizedBox,
                  Column(
                    children: [
                      const Text(
                        "\$30,420",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w500),
                      ),
                      height8SizedBox,
                      const Text(
                        "Total Balance",
                        style: TextStyle(color: AppColors.white, fontSize: 18),
                      ),
                      height12SizedBox,
                      InkWell(
                        onTap: () {
                          bottomSheetToAddMoney(context);
                        },
                        child: Image.asset(
                          "assets/addMoney.png",
                          scale: 3.5,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          height20SizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/setting.png",
                      scale: 3.5,
                    ),
                    Text(
                      StringConstants.manageText,
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              // Divider(color: AppColors.red),
              Container(
                color: AppColors.grey,
                width: 1,
                height: 40,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/pickup.png",
                      scale: 3.5,
                    ),
                    Text(
                      StringConstants.pickupPackageText,
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),

              //FOR STORE OWNER

              // Expanded(
              //   flex: 4,
              //   child: Column(
              //     children: [
              //       Image.asset(
              //         "assets/addFunds.png",
              //         scale: 3.5,
              //       ),
              //       Text(
              //         StringConstants.addFundsText,
              //         style: const TextStyle(
              //             fontSize: 16,
              //             color: AppColors.black,
              //             fontWeight: FontWeight.w500),
              //       )
              //     ],
              //   ),
              // ),
            ],
          )
        ]),
      ),
    );
  }
}
