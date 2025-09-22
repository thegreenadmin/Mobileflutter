import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/model/user_featured_product_model.dart';
import 'package:thegreenmall/dashboard/home/model/user_offers_model.dart';
import 'package:thegreenmall/dashboard/home/view/account/account_screen.dart';
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
import 'customer/components/store_home_main_args.dart';
import 'store_owner/manage_store_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, GlobalVarMixin {

  final CarouselSliderController _controllerProducts = CarouselSliderController();
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final AccountController accountController = Get.put(AccountController());

  final HomeController homeController = Get.put(HomeController());

  Future<void> _pullRefresh() async {
    homeController.onInit();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void clearConnectionPool() {
    HttpClient().close(force: true);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      // appBar: _buildAppbar(),
      body: buildBody(),
    );
  }

  buildBody() {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView(/*crossAxisAlignment: CrossAxisAlignment.start,*/ children: [
            _buildAppbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() =>
                  roleApp.value == Role.customerRoleText
                      ? _buildCarouselSlider(
                      offersCarouselList: homeController.userCarouselImgList,
                      featuredProductList:
                      homeController.featuredUserProductList)
                      : _buildCarouselSlider(
                      offersCarouselList: homeController.getOwnerOfferList,
                      featuredProductList:
                      homeController.ownerFeatureProductList)),
                  height20SizedBox,
                  _buildFeatureProductText(),
                  height20SizedBox,
                  Obx(
                        () =>
                    roleApp.value == Role.customerRoleText
                        ? _buildProductsCarousel(
                        featuredProductList:
                        homeController.featuredUserProductList)
                        : _buildProductsCarousel(
                        featuredProductList:
                        homeController.ownerFeatureProductList),
                  )
                ],
              ),
            ),
          ]),

        ),
        //LOADING OVERLAY
        Obx(() {
          if (homeController.isLoading.value) {
            return Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),);
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Obx _buildFeatureProductText() {
    return Obx(
          () =>
      (roleApp.value == Role.customerRoleText && homeController.featuredUserProductList.isEmpty) ||
          (roleApp.value == Role.storeOwnerRoleText && homeController.ownerFeatureProductList.isEmpty)
          ? height0SizedBox
          : Text(
        StringConstants.featuredProductsText,
        style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20),
      ),
    );
  }

  _buildAppbar() {
    return Container(
      color: AppColors.primaryLight,
      child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4, top: 20, bottom: 10),
          child: Column(
            children: [
              buildTitle(),
              height12SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RawMaterialButton(
                        elevation: 0,
                        onPressed: () async {
                          roleApp.value == Role.customerRoleText
                              ? Get.to(() => const UserInboxScreen(),
                              id: pageIdApp.value)
                              : hasStoreAccess.value &&
                              permissionStoreList.isEmpty ||
                              permissionStoreList.any((element) =>
                              element.isStoreOwner == true ||
                                  element.controllers!.any((ele) =>
                                  ele.controllerKey ==
                                      PermissionKey
                                          .manageMessages.statusName))
                              ? await Get.to(() => const OwnerInboxScreen(),
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
                      width8SizedBox,
                      Obx(() =>
                      hasStoreAccess.value
                          ? RawMaterialButton(
                        elevation: 0,
                        onPressed: () async {
                          if (roleApp.value == Role.customerRoleText) {
                            await Get.to(
                                  () =>
                                  SearchStoreUserScreen(
                                    firstName: homeController.getUserDetailModel.data?.user?.firstName ?? "",
                                    lastName: homeController.getUserDetailModel.data?.user?.lastName ?? "",
                                  ),
                              id: pageIdApp.value,

                              // arguments: {
                              // },
                            );
                          } else {
                            await Get.to(
                                  () =>
                                  OwnerStoresListScreen(
                                    firstName: homeController.getUserDetailModel.data?.user?.firstName ?? "",
                                    isFromHome: false,
                                    lastName: homeController.getUserDetailModel.data?.user?.lastName ?? "",
                                  ),
                              id: pageIdApp.value,
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
                            width4SizedBox,
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
                        onPressed: () async {
                          if (roleApp.value == Role.customerRoleText) {
                            await Get.to(
                                  () =>
                                  SearchStoreUserScreen(
                                    firstName: homeController.getUserDetailModel.data?.user?.firstName ?? "",
                                    lastName: homeController.getUserDetailModel.data?.user?.lastName ?? "",

                                  ),
                              id: pageIdApp.value,
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
                          onPressed: () async {
                            hasStoreAccess.value &&
                                permissionStoreList.isEmpty ||
                                permissionStoreList.any((element) =>
                                element.isStoreOwner == true ||
                                    element.controllers!.any((ele) =>
                                    ele.controllerKey ==
                                        PermissionKey.manageTransaction
                                            .statusName))
                                ? await Get.to(() => const TransactionScreen(),
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
                      width5SizedBox,
                      RawMaterialButton(
                          elevation: 0,
                          onPressed: () {
                            Get.to(() => const AccountScreen(),
                              id: pageIdApp.value,)
                                ?.then((value) {
                              homeController.isLoading.value = true;
                              homeController.apiGetUserDetail();
                              homeController.getCurrentLocation();
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
    );
  }

  Row buildTitle() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() =>
                  Text(
                    "${StringConstants.hiText}${firstName.value} ${lastName.value}",
                    style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                  )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstants.welcomeToText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: ' T',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: 'he',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: ' G',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: 'reen',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: ' M',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const TextSpan(
                      text: 'all',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
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
                    () =>
                    Visibility(
                      visible: roleApp.value == Role.customerRoleText &&
                          homeController.cartCount.value != 0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (homeController.isLoading.value == false) {
                                      // Get.parameters["storeId"] =
                                      //     homeController.storeIdValue?.value;
                                      await Get.to(() => CartScreen(storeId: homeController.storeIdValue?.value), id: pageIdApp.value)
                                          ?.then((value) => homeController.apiActiveCartApi());
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 18.0,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                            ImageConstants.cart,
                                            height: 14),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                            padding: const EdgeInsets.all(1.5),
                                            decoration: BoxDecoration(
                                              color: AppColors.red,
                                              borderRadius:
                                              BorderRadius.circular(8.5),
                                            ),
                                            constraints: const BoxConstraints(minWidth: 15, minHeight: 15,),
                                            child: Obx(
                                                  () =>
                                                  Text(
                                                    homeController.cartCount.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ), textAlign: TextAlign.center,
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
                  if (homeController.isLoading.value == false) {
                    Get.to(() => const NotificationListScreen(), id: pageIdApp.value);
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
        ]);
  }

  _buildCarouselSlider({RxList<OffersList>? offersCarouselList,
    RxList<ProductsList>? featuredProductList}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            offersCarouselList!.isEmpty
                ? SizedBox(
              height:
              offersCarouselList.isEmpty && featuredProductList!.isEmpty
                  ? WidgetConstants.screenHeight * 0.60
                  : WidgetConstants.screenHeight * 0.30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
            )
                : CarouselSlider(
              items: offersCarouselList.take(5)
                  .map((item) =>
                  Obx(() {
                    return InkWell(
                      onTap: () async {
                        if (homeController.isLoading.value == false) {
                          if (roleApp.value == Role.customerRoleText) {
                            if (item.isOfferForStore == false) {
                              await Get.to(() =>
                                    StoreHomeMainScreen(
                                      args: StoreHomeMainArgs(
                                        storeId: item.storeId ?? "",
                                        productId: item.productId ?? "",
                                        invokedIndex: item.isOfferForStore == true ? 0 : 2,
                                        isFromMenu: true,
                                        isFromFav: false,
                                        isFromHome: false,
                                        isFromOptions: false,
                                      ),
                                    ),
                                id: pageIdApp.value,
                              );
                              }else{

                              await Get.to(() =>
                                    StoreHomeMainScreen(
                                      args: StoreHomeMainArgs(
                                        storeId: item.storeId ?? "",
                                        invokedIndex: item.isOfferForStore == true ? 0 : 2,
                                        isFromMenu: false,
                                        isFromFav: false,
                                        isFromHome: true,
                                        isFromOptions: false,
                                      ),
                                    ),
                                id: pageIdApp.value,
                              );
                            }

                            /* Get.parameters["isFromMenu"] = "true";
                                Get.parameters['isFromFav'] = "false";
                                Get.parameters["isFromHome"] = "false";
                                Get.parameters["isFromOptions"] = "false";

                                if(  item.isOfferForStore == true){

                                  Get.parameters["invokedIndex"] = "0";
                                }else{
                                  Get.parameters["productId"] =
                                      homeController.featuredUserProductList[0].productId ?? "";
                                  Get.parameters["invokedIndex"] = "2";
                                }

                                Get.parameters["storeId"] = item.storeId ?? "";*/

                          } else {
                            // Get.parameters["isFromHome"] = "false";
                            // Get.parameters["storeId"] =
                            //     item.store!.storeId ?? "";
                            Get.to(() =>
                                ManageStoreMainScreen(
                                    storeId: item.store!.storeId ?? ""),
                              id: pageIdApp.value,);
                          }
                        }
                      },
                      child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Stack(
                                  children: <Widget>[
                                    CommonWidgets.cachedNetworkImage(
                                        item.image?.dynamicUrl.toString() ?? "",
                                        assetImg: ImageConstants.nopicfound,
                                        height:
                                        WidgetConstants.screenHeight * 0.28,
                                        width:
                                        WidgetConstants.screenWidth * 0.85),
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(200, 0, 0, 0),
                                              Color.fromARGB(0, 0, 0, 0)
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Text(
                                          offersCarouselList
                                              .where((p0) => item == p0)
                                              .first
                                              .store
                                              ?.storeName ?? "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))),
                    );
                  }))
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
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
            Obx(() =>
            offersCarouselList.isEmpty
                ? height0SizedBox
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: offersCarouselList
                  .take(5)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                return GestureDetector(
                  onTap: () {
                    if (homeController.isLoading.value == false) {
                      _controller.animateToPage(entry.key);
                    }
                  },
                  child: Container(
                    width: _current == entry.key ? 25 : 10,
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        shape: BoxShape.rectangle,
                        color: _current == entry.key
                            ? AppColors.primary
                            : AppColors.grey),
                  ),
                );
              }).toList(),
            ))
          ]);

  _buildProductsCarousel({RxList<ProductsList>? featuredProductList}) {
    return featuredProductList!.isEmpty
        ? height5SizedBox

        : CarouselSlider(
      items: featuredProductList
          .map(
            (item) =>
            Container(

              width: WidgetConstants.screenWidth * 0.48,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (homeController.isLoading.value == false) {
                    if (roleApp.value == Role.customerRoleText) {
                      // Get.parameters["isFromHome"] = "false";
                      // Get.parameters["isFromFav"] = "false";
                      // Get.parameters["isFromMenu"] = "true";
                      // Get.parameters["isFromOptions"] = "false";
                      // Get.parameters["productId"] =
                      //     item.productId ?? "";
                      // Get.parameters["storeId"] =
                      //     item.storeId ?? "";
                      // Get.parameters["invokedIndex"] =
                      //     "2";
                      Get.to(
                            () =>
                            StoreHomeMainScreen(args:
                            StoreHomeMainArgs(
                              storeId: item.storeId ?? "",
                              productId: item.productId ?? "",
                              invokedIndex: 2,
                              isFromMenu: true,
                              isFromFav: false,
                              isFromHome: false,
                              isFromOptions: false,
                            )

                            ),
                        id: pageIdApp.value,
                      );
                    } else {
                      // Get.parameters["isFromHome"] = "true";
                      // Get.parameters["storeId"] =
                      //     item.storeId;
                      // Get.parameters["productId"] =
                      //     item.productId;
                      // Get.parameters["categoryName"] = item.productCategories!
                      //     .isNotEmpty && item.productCategories != null
                      //     ? item.productCategories?.first.category
                      //     ?.categoryName ?? ""
                      //     : "";
                      hasStoreAccess.value &&
                          permissionStoreList.isEmpty ||
                          permissionStoreList.any((element) =>
                          element.storeId == item.storeId &&
                              element.isStoreOwner == true ||
                              element.storeId == item.storeId &&
                                  element.controllers!.any((ele) =>
                                  ele.controllerKey ==
                                      PermissionKey
                                          .editProduct.statusName))
                          ? Get.to(() =>
                          EditProductScreen(
                            isFromHome: true,
                            storeId: item.storeId,
                            productId: item.productId,
                            categoryName: item.productCategories!
                                .isNotEmpty && item.productCategories
                                != null ? item.productCategories?.first.category
                                ?.categoryName ?? ""
                                : "",
                          ),
                        id: pageIdApp.value,
                      )!
                          .then((value) => homeController.apiGetOwnerFeaturedProducts())
                          : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CommonWidgets.cachedNetworkImage(
                        item.productImages ==
                            null ||
                            item
                                .productImages!
                                .isEmpty ||
                            item
                                .productImages![0]
                                .image!
                                .dynamicUrl ==
                                null ||
                            item
                                .productImages!
                                .isEmpty
                            ? ""
                            : item
                            .productImages![0]
                            .image!
                            .dynamicUrl
                            .toString(),
                        height: WidgetConstants.screenHeight * 0.25,
                        width: WidgetConstants.screenWidth * 0.5,
                      ),
                    ),
                    height8SizedBox,
                    Flexible(
                      child: Text(
                        item.productName ?? "",
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      )
          .toList(),
      carouselController: _controllerProducts,
      options: CarouselOptions(
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 0.6,
        enlargeCenterPage: false,
        autoPlay: true,
        aspectRatio: 1.3,
      ),
    );
  }

}
