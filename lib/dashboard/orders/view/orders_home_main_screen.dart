import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../view/component/order_status_enum.dart';
import 'mark_return_order_screen.dart';

class OrdersHomeMainScreen extends StatefulWidget {
  const OrdersHomeMainScreen({super.key});

  @override
  State<OrdersHomeMainScreen> createState() => _OrdersHomeMainScreenState();
}

class _OrdersHomeMainScreenState extends State<OrdersHomeMainScreen> {
  final OrdersHomeMainController ordersHomeMainController =
      Get.put(OrdersHomeMainController());

  Padding horizontalTabs() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => SizedBox(
            height: 50,
            width: WidgetConstants.screenWidth,
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return width10SizedBox;
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: ordersHomeMainController.horizontalTabList.length,
                itemBuilder: (_, i) {
                  return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        ordersHomeMainController.onIndexChange(i);
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                ordersHomeMainController.horizontalTabList[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: ordersHomeMainController
                                              .selectedIndex.value ==
                                          i
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: ordersHomeMainController
                                              .selectedIndex.value ==
                                          i
                                      ? AppColors.primary
                                      : AppColors.blacklight,
                                ),
                              ),
                              height10SizedBox,
                              Container(
                                color: ordersHomeMainController
                                            .selectedIndex.value ==
                                        i
                                    ? AppColors.primary
                                    : null,
                                height: 2,
                                width: 80,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ],
                      ));
                }),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.18),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(() => ordersHomeMainController
                            .storeDetailsResponse.value.data !=
                        null &&
                    ordersHomeMainController
                            .storeDetailsResponse.value.data!.store !=
                        null
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.black45, BlendMode.darken),
                        image: ordersHomeMainController.storeDetailsResponse
                                        .value.data!.store!.image!.dynamicUrl ==
                                    null ||
                                ordersHomeMainController
                                    .storeDetailsResponse
                                    .value
                                    .data!
                                    .store!
                                    .image!
                                    .dynamicUrl!
                                    .isEmpty
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
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: int.parse(ordersHomeMainController
                                                .storeCount.value) >
                                            1 ||
                                        ordersHomeMainController
                                            .isFromNotification.value,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        Get.back(id: pageIdApp.value);
                                        Get.delete<OrdersHomeMainController>();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ]),
                            height10SizedBox,
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.white, width: 1)),
                                  child: CircleAvatar(
                                    radius: 28.0,
                                    backgroundImage: ordersHomeMainController
                                                    .storeDetailsResponse
                                                    .value
                                                    .data!
                                                    .store!
                                                    .logo!
                                                    .dynamicUrl ==
                                                null ||
                                            ordersHomeMainController
                                                .storeDetailsResponse
                                                .value
                                                .data!
                                                .store!
                                                .logo!
                                                .dynamicUrl!
                                                .isEmpty
                                        ? const AssetImage(
                                                ImageConstants.storeicon)
                                            as ImageProvider
                                        : NetworkImage(ordersHomeMainController
                                                .storeDetailsResponse
                                                .value
                                                .data!
                                                .store!
                                                .logo!
                                                .dynamicUrl ??
                                            ""),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                width10SizedBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ordersHomeMainController
                                              .storeDetailsResponse
                                              .value
                                              .data!
                                              .store!
                                              .storeName ??
                                          "",
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    height8SizedBox,
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImageConstants.loc,
                                          color: AppColors.white,
                                          scale: 2,
                                        ),
                                        width4SizedBox,
                                        SizedBox(
                                          width:
                                              WidgetConstants.screenWidth * 0.6,
                                          child: Text(
                                              ordersHomeMainController
                                                      .storeDetailsResponse
                                                      .value
                                                      .data!
                                                      .store!
                                                      .storeAddresses!
                                                      .first
                                                      .addressLine1 ??
                                                  "",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  color: AppColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    height8SizedBox,
                                    SizedBox(
                                      height: 20,
                                      width: WidgetConstants.screenWidth * 0.7,
                                      child: Row(
                                        children: [
                                          Text(
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
                                                  : StringConstants
                                                      .storeHoursText,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                  )
                : height0SizedBox)
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          children: [
            horizontalTabs(),
            Obx(() => Expanded(
                child: ordersHomeMainController.ownerOrderHistoryList!.isEmpty
                    ? ordersHomeMainController.isLoading.value == true
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
                        itemCount: ordersHomeMainController
                            .ownerOrderHistoryList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              ordersHomeMainController.storeId.value =
                                  ordersHomeMainController
                                          .ownerOrderHistoryList![index]
                                          .storeId ??
                                      "";

                              ordersHomeMainController.orderId.value =
                                  ordersHomeMainController
                                          .ownerOrderHistoryList![index]
                                          .orderId ??
                                      "";

                              ordersHomeMainController.apiGetStoreOrderDetail();

                              // SharedPreferenceStorage.setData(
                              //     "context", context);

                              /// ====================================

                              Get.parameters["storeId"] =
                                  ordersHomeMainController
                                          .ownerOrderHistoryList![index]
                                          .storeId ??
                                      "";

                              Get.parameters["orderId"] =
                                  ordersHomeMainController
                                          .ownerOrderHistoryList![index]
                                          .orderId ??
                                      "";
                              ordersHomeMainController
                                          .ownerOrderHistoryList![index]
                                          .orderHistories!
                                          .first
                                          .orderStatus!
                                          .orderStatusName == //"11"
                                      OrderStatus.returnRequest.statusName
                                  ? permissionStoreList.any((element) => element.isStoreOwner == true) ||
                                          permissionStoreList.any((element) =>
                                              element.storeId == ordersHomeMainController.ownerOrderHistoryList![index].storeId &&
                                              element.controllers!.any((ele) =>
                                                  ele.controllerKey ==
                                                  PermissionKey
                                                      .manageReturnRequests
                                                      .statusName))
                                      ? Get.to(const MarkReturnOrderScreen(), id: pageIdApp.value)!
                                          .then((value) => ordersHomeMainController
                                              .apiGetOwnerOrderHistory())
                                      : Utility.showAlertMessage(AlertStringConstants
                                          .notAuthorisedToStoreText)

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (_) => const MarkReturnOrderScreen(),
                                  // )).then((value) {
                                  //   // ordersController
                                  //   //     .apiGetStoreOrderListApi();
                                  // })
                                  /*: ordersHomeMainController
                                  .ownerOrderHistoryList![index]
                                  .orderHistories!
                                  .first
                                  .orderStatus!
                                  .orderStatusName == //"12"
                                  OrderStatus
                                      .returnConfirmed
                                      .statusName
                                  ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const ReturnConfirmOrderScreen(),
                              ))*/
                                  : ordersHomeMainController
                                              .ownerOrderHistoryList![index]
                                              .orderHistories!
                                              .first
                                              .orderStatus!
                                              .orderStatusName == //7
                                          OrderStatus.cancelled.statusName
                                      ? null
                                      :
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //   builder: (_) => const MarkOrderStatusScreen(),
                                      // ));
                                      Get.to(const MarkOrderStatusScreen(), id: pageIdApp.value);

                              /// ====================================
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                MainAxisAlignment.spaceBetween,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${StringConstants.orderedDateText}: ",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blacklight,
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
                                          height5SizedBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    "${StringConstants.estimatedDeliveyDateText}: ",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                              ),
                                              Text(
                                                  Utility.parseDateTime(
                                                    DateTime.parse(
                                                        ordersHomeMainController
                                                            .ownerOrderHistoryList![
                                                                index]
                                                            .estimateDeliveryDate
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
                                          height5SizedBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${StringConstants.orderType}: ",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blacklight,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14)),
                                              Text(
                                                  ordersHomeMainController
                                                              .ownerOrderHistoryList?[
                                                                  index]
                                                              .deliveryServiceId
                                                              .toString() ==
                                                          "1"
                                                      ? StringConstants
                                                          .inStoreText
                                                      : ordersHomeMainController
                                                                  .ownerOrderHistoryList?[
                                                                      index]
                                                                  .deliveryServiceId
                                                                  .toString() ==
                                                              "2"
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${StringConstants.statusText}: ",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blacklight,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${StringConstants.orderAmountText}: ",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blacklight,
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
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                          );
                        })))
          ],
        ),
      ),
    );
  }
}
