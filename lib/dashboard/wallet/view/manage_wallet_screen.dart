import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:thegreenmall/dashboard/more/view/webview_page_screen.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/create_owner_bankaccount_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/payout_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

import 'component/auto_reload_screen.dart';

class ManageWalletScreen extends StatefulWidget {
  const ManageWalletScreen({super.key});

  @override
  State<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends State<ManageWalletScreen> {
  final WalletController walletController = Get.put(WalletController());

  bottomSheetToAddMoney(context, {isFromEdit = false}) {
    walletController.isautoRechargeEnable.value = false;
    walletController.chargeAmountTextController.clear();
    walletController.thresholdAmountTextController.clear();
    walletController.thresholdAmountTextController.clear();
    walletController.autoChargeType.value = "";
    walletController.selectedFrequency.value = "";

    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext ctxx) {
          // return StatefulBuilder(
          //     builder: (BuildContext context, StateSetter setState) {

          return Padding(
            padding: MediaQuery.of(ctxx).viewInsets,
            child: Wrap(
                children: <Widget>[AutoReloadScreen(isFromEdit: isFromEdit)]),
          );
        }).then((value) => {
          // walletController.isautoRechargeEnable.value = false,
          // walletController.chargeAmountTextController.clear(),
          // walletController.thresholdAmountTextController.clear(),
          // walletController.thresholdAmountTextController.clear(),
          // walletController.autoChargeType.value = "",
        });
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
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // Get.back();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.black,
                            size: 24.0,
                          ),
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.walletText,
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
              () => walletController.role!.value == Role.customerRoleText
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
                                child: Text(StringConstants
                                    .toKnowBalanceYouDontHaveText)),
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
                                    color: AppColors.blacklight, fontSize: 18),
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
                                                  null &&
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
                    Obx(() => walletController.role!.value ==
                            Role.customerRoleText
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
                                    SharedPreferenceStorage.getData(
                                                Role.role.value) ==
                                            Role.customerRoleText
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
                                    SharedPreferenceStorage.getData(
                                                Role.role.value) ==
                                            Role.customerRoleText
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
                          ))
                  ],
                )
              ],
            ),
            height30SizedBox,
            Obx(
              () => walletController.role!.value == Role.customerRoleText
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.autoreload,
                                scale: 3.2,
                              ),
                              width15SizedBox,
                              Obx(
                                () =>
                                    !walletController.isautoRechargeEnable.value
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
                                              await walletController
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
                                    walletController.isautoRechargeEnable.value,
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
                                  walletController.isautoRechargeEnable.value =
                                      val;
                                  if (walletController
                                      .isautoRechargeEnable.value) {
                                    walletController
                                        .isautoRechargeEnable.value = true;
                                    bottomSheetToAddMoney(context);
                                  } else {
                                    walletController
                                        .isautoRechargeEnable.value = false;
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
              () => walletController.role!.value == Role.customerRoleText
                  ? const Divider(
                      color: AppColors.grey,
                      height: 35,
                    )
                  : height0SizedBox,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => InkWell(
                    onTap: () async {
                      SharedPreferenceStorage.setData("context", context);

                      walletController.role!.value == Role.customerRoleText
                          ? Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (_) => const AddCardScreen(),
                              ))
                              // Get.to(const AddCardScreen())!
                              .then((value) =>
                                  walletController.apiGetCardList(context))
                          : Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (_) => const CreateOwnerBankAccount(),
                              ))
                              // Get.to(const CreateOwnerBankAccount())!
                              .then((value) =>
                                  walletController.apiGetBankAccountList());
                    },
                    child: walletController.role!.value == Role.customerRoleText
                        ? Row(children: [
                            Image.asset(ImageConstants.addcard, scale: 3.2),
                            width15SizedBox,
                            Text(
                              StringConstants.addCardPaymentMethodsText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ])
                        : walletController.capability.value == "active" &&
                                walletController.payouts.value == true
                            ? height0SizedBox
                            //  Row(
                            //     children: [
                            //       Image.asset(
                            //         ImageConstants.addBank,
                            //         scale: 20,
                            //         color: AppColors.blacklight,
                            //       ),
                            //       width15SizedBox,
                            //       Text(
                            //         StringConstants
                            //             .addBankAccountDebitMethodsText,
                            //         style: const TextStyle(
                            //             color: AppColors.black,
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w500),
                            //       ),
                            //     ],
                            //   )
                            : InkWell(
                                onTap: () {
                                  SharedPreferenceStorage.setData(
                                      "context", context);
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => WebviewPageScreen(
                                              isFrom: "connectAccount",
                                              url: Uri.parse(walletController
                                                      .accountLink.value)
                                                  .toString())))
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
                                      color: AppColors.blacklight,
                                    ),
                                    width15SizedBox,
                                    const Text(
                                      "Connect Bank Account",
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )),
              ),
            ),
            Obx(
              () => walletController.role!.value == Role.customerRoleText
                  ? height0SizedBox
                  : walletController.capability.value == "active" &&
                          walletController.payouts.value == true
                      ? height0SizedBox
                      : const Divider(
                          color: AppColors.grey,
                          height: 25,
                        ),
            ),
            Obx(
              () => walletController.role!.value == Role.customerRoleText
                  ? height0SizedBox
                  : InkWell(
                      onTap: () {
                        SharedPreferenceStorage.setData("context", context);
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (_) => const PayOutScreen(),
                        ))
                            .then((value) {
                          walletController.apiGetBankAccountList();
                          walletController.apiGetAccountDetails();
                        });
                        // Get.to(const PayOutScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConstants.debitcard,
                              color: AppColors.blacklight,
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
              () => walletController.role!.value == Role.customerRoleText
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
            Obx(() => walletController.role!.value == Role.customerRoleText
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
                                    left: 20, right: 10, top: 15, bottom: 15),
                                color: AppColors.primarylight,
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
                                                ImageConstants.mastercard,
                                                fit: BoxFit.cover,
                                                scale: 5),
                                          ),
                                          width15SizedBox,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                walletController.cardList[index]
                                                    .card!.funding
                                                    .toString(),
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
                                                    color: AppColors.blacklight,
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
                                              Navigator.pop(Get.context!);
                                              walletController.apiDeleteCard(
                                                  context,
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
                                color: AppColors.primarylight,
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
                                                    color: AppColors.blacklight,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
