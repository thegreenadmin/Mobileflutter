import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
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
                      ? const AssetImage("assets/storeicon.png")
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
                              "assets/liked.png",
                              scale: 2.8,
                            )
                                : Image.asset(
                              "assets/favoutline.png",
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
                                    "assets/loc.png",
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
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Obx(
                    () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      height40SizedBox,
                      Image.asset("assets/tick.png"),
                      Text(
                        StringConstants.orderText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                      height20SizedBox,

                      height10SizedBox,
                      Text(
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.description ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.black),
                      ),
                      height20SizedBox,
                      Text(
                        StringConstants.otherDetailText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                      height20SizedBox,

                      height20SizedBox,
                      Text(
                        StringConstants.ratingReviewText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                      height20SizedBox,
                      const Text(
                        "4.4",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                      height20SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          if(storeHomeMainController.quantity.value!=0){
                            storeHomeMainController.apiAddToCart(context);
                          }else{
                            Utility.showToast("Please add at least one item in cart");
                          }

                        },
                        height: 50,
                        text: StringConstants.addToOrderText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 16,
                      ),
                      height80SizedBox,
                    ],
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: WidgetConstants.screenHeight*0.1,
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
                        Text(
                          StringConstants.clickCollectText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 22.0,
                              backgroundColor: Colors.white,
                              child: Image.asset("assets/cart.png",height: 16),),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(8.5),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  child:  Obx(()=>
                                      Text(
                                        storeHomeMainController.cartItems.length.toString()??"0",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),)
                              ),
                            )
                          ],
                        ),
                        width8SizedBox,
                        CustomButton(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primary, AppColors.primary],
                          ),
                          onTap: () {
                            Get.to(const CartScreen());
                          },
                          height: 45,
                          width: 120,
                          text: StringConstants.checkOutText,
                          borderRadius: 12,
                          fontWeight: FontWeight.w500,
                          iconL: false,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
