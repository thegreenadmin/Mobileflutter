import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import '../../../../../utils/image_constants.dart';

class UserStoreOrderAppBar extends StatefulWidget with PreferredSizeWidget {
  const UserStoreOrderAppBar({Key? key}) : super(key: key);

  @override
  State<UserStoreOrderAppBar> createState() => _UserStoreOrderAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(WidgetConstants.screenHeight * 0.25);
}

class _UserStoreOrderAppBarState extends State<UserStoreOrderAppBar> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.25),
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
                        left: 20.0, right: 10, bottom: 10),
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
                                  Navigator.of(context).pop();
                                  // Get.back();
                                },
                                icon: const Icon(
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
                                      //      ||
                                      // storeHomeMainController
                                      //     .productDetailResponse
                                      //     .value
                                      //     .data!
                                      //     .product!
                                      //     .cartItems!
                                      //     .isNotEmpty,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [],
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    storeHomeMainController
                                                        .apiGetUserWalletBalance();
                                                    SharedPreferenceStorage
                                                        .setData(
                                                            "context", context);
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (_) =>
                                                          const CartScreen(),
                                                    )).then((value) =>
                                                        storeHomeMainController
                                                            .apiActiveCartApi(
                                                            context));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 22.0,
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
                                            storeHomeMainController
                                                .apiRemoveFavouriteStore(
                                                    storeHomeMainController
                                                        .storeDetailsResponse
                                                        .value
                                                        .data
                                                        ?.store
                                                        ?.storeId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.liked,
                                            scale: 3.5,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            storeHomeMainController
                                                .apiCreateFavouriteStore(
                                                    storeHomeMainController
                                                        .storeDetailsResponse
                                                        .value
                                                        .data
                                                        ?.store
                                                        ?.storeId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.favoutline,
                                            scale: 3.5,
                                          ),
                                        ),
                                ],
                              )
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
                                backgroundImage: storeHomeMainController
                                                .storeDetailsResponse.value.data ==
                                            null ||
                                        storeHomeMainController
                                                .storeDetailsResponse
                                                .value
                                                .data!
                                                .store!
                                                .logo!
                                                .dynamicUrl ==
                                            null ||
                                        storeHomeMainController
                                            .storeDetailsResponse
                                            .value
                                            .data!
                                            .store!
                                            .logo!
                                            .dynamicUrl!
                                            .isEmpty
                                    ? const AssetImage(ImageConstants.storeicon)
                                        as ImageProvider
                                    : NetworkImage(storeHomeMainController
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
                                  storeHomeMainController.storeDetailsResponse
                                          .value.data?.store?.storeName ??
                                      "",
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                height4SizedBox,
                                Row(
                                  children: [
                                    Image.asset(
                                      ImageConstants.loc,
                                      color: AppColors.white,
                                      scale: 2,
                                    ),
                                    width4SizedBox,
                                    SizedBox(
                                      width: WidgetConstants.screenWidth * 0.6,
                                      child: Text(
                                          storeHomeMainController
                                                  .storeDetailsResponse
                                                  .value
                                                  .data
                                                  ?.store
                                                  ?.storeAddresses
                                                  ?.first
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
                                height6SizedBox,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                height4SizedBox,
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 15,
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
                                              radius: 12.0,
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
                            )
                          ],
                        )
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}
