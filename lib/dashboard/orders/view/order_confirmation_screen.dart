import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.18),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: ordersController.storeDetailsResponse.value.data!
                                  .store!.image!.dynamicUrl ==
                              null ||
                          ordersController.storeDetailsResponse.value.data!
                              .store!.image!.dynamicUrl!.isEmpty
                      ? const AssetImage(ImageConstants.storeicon)
                          as ImageProvider
                      : NetworkImage(ordersController.storeDetailsResponse.value
                          .data!.store!.image!.dynamicUrl!),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
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
                            ordersController.isFavouriteStore.value == true
                                ? InkWell(
                                    onTap: () {
                                      ordersController.apiRemoveFavouriteStore(
                                          ordersController.storeDetailsResponse
                                              .value.data?.store?.storeId);
                                    },
                                    child: Image.asset(
                                      ImageConstants.liked,
                                      scale: 2.8,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      ordersController.apiCreateFavouriteStore(
                                          ordersController.storeDetailsResponse
                                              .value.data?.store?.storeId);
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
                                              .value
                                              .data!
                                              .store!
                                              .logo!
                                              .dynamicUrl ==
                                          null ||
                                      ordersController
                                          .storeDetailsResponse
                                          .value
                                          .data!
                                          .store!
                                          .logo!
                                          .dynamicUrl!
                                          .isEmpty
                                  ? const AssetImage(ImageConstants.storeicon)
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ordersController.storeDetailsResponse.value
                                        .data!.store!.storeName ??
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
                                    width: WidgetConstants.screenWidth * 0.6,
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
                                                : StringConstants.storeHoursText
                                            : StringConstants.storeHoursText,
                                        style: const TextStyle(
                                            overflow: TextOverflow.visible,
                                            color: AppColors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    width8SizedBox,
                                    ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return width8SizedBox;
                                        },
                                        shrinkWrap: true,
                                        // physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
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
                                            backgroundColor: AppColors.primary,
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
                                                    ImageConstants.instore,
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
                                                        ImageConstants.delivery,
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
                                    width8SizedBox,
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
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height40SizedBox,
            Image.asset(ImageConstants.tickBorder, scale: 1.2),
            height8SizedBox,
            Text(
              StringConstants.orderConfirmationText,
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
            height20SizedBox,
            const Divider(
              height: 20,
              color: AppColors.grey,
            ),
            height12SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.ordersConfirmationNumberText,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.black),
                ),
                Text(
                  ordersController.orderStatus.value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.primary),
                ),
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
                Text(
                  StringConstants.received,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.green),
                ),
              ],
            ),
            height10SizedBox,
            const Divider(
              height: 20,
              color: AppColors.grey,
            ),
            height30SizedBox,
            EasyStepper(
              activeStep: ordersController.activeStep.value,
              lineLength: 55,
              stepShape: StepShape.circle,
              borderThickness: 0,
              padding: 0,
              stepRadius: 22,
              lineColor: AppColors.grey,
              lineType: LineType.normal,
              activeStepBorderType: BorderType.normal,
              unreachedStepBorderType: BorderType.normal,
              finishedStepBorderColor: AppColors.primary,
              finishedStepTextColor: AppColors.primary,
              finishedStepBackgroundColor: AppColors.primary,
              activeStepIconColor: AppColors.primary,
              showLoadingAnimation: false,
              unreachedStepIconColor: AppColors.black,
              unreachedStepTextColor: AppColors.black,
              steps: List<EasyStep>.generate(
                ordersController.stepInd.length,
                (index) => EasyStep(
                  customStep: ordersController.activeStep.value ==
                          ordersController.stepInd[index].id?.toInt()
                      ? Image.asset(ImageConstants.blueTick)
                      : Image.asset(ImageConstants.blackTick),
                  title: ordersController.stepInd[index].name ?? "",
                ),
              ),
              onStepReached: (index) {},
            ),
            height40SizedBox,
            CustomButton(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primary],
              ),
              onTap: () {
                Get.offAll(BottomNavigation());
              },
              height: 50,
              width: WidgetConstants.screenWidth * 0.5,
              text: StringConstants.continueShoppingText,
              borderRadius: 12,
              fontWeight: FontWeight.w500,
              iconL: false,
              fontSize: 16,
            ),
            height30SizedBox,
          ],
        ),
      ),
    );
  }
}
