import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';

import 'package:thegreenmall/dashboard/wallet/view/add_card_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

import 'package:thegreenmall/utils/sizedbox_constants.dart';

import 'component/edit_auto_reload.dart';

class ManageWalletScreen extends StatefulWidget {
  const ManageWalletScreen({super.key});

  @override
  State<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends State<ManageWalletScreen> {
  final WalletController walletController = Get.put(WalletController());

  bottomSheetToAddMoney(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return const EditAutoReload();
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
                    Column(
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
                              color: AppColors.white, fontSize: 18),
                        ),
                        height12SizedBox,
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            ImageConstants.asofnow,
                            scale: 3.5,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            height40SizedBox,
            InkWell(
              onTap: (){
                bottomSheetToAddMoney(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      ImageConstants.autoreload,
                      scale: 3.2,
                    ),
                    width15SizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.autoReloadIntoWalletText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          StringConstants.editText,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.grey,
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  Get.to(const AddCardScreen());
                },
                child: Row(
                  children: [
                    Image.asset(ImageConstants.addcard, scale: 3.2),
                    width15SizedBox,
                    SharedPreferenceStorage.getData(Role.role.value) ==
                            Role.customerRoleText
                        ? Text(
                            StringConstants.addCardPaymentMethodsText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            StringConstants.addBankAccountDebitMethodsText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.grey,
              height: 35,
            ),
            Obx(
              () => walletController.cardList.isEmpty
                  ? height0SizedBox
                  : Text(
                      StringConstants.paymentMethodText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
            ),
            Obx(
              () => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: walletController.cardList.isEmpty
                    ? walletController.isLoading.value == true
                        ? height0SizedBox
                        : height0SizedBox
                    : ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            walletController
                                                .cardList[index].card!.funding
                                                .toString(),
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          height10SizedBox,
                                          Text(
                                            "**** **** **** **** ${walletController.cardList[index].card!.last4}",
                                            style: TextStyle(
                                                color: AppColors.blacklight,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                StringConstants.alertText,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.black,
                                                    fontSize: 20),
                                              ),
                                              content: Text(
                                                  AlertStringConstants
                                                      .areYouSureText,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.black,
                                                      fontSize: 20)),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      walletController.apiDeleteCard(
                                                          userStripeCardId:
                                                              walletController
                                                                      .cardList[
                                                                          index]
                                                                      .userStripeCardId ??
                                                                  "");
                                                    },
                                                    child: Text(StringConstants
                                                        .deleteText)),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(StringConstants
                                                      .cancelText),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        ImageConstants.deleteicon,
                                        scale: 3.0,
                                      )),
                                ]),
                          );
                        }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
