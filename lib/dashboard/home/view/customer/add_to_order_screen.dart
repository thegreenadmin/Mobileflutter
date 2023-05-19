import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_orders_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_menu_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/dashboard/home/model/nearby_stores_response_model.dart'
    as nearby;

class AddToOrderScreen extends StatefulWidget {
  const AddToOrderScreen({super.key});

  @override
  State<AddToOrderScreen> createState() => _AddToOrderScreenState();
}

class _AddToOrderScreenState extends State<AddToOrderScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(storeHomeMainController.storeId.value != Get.parameters["storeId"] ){
        storeHomeMainController.storeId.value = Get.parameters["storeId"] ?? "";
        storeHomeMainController.getCurrentLocation();
      }

      if (Get.parameters == null
          ? false
          : Get.parameters['isFromHome'] != "false") {

        storeHomeMainController.productId.value =
        Get.parameters["productId"] == null
            ? ""
            : Get.parameters["productId"] ?? "";
      }

      storeHomeMainController.isFromHome.value =
      Get.parameters["isFromHome"] == "true" ? true : false;
      storeHomeMainController.isFromMenu.value =
      Get.parameters["isFromMenu"] == "true" ? true : false;
      storeHomeMainController.isFromFav.value =
      Get.parameters["isFromFav"] == "true" ? true : false;

      print("PRODUCT ID--------${Get.parameters["productId"]}");

      storeHomeMainController.apiGetUserDetailsApi();
      print("is from isFromFav--${storeHomeMainController.isFromFav.value}");
      print("is from isFromMenu--${storeHomeMainController.isFromMenu.value}");
      print("is from homeee--${storeHomeMainController.isFromHome.value}");
      if (storeHomeMainController.isFromMenu.value) {  storeHomeMainController.selectedIndex.value = 1;}
      if (storeHomeMainController.isFromFav.value) {  storeHomeMainController.selectedIndex.value = 2;}


      if (storeHomeMainController.isFromHome.value) {
        // nearby.Store store = nearby.Store();
        // store.storeId = storeHomeMainController.storeId.value;
        // storeHomeMainController.storeAddress.value.store = store;
        // storeHomeMainController.isFavouriteStore.value =
        //     store.isFavouriteStore ?? false;
        storeHomeMainController.selectedIndex.value = 0;
        storeHomeMainController.apiGetCartListApi(Get.context);
        storeHomeMainController.apiGetShopProductDetailApi();
      } else {
        // nearby.Store store = nearby.Store();
        // store.storeId = storeHomeMainController.storeId.value;
        // storeHomeMainController.storeAddress.value.store = store;
        // storeAddress.value = Get.arguments["storeAddress"] ?? {};
        if (storeHomeMainController.isFromMenu.value) {
          storeHomeMainController.selectedIndex.value = 1;
        }else
        if (storeHomeMainController.isFromFav.value) {
          storeHomeMainController.selectedIndex.value = 2;
        }
        // storeHomeMainController.isFavouriteStore.value =
        //     storeHomeMainController.storeAddress.value.store?.isFavouriteStore ?? false;
        // storeHomeMainController.onIndexChange(0);
      }
      storeHomeMainController.apiGetUserWalletBalance();
    });

  }

  RxList horizontalTabList = [
    StringConstants.storeText,
    StringConstants.menuText,
    StringConstants.favoriteText,
    StringConstants.optionsText,
  ].obs;

  void contactAlertDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Text(
              StringConstants.welcomeText,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height10SizedBox,
            Text(
              storeHomeMainController
                      .storeDetailsResponse.value.data!.store!.storeName ??
                  "",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              "${StringConstants.contactUsText} " "at:",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            Text(
              storeHomeMainController
                  .storeDetailsResponse.value.data!.store!.storePhone ??
                  "",
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Text(
              "${StringConstants.emailText} " "at:",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            Text(
              storeHomeMainController
                  .storeDetailsResponse.value.data!.store!.storeEmail ??
                  "",
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height15SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Get.back();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        StringConstants.okayText,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  Padding horizontalTabs() {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 18,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width40SizedBox;
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: horizontalTabList.length,
            itemBuilder: (_, i) {
              return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    storeHomeMainController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        horizontalTabList[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              storeHomeMainController.selectedIndex.value == i
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                          color:
                              storeHomeMainController.selectedIndex.value == i
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                        ),
                      ),
                      i != 3
                          ? height0SizedBox
                          : PopupMenuButton(
                        offset: const Offset(0, 25),
                        shape: const TooltipShape(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: storeHomeMainController
                              .selectedIndex.value ==
                              i
                              ? AppColors.primary
                              : AppColors.blacklight,
                          size: 22,
                        ),
                        onSelected: (String value) async {
                          FocusScope.of(context)
                              .requestFocus(FocusNode());
                        },
                        itemBuilder: (context) =>
                        createOptionsPopUpList(Get.context)!,
                      )
                    ],
                  ));
            }),
      ),
    );
  }

  List<PopupMenuEntry<String>>? createOptionsPopUpList(context) {
    return List.generate(4, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    // Get.back();
                    await storeHomeMainController.apiGetPreviousOrders();
                    SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const PreviousOrdersScreen(),
                    ));
                    // Get.to(const PreviousOrdersScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.previousText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                // Get.back();
                contactAlertDialog(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.contactText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (index == 2) {
        return PopupMenuItem<String>(
          value: StringConstants.storePolicyText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                if (storeHomeMainController.storeDetailsResponse.value.data!
                    .store!.storePages![0].storePageType ==
                    "privacy" ||
                    storeHomeMainController.storeDetailsResponse.value.data!
                        .store!.storePages![1].storePageType ==
                        "privacy") {
                  Navigator.of(context).pop();
                  // Get.back();
                  storeHomeMainController.termsAndPrivacyDailogue(context,
                      content: storeHomeMainController.storeDetailsResponse
                          .value.data!.store!.storePages!.first.storePageContent
                          .toString(),
                      contentType: "privacy");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.storePolicyText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (index == 3) {
        return PopupMenuItem<String>(
          value: StringConstants.termsAndConditionsText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                if (storeHomeMainController.storeDetailsResponse.value.data!
                    .store!.storePages!.first.storePageType ==
                    "terms") {
                  // Get.back();
                  storeHomeMainController.termsAndPrivacyDailogue(context,
                      content: storeHomeMainController.storeDetailsResponse
                          .value.data!.store!.storePages!.first.storePageContent
                          .toString(),
                      contentType: "terms");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.termsAndConditionsText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return null!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserStoreOrderAppBar(),
      body:
      Obx(() =>  Column(
        children: [
          horizontalTabs(),
          const Divider(
            thickness: 1,
          ),
          storeHomeMainController.selectedIndex.value == 0
              ?  Expanded(child:  storeHomeMainController.isFromHome.value == true ?
          stackData() : const StoreHomeScreen())
              : storeHomeMainController.selectedIndex.value == 1
              ?   Expanded(child: storeHomeMainController.isFromMenu.value == true ?
          stackData(): const StoreMenuScreen())
              : storeHomeMainController.selectedIndex.value == 2
              ?   Expanded(child:storeHomeMainController.isFromFav.value == true ?
          stackData() :  const StoreFavouriteScreen())
              : storeHomeMainController.selectedIndex.value == 3
              ?  const Expanded(child: StoreFavouriteScreen())
              :  const Expanded(child: StoreHomeScreen()),
        ],
      ),)

    );
  }

  Widget stackData(){
    return  Stack(
      children: [
        SizedBox(
          height: WidgetConstants.screenHeight * 0.5,
          child: SingleChildScrollView(
              child:
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                            child: storeHomeMainController
                                .productDetailResponse
                                .value
                                .data
                                ?.product
                                ?.productImages ==
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                      scale: 3.2,
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
                                      scale: 3.2,
                                    ),
                                  ),
                                ],
                              ),
                              height4SizedBox,
                              SizedBox(
                                width: 200,
                                child: Text(
                                    storeHomeMainController
                                        .productDetailResponse
                                        .value
                                        .data
                                        ?.product
                                        ?.description ??
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
                                        text:
                                        "${StringConstants.unitPriceText}:",
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
                                      text: storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data
                                          ?.product
                                          ?.offer
                                          ?.offerValue !=
                                          null
                                          ? storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data!
                                          .product!
                                          .offer!
                                          .offerType!
                                          .contains("percentage")
                                          ? ' ${storeHomeMainController.productDetailResponse.value.data?.product?.offer?.offerValue ?? "0"}%'
                                          : ''
                                          ' \$${storeHomeMainController.productDetailResponse.value.data?.product?.offer?.offerValue ?? "0"}'
                                          : storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data !=
                                          null
                                          ? storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data!
                                          .product!
                                          .discountType!
                                          .contains("percentage")
                                          ? ' ${storeHomeMainController.productDetailResponse.value.data?.product?.discountValue ?? "0"}%'
                                          : ' \$${storeHomeMainController.productDetailResponse.value.data?.product?.discountValue ?? "0"}'
                                          : ' 0%',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.black),
                                    ),
                                  ],
                                ),
                              ),
                              height20SizedBox,
                              Row(
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
                              )
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
                        "${storeHomeMainController.productDetailResponse.value.data?.product?.weight.toString() ?? "0"} grams"),
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
                        Text(
                          double.parse(storeHomeMainController
                              .productDetailResponse
                              .value
                              .data
                              ?.product
                              ?.averageRating
                              ?.toString() ??
                              "0.0")
                              .toString(),
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
                                          "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user?.firstName?.toTitleCase() ?? ""} "
                                              "${storeHomeMainController.productDetailResponse.value.data?.product?.productReviews?[i].user?.lastName?.toTitleCase() ?? ""} ",
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
                                              Utility.formatDateTime(
                                                  '${storeHomeMainController.productDetailResponse.value.data!.product!.productReviews![i].createdAt.toString().substring(0, 10)} ${storeHomeMainController.productDetailResponse.value.data!.product!.productReviews![i].createdAt.toString().substring(11, 23)}',
                                                  firstFormat:
                                                  "yyyy-dd-MM HH:mm:ss",
                                                  secFormat: "dd/MM/yyyy"),
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
                    height20SizedBox,
                    storeHomeMainController.productDetailResponse.value.data
                        ?.product !=
                        null &&
                        storeHomeMainController.productDetailResponse.value
                            .data!.product!.cartItems!.isNotEmpty
                        ? height80SizedBox
                        : height15SizedBox,
                  ],
                ),
              ),
          ),
        ),
        Positioned(
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
        )
      ],
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
