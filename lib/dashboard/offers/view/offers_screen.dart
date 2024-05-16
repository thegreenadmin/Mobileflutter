import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/edit_offer_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offer_products_screen.dart';
import 'package:thegreenmall/utils/common_appBar.dart';
import 'package:thegreenmall/utils/utils.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  OffersController offersController = Get.put(OffersController());
  StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Obx(() => CommonAppBar(
            showActiveCart: true,
            role: offersController.role.value,
            cartCount:
                offersController.searchStoreUserController.cartCount.value,
            storeId:
                offersController.searchStoreUserController.storeIdValue.value,
            cartLength:
                offersController.searchStoreUserController.cartItems.length,
            firstName: offersController.firstName!.value,
            labelText: StringConstants.offersText,
            lastName: offersController.lastName!.value,
            okayTap: () {
              offersController.searchStoreUserController.apiActiveCartApi();
            },
            isFromNotification: false)),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Obx(
                () => roleApp.value == Role.customerRoleText
                    ? height0SizedBox
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => offersController.getOwnerOfferList.isEmpty
                                ? height0SizedBox
                                : Text(
                                    StringConstants.activeOffersText,
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 18.0,
                              ),
                              width2SizedBox,
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Get.parameters["isFrom"] =
                                      StringConstants.addOfferText;
                                  hasStoreAccess.value &&
                                              permissionStoreList.isEmpty ||
                                          permissionStoreList.any((element) =>
                                              element.isStoreOwner == true ||
                                              element.controllers!.any((ele) =>
                                                  ele.controllerKey ==
                                                  PermissionKey
                                                      .createOffers.statusName))
                                      ? Get.to(() => const AddOfferScreen(),
                                          id: pageIdApp.value,
                                          arguments: {
                                              "isFrom":
                                                  StringConstants.addOfferText,
                                            })?.then((value) {
                                          offersController
                                              .apiGetOwnerOffersList();
                                        })
                                      : Utility.showAlertMessage(
                                          AlertStringConstants
                                              .notAuthorizedToStoreText);
                                },
                                child: Text(StringConstants.addNewOfferText,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.primary)),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              height20SizedBox,
              Expanded(
                child: Obx(() => roleApp.value == Role.customerRoleText
                    ? offersController.getUserOfferList.isEmpty
                        ? offersController.isLoading!.value == true
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
                                      StringConstants.noOffersFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height8SizedBox;
                            },
                            shrinkWrap: true,
                            controller: offersController.scrollController1,
                            //offersController.getUserOfferList.length,
                            itemCount: offersController.getUserOfferList.isEmpty
                                ? 1
                                : offersController.getUserOfferList.length +
                                    (offersController.isLoading!.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index <
                                  offersController.getUserOfferList.length) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: AppColors.greylight,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      )),
                                  child: Column(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.white,
                                                  width: 1)),
                                          child: CommonWidgets
                                              .circleCachedNetworkImage(
                                            offersController
                                                .getUserOfferList[index]
                                                .logo!
                                                .dynamicUrl
                                                .toString(),
                                            fit: BoxFit.contain,
                                            radius: 24.0,
                                            assetImg: ImageConstants.nopicfound,
                                          ),
                                        ),
                                        width10SizedBox,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offersController
                                                      .getUserOfferList[index]
                                                      .storeName ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            height8SizedBox,
                                            Row(
                                              children: [
                                                Image.asset(
                                                  ImageConstants.loc,
                                                  scale: 3,
                                                ),
                                                width6SizedBox,
                                                Text(
                                                  offersController
                                                          .getUserOfferList[
                                                              index]
                                                          .storeAddresses![0]
                                                          .city ??
                                                      "",
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.blacklight,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    height12SizedBox,
                                    SizedBox(
                                      height:
                                          WidgetConstants.screenHeight * 0.2,
                                      width: WidgetConstants.screenWidth,
                                      child: ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context, int i) {
                                            return width8SizedBox;
                                          },
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: offersController
                                              .getUserOfferList[index]
                                              .offers!
                                              .length,
                                          itemBuilder:
                                              (BuildContext context, int i) =>
                                                  InkWell(
                                                    onTap: () async {
                                                      storeHomeMainController
                                                              .offerObj.value =
                                                          offersController
                                                              .getUserOfferList[
                                                                  index]
                                                              .offers![i];

                                                      print(
                                                          "offerObj======== ${storeHomeMainController.offerObj.value.offerName}");
                                                      await offersController
                                                          .apiGetOffersProducts(
                                                              offerId: offersController
                                                                  .getUserOfferList[
                                                                      index]
                                                                  .offers![i]
                                                                  .offerId
                                                                  .toString(),
                                                              storeId: offersController
                                                                  .getUserOfferList[
                                                                      index]
                                                                  .storeId
                                                                  .toString());

                                                      Get.to(
                                                        () =>
                                                            OfferProductScreen(
                                                          offerObj: offersController
                                                              .getUserOfferList[
                                                                  index]
                                                              .offers![i],
                                                        ),
                                                        id: pageIdApp.value,
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: CommonWidgets
                                                                  .cachedNetworkImage(
                                                                offersController
                                                                    .getUserOfferList[
                                                                        index]
                                                                    .offers![i]
                                                                    .image!
                                                                    .dynamicUrl!
                                                                    .toString(),
                                                                fit:
                                                                    BoxFit.fill,
                                                                width: WidgetConstants
                                                                        .screenWidth *
                                                                    0.8,
                                                                assetImg:
                                                                    ImageConstants
                                                                        .nopicfound,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 55,
                                                              child: Card(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                                )),
                                                                color: Colors
                                                                    .white,
                                                                elevation: 2.0,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          12.0,
                                                                      right: 12,
                                                                      bottom:
                                                                          10,
                                                                      top: 10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        offersController.getUserOfferList[index].offers![i].offerName ??
                                                                            "",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                AppColors.black,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            height12SizedBox,
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                    )
                                  ]),
                                );
                              } else if (offersController.isLoading!.value) {
                                Timer(const Duration(milliseconds: 10), () {
                                  offersController.scrollController1.jumpTo(
                                      offersController.scrollController1
                                          .position.maxScrollExtent);
                                });
                                return CommonWidgets.loadingIndicator();
                              } else {
                                return const SizedBox();
                              }
                            })
                    : offersController.getOwnerOfferList.isEmpty
                        ? offersController.isLoading!.value == true
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
                                      StringConstants.noOffersFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height8SizedBox;
                            },
                            shrinkWrap: true,
                            controller: offersController.scrollController,
                            itemCount: offersController
                                    .getOwnerOfferList.isEmpty
                                ? 1
                                : offersController.getOwnerOfferList.length +
                                    (offersController.isLoading!.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index <
                                  offersController.getOwnerOfferList.length) {
                                return Dismissible(
                                  background: Container(
                                    color: AppColors.redlight,
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            color: AppColors.red,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  resizeDuration:
                                      const Duration(milliseconds: 200),
                                  key: UniqueKey(),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    hasStoreAccess.value &&
                                                permissionStoreList.isEmpty ||
                                            permissionStoreList.any((element) =>
                                                element.storeId == offersController.getOwnerOfferList[index].store!.storeId &&
                                                    element.isStoreOwner ==
                                                        true ||
                                                element.storeId == offersController.getOwnerOfferList[index].store!.storeId &&
                                                    element.controllers!.any(
                                                        (ele) =>
                                                            ele.controllerKey ==
                                                            PermissionKey
                                                                .editOffers
                                                                .statusName))
                                        ? Utility.showConfirmAlertMessage(
                                            AlertStringConstants.areYouSureText,
                                            okay: StringConstants.deleteText,
                                            okayTap: () async {
                                            Get.back();
                                            offersController.storeId!
                                                .value = offersController
                                                    .getOwnerOfferList[index]
                                                    .store!
                                                    .storeId ??
                                                "";
                                            offersController.offerId!
                                                .value = offersController
                                                    .getOwnerOfferList[index]
                                                    .offerId ??
                                                "";
                                            await offersController
                                                .apiDeleteOffer();
                                          })
                                        : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);

                                    return null;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: const BoxDecoration(
                                        color: AppColors.greylight,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        )),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color:
                                                                AppColors.white,
                                                            width: 1)),
                                                    child: CommonWidgets
                                                        .circleCachedNetworkImage(
                                                      offersController
                                                          .getOwnerOfferList[
                                                              index]
                                                          .store!
                                                          .logo!
                                                          .dynamicUrl!,
                                                      fit: BoxFit.contain,
                                                      radius: 24.0,
                                                      assetImg: ImageConstants
                                                          .nopicfound,
                                                    ),
                                                  ),
                                                  width10SizedBox,
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        offersController
                                                                .getOwnerOfferList[
                                                                    index]
                                                                .store!
                                                                .storeName ??
                                                            "",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                AppColors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      height8SizedBox,
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            ImageConstants.loc,
                                                            scale: 3,
                                                          ),
                                                          width6SizedBox,
                                                          Text(
                                                            offersController
                                                                    .getOwnerOfferList[
                                                                        index]
                                                                    .store!
                                                                    .storeAddresses![
                                                                        0]
                                                                    .city ??
                                                                "",
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: AppColors
                                                                    .blacklight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.parameters["isFrom"] =
                                                        StringConstants
                                                            .editOfferText;
                                                    Get.parameters["storeId"] =
                                                        offersController
                                                                .getOwnerOfferList[
                                                                    index]
                                                                .store!
                                                                .storeId ??
                                                            "";
                                                    Get.parameters["offerId"] =
                                                        offersController
                                                                .getOwnerOfferList[
                                                                    index]
                                                                .offerId ??
                                                            "";

                                                    hasStoreAccess.value &&
                                                                permissionStoreList
                                                                    .isEmpty ||
                                                            permissionStoreList.any((element) =>
                                                                element.storeId == offersController.getOwnerOfferList[index].store!.storeId &&
                                                                    element.isStoreOwner ==
                                                                        true ||
                                                                element.storeId == offersController.getOwnerOfferList[index].store!.storeId &&
                                                                    element.controllers!.any((ele) =>
                                                                        ele.controllerKey ==
                                                                        PermissionKey
                                                                            .editOffers
                                                                            .statusName))
                                                        ? Get.to(() => const EditOfferScreen(),
                                                                id: pageIdApp
                                                                    .value,
                                                                arguments: {
                                                                "isFrom":
                                                                    StringConstants
                                                                        .editOfferText,
                                                                "storeId": offersController
                                                                        .getOwnerOfferList[
                                                                            index]
                                                                        .store!
                                                                        .storeId ??
                                                                    "",
                                                                "offerId": offersController
                                                                        .getOwnerOfferList[
                                                                            index]
                                                                        .offerId ??
                                                                    ""
                                                              })!
                                                            .then((value) {
                                                            roleApp.value ==
                                                                    Role
                                                                        .customerRoleText
                                                                ? offersController
                                                                    .apiGetUserOffersList()
                                                                : offersController
                                                                    .apiGetOwnerOffersList();
                                                          })
                                                        : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                                                  },
                                                  child: Image.asset(
                                                    ImageConstants.edit,
                                                    scale: 3,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          height8SizedBox,
                                          height12SizedBox,
                                          SizedBox(
                                              height:
                                                  WidgetConstants.screenHeight *
                                                      0.2,
                                              width:
                                                  WidgetConstants.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: CommonWidgets
                                                            .cachedNetworkImage(
                                                          offersController
                                                              .getOwnerOfferList[
                                                                  index]
                                                              .image!
                                                              .dynamicUrl
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                          width: WidgetConstants
                                                                  .screenWidth *
                                                              0.8,
                                                          assetImg:
                                                              ImageConstants
                                                                  .nopicfound,
                                                          placeholder: (context,
                                                                  url) =>
                                                              SizedBox(
                                                                  width: WidgetConstants
                                                                          .screenWidth *
                                                                      0.8,
                                                                  child: const Center(
                                                                      child:
                                                                          CircularProgressIndicator())),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 55,
                                                        child: Card(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                            Radius.circular(10),
                                                          )),
                                                          color: Colors.white,
                                                          elevation: 2.0,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 12.0,
                                                                    right: 12,
                                                                    bottom: 10,
                                                                    top: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  offersController
                                                                      .getOwnerOfferList[
                                                                          index]
                                                                      .offerName!,
                                                                  style: const TextStyle(
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      height12SizedBox,
                                                    ],
                                                  ),
                                                ],
                                              ))
                                        ]),
                                  ),
                                );
                              } else if (offersController.isLoading!.value) {
                                Timer(const Duration(milliseconds: 10), () {
                                  offersController.scrollController.jumpTo(
                                      offersController.scrollController.position
                                          .maxScrollExtent);
                                });
                                return CommonWidgets.loadingIndicator();
                              } else {
                                return const SizedBox();
                              }
                            }
                            // itemBuilder: (BuildContext context, int index) {
                            // }
                            )),
              ),
            ],
          )),
    );
  }
}
