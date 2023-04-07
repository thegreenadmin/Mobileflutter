import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

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
      body: Column(
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
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return width40SizedBox;
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
                            Get.to(
                              () => const MarkOrderStatusScreen(),
                            );
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
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: ordersHomeMainController
                                                        .ownerOrderHistoryList![
                                                            index]
                                                        .store!
                                                        .image!
                                                        .dynamicUrl ==
                                                    null ||
                                                ordersHomeMainController
                                                    .ownerOrderHistoryList![
                                                        index]
                                                    .store!
                                                    .image!
                                                    .dynamicUrl!
                                                    .isEmpty
                                            ? const AssetImage(
                                                    ImageConstants.nopicfound)
                                                as ImageProvider
                                            : NetworkImage(
                                                ordersHomeMainController
                                                    .ownerOrderHistoryList![
                                                        index]
                                                    .store!
                                                    .image!
                                                    .dynamicUrl
                                                    .toString()),
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
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Order ID",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blacklight,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text:
                                                        ': #${ordersHomeMainController.ownerOrderHistoryList![index].orderId!}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                    ordersHomeMainController
                                                        .ownerOrderHistoryList![
                                                            index]
                                                        .orderDate!
                                                        .trim(),
                                                  ),
                                                  secFormat: '',
                                                ).toString(),
                                                style: TextStyle(
                                                    color: AppColors.blacklight,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                        height8SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                ordersHomeMainController
                                                        .ownerOrderHistoryList![
                                                            index]
                                                        .store!
                                                        .storeName ??
                                                    "",
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                            Text(
                                              "\$${ordersHomeMainController.ownerOrderHistoryList![index].totalAmount!.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        height6SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${StringConstants.cityText}: ",
                                                style: TextStyle(
                                                    color: AppColors.blacklight,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                            Row(
                                              children: [
                                                Text(
                                                    "${StringConstants.mobileText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
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
                                        ),
                                        height6SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                ordersHomeMainController
                                                    .ownerOrderHistoryList![
                                                        index]
                                                    .orderDeliveryAddresses!
                                                    .first
                                                    .city!,
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            Text(
                                              ordersHomeMainController
                                                      .ownerOrderHistoryList![
                                                          index]
                                                      .customerPhone ??
                                                  "",
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600,
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
                      })))
        ],
      ),
    );
  }
}
