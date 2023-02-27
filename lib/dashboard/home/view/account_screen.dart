import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';

import 'package:thegreenmall/dashboard/home/view/personal_info_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';

import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountController accountController = Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Column(
                  children: [
                    Row(
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
                                StringConstants.accountText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/homeMall.png",
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          )),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/userAccount.png",
                      scale: 3,
                    ),
                    width10SizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "John Jocobon",
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "johnjocobon@gmail.com",
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.profileText,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    height20SizedBox,
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(const PersonalInfoScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/person.png",
                                color: AppColors.primary,
                                scale: 3.5,
                              ),
                              width15SizedBox,
                              Text(StringConstants.personalInformationText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Image.asset(
                            "assets/arrowForward.png",
                            scale: 3.4,
                            color: AppColors.blacklight,
                          )
                        ],
                      ),
                    ),

                    const Divider(
                      height: 40,
                      thickness: 1,
                    ),

                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/cards.png",
                                color: AppColors.primary,
                                scale: 3.5,
                              ),
                              width15SizedBox,
                              Text(StringConstants.cardAndPaymentsText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Image.asset(
                            "assets/arrowForward.png",
                            scale: 3.4,
                            color: AppColors.blacklight,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 40,
                      thickness: 1,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/transactionHistory.png",
                                color: AppColors.primary,
                                scale: 3.5,
                              ),
                              width15SizedBox,
                              Text(StringConstants.transactionHistoryText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Image.asset(
                            "assets/arrowForward.png",
                            scale: 3.4,
                            color: AppColors.blacklight,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 40,
                      thickness: 1,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/accountId.png",
                                color: AppColors.primary,
                                scale: 3.5,
                              ),
                              width15SizedBox,
                              Text(StringConstants.accountIdText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Image.asset(
                            "assets/arrowForward.png",
                            scale: 3.4,
                            color: AppColors.blacklight,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 40,
                      thickness: 1,
                    ),
                    Text(
                      StringConstants.securityText,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    height20SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.screenLockText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => FlutterSwitch(
                              height: 28,
                              width: 50,
                              value: accountController.isScreenLockNotify.value,
                              activeToggleColor: AppColors.primary,
                              inactiveToggleColor: AppColors.grey,
                              activeSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              activeColor: AppColors.greymediumlight,
                              inactiveColor: AppColors.greymediumlight,
                              onToggle: (val) {
                                accountController.isScreenLockNotify.value =
                                    val;
                              },
                            )),
                      ],
                    ),
                    const Divider(
                      height: 40,
                      thickness: 1,
                    ),
                    Text(
                      StringConstants.notificationPreferencesText,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    height20SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.inboxMessages,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => FlutterSwitch(
                              height: 28,
                              width: 50,
                              value:
                                  accountController.isInboxMessagesNotify.value,
                              activeToggleColor: AppColors.primary,
                              inactiveToggleColor: AppColors.grey,
                              activeSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              activeColor: AppColors.greymediumlight,
                              inactiveColor: AppColors.greymediumlight,
                              onToggle: (val) {
                                accountController.isInboxMessagesNotify.value =
                                    val;
                              },
                            )),
                      ],
                    ),
                    height15SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.tippingReceiptsAndOrdersText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => FlutterSwitch(
                              height: 28,
                              width: 50,
                              value: accountController.isTippingNotify.value,
                              activeToggleColor: AppColors.primary,
                              inactiveToggleColor: AppColors.grey,
                              activeSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              activeColor: AppColors.greymediumlight,
                              inactiveColor: AppColors.greymediumlight,
                              onToggle: (val) {
                                accountController.isTippingNotify.value = val;
                              },
                            )),
                      ],
                    ),

                    height25SizedBox,
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                          width: Get.width * 0.90,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.redlight,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                color: AppColors.red,
                                size: 24.0,
                              ),
                              Text(StringConstants.logoutText,
                                  style: const TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          )),
                    ),
                    // CustomButton(
                    //   gradient: const LinearGradient(
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     colors: [AppColors.redlight, AppColors.redlight],
                    //   ),
                    //   onTap: () {},
                    //   height: 50,
                    //   textColor: AppColors.red,
                    //   text: StringConstants.logoutText,
                    //   borderRadius: 12,
                    //   fontWeight: FontWeight.w500,
                    //   icon: true,
                    //   fontSize: 16,
                    //   image: const Icon(
                    //     Icons.logout,
                    //     color: AppColors.red,
                    //     size: 24.0,
                    //   ),
                    // ),
                    height25SizedBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
