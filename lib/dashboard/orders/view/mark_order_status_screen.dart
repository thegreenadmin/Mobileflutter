import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

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
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.white,
                                      size: 24.0,
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
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 25, vertical: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => SizedBox(
                    height: 150,
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
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        ordersHomeMainController
                                            .customerName.value,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16)),
                                    height4SizedBox,
                                    Row(children: [
                                      Text(
                                          "${StringConstants.orderedDateText}: ",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      Text(
                                          ordersHomeMainController
                                              .orderDate.value,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                    ]),
                                    height4SizedBox,
                                    Row(
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
                          Divider(
                            height: 20,
                            color: AppColors.blacklight,
                          ),
                        ]),
                  )),
              Obx(() => Expanded(
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
                          itemCount:
                              ordersHomeMainController.getOrderItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  color: AppColors.white,
                                                  width: 1)),
                                          child: ordersHomeMainController
                                                          .getOrderItems[index]
                                                          .product!
                                                          .productImages!
                                                          .first
                                                          .image!
                                                          .dynamicUrl ==
                                                      null ||
                                                  ordersHomeMainController
                                                      .getOrderItems[index]
                                                      .product!
                                                      .productImages!
                                                      .first
                                                      .image!
                                                      .dynamicUrl!
                                                      .isEmpty
                                              ? Image.asset(
                                                  ImageConstants.nopicfound,
                                                  fit: BoxFit.fill,
                                                  height: 70,
                                                )
                                              : Image.network(
                                                  ordersHomeMainController
                                                      .getOrderItems[index]
                                                      .product!
                                                      .productImages!
                                                      .first
                                                      .image!
                                                      .dynamicUrl
                                                      .toString(),
                                                  height: 70,
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                      width10SizedBox,
                                      Flexible(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                ordersHomeMainController
                                                        .getOrderItems[index]
                                                        .product!
                                                        .productName ??
                                                    "",
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16)),
                                            height5SizedBox,
                                            Text(
                                                ordersHomeMainController
                                                        .getOrderItems[index]
                                                        .product!
                                                        .description ??
                                                    "",
                                                style: TextStyle(
                                                    color: AppColors.blacklight,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            height12SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "${StringConstants.qtyText.toUpperCase()}: ",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blacklight,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                    Text(
                                                        ordersHomeMainController
                                                            .getOrderItems[
                                                                index]
                                                            .product!
                                                            .quantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "${StringConstants.unitPriceText}: ",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blacklight,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                    Text(
                                                        "\$${ordersHomeMainController.getOrderItems[index].product!.productPrice}",
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            height6SizedBox,
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Obx(
                                              () => SizedBox(
                                              height: 20,
                                              width: 30,
                                              child: Checkbox(
                                                side: MaterialStateBorderSide.resolveWith(
                                                      (states) => BorderSide(
                                                      width: 1.0,
                                                      color:
                                                      AppColors.primary.withOpacity(0.5)),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(6.0)),
                                                activeColor: AppColors.primary,
                                                value: ordersHomeMainController.getOrderItems[index].isSelected??false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ordersHomeMainController.getOrderItems.elementAt(index).isSelected = value;
                                                  });
                                                  },
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            );
                          })))
            ]),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: CustomButton(
              border: Border.all(
                color: AppColors.primary,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primary],
              ),
              onTap: () {
                ordersHomeMainController.selectedIndex.value == 0
                    ? ordersHomeMainController.apiMarkOrderReady(
                        orderId: ordersHomeMainController.orderId.value,
                        storeId: ordersHomeMainController.storeId.value)
                    : ordersHomeMainController.selectedIndex.value == 1
                        ? ordersHomeMainController.apiMarkReadyForPick(
                            orderId: ordersHomeMainController.orderId.value,
                            storeId: ordersHomeMainController.storeId.value)
                        : ordersHomeMainController.selectedIndex.value == 2
                            ? ordersHomeMainController.apiMarkDelivered(
                                orderId: ordersHomeMainController.orderId.value,
                                storeId: ordersHomeMainController.storeId.value)
                            : ordersHomeMainController.selectedIndex.value == 3
                                ? ordersHomeMainController.apiMarkOrderReady(
                                    orderId:
                                        ordersHomeMainController.orderId.value,
                                    storeId:
                                        ordersHomeMainController.storeId.value)
                                : ordersHomeMainController.apiMarkOrderReady(
                                    orderId:
                                        ordersHomeMainController.orderId.value,
                                    storeId:
                                        ordersHomeMainController.storeId.value);
              },
              height: 50,
              text: ordersHomeMainController.selectedIndex.value == 0
                  ? StringConstants.orderReadyText
                  : ordersHomeMainController.selectedIndex.value == 1
                      ? StringConstants.readyForPickUpText
                      : ordersHomeMainController.selectedIndex.value == 2
                          ? StringConstants.orderReadyText
                          : ordersHomeMainController.selectedIndex.value == 3
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
        ],
      ),
    );
  }
}
