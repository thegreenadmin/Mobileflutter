import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_id_screen.dart';
import 'package:thegreenmall/dashboard/home/view/account/active_membership_screen.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/transaction_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

enum _SupportState {
  unknown,
}

class AccountScreen extends StatefulWidget {
  final bool? isFromCart ;
  const AccountScreen({super.key, this.isFromCart = false});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with GlobalVarMixin{
  final AccountController accountController = Get.isRegistered() ? Get.find<AccountController>() : Get.put(AccountController());

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState supportState = _SupportState.unknown;
  bool? canCheckBiometrics;
  List<BiometricType>? availableBiometrics;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';

      authenticatedBiometric.value = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: true, useErrorDialogs: true),
      );

      isAuthenticating = false;
      authenticated = authenticatedBiometric.value;
      authorized = 'Authenticating';
    } on PlatformException catch (e) {
      isAuthenticating = false;
      authorized = 'Error - ${e.message}';
      SharedPreferenceStorage.setData(StringConstants.authenticatedText, false);
      authenticatedBiometric.value = false;
      BioMetricAuthentication.isBioMetricAuthenticated.value = false;
      accountController.isScreenLockNotify.value = false;
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    authorized = message;

    if (authenticatedBiometric.value) {
      SharedPreferenceStorage.setData(StringConstants.authenticatedText, true);
      BioMetricAuthentication.isBioMetricAuthenticated.value = true;
      accountController.isScreenLockNotify.value = true;
    } else {
      SharedPreferenceStorage.setData(StringConstants.authenticatedText, false);
      authenticatedBiometric.value = false;
      BioMetricAuthentication.isBioMetricAuthenticated.value = false;
      accountController.isScreenLockNotify.value = false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountController.apiGetUserDetailApi();
      accountController.isFromCart.value = widget.isFromCart??false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(id: pageIdApp.value);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
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

                                    Get.parameters["orderId"] = "";
                                    Get.parameters[Role.role] =
                                        Role.storeOwnerRoleText;
                                    roleApp.value = Role.storeOwnerRoleText;
                                    Get.find<BottomNavController>().onReady();
                                    Get.until((route) => route.isFirst,
                                        id: pageIdApp.value);
                                  } else {
                                    SharedPreferenceStorage.setData(
                                        Role.role, Role.customerRoleText);

                                    roleApp.value = Role.customerRoleText;
                                    accountController.roleId?.value =
                                        Role.customerRoleText;
                                    Get.parameters["orderId"] = "";
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
                                              color: AppColors.blackLight,
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
                                    color: AppColors.blackLight,
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
                                            color: AppColors.blackLight,
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
                                // Check if user is guest - show modal for account-based features
                                if (isGuest.value == true) {
                                  GuestAccessModal.show(
                                    title: "Login Required",
                                    message: "Please login to access transaction history",
                                    onContinueAsGuest: () {
                                      // Allow guest to continue - just close modal
                                    },
                                  );
                                  return;
                                }
                                
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
                                    color: AppColors.blackLight,
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
                                    color: AppColors.blackLight,
                                  )
                                ],
                              ),
                            ),
                          Obx(
                              () => roleApp.value == Role.customerRoleText
                                  ? height0SizedBox
                                  : const Divider(
                                      height: 40,
                                      thickness: 1,
                                    ),
                            ),
                            /*  Obx(
                              () => roleApp.value == Role.customerRoleText
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
                                            color: AppColors.blackLight,
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                            const Divider(
                              height: 40,
                              thickness: 1,
                            ),*/
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
                                        color: AppColors.greyLight,
                                      ),
                                      inactiveSwitchBorder: Border.all(
                                        color: AppColors.greyLight,
                                      ),
                                      activeColor: AppColors.greyMediumLight,
                                      inactiveColor: AppColors.greyMediumLight,
                                      onToggle: (val) {
                                        accountController.isScreenLockNotify.value =
                                            val;
                                        if (accountController
                                            .isScreenLockNotify.value) {
                                          _authenticateWithBiometrics();
                                        } else {
                                          authenticatedBiometric.value = false;
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
                                  () => roleApp.value == Role.customerRoleText
                                      ? FlutterSwitch(
                                          height: 28,
                                          width: 50,
                                          value: accountController
                                              .isUserInboxMessagesNotify.value,
                                          activeToggleColor: AppColors.primary,
                                          inactiveToggleColor: AppColors.grey,
                                          activeSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          inactiveSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          activeColor: AppColors.greyMediumLight,
                                          inactiveColor: AppColors.greyMediumLight,
                                          onToggle: (val) {
                                            accountController
                                                .isUserInboxMessagesNotify
                                                .value = val;

                                            // if (accountController
                                            //     .isUserInboxMessagesNotify.value) {
                                            accountController
                                                .apiUpdateNotificationStatus(
                                                    isEnabled: accountController
                                                        .isUserInboxMessagesNotify
                                                        .value,
                                                    isOwner: false,
                                                    notificationType: "message");
                                            // } else {
                                            //   accountController
                                            //       .apiUpdateNotificationStatus(
                                            //           isEnabled: false,
                                            //           isOwner: false,
                                            //           notificationType: "message");
                                            // }
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
                                            color: AppColors.greyLight,
                                          ),
                                          inactiveSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          activeColor: AppColors.greyMediumLight,
                                          inactiveColor: AppColors.greyMediumLight,
                                          onToggle: (val) {
                                            accountController
                                                .isOwnerInboxMessagesNotify
                                                .value = val;

                                            // if (accountController
                                            //     .isOwnerInboxMessagesNotify.value) {
                                            accountController
                                                .apiUpdateNotificationStatus(
                                                    isEnabled: accountController
                                                        .isOwnerInboxMessagesNotify
                                                        .value,
                                                    isOwner: true,
                                                    notificationType: "message");
                                            // } else {
                                            //   accountController
                                            //       .apiUpdateNotificationStatus(
                                            //           isEnabled: false,
                                            //           isOwner: true,
                                            //           notificationType: "message");
                                            // }
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
                                  () => roleApp.value == Role.customerRoleText
                                      ? FlutterSwitch(
                                          height: 28,
                                          width: 50,
                                          value: accountController
                                              .isUserOfferNotify.value,
                                          activeToggleColor: AppColors.primary,
                                          inactiveToggleColor: AppColors.grey,
                                          activeSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          inactiveSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          activeColor: AppColors.greyMediumLight,
                                          inactiveColor: AppColors.greyMediumLight,
                                          onToggle: (val) {
                                            accountController
                                                .isUserOfferNotify.value = val;

                                            // if (accountController
                                            //     .isUserOfferNotify.value) {
                                            accountController
                                                .apiUpdateNotificationStatus(
                                                    isEnabled: accountController
                                                        .isUserOfferNotify.value,
                                                    isOwner: false,
                                                    notificationType: "offer");
                                            // } else {
                                            //   accountController
                                            //       .apiUpdateNotificationStatus(
                                            //           isEnabled: false,
                                            //           isOwner: false,
                                            //           notificationType: "offer");
                                            // }
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
                                            color: AppColors.greyLight,
                                          ),
                                          inactiveSwitchBorder: Border.all(
                                            color: AppColors.greyLight,
                                          ),
                                          activeColor: AppColors.greyMediumLight,
                                          inactiveColor: AppColors.greyMediumLight,
                                          onToggle: (val) {
                                            accountController
                                                .isOwnerOfferNotify.value = val;

                                            // if (accountController
                                            //     .isOwnerOfferNotify.value) {
                                            accountController
                                                .apiUpdateNotificationStatus(
                                                    isEnabled: accountController
                                                        .isOwnerOfferNotify.value,
                                                    isOwner: true,
                                                    notificationType: "offer");
                                            // } else {
                                            //   accountController
                                            //       .apiUpdateNotificationStatus(
                                            //           isEnabled: false,
                                            //           isOwner: true,
                                            //           notificationType: "offer");
                                            // }
                                          },
                                        ),
                                ),
                              ],
                            ),
                            height30SizedBox,
                            CustomButton(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColors.primary, AppColors.primary],
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
                              textColor: AppColors.white,
                              text: StringConstants.logoutText,
                              borderRadius: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            height30SizedBox,
                            CustomButton(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColors.redLight, AppColors.redLight],
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
              ],
            ),
            //LOADING OVERLAY
            Obx(() {
              return accountController.isLoading.value
                  ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
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
                            Image.asset(
                              ImageConstants.homeMall,
                              scale: 4,
                            ),
                            width10SizedBox,
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
                      ]),
                ],
              )),
        ));
  }
}
