import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_orders_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_menu_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/view_pdf_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';
import 'package:thegreenmall/utils/utility.dart';
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

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storeHomeMainController.storeId.value != Get.parameters["storeId"]) {
        storeHomeMainController.storeId.value = Get.parameters["storeId"] ?? "";
        storeHomeMainController.getCurrentLocation();
      }
      storeHomeMainController.productId.value = Get.parameters["productId"] ?? "";
      storeHomeMainController.isFromHome.value = Get.parameters["isFromHome"] == "true" ? true : false;
      storeHomeMainController.isFromMenu.value = Get.parameters["isFromMenu"] == "true" ? true : false;
      storeHomeMainController.isFromFav.value = Get.parameters["isFromFav"] == "true" ? true : false;

      storeHomeMainController.apiGetUserDetailsApi();
      if (storeHomeMainController.isFromMenu.value) {
        storeHomeMainController.selectedIndex.value = 1;
        storeHomeMainController.lastSelectedIndex.value = 1;
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
      storeHomeMainController.apiGetCartListApi();
      storeHomeMainController.apiGetShopProductDetailApi();
      storeHomeMainController.apiGetUserWalletBalance();
      storeHomeMainController.apiActiveCartApi();
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
      barrierDismissible: true,
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
            SelectableText(
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
            SelectableText(
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
            InkWell(
              onTap: () {
                storeHomeMainController.apiContactStore(context);
              },
              child: Container(
                height: 50.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    "Have issue/question?",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            height15SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                                  // Navigator.of(context).pop();
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
                        StringConstants.closeText,
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
      padding: const EdgeInsets.only(left: 10.0, right: 0, top: 10, bottom: 10),
      child: SizedBox(
        height: 18,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width38SizedBox;
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
                      i != 3
                          ? Text(
                              horizontalTabList[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: storeHomeMainController
                                            .selectedIndex.value ==
                                        i
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: storeHomeMainController
                                            .selectedIndex.value ==
                                        i
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                              ),
                            )
                          : PopupMenuButton(
                              onOpened: () async{
                                storeHomeMainController.selectedIndex.value = 3;
                                await storeHomeMainController.apiGetPreviousOrders();
                              },
                              offset: const Offset(0, 25),
                              shape: const TooltipShape(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onSelected: (String value) async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              itemBuilder: (context) =>
                                  createOptionsPopUpList(context)!,
                              child: Row(children: [
                                Text(
                                  horizontalTabList[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: storeHomeMainController
                                                .selectedIndex.value ==
                                            i
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: storeHomeMainController
                                                .selectedIndex.value ==
                                            i
                                        ? AppColors.primary
                                        : AppColors.blacklight,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: storeHomeMainController
                                              .selectedIndex.value ==
                                          i
                                      ? AppColors.primary
                                      : AppColors.blacklight,
                                  size: 24,
                                )
                              ]),
                            )
                    ],
                  ));
            }),
      ),
    );
  }

  List<PopupMenuEntry<String>>? createOptionsPopUpList(ctx) {
    return List.generate(4, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousOrdersText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
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
            ],
          ),
          onTap: () async {
            storeHomeMainController.popUpMenuChange(index);
          },
        );
      } else if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
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
          onTap: () {
            contactAlertDialog(ctx);
          },
        );
      } else if (index == 2) {
        return PopupMenuItem<String>(
          value: StringConstants.storePolicyText,
          child: SizedBox(
            width: 150,
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
          onTap: () {
            storeHomeMainController.popUpMenuChange(index);
          },
        );
      } else {
        return PopupMenuItem<String>(
          value: StringConstants.termsAndConditionsText,
          child: SizedBox(
            width: 150,
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
          onTap: () {
            storeHomeMainController.popUpMenuChange(index);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.25),
            child: const UserStoreOrderAppBar()),
        body: Obx(
          () => Column(
            children: [
              horizontalTabs(),
              const Divider(
                thickness: 1,
              ),
              storeHomeMainController.selectedIndex.value == 0
                  ? Expanded(
                      child: storeHomeMainController.isFromHome.value == true
                          ? stackData()
                          : const StoreHomeScreen())
                  : storeHomeMainController.selectedIndex.value == 1
                      ? Expanded(
                          child:
                              storeHomeMainController.isFromMenu.value == true
                                  ? stackData()
                                  : const StoreMenuScreen())
                      : storeHomeMainController.selectedIndex.value == 2
                          ? Expanded(
                              child: storeHomeMainController.isFromFav.value ==
                                      true
                                  ? stackData()
                                  : const StoreFavouriteScreen())
                          : storeHomeMainController.selectedIndex.value == 3
                            ? storeHomeMainController.popUpIndex.value == 0
                            ? const Expanded(child: PreviousOrdersScreen())
                            : storeHomeMainController.popUpIndex.value == 2
                            ? Expanded(child: PdfViewScreen(
                            isShowPrivacy: true,
                            url: storeHomeMainController.storeDetailsResponse.value
                                .data!.store!.storePages!
                                .first.storePageContent!.dynamicUrl.toString()))
                            : storeHomeMainController.popUpIndex.value == 3
                            ? Expanded(child: PdfViewScreen(
                            isShowPrivacy: false,
                            url: storeHomeMainController
                                .storeDetailsResponse.value
                                .data!.store!.storePages!.first
                                .storePageContent!.dynamicUrl.toString()))
                            : storeHomeMainController.lastSelectedIndex.value == 1
                              ? Expanded(
                                  child:
                                  storeHomeMainController.isFromMenu.value == true
                                      ? stackData()
                                      : const StoreMenuScreen())
                              : storeHomeMainController.lastSelectedIndex.value == 2
                              ? Expanded(
                                child: storeHomeMainController.isFromFav.value ==
                                    true
                                    ? stackData()
                                    : const StoreFavouriteScreen())
                              : Expanded(
                                child: storeHomeMainController.isFromHome.value == true
                                    ? stackData()
                                    : const StoreHomeScreen())
                            : const Expanded(child: StoreHomeScreen())
            ],
          ),
        ));
  }

  Widget stackData() {
    return Stack(
      children: [
        SizedBox(
          height: WidgetConstants.screenHeight * 0.8,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.orderText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: AppColors.black),
                  ),
                  height15SizedBox,
                  Obx(()=>Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 4,
                        child: storeHomeMainController.productDetailResponse
                            .value.data?.product?.productImages ==
                            null ||
                            storeHomeMainController.productDetailResponse
                                .value.data!.product!.productImages!.isEmpty
                            ? Image.asset(
                          ImageConstants.nopicfound,
                          fit: BoxFit.fill,
                          height: 120,
                          width: 120,
                          color: AppColors.grey.withOpacity(0.4),
                        )
                            : Column(
                          children: [
                            CarouselSlider(
                              items: storeHomeMainController.productIm!
                                  .map((item) => InkWell(
                                onTap: () {},
                                child: Center(
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(6.0),
                                      child: Image.network(
                                          item.image?.dynamicUrl
                                              .toString() ??
                                              "",
                                          fit: BoxFit.fill,
                                          height: WidgetConstants
                                              .screenHeight *
                                              0.6,
                                          width: WidgetConstants
                                              .screenWidth *
                                              0.4),
                                    )),
                              ))
                                  .toList(),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  enlargeStrategy:
                                  CenterPageEnlargeStrategy.scale,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                  aspectRatio: 1.1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                            Obx(() => storeHomeMainController
                                .productDetailResponse
                                .value
                                .data!
                                .product!
                                .productImages!
                                .isEmpty
                                ? height0SizedBox
                                : SizedBox(
                              width:
                              WidgetConstants.screenWidth * 0.4,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: storeHomeMainController
                                      .productIm!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () => _controller
                                          .animateToPage(entry.key),
                                      child: Container(
                                        width: _current == entry.key
                                            ? 25
                                            : 10,
                                        height: 5.0,
                                        margin: const EdgeInsets
                                            .symmetric(
                                            vertical: 8.0,
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(8.0),
                                            shape:
                                            BoxShape.rectangle,
                                            color: _current ==
                                                entry.key
                                                ? AppColors.primary
                                                : AppColors.grey),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ))
                          ],
                        ),

                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   child: storeHomeMainController.productDetailResponse
                        //                   .value.data?.product?.productImages ==
                        //               null ||
                        //           storeHomeMainController
                        //               .productDetailResponse
                        //               .value
                        //               .data!
                        //               .product!
                        //               .productImages!
                        //               .isEmpty
                        //       ? Image.asset(
                        //           ImageConstants.nopicfound,
                        //           fit: BoxFit.fill,
                        //           height: 120,
                        //           width: 120,
                        //         )
                        //       : Image.network(
                        //           storeHomeMainController
                        //                   .productDetailResponse
                        //                   .value
                        //                   .data
                        //                   ?.product
                        //                   ?.productImages
                        //                   ?.first
                        //                   .image
                        //                   ?.dynamicUrl
                        //                   .toString() ??
                        //               "",
                        //           fit: BoxFit.fill,
                        //           height: 120,
                        //         ),
                        // ),
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
                                Expanded(
                                  child: Text(
                                      storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data
                                          ?.product
                                          ?.productName ??
                                          "",
                                      style: const TextStyle(
                                          overflow: TextOverflow.visible,
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600)),
                                ),
                                storeHomeMainController
                                    .isFavouriteProduct.value ==
                                    true
                                    ? InkWell(
                                  onTap: () {
                                    if(storeHomeMainController.isLoading.value == false){
                                      storeHomeMainController
                                          .apiRemoveFavouriteProduct(
                                          storeHomeMainController
                                              .productDetailResponse
                                              .value
                                              .data
                                              ?.product
                                              ?.productId);

                                          }
                                  },
                                  child: Image.asset(
                                    ImageConstants.liked,
                                    scale: 3.2,
                                  ),
                                )
                                    : InkWell(
                                  onTap: () {
                                    if(storeHomeMainController.isLoading.value == false){
                                      storeHomeMainController
                                          .apiCreateFavouriteProduct(
                                          storeHomeMainController
                                              .productDetailResponse
                                              .value
                                              .data
                                              ?.product
                                              ?.productId);

                                          }
                                  },
                                  child: Image.asset(
                                    ImageConstants.fav,
                                    scale: 3.2,
                                  ),
                                ),
                              ],
                            ),
                            storeHomeMainController.productDetailResponse.value
                                .data?.product?.description !=
                                ""
                                ? height0SizedBox
                                : height4SizedBox,
                            storeHomeMainController.productDetailResponse.value
                                .data?.product?.description !=
                                ""
                                ? height0SizedBox
                                : SizedBox(
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
                            storeHomeMainController.productDetailResponse.value
                                .data?.product?.description !=
                                ""
                                ? height0SizedBox
                                : height10SizedBox,
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
                                      text: storeHomeMainController
                                          .productDetailResponse
                                          .value
                                          .data
                                          ?.product
                                          ?.offer
                                          ?.offerValue !=
                                          null
                                          ? "${StringConstants.offersText} ${StringConstants.discountText.toLowerCase()}:"
                                          : "${StringConstants.productText} ${StringConstants.discountText.toLowerCase()}:",
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
                                      storeHomeMainController.itemsCount.value =
                                      storeHomeMainController
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
                                      scale: 2.8,
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
                                    storeHomeMainController.itemsCount.value =
                                        storeHomeMainController
                                            .itemsCount.value +
                                            1;
                                  },
                                  child: Image.asset(
                                    ImageConstants.add,
                                    scale: 2.8,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      storeHomeMainController
                                      .productDetailResponse
                                      .value
                                      .data
                                      ?.product
                                      ?.productContents!
                                      .first
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
                      storeHomeMainController
                                      .productDetailResponse
                                      .value
                                      .data
                                      ?.product
                                      ?.productContents!
                                      .first
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
                      storeHomeMainController
                                      .productDetailResponse
                                      .value
                                      .data
                                      ?.product
                                      ?.productContents!
                                      .first
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
                      storeHomeMainController
                                      .productDetailResponse
                                      .value
                                      .data
                                      ?.product
                                      ?.productContents!
                                      .first
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
                                      ?.productContents!
                                      .first
                                      .paragraph ??
                                  "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.blacklight),
                            ),
                      height20SizedBox,
                      storeHomeMainController.productDetailResponse.value.data
                                      ?.product?.productLinks==null
                          || storeHomeMainController.productDetailResponse.value.data
                                      !.product!.productLinks!.isEmpty || storeHomeMainController.productDetailResponse.value.data
                                      ?.product!.productLinks!.first.link == null || storeHomeMainController
                                  .productDetailResponse.value.data!.product!.productLinks!
                                  .first.link!.isEmpty
                          ? height0SizedBox
                          : Text(
                              StringConstants.additionalLinksToResearchText,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.blacklight),
                            ),
                      storeHomeMainController.productDetailResponse.value.data
                          ?.product?.productLinks==null ||
                          storeHomeMainController.productDetailResponse.value.data
                      !.product!.productLinks!.isEmpty ||
                          storeHomeMainController.productDetailResponse.value.data
                                      ?.product!.productLinks!.first.link ==
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
                          : height8SizedBox,
                      storeHomeMainController.productDetailResponse.value.data
                          ?.product?.productLinks==null ||
                          storeHomeMainController.productDetailResponse.value.data
                      !.product!.productLinks!.isEmpty ||
                          storeHomeMainController.productDetailResponse.value.data
                                      ?.product?.productLinks?.first.link == null ||
                              storeHomeMainController.productDetailResponse.value
                                  .data!.product!.productLinks!.first.link!.isEmpty
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
                                        ?.product?.productLinks?.first
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
                  //height10SizedBox,
                  storeHomeMainController.productDetailResponse.value.data != null
                      ? storeHomeMainController.productDetailResponse.value
                                      .data!.product!.description == null ||
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
                                  ?.product?.description == null ||
                          storeHomeMainController.productDetailResponse.value
                              .data!.product!.description!.isEmpty
                      ? height0SizedBox
                      : Text(
                          storeHomeMainController.productDetailResponse.value
                                  .data?.product?.description ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.blacklight),
                        ),
                  storeHomeMainController.productDetailResponse.value.data
                                  ?.product?.description == null ||
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
                  height20SizedBox,
                  _buildRowOtherDetail(
                      title: StringConstants.categoryNameText,
                      textData: storeHomeMainController.productDetailResponse
                          .value.data?.product
                          ?.productCategories!=null && storeHomeMainController
                          .productDetailResponse.value
                          .data!.product!.productCategories!.isNotEmpty ? storeHomeMainController
                              .productDetailResponse.value.data?.product
                              ?.productCategories?.first.category?.categoryName ??
                          "":"NA"),
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
                          "${storeHomeMainController.productDetailResponse.value.data?.product?.weight.toString() ?? "0"} Ounces"),
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
                      title: StringConstants.returnDaysText,
                      textData: storeHomeMainController.productDetailResponse
                              .value.data?.product?.returnDaysCount
                              .toString() ?? "0"),
                  height20SizedBox,
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
                        double.parse(storeHomeMainController
                                    .productDetailResponse.value.data
                                    ?.product?.averageRating
                                    ?.toString() ?? "0.0")
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
                                    .productDetailResponse.value.data
                                    ?.product?.averageRating
                                    ?.toDouble() ?? 0.0,
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
                              .value.data?.product?.productReviews?.length ?? 0,
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
                                                        .value.data?.product
                                                        ?.productReviews?[i]
                                                        .rating
                                                        ?.toDouble() ?? 0.0,
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
                                                .value.data?.product
                                                ?.productReviews?[i]
                                                .review ?? "",
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
                  storeHomeMainController
                                  .productDetailResponse.value.data?.product !=
                              null &&
                          storeHomeMainController.productDetailResponse.value
                              .data!.product!.cartItems!.isNotEmpty
                      ? height80SizedBox
                      : height15SizedBox,
                  height20SizedBox,
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
              if (int.parse(storeHomeMainController.storeIdValue.toString()) ==
                  0) {
                if (storeHomeMainController.itemsCount.value != 0) {
                  storeHomeMainController.apiAddToCart(context);
                } else {
                  Utility.showAlertMessage(
                      AlertStringConstants.pleaseAddAtleastOneItemText);
                }
              } else {
                if ((int.parse(
                        storeHomeMainController.storeIdValue.toString()) !=
                    int.parse(storeHomeMainController.storeId.toString()))) {
                  storeHomeMainController.discardCartItems(context);
                } else {
                  if (storeHomeMainController.itemsCount.value != 0) {
                    storeHomeMainController.apiAddToCart(context);
                  } else {
                    Utility.showAlertMessage(
                        AlertStringConstants.pleaseAddAtleastOneItemText);
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
