import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/dashboard/home/view/customer/previous_orders_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_menu_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/view_pdf_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class StoreHomeMainScreen extends StatefulWidget {
  const StoreHomeMainScreen({super.key});

  @override
  State<StoreHomeMainScreen> createState() => _StoreHomeMainScreenState();
}

class _StoreHomeMainScreenState extends State<StoreHomeMainScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  RxList horizontalTabList = [
    StringConstants.storeText,
    StringConstants.menuText,
    StringConstants.favoriteText,
    StringConstants.optionsText,
  ].obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeHomeMainController.productId.value =
          Get.parameters["productId"] ?? "";
      storeHomeMainController.isFromHome.value =
          Get.parameters["isFromHome"] == "true" ? true : false;
      storeHomeMainController.isFromFav.value =
          Get.parameters["isFromFav"] == "true" ? true : false;
      storeHomeMainController.isFromMenu.value =
          Get.parameters["isFromMenu"] == "true" ? true : false;
      storeHomeMainController.apiGetUserDetailsApi();
      storeHomeMainController.storeId.value = Get.parameters["storeId"] ?? "";

      storeHomeMainController.getCurrentLocation();
      if (storeHomeMainController.isFromMenu.value) {
        storeHomeMainController.selectedIndex.value = 1;
        if(storeHomeMainController.storeId.value != "" && storeHomeMainController.productId.value != ""){
          storeHomeMainController.apiGetShopProductDetailApi();
        }
      } else if (storeHomeMainController.isFromFav.value) {
        storeHomeMainController.selectedIndex.value = 2;
        storeHomeMainController.apiFeatureProductListApi(
            isFeaturedProduct: true);
        if(storeHomeMainController.storeId.value != "" && storeHomeMainController.productId.value != ""){
          storeHomeMainController.apiGetShopProductDetailApi();
        }
      } else if (storeHomeMainController.isFromHome.value) {
        storeHomeMainController.selectedIndex.value = 0;
        storeHomeMainController.apiGetStoreOffersApi();
        storeHomeMainController.apiFeatureProductListApi(
            isFeaturedProduct: true);
        if(storeHomeMainController.storeId.value != "" && storeHomeMainController.productId.value != ""){
          storeHomeMainController.apiGetShopProductDetailApi();
        }

      } else {
        storeHomeMainController.onIndexChange(0);
      }

      storeHomeMainController.apiGetUserWalletBalance();
    });
  }

  void contactAlertDialog(
    context,
  ) {
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
                      .storeDetailsResponse.value.data?.store?.storeName ??
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
                      .storeDetailsResponse.value.data?.store?.storePhone ??
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
                      .storeDetailsResponse.value.data?.store?.storeEmail ??
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
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 5),
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
                          : Obx(() {
                              return PopupMenuButton(
                                onOpened: () async {
                                  storeHomeMainController.selectedIndex.value =
                                      3;
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
                              );
                            })
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              horizontalTabs(),
              const Divider(
                thickness: 1,
              ),
              storeHomeMainController.selectedIndex.value == 0
                  ? const Expanded(child: StoreHomeScreen())
                  : storeHomeMainController.selectedIndex.value == 1
                      ? const Expanded(child: StoreMenuScreen())
                      : storeHomeMainController.selectedIndex.value == 2
                          ? const Expanded(child: StoreFavouriteScreen())
                          : storeHomeMainController.selectedIndex.value == 3
                              ? storeHomeMainController.popUpIndex.value == 0
                                  ? const Expanded(
                                      child: PreviousOrdersScreen())
                                  : storeHomeMainController.popUpIndex.value ==
                                          2
                                      ? storeHomeMainController
                                                  .storeDetailsResponse
                                                  .value
                                                  .data!
                                                  .store!
                                                  .storePages!
                                                  .first
                                                  .storePageContent!
                                                  .dynamicUrl ==
                                              null
                                          ? const Expanded(
                                              child: StoreHomeScreen())
                                          : Expanded(
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
                                          ? storeHomeMainController
                                                      .storeDetailsResponse
                                                      .value
                                                      .data!
                                                      .store!
                                                      .storePages!
                                                      .first
                                                      .storePageContent!
                                                      .dynamicUrl ==
                                                  null
                                              ? const Expanded(
                                                  child: StoreHomeScreen())
                                              : Expanded(
                                                  child: PdfViewScreen(
                                                      isShowPrivacy: false,
                                                      url: storeHomeMainController.storeDetailsResponse.value.data!.store!.storePages!.first.storePageContent!.dynamicUrl.toString()))
                                          : storeHomeMainController.lastSelectedIndex.value == 1
                                              ? const Expanded(child: StoreMenuScreen())
                                              : storeHomeMainController.lastSelectedIndex.value == 2
                                                  ? const Expanded(child: StoreFavouriteScreen())
                                                  : const Expanded(child: StoreHomeScreen())
                              : const Expanded(child: StoreHomeScreen())
            ],
          ),
        ));
  }
}
