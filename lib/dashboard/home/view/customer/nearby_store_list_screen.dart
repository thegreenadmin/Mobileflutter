import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class NearbyStoreListScreen extends StatefulWidget {
  const NearbyStoreListScreen({super.key});

  @override
  State<NearbyStoreListScreen> createState() => _NearbyStoreListScreenState();
}

class _NearbyStoreListScreenState extends State<NearbyStoreListScreen> {
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Obx(
              () => searchStoreUserController.storeAddresses.isEmpty
                  ? searchStoreUserController.isDataLoading.value == true
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
                                searchStoreUserController.type.value == 0
                                    ? StringConstants.noNearbyStoreFoundText
                                    : searchStoreUserController.type.value == 1
                                        ? StringConstants
                                            .noPreviousStoresFoundText
                                        : StringConstants
                                            .noFavouriteStoresFoundText,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.builder(
                      controller: searchStoreUserController.scrollController,
                      itemCount: searchStoreUserController
                              .storeAddresses.length +
                          (searchStoreUserController.isLoading.value ? 1 : 0),
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index <
                            searchStoreUserController.storeAddresses.length) {
                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              Get.parameters["storeId"] =
                                  searchStoreUserController
                                          .storeAddresses[index]
                                          .store
                                          ?.storeId ??
                                      "";
                              Get.parameters["isFromMenu"] = "false";
                              Get.parameters['isFromFav'] = "false";
                              Get.parameters["isFromHome"] = "true";
                              Get.parameters["isFromOptions"] = "false";
                              await Get.to(() => const StoreHomeMainScreen(),
                                  id: pageIdApp.value);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: searchStoreUserController
                                              .storeAddresses[index]
                                              .store!
                                              .isVerified ==
                                          true
                                      ? AppColors.primarylight
                                      : AppColors.grey,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            assetImg: ImageConstants.nopicfound,
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
                                                visible:
                                                    searchStoreUserController
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
                                                                .blacklight,
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
                                                          .storeAddresses[index]
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
                                                      color:
                                                          AppColors.blacklight,
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
                                                    .store
                                                    ?.isFavouriteStore ==
                                                true
                                            ? InkWell(
                                                onTap: () {
                                                  if (searchStoreUserController
                                                          .isLoading.value ==
                                                      false) {
                                                    searchStoreUserController
                                                        .apiRemoveFavouriteStore(
                                                      searchStoreUserController
                                                          .storeAddresses[index]
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
                                                  if (searchStoreUserController
                                                          .isLoading.value ==
                                                      false) {
                                                    searchStoreUserController
                                                        .apiCreateFavouriteStore(
                                                      searchStoreUserController
                                                          .storeAddresses[index]
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
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return width10SizedBox;
                                            },
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: searchStoreUserController
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
                                      searchStoreUserController
                                                  .storeAddresses[index]
                                                  .store!
                                                  .isVerified ==
                                              false
                                          ? RawMaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                if (hasStoreAccess.value) {
                                                  searchStoreUserController
                                                      .enterEinNumberAlert(
                                                          context,
                                                          searchStoreUserController
                                                              .storeAddresses[
                                                                  index]
                                                              .store!
                                                              .storeId
                                                              .toString());
                                                }
                                              },
                                              constraints:
                                                  const BoxConstraints(),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8.0, 8.0, 8.0),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: hasStoreAccess.value
                                                        ? AppColors.primary
                                                        : AppColors
                                                            .primaryBackgroundLight),
                                                borderRadius:
                                                    BorderRadius.circular(28.0),
                                              ),
                                              fillColor: hasStoreAccess.value
                                                  ? AppColors.primary
                                                  : AppColors
                                                      .primaryBackgroundLight,
                                              child: Text(
                                                StringConstants.claimStoreText,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.0,
                                                    color: hasStoreAccess.value
                                                        ? AppColors.white
                                                        : AppColors.grey),
                                              ),
                                            )
                                          : height0SizedBox
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          );
                        } else if (searchStoreUserController.isLoading.value) {
                          Timer(const Duration(milliseconds: 10), () {
                            searchStoreUserController.scrollController.jumpTo(
                                searchStoreUserController
                                    .scrollController.position.maxScrollExtent);
                          });
                          return CommonWidgets.loadingIndicator();
                        } else {
                          return const SizedBox();
                        }
                      }),
            ),
          ),
        ]),
      ),
    );
  }
}
