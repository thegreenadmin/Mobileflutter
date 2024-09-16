import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AddToOrderScreen extends StatefulWidget {
  const AddToOrderScreen({super.key});

  @override
  State<AddToOrderScreen> createState() => _AddToOrderScreenState();
}

class _AddToOrderScreenState extends State<AddToOrderScreen> {
  final StoreHomeMainController storeHomeMainController =
  Get.put(StoreHomeMainController());
  final CarouselController _controller = CarouselController();
  int _current = 0;

/*  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeHomeMainController.showLoading.value = false;
      if (storeHomeMainController.storeId.value != Get.parameters["storeId"]) {
        storeHomeMainController.storeId.value = Get.parameters["storeId"] ?? "";
        storeHomeMainController.getCurrentLocation();
      }
      storeHomeMainController.productId.value =
          Get.parameters["productId"] ?? "";
      storeHomeMainController.isFromHome.value =
          Get.parameters["isFromHome"] == "true";
      storeHomeMainController.isFromMenu.value =
          Get.parameters["isFromMenu"] == "true";
      storeHomeMainController.isFromFav.value =
          Get.parameters["isFromFav"] == "true";
      storeHomeMainController.isFromOptions.value =
          Get.parameters["isFromOptions"] == "true";


      storeHomeMainController.apiGetUserDetailsApi();

      */ /*if (storeHomeMainController.isFromMenu.value) {
        storeHomeMainController.selectedIndex.value = 1;
        storeHomeMainController.lastSelectedIndex.value = 1;
        storeHomeMainController.showLoading.value = false;
        storeHomeMainController.onIndexChange(1);
      }
      if (storeHomeMainController.isFromFav.value) {
        storeHomeMainController.selectedIndex.value = 2;
        storeHomeMainController.lastSelectedIndex.value = 2;
        storeHomeMainController.showLoading.value = false;
        storeHomeMainController.onIndexChange(2);
      }

      if (storeHomeMainController.isFromHome.value) {
        storeHomeMainController.selectedIndex.value = 0;
        storeHomeMainController.lastSelectedIndex.value = 0;
        storeHomeMainController.showLoading.value = false;
        storeHomeMainController.onIndexChange(0);
      }
      if (storeHomeMainController.isFromOptions.value) {
        storeHomeMainController.selectedIndex.value = 3;
        storeHomeMainController.lastSelectedIndex.value = 3;
        storeHomeMainController.showLoading.value = false;
        storeHomeMainController.onIndexChange(3);
      }*/ /*

      if (storeHomeMainController.storeId.value != "" &&
          storeHomeMainController.productId.value != "") {
        storeHomeMainController.apiGetShopProductDetailApi();
      }
      storeHomeMainController.apiGetUserWalletBalance();
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return stackData();
  }

  Widget stackData() {
    return Stack(
      children: [
        SizedBox(
          height: WidgetConstants.screenHeight * 0.8,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.orderText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    height15SizedBox,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(flex: 4, child: _buildProductImagesSection()),
                        width10SizedBox,
                        Flexible(flex: 7, child: _buildProductDetailsSection()),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productContents ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productContents!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productContents
                                ?.first
                                .paragraph ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productContents!
                                .first
                                .paragraph!
                                .isEmpty
                            ? height0SizedBox
                            : height20SizedBox,
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productContents ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productContents!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productContents
                                ?.first
                                .paragraph ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productContents!
                                .first
                                .paragraph!
                                .isEmpty
                            ? height0SizedBox
                            : Text(
                          StringConstants.contentsAndStrainsText,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.blacklight),
                        ),
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productContents ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productContents!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productContents
                                ?.first
                                .paragraph ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productContents!
                                .first
                                .paragraph!
                                .isEmpty
                            ? height0SizedBox
                            : height8SizedBox,
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productContents ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productContents!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productContents
                                ?.first
                                .paragraph ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productContents!
                                .first
                                .paragraph!
                                .isEmpty
                            ? height0SizedBox
                            : Text(
                          storeHomeMainController
                              .productDetailResponse
                              .value
                              .data
                              ?.product
                              ?.productContents
                              ?.first
                              .paragraph ??
                              "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.blacklight),
                        ),
                        height20SizedBox,
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productLinks ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productLinks!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product!
                                .productLinks!
                                .first
                                .link ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productLinks!
                                .first
                                .link!
                                .isEmpty
                            ? height0SizedBox
                            : Text(
                          StringConstants.additionalLinksToResearchText,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.blacklight),
                        ),
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productLinks ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productLinks!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product!
                                .productLinks!
                                .first
                                .link ==
                                null &&
                                storeHomeMainController
                                    .productDetailResponse
                                    .value
                                    .data!
                                    .product!
                                    .productLinks!
                                    .first
                                    .link!
                                    .isEmpty
                            ? height0SizedBox
                            : height6SizedBox,
                        storeHomeMainController.productDetailResponse.value.data
                            ?.product?.productLinks ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productLinks!.isEmpty ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productLinks
                                ?.first
                                .link ==
                                null ||
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productLinks!
                                .first
                                .link!
                                .isEmpty
                            ? height0SizedBox
                            : InkWell(
                          onTap: () async {
                            String url = storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productLinks!
                                .first
                                .link! ??
                                "";
                            Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productLinks
                                ?.first
                                .link ??
                                "",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    height10SizedBox,
                    storeHomeMainController.productDetailResponse.value.data !=
                        null
                        ? storeHomeMainController.productDetailResponse.value
                        .data!.product!.description ==
                        null ||
                        storeHomeMainController.productDetailResponse
                            .value.data!.product!.description!.isEmpty
                        ? height0SizedBox
                        : Text(
                      StringConstants.aboutProductText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.black),
                    )
                        : height0SizedBox,
                    height10SizedBox,
                    storeHomeMainController.productDetailResponse.value.data
                        ?.product?.description ==
                        null ||
                        storeHomeMainController.productDetailResponse.value
                            .data!.product!.description!.isEmpty
                        ? height0SizedBox
                        : Text(
                      storeHomeMainController.productDetailResponse.value
                          .data?.product?.description ??
                          "",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.blacklight),
                    ),
                    storeHomeMainController.productDetailResponse.value.data
                        ?.product?.description ==
                        null ||
                        storeHomeMainController.productDetailResponse.value
                            .data!.product!.description!.isEmpty
                        ? height0SizedBox
                        : height20SizedBox,
                    Text(
                      StringConstants.otherDetailsText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    height15SizedBox,
                    _buildRowOtherDetail(
                        title: StringConstants.categoryNameText,
                        textData: storeHomeMainController.productDetailResponse
                            .value.data?.product?.productCategories != null &&
                            storeHomeMainController.productDetailResponse.value.data!.product!.productCategories!.isNotEmpty
                            ? storeHomeMainController
                            .productDetailResponse
                            .value
                            .data
                            ?.product
                            ?.productCategories
                            ?.first
                            .category
                            ?.categoryName ?? "" : "NA"),

                    _buildRowOtherDetail(
                        title: StringConstants.quantityUnitText,
                        textData:
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.quantity.toString() ??
                            ""} ${storeHomeMainController.productDetailResponse.value.data?.product?.quantityType?.quantityTypeName
                            .toString() ?? "NA"}"),

                    _buildRowOtherDetail(
                        title: StringConstants.featuredProductText,
                        textData: storeHomeMainController.productDetailResponse
                            .value.data?.product?.isFeaturedProduct == true
                            ? "Yes" : "No"),

                    _buildRowOtherDetail(
                        title: StringConstants.lengthText,
                        textData:
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.length.toString() ?? "0"} Inches"),

                    _buildRowOtherDetail(
                        title: StringConstants.breadthText,
                        textData:
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.width.toString() ?? "0"} Inches"),

                    _buildRowOtherDetail(
                        title: StringConstants.heightText,
                        textData:
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.height.toString() ?? "0"} Inches"),

                    _buildRowOtherDetail(
                        title: StringConstants.weightText,
                        textData:
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.weight.toString() ?? "0"} Ounces"),

                    _buildRowOtherDetail(
                        title: StringConstants.returnAvailableText,
                        textData: storeHomeMainController.productDetailResponse
                            .value.data?.product?.isProductReturnable ==
                            true
                            ? "Yes"
                            : "No"),
                    Visibility(
                      visible: storeHomeMainController.productDetailResponse.value
                          .data?.product?.isProductReturnable ==
                          true,
                      child: _buildRowOtherDetail(
                          title: StringConstants.returnDaysText,
                          textData: storeHomeMainController
                              .productDetailResponse
                              .value
                              .data
                              ?.product
                              ?.returnDaysCount
                              .toString() ??
                              "0"),
                    ),
                    Text(
                      StringConstants.ratingReviewText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.black),
                    ),
                    height20SizedBox,
                    Row(
                      children: [
                        Text(
                          storeHomeMainController.productDetailResponse.value.data
                              ?.product?.averageRating
                              ?.toStringAsFixed(1) ??
                              "0.0",
                          style: const TextStyle(
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
                              initialRating: storeHomeMainController
                                  .productDetailResponse
                                  .value
                                  .data
                                  ?.product
                                  ?.averageRating
                                  ?.toDouble() ??
                                  0.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              unratedColor: AppColors.grey,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemSize: 20.0,
                              itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
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
                            height6SizedBox,
                            Text(
                              "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?.length ??
                                  "0"} ${StringConstants.reviewsText}",
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
                        separatorBuilder: (BuildContext context, int index) {
                          return height12SizedBox;
                        },
                        itemCount: storeHomeMainController.productDetailResponse
                            .value.data?.product?.productReviews?.length ??
                            0,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      ImageConstants.userAccount,
                                    ),
                                  ),
                                  width10SizedBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user
                                              ?.firstName?.toTitleCase() ?? ""} "
                                              "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user
                                              ?.lastName?.toTitleCase() ?? ""} ",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        height6SizedBox,
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                              storeHomeMainController
                                                  .productDetailResponse
                                                  .value
                                                  .data
                                                  ?.product
                                                  ?.productReviews?[i]
                                                  .rating
                                                  ?.toDouble() ??
                                                  0.0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              unratedColor: AppColors.grey,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 20.0,
                                              itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                              itemBuilder: (context, _) =>
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                              updateOnDrag: false,
                                            ),
                                            width8SizedBox,
                                            Text(
                                              DateFormat('MM/dd/yyyy').format(
                                                  DateTime.parse(
                                                      storeHomeMainController
                                                          .productDetailResponse
                                                          .value
                                                          .data!
                                                          .product!
                                                          .productReviews![i]
                                                          .createdAt
                                                          .toString())),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        height6SizedBox,
                                        Text(
                                          storeHomeMainController
                                              .productDetailResponse
                                              .value
                                              .data
                                              ?.product
                                              ?.productReviews?[i]
                                              .review ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          );
                        }),
                    height30SizedBox,
                    storeHomeMainController
                        .productDetailResponse.value.data?.product !=
                        null &&
                        storeHomeMainController.productDetailResponse.value
                            .data!.product!.cartItems!.isNotEmpty
                        ? height80SizedBox
                        : height15SizedBox,
                    height20SizedBox,
                  ],
                );
              }),
            ),
          ),
        ),

        Obx(() =>
        storeHomeMainController.isVerifiedStore.value
            ? Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: CustomButton(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary],
            ),
            onTap: () {
              if (storeHomeMainController.isVerifiedStore.value) {
                Get.parameters['isFromAddProduct'] = "yes";
                if (int.parse(storeHomeMainController.storeIdValue
                    .toString()) ==
                    0) {
                  if (storeHomeMainController.itemsCount.value != 0) {
                    storeHomeMainController.apiAddToCart(context);
                  } else {
                    Utility.showAlertMessage(
                        AlertStringConstants.pleaseAddAtLeastOneItemText);
                  }
                } else {
                  if ((int.parse(storeHomeMainController.storeIdValue
                      .toString()) !=
                      int.parse(
                          storeHomeMainController.storeId.toString()))) {
                    storeHomeMainController.discardCartItems(context);
                  } else {
                    if (storeHomeMainController.itemsCount.value != 0) {
                      storeHomeMainController.apiAddToCart(context);
                    } else {
                      Utility.showAlertMessage(AlertStringConstants
                          .pleaseAddAtLeastOneItemText);
                    }
                  }
                }
              }
            },
            height: 50,
            text: StringConstants.addToOrderText,
            borderRadius: 12,
            fontWeight: FontWeight.w500,
            iconL: false,
            fontSize: 16,
          ),
        )
            : height0SizedBox)
      ],
    );
  }

  Column _buildRowOtherDetail({
    String title = "",
    String textData = "",
  }) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.blacklight),
              ),
              Text(
                textData,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.black),
              ),
            ],
          ), height10SizedBox
        ],
      );


  Widget _buildProductImagesSection() {
    var productImages = storeHomeMainController
        .productDetailResponse.value.data?.product?.productImages;

    if (productImages == null || productImages.isEmpty) {
      return Image.asset(
        ImageConstants.defaultProduct,
        fit: BoxFit.fill,
        height: 120,
        width: 120,
      );
    }

    return Column(
      children: [
        CarouselSlider(
          items: storeHomeMainController.productIm!
              .map((item) =>
              InkWell(
                onTap: () {},
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CommonWidgets.cachedNetworkImage(
                      item.image?.dynamicUrl.toString() ?? "",
                      height: WidgetConstants.screenHeight * 0.6,
                      width: WidgetConstants.screenWidth * 0.4,
                    ),
                  ),
                ),
              ))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            autoPlayCurve: Curves.fastOutSlowIn,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            aspectRatio: 1.1,
            onPageChanged: (index, reason) {
              _current = index;
            },
          ),
        ),
        Obx(() {
          var productImages = storeHomeMainController
              .productDetailResponse.value.data?.product?.productImages;
          if (productImages == null || productImages.isEmpty) {
            return const SizedBox(height: 0);
          }
          return _buildCarouselIndicator();
        }),
      ],
    );
  }

  Widget _buildCarouselIndicator() {
    return SizedBox(
      width: WidgetConstants.screenWidth * 0.4,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: storeHomeMainController.productIm!.asMap().entries.map(
                (entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 25 : 10,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                    color: _current == entry.key ? AppColors.primary : AppColors.grey,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildProductDetailsSection() {
    var product = storeHomeMainController.productDetailResponse.value.data?.product;
    if (product == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildProductTitleAndFavorite(),
        if (product.description!.isNotEmpty) ...[
          height4SizedBox,
          SizedBox(width: 200,
              child: Text(
                  product.description ?? "", style: TextStyle(fontSize: 14, color: AppColors.blacklight, fontWeight: FontWeight.w400))),
          height10SizedBox,
        ],
        height4SizedBox,
        _buildProductPrice(),
        height4SizedBox,
        _buildProductDiscount(),
        height20SizedBox,
        _buildProductQuantitySelector(),
      ],
    );
  }

  Widget _buildProductTitleAndFavorite() {
    var product = storeHomeMainController.productDetailResponse.value.data?.product;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            product?.productName ?? "",
            style: const TextStyle(
              overflow: TextOverflow.visible,
              fontSize: 18,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            var isFavorite = storeHomeMainController.isFavouriteProduct.value;
            storeHomeMainController.isFavouriteProduct.value = !isFavorite;
            if (!storeHomeMainController.isLoading.value) {
              if (isFavorite) {
                storeHomeMainController.apiRemoveFavouriteProduct(product?.productId);
              } else {
                storeHomeMainController.apiCreateFavouriteProduct(product?.productId);
              }
            }
          },
          child: Image.asset(
            storeHomeMainController.isFavouriteProduct.value
                ? ImageConstants.liked
                : ImageConstants.fav,
            scale: 3.2,
          ),
        ),
      ],
    );
  }

  Widget _buildProductPrice() {
    var product = storeHomeMainController.productDetailResponse.value.data?.product;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "${StringConstants.unitPriceText}:",
            style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14),
          ),
          TextSpan(
            text: ' \$${product?.productPrice ?? ""}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDiscount() {
    var product = storeHomeMainController.productDetailResponse.value.data?.product;
    var discountText = product?.offer?.offerValue != null
        ? "${StringConstants.offersText} ${StringConstants.discountText.toLowerCase()}:"
        : "${StringConstants.productText} ${StringConstants.discountText.toLowerCase()}:";
    var discountValue = product?.offer?.offerValue != null
        ? product!.offer!.offerType!.contains("percentage")
        ? ' ${product.offer!.offerValue}%'
        : ' \$${product.offer!.offerValue}'
        : product?.discountType?.contains("percentage") ?? false
        ? ' ${product!.discountValue}%'
        : ' \$${product?.discountValue ?? "0"}';
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: discountText, style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14)),
          TextSpan(text: discountValue, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.black)),
        ],
      ),
    );
  }

  Widget _buildProductQuantitySelector() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            storeHomeMainController.itemsCount.value = storeHomeMainController.itemsCount.value != 0
                ? storeHomeMainController.itemsCount.value - 1
                : 0;
          },
          child: Image.asset(ImageConstants.subtract, scale: 2.8),
        ),
        width10SizedBox,
        Text(
          storeHomeMainController.itemsCount.toString().padLeft(2, '0'),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.black),
        ),
        width10SizedBox,
        InkWell(
          onTap: () {
            storeHomeMainController.itemsCount.value++;
          },
          child: Image.asset(ImageConstants.add, scale: 2.8),
        ),
      ],
    );
  }
}
