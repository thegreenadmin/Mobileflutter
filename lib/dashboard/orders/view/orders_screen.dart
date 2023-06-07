import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_return_order_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/return_confirm_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_status_enum.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersController ordersController = Get.put(OrdersController());

  Container userOrdersTab() {
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
                  if (ordersController.isActiveOrders.value == true) {
                    ordersController.orderStatusName.value =
                        OrderStatus.receivedOrder.statusName;
                    // ordersController.orderStatusId.value = 2;
                    ordersController.page.value = 1;
                    ordersController.orderList.clear();
                    ordersController.apiGetOrderListApi();
                  } else {
                    // ordersController.orderStatusId.value = 2;
                    ordersController.orderStatusName.value =
                        OrderStatus.receivedOrder.statusName;
                    ordersController.isActiveOrders.value =
                        !ordersController.isActiveOrders.value;
                    ordersController.page.value = 1;
                    ordersController.orderList.clear();
                    ordersController.apiGetOrderListApi();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.isActiveOrders.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.activeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.isActiveOrders.value
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
                  ordersController.isActiveOrders.value = false;
                  ordersController.orderStatusName.value =
                      OrderStatus.completed.statusName;
                  // ordersController.orderStatusId.value = 5;
                  ordersController.page.value = 1;
                  ordersController.orderList.clear();
                  ordersController.apiGetOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.completed.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.completeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.orderStatusName.value ==
                                  OrderStatus.completed.statusName
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
                  ordersController.isActiveOrders.value = false;
                  // ordersController.orderStatusId.value = 7;
                  ordersController.orderStatusName.value =
                      OrderStatus.cancelled.statusName;
                  ordersController.page.value = 1;
                  ordersController.orderList.clear();
                  ordersController.apiGetOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.cancelled.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.cancelledText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.orderStatusName.value ==
                                  OrderStatus.cancelled.statusName
                              ? AppColors.primary
                              : AppColors.blacklight,
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

  Container storeOrdersTab() {
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  ordersController.orderStatusName.value =
                      OrderStatus.receivedOrder.statusName;
                  // ordersController.orderStatusId.value = 2;
                  ordersController.page.value = 1;
                  ordersController.storeOrderList.clear();
                  ordersController.apiGetStoreOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  padding: const EdgeInsets.all(4),
                  width: WidgetConstants.screenWidth * 0.16,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.receivedOrder.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          StringConstants.newText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: ordersController.orderStatusName.value ==
                                    OrderStatus.receivedOrder.statusName
                                ? AppColors.primary
                                : AppColors.blacklight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // ordersController.orderStatusId.value = 3;
                  ordersController.orderStatusName.value =
                      OrderStatus.receivedOrder.statusName;
                  ordersController.page.value = 1;
                  ordersController.storeOrderList.clear();
                  ordersController.apiGetStoreOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  padding: const EdgeInsets.all(4),
                  width: WidgetConstants.screenWidth * 0.18,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.receivedOrder.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        StringConstants.pendingText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          color: ordersController.orderStatusName.value ==
                                  OrderStatus.receivedOrder.statusName
                              ? AppColors.primary
                              : AppColors.blacklight,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // ordersController.orderStatusId.value = 5;
                  ordersController.orderStatusName.value =
                      OrderStatus.completed.statusName;
                  ordersController.page.value = 1;
                  ordersController.storeOrderList.clear();
                  ordersController.apiGetStoreOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  padding: const EdgeInsets.all(4),
                  width: WidgetConstants.screenWidth * 0.20,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.completed.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        StringConstants.receivedText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          color: ordersController.orderStatusName.value ==
                                  OrderStatus.completed.statusName
                              ? AppColors.primary
                              : AppColors.blacklight,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // ordersController.orderStatusId.value = 7;
                  ordersController.orderStatusName.value =
                      OrderStatus.cancelled.statusName;
                  ordersController.page.value = 1;
                  ordersController.storeOrderList.clear();
                  ordersController.apiGetStoreOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  padding: const EdgeInsets.all(4),
                  width: WidgetConstants.screenWidth * 0.22,
                  color: ordersController.orderStatusName.value ==
                          OrderStatus.cancelled.statusName
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          StringConstants.cancelledText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ordersController.orderStatusName.value ==
                                    OrderStatus.cancelled.statusName
                                ? AppColors.primary
                                : AppColors.blacklight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  const Size.fromHeight(90.0),
        child:  Container(
                color: AppColors.primarylight,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Obx(
                                        () => ordersController
                                                    .isFromNotification.value ==
                                                true
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.of(Get.context!)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                  // Get.offAll(BottomNavigation());
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: AppColors.black,
                                                  size: 24.0,
                                                ),
                                              )
                                            : height0SizedBox,
                                      ),
                                      ordersController
                                                  .isFromNotification.value ==
                                              true
                                          ? width10SizedBox
                                          : height0SizedBox,
                                      ordersController.role!.value ==
                                              Role.customerRoleText
                                          ? Obx(
                                              () => Text(
                                                'Hi, ${ordersController.firstName?.value} ${ordersController.lastName?.value}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          : Obx(
                                              () => Text(
                                                'Hi, ${ordersController.role!.value}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                    ],
                                  ),
                                  height4SizedBox,
                                  Text(
                                    StringConstants.ordersText,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Obx(() => Text(
                                  //   ordersController.role!.value,
                                  //   style: const TextStyle(
                                  //       fontSize: 22,
                                  //       color: AppColors.black,
                                  //       fontWeight: FontWeight.w600),
                                  // ))
                                ],
                              ),
                              Image.asset(
                                ImageConstants.homeMall,
                                scale: 4,
                              )
                            ]),
                      ],
                    )),
              ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Obx(
                () => ordersController.role!.value == Role.customerRoleText
                    ? Center(
                        child: userOrdersTab(),
                      )
                    : Center(
                        child: storeOrdersTab(),
                      ),
              ),
              height25SizedBox,
              Obx(() => ordersController.role!.value == Role.customerRoleText
                  ? ordersController.orderList.isEmpty
                      ? ordersController.isDataLoading.value == true
                          ? height0SizedBox
                          : Expanded(
                              child: Column(
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
                                      StringConstants.noOrdersFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Expanded(
                          child: ListView.separated(
                              controller: ordersController.scrollController,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return height12SizedBox;
                              },
                              itemCount: ordersController.orderList.length +
                                  (ordersController.isLoading.value ? 1 : 0),
                              itemBuilder: (BuildContext context, int i) {
                                if (i < ordersController.orderList.length) {
                                  return InkWell(
                                    onTap: () {
                                      ordersController.storeId.value =
                                          ordersController
                                                  .orderList[i].storeId ??
                                              "";
                                      ordersController.orderStatus.value =
                                          ordersController
                                                  .orderList[i].orderId ??
                                              "";
                                      ordersController.apiGetStoreDetailsApi();
                                      ordersController.apiGetOrderDetailsApi();
                                      Get.parameters["orderStatus"] =
                                          ordersController
                                                  .orderList[i].orderId ??
                                              "";

                                      Get.parameters["isFromTransaction"] =
                                          "false";
                                      Get.parameters["isHome"] = "false";
                                      Get.parameters["isFromNotification"] =
                                          "false";
                                      Get.parameters["storeId"] =
                                          ordersController
                                                  .orderList[i].store?.storeId
                                                  .toString() ??
                                              "";
                                      SharedPreferenceStorage.setData(
                                          "context", context);
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const OrderConfirmationScreen(),
                                      )).then((value) {
                                        ordersController.apiGetOrderListApi();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primarylight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          )),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: AppColors.white,
                                                      width: 1)),
                                              child: CircleAvatar(
                                                radius: 22.0,
                                                backgroundImage: ordersController
                                                                .orderList[i]
                                                                .store
                                                                ?.logo
                                                                ?.dynamicUrl ==
                                                            null ||
                                                        ordersController
                                                            .orderList[i]
                                                            .store!
                                                            .logo!
                                                            .dynamicUrl!
                                                            .isEmpty
                                                    ? const AssetImage(
                                                        ImageConstants
                                                            .nopicfound,
                                                      ) as ImageProvider
                                                    : NetworkImage(
                                                        ordersController
                                                                .orderList[i]
                                                                .store
                                                                ?.logo
                                                                ?.dynamicUrl
                                                                .toString() ??
                                                            ""),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                            width5SizedBox,
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
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
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          14)),
                                                              TextSpan(
                                                                text:
                                                                    ': ${ordersController.orderList[i].orderId ?? "0"}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .blacklight),
                                                              ),
                                                            ],
                                                            style: const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: Utility.formatDateTime(
                                                                      '${ordersController.orderList[i].createdAt.toString().substring(0, 10)} ${ordersController.orderList[i].createdAt.toString().substring(11, 23)}',
                                                                      firstFormat:
                                                                          "yyyy-MM-dd HH:mm:ss",
                                                                      secFormat:
                                                                          "dd MMM yyyy"), //"14 Feb",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .blacklight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          14)),
                                                              TextSpan(
                                                                text:
                                                                    "-${Utility.formatDateTime('${ordersController.orderList[i].createdAt.toString().substring(0, 10)} ${ordersController.orderList[i].createdAt.toString().substring(11, 23)}', firstFormat: "yyyy-MM-dd HH:mm:ss", secFormat: "hh:mm a")}", //'2023-03:30 AM',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .blacklight,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                            style: const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  height8SizedBox,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          ordersController
                                                                  .orderList[i]
                                                                  .store
                                                                  ?.storeName ??
                                                              "",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16)),
                                                      Text(
                                                        "\$${ordersController.orderList[i].totalAmount?.toStringAsFixed(2)}",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        height6SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text.rich(
                                              softWrap: true,
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${StringConstants.statusText} : ",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text: ordersController
                                                            .orderList[i]
                                                            .orderHistories
                                                            ?.first
                                                            .orderStatus
                                                            ?.orderStatusName
                                                            ?.toTitleCase() ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.yellow,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "${StringConstants.productText}: ",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)),
                                                      TextSpan(
                                                        text: ordersController
                                                                .orderList[i]
                                                                .orderItems
                                                                ?.length
                                                                .toString() ??
                                                            "0",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: AppColors.blacklight,
                                                  size: 22.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ]),
                                    ),
                                  );
                                } else if (ordersController.isLoading.value) {
                                  Timer(const Duration(milliseconds: 10), () {
                                    ordersController.scrollController.jumpTo(
                                        ordersController.scrollController
                                            .position.maxScrollExtent);
                                  });
                                  return _loadingIndicator();
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        )
                  : ordersController.storeOrderList.isEmpty
                      ? ordersController.isDataLoading.value == true
                          ? height0SizedBox
                          : Expanded(
                              child: Column(
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
                                      StringConstants.noOrdersFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Expanded(
                          child: ListView.separated(
                              controller: ordersController.scrollController,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return height12SizedBox;
                              },
                              itemCount: ordersController
                                      .storeOrderList.length +
                                  (ordersController.isLoading.value ? 1 : 0),
                              itemBuilder: (BuildContext context, int i) {
                                if (i <
                                    ordersController.storeOrderList.length) {
                                  return InkWell(
                                    onTap: () {
                                      SharedPreferenceStorage.setData(
                                          "context", context);

                                      Get.parameters["storeId"] =
                                          ordersController.storeOrderList[i]
                                                  .store?.storeId
                                                  .toString() ??
                                              "";
                                      Get.parameters["orderId"] =
                                          ordersController
                                              .storeOrderList[i].orderId
                                              .toString();
                                      ordersController
                                                  .storeOrderList[i]
                                                  .orderHistories!
                                                  .first
                                                  .orderStatus!
                                                  .orderStatusName == //"11"
                                              OrderStatus
                                                  .returnRequest.statusName
                                          ? Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (_) =>
                                                  const MarkReturnOrderScreen(),
                                            ))
                                              /*Get.to(
                                    () =>
                                const MarkReturnOrderScreen(),
                                arguments: {
                                  "storeId": ordersController
                                      .storeOrderList[i]
                                      .store
                                      ?.storeId
                                      .toString() ??
                                      "",
                                  "orderId":
                                  ordersController
                                      .storeOrderList[i]
                                      .orderId
                                      .toString(),
                                })*/
                                              .then((value) {
                                              ordersController
                                                  .apiGetStoreOrderListApi();
                                            })
                                          : ordersController
                                                      .storeOrderList[i]
                                                      .orderHistories!
                                                      .first
                                                      .orderStatus!
                                                      .orderStatusName == //"12"
                                                  OrderStatus.returnConfirmed
                                                      .statusName
                                              ? Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      const ReturnConfirmOrderScreen(),
                                                ))
                                              /*Get.to(
                                    () =>
                                const ReturnConfirmOrderScreen(),
                                arguments: {
                                  "storeId": ordersController
                                      .storeOrderList[
                                  i]
                                      .store
                                      ?.storeId
                                      .toString() ??
                                      "",
                                  "orderId":
                                  ordersController
                                      .storeOrderList[
                                  i]
                                      .orderId
                                      .toString(),
                                })*/
                                              : ordersController.orderStatusName
                                                          .value == //7
                                                      OrderStatus
                                                          .cancelled.statusName
                                                  ? null
                                                  : Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                      builder: (_) =>
                                                          const OrdersHomeMainScreen(),
                                                    ));
                                      /*Get.to(
                                    () =>
                                const OrdersHomeMainScreen(),
                                arguments: {
                                  "storeId": ordersController
                                      .storeOrderList[
                                  i]
                                      .store
                                      ?.storeId
                                      .toString() ??
                                      "",
                                  "orderId": ordersController
                                      .storeOrderList[
                                  i]
                                      .orderId ??
                                      "",
                                });*/
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primarylight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          )),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: AppColors.white,
                                                      width: 1)),
                                              child: CircleAvatar(
                                                radius: 22.0,
                                                backgroundImage: ordersController
                                                                .storeOrderList[
                                                                    i]
                                                                .store
                                                                ?.logo
                                                                ?.dynamicUrl ==
                                                            null ||
                                                        ordersController
                                                            .storeOrderList[i]
                                                            .store!
                                                            .logo!
                                                            .dynamicUrl!
                                                            .isEmpty
                                                    ? const AssetImage(
                                                        ImageConstants
                                                            .nopicfound,
                                                      ) as ImageProvider
                                                    : NetworkImage(
                                                        ordersController
                                                                .storeOrderList[
                                                                    i]
                                                                .store
                                                                ?.logo
                                                                ?.dynamicUrl
                                                                .toString() ??
                                                            ""),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                            width5SizedBox,
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
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
                                                                    fontSize:
                                                                        14)),
                                                            TextSpan(
                                                              text:
                                                                  ': ${ordersController.storeOrderList[i].orderId ?? "0"}',
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
                                                      // width20SizedBox,
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: Utility.formatDateTime(
                                                                    '${ordersController.storeOrderList[i].createdAt.toString().substring(0, 10)} ${ordersController.storeOrderList[i].createdAt.toString().substring(11, 23)}',
                                                                    firstFormat:
                                                                        "yyyy-MM-dd HH:mm:ss",
                                                                    secFormat:
                                                                        "dd MMM yyyy"), //"14 Feb",
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .blacklight,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14)),
                                                            TextSpan(
                                                              text:
                                                                  "-${Utility.formatDateTime('${ordersController.storeOrderList[i].createdAt.toString().substring(0, 10)} ${ordersController.storeOrderList[i].createdAt.toString().substring(11, 23)}', firstFormat: "yyyy-MM-dd HH:mm:ss", secFormat: "hh:mm a")}", //'2023-03:30 AM',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .blacklight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  height8SizedBox,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: StringConstants
                                                                      .storeNameText,
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .blacklight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14)),
                                                              TextSpan(
                                                                text:
                                                                    ': ${ordersController.storeOrderList[i].store?.storeName ?? ""}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                    color: AppColors
                                                                        .blacklight),
                                                              ),
                                                            ],
                                                          ),
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "\$${ordersController.storeOrderList[i].totalAmount?.toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        height6SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text.rich(
                                              softWrap: true,
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${StringConstants.statusText}: ",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text: ordersController
                                                            .storeOrderList[i]
                                                            .orderHistories
                                                            ?.first
                                                            .orderStatus
                                                            ?.orderStatusName
                                                            ?.toTitleCase() ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.yellow,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "${StringConstants.productText}: ",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)),
                                                      TextSpan(
                                                        text: ordersController
                                                                .storeOrderList[
                                                                    i]
                                                                .orderItems
                                                                ?.length
                                                                .toString() ??
                                                            "0",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: AppColors.blacklight,
                                                  size: 22.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ]),
                                    ),
                                  );
                                } else if (ordersController.isLoading.value) {
                                  Timer(const Duration(milliseconds: 10), () {
                                    ordersController.scrollController.jumpTo(
                                        ordersController.scrollController
                                            .position.maxScrollExtent);
                                  });
                                  return _loadingIndicator();
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ))
            ],
          )),
    );
  }

  Widget _loadingIndicator() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).primaryColor,
          ),
        ));
  }
}
