import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_id_screen.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/transaction_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountController accountController = Get.put(AccountController());

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState supportState = _SupportState.unknown;
  bool? canCheckBiometrics;
  List<BiometricType>? availableBiometrics;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        isAuthenticating = true;
        authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        isAuthenticating = false;
        authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      setState(() {
        isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      authorized = message;
    });
    if (authenticated) {
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText.toLowerCase(), true);
      BioMetricAuthentication.isBioMetricAuthenticated.value = true;
      accountController.isScreenLockNotify.value = true;
    } else {
      SharedPreferenceStorage.setData(
          StringConstants.authenticatedText.toLowerCase(), false);
      BioMetricAuthentication.isBioMetricAuthenticated.value = false;
      accountController.isScreenLockNotify.value = false;
    }
  }

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
                            ImageConstants.homeMall,
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
                      ImageConstants.userAccount,
                      scale: 3,
                    ),
                    width10SizedBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                "${accountController.firstName!.value} ${accountController.lastName!.value}",
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              )),
                          Obx(() => Text(
                                accountController.email.value,
                                style: const TextStyle(
                                  overflow: TextOverflow.visible,
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
                height: 30,
              ),
              InkWell(
                  onTap: () async {
                    if (SharedPreferenceStorage.getData(Role.role.value)
                            .toString() ==
                        Role.customerRoleText) {
                      SharedPreferenceStorage.setData(
                          Role.role.value, Role.storeOwnerRoleText);
                      await Get.offAll(BottomNavigation());
                    } else {
                      SharedPreferenceStorage.setData(
                          Role.role.value, Role.customerRoleText);
                      await Get.offAll(BottomNavigation());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          SharedPreferenceStorage.getData(Role.role.value)
                                      .toString() ==
                                  Role.customerRoleText
                              ? StringConstants.switchToStoreText
                              : StringConstants.switchToCustomerText,
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w500),
                        ),
                        Image.asset(
                          ImageConstants.switchicon,
                          scale: 2.6,
                        ),
                      ],
                    ),
                  )),
              const Divider(
                thickness: 3,
                height: 30,
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
                                ImageConstants.person,
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
                            ImageConstants.arrowForward,
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
                      onTap: () {
                        Get.to(const AddCardScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.cards,
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
                            ImageConstants.arrowForward,
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
                      onTap: () {
                        Get.to(const TransactionScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.transactionHistory,
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
                            ImageConstants.arrowForward,
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
                      onTap: () {
                        Get.to(const AccountIdScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.accountId,
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
                            ImageConstants.arrowForward,
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
                                if (accountController
                                    .isScreenLockNotify.value) {
                                  _authenticateWithBiometrics();
                                } else {
                                  SharedPreferenceStorage.setData(
                                      StringConstants.authenticatedText
                                          .toLowerCase(),
                                      false);
                                  BioMetricAuthentication
                                      .isBioMetricAuthenticated.value = false;
                                }
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
                        SharedPreferenceStorage.getData(Role.role.value)
                                    .toString() ==
                                Role.customerRoleText
                            ? Obx(() => FlutterSwitch(

                                  height: 28,
                                  width: 50,
                                  value: accountController
                                      .isUserInboxMessagesNotify.value,
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
                                    accountController
                                        .isUserInboxMessagesNotify.value = val;
                                    if (accountController
                                        .isUserInboxMessagesNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: false,
                                              notificationType: "message");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: false,
                                              notificationType: "message");
                                    }
                                  },
                                ))
                            : Obx(() => FlutterSwitch(
                                  height: 28,
                                  width: 50,
                                  value: accountController
                                      .isOwnerInboxMessagesNotify.value,
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
                                    accountController
                                        .isOwnerInboxMessagesNotify.value = val;

                                    if (accountController
                                        .isOwnerInboxMessagesNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: true,
                                              notificationType: "message");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: true,
                                              notificationType: "message");
                                    }
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
                        SharedPreferenceStorage.getData(Role.role.value)
                                    .toString() ==
                                Role.customerRoleText
                            ? Obx(() => FlutterSwitch(
                                  height: 28,
                                  width: 50,
                                  value: accountController
                                      .isUserTippingNotify.value,
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
                                    accountController
                                        .isUserTippingNotify.value = val;
                                    if (accountController
                                        .isUserTippingNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: false,
                                              notificationType: "order");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: false,
                                              notificationType: "order");
                                    }
                                  },
                                ))
                            : Obx(() => FlutterSwitch(
                                  height: 28,
                                  width: 50,
                                  value: accountController
                                      .isOwnerTippingNotify.value,
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
                                    accountController
                                        .isOwnerTippingNotify.value = val;

                                    if (accountController
                                        .isOwnerTippingNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: true,
                                              notificationType: "order");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: true,
                                              notificationType: "order");
                                    }
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
                              StringConstants.storeOfferAndDiscountText,

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        SharedPreferenceStorage.getData(Role.role.value)
                                    .toString() ==
                                Role.customerRoleText
                            ? Obx(() => FlutterSwitch(
                                  height: 28,
                                  width: 50,
                                  value:
                                      accountController.isUserOfferNotify.value,
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
                                    accountController.isUserOfferNotify.value =
                                        val;

                                    if (accountController
                                        .isUserOfferNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: false,
                                              notificationType: "offer");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: false,
                                              notificationType: "offer");
                                    }
                                  },
                                ))
                            : Obx(() => FlutterSwitch(
                                  height: 28,
                                  width: 50,
                                  value: accountController
                                      .isOnwerOfferNotify.value,
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
                                    accountController.isOnwerOfferNotify.value =
                                        val;

                                    if (accountController
                                        .isOnwerOfferNotify.value) {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: true,
                                              isOwner: true,
                                              notificationType: "offer");
                                    } else {
                                      accountController
                                          .apiUpdateNotificationStatus(
                                              isEnabled: false,
                                              isOwner: true,
                                              notificationType: "offer");
                                    }
                                  },
                                )),
                      ],
                    ),
                    height25SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.redlight, AppColors.redlight],
                      ),
                      onTap: () async {
                        SharedPreferenceStorage.clearData();
                        await Get.offAll(const StartJourneyScreen());
                      },
                      height: 50,
                      textColor: AppColors.red,
                      text: StringConstants.deleteAccountText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
