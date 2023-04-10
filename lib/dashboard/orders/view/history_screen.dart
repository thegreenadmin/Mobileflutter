import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/history_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController historyController = Get.put(HistoryController());

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
                  if (historyController.isCurrentMonthSelected.value == true) {
                  } else {
                    historyController.isCurrentMonthSelected.value =
                        !historyController.isCurrentMonthSelected.value;
                  }
                  historyController.role!.value == Role.customerRoleText
                      ? historyController.apiGetUserOrderTransactionHistory()
                      : historyController.apiGetOwnerOrderTransactionHistory();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: historyController.isCurrentMonthSelected.value
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
                          color: historyController.isCurrentMonthSelected.value
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
                  if (historyController.isCurrentMonthSelected.value == false) {
                  } else {
                    historyController.isCurrentMonthSelected.value =
                        !historyController.isCurrentMonthSelected.value;
                  }
                  historyController.role!.value == Role.customerRoleText
                      ? historyController.apiGetUserOrderTransactionHistory()
                      : historyController.apiGetOwnerOrderTransactionHistory();

                  historyController.onIndexChange(0);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: historyController.isCurrentMonthSelected.value
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
                          color: historyController.isCurrentMonthSelected.value
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
            itemCount: historyController.horizontalTabList.length,
            itemBuilder: (_, i) {
              return Obx(() => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    historyController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            historyController.horizontalTabList[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  historyController.selectedIndex.value == i
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                              color: historyController.selectedIndex.value == i
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                            ),
                          ),
                          height10SizedBox,
                          historyController.selectedIndex.value == i
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
              () => historyController.isCurrentMonthSelected.value
                  ? height0SizedBox
                  : horizontalMonthsTab(),
            ),
            Obx(() => historyController.role!.value == Role.customerRoleText
                ? Expanded(
                    child: historyController.userOrderHistoryList!.isEmpty
                        ? historyController.isLoading.value == true
                            ? height0SizedBox
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/nodata.png",
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
                              return width40SizedBox;
                            },
                            itemCount:
                                historyController.userOrderHistoryList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  // Get.to(() => const OrderConfirmationScreen(),
                                  //     arguments: {
                                  //       "isFromTransaction": true,
                                  //       "storeId": historyController
                                  //               .userOrderHistoryList![index]
                                  //               .store!
                                  //               .storeId ?? "",
                                  //       "orderStatus": historyController
                                  //               .userOrderHistoryList![index]
                                  //               .orderId ?? ""
                                  //     });
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
                                              backgroundImage: historyController
                                                              .userOrderHistoryList![
                                                                  index]
                                                              .store!
                                                              .image!
                                                              .dynamicUrl ==
                                                          null ||
                                                      historyController
                                                          .userOrderHistoryList![
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
                                                      historyController
                                                          .userOrderHistoryList![
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
                                                            text: "Order ID",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blacklight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14)),
                                                        TextSpan(
                                                          text:
                                                              ': #${historyController.userOrderHistoryList![index].orderId!}',
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
                                                      Utility.parseDateTime(
                                                        DateTime.parse(
                                                          historyController
                                                              .userOrderHistoryList![
                                                                  index]
                                                              .orderDate!
                                                              .trim(),
                                                        ),
                                                        secFormat: '',
                                                      ).toString(),
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
                                                      historyController
                                                              .userOrderHistoryList![
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
                                                    "\$${historyController.userOrderHistoryList![index].totalAmount!.toStringAsFixed(2)}",
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
                                                  Text(
                                                      "${StringConstants.cityText}: ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blacklight,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14)),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${StringConstants.mobileText}: ",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .blacklight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14)),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: AppColors
                                                            .blacklight,
                                                        size: 22.0,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              height6SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      historyController
                                                          .userOrderHistoryList![
                                                              index]
                                                          .orderDeliveryAddresses!
                                                          .first
                                                          .city!,
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  Text(
                                                    historyController
                                                            .userOrderHistoryList![
                                                                index]
                                                            .customerPhone ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              )
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
                    child: historyController.ownerOrderHistoryList!.isEmpty
                        ? historyController.isLoading.value == true
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
                              return width40SizedBox;
                            },
                            itemCount:
                                historyController.ownerOrderHistoryList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  // Get.to(() => const OrdersHomeMainScreen(),
                                  //     arguments: {
                                  //       "storeId": historyController
                                  //           .ownerOrderHistoryList![index]
                                  //           .store!
                                  //           .storeId
                                  //           .toString(),
                                  //       "orderStatus": historyController
                                  //               .ownerOrderHistoryList![index]
                                  //               .orderId ??
                                  //           ""
                                  //     });
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
                                              backgroundImage: historyController
                                                              .ownerOrderHistoryList![
                                                                  index]
                                                              .store!
                                                              .image!
                                                              .dynamicUrl ==
                                                          null ||
                                                      historyController
                                                          .ownerOrderHistoryList![
                                                              index]
                                                          .store!
                                                          .image!
                                                          .dynamicUrl!
                                                          .isEmpty
                                                  ? const AssetImage(
                                                          ImageConstants
                                                              .nopicfound)
                                                      as ImageProvider
                                                  : NetworkImage(historyController
                                                      .ownerOrderHistoryList![
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
                                                            text: "Order ID",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blacklight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14)),
                                                        TextSpan(
                                                          text:
                                                              ': #${historyController.ownerOrderHistoryList![index].orderId!}',
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
                                                      Utility.parseDateTime(
                                                        DateTime.parse(
                                                          historyController
                                                              .ownerOrderHistoryList![
                                                                  index]
                                                              .orderDate!
                                                              .trim(),
                                                        ),
                                                        secFormat: '',
                                                      ).toString(),
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
                                                      historyController
                                                              .ownerOrderHistoryList![
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
                                                    "\$${historyController.ownerOrderHistoryList![index].totalAmount!.toStringAsFixed(2)}",
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
                                                  Text(
                                                      "${StringConstants.cityText}: ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blacklight,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14)),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${StringConstants.mobileText}: ",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .blacklight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14)),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: AppColors
                                                            .blacklight,
                                                        size: 22.0,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              height6SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      historyController
                                                          .ownerOrderHistoryList![
                                                              index]
                                                          .orderDeliveryAddresses!
                                                          .first
                                                          .city!,
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  Text(
                                                    historyController
                                                            .ownerOrderHistoryList![
                                                                index]
                                                            .customerPhone ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              )
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
