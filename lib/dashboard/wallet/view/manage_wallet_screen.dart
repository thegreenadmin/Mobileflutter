import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:thegreenmall/dashboard/more/view/webview_page_screen.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/payout_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'component/auto_reload_screen.dart';

class ManageWalletScreen extends StatefulWidget {
  const ManageWalletScreen({super.key});

  @override
  State<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends State<ManageWalletScreen> with GlobalVarMixin{
  final WalletController walletController = Get.put(WalletController());

  bottomSheetToAddMoney(context, {isFromEdit = false}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5, // Initial height as a fraction of the screen height
          minChildSize: 0.25, // Minimum height
          maxChildSize: 0.85, // Maximum height
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoReloadScreen(isFromEdit: isFromEdit),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => {walletController.apiGetCardList()});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Container(
          color: AppColors.primaryLight,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 20, top: 50, bottom: 10),
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
                          StringConstants.manageWalletText,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? height0SizedBox
                  : walletController.storeList.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: AppColors.grey,
                              size: 24.0,
                            ),
                            width4SizedBox,
                            Flexible(
                                child: Text(
                                    StringConstants
                                        .toKnowBalanceYouDoNotHaveText,
                                    style: TextStyle(
                                        color: AppColors.blackLight,
                                        fontSize: 18))),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                walletController.storeList.length == 1
                                    ? StringConstants.storeNameText
                                    : StringConstants.selectStoreText,
                                style: TextStyle(
                                    color: AppColors.blackLight, fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: walletController.storeList.length == 1
                                  ? Text(
                                      walletController.storeList[0].storeName
                                          .toString(),
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                  : DropdownButtonFormField<String>(
                                      value: walletController
                                                      .storeNameValue!.value !=
                                                  "" &&
                                              walletController
                                                      .ownerSelectedStore
                                                      .value !=
                                                  ""
                                          ? walletController.storeList
                                              .firstWhere((element) =>
                                                  element.storeId.toString() ==
                                                  walletController
                                                      .ownerSelectedStore.value)
                                              .storeId
                                          : null,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: AppColors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: AppColors.primary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: AppColors.primary,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: AppColors.primary,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      // hint: Text(
                                      //   StringConstants.selectStoreText,
                                      //   style: const TextStyle(
                                      //       color: AppColors.grey,
                                      //       fontSize: 14),
                                      // ),
                                      items: walletController.storeList
                                          .map((dynamic value) {
                                        return DropdownMenuItem<String>(
                                          value: value.storeId,
                                          child: Text(
                                            value.storeName,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        walletController.storeNameValue!.value =
                                            value.toString();
                                        walletController.ownerSelectedStore
                                            .value = value.toString();
                                        walletController
                                            .apiGetOwnerWalletBalance();
                                        walletController
                                            .apiGetStoreDetailsApi();
                                      },
                                    ),
                            ),
                          ],
                        ),
            ),
            height20SizedBox,
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  ImageConstants.walletCard,
                ),
                height20SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageConstants.dollar,
                      scale: 3.4,
                    ),
                    width15SizedBox,
                    Obx(() => roleApp.value == Role.customerRoleText
                        ? Column(
                            children: [
                              Obx(() => Text(
                                    "\$${walletController.userWalletBalance!.value}",
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500),
                                  )),
                              height8SizedBox,
                              Text(
                                StringConstants.totalBalanceText,
                                style: const TextStyle(
                                    color: AppColors.black, fontSize: 18),
                              ),
                              height12SizedBox,
                              InkWell(
                                  onTap: () {
                                    roleApp.value == Role.customerRoleText
                                        ? walletController
                                            .apiGetUserWalletBalance()
                                        : walletController
                                            .apiGetOwnerWalletBalance();
                                  },
                                  child:
                                      Obx(() => walletController.isLoading.value
                                          ? Center(
                                              child: LoadingAnimationWidget
                                                  .twistingDots(
                                                leftDotColor: AppColors.white,
                                                rightDotColor:
                                                    AppColors.primary,
                                                size: 50,
                                              ),
                                            )
                                          : Image.asset(
                                              ImageConstants.asofnow,
                                              scale: 3.5,
                                            ))),
                            ],
                          )
                        : Column(
                            children: [
                              Obx(() => Text(
                                    "\$${walletController.ownerWalletBalance!.value}",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500),
                                  )),
                              height8SizedBox,
                              Text(
                                StringConstants.totalBalanceText,
                                style: const TextStyle(
                                    color: AppColors.black, fontSize: 18),
                              ),
                              height12SizedBox,
                              InkWell(
                                  onTap: () {
                                    roleApp.value == Role.customerRoleText
                                        ? walletController
                                            .apiGetUserWalletBalance()
                                        : walletController
                                            .apiGetOwnerWalletBalance();
                                  },
                                  child:
                                      Obx(() => walletController.isLoading.value
                                          ? Center(
                                              child: LoadingAnimationWidget
                                                  .twistingDots(
                                                leftDotColor: AppColors.white,
                                                rightDotColor:
                                                    AppColors.primary,
                                                size: 50,
                                              ),
                                            )
                                          : Image.asset(
                                              ImageConstants.asofnow,
                                              scale: 3.3,
                                            ))),
                            ],
                          ))
                  ],
                )
              ],
            ),
            height30SizedBox,
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.autoreLoad,
                                scale: 3.2,
                              ),
                              width15SizedBox,
                              Obx(
                                () =>
                                    !walletController.isAutoRechargeEnable.value
                                        ? InkWell(
                                            onTap: () {
                                              // walletController.cardList.clear();
                                              // bottomSheetToAddMoney(context,
                                              //     isFromEdit: false);
                                            },
                                            child: Text(
                                              StringConstants
                                                  .autoReloadIntoWalletText,
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              walletController
                                                  .apiGetAutoRechargeDetail();
                                              bottomSheetToAddMoney(context,
                                                  isFromEdit: true);
                                            },
                                            child: Text(
                                              StringConstants
                                                  .editAutoReloadIntoWalletText,
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                              ),
                              height12SizedBox,
                            ],
                          ),
                          Obx(() => FlutterSwitch(
                                height: 28,
                                width: 50,
                                value:
                                    walletController.isAutoRechargeEnable.value,
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
                                onToggle: (val) async {
                                  walletController.isAutoRechargeEnable.value =
                                      val;
                                  if (walletController
                                      .isAutoRechargeEnable.value) {
                                    walletController
                                        .isAutoRechargeEnable.value = true;
                                    walletController.apiGetAutoRechargeDetail();
                                    bottomSheetToAddMoney(context);
                                  } else {
                                    walletController
                                        .isAutoRechargeEnable.value = false;
                                    if (walletController.getAutoRechargeModel
                                            .data!.userWalletAutoCharge !=
                                        null) {
                                      walletController.apiDisableAutoRecharge();
                                    }
                                  }
                                },
                              )),
                        ],
                      ),
                    )
                  : height0SizedBox,
            ),
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? const Divider(
                      color: AppColors.grey,
                      height: 35,
                    )
                  : height0SizedBox,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => const AddCardScreen(),
                          id: pageIdApp.value,
                        )!
                            .then((value) => walletController.apiGetCardList());
                      },
                      child: Row(children: [
                        Image.asset(ImageConstants.addcard, scale: 3.9),
                        width15SizedBox,
                        Text(
                          StringConstants.addCardPaymentMethodsText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                    ),
                    Obx(() => roleApp.value == Role.customerRoleText
                        ? height0SizedBox
                        : height10SizedBox),
                    Obx(
                      () => roleApp.value == Role.customerRoleText
                          ? height0SizedBox
                          : const Divider(
                              color: AppColors.grey,
                              height: 25,
                            ),
                    ),
                    roleApp.value == Role.customerRoleText
                        ? height0SizedBox
                        : InkWell(
                            onTap: () {
                              Get.to(
                                () => WebviewPageScreen(
                                    isFrom: "connectAccount",
                                    url: Uri.parse(
                                            walletController.accountLink.value)
                                        .toString()),
                                id: pageIdApp.value,
                              )!
                                  .then((value) {
                                walletController.apiGetAccountDetails();
                                walletController.apiGetBankAccountList();
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstants.addBank,
                                  scale: 20,
                                  color: AppColors.blackLight,
                                ),
                                width15SizedBox,
                                Text(
                                  StringConstants.connectBankAccountText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? height0SizedBox
                  : const Divider(
                      color: AppColors.grey,
                      height: 25,
                    ),
            ),
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? height0SizedBox
                  : InkWell(
                      onTap: () {
                        Get.to(
                          () => const PayOutScreen(),
                          id: pageIdApp.value,
                        )?.then((value) {
                          walletController.apiGetBankAccountList();
                          walletController.apiGetAccountDetails();
                          walletController.apiGetOwnerWalletBalance();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConstants.debitcard,
                              color: AppColors.blackLight,
                              scale: 18.2,
                            ),
                            width15SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringConstants.debitMoneyFromWalletText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            const Divider(
              color: AppColors.grey,
              height: 25,
            ),
            Obx(
              () => roleApp.value == Role.customerRoleText
                  ? walletController.cardList.isEmpty
                      ? height0SizedBox
                      : Text(
                          StringConstants.paymentMethodText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                  : walletController.bankAccountList.isEmpty
                      ? height0SizedBox
                      : Text(
                          StringConstants.bankAccountsText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
            ),
            Obx(() => roleApp.value == Role.customerRoleText
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: walletController.cardList.isEmpty
                        ? walletController.isLoading.value == true
                            ? height0SizedBox
                            : height0SizedBox
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height15SizedBox;
                            },
                            itemCount: walletController.cardList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 15, bottom: 15),
                                color: AppColors.primaryLight,
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
                                                const EdgeInsets.only(top: 8.0),
                                            child: Image.asset(
                                              walletController.cardList[index]
                                                          .card!.brand ==
                                                      StringConstants.visaText
                                                  ? ImageConstants.visacard
                                                  : walletController
                                                              .cardList[index]
                                                              .card!
                                                              .brand ==
                                                          StringConstants
                                                              .masterCardText
                                                      ? ImageConstants
                                                          .mastercard
                                                      : walletController
                                                                  .cardList[
                                                                      index]
                                                                  .card!
                                                                  .brand ==
                                                              StringConstants
                                                                  .americanExpressText
                                                          ? ImageConstants
                                                              .americanexpress
                                                          : walletController
                                                                      .cardList[
                                                                          index]
                                                                      .card!
                                                                      .brand ==
                                                                  StringConstants
                                                                      .discoverText
                                                              ? ImageConstants
                                                                  .discovecard
                                                              : ImageConstants
                                                                  .card,
                                              height: 20,
                                            ),
                                          ),
                                          width15SizedBox,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                walletController
                                                    .cardList[index].card!.brand
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              height10SizedBox,
                                              Text(
                                                "**** **** **** **** ${walletController.cardList[index].card!.last4}",
                                                style: TextStyle(
                                                    color: AppColors.blackLight,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            Utility.showConfirmAlertMessage(
                                                AlertStringConstants
                                                    .areYouSureText,
                                                okay:
                                                    StringConstants.deleteText,
                                                okayTap: () async {
                                              Get.back();
                                              walletController.apiDeleteCard(
                                                  userStripeCardId:
                                                      walletController
                                                              .cardList[index]
                                                              .userStripeCardId ??
                                                          "");
                                            });
                                          },
                                          child: Image.asset(
                                            ImageConstants.deleteicon,
                                            scale: 3.0,
                                          )),
                                    ]),
                              );
                            }),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: walletController.bankAccountList.isEmpty
                        ? walletController.isLoading.value == true
                            ? height0SizedBox
                            : height0SizedBox
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height15SizedBox;
                            },
                            itemCount: walletController.bankAccountList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 10, top: 15, bottom: 15),
                                color: AppColors.primaryLight,
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
                                          width15SizedBox,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                walletController
                                                    .bankAccountList[index]
                                                    .bank!
                                                    .bankName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              height10SizedBox,
                                              Text(
                                                "**** **** **** **** ${walletController.bankAccountList[index].bank!.last4}",
                                                style: TextStyle(
                                                    color: AppColors.blackLight,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      InkWell(
                                          onTap: () async {
                                            Get.to(
                                              () => WebviewPageScreen(
                                                  isFrom: "connectAccount",
                                                  url: Uri.parse(
                                                          walletController
                                                              .accountLink
                                                              .value)
                                                      .toString()),
                                              id: pageIdApp.value,
                                            )!
                                                .then((value) {
                                              walletController
                                                  .apiGetAccountDetails();
                                              walletController
                                                  .apiGetBankAccountList();
                                            });
                                          },
                                          child: Image.asset(
                                            ImageConstants.edit,
                                            scale: 3.0,
                                          )),

                                      // InkWell(
                                      //     onTap: () async {
                                      //       Utility.showConfirmAlertMessage(
                                      //           AlertStringConstants
                                      //               .areYouSureText,
                                      //           okay:
                                      //               StringConstants.deleteText,
                                      //           okayTap: () async {
                                      //         Navigator.pop(Get.context!);
                                      //         walletController.apiDeleteBankAccounts(
                                      //             userStripeBankId:
                                      //                 walletController
                                      //                         .bankAccountList[
                                      //                             index]
                                      //                         .userStripeBankId ??
                                      //                     "");
                                      //       });
                                      //     },
                                      //     child: Image.asset(
                                      //       ImageConstants.deleteicon,
                                      //       scale: 3.0,
                                      //     )),
                                    ]),
                              );
                            }),
                  ))
          ]),
        ),
      ),
    );
  }
}
