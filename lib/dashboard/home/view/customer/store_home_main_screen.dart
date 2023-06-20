import 'package:flutter/material.dart';
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
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';
import 'package:thegreenmall/utils/utility.dart';

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
    if (storeHomeMainController.storeId.value != Get.parameters["storeId"]) {
      storeHomeMainController.storeId.value = Get.parameters["storeId"] ?? "";
      storeHomeMainController.getCurrentLocation();
    }
    storeHomeMainController.apiGetCartListApi(context);

    if (Get.parameters["isFromHome"] == null
        ? false
        : Get.parameters['isFromHome'] != "false") {
      storeHomeMainController.isFromHome.value =
          Get.parameters["isFromHome"] == "true" ? true : false;

      storeHomeMainController.productId.value =
          Get.parameters["productId"] == null
              ? ""
              : Get.parameters["productId"] ?? "";
    }
    storeHomeMainController.storeId.value = Get.parameters["storeId"] == null
        ? ""
        : Get.parameters["storeId"] ?? "";
    storeHomeMainController.apiGetUserDetailsApi();
    if (storeHomeMainController.isFromHome.value) {
      storeHomeMainController.selectedIndex.value = 0;
      storeHomeMainController.apiGetStoreDetailsApi();
      storeHomeMainController.apiGetCartListApi(context);
      storeHomeMainController.apiGetShopProductDetailApi();
    } else {
      storeHomeMainController.apiGetStoreDetailsApi();
      storeHomeMainController.onIndexChange(0);
    }
    storeHomeMainController.apiGetUserWalletBalance();
    storeHomeMainController.apiGetCartListApi(Get.context);
    storeHomeMainController.apiActiveCartApi(Get.context);
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
          value: StringConstants.previousOrdersText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    // Get.back();
                    await storeHomeMainController.apiGetPreviousOrders();
                    SharedPreferenceStorage.setData("context", ctx);
                    Navigator.of(ctx).push(MaterialPageRoute(
                      builder: (_) => const PreviousOrdersScreen(),
                    ));
                    // Get.to(const PreviousOrdersScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.previousOrdersText,
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
                Navigator.of(ctx).pop();
                // Get.back();
                contactAlertDialog(ctx);
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
              onTap: () {
                Navigator.of(ctx).pop();
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
                    SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PdfViewScreen(
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
                                .toString())));
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
              onTap: () {
                Navigator.of(ctx).pop();
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
                    SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PdfViewScreen(
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
                                .toString())));
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
                              ? const Expanded(child: StoreFavouriteScreen())
                              : const Expanded(child: StoreHomeScreen())
            ],
          ),
        ));
  }
}
