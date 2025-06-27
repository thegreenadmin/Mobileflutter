import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet_customer.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet_owner.dart';
import 'package:thegreenmall/dashboard/wallet/view/manage_wallet_screen.dart';
import 'package:thegreenmall/utils/common_appBar.dart';
import 'package:thegreenmall/utils/utils.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with GlobalVarMixin{
  final WalletController walletController = Get.put(WalletController());
  var roleVal = "";
  String storeName = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(

      body: Stack(
        children: [
          Column(
            children: [
              Obx(() => CommonAppBar(
                  showActiveCart: true,
                  role: walletController.role!.value,
                  cartCount:
                  walletController.searchStoreUserController.cartCount.value,
                  storeId:
                  walletController.searchStoreUserController.storeIdValue.value,
                  cartLength:
                  walletController.searchStoreUserController.cartCount.value,
                  firstName: walletController.firstName!.value,
                  labelText: StringConstants.walletText,
                  lastName: walletController.lastName!.value,
                  okayTap: () {
                    walletController.searchStoreUserController.apiActiveCartApi();
                  },
                  isFromNotification: false)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Obx(
                    () => roleApp.value == Role.customerRoleText
                        ? height0SizedBox
                        : walletController.storeList.isEmpty
                            ? walletController.isStoresLoading.value
                                ? height0SizedBox
                                : Row(
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
                                            autovalidateMode:
                                                AutovalidateMode.onUserInteraction,
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
                                            hint: Text(
                                              StringConstants.selectStoreText,
                                              style: const TextStyle(
                                                  color: AppColors.grey,
                                                  fontSize: 14),
                                            ),
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
                                    walletController.isLoading.value
                                        ? Center(
                                            child:
                                                LoadingAnimationWidget.twistingDots(
                                              leftDotColor: AppColors.white,
                                              rightDotColor: AppColors.primary,
                                              size: 50,
                                            ),
                                          )
                                        : Text(
                                            "\$${walletController.userWalletBalance?.value ?? "0.00"}",
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500),
                                          ),
                                    height8SizedBox,
                                    Text(
                                      StringConstants.totalBalanceText,
                                      style: const TextStyle(
                                          color: AppColors.white, fontSize: 18),
                                    ),
                                    height12SizedBox,
                                    InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => const AddMoneyToWalletUser(),
                                          id: pageIdApp.value,
                                        )!
                                            .then((value) => walletController
                                                .apiGetUserWalletBalance());
                                      },
                                      child: Image.asset(
                                        ImageConstants.addMoney,
                                        scale: 3.5,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    walletController.isLoading.value
                                        ? Center(
                                            child:
                                                LoadingAnimationWidget.twistingDots(
                                              leftDotColor: AppColors.white,
                                              rightDotColor: AppColors.primary,
                                              size: 50,
                                            ),
                                          )
                                        : Text(
                                            "\$${walletController.ownerWalletBalance!.value}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500),
                                          ),
                                    height4SizedBox,
                                    Text(
                                      StringConstants.totalBalanceText,
                                      style: const TextStyle(
                                          color: AppColors.black, fontSize: 18),
                                    ),
                                    height10SizedBox,
                                    InkWell(
                                      onTap: () {
                                        if (walletController.storeList.isEmpty) {
                                          Utility.showAlertMessage(
                                              "Please add a store first");
                                          return;
                                        }
                                        Get.to(
                                          () =>  AddMoneyToWalletOwner( selectedStore : walletController.ownerSelectedStore.value ?? ""),
                                          id: pageIdApp.value,
                                        )!
                                            .then((value) => walletController
                                                .apiGetOwnerWalletBalance());
                                      },
                                      child: Image.asset(
                                        ImageConstants.addMoney,
                                        scale: 3.5,
                                      ),
                                    ),
                                  ],
                                ))
                        ],
                      )
                    ],
                  ),
                  height25SizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (roleApp.value == Role.storeOwnerRoleText &&
                                walletController.storeList.isEmpty) {
                              Utility.showAlertMessage("Please add a store first");
                              return;
                            }
                            Get.to(
                              () => const ManageWalletScreen(),
                              id: pageIdApp.value,
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                ImageConstants.setting,
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
                      ),
                      // SharedPreferenceStorage.getData(Role.role) ==
                      //         Role.customerRoleText
                      //     ? Container(
                      //         color: AppColors.grey,
                      //         width: 1,
                      //         height: 40,
                      //       )
                      //     : height0SizedBox,
                      // SharedPreferenceStorage.getData(Role.role) ==
                      //         Role.customerRoleText
                      //     ? Expanded(
                      //         flex: 4,
                      //         child: Column(
                      //           children: [
                      //             Image.asset(
                      //               ImageConstants.pickUp,
                      //               scale: 3.5,
                      //             ),
                      //             Text(
                      //               StringConstants.pickupPackageText,
                      //               style: const TextStyle(
                      //                   fontSize: 16,
                      //                   color: AppColors.black,
                      //                   fontWeight: FontWeight.w500),
                      //             )
                      //           ],
                      //         ),
                      //       )
                      //     : height0SizedBox,
                    ],
                  ),
                  height30SizedBox,
                  Obx(() => roleApp.value == Role.customerRoleText
                      ? height0SizedBox
                      : Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Column(
                                //   children: [
                                //     Image.asset(
                                //       ImageConstants.rounddownload,
                                //       scale: 3,
                                //     ),
                                //     const Text(
                                //       "Download",
                                //       style: TextStyle(
                                //           fontSize: 14, fontWeight: FontWeight.w600),
                                //     ),
                                //   ],
                                // ),
                                // QrImage(
                                //   data: walletController.dynamicLink.value.toString(),
                                //   size: 150,
                                //   embeddedImageStyle: QrEmbeddedImageStyle(
                                //     size: const Size(
                                //       50,
                                //       50,
                                //     ),
                                //   ),
                                // ),
                                // InkWell(
                                //   onTap: () async {
                                //     if (Platform.isIOS) {
                                //       await Share.share(
                                //         "Let's connect on The Green Mall! Get it at${walletController.dynamicLink.value}",
                                //       );
                                //     } else {
                                //       await Share.share(
                                //         "Let's connect on The Green Mall! Get it at${walletController.dynamicLink.value}",
                                //       );
                                //     }
                                //   },
                                //   child: Column(
                                //     children: [
                                //       Image.asset(
                                //         ImageConstants.roundshare,
                                //         scale: 3,
                                //       ),
                                //       const Text(
                                //         "Share",
                                //         style: TextStyle(
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.w600),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            height10SizedBox,
                            // const Center(
                            //   child: Text(
                            //     "Scan QR Code",
                            //     style: TextStyle(
                            //         fontSize: 14, fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                            height8SizedBox,
                            // const Center(
                            //   child: Text(
                            //       "It is a long established fact that a reader will be distracted by the readable content",
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(
                            //           fontSize: 14, fontWeight: FontWeight.w500)),
                            // ),
                          ],
                        ))
                ]),
              ),
            ],
          ),
          //LOADING OVERLAY
          Obx(() {
            return walletController.isLoading.value
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
    );
  }
}
