import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_orders_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/view_pdf_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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

  void contactAlertDialog(
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
            Obx(
              () => storeHomeMainController.isVerifiedStore.value
                  ? Column(
                      children: [
                        height15SizedBox,
                        InkWell(
                          onTap: () {
                            Get.back();
                            storeHomeMainController.apiContactStore();
                          },
                          child: Container(
                            height: 50.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                StringConstants.haveIssueText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : height0SizedBox,
            ),
            height15SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
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
      padding: const EdgeInsets.only(left: 10.0, right: 0, top: 10, bottom: 5),
      child: SizedBox(
        height: 18,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width50SizedBox;
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
                                fontSize: 14,
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
                              onOpened: () async {
                                storeHomeMainController.selectedIndex.value = 3;
                                await storeHomeMainController
                                    .apiGetPreviousOrders();
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
                                    fontSize: 14,
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
    if (storeHomeMainController
        .storeDetailsResponse.value.data!.store!.storePages!
        .any((element) =>
            element.storePageType == "privacy" &&
            element.storePageContent?.dynamicUrl != null &&
            storeHomeMainController.listIndex.value < 4)) {
      storeHomeMainController.listIndex.value =
          storeHomeMainController.listIndex.value + 1;
    }
    if (storeHomeMainController
        .storeDetailsResponse.value.data!.store!.storePages!
        .any((element) =>
            element.storePageType == "terms" &&
            element.storePageContent?.dynamicUrl != null &&
            storeHomeMainController.listIndex.value < 4)) {
      storeHomeMainController.listIndex.value =
          storeHomeMainController.listIndex.value + 1;
    }
    return List.generate(storeHomeMainController.listIndex.value, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousOrdersText,
          child: Column(
            children: [
              SizedBox(
                width: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.previousOrdersText,
                      style: const TextStyle(
                          color: AppColors.black, fontFamily: "", fontSize: 14),
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
            width: 100,
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
        return storeHomeMainController
                .storeDetailsResponse.value.data!.store!.storePages!
                .any((element) =>
                    element.storePageType == "privacy" &&
                    element.storePageContent?.dynamicUrl != null)
            ? PopupMenuItem<String>(
                value: StringConstants.storePolicyText,
                child: SizedBox(
                  width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.storePolicyText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  storeHomeMainController.popUpMenuChange(index);
                },
              )
            : PopupMenuItem<String>(
                value: StringConstants.storePolicyText,
                child: const SizedBox(
                  width: 100,
                ),
              );
      } else {
        return storeHomeMainController
                .storeDetailsResponse.value.data!.store!.storePages!
                .any((element) =>
                    element.storePageType == "terms" &&
                    element.storePageContent?.dynamicUrl != null)
            ? PopupMenuItem<String>(
                value: StringConstants.termsAndConditionsText,
                child: SizedBox(
                  width: 136,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.termsAndConditionsText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  storeHomeMainController.popUpMenuChange(index);
                },
              )
            : PopupMenuItem<String>(
                value: StringConstants.storePolicyText,
                child: const SizedBox(
                  width: 100,
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
                      ? userProductWidget()
                      : storeHomeMainController.selectedIndex.value == 2
                          ? const Expanded(child: StoreFavouriteScreen())
                          : storeHomeMainController.selectedIndex.value == 3
                              ? storeHomeMainController.popUpIndex.value == 0
                                  ? const Expanded(
                                      child: PreviousOrdersScreen())
                                  : storeHomeMainController.popUpIndex.value ==
                                          2
                                      ? Expanded(
                                          child: PdfViewScreen(
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
                                                  .toString()))
                                      : storeHomeMainController.popUpIndex.value ==
                                              3
                                          ? Expanded(
                                              child: PdfViewScreen(
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
                                                      .toString()))
                                          : storeHomeMainController
                                                      .lastSelectedIndex
                                                      .value ==
                                                  1
                                              ? userProductWidget()
                                              : storeHomeMainController
                                                          .lastSelectedIndex
                                                          .value ==
                                                      2
                                                  ? const Expanded(
                                                      child: StoreFavouriteScreen())
                                                  : const Expanded(child: StoreHomeScreen())
                              : const Expanded(child: StoreHomeScreen())
            ],
          ),
        ));
  }

  Widget userProductWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    storeHomeMainController.categoryName.value ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
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
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    itemBuilder: (context) =>
                        productFilterCreateOptionsPopUpList(context)!,
                  ),
                ],
              ),
            ),
            height10SizedBox,
            Obx(
              () => storeHomeMainController.featureProductList.isEmpty
                  ? storeHomeMainController.isLoading.value == true
                      ? height0SizedBox
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                ImageConstants.nodata,
                                scale: 8,
                                color: AppColors.primary,
                              ),
                            ),
                            height4SizedBox,
                            Center(
                              child: Text(
                                StringConstants.noProductFoundText,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : Expanded(
                      child: GridView.builder(
                        itemCount:
                            storeHomeMainController.featureProductList.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              (WidgetConstants.screenHeight * 0.47 +
                                      WidgetConstants.screenHeight * 0.22) /
                                  WidgetConstants.screenHeight,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 10.0,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () async {
                              Get.parameters['productId'] =
                                  storeHomeMainController
                                      .featureProductList[i].productId
                                      .toString();

                              Get.parameters['isFromFav'] = "false";
                              Get.parameters["isFromHome"] = "false";
                              Get.parameters['isFromMenu'] = "true";
                              Get.parameters["isFromOptions"] = "false";
                              await Get.to(() => const AddToOrderScreen(),
                                  id: pageIdApp.value);
                            },
                            child: Card(
                              elevation: 0,
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        CommonWidgets.cachedNetworkImage(
                                          storeHomeMainController
                                                      .featureProductList[i]
                                                      .productImages!
                                                      .isNotEmpty &&
                                                  storeHomeMainController
                                                          .featureProductList[i]
                                                          .productImages
                                                          ?.first
                                                          .image
                                                          ?.dynamicUrl !=
                                                      null
                                              ? storeHomeMainController
                                                      .featureProductList[i]
                                                      .productImages
                                                      ?.first
                                                      .image!
                                                      .dynamicUrl ??
                                                  ""
                                              : "",
                                          fit: BoxFit.fill,
                                          height: WidgetConstants.screenHeight *
                                              0.19,
                                          width:
                                              WidgetConstants.screenWidth * 0.4,
                                        ),
                                        /*  storeHomeMainController
                                                    .featureProductList[i]
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
                                                        .featureProductList[i]
                                                        .productImages
                                                        ?.first
                                                        .image!
                                                        .dynamicUrl ??
                                                    "",
                                                fit: BoxFit.fill,
                                                height: 148,
                                                width: 148,
                                              )
                                            : Image.asset(
                                                ImageConstants.defaultProduct,
                                                fit: BoxFit.fill,
                                                height: 148,
                                                width: 148,
                                              ),*/
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: storeHomeMainController
                                                      .featureProductList[i]
                                                      .isFavouriteProduct ==
                                                  true
                                              ? InkWell(
                                                  onTap: () {
                                                    if (storeHomeMainController
                                                            .isLoading.value ==
                                                        false) {
                                                      storeHomeMainController
                                                          .apiRemoveFavouriteProduct(
                                                              storeHomeMainController
                                                                  .featureProductList[
                                                                      i]
                                                                  .productId);
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    ImageConstants.liked,
                                                    scale: 3,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (storeHomeMainController
                                                            .isLoading.value ==
                                                        false) {
                                                      storeHomeMainController
                                                          .apiCreateFavouriteProduct(
                                                              storeHomeMainController
                                                                  .featureProductList[
                                                                      i]
                                                                  .productId);
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    ImageConstants.fav,
                                                    scale: 3,
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  height5SizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storeHomeMainController
                                                .featureProductList[i]
                                                .productName ??
                                            "",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      storeHomeMainController
                                              .featureProductList[i]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : height4SizedBox,
                                      storeHomeMainController
                                              .featureProductList[i]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : Text(
                                              storeHomeMainController
                                                      .featureProductList[i]
                                                      .description ??
                                                  "",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: AppColors.blacklight,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                      storeHomeMainController
                                              .featureProductList[i]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : height4SizedBox,
                                      Text(
                                        "${StringConstants.unitPriceText}: \$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>>? productFilterCreateOptionsPopUpList(
      BuildContext cont) {
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
                            storeHomeMainController.categoryId.value ?? "0",
                        orderBy: "2",
                        orderType: "2");
                    // Navigator.of(contx).pop();
                    Get.back(id: pageIdApp.value);
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
                categoryId: storeHomeMainController.categoryId.value ?? "0",
                orderBy: "2",
              );
              // Navigator.of(contx).pop();
              Get.back(id: pageIdApp.value);
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
