import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_orders_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_menu_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/view_pdf_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';
import 'package:thegreenmall/utils/utility.dart';

class UserProductListScreen extends StatefulWidget {
  const UserProductListScreen({super.key});

  @override
  State<UserProductListScreen> createState() => _UserProductListScreenState();
}

class _UserProductListScreenState extends State<UserProductListScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  RxList horizontalTabList = [
    StringConstants.storeText,
    StringConstants.menuText,
    StringConstants.favoriteText,
    StringConstants.optionsText,
  ].obs;
/*
  @override
  void initState() {
    super.initState();
    if (Get.parameters["isFromHome"] == null ? false : Get.parameters['isFromHome'] != "false") {
      storeHomeMainController.isFromHome.value = Get.parameters["isFromHome"]=="true"?true:false;

      storeHomeMainController.productId.value =
      Get.parameters["productId"] == null ? "" : Get.parameters["productId"] ?? "";
    }
    storeHomeMainController.storeId.value =
    Get.parameters["storeId"] == null ? "" : Get.parameters["storeId"] ?? "";
    storeHomeMainController.apiGetUserDetailsApi();
    if (storeHomeMainController.isFromHome.value) {
      nearby.Store store = nearby.Store();
      store.storeId = storeHomeMainController.storeId.value;
      storeHomeMainController.storeAddress.value.store = store;
      storeHomeMainController.isFavouriteStore.value = store.isFavouriteStore ?? false;
      storeHomeMainController.selectedIndex.value = 0;
      storeHomeMainController.apiGetStoreDetailsApi();
      storeHomeMainController.apiGetCartListApi(context);
      storeHomeMainController.setupScrollController(Get.context);
      storeHomeMainController.apiGetShopProductDetailApi();
    } else {
      nearby.Store store = nearby.Store();
      store.storeId =storeHomeMainController.storeId.value;
      storeHomeMainController.storeAddress.value.store = store;
      storeHomeMainController.isFavouriteStore.value = store.isFavouriteStore ?? false;
      // storeAddress.value = Get.arguments["storeAddress"] ?? {};
      // isFavouriteStore.value =
      //     storeAddress.value.store?.isFavouriteStore ?? false;
      storeHomeMainController.setupScrollController(Get.context);
      storeHomeMainController.apiGetStoreDetailsApi();
      storeHomeMainController.onIndexChange(0);
    }
    storeHomeMainController.apiGetUserWalletBalance();
  }*/

  void contactAlertDailogue(
    context,
  ) {
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
            Text(
              "${StringConstants.emailText} " "at:",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            SelectableText(
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
                              onOpened: () {
                                storeHomeMainController.selectedIndex.value = 3;
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
          value: StringConstants.previousText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    Get.back( );
                                  // Navigator.of(ctx).pop();
                    // Get.back();
                    await storeHomeMainController.apiGetPreviousOrders();
                    // SharedPreferenceStorage.setData("context", ctx);
                    // Navigator.of(ctx).push(MaterialPageRoute(
                    //   builder: (_) => const PreviousOrdersScreen(),
                    // ));
                    await Get.to(const PreviousOrdersScreen(),
                        id:storeHomeMainController.pageId.value);
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
      } else if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back( );
                                  // Navigator.of(ctx).pop();
                // Get.back();
                contactAlertDailogue(ctx);
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
      } else if (index == 2) {
        return PopupMenuItem<String>(
          value: StringConstants.storePolicyText,
          child: SizedBox(
            width: 150,
            child: GestureDetector(
              onTap: () async{
                Get.back( );
                                  // Navigator.of(ctx).pop();
                if (storeHomeMainController.storeDetailsResponse.value.data!
                    .store!.storePages!.isEmpty) {
                  Utility.showToast(StringConstants.noPrivacyFoundText);
                } else {
                  if (storeHomeMainController.storeDetailsResponse.value.data!
                              .store!.storePages![0].storePageType ==
                          "privacy" ||
                      storeHomeMainController.storeDetailsResponse.value.data!
                              .store!.storePages![1].storePageType ==
                          "privacy") {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => PdfViewScreen(
                    //         isShowPrivacy: true,
                    //         url: storeHomeMainController
                    //             .storeDetailsResponse
                    //             .value
                    //             .data!
                    //             .store!
                    //             .storePages!
                    //             .first
                    //             .storePageContent!
                    //             .dynamicUrl
                    //             .toString())));
                    await Get.to(PdfViewScreen(
                        isShowPrivacy: true,
                        url: storeHomeMainController
                            .storeDetailsResponse
                            .value
                            .data!
                            .store!
                            .storePages!
                            .first
                            .storePageContent!
                            .dynamicUrl
                            .toString()),
                        id:storeHomeMainController.pageId.value);

                  }
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
      } else {
        return PopupMenuItem<String>(
          value: StringConstants.termsAndConditionsText,
          child: SizedBox(
            width: 150,
            child: GestureDetector(
              onTap: () async{
                Get.back( );
                                  // Navigator.of(ctx).pop();
                if (storeHomeMainController.storeDetailsResponse.value.data!
                    .store!.storePages!.isEmpty) {
                  Utility.showToast(StringConstants.noTermsFoundText);
                } else {
                  if (storeHomeMainController.storeDetailsResponse.value.data!
                              .store!.storePages![0].storePageType ==
                          "terms" ||
                      storeHomeMainController.storeDetailsResponse.value.data!
                              .store!.storePages![1].storePageType ==
                          "terms") {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => PdfViewScreen(
                    //         isShowPrivacy: false,
                    //         url: storeHomeMainController
                    //             .storeDetailsResponse
                    //             .value
                    //             .data!
                    //             .store!
                    //             .storePages!
                    //             .first
                    //             .storePageContent!
                    //             .dynamicUrl
                    //             .toString())));
                    await Get.to(PdfViewScreen(
                        isShowPrivacy: false,
                        url: storeHomeMainController
                            .storeDetailsResponse
                            .value
                            .data!
                            .store!
                            .storePages!
                            .first
                            .storePageContent!
                            .dynamicUrl
                            .toString()),
                        id:storeHomeMainController.pageId.value);

                  }
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
                  ? const Expanded(child: StoreHomeScreen())
                  : storeHomeMainController.selectedIndex.value == 1
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      storeHomeMainController
                                              .category.value.categoryName ??
                                          "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: AppColors.black),
                                    ),
                                    PopupMenuButton(
                                      offset: const Offset(0, 25),
                                      shape: const TooltipShape(),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Image.asset(
                                        ImageConstants.productFilter,
                                        scale: 2.5,
                                      ),
                                      onSelected: (String value) async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      itemBuilder: (context) =>
                                          productFilterCreateOptionsPopUpList(
                                              context)!,
                                    ),
                                  ],
                                ),
                                height20SizedBox,
                                Obx(
                                  () => storeHomeMainController
                                          .featureProductList.isEmpty
                                      ? storeHomeMainController
                                                  .isLoading.value ==
                                              true
                                          ? height0SizedBox
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Image.asset(
                                                    ImageConstants.nopicfound,
                                                    scale: 8,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                height4SizedBox,
                                                Center(
                                                  child: Text(
                                                    StringConstants
                                                        .noProductFoundText,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            )
                                      : Expanded(
                                          child: GridView.builder(
                                            itemCount: storeHomeMainController
                                                .featureProductList.length,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: (WidgetConstants
                                                          .screenWidth +
                                                      120) /
                                                  WidgetConstants.screenHeight,
                                              mainAxisSpacing: 0.0,
                                              crossAxisSpacing: 0.0,
                                              crossAxisCount: 2,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return InkWell(
                                                onTap: () async {
                                                  storeHomeMainController
                                                          .productId.value =
                                                      storeHomeMainController
                                                          .featureProductList[i]
                                                          .productId
                                                          .toString();
                                                  await storeHomeMainController
                                                      .apiGetShopProductDetailApi();
                                                  await storeHomeMainController
                                                      .apiGetCartListApi();
                                                  // SharedPreferenceStorage
                                                  //     .setData(
                                                  //         "context", context);
                                                  Get.parameters['isFromFav'] =
                                                      "false";
                                                  Get.parameters["isFromHome"] =
                                                      "false";
                                                  Get.parameters['isFromMenu'] =
                                                      "true";
                                                  // Navigator.of(context)
                                                  //     .push(MaterialPageRoute(
                                                  //   builder: (_) =>
                                                  //       const AddToOrderScreen(),
                                                  // ));
                                                  await Get.to(const AddToOrderScreen(),
                                                      id:storeHomeMainController.pageId.value);
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Card(
                                                      shape:
                                                          BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      elevation: 0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [
                                                            storeHomeMainController
                                                                        .featureProductList[
                                                                            i]
                                                                        .productImages!
                                                                        .isNotEmpty &&
                                                                    storeHomeMainController
                                                                            .featureProductList[i]
                                                                            .productImages
                                                                            ?.first
                                                                            .image
                                                                            ?.dynamicUrl !=
                                                                        null
                                                                ? Image.network(
                                                                    storeHomeMainController
                                                                        .featureProductList[
                                                                            i]
                                                                        .productImages
                                                                        ?.first
                                                                        .image
                                                                        ?.dynamicUrl,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 148,
                                                                    width: 148,
                                                                  )
                                                                : Image.asset(
                                                                    ImageConstants
                                                                        .nopicfound,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 148,
                                                                    width: 148,
                                                                  ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: storeHomeMainController
                                                                          .featureProductList[
                                                                              i]
                                                                          .isFavouriteProduct ==
                                                                      true
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        storeHomeMainController.apiRemoveFavouriteProduct(storeHomeMainController
                                                                            .featureProductList[i]
                                                                            .productId);
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        ImageConstants
                                                                            .liked,
                                                                        scale:
                                                                            3,
                                                                      ),
                                                                    )
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        storeHomeMainController.apiCreateFavouriteProduct(storeHomeMainController
                                                                            .featureProductList[i]
                                                                            .productId);
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        ImageConstants
                                                                            .fav,
                                                                        scale:
                                                                            3,
                                                                      ),
                                                                    ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    height5SizedBox,
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            storeHomeMainController
                                                                    .featureProductList[
                                                                        i]
                                                                    .productName ??
                                                                "",
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          storeHomeMainController
                                                                  .featureProductList[
                                                                      i]
                                                                  .description!
                                                                  .isEmpty
                                                              ? height0SizedBox
                                                              : height4SizedBox,
                                                          storeHomeMainController
                                                                  .featureProductList[
                                                                      i]
                                                                  .description!
                                                                  .isEmpty
                                                              ? height0SizedBox
                                                              : Text(
                                                                  storeHomeMainController
                                                                          .featureProductList[
                                                                              i]
                                                                          .description ??
                                                                      "",
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      color: AppColors
                                                                          .blacklight,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                          storeHomeMainController
                                                                  .featureProductList[
                                                                      i]
                                                                  .description!
                                                                  .isEmpty
                                                              ? height0SizedBox
                                                              : height4SizedBox,
                                                          Text(
                                                            "Unit price: \$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : storeHomeMainController.selectedIndex.value == 2
                          ? const Expanded(child: StoreFavouriteScreen())
                          : storeHomeMainController.selectedIndex.value == 3
                              ? const Expanded(child: StoreFavouriteScreen())
                              : const Expanded(child: StoreHomeScreen()),
            ],
          ),
        ));
  }

  List<PopupMenuEntry<String>>? productFilterCreateOptionsPopUpList(
      BuildContext contx) {
    return List.generate(2, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.lowToHighText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    await storeHomeMainController.apiFeatureProductListApi(
                        categoryId:
                            storeHomeMainController.category.value.categoryId ??
                                "0",
                        orderBy: "2",
                        orderType: "2");
                    // Navigator.of(contx).pop();
                    Get.back(id:storeHomeMainController.pageId.value);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${StringConstants.priceText} ${StringConstants.lowToHighText.toLowerCase()}",
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return PopupMenuItem<String>(
        value: StringConstants.highToLowText,
        child: SizedBox(
          width: 130,
          child: GestureDetector(
            onTap: () async {
              await storeHomeMainController.apiFeatureProductListApi(
                categoryId:
                    storeHomeMainController.category.value.categoryId ?? "0",
                orderBy: "2",
              );
              // Navigator.of(contx).pop();
              Get.back(id:storeHomeMainController.pageId.value);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${StringConstants.priceText} ${StringConstants.highToLowText.toLowerCase()}",
                  style: const TextStyle(
                      color: AppColors.black, fontFamily: "", fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
