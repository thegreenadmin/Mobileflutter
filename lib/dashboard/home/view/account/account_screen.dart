import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_id_screen.dart';
import 'package:thegreenmall/dashboard/home/view/account/active_membership_screen.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/transaction_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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
    return WillPopScope(
      onWillPop: () async {
        Get.back(id: pageIdApp.value);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                    Get.back(id: pageIdApp.value);
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
                Obx(
                  () => hasStoreAccess.value == false
                      ? height0SizedBox
                      : const Divider(
                          thickness: 3,
                          height: 30,
                        ),
                ),
                Obx(
                  () => hasStoreAccess.value == false
                      ? height0SizedBox
                      : InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            if (roleApp.value == Role.customerRoleText) {
                              SharedPreferenceStorage.setData(
                                  Role.role, Role.storeOwnerRoleText);
                              accountController.roleId?.value =
                                  Role.storeOwnerRoleText;
                              Get.parameters[Role.role] =
                                  Role.storeOwnerRoleText;
                              roleApp.value = Role.storeOwnerRoleText;
                              Get.put(BottomNavController()).onReady();
                              Get.until((route) => route.isFirst,
                                  id: pageIdApp.value);
                            } else {
                              SharedPreferenceStorage.setData(
                                  Role.role, Role.customerRoleText);
                              roleApp.value = Role.customerRoleText;
                              accountController.roleId?.value =
                                  Role.customerRoleText;
                              Get.parameters[Role.role] = Role.customerRoleText;
                              Get.until((route) => route.isFirst,
                                  id: pageIdApp.value);
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 14.0, right: 14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text(
                                    roleApp.value == Role.customerRoleText
                                        ? StringConstants.switchToStoreText
                                        : StringConstants.switchToCustomerText,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.blacklight,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Image.asset(
                                  ImageConstants.switchicon,
                                  scale: 2.6,
                                ),
                              ],
                            ),
                          )),
                ),
                Obx(
                  () => hasStoreAccess.value == false
                      ? height0SizedBox
                      : const Divider(
                          thickness: 3,
                          height: 30,
                        ),
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
                          Get.to(() => const PersonalInfoScreen(),
                              id: pageIdApp.value);
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
                      Obx(
                        () => roleApp.value == Role.customerRoleText
                            ? InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Get.to(() => const AddCardScreen(),
                                      id: accountController.pageId.value);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImageConstants.cards,
                                          color: AppColors.primary,
                                          scale: 3.5,
                                        ),
                                        width15SizedBox,
                                        Text(
                                            StringConstants.cardAndPaymentsText,
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
                              )
                            : height0SizedBox,
                      ),
                      Obx(
                        () => roleApp.value.toString() == Role.customerRoleText
                            ? const Divider(
                                height: 40,
                                thickness: 1,
                              )
                            : height0SizedBox,
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          hasStoreAccess.value && permissionStoreList.isEmpty ||
                                  permissionStoreList.any((element) =>
                                      element.isStoreOwner == true ||
                                      element.controllers!.any((ele) =>
                                          ele.controllerKey ==
                                          PermissionKey
                                              .manageTransaction.statusName))
                              ? Get.to(() => const TransactionScreen(),
                                  id: pageIdApp.value)
                              : Utility.showAlertMessage(AlertStringConstants
                                  .notAuthorizedToStoreText);
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
                                Text(StringConstants.transactionsHistoryText,
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
                          Get.to(() => const AccountIdScreen(),
                              id: pageIdApp.value);
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
                      Obx(
                        () => accountController.roleId?.value.toString() ==
                                Role.customerRoleText
                            ? height0SizedBox
                            : const Divider(
                                height: 40,
                                thickness: 1,
                              ),
                      ),
                      Obx(
                        () => accountController.roleId?.value.toString() ==
                                Role.customerRoleText
                            ? height0SizedBox
                            : InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  hasStoreAccess.value &&
                                              permissionStoreList.isEmpty ||
                                          permissionStoreList.any((element) =>
                                              element.isStoreOwner == true)
                                      ? Get.to(
                                          () => const ActiveMembershipScreen(),
                                          id: pageIdApp.value)
                                      : Utility.showAlertMessage(
                                          AlertStringConstants
                                              .notAuthorizedToStoreText);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImageConstants.accountId,
                                          color: AppColors.primary,
                                          scale: 3.5,
                                        ),
                                        width15SizedBox,
                                        Text(
                                            StringConstants
                                                .activeMembershipsText,
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
                                value:
                                    accountController.isScreenLockNotify.value,
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
                                        StringConstants.authenticatedText,
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
                          Obx(
                            () => accountController.roleId?.value.toString() ==
                                    Role.customerRoleText
                                ? FlutterSwitch(
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
                                          .isUserInboxMessagesNotify
                                          .value = val;
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
                                  )
                                : FlutterSwitch(
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
                                          .isOwnerInboxMessagesNotify
                                          .value = val;

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
                                  ),
                          ),
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
                          Obx(
                            () => accountController.roleId?.value.toString() ==
                                    Role.customerRoleText
                                ? FlutterSwitch(
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
                                  )
                                : FlutterSwitch(
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
                                  ),
                          )
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
                          Obx(
                            () => accountController.roleId?.value.toString() ==
                                    Role.customerRoleText
                                ? FlutterSwitch(
                                    height: 28,
                                    width: 50,
                                    value: accountController
                                        .isUserOfferNotify.value,
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
                                          .isUserOfferNotify.value = val;

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
                                  )
                                : FlutterSwitch(
                                    height: 28,
                                    width: 50,
                                    value: accountController
                                        .isOwnerOfferNotify.value,
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
                                          .isOwnerOfferNotify.value = val;

                                      if (accountController
                                          .isOwnerOfferNotify.value) {
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
                                  ),
                          ),
                        ],
                      ),
                      height25SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primarylight,
                            AppColors.primarylight
                          ],
                        ),
                        onTap: () async {
                          Utility.showConfirmAlertMessage(
                              AlertStringConstants.areYouSureLogoutAccountText,
                              cancelText: StringConstants.noText,
                              okay: StringConstants.yesText, okayTap: () {
                            accountController.apiLogOutUser();
                          });
                        },
                        height: 50,
                        textColor: AppColors.primary,
                        text: StringConstants.logoutText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      height12SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.redlight, AppColors.redlight],
                        ),
                        onTap: () async {
                          Utility.showConfirmAlertMessage(
                              AlertStringConstants.areYouSureDeleteAccountText,
                              okay: StringConstants.deleteText, okayTap: () {
                            accountController.apiDeleteUserAccount();
                          });
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
      ),
    );
  }
}
