import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/store_home_main_args.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../view/component/order_status_enum.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String? orderId;
  final String? storeId;
  final String? orderStatus;
  final bool? isFromNotification;
  final bool? isFromTransaction;
  final bool? isHome;
  const OrderConfirmationScreen({super.key, this.orderId, this.storeId, this.isFromNotification, this.orderStatus, this.isFromTransaction, this.isHome});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> with GlobalVarMixin{
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  void initState() {
    // Check if user is guest - show modal for account-based features
    if (isGuest.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GuestAccessModal.show(
          title: "Login Required",
          message: "Please login to access order history",
          onContinueAsGuest: () {
            // Allow guest to continue - just close modal and go back
            Get.back();
          },
        );
      });
      super.initState();
      return;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersController.isFromNotification.value =
         widget.isFromNotification??false;
      ordersController.storeId.value = widget.storeId ?? "";
      if(ordersController.storeId.value !=""){
        ordersController.apiGetStoreDetailsApi();
      }

      ordersController.orderStatus.value = widget.orderStatus ?? "";
      // if (Get.parameters["isHome"] != null) {
        ordersController.isHome.value = widget.isHome ??false;
      // }
      ordersController.isActiveOrders.value = true;
      ordersController.orderStatusId.value = 2;

      if (ordersController.orderStatus.value != "") {
        ordersController.apiGetOrderDetailsApi();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (ordersController.isHome.value) {
          Get.back(id: pageIdApp.value);
          Get.back(id: pageIdApp.value);
        } else {
          Get.back(id: pageIdApp.value);
        }

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.25),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Obx(() => ordersController.storeDetailsResponse.value.data !=
                          null &&
                      ordersController.storeDetailsResponse.value.data?.store !=
                          null
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                              Colors.black45, BlendMode.darken),
                          image: () {
                                final url = ordersController
                                    .storeDetailsResponse
                                    .value
                                    .data
                                    ?.store
                                    ?.image
                                    ?.dynamicUrl;
                                return (url == null || url.isEmpty)
                                    ? const AssetImage(ImageConstants.storeicon)
                                        as ImageProvider
                                    : CachedNetworkImageProvider(url);
                              }(),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 35, left: 20.0, right: 20, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ordersController.isHome.value
                                        ? height0SizedBox
                                        : IconButton(
                                      splashRadius: 40,
                                      padding: EdgeInsets.all(10),
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              Get.back(id: pageIdApp.value);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: AppColors.white,
                                              size: 26.0,
                                            ),
                                          ),
                                    ordersController.isFavouriteStore.value ==
                                            true
                                        ? InkWell(
                                            onTap: () {
                                              if (ordersController
                                                      .isLoading.value ==
                                                  false) {
                                                ordersController
                                                    .apiRemoveFavouriteStore(
                                                        ordersController
                                                            .storeDetailsResponse
                                                            .value
                                                            .data
                                                            ?.store
                                                            ?.storeId);
                                              }
                                            },
                                            child: Image.asset(
                                              ImageConstants.liked,
                                              scale: 2.8,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              if (ordersController
                                                      .isLoading.value ==
                                                  false) {
                                                ordersController
                                                    .apiCreateFavouriteStore(
                                                        ordersController
                                                            .storeDetailsResponse
                                                            .value
                                                            .data
                                                            ?.store
                                                            ?.storeId);
                                              }
                                            },
                                            child: Image.asset(
                                              ImageConstants.favoutline,
                                              scale: 2.8,
                                            ),
                                          ),
                                  ]),

                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child:
                                        CommonWidgets.circleCachedNetworkImage(
                                      ordersController
                                              .storeDetailsResponse
                                              .value
                                              .data!
                                              .store!
                                              .logo!
                                              .dynamicUrl ??
                                          "",
                                      fit: BoxFit.contain,
                                      radius: 38.0,
                                      assetImg: ImageConstants.nopicfound,
                                    ),
                                  ),
                                  width10SizedBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ordersController
                                                  .storeDetailsResponse
                                                  .value
                                                  .data!
                                                  .store!
                                                  .storeName ??
                                              "",
                                          style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        height4SizedBox,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Image.asset(
                                                ImageConstants.loc,
                                                color: AppColors.white,
                                                scale: 3.0,
                                              ),
                                            ),
                                            width4SizedBox,
                                            Expanded(
                                              child: Text(
                                                  ordersController
                                                      .storeLocation.value,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        height4SizedBox,
                                        SizedBox(
                                          height: 15,
                                          child: Row(
                                            children: [
                                              Text(
                                                  ordersController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data!
                                                          .store!
                                                          .storeTimings!
                                                          .isNotEmpty
                                                      ? ordersController
                                                                  .storeDetailsResponse
                                                                  .value
                                                                  .data!
                                                                  .store!
                                                                  .storeTimings!
                                                                  .first
                                                                  .is24HoursActive ==
                                                              false
                                                          ? "${Utility.formatDateTime(ordersController.storeDetailsResponse.value.data!.store!.storeTimings!.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                              "${Utility.formatDateTime(ordersController.storeDetailsResponse.value.data!.store!.storeTimings!.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                          : StringConstants
                                                              .storeHoursText
                                                      : StringConstants
                                                          .storeHoursText,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.visible,
                                                      color: AppColors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              width8SizedBox,
                                            ],
                                          ),
                                        ),
                                        height4SizedBox,
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: ListView.separated(

                                                  padding: EdgeInsets.zero,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return width8SizedBox;
                                                  },
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: ordersController
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
                                                      child: ordersController
                                                                  .storeDetailsResponse
                                                                  .value
                                                                  .data
                                                                  ?.store
                                                                  ?.storeDeliveryServices?[
                                                                      i]
                                                                  .deliveryServiceId ==
                                                              "1"
                                                          ? Image.asset(
                                                              ImageConstants
                                                                  .instore,
                                                              scale: 4.5,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : ordersController
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
                                                                  color: Colors
                                                                      .white,
                                                                  scale: 4.5,
                                                                )
                                                              : Image.asset(
                                                                  ImageConstants
                                                                      .curb,
                                                                  color: Colors
                                                                      .white,
                                                                  scale: 3.5,
                                                                ),
                                                    );
                                                  }),
                                            ),
                                            width6SizedBox,
                                            InkWell(
                                              highlightColor:
                                                  Colors.transparent,
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
                    )
                  : height0SizedBox)
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height30SizedBox,
                Obx(
                  () => Visibility(
                    visible: ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnRequest.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnConfirmed.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnCancelled.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returned.statusName,
                    child: Column(
                      children: [
                        Image.asset(ImageConstants.tickBorder, scale: 1.2),
                        height8SizedBox,
                        Text(
                          StringConstants.orderConfirmedText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: AppColors.black),
                        ),
                        height8SizedBox,
                        Text(
                          StringConstants.thankOrderText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.black),
                        ),
                        height10SizedBox,
                        const Divider(
                          height: 20,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                height12SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.orderIDText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Obx(
                      () => Text(
                        ordersController.orderStatus.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.primary),
                      ),
                    )
                  ],
                ),
                height12SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.orderStatusText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Obx(
                      () => Text(
                        ordersController.orderStatusTypeName.value
                            .toTitleCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.green),
                      ),
                    )
                  ],
                ),
                height12SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.orderAmountText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Obx(
                      () => Text(
                        "\$${ordersController.totalAmount.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.primary),
                      ),
                    )
                  ],
                ),
                height12SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.orderDateText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    Obx(
                      () => Text(
                        ordersController.orderDate.value != ""
                            ? Utility.formatDateTime(
                                '${ordersController.orderDate.value.toString().substring(0, 10)} ${ordersController.orderDate.value.toString().substring(11, 23)}',
                                firstFormat: "yyyy-MM-dd HH:mm:ss",
                                secFormat: "dd MMM yyyy")
                            : "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.primary),
                      ),
                    )
                  ],
                ),
                height10SizedBox,
                const Divider(
                  height: 20,
                  color: AppColors.grey,
                ),
                height30SizedBox,
                buildEasyStepper(),
                Obx(
                  () => Visibility(
                    visible: ordersController.orderStatusTypeName.value ==
                            OrderStatusEnum.readyForPickup.statusName &&
                        ordersController.orderType.value != "2" /*&& !ordersController.isCustomerReached.value*/,
                    child: Column(
                      children: [
                        CustomButton(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primary, AppColors.primary],
                          ),
                          onTap: () {
                            ordersController.apiIamHereNotification();
                          },
                          height: 50,
                          width: WidgetConstants.screenWidth * 0.5,
                          text: StringConstants.hereForPickupText,
                          borderRadius: 12,
                          fontWeight: FontWeight.w500,
                          iconL: false,
                          fontSize: 16,
                        ),
                        height30SizedBox,
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnRequest.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnConfirmed.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returnCancelled.statusName &&
                        ordersController.orderStatusTypeName.value !=
                            OrderStatusEnum.returned.statusName,
                    child: Column(
                      children: [
                        CustomButton(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primary, AppColors.primary],
                          ),
                          onTap: () async {
                            /*Get.parameters["storeId"] =
                                ordersController.storeId.value;
                            Get.parameters["isFromMenu"] = "false";
                            Get.parameters["isFromHome"] = "true";
                            Get.parameters["isFromFav"] = "false";
                            Get.parameters["isFromOptions"] = "false";*/
                            // Get.put(StoreHomeMainController()).onInit();
                            Get.to(() => StoreHomeMainScreen(
                                args:  StoreHomeMainArgs(
                                  storeId: ordersController.storeId.value,
                                  isFromMenu: false,isFromFav: false,
                                  isFromHome: true, isFromOptions: false,
                                )
                            ),
                                id: pageIdApp.value);
                          },
                          height: 50,
                          width: WidgetConstants.screenWidth * 0.5,
                          text: StringConstants.continueShoppingText,
                          borderRadius: 12,
                          fontWeight: FontWeight.w500,
                          iconL: false,
                          fontSize: 16,
                        ),
                        height20SizedBox,
                        CustomButton(
                          border: Border.all(color: AppColors.primary),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.white, AppColors.white],
                          ),
                          onTap: showOrderQrDialog,
                          height: 50,
                          width: WidgetConstants.screenWidth * 0.5,
                          text: StringConstants.showOrderQRText,
                          textColor: AppColors.primary,
                          borderRadius: 12,
                          fontWeight: FontWeight.w500,
                          iconL: false,
                          fontSize: 16,
                        ),
                        height20SizedBox,
                      ],
                    ),
                  ),
                ),
                buildOrderItems()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The store side scans this from Orders > Scan Order Barcode to open the
  /// fulfil screen for this order (see OrderBarcodeScannerScreen).
  void showOrderQrDialog() {
    final payload = jsonEncode({
      "type": "order",
      "order_id": ordersController.orderStatus.value,
      "store_id": ordersController.storeId.value,
    });
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        icon: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.clear,
              color: AppColors.primary,
              size: 24.0,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // AlertDialog measures its content with IntrinsicWidth, which
        // QrImageView's internal LayoutBuilder can't answer — the tight
        // SizedBoxes below keep intrinsic measurement from reaching it.
        content: SizedBox(
          width: 260,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyLight),
              ),
              child: SizedBox(
                width: 220,
                height: 220,
                child: QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  size: 220,
                ),
              ),
            ),
            height12SizedBox,
            Text(
              "${StringConstants.orderIDText}: #${ordersController.orderStatus.value}",
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            height8SizedBox,
            Text(
              StringConstants.showQrAtStoreText,
              style: TextStyle(color: AppColors.blackLight, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
          ),
        ),
      ),
    );
  }

  Obx buildEasyStepper() {
    return Obx(
                () => Visibility(
                  visible: ordersController.orderStatusTypeName.value !=
                          OrderStatusEnum.returnRequest.statusName &&
                      ordersController.orderStatusTypeName.value !=
                          OrderStatusEnum.returnConfirmed.statusName &&
                      ordersController.orderStatusTypeName.value !=
                          OrderStatusEnum.returnCancelled.statusName &&
                      ordersController.orderStatusTypeName.value !=
                          OrderStatusEnum.returned.statusName,
                  child: Column(
                    children: [
                      EasyStepper(
                        activeStep: ordersController.activeStep.value,
                        stepShape: StepShape.circle,
                        borderThickness: 0,
                        stepRadius: WidgetConstants.screenWidth * 0.075,
                        lineStyle: LineStyle(
                          lineLength: WidgetConstants.screenWidth * 0.063,
                          lineType: LineType.normal,
                          activeLineColor: AppColors.grey,
                          defaultLineColor: AppColors.grey,
                        ),
                        activeStepBorderType: BorderType.normal,
                        unreachedStepBorderType: BorderType.normal,
                        finishedStepTextColor: AppColors.primary,
                        finishedStepBackgroundColor: AppColors.white,
                        activeStepIconColor: AppColors.white,
                        showLoadingAnimation: false,
                        showStepBorder: false,
                        disableScroll: true,
                        unreachedStepIconColor: AppColors.black,
                        unreachedStepTextColor: AppColors.black,
                        steps: List<EasyStep>.generate(
                          ordersController.stepInd.length,
                          (index) => EasyStep(
                            customStep: Center(
                              child: ordersController
                                          .stepInd[index].isSelected ==
                                      true
                                  ? Image.asset(
                                      ImageConstants.blueTick,
                                      scale: 3.5,
                                    )
                                  : Image.asset(
                                      ImageConstants.blackTick,
                                      scale: 3.5,
                                    ),
                            ),
                            customTitle: Text(
                              ordersController.stepInd[index].name ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppColors.black),
                            ),
                          ),
                        ),
                        onStepReached: (index) {},
                      ),
                      height20SizedBox,
                    ],
                  ),
                ),
              );
  }

  Widget buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringConstants.itemsText,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.black),
            ),
            Obx(
              () => Visibility(
                visible: ordersController.orderStatusTypeName.value ==
                    OrderStatusEnum.returnRequest.statusName,
                child: CustomButton(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.white, AppColors.white],
                  ),
                  onTap: () {
                    Utility.showConfirmAlertMessage(
                        AlertStringConstants.cancelReturnRequestAlertText,
                        okay: StringConstants.yesText,
                        cancelText: StringConstants.noText, okayTap: () {
                      ordersController.apiCancelReturnRequestOrder();
                    });
                  },
                  height: 35,
                  border: Border.all(
                    color: AppColors.blackLight,
                    width: 1,
                  ),
                  textColor: AppColors.red,
                  width: WidgetConstants.screenWidth * 0.28,
                  text: StringConstants.canceReturnlText,
                  borderRadius: 12,
                  fontWeight: FontWeight.w500,
                  iconL: false,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
        height20SizedBox,
        Obx(() => SizedBox(
              height: WidgetConstants.screenHeight * 0.3,
              child: ordersController.orderItems.isEmpty
                  ? ordersController.isLoading.value == true
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
                                StringConstants.noOrdersItemsFoundText,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.separated(

                      separatorBuilder: (BuildContext context, int index) {
                        return height8SizedBox;
                      },
                      padding: EdgeInsets.only(
                          bottom: WidgetConstants.screenHeight * 0.1),
                      itemCount: ordersController.orderItems.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.white,
                                              width: 1)),
                                      child: CommonWidgets
                                          .circleCachedNetworkImage(
                                        ordersController.orderItems[i]
                                                        .product !=
                                                    null &&
                                                ordersController
                                                        .orderItems[i]
                                                        .product
                                                        ?.productImages !=
                                                    null &&
                                                ordersController
                                                    .orderItems[i]
                                                    .product!
                                                    .productImages!
                                                    .isNotEmpty
                                            ? ordersController
                                                    .orderItems[i]
                                                    .product
                                                    ?.productImages
                                                    ?.first
                                                    .image
                                                    ?.dynamicUrl ??
                                                ""
                                            : "",
                                        fit: BoxFit.contain,
                                        radius: 22.0,
                                        assetImg: ImageConstants.defaultProduct,
                                      ),
                                    ),
                                    width5SizedBox,
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ordersController.orderItems[i]
                                                    .product?.productName
                                                    ?.toCapitalized() ??
                                                "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: AppColors.black),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "${StringConstants.unitPriceText}: ",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .blackLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14)),
                                                      TextSpan(
                                                        text:
                                                            "\$${ordersController.orderItems[i].offerPrice?.toStringAsFixed(2) ?? "0.00"}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppColors
                                                                .blackLight),
                                                      ),
                                                    ],
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${StringConstants.qtyText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14)),
                                                TextSpan(
                                                  text: ordersController
                                                          .orderItems[i]
                                                          .orderItemCount
                                                          ?.toString()
                                                          .padLeft(2, '0') ??
                                                      "0",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackLight),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.visible,
                                          ),
                                          height8SizedBox,
                                          Visibility(
                                            visible: ordersController.orderItems[i].product != null &&
                                                ordersController.orderItems[i].product?.productReviews !=
                                                    null &&
                                                ordersController
                                                    .orderItems[i]
                                                    .product!
                                                    .productReviews!
                                                    .isNotEmpty &&
                                                (ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isEmpty &&
                                                    ordersController.orderStatusTypeName.value !=
                                                        OrderStatusEnum
                                                            .returnRequest
                                                            .statusName) &&
                                                (ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isEmpty &&
                                                    ordersController.orderStatusTypeName.value !=
                                                        OrderStatusEnum
                                                            .returnConfirmed
                                                            .statusName) &&
                                                (ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isEmpty &&
                                                    ordersController.orderStatusTypeName.value !=
                                                        OrderStatusEnum.returnCancelled.statusName),
                                            child: RatingBar.builder(
                                              initialRating: ordersController
                                                          .orderItems[i]
                                                          .product !=
                                                      null
                                                  ? ordersController
                                                          .orderItems[i]
                                                          .product!
                                                          .productReviews!
                                                          .isNotEmpty
                                                      ? ordersController
                                                              .orderItems[i]
                                                              .product!
                                                              .productReviews
                                                              ?.first
                                                              .rating
                                                              ?.toDouble() ??
                                                          0.0
                                                      : 0.0
                                                  : 0.0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              unratedColor: AppColors.grey,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 20.0,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.2),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                // _selectedIcon ?? Icons.star,
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                // ratingValue.value = rating;
                                              },
                                              updateOnDrag: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isNotEmpty &&
                                                    ordersController
                                                            .orderStatusTypeName
                                                            .value ==
                                                        OrderStatusEnum
                                                            .returnRequest
                                                            .statusName ||
                                                ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isNotEmpty &&
                                                    ordersController
                                                            .orderStatusTypeName
                                                            .value ==
                                                        OrderStatusEnum
                                                            .returnConfirmed
                                                            .statusName ||
                                                ordersController
                                                        .orderItems[i]
                                                        .returnOrderItems!
                                                        .isNotEmpty &&
                                                    ordersController
                                                            .orderStatusTypeName
                                                            .value ==
                                                        OrderStatusEnum
                                                            .returnCancelled
                                                            .statusName,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "${StringConstants.statusText}: ",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .blackLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12)),
                                                      TextSpan(
                                                        text: ordersController
                                                                    .orderStatusTypeName
                                                                    .value ==
                                                                OrderStatusEnum
                                                                    .returnRequest
                                                                    .statusName
                                                            ? StringConstants
                                                                .inProgress
                                                            : ordersController
                                                                        .orderStatusTypeName
                                                                        .value ==
                                                                    OrderStatusEnum
                                                                        .returnConfirmed
                                                                        .statusName
                                                                ? StringConstants
                                                                    .approvedText
                                                                : StringConstants
                                                                    .completedText,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: AppColors
                                                                .blackLight),
                                                      ),
                                                    ],
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: ordersController
                                                    .orderItems[i]
                                                    .product!
                                                    .productReviews!
                                                    .isEmpty &&
                                                ordersController
                                                        .activeStep.value ==
                                                    2 &&
                                                ordersController
                                                    .orderItems[i]
                                                    .returnOrderItems!
                                                    .isEmpty &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .cancelled.statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .cancellationRequest
                                                        .statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .cancelRequest
                                                        .statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .failed.statusName &&
                                                (ordersController
                                                            .orderStatusTypeName
                                                            .value !=
                                                        OrderStatusEnum
                                                            .returnRequest
                                                            .statusName ||
                                                    ordersController
                                                            .orderStatusTypeName
                                                            .value !=
                                                        OrderStatusEnum
                                                            .returnConfirmed
                                                            .statusName ||
                                                    ordersController
                                                            .orderStatusTypeName
                                                            .value !=
                                                        OrderStatusEnum
                                                            .returnCancelled
                                                            .statusName),
                                            child: CustomButton(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.white,
                                                  AppColors.white
                                                ],
                                              ),
                                              onTap: () {
                                                ordersController.ratingValue
                                                    .value = ordersController
                                                            .orderItems[i]
                                                            .product !=
                                                        null
                                                    ? ordersController
                                                            .orderItems[i]
                                                            .product!
                                                            .productReviews!
                                                            .isNotEmpty
                                                        ? ordersController
                                                                .orderItems[i]
                                                                .product!
                                                                .productReviews
                                                                ?.first
                                                                .rating
                                                                ?.toDouble() ??
                                                            0.0
                                                        : 0.0
                                                    : 0.0;
                                                ordersController.productId
                                                    .value = ordersController
                                                        .orderItems[i]
                                                        .productId ??
                                                    "";
                                                ordersController
                                                    .bottomSheetRateNow(
                                                        context);
                                              },
                                              height: 35,
                                              border: Border.all(
                                                color: AppColors.primary,
                                                width: 1,
                                              ),
                                              textColor: AppColors.primary,
                                              width:
                                                  WidgetConstants.screenWidth *
                                                      0.25,
                                              text: StringConstants.rateNowText,
                                              borderRadius: 10,
                                              fontWeight: FontWeight.w500,
                                              iconL: false,
                                              fontSize: 14,
                                            ),
                                          ),
                                          /* Visibility(
                                    visible: ordersController
                                        .activeStep.value != 3 && ordersController
                                        .activeStep.value != 2
                                        && ordersController.orderStatusTypeName.value != OrderStatus.cancellationRequest.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.cancelRequest.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.cancelled.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.returnRequest.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.returnConfirmed.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.returnCancelled.statusName ,
                                    child: CustomButton(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.white,
                                          AppColors.white
                                        ],
                                      ),
                                      onTap: () {
                                        Utility.showConfirmAlertMessage(
                                            AlertStringConstants.cancelOrderAlertText,
                                            okay: StringConstants.yesText,cancelText:  StringConstants.noText,
                                            okayTap: (){
                                              ordersController
                                                  .orderItemObj.value =
                                              ordersController
                                                  .orderItems[i];
                                              ordersController
                                                  .apiCancelOrder(context);
                                            });

                                      },
                                      height: 35,
                                      border: Border.all(
                                        color: AppColors.blacklight,
                                        width: 1,
                                      ),
                                      textColor: AppColors.red,
                                      width:
                                      WidgetConstants.screenWidth * 0.3,
                                      text: StringConstants.cancelOrderText,
                                      borderRadius: 12,
                                      fontWeight: FontWeight.w500,
                                      iconL: false,
                                      fontSize: 12,
                                    ),
                                  ),*/
                                          height6SizedBox,
                                          Visibility(
                                            visible: ordersController
                                                        .activeStep.value ==
                                                    2 &&
                                                ordersController.orderItems[i]
                                                        .enableReturnButton ==
                                                    true &&
                                                ordersController.orderItems[i]
                                                    .returnOrderItems!.isEmpty &&
                                                ordersController.orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .returnRequest
                                                        .statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .cancelled.statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .returnConfirmed
                                                        .statusName &&
                                                ordersController
                                                        .orderStatusTypeName
                                                        .value !=
                                                    OrderStatusEnum
                                                        .returnCancelled
                                                        .statusName,
                                            child: InkWell(
                                              onTap: () {
                                                Utility.showConfirmAlertMessage(
                                                    AlertStringConstants
                                                        .returnOrderAlertText,
                                                    okay:
                                                        StringConstants.yesText,
                                                    cancelText: StringConstants
                                                        .noText, okayTap: () {
                                                  ordersController
                                                          .orderItemObj.value =
                                                      ordersController
                                                          .orderItems[i];
                                                  ordersController
                                                      .bottomSheetReturnOrder(
                                                          context);
                                                });
                                              },
                                              child: Text(
                                                StringConstants.returnOrderText,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: AppColors.red),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: ordersController.orderItems[i].product != null &&
                                      ordersController.orderItems[i].product?.productReviews !=
                                          null &&
                                      ordersController.orderItems[i].product!
                                          .productReviews!.isNotEmpty &&
                                      (ordersController.orderItems[i].returnOrderItems!.isEmpty &&
                                          ordersController.orderStatusTypeName.value !=
                                              OrderStatusEnum
                                                  .returnRequest.statusName) &&
                                      (ordersController.orderItems[i].returnOrderItems!.isEmpty &&
                                          ordersController.orderStatusTypeName.value !=
                                              OrderStatusEnum.returnConfirmed
                                                  .statusName) &&
                                      (ordersController.orderItems[i]
                                              .returnOrderItems!.isEmpty &&
                                          ordersController.orderStatusTypeName.value !=
                                              OrderStatusEnum.returnCancelled
                                                  .statusName) &&
                                      (ordersController.orderItems[i]
                                              .returnOrderItems!.isEmpty &&
                                          ordersController.orderStatusTypeName.value !=
                                              OrderStatusEnum.returned.statusName),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      height8SizedBox,
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${StringConstants.reviewText}: ",
                                                style: TextStyle(
                                                    color: AppColors.blackLight,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                              text: ordersController
                                                              .orderItems[i]
                                                              .product !=
                                                          null &&
                                                      ordersController
                                                              .orderItems[i]
                                                              .product
                                                              ?.productReviews !=
                                                          null &&
                                                      ordersController
                                                          .orderItems[i]
                                                          .product!
                                                          .productReviews!
                                                          .isNotEmpty
                                                  ? ordersController
                                                          .orderItems[i]
                                                          .product
                                                          ?.productReviews
                                                          ?.first
                                                          .review ??
                                                      ""
                                                  : "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: AppColors.blackLight),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.start,
                                      ),
                                      height4SizedBox,
                                    ],
                                  ),
                                ),
                                height4SizedBox,
                                Visibility(
                                  visible: ordersController.orderItems[i]
                                              .returnOrderItems!.isNotEmpty &&
                                          ordersController
                                                  .orderStatusTypeName.value ==
                                              OrderStatusEnum
                                                  .returnRequest.statusName ||
                                      ordersController.orderItems[i]
                                              .returnOrderItems!.isNotEmpty &&
                                          ordersController
                                                  .orderStatusTypeName.value ==
                                              OrderStatusEnum
                                                  .returnConfirmed.statusName ||
                                      ordersController.orderItems[i]
                                              .returnOrderItems!.isNotEmpty &&
                                          ordersController
                                                  .orderStatusTypeName.value ==
                                              OrderStatusEnum
                                                  .returnCancelled.statusName ||
                                      ordersController.orderItems[i]
                                              .returnOrderItems!.isNotEmpty &&
                                          ordersController
                                                  .orderStatusTypeName.value ==
                                              OrderStatusEnum
                                                  .returned.statusName,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${StringConstants.returnRequestDateText}: ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackLight,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text: ordersController
                                                                    .orderItems[
                                                                        i]
                                                                    .returnOrderItems !=
                                                                null &&
                                                            ordersController
                                                                .orderItems[i]
                                                                .returnOrderItems!
                                                                .isNotEmpty
                                                        ? Utility.formatDateTime(
                                                            '${ordersController.orderItems[i].returnOrderItems?.first.createdAt.toString().substring(0, 10)} ${ordersController.orderItems[i].returnOrderItems?.first.createdAt.toString().substring(11, 23)}',
                                                            firstFormat:
                                                                "yyyy-MM-dd HH:mm:ss",
                                                            secFormat:
                                                                "dd MMM yyyy")
                                                        : "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .blackLight),
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          width50SizedBox,
                                          width50SizedBox,
                                          width50SizedBox,
                                          width30SizedBox,
                                          /* Expanded(
                                    child: Text.rich(
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
                                                  fontSize: 12)),
                                          TextSpan(
                                            text:
                                            ordersController.orderStatusTypeName.value == OrderStatus.returnRequest.statusName
                                                ? StringConstants.inProgress
                                                : ordersController.orderStatusTypeName.value == OrderStatus.returnConfirmed.statusName?
                                            StringConstants.approvedText:StringConstants.completedText,
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
                                      textAlign: TextAlign.end,
                                    ),
                                  ),*/
                                        ],
                                      ),
                                      height4SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // width50SizedBox,
                                          Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${StringConstants.returnRequestAmountText}: ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackLight,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text: ordersController
                                                                    .orderItems[
                                                                        i]
                                                                    .returnOrderItems !=
                                                                null &&
                                                            ordersController
                                                                .orderItems[i]
                                                                .returnOrderItems!
                                                                .isNotEmpty
                                                        ? "\$${ordersController.orderItems[i].returnOrderItems?.first.totalAmountReversed?.toStringAsFixed(2) ?? ""}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .blackLight),
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${StringConstants.lastUpdateDateText}:",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackLight,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14)),
                                                  TextSpan(
                                                    text: ordersController
                                                                    .orderItems[
                                                                        i]
                                                                    .returnOrderItems !=
                                                                null &&
                                                            ordersController
                                                                .orderItems[i]
                                                                .returnOrderItems!
                                                                .isNotEmpty
                                                        ? Utility.formatDateTime(
                                                            '${ordersController.orderItems[i].returnOrderItems?.first.updatedAt.toString().substring(0, 10)} ${ordersController.orderItems[i].returnOrderItems?.first.updatedAt.toString().substring(11, 23)}',
                                                            firstFormat:
                                                                "yyyy-MM-dd HH:mm:ss",
                                                            secFormat:
                                                                "dd MMM yyyy")
                                                        : "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .blackLight),
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        ],
                                      ),
                                      height4SizedBox,
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${StringConstants.returnReasonText}: ",
                                                style: TextStyle(
                                                    color: AppColors.blackLight,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                              text: ordersController
                                                              .orderItems[i]
                                                              .returnOrderItems !=
                                                          null &&
                                                      ordersController
                                                          .orderItems[i]
                                                          .returnOrderItems!
                                                          .isNotEmpty
                                                  ? ordersController
                                                          .orderItems[i]
                                                          .returnOrderItems
                                                          ?.first
                                                          .remarks
                                                          .toString() ??
                                                      ""
                                                  : "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: AppColors.blackLight),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        );
                      }),
            )),
      ],
    );
  }
}
