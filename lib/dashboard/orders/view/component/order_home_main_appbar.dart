import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import '../../../../../utils/image_constants.dart';

class OrderHomeMainAppBar extends StatefulWidget with PreferredSizeWidget {
  const OrderHomeMainAppBar({Key? key}) : super(key: key);

  @override
  State<OrderHomeMainAppBar> createState() => _UserStoreOrderAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(WidgetConstants.screenHeight * 0.18);
}

class _UserStoreOrderAppBarState extends State<OrderHomeMainAppBar> {
  final OrdersHomeMainController ordersHomeMainController =
      Get.put(OrdersHomeMainController());

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.18),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(() => ordersHomeMainController.storeDetailsResponse.value.data !=
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
                      image: ordersHomeMainController.storeDetailsResponse.value
                                      .data!.store!.image!.dynamicUrl ==
                                  null ||
                              ordersHomeMainController.storeDetailsResponse
                                  .value.data!.store!.image!.dynamicUrl!.isEmpty
                          ? const AssetImage(
                              ImageConstants.nopicfound,
                            ) as ImageProvider
                          : NetworkImage(ordersHomeMainController
                              .storeDetailsResponse
                              .value
                              .data!
                              .store!
                              .image!
                              .dynamicUrl
                              .toString()),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ImageConstants.nopicfound,
                                        ) as ImageProvider
                                      : NetworkImage(ordersHomeMainController
                                          .storeDetailsResponse
                                          .value
                                          .data!
                                          .store!
                                          .logo!
                                          .dynamicUrl!),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                overflow: TextOverflow.visible,
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
                                        // Text(
                                        //     ordersHomeMainController
                                        //             .storeAddress
                                        //             .value
                                        //             .store!
                                        //             .storeTimings!
                                        //             .isNotEmpty
                                        //         ? ordersHomeMainController
                                        //                     .storeAddress
                                        //                     .value
                                        //                     .store
                                        //                     ?.storeTimings
                                        //                     ?.first
                                        //                     .is24HoursActive ==
                                        //                 false
                                        //             ? "${Utility.formatDateTime(ordersHomeMainController.storeAddress.value.store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                        //                 "${Utility.formatDateTime(ordersHomeMainController.storeAddress.value.store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                        //             : StringConstants
                                        //                 .storeHoursText
                                        //         : StringConstants.storeHoursText,
                                        //     style: const TextStyle(
                                        //         overflow: TextOverflow.visible,
                                        //         color: AppColors.white,
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w400)),
                                        width8SizedBox,
                                      ],
                                    ),
                                  )
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
    );
  }
}
