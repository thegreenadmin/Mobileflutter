import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class AddToOrderScreen extends StatefulWidget {
  const AddToOrderScreen({super.key});

  @override
  State<AddToOrderScreen> createState() => _AddToOrderScreenState();
}

class _AddToOrderScreenState extends State<AddToOrderScreen> {
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
                                  ?.dynamicUrl == null ||
                          storeHomeMainController.storeAddress.value.store!
                              .image!.dynamicUrl!.isEmpty
                      ? const AssetImage(ImageConstants.nopicfound) as ImageProvider
                      : NetworkImage(storeHomeMainController
                              .storeAddress.value.store?.image?.dynamicUrl
                              .toString() ?? ""),
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
                                storeHomeMainController.itemsCount.value = 0;
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 24.0,
                              ),
                            ),
                            storeHomeMainController.storeAddress.value.store
                                        ?.isFavouriteStore == true
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
                                  ? const AssetImage(ImageConstants.nopicfound)
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
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Obx(
                () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.orderText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.black),
                  ),
                  height20SizedBox,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: storeHomeMainController.productDetailResponse.value
                                          .data?.product?.productImages == null ||
                                  storeHomeMainController.productDetailResponse
                                      .value.data!.product!.productImages!.isEmpty
                              ? Image.asset(
                            ImageConstants.nopicfound,
                                  fit: BoxFit.fill,
                                  height: 120,
                                )
                              : Image.network(
                                  storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data
                                          ?.product
                                          ?.productImages
                                          ?.first
                                          .image
                                          ?.dynamicUrl
                                          .toString() ??
                                      "",
                                  fit: BoxFit.fill,
                                  height: 120,
                                ),
                        ),
                      ),
                      width10SizedBox,
                      Flexible(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storeHomeMainController.productDetailResponse
                                            .value.data?.product?.productName ??
                                        "",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600)),
                                storeHomeMainController.productDetailResponse.value
                                            .data?.product?.isFavouriteProduct ==
                                        true
                                    ? Image.asset(
                                  ImageConstants.liked,
                                        scale: 2.8,
                                      )
                                    : Image.asset(
                                  ImageConstants.favoutline,
                                        scale: 2.8,
                                      ),
                              ],
                            ),
                            height8SizedBox,
                            SizedBox(
                              width: 200,
                              child: Text(
                                  storeHomeMainController.productDetailResponse
                                          .value.data?.product?.description ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.blacklight,
                                      fontWeight: FontWeight.w400)),
                            ),
                            height20SizedBox,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: StringConstants.unitPriceText,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                  TextSpan(
                                    text:
                                        ' \$${storeHomeMainController.productDetailResponse.value.data?.product?.productPrice ?? ""}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                            height10SizedBox,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: StringConstants.discountText,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                  TextSpan(
                                    text:
                                        ' ${storeHomeMainController.productDetailResponse.value.data?.product?.discountValue ?? ""}%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                            height20SizedBox,
                            Obx(() => Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                            storeHomeMainController.itemsCount.value =
                                            storeHomeMainController
                                                .itemsCount.value != 0
                                                ? storeHomeMainController
                                                .itemsCount.value - 1
                                                : storeHomeMainController
                                                .itemsCount.value;
                                        },
                                        child: Image.asset(
                                          ImageConstants.subtract,
                                          scale: 2.5,
                                        )),
                                    width10SizedBox,
                                    Text(
                                        storeHomeMainController.itemsCount.toString().length < 2
                                          ? storeHomeMainController.itemsCount.toString().padLeft(2,'0')
                                          : storeHomeMainController.itemsCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.black),
                                    ),
                                    width10SizedBox,
                                    InkWell(
                                      onTap: () {
                                          storeHomeMainController.itemsCount.value =
                                          storeHomeMainController.itemsCount.value + 1;
                                          print("storeHomeMainController.quantity add");
                                          print(storeHomeMainController.itemsCount.value.toString());

                                      },
                                      child: Image.asset(
                                        ImageConstants.add,
                                        scale: 2.5,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  height20SizedBox,
                  Text(
                    StringConstants.aboutProductText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.black),
                  ),
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
                  _buildRowOtherDetail(
                      title: StringConstants.categoriesText,
                      textData: storeHomeMainController
                              .productDetailResponse
                              .value
                              .data
                              ?.product
                              ?.productCategories
                              ?.first
                              .category
                              ?.categoryName ??
                          ""),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.quantityUnitText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.quantity.toString()} ${storeHomeMainController.productDetailResponse.value.data?.product?.quantityType?.quantityTypeName.toString()}"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.featuredProductText,
                      textData: storeHomeMainController.productDetailResponse.value
                                  .data?.product?.isFeaturedProduct ==
                              true
                          ? "Yes"
                          : "No"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.lengthText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.length.toString() ?? "0"} feet"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.breadthText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.width.toString() ?? "0"} feet"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.heightText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.height.toString() ?? "0"} feet"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.weightText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.weight.toString() ?? "0"} kg"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.returnAvailableText,
                      textData: storeHomeMainController.productDetailResponse.value
                                  .data?.product?.isProductReturnable ==
                              true
                          ? "Yes"
                          : "No"),
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.daysText,
                      textData:
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.returnDaysCount.toString() ?? "0"} Days"),
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
                      if(storeHomeMainController.itemsCount.value!=0){
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

  Row _buildRowOtherDetail({
    String title = "",
    String textData = "",
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.blacklight),
          ),
          Text(
            textData,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.black),
          ),
        ],
      );
}
