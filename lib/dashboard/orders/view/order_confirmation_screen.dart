import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import '../view/component/order_status_enum.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersController.firstName?.value =
          SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
      ordersController.lastName?.value =
          SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
      if (Get.parameters == null
          ? false
          : Get.parameters['isFromNotification'] != "false") {
        ordersController.isFromNotification.value =
            Get.parameters["isFromNotification"] == "true" ? true : false;
      }
      if (Get.parameters == null
          ? false
          : Get.parameters['storeId'] != "" &&
              Get.parameters['storeId'] != null) {
        ordersController.storeId.value = Get.parameters["storeId"] ?? "";
        ordersController.apiGetStoreDetailsApi();
      }

      if (Get.parameters == null
          ? false
          : Get.parameters['isFromTransaction'] == "true"
              ? true
              : false) {
        ordersController.storeId.value = Get.parameters["storeId"] ?? "";
        ordersController.apiGetStoreDetailsApi();
      }
      if (Get.parameters["orderStatus"] != null) {
        ordersController.orderStatus.value =
            Get.parameters["orderStatus"] ?? "";
      }
      ordersController.isActiveOrders.value = true;
      ordersController.orderStatusId.value = 2;
      // ordersController.orderStatusName.value = OrderStatus.newOrder.statusName;
      // print("SharedPreferenceStorage:--Order Screen---------------");
      // print(SharedPreferenceStorage.getData(Role.role.value));
      if (SharedPreferenceStorage.getData(Role.role.value) ==
          Role.customerRoleText) {
        ordersController.role!.value = Role.customerRoleText;
        // ordersController.apiGetOrderListApi();
        if (ordersController.orderStatus.value != "") {
          ordersController.apiGetOrderDetailsApi();
        }
        // ordersController.page.value = 1;
      } /*else {
        ordersController.role!.value = Role.storeOwnerRoleText;
        ordersController.apiGetStoreOrderListApi();
        ordersController.page.value = 1;
      }*/
      // ordersController.apiGetOrderStatusListApi();
      // ordersController.setupScrollController(Get.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Get.back();
        // Get.back();
        // Get.back();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.26),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Obx(() => ordersController.storeDetailsResponse.value.data !=
                          null &&
                      ordersController.storeDetailsResponse.value.data!.store !=
                          null
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                              Colors.black45, BlendMode.darken),
                          image: ordersController.storeDetailsResponse.value
                                          .data!.store!.image!.dynamicUrl ==
                                      null ||
                                  ordersController.storeDetailsResponse.value
                                      .data!.store!.image!.dynamicUrl!.isEmpty
                              ? const AssetImage(ImageConstants.storeicon)
                                  as ImageProvider
                              : NetworkImage(ordersController
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //Get.back();
                                        //   Get.back();
                                        //   Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                    ordersController.isFavouriteStore.value ==
                                            true
                                        ? InkWell(
                                            onTap: () {
                                              ordersController
                                                  .apiRemoveFavouriteStore(
                                                      ordersController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeId);
                                            },
                                            child: Image.asset(
                                              ImageConstants.liked,
                                              scale: 2.8,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              ordersController
                                                  .apiCreateFavouriteStore(
                                                      ordersController
                                                          .storeDetailsResponse
                                                          .value
                                                          .data
                                                          ?.store
                                                          ?.storeId);
                                            },
                                            child: Image.asset(
                                              ImageConstants.favoutline,
                                              scale: 2.8,
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
                                      backgroundImage: ordersController
                                                      .storeDetailsResponse
                                                      .value.data!.store!.logo!
                                                      .dynamicUrl ==
                                                  null ||
                                              ordersController
                                                  .storeDetailsResponse
                                                  .value.data!
                                                  .store!.logo!
                                                  .dynamicUrl!.isEmpty
                                          ? const AssetImage(
                                                  ImageConstants.storeicon)
                                              as ImageProvider
                                          : NetworkImage(ordersController
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ordersController.storeDetailsResponse
                                                .value.data!.store!.storeName ??
                                            "",
                                        style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      height6SizedBox,
                                      Row(
                                        children: [
                                          Image.asset(
                                            ImageConstants.loc,
                                            color: AppColors.white,
                                            scale: 2,
                                          ),
                                          width4SizedBox,
                                          SizedBox(
                                            width: WidgetConstants.screenWidth *
                                                0.6,
                                            child: Text(
                                                ordersController
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
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                        ],
                                      ),
                                      height6SizedBox,
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
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            width8SizedBox,
                                          ],
                                        ),
                                      ),
                                      height6SizedBox,
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                            width: 100,
                                            child: ListView.separated(
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
                                                    radius: 12.0,
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
                                                            color: Colors.white,
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
                    Obx(() =>  Text(
                      ordersController.orderStatusTypeName.value.toTitleCase()??"",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.green),
                    ),)

                  ],
                ),height12SizedBox,
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
                     Text(
                      "\$${ordersController.orderDetailResponse.data?.order?.totalAmount?.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.primary),
                    ),

                  ],
                ),height12SizedBox,
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
                     Text(
                      Utility.formatDateTime(
                          '${ordersController.orderDetailResponse.data?.order?.createdAt.toString().substring(0, 10)} ${ordersController.orderDetailResponse.data?.order?.createdAt.toString().substring(11, 23)}',
                          firstFormat:
                          "yyyy-MM-dd HH:mm:ss",
                          secFormat:
                          "dd MMM yyyy"),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.primary),
                    ),

                  ],
                ),
                height10SizedBox,
                const Divider(
                  height: 20,
                  color: AppColors.grey,
                ),
                height30SizedBox,
                Visibility(
                  visible: ordersController.orderStatusTypeName.value != OrderStatus.returnRequest.statusName
                      && ordersController.orderStatusTypeName.value != OrderStatus.returnConfirmed.statusName
                      && ordersController.orderStatusTypeName.value != OrderStatus.returnCancelled.statusName,
                  child: Column(
                    children: [
                      Obx(
                        () => EasyStepper(
                          activeStep: ordersController.activeStep.value,
                          lineLength: WidgetConstants.screenWidth * 0.063,
                          stepShape: StepShape.circle,
                          borderThickness: 0,
                          stepRadius: WidgetConstants.screenWidth * 0.075,
                          lineColor: AppColors.grey,
                          lineType: LineType.normal,
                          activeStepBorderType: BorderType.normal,
                          unreachedStepBorderType: BorderType.normal,
                          finishedStepBorderColor: AppColors.white,
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
                              customStep:
                                  ordersController.stepInd[index].isSelected == true
                                      ? Image.asset(
                                          ImageConstants.blueTick,
                                          scale: 3.5,
                                        )
                                      : Image.asset(
                                          ImageConstants.blackTick,
                                          scale: 3.5,
                                        ),
                              customTitle: Text(
                                ordersController.stepInd[index].name ?? "",
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
                      ),
                      height30SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          BuildContext rContext =
                          SharedPreferenceStorage.getData(
                            "context",
                          );
                          // print(rContext);
                          Get.parameters["storeId"] = ordersController.storeId.value;
                          print(Get.parameters["storeId"]);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const StoreHomeMainScreen(),
                          ));
                          // Navigator.of(rContext)
                          //     .popUntil((route) => route.isFirst);
                          // Get.offAll(BottomNavigation());
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
                    ],
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
            Obx(() =>  Visibility(
              visible: ordersController.orderStatusTypeName.value == OrderStatus.returnRequest.statusName,
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
                      AlertStringConstants.cancelReturnRequestAlertText,
                      okay: StringConstants.yesText,cancelText:  StringConstants.noText,
                      okayTap: (){
                        ordersController
                            .apiCancelReturnRequestOrder(context);
                      });

                },
                height: 35,
                border: Border.all(
                  color: AppColors.blacklight,
                  width: 1,
                ),
                textColor: AppColors.red,
                width:
                WidgetConstants.screenWidth *
                    0.28,
                text: StringConstants.canceReturnlText,
                borderRadius: 12,
                fontWeight: FontWeight.w500,
                iconL: false,
                fontSize: 12,
              ),
            ),)

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
                          fontStyle: FontStyle.italic,
                          fontSize: 16),
                    ),
                  ),
                ],
              )
                  : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return height8SizedBox;
                  },
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: ordersController.orderItems.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                          color: AppColors.primarylight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(children: [
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
                              child: CircleAvatar(
                                radius: 22.0,
                                backgroundImage: ordersController
                                    .orderItems[i]
                                    .product
                                    ?.productImages
                                    ?.first
                                    .image
                                    ?.dynamicUrl ==
                                    null ||
                                    ordersController
                                        .orderItems[i]
                                        .product!
                                        .productImages!
                                        .first
                                        .image!
                                        .dynamicUrl!
                                        .isEmpty
                                    ? const AssetImage(
                                    ImageConstants.storeicon)
                                as ImageProvider
                                    : NetworkImage(ordersController
                                    .orderItems[i]
                                    .product
                                    ?.productImages
                                    ?.first
                                    .image
                                    ?.dynamicUrl ??
                                    ""),
                                backgroundColor: Colors.transparent,
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
                                        .product?.productName ??
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
                                                          .blacklight,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14)),
                                              TextSpan(
                                                text:
                                                "\$${ordersController.orderItems[i].product?.productPrice.toString() ?? ""}",
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
                                      ),
                                    ],
                                  ),


                                  height8SizedBox,
                                  Visibility(
                                    visible: ordersController.orderStatusTypeName.value != OrderStatus.returnRequest.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.returnConfirmed.statusName
                                        && ordersController.orderStatusTypeName.value != OrderStatus.returnCancelled.statusName,
                                    child: RatingBar.builder(
                                      initialRating: ordersController
                                          .orderItems[i]
                                          .product != null
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
                                    visible: ordersController.orderStatusTypeName.value == OrderStatus.returnRequest.statusName
                                        || ordersController.orderStatusTypeName.value == OrderStatus.returnConfirmed.statusName
                                        || ordersController.orderStatusTypeName.value == OrderStatus.returnCancelled.statusName,

                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
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
                                        ),
                                      ],
                                    ),
                                  ),


                                  Visibility(
                                    visible: ordersController
                                        .activeStep.value ==
                                        3,
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
                                          0.3,
                                      text: StringConstants.rateNowText,
                                      borderRadius: 12,
                                      fontWeight: FontWeight.w500,
                                      iconL: false,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Visibility(
                                    visible: ordersController
                                        .activeStep.value != 3 &&
                                        ordersController.orderStatusTypeName.value != OrderStatus.returnRequest.statusName
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
                                      WidgetConstants.screenWidth *
                                          0.3,
                                      text: StringConstants
                                          .cancelOrderText,
                                      borderRadius: 12,
                                      fontWeight: FontWeight.w500,
                                      iconL: false,
                                      fontSize: 12,
                                    ),
                                  ),
                                  height6SizedBox,
                                  Visibility(
                                    visible: ordersController.activeStep.value == 3 ,
                                    child: InkWell(
                                      onTap: () {
                                        Utility.showConfirmAlertMessage(
                                            AlertStringConstants.returnOrderAlertText,
                                            okay: StringConstants.yesText,cancelText:  StringConstants.noText,
                                            okayTap: (){
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
                          visible: ordersController.orderStatusTypeName.value == OrderStatus.returnRequest.statusName
                              || ordersController.orderStatusTypeName.value == OrderStatus.returnConfirmed.statusName
                              || ordersController.orderStatusTypeName.value == OrderStatus.returnCancelled.statusName,

                          child: Row(
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
                                          "${StringConstants.returnRequestDateText}: ",
                                          style: TextStyle(
                                              color: AppColors
                                                  .blacklight,
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 12)),
                                      TextSpan(
                                        text:
                                        Utility.formatDateTime(
                                            '${ordersController.orderItems[i].returnOrderItems?.first?.createdAt.toString().substring(0, 10)} ${ordersController.orderItems[i].returnOrderItems?.first?.createdAt.toString().substring(11, 23)}',
                                            firstFormat:
                                            "yyyy-MM-dd HH:mm:ss",
                                            secFormat:
                                            "dd MMM yyyy"),
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
                              ),
                              width50SizedBox,
                              width50SizedBox,
                              width50SizedBox,
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
                        ),
                        Visibility(
                          visible: ordersController.orderStatusTypeName.value == OrderStatus.returnRequest.statusName
                              || ordersController.orderStatusTypeName.value == OrderStatus.returnConfirmed.statusName
                              || ordersController.orderStatusTypeName.value == OrderStatus.returnCancelled.statusName,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // width50SizedBox,
                              Expanded(child:  Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                        "${StringConstants.returnRequestAmountText}: ",
                                        style: TextStyle(
                                            color: AppColors
                                                .blacklight,
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 12)),
                                    TextSpan(
                                      text:
                                      "\$${ordersController.orderItems[i].returnOrderItems?.first.totalTaxReversed?.toStringAsFixed(2) ?? ""}",
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
                              ),),
                              Expanded(child:  Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                        "${StringConstants.lastUpdateDateText}:",
                                        style: TextStyle(
                                            color: AppColors
                                                .blacklight,
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 12)),
                                    TextSpan(
                                      text:
                                      Utility.formatDateTime(
                                          '${ordersController.orderItems[i].returnOrderItems?.first.updatedAt.toString().substring(0, 10)} ${ordersController.orderItems[i].returnOrderItems?.first?.updatedAt.toString().substring(11, 23)}',
                                          firstFormat: "yyyy-MM-dd HH:mm:ss",
                                          secFormat: "dd MMM yyyy"),
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
                              ),)

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
