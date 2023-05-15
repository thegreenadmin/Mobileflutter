import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/home_offers_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/search_store_user_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_screen.dart';
import 'package:thegreenmall/dashboard/home/view/notification_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_store_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/owner_stores_list_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/transaction_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

import 'store_owner/manage_store_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  "Hi, ${homeController.firstName!.value} ${homeController.lastName!.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                )),
                            Text(
                              "${StringConstants.welcomeToText} ${StringConstants.appNameText}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(const NotificationListScreen());
                              },
                              child: const Icon(
                                Icons.notifications_active,
                                color: AppColors.primary,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Image.asset(
                              ImageConstants.homeMall,
                              scale: 4,
                            ),
                          ],
                        )
                      ]),
                  height20SizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: () {
                              homeController.role!.value ==
                                      Role.customerRoleText
                                  ? Get.to(const UserInboxScreen())
                                  : Get.to(const OwnerInboxScreen());
                            },
                            constraints: const BoxConstraints(),
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 2.0, 10.0, 2.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.0, color: AppColors.primary),
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            fillColor: AppColors.white,
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.asset(
                                      ImageConstants.message,
                                      scale: 2.5,
                                      color: AppColors.white,
                                    )),
                                width5SizedBox,
                                Text(
                                  StringConstants.inboxText,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          width10SizedBox,
                          Obx(() => homeController.hasStoreAccess!.value
                              ? RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    if (SharedPreferenceStorage.getData(
                                            Role.role.value) ==
                                        Role.customerRoleText) {
                                      Get.to(
                                        const SearchStoreUserScreen(),
                                        arguments: {
                                          "firstName":
                                              homeController.firstName!.value,
                                          "lastName":
                                              homeController.lastName!.value,
                                        },
                                      );
                                    } else {
                                      Get.to(
                                        () => const OwnerStoresListScreen(),
                                        arguments: {
                                          "firstName":
                                              homeController.firstName!.value,
                                          "lastName":
                                              homeController.lastName!.value,
                                        },
                                      );
                                    }
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 2.0, 10.0, 2.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0, color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.white,
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Image.asset(
                                            ImageConstants.storeUnion,
                                            scale: 2.2,
                                            color: AppColors.white,
                                          )),
                                      width5SizedBox,
                                      Text(
                                        StringConstants.storesText,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              : RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    if (SharedPreferenceStorage.getData(
                                            Role.role.value) ==
                                        Role.customerRoleText) {
                                      Get.to(
                                        const SearchStoreUserScreen(),
                                        arguments: {
                                          "firstName":
                                              homeController.firstName!.value,
                                          "lastName":
                                              homeController.lastName!.value,
                                        },
                                      );
                                    }
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 2.0, 10.0, 2.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0, color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.white,
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Image.asset(
                                            ImageConstants.storeUnion,
                                            scale: 2.2,
                                            color: AppColors.white,
                                          )),
                                      width5SizedBox,
                                      Text(
                                        StringConstants.storesText,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ))
                        ],
                      ),
                      Row(
                        children: [
                          RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.to(const TransactionScreen());
                              },
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(14.0),
                              shape: const CircleBorder(
                                side: BorderSide(
                                    width: 1.0, color: AppColors.primary),
                              ),
                              fillColor: AppColors.white,
                              child: Image.asset(
                                ImageConstants.union,
                                scale: 2.4,
                              )),
                          width10SizedBox,
                          RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.to(const AccountScreen(),
                                    arguments: {"isFromCart": false});
                              },
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(14.0),
                              shape: const CircleBorder(
                                side: BorderSide(
                                    width: 1.0, color: AppColors.primary),
                              ),
                              fillColor: AppColors.white,
                              child: Image.asset(
                                ImageConstants.user,
                                scale: 2.5,
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: WidgetConstants.screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(() => homeController.role!.value == Role.customerRoleText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        homeController.isLoading!.value == true
                            ? SizedBox(
                                height: WidgetConstants.screenHeight * 0.20,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primary)),
                              ) //
                            : homeController.userOfferList.isEmpty
                                ? SizedBox(
                                    height: WidgetConstants.screenHeight * 0.50,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.greenmall420,
                                          ),
                                          Text(
                                            StringConstants
                                                .welcomeToGreenMallText,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : CarouselSlider(
                                    items: homeController.userCrouselImgList
                                        .map((item) => InkWell(
                                              onTap: () {
                                                // Get.to(HomeOffersDetailScreen(),
                                                //     arguments: {
                                                //       "storeId":
                                                //           item.storeId ?? "",
                                                //       "offerId":
                                                //           item.offerId ?? ""
                                                //     });
                                                // Get.to(
                                                //     () =>
                                                //         const StoreHomeMainScreen(),
                                                //     arguments: {
                                                //       "isFromHome": true,
                                                //       "storeId":
                                                //           item.storeId ?? "",
                                                //     });
                                              },
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
                                                        0.3,
                                                    width: WidgetConstants
                                                            .screenWidth *
                                                        0.85),
                                              )),
                                            ))
                                        .toList(),
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.scale,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        viewportFraction: 1.2,
                                        enlargeCenterPage: false,
                                        autoPlay: true,
                                        aspectRatio: 1.5,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                        height5SizedBox,
                        Obx(() => homeController.userCrouselImgList.isEmpty
                            ? height0SizedBox
                            : InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: homeController.userCrouselImgList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: _current == entry.key ? 25 : 10,
                                        height: 5.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            shape: BoxShape.rectangle,
                                            color: _current == entry.key
                                                ? AppColors.primary
                                                : AppColors.grey),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ))
                      ])
                : Column(
                    children: [
                      homeController.getOwnerOfferlist.isEmpty
                          ? homeController.isLoading!.value == true
                              ? SizedBox(
                                  height: WidgetConstants.screenHeight * 0.20,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.primary)),
                                ) //height0SizedBox
                              : SizedBox(
                                  height: WidgetConstants.screenHeight * 0.50,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageConstants.greenmall420,
                                        ),
                                        Text(
                                          StringConstants
                                              .welcomeToGreenMallText,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                          : CarouselSlider(
                              items: homeController.getOwnerOfferlist
                                  .map((item) => InkWell(
                                        onTap: () {
                                          Get.to(
                                              () =>
                                                  const ManageStoreMainScreen(),
                                              arguments: {
                                                "isFromHome": true,
                                                "storeId":
                                                    item.store?.storeId ?? "",
                                              });
                                        },
                                        child: Center(
                                            child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          child: Image.network(
                                              item.image?.dynamicUrl ?? "",
                                              fit: BoxFit.fill,
                                              height:
                                                  WidgetConstants.screenHeight *
                                                      0.3,
                                              width:
                                                  WidgetConstants.screenWidth *
                                                      0.85),
                                        )),
                                      ))
                                  .toList(),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  viewportFraction: 1.2,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                  aspectRatio: 1.5,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                      height5SizedBox,
                      homeController.getOwnerOfferlist.isEmpty
                          ? height0SizedBox
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: homeController.getOwnerOfferlist
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: _current == entry.key ? 25 : 10,
                                    height: 5.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                        color: _current == entry.key
                                            ? AppColors.primary
                                            : AppColors.grey),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  )),
            height5SizedBox,
            Obx(
              () => homeController.role!.value == Role.customerRoleText
                  ? homeController.featuredUserProductList.isEmpty
                      ? height0SizedBox
                      : Text(
                          StringConstants.featuredProductText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22),
                        )
                  : homeController.ownerFeatureProductList.isEmpty
                      ? height0SizedBox
                      : Text(
                          StringConstants.featuredProductText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22),
                        ),
            ),
            height12SizedBox,
            Obx(
              () => homeController.role!.value == Role.customerRoleText
                  ? homeController.featuredUserProductList.isEmpty
                      ? height0SizedBox
                      : SizedBox(
                          height: WidgetConstants.screenHeight * 0.28,
                          width: WidgetConstants.screenWidth,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return width12SizedBox;
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                homeController.featuredUserProductList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                print(
                                    "featuredUserProductList--------id--  ${homeController.featuredUserProductList[index].storeId}");
                                print(
                                    "featuredUserProductList--------productId--  ${homeController.featuredUserProductList[index].productId}");
                                Get.to(() => const AddToOrderScreen(),
                                    arguments: {
                                      "isFromHome": true,
                                      "productId": homeController
                                              .featuredUserProductList[index]
                                              .productId ??
                                          "",
                                      "storeId": homeController
                                              .featuredUserProductList[index]
                                              .storeId ??
                                          "",
                                    });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: WidgetConstants.screenHeight * 0.22,
                                    width: WidgetConstants.screenWidth * 0.44,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: homeController
                                                        .featuredUserProductList[
                                                            index]
                                                        .productImages ==
                                                    null ||
                                                homeController
                                                    .featuredUserProductList[
                                                        index]
                                                    .productImages!
                                                    .isEmpty ||
                                                homeController
                                                        .featuredUserProductList[
                                                            index]
                                                        .productImages![0]
                                                        .image!
                                                        .dynamicUrl ==
                                                    null ||
                                                homeController
                                                    .featuredUserProductList[
                                                        index]
                                                    .productImages!
                                                    .isEmpty
                                            ? Image.asset(
                                                ImageConstants.nopicfound,
                                                fit: BoxFit.fill,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                              )
                                            : Image.network(
                                                homeController
                                                    .featuredUserProductList[
                                                        index]
                                                    .productImages![0]
                                                    .image!
                                                    .dynamicUrl
                                                    .toString(),
                                                fit: BoxFit.fill,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                              )),
                                  ),
                                  height8SizedBox,
                                  Text(
                                    homeController
                                            .featuredUserProductList[index]
                                            .productName ??
                                        "",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                  : homeController.ownerFeatureProductList.isEmpty
                      ? height0SizedBox
                      : SizedBox(
                          height: WidgetConstants.screenHeight * 0.28,
                          width: WidgetConstants.screenWidth,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return width12SizedBox;
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                homeController.ownerFeatureProductList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                              onTap: () {
                                Get.to(const EditStoreDetailScreen(),
                                    arguments: {
                                      "isFromHome": true,
                                      'storeId': homeController
                                          .ownerFeatureProductList[index]
                                          .storeId
                                    });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: WidgetConstants.screenHeight * 0.22,
                                    width: WidgetConstants.screenWidth * 0.44,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: homeController
                                                        .ownerFeatureProductList[
                                                            index]
                                                        .productImages ==
                                                    null ||
                                                homeController
                                                        .ownerFeatureProductList[
                                                            index]
                                                        .productImages![0]
                                                        .image!
                                                        .dynamicUrl ==
                                                    null ||
                                                homeController
                                                    .ownerFeatureProductList[
                                                        index]
                                                    .productImages!
                                                    .isEmpty
                                            ? Image.asset(
                                                ImageConstants.nopicfound,
                                                fit: BoxFit.fill,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                              )
                                            : Image.network(
                                                homeController
                                                    .ownerFeatureProductList[
                                                        index]
                                                    .productImages![0]
                                                    .image!
                                                    .dynamicUrl
                                                    .toString(),
                                                fit: BoxFit.fill,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                              )),
                                  ),
                                  height8SizedBox,
                                  Text(
                                    homeController
                                            .ownerFeatureProductList[index]
                                            .productName ??
                                        "",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
            )
          ]),
        ),
      ),
    );
  }
}
