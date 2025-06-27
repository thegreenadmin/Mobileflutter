import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../../controller/store_home_main_controller.dart';
import 'components/store_home_main_args.dart';

class NearbyStoreListScreen extends StatefulWidget {
  const NearbyStoreListScreen({super.key});

  @override
  State<NearbyStoreListScreen> createState() => _NearbyStoreListScreenState();
}

class _NearbyStoreListScreenState extends State<NearbyStoreListScreen> with GlobalVarMixin{
  final SearchStoreUserController searchStoreUserController  = Get.isRegistered<SearchStoreUserController>()
      ? Get.find<SearchStoreUserController>()
      : Get.put(SearchStoreUserController());
  final StoreHomeMainController storeHomeMainController = Get.isRegistered<StoreHomeMainController>()
      ? Get.find<StoreHomeMainController>()
      : Get.put(StoreHomeMainController());


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Obx(
            () {
              if (searchStoreUserController.storeAddresses.isEmpty) {
                return noDataWidget();
              }

              return ListView.builder(
                  padding: EdgeInsets.zero,
                  key: const PageStorageKey("nearByList"),
              controller: searchStoreUserController.nearByStoresScrollController,

                  itemCount: searchStoreUserController.storeAddresses.length +
                  (searchStoreUserController.isDataLoading.value ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index < searchStoreUserController.storeAddresses.length) {
                  return searchStoreUserController.storeAddresses[index]
                      .store!.isVerified == false && !hasStoreAccess.value
                      ? height0SizedBox
                      : buildProductCard(index, context);
                } else if (searchStoreUserController.isDataLoading.value) {
                  if (!searchStoreUserController
                      .nearByStoresScrollController.hasClients) {
                    Timer(const Duration(milliseconds: 10), () {
                      searchStoreUserController.nearByStoresScrollController.jumpTo(
                          searchStoreUserController.nearByStoresScrollController
                              .position.maxScrollExtent);
                    });
                  }
                  return CommonWidgets.loadingIndicator();

                } else {
                  return const SizedBox();
                }
              });
            },
      ),
    );
  }

  InkWell buildProductCard(int index, BuildContext context) {
    return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    // Get.parameters["storeId"] = searchStoreUserController.storeAddresses[index].store?.storeId ?? "";
                    // Get.parameters["isFromMenu"] = "false";
                    // Get.parameters['isFromFav'] = "false";
                    // Get.parameters["isFromHome"] = "true";
                    // Get.parameters["isFromOptions"] = "false";
                    // storeHomeMainController.onInit();
                    await Get.to(() => StoreHomeMainScreen(args: StoreHomeMainArgs(
                      storeId: searchStoreUserController.storeAddresses[index].store?.storeId ?? "",
                      isFromMenu: false,isFromFav: false,isFromHome: true, isFromOptions: false,
                    ),),id: pageIdApp.value,)?.then((v)=>searchStoreUserController.updateCurrentLocation());
                    // await Get.to(() => const StoreHomeMainScreen( ),
                    //     id: pageIdApp.value)?.then((v)=>searchStoreUserController.updateCurrentLocation());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: searchStoreUserController.storeAddresses[index].store!.isVerified == true
                            ? AppColors.primaryLight
                            : AppColors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
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
                                  searchStoreUserController
                                      .storeAddresses[index]
                                      .store
                                      ?.logo
                                      ?.dynamicUrl ??
                                      "",
                                  fit: BoxFit.contain,
                                  radius: 25.0,
                                  assetImg:
                                  ImageConstants.nopicfound,
                                ),
                              ),
                              width8SizedBox,
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.5,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      searchStoreUserController
                                          .storeAddresses[index]
                                          .store
                                          ?.storeName ??
                                          "",
                                      style: const TextStyle(
                                          fontSize: 17.0,
                                          color: AppColors.black,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                    height4SizedBox,
                                    Visibility(
                                      visible: searchStoreUserController
                                          .storeAddresses[
                                      index]
                                          .addressLine1 !=
                                          null &&
                                          searchStoreUserController
                                              .storeAddresses[
                                          index]
                                              .addressLine1 !=
                                              "",
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageConstants.loc,
                                            scale: 3.2,
                                          ),
                                          width4SizedBox,
                                          Expanded(
                                            child: Text(
                                              searchStoreUserController
                                                  .storeAddresses[
                                              index]
                                                  .addressLine1 ??
                                                  "",
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors
                                                      .blackLight,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    height4SizedBox,
                                    Text(
                                        searchStoreUserController
                                            .storeAddresses[
                                        index]
                                            .store!
                                            .storeTimings!
                                            .isNotEmpty
                                            ? searchStoreUserController
                                            .storeAddresses[
                                        index]
                                            .store
                                            ?.storeTimings
                                            ?.first
                                            .is24HoursActive ==
                                            false
                                            ? "${StringConstants.storeHourText}: ${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - ${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                            : StringConstants
                                            .storeHoursText
                                            : StringConstants
                                            .storeHoursText,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors
                                                .blackLight,
                                            fontWeight:
                                            FontWeight.w500)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              searchStoreUserController
                                  .storeAddresses[index]
                                  .store!.isFavouriteStore!.value ==
                                  true
                                  ? InkWell(
                                onTap: () {
                                  searchStoreUserController
                                      .storeAddresses[index]
                                      .store!.isFavouriteStore!.value =
                                  false;
                                  if (searchStoreUserController
                                      .isLoading.value ==
                                      false) {
                                    searchStoreUserController
                                        .apiRemoveFavouriteStore(
                                      searchStoreUserController
                                          .storeAddresses[
                                      index]
                                          .store
                                          ?.storeId,
                                    );
                                  }
                                },
                                radius: 20,
                                child: Image.asset(
                                  ImageConstants.liked,
                                  scale: 3.2,
                                ),
                              )
                                  : InkWell(
                                onTap: () {
                                  searchStoreUserController
                                      .storeAddresses[index]
                                      .store!.isFavouriteStore!.value =
                                  true;
                                  if (searchStoreUserController
                                      .isLoading.value ==
                                      false) {
                                    searchStoreUserController
                                        .apiCreateFavouriteStore(
                                      searchStoreUserController
                                          .storeAddresses[
                                      index]
                                          .store
                                          ?.storeId,
                                    );
                                  }
                                },
                                radius: 20,
                                child: Image.asset(
                                  ImageConstants.fav,
                                  scale: 3.2,
                                ),
                              ),
                              width10SizedBox,
                              Image.asset(
                                ImageConstants.info,
                                scale: 3.2,
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: WidgetConstants.screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  separatorBuilder:
                                      (BuildContext context,
                                      int index) {
                                    return width10SizedBox;
                                  },
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  searchStoreUserController
                                      .storeAddresses[index]
                                      .store
                                      ?.storeDeliveryServices
                                      ?.length ??
                                      0,
                                  itemBuilder: (_, i) {
                                    return Row(
                                      children: [
                                        searchStoreUserController
                                            .storeAddresses[
                                        index]
                                            .store
                                            ?.storeDeliveryServices?[
                                        i]
                                            .deliveryServiceId ==
                                            "1"
                                            ? Image.asset(
                                          ImageConstants
                                              .instore,
                                          scale: 2.5,
                                        )
                                            : searchStoreUserController
                                            .storeAddresses[
                                        index]
                                            .store
                                            ?.storeDeliveryServices?[
                                        i]
                                            .deliveryServiceId ==
                                            "2"
                                            ? Image.asset(
                                          ImageConstants
                                              .delivery,
                                          scale: 2.7,
                                        )
                                            : Image.asset(
                                          ImageConstants
                                              .curb,
                                          scale: 2.1,
                                        ),
                                        width3SizedBox,
                                        Text(
                                          searchStoreUserController
                                              .storeAddresses[
                                          index]
                                              .store
                                              ?.storeDeliveryServices?[
                                          i]
                                              .deliveryServiceName ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            width10SizedBox,
                            /*searchStoreUserController
                                                        .storeAddresses[
                                                            index]
                                                        .store!
                                                        .isVerified ==
                                                    false &&
                                                hasStoreAccess.value
                                            ? RawMaterialButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  searchStoreUserController
                                                      .enterEinNumberAlert(
                                                          context,
                                                          searchStoreUserController
                                                              .storeAddresses[
                                                                  index]
                                                              .store!
                                                              .storeId
                                                              .toString());
                                                },
                                                constraints:
                                                    const BoxConstraints(),
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    8.0, 8.0, 8.0, 8.0),
                                                shape:
                                                    RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: AppColors
                                                          .primary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.0),
                                                ),
                                                fillColor:
                                                    AppColors.primary,
                                                child: Text(
                                                  StringConstants
                                                      .claimStoreText,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.0,
                                                      color: hasStoreAccess
                                                              .value
                                                          ? AppColors.white
                                                          : AppColors.grey),
                                                ),
                                              )
                                            : height0SizedBox*/
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
  }

  SingleChildScrollView noDataWidget() {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: WidgetConstants.screenHeight *0.09,),
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
                searchStoreUserController.type.value == 0
                    ? StringConstants.noNearbyStoreFoundText
                    : searchStoreUserController.type.value == 1
                    ? StringConstants.noPreviousStoresFoundText
                    : StringConstants.noFavouriteStoresFoundText,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
          ],
        ),
      );
  }
}
