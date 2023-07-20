import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/transaction_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
                  roleApp.value == Role.customerRoleText
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
                          fontWeight:
                              transactionController.isCurrentMonthSelected.value
                                  ? FontWeight.w600
                                  : FontWeight.w400,
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
                onTap: () async {
                  if (transactionController.isCurrentMonthSelected.value ==
                      false) {
                  } else {
                    transactionController.isCurrentMonthSelected.value =
                        !transactionController.isCurrentMonthSelected.value;
                  }

                  roleApp.value == Role.customerRoleText
                      ? transactionController
                          .apiGetUserOrderTransactionHistory()
                      : transactionController
                          .apiGetOwnerOrderTransactionHistory();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    transactionController.ownerOrderTransactionList!.clear();
                    transactionController.userTransactionList!.clear();
                    transactionController.onIndexChange(0);
                  });
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
                          fontWeight:
                              transactionController.isCurrentMonthSelected.value
                                  ? FontWeight.w400
                                  : FontWeight.w600,
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
                                      ? FontWeight.w600
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
                                  // Navigator.of(context).pop();
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
                                StringConstants.transactionsHistoryText,
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
            Obx(() => roleApp.value == Role.customerRoleText
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
                                  // SharedPreferenceStorage.setData(
                                  //     "context", context);
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (_) =>
                                  //       const UserTransactionDetailScreen(),
                                  // ));
                                  // Get.parameters["isFromTransaction"] = "true";
                                  // Get.parameters["user_stripe_card_id"] =
                                  //     transactionController
                                  //             .userTransactionList![index]
                                  //             .userWalletTransactionId ??
                                  //         "";
                                  /* Get.to(
                                      () => const UserTransactionDetailScreen(),
                                      arguments: {
                                        "isFromTransaction": true,
                                        "user_stripe_card_id":
                                            transactionController
                                                    .userTransactionList![index]
                                                    .userWalletTransactionId ??
                                                "",
                                      });*/
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
                                                            .storeicon,
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
                                                                      .logo!
                                                                      .dynamicUrl ==
                                                                  null ||
                                                              transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .store!
                                                                  .logo!
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
                                                                  .logo!
                                                                  .dynamicUrl
                                                                  .toString()),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                  )),
                                        width10SizedBox,
                                        Flexible(
                                          flex: 10,
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
                                                            text: transactionController
                                                                        .userTransactionList![
                                                                            index]
                                                                        .orderTransaction !=
                                                                    null
                                                                ? StringConstants
                                                                    .orderIDText
                                                                : transactionController
                                                                            .userTransactionList![
                                                                                index]
                                                                            .membership !=
                                                                        null
                                                                    ? StringConstants
                                                                        .membershipIdText
                                                                    : StringConstants
                                                                        .transactionIdText,
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
                                                              ? ': #${transactionController.userTransactionList![index].orderTransaction!.orderId}'
                                                              : transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .orderItemRefundTransaction !=
                                                                      null
                                                                  ? ': #${transactionController.userTransactionList![index].orderItemRefundTransaction!.orderItemRefundTransactionId}'
                                                                  : transactionController
                                                                              .userTransactionList![
                                                                                  index]
                                                                              .transaction !=
                                                                          null
                                                                      ? ': #${transactionController.userTransactionList![index].transaction!.transactionId}'
                                                                      : transactionController.userTransactionList![index].membership !=
                                                                              null
                                                                          ? ': #${transactionController.userTransactionList![index].membership!.membershipId}'
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
                                                                  .userTransactionList![
                                                                      index]
                                                                  .orderTransaction !=
                                                              null
                                                          ? Utility
                                                              .parseDateTime(
                                                              DateTime.parse(
                                                                  transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .createdAt
                                                                      .toString()),
                                                              secFormat: '',
                                                            ).toString()
                                                          : transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .orderItemRefundTransaction !=
                                                                  null
                                                              ? Utility
                                                                  .parseDateTime(
                                                                  DateTime.parse(transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .createdAt
                                                                      .toString()),
                                                                  secFormat: '',
                                                                ).toString()
                                                              : transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .transaction !=
                                                                      null
                                                                  ? Utility
                                                                      .parseDateTime(
                                                                      DateTime.parse(transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .createdAt
                                                                          .toString()),
                                                                      secFormat:
                                                                          '',
                                                                    ).toString()
                                                                  : transactionController
                                                                              .userTransactionList![
                                                                                  index]
                                                                              .membership !=
                                                                          null
                                                                      ? Utility
                                                                              .parseDateTime(
                                                                          DateTime.parse(transactionController
                                                                              .userTransactionList![index]
                                                                              .createdAt
                                                                              .toString()),
                                                                          secFormat:
                                                                              '',
                                                                        )
                                                                          .toString()
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
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        transactionController
                                                                    .userTransactionList![
                                                                        index]
                                                                    .store ==
                                                                null
                                                            ? transactionController
                                                                        .userTransactionList![
                                                                            index]
                                                                        .membership !=
                                                                    null
                                                                ? StringConstants
                                                                    .membershipTransactionText
                                                                : StringConstants
                                                                    .walletTransactionText
                                                            : transactionController
                                                                    .userTransactionList![
                                                                        index]
                                                                    .store!
                                                                    .storeName ??
                                                                "",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14)),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .orderTransaction !=
                                                              null
                                                          ? "\$${transactionController.userTransactionList![index].orderTransaction!.totalAmount!.toStringAsFixed(2)}"
                                                          : transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .orderItemRefundTransaction !=
                                                                  null
                                                              ? "\$${transactionController.userTransactionList![index].orderItemRefundTransaction!.transaction!.transactionAmount!.toStringAsFixed(2)}"
                                                              : transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .transaction !=
                                                                      null
                                                                  ? "\$${transactionController.userTransactionList![index].transaction!.transactionAmount!.toStringAsFixed(2)}"
                                                                  : transactionController
                                                                              .userTransactionList![index]
                                                                              .membership !=
                                                                          null
                                                                      ? "\$${transactionController.userTransactionList![index].membership!.membershipCharge!.toStringAsFixed(2)}"
                                                                      : "",
                                                      textAlign: TextAlign.end,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${StringConstants.transactionText}: ",
                                                      style: const TextStyle(
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
                                                      ? transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .orderTransaction!
                                                                  .orderTransactionType ==
                                                              "order"
                                                          ? Text(StringConstants
                                                              .debitText)
                                                          : Text(StringConstants
                                                              .creditText)
                                                      : transactionController
                                                                  .userTransactionList![
                                                                      index]
                                                                  .orderItemRefundTransaction !=
                                                              null
                                                          ? Text(StringConstants
                                                              .creditText)
                                                          : transactionController
                                                                      .userTransactionList![
                                                                          index]
                                                                      .transaction !=
                                                                  null
                                                              ? Text(StringConstants
                                                                  .walletTransactionText)
                                                              : transactionController
                                                                          .userTransactionList![
                                                                              index]
                                                                          .membership !=
                                                                      null
                                                                  ? Text(StringConstants
                                                                      .debitText)
                                                                  : const Text(
                                                                      ""),
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
                    child:
                        transactionController.ownerOrderTransactionList!.isEmpty
                            ? transactionController.isLoading.value == true
                                ? height0SizedBox
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          AlertStringConstants
                                              .noHistoryFoundText,
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
                                      // SharedPreferenceStorage.setData(
                                      //     "context", context);
                                      // Get.parameters[
                                      //         "store_wallet_transaction_id"] =
                                      //     transactionController
                                      //         .ownerOrderTransactionList![index]
                                      //         .storeWalletTransactionId;
                                      // Get.parameters["store_id"] =
                                      //     transactionController
                                      //         .ownerOrderTransactionList![index]
                                      //         .storeId;
                                      // transactionController
                                      //             .ownerOrderTransactionList![index]
                                      //             .orderTransaction !=
                                      //         null
                                      //     ? Navigator.of(context)
                                      //         .push(MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             const OwnerTransactionDetailScreen(),
                                      //       ))

                                      /* Get.to(
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
                                                })*/
                                      // : transactionController
                                      //             .ownerOrderTransactionList![
                                      //                 index]
                                      //             .orderItemRefundTransaction !=
                                      //         null
                                      //     ? Navigator.of(context)
                                      //         .push(MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             const OwnerTransactionDetailScreen(),
                                      //       ))

                                      /*Get.to(
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
                                                        })*/
                                      // : null;
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
                                                                  .logo!
                                                                  .dynamicUrl ==
                                                              null ||
                                                          transactionController
                                                              .ownerOrderTransactionList![
                                                                  index]
                                                              .store!
                                                              .logo!
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
                                                              .logo!
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
                                                                text: transactionController
                                                                            .ownerOrderTransactionList![
                                                                                index]
                                                                            .orderTransaction !=
                                                                        null
                                                                    ? StringConstants
                                                                        .orderIDText
                                                                    : StringConstants
                                                                        .transactionIdText,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .blacklight,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14)),
                                                            TextSpan(
                                                              text: transactionController
                                                                          .ownerOrderTransactionList![
                                                                              index]
                                                                          .orderTransaction !=
                                                                      null
                                                                  ? ': #${transactionController.ownerOrderTransactionList![index].orderTransaction!.orderId}'
                                                                  : transactionController
                                                                              .ownerOrderTransactionList![
                                                                                  index]
                                                                              .orderItemRefundTransaction !=
                                                                          null
                                                                      ? ': #${transactionController.ownerOrderTransactionList![index].orderItemRefundTransaction!.orderItemRefundTransactionId}'
                                                                      : transactionController.ownerOrderTransactionList![index].storePayout !=
                                                                              null
                                                                          ? ': #${transactionController.ownerOrderTransactionList![index].storePayout!.transactionId}'
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
                                                                  DateTime.parse(transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .createdAt
                                                                      .toString()),
                                                                  secFormat: '',
                                                                ).toString()
                                                              : transactionController.ownerOrderTransactionList![index].orderItemRefundTransaction !=
                                                                      null
                                                                  ? Utility
                                                                      .parseDateTime(
                                                                      DateTime.parse(transactionController
                                                                          .ownerOrderTransactionList![
                                                                              index]
                                                                          .orderItemRefundTransaction!
                                                                          .createdAt
                                                                          .toString()),
                                                                      secFormat:
                                                                          '',
                                                                    ).toString()
                                                                  : transactionController
                                                                              .ownerOrderTransactionList![
                                                                                  index]
                                                                              .storePayout !=
                                                                          null
                                                                      ? Utility
                                                                              .parseDateTime(
                                                                          DateTime.parse(transactionController
                                                                              .ownerOrderTransactionList![index]
                                                                              .storePayout!
                                                                              .createdAt
                                                                              .toString()),
                                                                          secFormat:
                                                                              '',
                                                                        )
                                                                          .toString()
                                                                      : "",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .blacklight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16)),
                                                      Text(
                                                        transactionController
                                                                    .ownerOrderTransactionList![
                                                                        index]
                                                                    .orderTransaction !=
                                                                null
                                                            ? "\$${transactionController.ownerOrderTransactionList![index].orderTransaction?.storeReceivedAmount!.toStringAsFixed(2)}"
                                                            : transactionController
                                                                        .ownerOrderTransactionList![
                                                                            index]
                                                                        .storePayout !=
                                                                    null
                                                                ? transactionController
                                                                            .ownerOrderTransactionList![
                                                                                index]
                                                                            .storePayout
                                                                            ?.payoutType ==
                                                                        "transfered"
                                                                    ? "\$${transactionController.ownerOrderTransactionList![index].storePayout?.totalTransactionAmount!.toStringAsFixed(2)}"
                                                                    : "\$${transactionController.ownerOrderTransactionList![index].storePayout?.totalReversedAmount!.toStringAsFixed(2)}"
                                                                : transactionController
                                                                            .ownerOrderTransactionList![index]
                                                                            .orderItemRefundTransaction !=
                                                                        null
                                                                    ? "\$${transactionController.ownerOrderTransactionList![index].orderItemRefundTransaction?.transaction!.transactionAmount!.toStringAsFixed(2)}"
                                                                    : "",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primary,
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
                                                      Text(
                                                          "${StringConstants.transactionText}: ",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14)),
                                                      transactionController
                                                                  .ownerOrderTransactionList![
                                                                      index]
                                                                  .orderTransaction !=
                                                              null
                                                          ? transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .orderTransaction!
                                                                      .orderTransactionType ==
                                                                  "order cancel"
                                                              ? Text(
                                                                  StringConstants
                                                                      .debitText)
                                                              : Text(
                                                                  StringConstants
                                                                      .creditText)
                                                          : transactionController
                                                                      .ownerOrderTransactionList![
                                                                          index]
                                                                      .orderItemRefundTransaction !=
                                                                  null
                                                              ? Text(
                                                                  StringConstants
                                                                      .debitText)
                                                              : transactionController
                                                                          .ownerOrderTransactionList![
                                                                              index]
                                                                          .storePayout !=
                                                                      null
                                                                  ? transactionController.ownerOrderTransactionList![index].storePayout!.payoutType ==
                                                                          "transfered"
                                                                      ? Text(StringConstants
                                                                          .debitText)
                                                                      : Text(StringConstants
                                                                          .creditText)
                                                                  : const Text(
                                                                      ""),
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
