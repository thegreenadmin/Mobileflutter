import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/transaction_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/owner_transaction_detail_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/user_transaction_detail.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  Container _orderHistoryTab() {
    return Container(
      height: 47,
      width: WidgetConstants.screenWidth * 0.90,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            width: 0, //
            color: AppColors.blacklight),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (transactionController.isCurrentMonthSelected.value ==
                      true) {
                  } else {
                    transactionController.isCurrentMonthSelected.value =
                        !transactionController.isCurrentMonthSelected.value;
                  }
                  transactionController.role!.value == Role.customerRoleText
                      ? transactionController
                          .apiGetUserOrderTransactionHistory()
                      : transactionController
                          .apiGetOwnerOrderTransactionHistory();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: transactionController.isCurrentMonthSelected.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.currentMonthText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color:
                              transactionController.isCurrentMonthSelected.value
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (transactionController.isCurrentMonthSelected.value ==
                      false) {
                  } else {
                    transactionController.isCurrentMonthSelected.value =
                        !transactionController.isCurrentMonthSelected.value;
                  }

                  transactionController.role!.value == Role.customerRoleText
                      ? transactionController
                          .apiGetUserOrderTransactionHistory()
                      : transactionController
                          .apiGetOwnerOrderTransactionHistory();

                  //transactionController.userOrd!.clear();
                  transactionController.onIndexChange(0);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: transactionController.isCurrentMonthSelected.value
                      ? AppColors.white
                      : AppColors.primarylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.pastOrdersText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color:
                              transactionController.isCurrentMonthSelected.value
                                  ? AppColors.blacklight
                                  : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Padding horizontalMonthsTab() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 30,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width40SizedBox;
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: transactionController.horizontalTabList.length,
            itemBuilder: (_, i) {
              return Obx(() => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    transactionController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            transactionController.horizontalTabList[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  transactionController.selectedIndex.value == i
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                              color:
                                  transactionController.selectedIndex.value == i
                                      ? AppColors.primary
                                      : AppColors.blacklight,
                            ),
                          ),
                          height10SizedBox,
                          transactionController.selectedIndex.value == i
                              ? Container(
                                  width: 65,
                                  height: 1,
                                  color: AppColors.primary,
                                )
                              : height0SizedBox
                        ],
                      ),
                    ],
                  )));
            }),
      ),
    );
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
                                StringConstants.historyText,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _orderHistoryTab(),
            height20SizedBox,
            Obx(
              () => transactionController.isCurrentMonthSelected.value
                  ? height0SizedBox
                  : horizontalMonthsTab(),
            ),
            Obx(() => transactionController.role!.value == Role.customerRoleText
                ? Expanded(
                    child: transactionController.userTransactionList!.isEmpty
                        ? transactionController.isLoading.value == true
                            ? height0SizedBox
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      ImageConstants.nodata,
                                      scale: 8,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  height4SizedBox,
                                  Center(
                                    child: Text(
                                      AlertStringConstants.noHistoryFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height12SizedBox;
                            },
                            itemCount: transactionController
                                .userTransactionList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(
                                      () => const UserTransactionDetailScreen(),
                                      arguments: {
                                        "isFromTransaction": true,
                                        "user_stripe_card_id":
                                            transactionController
                                                    .userTransactionList![index]
                                                    .userStripeCardId ??
                                                "",
                                      });
                                  print(transactionController
                                      .userTransactionList![index]
                                      .userStripeCardId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: AppColors.greylight,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      )),
                                  child: Column(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 2,
                                            child: transactionController
                                                        .userTransactionList![
                                                            index]
                                                        .store ==
                                                    null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color:
                                                                AppColors.white,
                                                            width: 1)),
                                                    child: const CircleAvatar(
                                                      radius: 25.0,
                                                      backgroundImage:
                                                          AssetImage(
                                                        ImageConstants
                                                            .nopicfound,
                                                      ),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color:
                                                                AppColors.white,
                                                            width: 1)),
                                                    child: CircleAvatar(
                                                      radius: 25.0,
                                                      backgroundImage: transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .store!
                                                                      .image!
                                                                      .dynamicUrl ==
                                                                  null ||
                                                              transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .store!
                                                                  .image!
                                                                  .dynamicUrl!
                                                                  .isEmpty
                                                          ? const AssetImage(
                                                                  ImageConstants
                                                                      .nopicfound)
                                                              as ImageProvider
                                                          : NetworkImage(
                                                              transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .store!
                                                                  .image!
                                                                  .dynamicUrl
                                                                  .toString()),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                  )),
                                        width10SizedBox,
                                        Flexible(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: StringConstants
                                                                .orderIDText,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blacklight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14)),
                                                        TextSpan(
                                                          text: transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .orderTransaction !=
                                                                  null
                                                              ? ': #${transactionController.userTransactionList![index].orderTransaction!.orderTransactionId}'
                                                              : transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .orderItemRefundTransaction !=
                                                                      null
                                                                  ? ': #${transactionController.userTransactionList![index].transactionId}'
                                                                  : transactionController
                                                                              .userTransactionList![index]
                                                                              .transaction !=
                                                                          null
                                                                      ? ': #${transactionController.userTransactionList![index].transactionId}'
                                                                      : "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: AppColors
                                                                  .blacklight),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  width15SizedBox,
                                                  // Text(
                                                  //     Utility.parseDateTime(
                                                  //       DateTime.parse(
                                                  //         transactionController
                                                  //             .ownerOrderTransactionList[index].

                                                  //             .trim(),
                                                  //       ),
                                                  //       secFormat: '',
                                                  //     ).toString(),
                                                  //     style: TextStyle(
                                                  //         color: AppColors
                                                  //             .blacklight,
                                                  //         fontWeight:
                                                  //             FontWeight.w400,
                                                  //         fontSize: 14)),
                                                ],
                                              ),
                                              height8SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .store ==
                                                              null
                                                          ? "Wallet Transaction"
                                                          : transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .store!
                                                                  .storeName ??
                                                              "",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16)),
                                                  Text(
                                                    "\$" +
                                                        transactionController
                                                            .userTransactionList![
                                                                index]
                                                            .netBalance!
                                                            .toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                      "Transaction Type:",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14)),
                                                  transactionController
                                                              .userTransactionList![
                                                                  index]
                                                              .orderTransaction !=
                                                          null
                                                      ? const Text(
                                                          "Order Transaction")
                                                      : transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .orderItemRefundTransaction !=
                                                              null
                                                          ? const Text(
                                                              "Order Refund")
                                                          : transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .transaction !=
                                                                  null
                                                              ? const Text(
                                                                  "Wallet Recharge")
                                                              : const Text(" "),
                                                ],
                                              ),
                                              height6SizedBox,
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            }))
                : Expanded(
                    child: transactionController
                            .ownerOrderTransactionList!.isEmpty
                        ? transactionController.isLoading.value == true
                            ? height0SizedBox
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      ImageConstants.nodata,
                                      scale: 8,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  height4SizedBox,
                                  Center(
                                    child: Text(
                                      AlertStringConstants.noHistoryFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height12SizedBox;
                            },
                            itemCount: transactionController
                                .ownerOrderTransactionList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  transactionController
                                              .ownerOrderTransactionList![index]
                                              .orderTransaction !=
                                          null
                                      ? Get.to(
                                          const OwnerTransactionDetailScreen(),
                                          arguments: {
                                              "store_wallet_transaction_id":
                                                  transactionController
                                                      .ownerOrderTransactionList![
                                                          index]
                                                      .storeWalletTransactionId,
                                              "store_id": transactionController
                                                  .ownerOrderTransactionList![
                                                      index]
                                                  .storeId
                                            })
                                      : transactionController
                                                  .ownerOrderTransactionList![
                                                      index]
                                                  .orderItemRefundTransaction !=
                                              null
                                          ? Get.to(
                                              const OwnerTransactionDetailScreen(),
                                              arguments: {
                                                  "store_wallet_transaction_id":
                                                      transactionController
                                                          .ownerOrderTransactionList![
                                                              index]
                                                          .storeWalletTransactionId,
                                                  "store_id": transactionController
                                                      .ownerOrderTransactionList![
                                                          index]
                                                      .storeId
                                                })
                                          : null;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: AppColors.greylight,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      )),
                                  child: Column(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors.white,
                                                    width: 1)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: transactionController
                                                              .ownerOrderTransactionList![
                                                                  index]
                                                              .store!
                                                              .image!
                                                              .dynamicUrl ==
                                                          null ||
                                                      transactionController
                                                          .ownerOrderTransactionList![
                                                              index]
                                                          .store!
                                                          .image!
                                                          .dynamicUrl!
                                                          .isEmpty
                                                  ? const AssetImage(
                                                          ImageConstants
                                                              .nopicfound)
                                                      as ImageProvider
                                                  : NetworkImage(
                                                      transactionController
                                                          .ownerOrderTransactionList![
                                                              index]
                                                          .store!
                                                          .image!
                                                          .dynamicUrl
                                                          .toString()),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        width10SizedBox,
                                        Flexible(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: StringConstants
                                                                .orderIDText,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blacklight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14)),
                                                        TextSpan(
                                                          text: transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .orderTransaction !=
                                                                  null
                                                              ? ': #${transactionController.ownerOrderTransactionList![index].orderTransactionId}'
                                                              : transactionController
                                                                          .ownerOrderTransactionList![
                                                                              index]
                                                                          .orderItemRefundTransaction !=
                                                                      null
                                                                  ? ': #${transactionController.ownerOrderTransactionList![index].orderItemRefundTransaction!.returnOrderItemId}'
                                                                  : "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: AppColors
                                                                  .blacklight),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  width15SizedBox,
                                                  Text(
                                                      transactionController
                                                                  .ownerOrderTransactionList![
                                                                      index]
                                                                  .orderTransaction !=
                                                              null
                                                          ? Utility
                                                              .parseDateTime(
                                                              DateTime.parse(
                                                                  transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .createdAt
                                                                      .toString()),
                                                              secFormat: '',
                                                            ).toString()
                                                          : transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .orderItemRefundTransaction !=
                                                                  null
                                                              ? Utility
                                                                  .parseDateTime(
                                                                  DateTime.parse(transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .orderItemRefundTransaction!
                                                                      .createdAt
                                                                      .toString()),
                                                                  secFormat: '',
                                                                ).toString()
                                                              : "",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blacklight,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                ],
                                              ),
                                              height8SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      transactionController
                                                              .ownerOrderTransactionList![
                                                                  index]
                                                              .store!
                                                              .storeName ??
                                                          "",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16)),
                                                  Text(
                                                    "\$" +
                                                        transactionController
                                                            .ownerOrderTransactionList![
                                                                index]
                                                            .netBalance!
                                                            .toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              height6SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                      "Transaction Type:",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14)),
                                                  transactionController
                                                              .ownerOrderTransactionList![
                                                                  index]
                                                              .orderTransaction !=
                                                          null
                                                      ? const Text(
                                                          "Order Transaction")
                                                      : transactionController
                                                                  .ownerOrderTransactionList![
                                                                      index]
                                                                  .orderItemRefundTransaction !=
                                                              null
                                                          ? const Text(
                                                              "Order Refund")
                                                          :
                                                          // transactionController
                                                          //             .ownerOrderTransactionList![
                                                          //                 index]
                                                          //             .returnOrderItemId !=
                                                          //         null
                                                          //     ? const Text(
                                                          //         "Wallet Recharge")
                                                          //     :
                                                          const Text(" "),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            }))),
          ],
        ),
      ),
    );
  }
}
