import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

mixin PreferredSizeWidget on Widget {
  Size get preferredSize => Size.fromHeight(WidgetConstants.screenHeight *
      0.25); // Implement your preferredSize logic here
}

class UserStoreOrderAppBar extends StatefulWidget with PreferredSizeWidget {
  const UserStoreOrderAppBar({super.key});

  @override
  State<UserStoreOrderAppBar> createState() => _UserStoreOrderAppBarState();
}

class _UserStoreOrderAppBarState extends State<UserStoreOrderAppBar> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Obx(() => Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: storeHomeMainController
                                  .storeDetailsResponse.value.data ==
                              null ||
                          storeHomeMainController.storeDetailsResponse.value
                                  .data!.store!.image!.dynamicUrl ==
                              null ||
                          storeHomeMainController.storeDetailsResponse.value
                              .data!.store!.image!.dynamicUrl!.isEmpty
                      ? const AssetImage(ImageConstants.storeicon)
                          as ImageProvider
                      : NetworkImage(storeHomeMainController
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
                      left: 15.0, right: 15, bottom: 10, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back(id: pageIdApp.value);
                                Get.delete<StoreHomeMainController>();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 24.0,
                              ),
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible: storeHomeMainController
                                            .cartCount.value !=
                                        0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  storeHomeMainController
                                                      .apiGetUserWalletBalance();
                                                  await Get.to(
                                                          const CartScreen(),
                                                          id: pageIdApp.value)
                                                      ?.then((value) =>
                                                          storeHomeMainController
                                                              .apiActiveCartApi());
                                                },
                                                child: Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Image.asset(
                                                          ImageConstants.cart,
                                                          height: 16),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.5),
                                                          ),
                                                          constraints:
                                                              const BoxConstraints(
                                                            minWidth: 15,
                                                            minHeight: 15,
                                                          ),
                                                          child: Obx(
                                                            () => Text(
                                                              storeHomeMainController
                                                                  .cartItems
                                                                  .length
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                storeHomeMainController
                                            .isFavouriteStore.value ==
                                        true
                                    ? InkWell(
                                        onTap: () {
                                          if (storeHomeMainController
                                                  .isLoading.value ==
                                              false) {
                                            storeHomeMainController
                                                .apiRemoveFavouriteStore(
                                                    storeHomeMainController
                                                        .storeDetailsResponse
                                                        .value
                                                        .data
                                                        ?.store
                                                        ?.storeId);
                                          }
                                        },
                                        child: Image.asset(
                                          ImageConstants.liked,
                                          scale: 3.5,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (storeHomeMainController
                                                  .isLoading.value ==
                                              false) {
                                            storeHomeMainController
                                                .apiCreateFavouriteStore(
                                                    storeHomeMainController
                                                        .storeDetailsResponse
                                                        .value
                                                        .data
                                                        ?.store
                                                        ?.storeId);
                                          }
                                        },
                                        child: Image.asset(
                                          ImageConstants.favoutline,
                                          scale: 3.5,
                                        ),
                                      ),
                              ],
                            )
                          ]),
                      height8SizedBox,
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.white, width: 1)),
                            child: CommonWidgets.circleCachedNetworkImage(
                                storeHomeMainController.storeDetailsResponse
                                        .value.data?.store?.logo?.dynamicUrl ??
                                    "",
                                fit: BoxFit.contain,
                                radius: 38.0,
                                assetImg: ImageConstants.nopicfound,
                                assetBackgroundColor: Colors.grey.shade50),
                          ),
                          width10SizedBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storeHomeMainController.storeDetailsResponse
                                          .value.data?.store?.storeName ??
                                      "",
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                // height4SizedBox,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Image.asset(
                                        ImageConstants.loc,
                                        color: AppColors.white,
                                        scale: 3.0,
                                      ),
                                    ),
                                    width4SizedBox,
                                    Expanded(
                                      child: Text(
                                          storeHomeMainController
                                              .storeLocation.value,
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                                height4SizedBox,
                                SizedBox(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Text(
                                          storeHomeMainController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data !=
                                                      null &&
                                                  storeHomeMainController
                                                      .storeDetailsResponse
                                                      .value
                                                      .data!
                                                      .store!
                                                      .storeTimings!
                                                      .isNotEmpty
                                              ? storeHomeMainController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data!
                                                          .store!
                                                          .storeTimings!
                                                          .first
                                                          .is24HoursActive ==
                                                      false
                                                  ? "${Utility.formatDateTime(storeHomeMainController.storeDetailsResponse.value.data!.store!.storeTimings!.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                      "${Utility.formatDateTime(storeHomeMainController.storeDetailsResponse.value.data!.store!.storeTimings!.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
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
                                height4SizedBox,
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      child: ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return width6SizedBox;
                                          },
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: storeHomeMainController
                                                  .storeDetailsResponse
                                                  .value
                                                  .data
                                                  ?.store
                                                  ?.storeDeliveryServices
                                                  ?.length ??
                                              0,
                                          itemBuilder: (_, i) {
                                            return CircleAvatar(
                                              radius: 18.0,
                                              backgroundColor:
                                                  AppColors.primary,
                                              child: storeHomeMainController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeDeliveryServices?[
                                                              i]
                                                          .deliveryServiceId ==
                                                      "1"
                                                  ? Image.asset(
                                                      ImageConstants.instore,
                                                      scale: 4.5,
                                                      color: Colors.white,
                                                    )
                                                  : storeHomeMainController
                                                              .storeDetailsResponse
                                                              .value
                                                              .data
                                                              ?.store
                                                              ?.storeDeliveryServices?[
                                                                  i]
                                                              .deliveryServiceId ==
                                                          "2"
                                                      ? Image.asset(
                                                          ImageConstants
                                                              .delivery,
                                                          color: Colors.white,
                                                          scale: 4.5,
                                                        )
                                                      : Image.asset(
                                                          ImageConstants.curb,
                                                          color: Colors.white,
                                                          scale: 3.5,
                                                        ),
                                            );
                                          }),
                                    ),
                                    width2SizedBox,
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {},
                                      child: Image.asset(
                                        ImageConstants.call,
                                        scale: 2.5,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ))
      ],
    );
  }
}
