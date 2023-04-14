import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
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
      appBar: const UserStoreOrderAppBar(),
      body: Stack(
        children: [
          SizedBox(
            height: WidgetConstants.screenHeight,
            child: SingleChildScrollView(
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
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: storeHomeMainController.productDetailResponse
                                            .value.data?.product?.productImages ==
                                        null ||
                                    storeHomeMainController
                                        .productDetailResponse
                                        .value
                                        .data!
                                        .product!
                                        .productImages!
                                        .isEmpty
                                ? Image.asset(
                                    ImageConstants.nopicfound,
                                    fit: BoxFit.fill,
                                    height: 120,
                                    width: 120,
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
                                      storeHomeMainController
                                              .productDetailResponse
                                              .value
                                              .data
                                              ?.product
                                              ?.productName ??
                                          "",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600)),
                                  storeHomeMainController
                                              .isFavouriteProduct.value ==
                                          true
                                      ? InkWell(
                                          onTap: () {
                                            storeHomeMainController
                                                .apiRemoveFavouriteProduct(
                                                    storeHomeMainController
                                                        .productDetailResponse
                                                        .value
                                                        .data
                                                        ?.product
                                                        ?.productId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.liked,
                                            scale: 2.9,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            storeHomeMainController
                                                .apiCreateFavouriteProduct(
                                                    storeHomeMainController
                                                        .productDetailResponse
                                                        .value
                                                        .data
                                                        ?.product
                                                        ?.productId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.fav,
                                            scale: 2.9,
                                          ),
                                        ),
                                ],
                              ),
                              height4SizedBox,
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
                              height10SizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "${StringConstants.unitPriceText}:",
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
                              height8SizedBox,
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
                                            storeHomeMainController.itemsCount
                                                .value = storeHomeMainController
                                                        .itemsCount.value !=
                                                    0
                                                ? storeHomeMainController
                                                        .itemsCount.value -
                                                    1
                                                : storeHomeMainController
                                                    .itemsCount.value;
                                          },
                                          child: Image.asset(
                                            ImageConstants.subtract,
                                            scale: 2.5,
                                          )),
                                      width10SizedBox,
                                      Text(
                                        storeHomeMainController.itemsCount
                                                    .toString()
                                                    .length <
                                                2
                                            ? storeHomeMainController.itemsCount
                                                .toString()
                                                .padLeft(2, '0')
                                            : storeHomeMainController.itemsCount
                                                .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.black),
                                      ),
                                      width10SizedBox,
                                      InkWell(
                                        onTap: () {
                                          storeHomeMainController.itemsCount
                                              .value = storeHomeMainController
                                                  .itemsCount.value +
                                              1;
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
                        textData: storeHomeMainController.productDetailResponse
                                    .value.data?.product?.isFeaturedProduct ==
                                true
                            ? "Yes"
                            : "No"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.lengthText,
                        textData:
                            "${storeHomeMainController.productDetailResponse.value.data?.product?.length.toString() ?? "0"} Inches"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.breadthText,
                        textData:
                            "${storeHomeMainController.productDetailResponse.value.data?.product?.width.toString() ?? "0"} Inches"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.heightText,
                        textData:
                            "${storeHomeMainController.productDetailResponse.value.data?.product?.height.toString() ?? "0"} Inches"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.weightText,
                        textData:
                            "${storeHomeMainController.productDetailResponse.value.data?.product?.weight.toString() ?? "0"} kg"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.returnAvailableText,
                        textData: storeHomeMainController.productDetailResponse
                                    .value.data?.product?.isProductReturnable ==
                                true
                            ? "Yes"
                            : "No"),
                    height20SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.daysText,
                        textData:
                            "${storeHomeMainController.productDetailResponse.value.data?.product?.returnDaysCount.toString() ?? "0"} Days"),
                    height20SizedBox,
                    Text(
                      StringConstants.ratingReviewText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.black),
                    ),
                    height20SizedBox,
                    Row(
                      children: [
                        const Text(
                          "4.4",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: AppColors.black),
                        ),
                        width8SizedBox,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: 0.0,
                              minRating: 1,
                              direction:  Axis.horizontal,
                              allowHalfRating: false,
                              unratedColor: AppColors.grey,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemSize: 20.0,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                // _selectedIcon ?? Icons.star,
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // ratingValue.value = rating;
                              },
                              updateOnDrag: false,
                            ),
                            height6SizedBox,
                            Text(
                              "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?.length} ${StringConstants.reviewsText}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    height20SizedBox,
                    ListView.separated(
                        separatorBuilder:
                            (BuildContext context, int index) {
                          return height12SizedBox;
                        },
                        itemCount:
                        storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?.length??0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
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
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      ImageConstants.nopicfound,
                                    ),
                                  ),
                                  width10SizedBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                         "${ storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user?.firstName?.toTitleCase() ?? ""} "
                                             "${ storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user?.lastName?.toTitleCase() ?? ""} ",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: AppColors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        height6SizedBox,
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i]
                                                  .rating?.toDouble()??0.0,
                                              minRating: 1,
                                              direction:  Axis.horizontal,
                                              allowHalfRating: false,
                                              unratedColor:  AppColors.grey,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 20.0,
                                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                              },
                                              updateOnDrag: false,
                                            ),
                                            width8SizedBox,
                                            Text(
                                              Utility.formatDateTime('${storeHomeMainController.productDetailResponse.value.data!.product!.productReviews![i].createdAt.toString().substring(0,10)} ${storeHomeMainController.productDetailResponse.value.data!.product!.productReviews![i].createdAt.toString().substring(11,23)}'??"",
                                              firstFormat: "yyyy-dd-MM HH:mm:ss",secFormat: "dd/MM/yyyy"),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.black,
                                                  fontWeight:
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        ),height6SizedBox,
                                        Text(
                                          storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i]
                                              .review ?? "",
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.black,
                                              fontWeight:
                                              FontWeight.w400),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          );
                        }),
                    height20SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        if (storeHomeMainController.itemsCount.value != 0) {
                          storeHomeMainController.apiAddToCart(context);
                        } else {
                          Utility.showToast(
                              AlertStringConstants.pleaseAddAtleastOneItemText);
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
          ),
          Obx(()=> Visibility(
            visible:  storeHomeMainController.productDetailResponse.value.data
                ?.product?.cartItems?.isNotEmpty ??false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: WidgetConstants.screenHeight * 0.1,
                color: AppColors.primaryBackgroundLight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringConstants.payNowText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(const CartScreen());
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 22.0,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(ImageConstants.cart,
                                      height: 16),
                                ),
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
                                      child: Obx(
                                            () => Text(
                                          storeHomeMainController.cartItems.length
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                )
                              ],
                            ),
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
          ),),
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
