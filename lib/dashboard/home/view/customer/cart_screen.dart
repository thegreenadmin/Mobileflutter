import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_edit_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet_customer.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

class CartScreen extends StatefulWidget {
  final bool? isFromAddProduct;
  final String? storeId;
  const CartScreen({super.key,  this.isFromAddProduct=false,  this.storeId});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with GlobalVarMixin{
  // final StoreHomeMainController storeHomeMainController =
  //     Get.put(StoreHomeMainController());

  late final StoreHomeMainController storeHomeMainController;

  @override
   initState()  {
    super.initState();
    
    // Check if user is guest - show modal for account-based features
    if (isGuest.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GuestAccessModal.show(
          title: "Login Required",
          message: "Please login to access your cart",
          onContinueAsGuest: () {
            // Allow guest to continue - just close modal and go back
            Get.back();
          },
        );
      });
      return;
    }
    
    storeHomeMainController = Get.put(StoreHomeMainController());

    storeHomeMainController.storeId.value = (widget.storeId != null && widget.storeId!.isNotEmpty) ? widget.storeId! : "0";
    storeHomeMainController.isFromAddProduct.value = widget.isFromAddProduct ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Loads the wallet balance and chains the active-cart, cart-list and
      // store-details fetches, so the cart works no matter where it's
      // opened from (tab bar, wallet cart icon, store page). Calling
      // apiActiveCartApi directly here left walletBalance at 0.0, showing
      // a bogus "insufficient funds" banner.
      await storeHomeMainController.apiGetUserWalletBalance();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: AppColors.primaryLight,
                  child: Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, right: 20, top: 50,bottom: 10),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      ImageConstants.homeMall,
                                      scale: 4,
                                    ),
                                    width10SizedBox,
                                    IconButton(
                                      padding: EdgeInsets.all(5),
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        storeHomeMainController.itemsCount.value = 1;
                                        // if (Get.parameters['isFromAddProduct'] ==
                                        //         'yes' &&
                                        //     Get.parameters["isFromHome"] ==
                                        //         "true") {
                                        //   Get.back(id: pageIdApp.value);
                                        //   Get.back(id: pageIdApp.value);
                                        //   Get.parameters['isFromAddProduct'] = 'no';
                                        // } else {
                                        Get.back(id: pageIdApp.value);
                                        // }


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
                              ]),
                        ],
                      )),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConstants.itemsText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            height10SizedBox,
                            Obx(
                              () => ListView.separated(
                                  padding: EdgeInsets.zero,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return height10SizedBox;
                                  },
                                  itemCount:
                                      storeHomeMainController.cartItems.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
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
                                                child: CommonWidgets
                                                    .cachedNetworkImage(
                                                  storeHomeMainController
                                                          .cartItems[i]
                                                          .product?.image?.dynamicUrl ?? "",
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
                                                            ?.productName ?? "",
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  height6SizedBox,
                                                  storeHomeMainController
                                                          .cartItems[i]
                                                          .product!
                                                          .description!
                                                          .isEmpty
                                                      ? height0SizedBox
                                                      : Text(
                                                          storeHomeMainController
                                                                  .cartItems[i]
                                                                  .product
                                                                  ?.description ?? "",
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  AppColors.black,
                                                              fontWeight:
                                                                  FontWeight.w400),
                                                        ),
                                                  storeHomeMainController
                                                          .cartItems[i]
                                                          .product!
                                                          .description!
                                                          .isEmpty
                                                      ? height0SizedBox
                                                      : height6SizedBox,
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
                                                                text:
                                                                    "${StringConstants.unitPriceText}:",
                                                                style: const TextStyle(
                                                                    color: AppColors.black,
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 14)),
                                                            TextSpan(
                                                              text:
                                                                  ' \$${storeHomeMainController.cartItems[i].product?.productPrice?.toStringAsFixed(2) ?? "0"}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
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
                                                            storeHomeMainController.cartItems[i].itemsCount != 0 &&
                                                                    !storeHomeMainController
                                                                        .isLoading.value
                                                                ? storeHomeMainController.apiUpdateCart(
                                                                    cartItemId: (storeHomeMainController
                                                                                .cartItems[i]
                                                                                .cartItemId?.isNotEmpty == true)
                                                                            ? int.parse(storeHomeMainController.cartItems[i].cartItemId!)
                                                                            : 0,
                                                                    quantity: storeHomeMainController
                                                                            .cartItems[i].itemsCount! - 1)
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
                                                                    .length < 2
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
                                                          !storeHomeMainController
                                                                  .isLoading.value
                                                              ? storeHomeMainController.apiUpdateCart(
                                                                  cartItemId: (storeHomeMainController
                                                                              .cartItems[
                                                                                  i]
                                                                              .cartItemId?.isNotEmpty == true)
                                                                          ? int.parse(storeHomeMainController.cartItems[i].cartItemId!)
                                                                          : 0,
                                                                  quantity: storeHomeMainController
                                                                          .cartItems[
                                                                              i]
                                                                          .itemsCount! +
                                                                      1)
                                                              : null;
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
                                                  Utility.showConfirmAlertMessage(
                                                      AlertStringConstants
                                                          .areYouSureText,
                                                      okay: StringConstants
                                                          .deleteText, okayTap: () {
                                                    storeHomeMainController
                                                        .apiDeleteCart(
                                                            cartItemId: (storeHomeMainController
                                                                        .cartItems[
                                                                            i]
                                                                        .cartItemId?.isNotEmpty == true)
                                                                    ? int.parse(storeHomeMainController.cartItems[i].cartItemId!)
                                                                    : 0);
                                                  });
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            height10SizedBox,
                            Obx(
                              () => storeHomeMainController
                                          .storeDetailsResponse
                                          .value
                                          .data?.store?.storeDeliveryServices !=null
                              /* && storeHomeMainController
                                  .storeDetailsResponse
                                  .value
                                  .data!.store!.storeDeliveryServices!.isNotEmpty*/
                                  ? GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: storeHomeMainController
                                              .storeDetailsResponse
                                              .value
                                              .data
                                              ?.store
                                              ?.storeDeliveryServices
                                              ?.length ??
                                          0,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            (WidgetConstants.screenWidth * 0.8) /
                                                WidgetConstants.screenHeight *
                                                8.5,
                                        mainAxisSpacing: 8.0,
                                        crossAxisSpacing: 8.0,
                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder: (BuildContext context, int i) {
                                        return Obx(() => CustomButton(
                                              width:
                                                  WidgetConstants.screenWidth * 0.3,
                                              border: Border.all(
                                                  color: AppColors.primary),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: storeHomeMainController
                                                            .storeDeliveryServiceId
                                                            .value ==
                                                        storeHomeMainController
                                                            .storeDetailsResponse
                                                            .value
                                                            .data?.store?.storeDeliveryServices?[i].storeDeliveryServiceId.toString()
                                                    ? [
                                                        AppColors.primary,
                                                        AppColors.primary
                                                      ]
                                                    : [
                                                        AppColors.white,
                                                        AppColors.white
                                                      ],
                                              ),
                                              onTap: () async {
                                                storeHomeMainController
                                                    .storeDeliveryServiceId
                                                    .value = storeHomeMainController
                                                        .storeDetailsResponse
                                                        .value
                                                        .data?.store?.storeDeliveryServices?[i]
                                                        .storeDeliveryServiceId.toString() ?? "0";
                                                storeHomeMainController
                                                        .selectedDeliveryService
                                                        .value =
                                                    storeHomeMainController
                                                        .storeDetailsResponse.value
                                                        .data?.store?.storeDeliveryServices![i]
                                                        .deliveryServiceId?.toString()??"";
                  
                                                storeHomeMainController
                                                        .storeAddressId.value =
                                                    storeHomeMainController.storeDetailsResponse.value
                                                        .data?.store?.storeAddresses?.first.storeAddressId
                                                        .toString()??"";
                  
                                                await storeHomeMainController
                                                    .apiGetUserWalletBalance();
                                                // await storeHomeMainController
                                                //     .apiGetCartListApi(
                                                //         isShowLoading: true);
                                              },
                                              height: 40,
                                              text: storeHomeMainController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeDeliveryServices?[i]
                                                          .deliveryServiceId ==
                                                      "1"
                                                  ? StringConstants.inStoreText
                                                  : storeHomeMainController
                                                              .storeDetailsResponse
                                                              .value
                                                              .data
                                                              ?.store
                                                              ?.storeDeliveryServices?[i]
                                                              .deliveryServiceId ==
                                                          "2"
                                                      ? StringConstants.deliveryText
                                                      : StringConstants
                                                          .curbSideText,
                                              textColor: storeHomeMainController
                                                          .storeDeliveryServiceId
                                                          .value ==
                                                      storeHomeMainController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeDeliveryServices?[
                                                      i]
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
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeDeliveryServices?[i]
                                                          .deliveryServiceId == "1"
                                                  ? Image.asset(
                                                      ImageConstants.instore,
                                                      scale: 2.5,
                                                      color: storeHomeMainController
                                                                  .storeDeliveryServiceId
                                                                  .value == storeHomeMainController.storeDetailsResponse.value
                                                                  .data?.store?.storeDeliveryServices?[i].storeDeliveryServiceId.toString()
                                                          ? AppColors.white
                                                          : AppColors.primary,
                                                    )
                                                  : storeHomeMainController.storeDetailsResponse.value.data?.store
                                                              ?.storeDeliveryServices?[i].deliveryServiceId == "2"
                                                      ? Image.asset(
                                                          ImageConstants.delivery,
                                                          scale: 2.5,
                                                          color: storeHomeMainController
                                                                      .storeDeliveryServiceId
                                                                      .value == storeHomeMainController
                                                                      .storeDetailsResponse
                                                                      .value
                                                                      .data
                                                                      ?.store
                                                                      ?.storeDeliveryServices?[i]
                                                                      .storeDeliveryServiceId.toString()
                                                              ? AppColors.white
                                                              : AppColors.primary,
                                                        )
                                                      : Image.asset(
                                                          ImageConstants.curb,
                                                          scale: 2.2,
                                                          color: storeHomeMainController
                                                                      .storeDeliveryServiceId
                                                                      .value == storeHomeMainController
                                                                      .storeDetailsResponse
                                                                      .value
                                                                      .data
                                                                      ?.store
                                                                      ?.storeDeliveryServices?[i]
                                                                      .storeDeliveryServiceId
                                                                      .toString()
                                                              ? AppColors.white
                                                              : AppColors.primary,
                                                        ),
                                            ));
                                      },
                                    )
                                  : Text(
                                      AlertStringConstants.noDataFoundText,
                                      style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                            ),
                            height20SizedBox,
                            Obx(
                              () => Text(
                                storeHomeMainController.selectedDeliveryService.value == "1" ||
                                        storeHomeMainController.selectedDeliveryService.value == "3"
                                    ? StringConstants.pickUpLocationText
                                    : StringConstants.shippingAddressText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            height15SizedBox,
                            Obx(
                              () => storeHomeMainController
                                              .selectedDeliveryService.value == "1" ||
                                      storeHomeMainController.selectedDeliveryService.value == "3"
                                  ? Container(
                                      width: WidgetConstants.screenWidth,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 12),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          )),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            ImageConstants.loc,
                                            scale: 2.5,
                                          ),
                                          width10SizedBox,
                                          Expanded(
                                            child: Text(
                                              "${storeHomeMainController.storeDetailsResponse.value.data?.store!.storeAddresses!.first.addressLine1 ?? ""}, ${storeHomeMainController.storeDetailsResponse.value.data?.store!.storeAddresses!.first.city ?? ""}, "
                                              "${storeHomeMainController.storeDetailsResponse.value.data?.store!.storeAddresses!.first.state!.stateName ?? ""}, ${storeHomeMainController.storeDetailsResponse.value.data?.store!.storeAddresses!.first.postalCode}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          )),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    ImageConstants.loc,
                                                    scale: 2.5,
                                                  ),
                                                  width10SizedBox,
                                                  Obx(
                                                    () => Expanded(
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
                                                            ? StringConstants
                                                                .addAddressText
                                                            : "${storeHomeMainController.selectedUserAddress.value.addressLine1 ?? ""},${storeHomeMainController.selectedUserAddress.value.city ?? ""},"
                                                                "${storeHomeMainController.selectedUserAddress.value.state?.stateName ?? ""},${storeHomeMainController.selectedUserAddress.value.state?.country?.countryName ?? ""},",
                                                        style: const TextStyle(
                                                            overflow: TextOverflow
                                                                .visible,
                                                            color: AppColors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            width10SizedBox,
                                            Visibility(
                                              visible: storeHomeMainController
                                                          .selectedUserAddress
                                                          .value
                                                          .addressLine1 ==
                                                      null &&
                                                  storeHomeMainController
                                                          .selectedUserAddress
                                                          .value
                                                          .city ==
                                                      null,
                                              child: Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Get.parameters["isFromCart"] =
                                                    //     "true";
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
                                                        ?
                                                        Get.to( PersonalInfoEditScreen(isFromCart : true),
                                                                id: pageIdApp.value,
                                                               /* arguments: ({
                                                                  "isFromCart": true
                                                                })*/)?.then((value) =>
                                                            storeHomeMainController
                                                                .apiGetUserDetailsApi())
                                                        : /*storeHomeMainController
                                                                  .userAddress
                                                                  .isNotEmpty
                                                              ? storeHomeMainController.bottomSheetChangePickupLocation(context)
                                                              : */
                                                        null;
                                                  },
                                                  child: Container(
                                                    height: 40.0,
                                                    width: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      border: Border.all(
                                                          color: AppColors.primary),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                        StringConstants.addText,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.0,
                                                            color:
                                                                AppColors.primary),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),
                            ),
                            height10SizedBox,
                            Text(
                              StringConstants.orderSummaryText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            height10SizedBox,
                            Center(
                              child: DottedBorder(
                                color: AppColors.blackLight,
                                strokeWidth: 1,
                                dashPattern: const [4, 4],
                                child: Obx(() => Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10, bottom: 0),
                                      color: AppColors.greyLight,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildRow(StringConstants.subtotalText, "\$${storeHomeMainController.cartData.value.cartSubTotal?.toStringAsFixed(2) ?? "0.00"}"),
                                            buildRow(StringConstants.discountText, "\$${storeHomeMainController.cartData.value.cartTotalDiscount?.toStringAsFixed(2) ?? "0.00"}"),
                                            buildRow(StringConstants.deliveryChargeText, "\$${storeHomeMainController.cartData.value.cartDeliveryServiceCharge?.toStringAsFixed(2) ?? "0.00"}"),
                                            buildRow(StringConstants.serviceFeesText, "\$${storeHomeMainController.cartData.value.cartTotalServiceCharged?.toStringAsFixed(2) ?? "0.00"}"),
                                            buildRow(StringConstants.taxText, "\$${storeHomeMainController.cartData.value.cartTotalTax?.toStringAsFixed(2) ?? "0.00"}"),
                                            buildRow(StringConstants.totalText, "\$${storeHomeMainController.cartData.value.cartTotalPrice?.toStringAsFixed(2) ?? "0.00"}",
                                                fontWeight: FontWeight.w600),
                                          ]),
                                    )),
                              ),
                            ),
                            Obx(
                              () => storeHomeMainController
                                              .cartData.value.cartTotalPrice !=
                                          null &&
                                      storeHomeMainController.walletBalance.value <
                                          storeHomeMainController
                                              .cartData.value.cartTotalPrice!
                                  ? height80SizedBox
                                  : height50SizedBox,
                            ),
                            height40SizedBox,
                          ]),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Obx(() =>
                        Visibility(
                          visible: storeHomeMainController
                                      .cartData.value.cartTotalPrice !=
                                  null &&
                              storeHomeMainController.walletBalance.value <
                                  storeHomeMainController
                                      .cartData.value.cartTotalPrice!,
                          child: Container(
                            color: AppColors.redLight,
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Obx(() => Text(
                                        "${StringConstants.inSufficientFundText}(\$${storeHomeMainController.walletBalance.value.toStringAsFixed(2)})",
                                        // "Cart Total Price- ${storeHomeMainController
                                        //     .cartData.value.cartTotalPrice} Wallet Balance- (\$${storeHomeMainController.walletBalance.value})",
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                            color: AppColors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() =>  AddMoneyToWalletUser(isFromCartScreen:true),
                                            id: pageIdApp.value)
                                        ?.then((value) {
                                      storeHomeMainController
                                          .apiGetUserWalletBalance();
                                    });

                                    Get.parameters["isFromCartScreen"] = "true";
                                  },
                                  child: Text(
                                    StringConstants.addFundText,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
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
                                  StringConstants.amountToPayText,
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
                            Obx(
                              () => CustomButton(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: storeHomeMainController
                                              .walletBalance.value <
                                          storeHomeMainController
                                              .cartTotalPrice.value
                                      ? [AppColors.grey, AppColors.grey]
                                      : [AppColors.primary, AppColors.primary],
                                ),
                                onTap: () async {
                                  if (storeHomeMainController.cartData.value.cartTotalPrice == null  || storeHomeMainController.cartData.value.cartTotalPrice == 0) {
                                    Utility.showConfirmAlertMessage("Order can not be proceed, Order amount is \$0",okayTap: (){
                                      Get.back(id: pageIdApp.value);
                                    });
                                    return;
                                  }

                                  // Get.parameters['isFromAddProduct'] = 'no';
                                  if (storeHomeMainController
                                          .storeDeliveryServiceId.value !=
                                      "0") {
                                    if (storeHomeMainController
                                                .walletBalance.value >=
                                            storeHomeMainController
                                                .cartTotalPrice.value &&
                                        storeHomeMainController
                                                .isLoading.value ==
                                            false) {
                                      storeHomeMainController
                                          .moneyDeductFromCartDialog(context,
                                              amount: storeHomeMainController
                                                      .cartData
                                                      .value
                                                      .cartTotalPrice
                                                      ?.toStringAsFixed(2) ??
                                                  "0");
                                    } else {
                                      /* Utility.showConfirmAlertMessage(
                                          StringConstants.inSufficientFundText,
                                          okay: StringConstants.addFundsText,
                                          okayTap: () async {
                                        Get.back();
                                        await Get.to(()=>const AddMoneyToWalletUser(),
                                                id: pageIdApp.value)
                                            ?.then((value) {
                                          storeHomeMainController
                                              .apiGetUserWalletBalance();
                                        });

                                        Get.parameters["isFromCartScreen"] =
                                            "true";
                                      });*/
                                    }
                                  } else {
                                    Utility.showAlertMessage(
                                        AlertStringConstants
                                            .pleaseSelectOrderTypeText);
                                  }
                                },
                                height: 45,
                                width: 120,
                                text: StringConstants.payNowText,
                                textColor: storeHomeMainController
                                            .walletBalance.value <
                                        storeHomeMainController
                                            .cartTotalPrice.value
                                    ? AppColors.black
                                    : AppColors.white,
                                borderRadius: 12,
                                fontWeight: FontWeight.w500,
                                iconL: false,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            //LOADING OVERLAY
            Obx(() {
              return storeHomeMainController.isLoading.value
                  ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),)
                  : const SizedBox.shrink();
            }),
          ],
        ));
  }

  Column buildRow(text, des,{FontWeight fontWeight = FontWeight.w500}) {
    return Column(
      children: [
        Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      des,
                      style:  TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: fontWeight),
                    ),
                  ],
                ), height10SizedBox,
      ],
    );
  }
}
