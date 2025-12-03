import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'components/store_home_main_args.dart';

class PreviousStoreListScreen extends StatefulWidget {
  const PreviousStoreListScreen({super.key});

  @override
  State<PreviousStoreListScreen> createState() =>
      _PreviousStoreListScreenState();
}

class _PreviousStoreListScreenState extends State<PreviousStoreListScreen> with GlobalVarMixin{
  final SearchStoreUserController searchStoreUserController =
  Get.isRegistered<SearchStoreUserController>()
      ? Get.find<SearchStoreUserController>()
      : Get.put(SearchStoreUserController());


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Expanded(
          child: Obx(
                () => searchStoreUserController.previousStore.isEmpty
                ? noDataWidget()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                controller: searchStoreUserController.previousStoresScrollController,
                itemCount: searchStoreUserController
                    .previousStore.length +
                    (searchStoreUserController.isDataLoading.value ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index <
                      searchStoreUserController.previousStore.length) {
                    return buildProductCard(index, context);
                  }
                  else if (searchStoreUserController.isDataLoading.value) {
                    if (!searchStoreUserController
                        .previousStoresScrollController.hasClients) {
                      Timer(const Duration(milliseconds: 10), () {
                        searchStoreUserController.previousStoresScrollController.jumpTo(
                            searchStoreUserController.previousStoresScrollController
                                .position.maxScrollExtent);
                      });
                    }
                    return CommonWidgets.loadingIndicator();
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ),
      ]),
    );
  }

  Visibility buildProductCard(int index, BuildContext context) {
    return Visibility(
                    visible: searchStoreUserController
                        .previousStore[index]
                        .isVerified ==
                        true,
                    child: InkWell(
                      onTap: () async {
                        /*Get.parameters["storeId"] =
                            searchStoreUserController
                                .previousStore[index].storeId ??
                                "";
                        Get.parameters["isFromMenu"] = "false";
                        Get.parameters['isFromFav'] = "false";
                        Get.parameters["isFromHome"] = "true";
                        Get.parameters["isFromOptions"] = "false";*/
                        await Get.to(() =>  StoreHomeMainScreen(
                            args:  StoreHomeMainArgs(
                              storeId: searchStoreUserController
                                  .previousStore[index].storeId ??
                                  "",
                              isFromMenu: false,isFromFav: false,
                              isFromHome: true, isFromOptions: false,
                            )
                        ),
                            id: pageIdApp.value)?.then((v)=>searchStoreUserController.updateCurrentLocation());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: searchStoreUserController
                                .previousStore[index]
                                .isVerified ==
                                true
                                ? AppColors.primaryLight
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
                                          .previousStore[index]
                                          .logo
                                          ?.dynamicUrl ??
                                          "",
                                      fit: BoxFit.contain,
                                      assetImg: ImageConstants.nopicfound,
                                    ),
                                  ),
                                  width10SizedBox,
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
                                              .previousStore[index]
                                              .storeName ??
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
                                              .previousStore[index]
                                              .storeTimings!
                                              .isNotEmpty,
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
                                                      .previousStore[
                                                  index]
                                                      .storeAddresses !=
                                                      null &&
                                                      searchStoreUserController
                                                          .previousStore[
                                                      index]
                                                          .storeAddresses!
                                                          .isNotEmpty
                                                      ? searchStoreUserController
                                                      .previousStore[
                                                  index]
                                                      .storeAddresses
                                                      ?.first
                                                      .addressLine1 ??
                                                      ""
                                                      : "",
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
                                                .previousStore[index]
                                                .storeTimings!
                                                .isNotEmpty
                                                ? searchStoreUserController
                                                .previousStore[
                                            index]
                                                .storeTimings
                                                ?.first
                                                .is24HoursActive ==
                                                false
                                                ? "${StringConstants.storeHourText}: ${Utility.formatDateTime(searchStoreUserController.previousStore[index].storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                "${Utility.formatDateTime(searchStoreUserController.previousStore[index].storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                : StringConstants
                                                .storeHoursText
                                                : StringConstants
                                                .storeHoursText,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color:
                                                AppColors.blackLight,
                                                fontWeight:
                                                FontWeight.w500)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Obx(() {
                                    final store = searchStoreUserController.previousStore[index];

                                    store.isFavouriteStore?.value = store.isFavouriteStore?.value ?? false;

                                    final isFav = store.isFavouriteStore?.value ?? false;

                                    return InkWell(
                                      onTap: () {
                                        if (searchStoreUserController.isLoading.value) return;

                                        if (isFav) {
                                          // Un-favourite
                                          store.isFavouriteStore?.value = false;
                                          searchStoreUserController.apiRemoveFavouriteStore(store.storeId);
                                        } else {
                                          // Favourite
                                          store.isFavouriteStore?.value = true;
                                          searchStoreUserController.apiCreateFavouriteStore(store.storeId);
                                        }
                                      },
                                      radius: 20,
                                      child: Image.asset(
                                        isFav ? ImageConstants.liked : ImageConstants.fav,
                                        scale: 3.2,
                                      ),
                                    );
                                  }),
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
                                      itemCount: searchStoreUserController
                                          .previousStore[index]
                                          .storeDeliveryServices
                                          ?.length ??
                                          0,
                                      itemBuilder: (_, i) {
                                        return Row(
                                          children: [
                                            searchStoreUserController
                                                .previousStore[
                                            index]
                                                .storeDeliveryServices?[
                                            i]
                                                .deliveryServiceId ==
                                                "1"
                                                ? Image.asset(
                                              ImageConstants
                                                  .instore,
                                              scale: 2.5,
                                            )
                                                : searchStoreUserController
                                                .previousStore[
                                            index]
                                                .storeDeliveryServices?[
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
                                                  .previousStore[
                                              index]
                                                  .storeDeliveryServices?[
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
                                    .previousStore[index]
                                    .isVerified ==
                                    false
                                    ? RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    searchStoreUserController
                                        .enterEinNumberAlert(
                                        context,
                                        searchStoreUserController
                                            .previousStore[
                                        index]
                                            .storeId
                                            .toString());
                                  },
                                  constraints:
                                  const BoxConstraints(),
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 8.0, 8.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0,
                                        color: AppColors.primary),
                                    borderRadius:
                                    BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.primary,
                                  child: Text(
                                    StringConstants.claimStoreText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.white),
                                  ),
                                )
                                    : height0SizedBox
                              ],
                            ),
                          ),
                        ]),
                      ),
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
