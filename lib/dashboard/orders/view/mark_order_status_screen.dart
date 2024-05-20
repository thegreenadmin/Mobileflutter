import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'component/order_status_enum.dart';

class MarkOrderStatusScreen extends StatefulWidget {
  const MarkOrderStatusScreen({super.key});

  @override
  State<MarkOrderStatusScreen> createState() => _MarkOrderStatusScreenState();
}

class _MarkOrderStatusScreenState extends State<MarkOrderStatusScreen> {
  final OrdersHomeMainController ordersHomeMainController =
      Get.put(OrdersHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPreferredSize(),
      body: Stack(
        children: [
          buildOrderContainer(),
          buildPositionedButtons(),
        ],
      ),
    );
  }

  Container buildOrderContainer() {
    return Container(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 15, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(() => SizedBox(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${StringConstants.fullFillOrdersText} - #${ordersHomeMainController.orderId.value}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        height20SizedBox,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
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
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      ordersHomeMainController
                                          .customerName.value
                                          .toTitleCase(),
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  height4SizedBox,
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            "${StringConstants.orderedDateText}: ",
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                              ordersHomeMainController
                                                  .orderDate.value,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  height4SizedBox,
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text("${StringConstants.orderType}: ",
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.visible,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                              ordersHomeMainController
                                                      .getStoreOrderDetailModel
                                                      .value
                                                      .data
                                                      ?.order
                                                      ?.deliveryService
                                                      ?.name ??
                                                  "",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        )
                                      ]),
                                  height4SizedBox,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          "${StringConstants.orderAmountText}: ",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      Obx(() => Text(
                                            "\$${ordersHomeMainController.orderAmount.value}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          )),
                                    ],
                                  ),
                                  height6SizedBox,
                                ],
                              ),
                            ),
                          ],
                        ),
                        buildDivider(),
                        buildUserProof(),
                      ]),
                )),
            buildOrderItems(),
          ]),
        );
  }

  Obx buildOrderItems() {
  return Obx(() => Expanded(
          child: ordersHomeMainController.getOrderItems.isEmpty
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
                            AlertStringConstants
                                .noProductFoundForThisStore,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    )
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return width40SizedBox;
                  },
                  padding: EdgeInsets.only(
                      bottom: WidgetConstants.screenHeight * 0.2),
                  itemCount:
                      ordersHomeMainController.getOrderItems.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index <
                        ordersHomeMainController.getOrderItems.length) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8.0),
                                  child: CommonWidgets
                                      .cachedNetworkImage(
                                    ordersHomeMainController
                                                .getOrderItems[index]
                                                .product!
                                                .productImages!
                                                .isEmpty ||
                                            ordersHomeMainController
                                                    .getOrderItems[
                                                        index]
                                                    .product!
                                                    .productImages!
                                                    .first
                                                    .image!
                                                    .dynamicUrl ==
                                                null
                                        ? ""
                                        : ordersHomeMainController
                                            .getOrderItems[index]
                                            .product!
                                            .productImages!
                                            .first
                                            .image!
                                            .dynamicUrl
                                            .toString(),
                                    height: 70.0,
                                    width: 70.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              width10SizedBox,
                              Flexible(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                            ordersHomeMainController
                                                    .getOrderItems[
                                                        index]
                                                    .product!
                                                    .productName ??
                                                "",
                                            style: const TextStyle(
                                                color:
                                                    AppColors.black,
                                                fontWeight:
                                                    FontWeight.w600,
                                                fontSize: 16)),
                                        Obx(
                                          () =>
                                              ordersHomeMainController
                                                          .selectedIndex
                                                          .value ==
                                                      3
                                                  ? height0SizedBox
                                                  : Flexible(
                                                      flex: 1,
                                                      child: SizedBox(
                                                          height: 20,
                                                          width: 30,
                                                          child:
                                                              Checkbox(
                                                            side: MaterialStateBorderSide
                                                                .resolveWith(
                                                              (states) => BorderSide(
                                                                  width:
                                                                      1.0,
                                                                  color:
                                                                      AppColors.primary.withOpacity(0.5)),
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(6.0)),
                                                            activeColor:
                                                                AppColors
                                                                    .primary,
                                                            value: ordersHomeMainController
                                                                    .getOrderItems[index]
                                                                    .isSelected ??
                                                                false,
                                                            onChanged:
                                                                (bool?
                                                                    value) {
                                                              if (ordersHomeMainController.selectedIndex.value ==
                                                                      0 &&
                                                                  ordersHomeMainController.getOrderItems[index].orderItemStatus ==
                                                                      OrderStatusEnum
                                                                          .receivedOrder.statusName) {
                                                                setState(
                                                                    () {
                                                                  ordersHomeMainController.getOrderItems.elementAt(index).isSelected =
                                                                      value;
                                                                });
                                                              } else if (ordersHomeMainController.selectedIndex.value == 1 && ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.inProgress.statusName ||
                                                                  ordersHomeMainController.selectedIndex.value == 1 &&
                                                                      ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.receivedOrder.statusName) {
                                                                setState(
                                                                    () {
                                                                  ordersHomeMainController.getOrderItems.elementAt(index).isSelected =
                                                                      value;
                                                                });
                                                              } else if (ordersHomeMainController.selectedIndex.value == 2 && (ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.inTransit.statusName || ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.readyForPickup.statusName || ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.receivedOrder.statusName || ordersHomeMainController.getOrderItems[index].orderItemStatus == OrderStatusEnum.inProgress.statusName)) {
                                                                setState(
                                                                    () {
                                                                  ordersHomeMainController.getOrderItems.elementAt(index).isSelected =
                                                                      value;
                                                                });
                                                              }
                                                            },
                                                          )),
                                                    ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          ordersHomeMainController
                                                      .getOrderItems[
                                                          index]
                                                      .product
                                                      ?.description !=
                                                  null &&
                                              ordersHomeMainController
                                                  .getOrderItems[
                                                      index]
                                                  .product!
                                                  .description!
                                                  .isNotEmpty,
                                      child: Column(
                                        children: [
                                          height5SizedBox,
                                          Text(
                                              ordersHomeMainController
                                                      .getOrderItems[
                                                          index]
                                                      .product!
                                                      .description ??
                                                  "",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .blacklight,
                                                  fontWeight:
                                                      FontWeight.w400,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    height5SizedBox,
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${StringConstants.statusText}: ",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .blacklight,
                                                  fontWeight:
                                                      FontWeight.w400,
                                                  fontSize: 14)),
                                          TextSpan(
                                            text: ordersHomeMainController
                                                    .getOrderItems[
                                                        index]
                                                    .orderItemStatus
                                                    ?.toTitleCase() ??
                                                "",
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.w600,
                                                fontSize: 14,
                                                color: AppColors
                                                    .blacklight),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                    height6SizedBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${StringConstants.qtyText}:",
                                                overflow: TextOverflow
                                                    .visible,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .blacklight,
                                                    fontWeight:
                                                        FontWeight
                                                            .w500,
                                                    fontSize: 14)),
                                            Text(
                                                ordersHomeMainController
                                                    .getOrderItems[
                                                        index]
                                                    .orderItemCount
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                overflow: TextOverflow
                                                    .visible,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .black,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "${StringConstants.unitPriceText}: ",
                                                overflow: TextOverflow
                                                    .visible,
                                                style: TextStyle(
                                                    color: AppColors
                                                        .blacklight,
                                                    fontWeight:
                                                        FontWeight
                                                            .w500,
                                                    fontSize: 14)),
                                            Text(
                                                "\$${ordersHomeMainController.getOrderItems[index].offerPrice.toStringAsFixed(2) ?? "0.00"}",
                                                overflow: TextOverflow
                                                    .visible,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .black,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                    fontSize: 14)),
                                          ],
                                        )
                                      ],
                                    ),
                                    height6SizedBox,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                      );
                    } else if (ordersHomeMainController
                            .orderHistories.isNotEmpty &&
                        ordersHomeMainController.orderHistories.last
                                .orderStatus?.orderStatusName ==
                            OrderStatusEnum.readyForPickup.statusName &&
                        ordersHomeMainController
                                .orderHistories.last.isCreatedByStore ==
                            false) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5.0),
                        child: Text(
                            StringConstants
                                .customerInStoreForPickupText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      );
                    }
                    return height0SizedBox;
                  })));
  }

  Divider buildDivider() {
    return Divider(
      height: 10,
      color: AppColors.blacklight,
    );
  }

  Visibility buildUserProof() {
    return Visibility(
                        visible: ordersHomeMainController
                                .getStoreOrderDetailModel
                                .value
                                .data
                                ?.userProof
                                ?.image
                                ?.dynamicUrl !=
                            null,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: const BoxDecoration(
                                  color: AppColors.greylight,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1)),
                                        child: Image.asset(
                                          ImageConstants.licenseImg,
                                          fit: BoxFit.fill,
                                          height: 40,
                                          width: 55,
                                        ),
                                      ),
                                      width8SizedBox,
                                      Text(
                                          StringConstants.identityProofText,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (ordersHomeMainController
                                              .getStoreOrderDetailModel
                                              .value
                                              .data
                                              ?.userProof
                                              ?.image
                                              ?.dynamicUrl !=
                                          null) {
                                        showDialog(
                                          context: Get.context!,
                                          barrierDismissible: false,
                                          builder: (_) => AlertDialog(
                                            icon: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back(); // Navigator.pop(_);
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: AppColors.primary,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16)),
                                            content: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color:
                                                                  AppColors
                                                                      .white,
                                                              width: 1)),
                                                      child: CommonWidgets
                                                          .cachedNetworkImage(
                                                        ordersHomeMainController
                                                                .getStoreOrderDetailModel
                                                                .value
                                                                .data
                                                                ?.userProof
                                                                ?.image
                                                                ?.dynamicUrl
                                                                .toString() ??
                                                            "",
                                                        height: 200.0,
                                                        fit: BoxFit.fill,
                                                        assetImg:
                                                            ImageConstants
                                                                .nopicfound,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: const <Widget>[],
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(StringConstants.viewText,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                            buildDivider(),
                          ],
                        ),
                      );
  }

  Positioned buildPositionedButtons() {
    return Positioned(
          bottom: 20,
          left: ordersHomeMainController.selectedIndex.value == 0 ? 25 : 50,
          right: ordersHomeMainController.selectedIndex.value == 0 ? 25 : 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: ordersHomeMainController.selectedIndex.value == 0,
                replacement: height0SizedBox,
                child: CustomButton(
                  width: WidgetConstants.screenWidth * 0.4,
                  border: Border.all(
                    color: AppColors.blacklight,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.white, AppColors.white],
                  ),
                  onTap: () {
                    if (ordersHomeMainController.getOrderItems
                        .any((element) => element.isSelected == true)) {
                      Utility.showConfirmAlertMessage(
                          AlertStringConstants.cancelOrderAlertText,
                          okay: StringConstants.yesText,
                          cancelText: StringConstants.noText, okayTap: () {
                        ordersHomeMainController.apiCancelOrder();
                      });
                    } else {
                      Utility.showAlertMessage(AlertStringConstants
                          .pleaseSelectProductToProceedText);
                    }
                  },
                  height: 50,
                  text: StringConstants.cancelOrderText,
                  textColor: AppColors.red,
                  borderRadius: 14,
                  fontWeight: FontWeight.w500,
                  iconL: false,
                  iconR: false,
                  fontSize: 16,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: ordersHomeMainController.selectedIndex.value != 3,
                  child: CustomButton(
                    width: ordersHomeMainController.selectedIndex.value == 0
                        ? WidgetConstants.screenWidth * 0.4
                        : WidgetConstants.screenWidth * 0.7,
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      if (ordersHomeMainController.getOrderItems
                          .any((element) => element.isSelected == true)) {
                        ordersHomeMainController.selectedIndex.value == 0
                            ? ordersHomeMainController.apiMarkOrderReady()
                            : ordersHomeMainController.selectedIndex.value ==
                                    1
                                ? ordersHomeMainController
                                            .getStoreOrderDetailModel
                                            .value
                                            .data
                                            ?.order
                                            ?.deliveryService
                                            ?.id !=
                                        "2"
                                    ? ordersHomeMainController
                                        .apiMarkReadyForPickUp()
                                    : ordersHomeMainController
                                        .apiMarkReadyForShipping()
                                : ordersHomeMainController
                                            .selectedIndex.value ==
                                        2
                                    ?
                        // add method
                        alertTOCancelRemainingItems()


                                    : ordersHomeMainController
                                                .selectedIndex.value ==
                                            3
                                        ? ordersHomeMainController
                                            .apiMarkOrderReady()
                                        : ordersHomeMainController
                                            .apiMarkOrderReady();
                      } else {
                        Utility.showAlertMessage(AlertStringConstants
                            .pleaseSelectProductToProceedText);
                      }
                    },
                    height: 50,
                    text: ordersHomeMainController.selectedIndex.value == 0
                        ? StringConstants.prepareOrderText
                        : ordersHomeMainController.selectedIndex.value == 1 &&
                                ordersHomeMainController
                                        .getStoreOrderDetailModel
                                        .value
                                        .data
                                        ?.order
                                        ?.deliveryService
                                        ?.id !=
                                    "2"
                            ? StringConstants.readyForPickUpText
                            : ordersHomeMainController.selectedIndex.value == 1 &&
                                    ordersHomeMainController
                                            .getStoreOrderDetailModel
                                            .value
                                            .data
                                            ?.order
                                            ?.deliveryService
                                            ?.id ==
                                        "2"
                                ? StringConstants.orderShippedText
                                : ordersHomeMainController.selectedIndex.value == 2 &&
                                        ordersHomeMainController
                                                .getStoreOrderDetailModel
                                                .value
                                                .data
                                                ?.order
                                                ?.deliveryService
                                                ?.id !=
                                            "2"
                                    ? StringConstants.pickedUpText
                                    : ordersHomeMainController
                                                    .selectedIndex.value ==
                                                2 &&
                                            ordersHomeMainController
                                                    .getStoreOrderDetailModel
                                                    .value
                                                    .data
                                                    ?.order
                                                    ?.deliveryService
                                                    ?.id ==
                                                "2"
                                        ? StringConstants.deliveredText
                                        : ordersHomeMainController
                                                    .selectedIndex.value ==
                                                3
                                            ? StringConstants.completeText
                                            : "",
                    textColor: AppColors.white,
                    borderRadius: 14,
                    fontWeight: FontWeight.w500,
                    iconL: false,
                    iconR: false,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        );
  }

  alertTOCancelRemainingItems(){
    ordersHomeMainController.count.value = 0;
    for (var element in ordersHomeMainController.getOrderItems) {
      if(element.isSelected == true){
        ordersHomeMainController.count.value++;
      }

    }
    if (ordersHomeMainController.getOrderItems
        .every((element) => element.isSelected == true)) {
      ordersHomeMainController.apiMarkDelivered();

    }else{
      Utility.showConfirmAlertMessage(
        "You have selected ${ordersHomeMainController.count.value} of ${ordersHomeMainController.getOrderItems.length} items are you sure to cancel the remaining ones?",
        okayTap: (){
          ordersHomeMainController.apiMarkDelivered();
        },
      );
    }
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(() => Container(
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
                          left: 10.0, right: 8, bottom: 10, top: 30),
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
                              child: IconButton(
                                splashRadius: 45,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Get.back(id: pageIdApp.value);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.white,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    height8SizedBox,
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
    );
  }
}
