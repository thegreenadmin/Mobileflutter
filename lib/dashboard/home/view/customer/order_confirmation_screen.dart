import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_screen.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

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
      appBar: const UserStoreOrderAppBar(),
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
