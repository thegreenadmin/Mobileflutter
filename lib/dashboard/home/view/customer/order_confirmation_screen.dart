import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final StoreHomeMainController storeHomeMainController =
  Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145.0),
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
                  image: storeHomeMainController.storeAddress.value.store?.image
                      ?.dynamicUrl ==
                      null ||
                      storeHomeMainController.storeAddress.value.store!
                          .image!.dynamicUrl!.isEmpty
                      ? const AssetImage(ImageConstants.storeicon)
                  as ImageProvider
                      : NetworkImage(storeHomeMainController
                      .storeAddress.value.store?.image?.dynamicUrl
                      .toString() ??
                      ""),
                ),
              ),
              child: Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
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
                            storeHomeMainController.storeAddress.value.store
                                ?.isFavouriteStore ==
                                true
                                ? Image.asset(
                              ImageConstants.liked,
                              scale: 2.8,
                            )
                                : Image.asset(
                              ImageConstants.favoutline,
                              scale: 2.8,
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
                              backgroundImage: storeHomeMainController
                                  .storeAddress
                                  .value
                                  .store
                                  ?.logo
                                  ?.dynamicUrl ==
                                  null ||
                                  storeHomeMainController.storeAddress.value
                                      .store!.logo!.dynamicUrl!.isEmpty
                                  ? const AssetImage("assets/storeicon.png")
                              as ImageProvider
                                  : NetworkImage(storeHomeMainController
                                  .storeAddress
                                  .value
                                  .store
                                  ?.logo
                                  ?.dynamicUrl
                                  .toString() ??
                                  ""),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          width10SizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storeHomeMainController
                                    .storeAddress.value.store?.storeName ??
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
                                  Text(
                                      storeHomeMainController.storeAddress.value
                                          .addressLine1 ??
                                          "",
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              height8SizedBox,
                              Text(
                                  storeHomeMainController.storeAddress.value
                                      .store!.storeTimings!.isNotEmpty ? storeHomeMainController
                                      .storeAddress.value.store
                                      ?.storeTimings?.first.is24HoursActive == false
                                      ? "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                      "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                      : StringConstants.storeHoursText
                                      : StringConstants.storeHoursText,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
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
            Image.asset( ImageConstants.tickBorder,scale:2.2),
            height20SizedBox,
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
                  storeHomeMainController.orderStatus.value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.primary),
                ),
              ],
            ),   height10SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.orderStatusText,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16,
                      color: AppColors.black),
                ),
                Text(
                  StringConstants.received,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16,
                      color: AppColors.green),
                ),
              ],
            ),
            height40SizedBox,
            EasyStepper(
              activeStep: storeHomeMainController.activeStep.value,
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
              finishedStepBackgroundColor:AppColors.primary,
              activeStepIconColor: AppColors.primary,
              showLoadingAnimation: false,
              unreachedStepIconColor: AppColors.black,
              unreachedStepTextColor:  AppColors.black,
              steps:List<EasyStep>.generate(storeHomeMainController.stepInd.length, (index) =>
                    EasyStep(
                      customStep: storeHomeMainController.activeStep.value
                          == storeHomeMainController.stepInd[index].id?.toInt() ?
                      Image.asset(ImageConstants.blueTick):
                      Image.asset(ImageConstants.blackTick),
                      title: storeHomeMainController.stepInd[index].name??"",),),
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
