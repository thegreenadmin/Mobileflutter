import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import '../account_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.black,
                                    size: 24.0,
                                  ),
                                ),
                                width10SizedBox,
                                Text(
                                  StringConstants.cartText,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Image.asset(
                              ImageConstants.homeMall,
                              scale: 4,
                            )
                          ]),
                    ],
                  )),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.itemsText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      height10SizedBox,
                      Obx(
                        () => ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height12SizedBox;
                            },
                            itemCount: storeHomeMainController.cartItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                    color: AppColors.greylight,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    )),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          width: 80,
                                          height: 90,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  color: AppColors.primary,
                                                  width: 0)),
                                          child: storeHomeMainController
                                                      .cartItems[i]
                                                      .product
                                                      ?.image
                                                      ?.dynamicUrl !=
                                                  null
                                              ? Image.network(
                                                  storeHomeMainController
                                                          .cartItems[i]
                                                          .product
                                                          ?.image
                                                          ?.dynamicUrl ??
                                                      "",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  ImageConstants.nopicfound,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      width10SizedBox,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              storeHomeMainController
                                                      .cartItems[i]
                                                      .product
                                                      ?.productName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            height6SizedBox,
                                            Text(
                                              storeHomeMainController
                                                      .cartItems[i]
                                                      .product
                                                      ?.description ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            height6SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text.rich(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: StringConstants
                                                              .unitPriceText,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16)),
                                                      TextSpan(
                                                        text:
                                                            ' \$${storeHomeMainController.cartItems[i].product?.productPrice?.toStringAsFixed(2) ?? "0"}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                width10SizedBox,
                                              ],
                                            ),
                                            height10SizedBox,
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      storeHomeMainController
                                                                  .cartItems[i]
                                                                  .itemsCount !=
                                                              0
                                                          ? storeHomeMainController.apiUpdateCart(
                                                              cartItemId: int.parse(
                                                                  storeHomeMainController
                                                                          .cartItems[
                                                                              i]
                                                                          .cartItemId ??
                                                                      "0"),
                                                              quantity: storeHomeMainController
                                                                      .cartItems[
                                                                          i]
                                                                      .itemsCount! -
                                                                  1)
                                                          : null;
                                                    },
                                                    child: Image.asset(
                                                      ImageConstants.subtract,
                                                      scale: 3,
                                                    )),
                                                width6SizedBox,
                                                Text(
                                                  storeHomeMainController
                                                              .cartItems[i]
                                                              .itemsCount
                                                              .toString()
                                                              .length <
                                                          2
                                                      ? storeHomeMainController
                                                          .cartItems[i]
                                                          .itemsCount
                                                          .toString()
                                                          .padLeft(2, '0')
                                                      : storeHomeMainController
                                                          .cartItems[i]
                                                          .itemsCount
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: AppColors.black),
                                                ),
                                                width6SizedBox,
                                                InkWell(
                                                  onTap: () {
                                                    storeHomeMainController.apiUpdateCart(
                                                        cartItemId: int.parse(
                                                            storeHomeMainController
                                                                    .cartItems[
                                                                        i]
                                                                    .cartItemId ??
                                                                "0"),
                                                        quantity:
                                                            storeHomeMainController
                                                                    .cartItems[
                                                                        i]
                                                                    .itemsCount! +
                                                                1);
                                                  },
                                                  child: Image.asset(
                                                    ImageConstants.add,
                                                    scale: 3,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      width10SizedBox,
                                      InkWell(
                                          onTap: () async {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    StringConstants.alertText,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.black,
                                                        fontSize: 20),
                                                  ),
                                                  content: Text(
                                                      AlertStringConstants
                                                          .areYouSureText,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 20)),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors.primary,
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                          storeHomeMainController.apiDeleteCart(
                                                              cartItemId: int.parse(
                                                                  storeHomeMainController
                                                                          .cartItems[
                                                                              i]
                                                                          .cartItemId ??
                                                                      "0"));
                                                        },
                                                        child: Text(
                                                            StringConstants
                                                                .deleteText)),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                          StringConstants
                                                              .cancelText),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Image.asset(
                                            ImageConstants.deleteicon,
                                            scale: 3.0,
                                          )),
                                    ],
                                  ),
                                ]),
                              );
                            }),
                      ),
                      height10SizedBox,
                      Text(
                        StringConstants.orderType,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      height10SizedBox,
                      SizedBox(
                        height: 50,
                        width: WidgetConstants.screenWidth,
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return width10SizedBox;
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: storeHomeMainController
                                    .storeDetailsResponse
                                    .data
                                    ?.store
                                    ?.storeDeliveryServices
                                    ?.length ??
                                0,
                            itemBuilder: (_, i) {
                              return Obx(() => CustomButton(
                                    width: WidgetConstants.screenWidth * 0.3,
                                    border:
                                        Border.all(color: AppColors.primary),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: storeHomeMainController
                                                  .storeDeliveryServiceId
                                                  .value ==
                                              storeHomeMainController
                                                  .storeDetailsResponse
                                                  .data
                                                  ?.store
                                                  ?.storeDeliveryServices?[i]
                                                  .storeDeliveryServiceId
                                                  .toString()
                                          ? [
                                              AppColors.primary,
                                              AppColors.primary
                                            ]
                                          : [AppColors.white, AppColors.white],
                                    ),
                                    onTap: () async {
                                      storeHomeMainController
                                          .storeDeliveryServiceId
                                          .value = storeHomeMainController
                                              .storeDetailsResponse
                                              .data
                                              ?.store
                                              ?.storeDeliveryServices?[i]
                                              .storeDeliveryServiceId
                                              .toString() ??
                                          "0";
                                      await storeHomeMainController
                                          .apiGetCartListApi();
                                    },
                                    height: 45,
                                    text: storeHomeMainController
                                                .storeDetailsResponse
                                                .data
                                                ?.store
                                                ?.storeDeliveryServices?[i]
                                                .deliveryServiceId ==
                                            "1"
                                        ? StringConstants.inStoreText
                                        : storeHomeMainController
                                                    .storeDetailsResponse
                                                    .data
                                                    ?.store
                                                    ?.storeDeliveryServices?[i]
                                                    .deliveryServiceId ==
                                                "2"
                                            ? StringConstants.deliveryText
                                            : StringConstants.curbSideText,
                                    textColor: storeHomeMainController
                                                .storeDeliveryServiceId.value ==
                                            storeHomeMainController
                                                .storeDetailsResponse
                                                .data
                                                ?.store
                                                ?.storeDeliveryServices?[i]
                                                .storeDeliveryServiceId
                                                .toString()
                                        ? AppColors.white
                                        : AppColors.primary,
                                    borderRadius: 12,
                                    fontWeight: FontWeight.w500,
                                    iconL: true,
                                    fontSize: 16,
                                    imageL: storeHomeMainController
                                                .storeDetailsResponse
                                                .data
                                                ?.store
                                                ?.storeDeliveryServices?[i]
                                                .deliveryServiceId ==
                                            "1"
                                        ? Image.asset(
                                            ImageConstants.instore,
                                            scale: 2.8,
                                            color: storeHomeMainController
                                                        .storeDeliveryServiceId
                                                        .value ==
                                                    storeHomeMainController
                                                        .storeDetailsResponse
                                                        .data
                                                        ?.store
                                                        ?.storeDeliveryServices?[
                                                            i]
                                                        .storeDeliveryServiceId
                                                        .toString()
                                                ? AppColors.white
                                                : AppColors.primary,
                                          )
                                        : storeHomeMainController
                                                    .storeDetailsResponse
                                                    .data
                                                    ?.store
                                                    ?.storeDeliveryServices?[i]
                                                    .deliveryServiceId ==
                                                "2"
                                            ? Image.asset(
                                                ImageConstants.delivery,
                                                scale: 2.8,
                                                color: storeHomeMainController
                                                            .storeDeliveryServiceId
                                                            .value ==
                                                        storeHomeMainController
                                                            .storeDetailsResponse
                                                            .data
                                                            ?.store
                                                            ?.storeDeliveryServices?[
                                                                i]
                                                            .storeDeliveryServiceId
                                                            .toString()
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                              )
                                            : Image.asset(
                                                ImageConstants.curb,
                                                scale: 2.8,
                                                color: storeHomeMainController
                                                            .storeDeliveryServiceId
                                                            .value ==
                                                        storeHomeMainController
                                                            .storeDetailsResponse
                                                            .data
                                                            ?.store
                                                            ?.storeDeliveryServices?[
                                                                i]
                                                            .storeDeliveryServiceId
                                                            .toString()
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                              ),
                                  ));
                            }),
                      ),
                      height20SizedBox,
                      Text(
                        StringConstants.pickUpLocationText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      height20SizedBox,
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: const BoxDecoration(
                              color: AppColors.greylight,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              )),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      ImageConstants.loc,
                                      scale: 2.5,
                                    ),
                                    width10SizedBox,
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        storeHomeMainController
                                                        .selectedUserAddress
                                                        .value
                                                        .addressLine1 ==
                                                    null &&
                                                storeHomeMainController
                                                        .selectedUserAddress
                                                        .value
                                                        .city ==
                                                    null
                                            ? StringConstants.addAddressText
                                            : "${storeHomeMainController.selectedUserAddress.value.addressLine1 ?? ""},${storeHomeMainController.selectedUserAddress.value.city ?? ""},"
                                                "${storeHomeMainController.selectedUserAddress.value.state?.stateName ?? ""},${storeHomeMainController.selectedUserAddress.value.state?.country?.countryName ?? ""},",
                                        style: const TextStyle(
                                            overflow: TextOverflow.visible,
                                            color: AppColors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                width10SizedBox,
                                InkWell(
                                  onTap: () {
                                    storeHomeMainController.selectedUserAddress
                                                    .value.addressLine1 ==
                                                null &&
                                            storeHomeMainController
                                                    .selectedUserAddress
                                                    .value
                                                    .city ==
                                                null
                                        ? Get.to(const AccountScreen(),
                                            arguments: ({"isFromCart": true}))
                                        : storeHomeMainController
                                                .userAddress.isNotEmpty
                                            ? storeHomeMainController
                                                .bottomSheetChangePickupLocation(
                                                    context)
                                            : null;
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border:
                                          Border.all(color: AppColors.primary),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        storeHomeMainController
                                                        .selectedUserAddress
                                                        .value
                                                        .addressLine1 ==
                                                    null &&
                                                storeHomeMainController
                                                        .selectedUserAddress
                                                        .value
                                                        .city ==
                                                    null
                                            ? StringConstants.addText
                                            : StringConstants.changeText,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: AppColors.primary),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                      height10SizedBox,
                      Text(
                        StringConstants.orderSummaryText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      height10SizedBox,
                      Center(
                        child: DottedBorder(
                          color: AppColors.blacklight,
                          strokeWidth: 1,
                          dashPattern: const [4, 4],
                          child: Obx(() => Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                color: AppColors.greylight,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            StringConstants.subtotalText,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "\$${storeHomeMainController.cartData.value.cartSubTotal?.toStringAsFixed(2) ?? "0"}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      height10SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            StringConstants.taxText,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "\$${storeHomeMainController.cartData.value.cartTotalTax?.toStringAsFixed(2) ?? "0"}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      height10SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            StringConstants.serviceFeesText,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "\$${storeHomeMainController.cartData.value.cartDeliveryServiceCharge?.toStringAsFixed(2) ?? "0"}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      height10SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            StringConstants.totalText,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "\$${storeHomeMainController.cartData.value.cartTotalPrice?.toStringAsFixed(2) ?? "0"}",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ]),
                              )),
                        ),
                      ),
                      height20SizedBox,
                    ]),
              ),
              height10SizedBox,
              Container(
                color: AppColors.primaryBackgroundLight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.payNowText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Obx(
                            () => Text(
                              "\$${storeHomeMainController.cartData.value.cartTotalPrice?.toStringAsFixed(2) ?? "0"}",
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          storeHomeMainController.apiPlaceOrder();
                        },
                        height: 45,
                        width: 120,
                        text: StringConstants.payNowText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
