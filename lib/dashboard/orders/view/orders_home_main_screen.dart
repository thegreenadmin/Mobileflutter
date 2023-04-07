import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_home_main_appbar.dart';
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
      appBar: const OrderHomeMainAppBar(),
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
                            Get.to(() => const OrdersHomeMainScreen(),
                                arguments: {
                                  "storeId",
                                  ordersHomeMainController
                                      .ownerOrderHistoryList![index]
                                      .store!
                                      .storeId
                                      .toString()
                                });
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
