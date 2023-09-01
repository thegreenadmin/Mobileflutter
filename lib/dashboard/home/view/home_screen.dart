import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/search_store_user_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_screen.dart';
import 'package:thegreenmall/dashboard/home/view/notification_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/owner_stores_list_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/transaction_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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

  Future<void> _pullRefresh() async {
    homeController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 4, top: 50),
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
                                  "Hi, ${firstName.value} ${lastName.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                )),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome to ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'T',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'he',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' G',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'reen',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' M',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'all',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Visibility(
                                visible:
                                    roleApp.value == Role.customerRoleText &&
                                        homeController.searchStoreUserController
                                                .cartCount.value !=
                                            0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              Get.parameters["storeId"] =
                                                  homeController
                                                      .searchStoreUserController
                                                      .storeIdValue
                                                      .value;
                                              await Get.to(
                                                      () => const CartScreen(),
                                                      id: pageIdApp.value)
                                                  ?.then((value) => homeController
                                                      .searchStoreUserController
                                                      .apiActiveCartApi());
                                            },
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 22.0,
                                                  backgroundColor: Colors.white,
                                                  child: Image.asset(
                                                      ImageConstants.cart,
                                                      height: 16),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.5),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 15,
                                                        minHeight: 15,
                                                      ),
                                                      child: Obx(
                                                        () => Text(
                                                          homeController
                                                              .searchStoreUserController
                                                              .cartItems
                                                              .length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (homeController.isLoading?.value == false) {
                                  Get.to(() => const NotificationListScreen(),
                                      id: pageIdApp.value);
                                }
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
                              roleApp.value == Role.customerRoleText
                                  ? Get.to(() => const UserInboxScreen(),
                                      id: pageIdApp.value)
                                  : hasStoreAccess.value &&
                                              permissionStoreList.isEmpty ||
                                          permissionStoreList.any((element) =>
                                              element.isStoreOwner == true ||
                                              element.controllers!.any((ele) =>
                                                  ele.controllerKey ==
                                                  PermissionKey.manageMessages
                                                      .statusName))
                                      ? Get.to(() => const OwnerInboxScreen(),
                                          id: pageIdApp.value)
                                      : Utility.showAlertMessage(
                                          AlertStringConstants
                                              .notAuthorizedToStoreText);
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
                          Obx(() => hasStoreAccess.value
                              ? RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    if (roleApp.value ==
                                        Role.customerRoleText) {
                                      Get.parameters["firstName"] =
                                          firstName.value.toString();
                                      Get.parameters["lastName"] =
                                          lastName.value.toString();

                                      Get.parameters["isFromHome"] = "true";
                                      Get.parameters["isFromFav"] = "false";
                                      Get.parameters["isFromMenu"] = "false";
                                      Get.to(
                                        () => const SearchStoreUserScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                          "firstName": firstName.value,
                                          "lastName": lastName.value,
                                        },
                                      );
                                    } else {
                                      Get.parameters["isFromHome"] = 'false';
                                      Get.parameters["firstName"] =
                                          firstName.value.toString();
                                      Get.parameters["lastName"] =
                                          lastName.value;
                                      Get.parameters['storeId'] = "";
                                      Get.to(
                                        () => const OwnerStoresListScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                          "firstName": firstName.value,
                                          "lastName": lastName.value,
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
                                    if (roleApp.value ==
                                        Role.customerRoleText) {
                                      Get.to(
                                        () => const SearchStoreUserScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                          "firstName": firstName.value,
                                          "lastName": lastName.value,
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
                                hasStoreAccess.value &&
                                            permissionStoreList.isEmpty ||
                                        permissionStoreList.any((element) =>
                                            element.isStoreOwner == true ||
                                            element.controllers!.any((ele) =>
                                                ele.controllerKey ==
                                                PermissionKey.manageTransaction
                                                    .statusName))
                                    ? Get.to(() => const TransactionScreen(),
                                        id: pageIdApp.value)
                                    : Utility.showAlertMessage(
                                        AlertStringConstants
                                            .notAuthorizedToStoreText);
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
                                Get.parameters["isFromCart"] = "false";
                                Get.to(() => const AccountScreen(),
                                        id: pageIdApp.value,
                                        arguments: {"isFromCart": false})
                                    ?.then((value) {
                                  homeController.isLoading?.value = true;
                                  homeController.apiGetUserDetail();
                                  homeController.getCurrentLocation();
                                  homeController.getPage();
                                });
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
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Container(
            height: WidgetConstants.screenHeight * 0.84,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => roleApp.value == Role.customerRoleText
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          /*homeController.isLoading!.value == true
                              ? SizedBox(
                                  height: WidgetConstants.screenHeight * 0.35,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.primary)),
                                ) //
                              :*/
                          homeController.userCarouselImgList.isEmpty
                              ? SizedBox(
                                  height: homeController
                                          .featuredUserProductList.isEmpty
                                      ? WidgetConstants.screenHeight * 0.60
                                      : WidgetConstants.screenHeight * 0.30,
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
                              :

                              /// USER CAROUSEL
                              CarouselSlider(
                                  items: homeController.userCarouselImgList
                                      .take(5)
                                      .map((item) => InkWell(
                                            onTap: () async {
                                              if (homeController
                                                      .isLoading?.value ==
                                                  false) {
                                                Get.parameters["isFromHome"] =
                                                    "true";
                                                Get.parameters["isFromFav"] =
                                                    "false";
                                                Get.parameters["isFromMenu"] =
                                                    "false";
                                                Get.parameters["storeId"] =
                                                    item.storeId ?? "";
                                                await Get.to(
                                                    () =>
                                                        const StoreHomeMainScreen(),
                                                    id: pageIdApp.value);
                                              }
                                            },
                                            child: Center(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: CommonWidgets
                                                  .cachedNetworkImage(
                                                      item.image?.dynamicUrl
                                                              .toString() ??
                                                          "",
                                                      assetImg: ImageConstants
                                                          .nopicfound,
                                                      height: WidgetConstants
                                                              .screenHeight *
                                                          0.28,
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
                          Obx(() => homeController.userCarouselImgList.isEmpty
                              ? height0SizedBox
                              : InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: homeController.userCarouselImgList
                                        .take(5)
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (homeController.isLoading?.value ==
                                              false) {
                                            _controller
                                                .animateToPage(entry.key);
                                          }
                                        },
                                        child: Container(
                                          width:
                                              _current == entry.key ? 25 : 10,
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
                        homeController.getOwnerOfferList.isEmpty
                            ? SizedBox(
                                height: homeController
                                        .ownerFeatureProductList.isEmpty
                                    ? WidgetConstants.screenHeight * 0.60
                                    : WidgetConstants.screenHeight * 0.30,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstants.greenmall420,
                                      ),
                                      Text(
                                        StringConstants.welcomeToGreenMallText,
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

                            ///OWNER CAROUSEL
                            : CarouselSlider(
                                items: homeController.getOwnerOfferList
                                    .take(5)
                                    .map((item) => InkWell(
                                          onTap: () {
                                            if (homeController
                                                    .isLoading?.value ==
                                                false) {
                                              Get.parameters["isFromHome"] =
                                                  "false";
                                              Get.parameters["storeId"] =
                                                  item.store!.storeId ?? "";
                                              Get.to(
                                                  () =>
                                                      const ManageStoreMainScreen(),
                                                  id: pageIdApp.value,
                                                  arguments: {
                                                    "isFromHome": true,
                                                    "storeId":
                                                        item.store?.storeId ??
                                                            "",
                                                  });
                                            }
                                          },
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: CommonWidgets
                                                .cachedNetworkImage(
                                                    item.image?.dynamicUrl ??
                                                        "",
                                                    assetImg: ImageConstants
                                                        .nopicfound,
                                                    height: WidgetConstants
                                                            .screenHeight *
                                                        0.28,
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
                        homeController.getOwnerOfferList.isEmpty
                            ? height0SizedBox
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: homeController.getOwnerOfferList
                                    .take(5)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (homeController.isLoading?.value ==
                                          false) {
                                        _controller.animateToPage(entry.key);
                                      }
                                    },
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
                () => roleApp.value == Role.customerRoleText
                    ? homeController.featuredUserProductList.isEmpty
                        ? height0SizedBox
                        : Text(
                            StringConstants.featuredProductsText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          )
                    : homeController.ownerFeatureProductList.isEmpty
                        ? height0SizedBox
                        : Text(
                            StringConstants.featuredProductsText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
              ),
              height20SizedBox,
              Obx(
                () => roleApp.value == Role.customerRoleText
                    ? homeController.featuredUserProductList.isEmpty
                        ? height0SizedBox
                        : SizedBox(
                            height: WidgetConstants.screenHeight * 0.26,
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
                                  if (homeController.isLoading?.value ==
                                      false) {
                                    Get.parameters["isFromHome"] = "false";
                                    Get.parameters["isFromFav"] = "false";
                                    Get.parameters["isFromMenu"] = "true";
                                    Get.parameters["productId"] = homeController
                                            .featuredUserProductList[index]
                                            .productId ??
                                        "";
                                    Get.parameters["storeId"] = homeController
                                            .featuredUserProductList[index]
                                            .storeId ??
                                        "";

                                    Get.to(() => const AddToOrderScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                          "isFromHome": true,
                                          "productId": homeController
                                                  .featuredUserProductList[
                                                      index]
                                                  .productId ??
                                              "",
                                          "storeId": homeController
                                                  .featuredUserProductList[
                                                      index]
                                                  .storeId ??
                                              "",
                                        });
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CommonWidgets.cachedNetworkImage(
                                        homeController
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
                                            ? ""
                                            : homeController
                                                .featuredUserProductList[index]
                                                .productImages![0]
                                                .image!
                                                .dynamicUrl
                                                .toString(),
                                        height:
                                            WidgetConstants.screenHeight * 0.22,
                                        width:
                                            WidgetConstants.screenWidth * 0.4,
                                      ),
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
                                  if (homeController.isLoading?.value ==
                                      false) {
                                    Get.parameters["isFromHome"] = "true";
                                    Get.parameters["storeId"] = homeController
                                        .ownerFeatureProductList[index].storeId;
                                    Get.parameters["productId"] = homeController
                                        .ownerFeatureProductList[index]
                                        .productId;
                                    Get.parameters["categoryName"] =homeController
                                        .ownerFeatureProductList[index]
                                        .productCategories!.isNotEmpty && homeController
                                        .ownerFeatureProductList[index]
                                        .productCategories!=null?
                                        homeController
                                                .ownerFeatureProductList[index]
                                                .productCategories
                                                ?.first
                                                .category
                                                ?.categoryName ??
                                            "":"";
                                    hasStoreAccess.value && permissionStoreList.isEmpty ||
                                            permissionStoreList.any((element) =>
                                                element.storeId ==
                                                        homeController
                                                            .ownerFeatureProductList[
                                                                index]
                                                            .storeId &&
                                                    element.isStoreOwner ==
                                                        true ||
                                                element.storeId ==
                                                        homeController
                                                            .ownerFeatureProductList[
                                                                index]
                                                            .storeId &&
                                                    element.controllers!.any(
                                                        (ele) =>
                                                            ele.controllerKey ==
                                                            PermissionKey.editProduct.statusName))
                                        ? Get.to(() => const EditProductScreen(), id: pageIdApp.value, arguments: {
                                            "isFromHome": true,
                                            'storeId': homeController
                                                .ownerFeatureProductList[index]
                                                .storeId
                                          })!
                                            .then((value) => homeController.apiGetOwnerFeaturedProducts())
                                        : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CommonWidgets.cachedNetworkImage(
                                        assetImg: ImageConstants.defaultProduct,
                                        homeController
                                                        .ownerFeatureProductList[
                                                            index]
                                                        .productImages ==
                                                    null ||
                                                homeController
                                                    .ownerFeatureProductList[
                                                        index]
                                                    .productImages!
                                                    .isEmpty ||
                                                homeController
                                                        .ownerFeatureProductList[
                                                            index]
                                                        .productImages![0]
                                                        .image!
                                                        .dynamicUrl ==
                                                    null
                                            ? ""
                                            : homeController
                                                    .ownerFeatureProductList[
                                                        index]
                                                    .productImages?[0]
                                                    .image
                                                    ?.dynamicUrl
                                                    .toString() ??
                                                "",
                                        width:
                                            WidgetConstants.screenWidth * 0.4,
                                        height:
                                            WidgetConstants.screenHeight * 0.22,
                                      ),
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
      ),
    );
  }
}
