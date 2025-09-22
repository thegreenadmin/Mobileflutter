import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../view/component/order_status_enum.dart';
import 'mark_return_order_screen.dart';

class OrdersHomeMainScreen extends StatefulWidget {
  final String? orderId;
  final String? storeId;
  final String? storeName;
  final String? orderStatus;
  final bool? isFromNotification;
  final bool? isFromTransaction;
  final bool? isHome;
  const OrdersHomeMainScreen({super.key, this.orderId, this.storeId, this.orderStatus, this.isFromNotification, this.isFromTransaction, this.isHome, this.storeName});

  @override
  State<OrdersHomeMainScreen> createState() => _OrdersHomeMainScreenState();
}

class _OrdersHomeMainScreenState extends State<OrdersHomeMainScreen> with GlobalVarMixin{
  final OrdersHomeMainController ordersHomeMainController =
      Get.put(OrdersHomeMainController());


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersHomeMainController.storeId.value = widget.storeId ?? "";
      ordersHomeMainController.orderId.value = widget.orderId ?? "";
      ordersHomeMainController.isFromNotification.value = widget.isFromNotification ?? false;
    });
    super.initState();
  }

  Padding horizontalTabs() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            ordersHomeMainController.horizontalTabList.length,
                (i) => InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                ordersHomeMainController.onIndexChange(i);
                setState(() {});
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ordersHomeMainController.horizontalTabList[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: ordersHomeMainController.selectedIndex.value == i
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: ordersHomeMainController.selectedIndex.value == i
                          ? AppColors.primary
                          : AppColors.blackLight,
                    ),
                  ),
                  height8SizedBox,
                  Container(
                    color: ordersHomeMainController.selectedIndex.value == i
                        ? AppColors.primary
                        : Colors.transparent,
                    height: 2,
                    width: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Obx(() => Container(
                    height: WidgetConstants.screenHeight * 0.25,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.black45, BlendMode.darken),
                        image: ordersHomeMainController.storeDetailsResponse.value
                            .data?.store?.image?.dynamicUrl ==
                            null ||
                            ordersHomeMainController.storeDetailsResponse
                                .value.data!.store!.image!.dynamicUrl!.isEmpty
                            ? const AssetImage(ImageConstants.storeicon)
                        as ImageProvider
                            : NetworkImage(ordersHomeMainController
                            .storeDetailsResponse
                            .value
                            .data!
                            .store!
                            .image!
                            .dynamicUrl!),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18, bottom: 0, top: 35),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: int.parse(ordersHomeMainController
                                      .storeCount.value) >
                                      1 ||
                                      ordersHomeMainController
                                          .isFromNotification.value,
                                  child:
                                  IconButton(
                                    splashRadius: 40,
                                    padding: EdgeInsets.all(10),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Get.back(id: pageIdApp.value);
                                      Get.delete<OrdersHomeMainController>();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.white,
                                      size: 26.0,
                                    ),
                                  ),
                                ),
                              ]),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 8, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
                                child: CommonWidgets.circleCachedNetworkImage(
                                  ordersHomeMainController.storeDetailsResponse
                                      .value.data?.store?.logo?.dynamicUrl ??
                                      "",
                                  fit: BoxFit.contain,
                                  radius: 32.0,
                                  assetImg: ImageConstants.nopicfound,
                                ),
                              ),
                              width10SizedBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ordersHomeMainController.storeDetailsResponse
                                        .value.data?.store?.storeName ??
                                        "",
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Image.asset(
                                          ImageConstants.loc,
                                          color: AppColors.white,
                                          scale: 3,
                                        ),
                                      ),
                                      width4SizedBox,
                                      SizedBox(
                                        width: WidgetConstants.screenWidth * 0.6,
                                        child: Text(
                                            ordersHomeMainController
                                                .storeLocation.value,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                overflow: TextOverflow.visible,
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                  height4SizedBox,
                                  SizedBox(
                                    height: 20,
                                    width: WidgetConstants.screenWidth * 0.7,
                                    child: Row(
                                      children: [
                                        Text(
                                            ordersHomeMainController
                                                .storeDetailsResponse
                                                .value
                                                .data !=
                                                null &&
                                                ordersHomeMainController
                                                    .storeDetailsResponse
                                                    .value
                                                    .data!
                                                    .store!
                                                    .storeTimings!
                                                    .isNotEmpty
                                                ? ordersHomeMainController
                                                .storeDetailsResponse
                                                .value
                                                .data!
                                                .store!
                                                .storeTimings!
                                                .first
                                                .is24HoursActive ==
                                                false
                                                ? "${Utility.formatDateTime(ordersHomeMainController.storeDetailsResponse.value.data!.store!.storeTimings!.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                "${Utility.formatDateTime(ordersHomeMainController.storeDetailsResponse.value.data!.store!.storeTimings!.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                : StringConstants
                                                .storeHoursText
                                                : StringConstants.storeHoursText,
                                            style: const TextStyle(
                                                overflow: TextOverflow.visible,
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
              horizontalTabs(),
              Obx(() => Expanded(
                  child: ordersHomeMainController.ownerOrderHistoryList!.isEmpty
                      ? Column(
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
                                    AlertStringConstants.noDataFoundText,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                      : ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return height10SizedBox;
                          },
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          controller: ordersHomeMainController.scrollController,
                          itemCount: ordersHomeMainController
                                  .ownerOrderHistoryList!.length +
                              (ordersHomeMainController.isDataLoading.value ? 1 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            if (index <
                                ordersHomeMainController
                                    .ownerOrderHistoryList!.length) {
                              return buildOrderCard(index);
                            } else if (ordersHomeMainController.isDataLoading.value) {
                              Timer(const Duration(milliseconds: 10), () {
                                ordersHomeMainController.scrollController.jumpTo(
                                    ordersHomeMainController.scrollController
                                        .position.maxScrollExtent);
                              });

                              return CommonWidgets.loadingIndicator();
                            } else {
                              return const SizedBox();
                            }
                          })))
            ],
          ),
          //LOADING OVERLAY
          Obx(() {
            return ordersHomeMainController.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),)
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  InkWell buildOrderCard(int index) {
    return InkWell(
                              onTap: () {
                                ordersHomeMainController.storeId.value =
                                    ordersHomeMainController
                                            .ownerOrderHistoryList?[index]
                                            .storeId ?? "";
                                ordersHomeMainController.orderAmount.value=
                                ordersHomeMainController.ownerOrderHistoryList![index].orderTransactions![0].storeReceivedAmount?.toStringAsFixed(2) ??"0.0";                             ordersHomeMainController.orderId.value =
                                    ordersHomeMainController
                                            .ownerOrderHistoryList?[index]
                                            .orderId ?? "";

                                Get.parameters["storeId"] =
                                    ordersHomeMainController
                                            .ownerOrderHistoryList![index]
                                            .storeId ?? "";

                                Get.parameters["orderId"] =
                                    ordersHomeMainController
                                            .ownerOrderHistoryList![index]
                                            .orderId ?? "";
                                ordersHomeMainController.onInit();

                                ordersHomeMainController
                                            .ownerOrderHistoryList![index]
                                            .orderHistories!
                                            .first
                                            .orderStatus!
                                            .orderStatusName ==
                                        OrderStatusEnum.returnRequest.statusName
                                    ? hasStoreAccess.value && permissionStoreList.isEmpty ||
                                            permissionStoreList.any((element) =>
                                                element.storeId == ordersHomeMainController.ownerOrderHistoryList![index].storeId &&
                                                    element.isStoreOwner ==
                                                        true ||
                                                element.storeId == ordersHomeMainController.ownerOrderHistoryList![index].storeId &&
                                                    element.controllers!.any((ele) =>
                                                        ele.controllerKey ==
                                                        PermissionKey
                                                            .manageReturnRequests
                                                            .statusName))
                                        ? Get.to(
                                                () => const MarkReturnOrderScreen(),
                                                id: pageIdApp.value)!
                                            .then((value) => ordersHomeMainController.apiGetOwnerOrderHistory())
                                        : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText)
                                    : Get.to(() =>  MarkOrderStatusScreen(
                                  orderId: ordersHomeMainController
                                      .ownerOrderHistoryList?[index]
                                      .orderId ?? "",storeId: ordersHomeMainController
                                    .ownerOrderHistoryList?[index]
                                    .storeId ?? "",
                                ), id: pageIdApp.value)?.then((value) {
                                        ordersHomeMainController.onIndexChange(
                                            ordersHomeMainController
                                                .selectedIndex.value);
                                      });


                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                    color: AppColors.greyLight,
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
                                          child: const CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: AssetImage(
                                              ImageConstants.userAccount,
                                            ),
                                            backgroundColor: Colors.transparent,
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
                                                Text(
                                                    ordersHomeMainController
                                                            .ownerOrderHistoryList![
                                                                index]
                                                            .customerName
                                                            ?.toTitleCase() ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            height5SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.orderIDText}: ",
                                                    style: TextStyle(
                                                        color: AppColors.blackLight,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                  "#${ordersHomeMainController
                                                      .ownerOrderHistoryList![
                                                  index].orderId.toString()}",

                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
                                              ],
                                            ), height5SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.orderedDateText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                    Utility.parseDateTime(
                                                      DateTime.parse(
                                                          ordersHomeMainController
                                                              .ownerOrderHistoryList![
                                                                  index]
                                                              .orderDate
                                                              .toString()),
                                                      secFormat: '',
                                                    ).toString(),
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Visibility(
                                              visible: ordersHomeMainController
                                                      .ownerOrderHistoryList?[
                                                          index]
                                                      .deliveryServiceId
                                                      .toString() ==
                                                  "2",
                                              child: Column(
                                                children: [
                                                  height5SizedBox,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            "${StringConstants.estimatedDeliveryDateText}: ",
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: AppColors.blackLight,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                fontSize: 14)),
                                                      ),
                                                      Text(
                                                          Utility.parseDateTime(
                                                            DateTime.parse(
                                                                ordersHomeMainController
                                                                    .ownerOrderHistoryList![index]
                                                                    .estimateDeliveryDate.toString()),
                                                            secFormat: '',
                                                          ).toString(),
                                                          style: const TextStyle(
                                                              color: AppColors.black,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            height5SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.orderType}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                    ordersHomeMainController
                                                                .ownerOrderHistoryList?[index]
                                                                .deliveryServiceId
                                                                .toString() == "1"
                                                        ? StringConstants
                                                            .inStoreText
                                                        : ordersHomeMainController
                                                                    .ownerOrderHistoryList?[
                                                                        index]
                                                                    .deliveryServiceId
                                                                    .toString() == "2"
                                                            ? StringConstants
                                                                .deliveryText
                                                            : StringConstants
                                                                .curbSideText,
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            height5SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.statusText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                    ordersHomeMainController
                                                            .ownerOrderHistoryList?[
                                                                index]
                                                            .orderHistories
                                                            ?.first
                                                            .orderStatus
                                                            ?.orderStatusName
                                                            ?.toTitleCase() ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: AppColors.green,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            /* height5SizedBox,
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "${StringConstants.pickUpDateText}: ",
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColors.blacklight,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 14)),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            Utility.parseDateTime(
                                                                              DateTime.parse(
                                                                                  ordersHomeMainController
                                                                                      .ownerOrderHistoryList![
                                                                                          index]
                                                                                      .orderDate
                                                                                      .toString()),
                                                                              secFormat: '',
                                                                            ).toString(),
                                                                            style: const TextStyle(
                                                                                color:
                                                                                    AppColors.black,
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                                fontSize: 14)),
                                                                        Icon(
                                                                          Icons.chevron_right,
                                                                          color: AppColors.blacklight,
                                                                          size: 22.0,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),*/
                                            height5SizedBox,
                                           /* Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.orderAmountText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                    "\$${ordersHomeMainController.ownerOrderHistoryList![index].totalAmount!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            height5SizedBox,*/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${StringConstants.totalOrderAmount}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                                Text(
                                                    "\$${ordersHomeMainController.ownerOrderHistoryList![index].orderTransactions![0].storeReceivedAmount?.toStringAsFixed(2) ??"0.0"}",
                                                    // "\$${ordersHomeMainController.ownerOrderHistoryList![index].orderTransactions![0].storeReceivedAmount!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14))
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
  }
}
