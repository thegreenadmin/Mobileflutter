import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_configs/global_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/filter_option_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class UserStoresScreen extends StatefulWidget {
  const UserStoresScreen({Key? key}) : super(key: key);

  @override
  State<UserStoresScreen> createState() => _UserStoresScreenState();
}

class _UserStoresScreenState extends State<UserStoresScreen> {
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    updateCurrentLocation();
    super.initState();
  }

  Padding horizontalTab() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 30,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width40SizedBox;
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: searchStoreUserController.horizontalTabList.length,
            itemBuilder: (_, i) {
              return Obx(() => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    searchStoreUserController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            searchStoreUserController.horizontalTabList[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: searchStoreUserController
                                          .selectedIndex.value ==
                                      i
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: searchStoreUserController
                                          .selectedIndex.value ==
                                      i
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                            ),
                          ),
                          height8SizedBox,
                          searchStoreUserController.selectedIndex.value == i
                              ? Container(
                                  width: 68,
                                  height: 2,
                                  color: AppColors.primary,
                                )
                              : height0SizedBox
                        ],
                      ),
                    ],
                  )));
            }),
      ),
    );
  }

  Expanded favouriteSToreList() {
    return Expanded(
      child: Obx(
        () => searchStoreUserController.favStoreAddresses.isEmpty
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
                          StringConstants.noFavouriteStoresFoundText,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16),
                        ),
                      ),
                    ],
                  )
            : ListView.builder(
                controller: searchStoreUserController.scrollController,
                itemCount: searchStoreUserController.favStoreAddresses.length +
                    (searchStoreUserController.isFavLoading.value ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index <
                      searchStoreUserController.favStoreAddresses.length) {
                    return InkWell(
                      onTap: () {
                        Get.to(const StoreHomeMainScreen(), arguments: {
                          "storeAddress":
                              searchStoreUserController.storeAddresses[index]
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                            color: AppColors.primarylight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: searchStoreUserController
                                                      .favStoreAddresses[index]
                                                      .store
                                                      ?.logo
                                                      ?.dynamicUrl ==
                                                  null ||
                                              searchStoreUserController
                                                  .favStoreAddresses[index]
                                                  .store!
                                                  .logo!
                                                  .dynamicUrl!
                                                  .isEmpty
                                          ? const AssetImage(
                                              ImageConstants.nopicfound,
                                            ) as ImageProvider
                                          : NetworkImage(
                                              searchStoreUserController
                                                      .favStoreAddresses[index]
                                                      .store
                                                      ?.logo
                                                      ?.dynamicUrl
                                                      .toString() ??
                                                  ""),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  width10SizedBox,
                                  SizedBox(
                                      width: WidgetConstants.screenWidth * 0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            searchStoreUserController
                                                    .favStoreAddresses[index]
                                                    .store
                                                    ?.storeName ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 17.0,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          height4SizedBox,
                                          Visibility(
                                            visible: searchStoreUserController
                                                .favStoreAddresses[index]
                                                .store!
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
                                                            .favStoreAddresses[
                                                                index]
                                                            .addressLine1 ??
                                                        "",
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 14.0,
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          height4SizedBox,
                                          Text(
                                              searchStoreUserController
                                                      .storeAddresses.isNotEmpty
                                                  ? searchStoreUserController
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
                                                          ? "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                              "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                          : StringConstants
                                                              .storeHoursText
                                                      : StringConstants
                                                          .storeHoursText
                                                  : StringConstants
                                                      .storeHoursText,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.blacklight,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  searchStoreUserController
                                              .favStoreAddresses[index]
                                              .store
                                              ?.isFavouriteStore ==
                                          true
                                      ? InkWell(
                                          onTap: () {
                                            searchStoreUserController
                                                .apiRemoveFavouriteStore(
                                                    searchStoreUserController
                                                        .favStoreAddresses[
                                                            index]
                                                        .store
                                                        ?.storeId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.liked,
                                            scale: 3.2,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            searchStoreUserController
                                                .apiCreateFavouriteStore(
                                                    searchStoreUserController
                                                        .favStoreAddresses[
                                                            index]
                                                        .store
                                                        ?.storeId);
                                          },
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
                                          (BuildContext context, int index) {
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
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeDeliveryServices?[
                                                            i]
                                                        .deliveryServiceId ==
                                                    "1"
                                                ? Image.asset(
                                                    ImageConstants.instore,
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
                                                        ImageConstants.delivery,
                                                        scale: 2.7,
                                                      )
                                                    : Image.asset(
                                                        ImageConstants.curb,
                                                        scale: 2.1,
                                                      ),
                                            width3SizedBox,
                                            Text(
                                              searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.storeDeliveryServices?[
                                                          i]
                                                      .deliveryServiceName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                width10SizedBox,
                                RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {},
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 8.0, 8.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0, color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.primary,
                                  child: Text(
                                    StringConstants.orderHereText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  } else if (searchStoreUserController.isFavLoading.value) {
                    Timer(const Duration(milliseconds: 30), () {
                      searchStoreUserController.scrollController.jumpTo(
                          searchStoreUserController
                              .scrollController.position.maxScrollExtent);
                    });

                    return _loadingIndicator();
                  } else {
                    return const SizedBox();
                  }
                }),
      ),
    );
  }

  Expanded nearByStoreList() {
    return Expanded(
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
                          StringConstants.noNearbyStoreFoundText,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16),
                        ),
                      ),
                    ],
                  )
            : ListView.builder(
                controller: searchStoreUserController.scrollController,
                itemCount: searchStoreUserController.storeAddresses.length +
                    (searchStoreUserController.isLoading.value ? 1 : 0),
                primary: false,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (index < searchStoreUserController.storeAddresses.length) {
                    return InkWell(
                      onTap: () {
                        Get.to(const StoreHomeMainScreen(), arguments: {
                          "storeAddress":
                              searchStoreUserController.storeAddresses[index]
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                            color: AppColors.primarylight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.image
                                                      ?.dynamicUrl ==
                                                  null ||
                                              searchStoreUserController
                                                  .storeAddresses[index]
                                                  .store!
                                                  .image!
                                                  .dynamicUrl!
                                                  .isEmpty
                                          ? const AssetImage(
                                              ImageConstants.nopicfound,
                                            ) as ImageProvider
                                          : NetworkImage(
                                              searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.image
                                                      ?.dynamicUrl
                                                      .toString() ??
                                                  ""),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  width10SizedBox,
                                  SizedBox(
                                    width: WidgetConstants.screenWidth * 0.5,
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        height4SizedBox,
                                        Visibility(
                                          visible: searchStoreUserController
                                              .storeAddresses[index]
                                              .store!
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
                                                          .storeAddresses[index]
                                                          .addressLine1 ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.blacklight,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                    ? "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                        "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                    : StringConstants
                                                        .storeHoursText
                                                : StringConstants
                                                    .storeHoursText,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w500)),
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
                                            searchStoreUserController
                                                .apiRemoveFavouriteStore(
                                                    searchStoreUserController
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.liked,
                                            scale: 3.2,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            searchStoreUserController
                                                .apiCreateFavouriteStore(
                                                    searchStoreUserController
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeId);
                                          },
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
                                          (BuildContext context, int index) {
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
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeDeliveryServices?[
                                                            i]
                                                        .deliveryServiceId ==
                                                    "1"
                                                ? Image.asset(
                                                    ImageConstants.instore,
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
                                                        ImageConstants.delivery,
                                                        scale: 2.7,
                                                      )
                                                    : Image.asset(
                                                        ImageConstants.curb,
                                                        scale: 2.1,
                                                      ),
                                            width3SizedBox,
                                            Text(
                                              searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.storeDeliveryServices?[
                                                          i]
                                                      .deliveryServiceName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                width10SizedBox,
                                RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    Get.to(const StoreHomeMainScreen(),
                                        arguments: {
                                          "storeAddress":
                                              searchStoreUserController
                                                  .storeAddresses[index]
                                        });
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 8.0, 8.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0, color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.primary,
                                  child: Text(
                                    StringConstants.orderHereText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.white),
                                  ),
                                ),
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
                    return _loadingIndicator();
                  } else {
                    return const SizedBox();
                  }
                }),
      ),
    );
  }

  Expanded previousStoreList() {
    return Expanded(
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
                          StringConstants.noPreviousStoresFoundText,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16),
                        ),
                      ),
                    ],
                  )
            : ListView.builder(
                controller: searchStoreUserController.scrollController,
                itemCount: searchStoreUserController.storeAddresses.length +
                    (searchStoreUserController.isLoading.value ? 1 : 0),
                primary: false,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (index < searchStoreUserController.storeAddresses.length) {
                    return InkWell(
                      onTap: () {
                        Get.to(const StoreHomeMainScreen(), arguments: {
                          "storeAddress":
                              searchStoreUserController.storeAddresses[index]
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                            color: AppColors.primarylight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.image
                                                      ?.dynamicUrl ==
                                                  null ||
                                              searchStoreUserController
                                                  .storeAddresses[index]
                                                  .store!
                                                  .image!
                                                  .dynamicUrl!
                                                  .isEmpty
                                          ? const AssetImage(
                                              ImageConstants.nopicfound,
                                            ) as ImageProvider
                                          : NetworkImage(
                                              searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.image
                                                      ?.dynamicUrl
                                                      .toString() ??
                                                  ""),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  width10SizedBox,
                                  SizedBox(
                                    width: WidgetConstants.screenWidth * 0.5,
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        height4SizedBox,
                                        Visibility(
                                          visible: searchStoreUserController
                                              .storeAddresses[index]
                                              .store!
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
                                                          .storeAddresses[index]
                                                          .addressLine1 ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.blacklight,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                                    ? "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                        "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                    : StringConstants
                                                        .storeHoursText
                                                : StringConstants
                                                    .storeHoursText,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w500)),
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
                                            searchStoreUserController
                                                .apiRemoveFavouriteStore(
                                                    searchStoreUserController
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeId);
                                          },
                                          child: Image.asset(
                                            ImageConstants.liked,
                                            scale: 3.2,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            searchStoreUserController
                                                .apiCreateFavouriteStore(
                                                    searchStoreUserController
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeId);
                                          },
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
                                          (BuildContext context, int index) {
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
                                                        .storeAddresses[index]
                                                        .store
                                                        ?.storeDeliveryServices?[
                                                            i]
                                                        .deliveryServiceId ==
                                                    "1"
                                                ? Image.asset(
                                                    ImageConstants.instore,
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
                                                        ImageConstants.delivery,
                                                        scale: 2.7,
                                                      )
                                                    : Image.asset(
                                                        ImageConstants.curb,
                                                        scale: 2.1,
                                                      ),
                                            width3SizedBox,
                                            Text(
                                              searchStoreUserController
                                                      .storeAddresses[index]
                                                      .store
                                                      ?.storeDeliveryServices?[
                                                          i]
                                                      .deliveryServiceName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                width10SizedBox,
                                RawMaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    Get.to(const StoreHomeMainScreen(),
                                        arguments: {
                                          "storeAddress":
                                              searchStoreUserController
                                                  .storeAddresses[index]
                                        });
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 8.0, 8.0),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1.0, color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  fillColor: AppColors.primary,
                                  child: Text(
                                    StringConstants.orderHereText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.white),
                                  ),
                                ),
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
                    return _loadingIndicator();
                  } else {
                    return const SizedBox();
                  }
                }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hi, ${SharedPreferenceStorage.getData(StringConstants.firstNameText) + " " + SharedPreferenceStorage.getData(StringConstants.lastNameText)}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  StringConstants.searchForStoreText,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          ImageConstants.homeMall,
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                ],
              )),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: WidgetConstants.screenWidth,
                color: AppColors.primarylight,
              ),
              Positioned(
                top: 30,
                child: Stack(
                  children: [
                    SizedBox(
                        height: 250,
                        width: WidgetConstants.screenWidth,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          markers: Set<Marker>.of(markers.values),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        )),
                    Positioned(
                        top: 170,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            Get.to(const FilterOptionScreen());
                          },
                          child: Image.asset(
                            ImageConstants.filterbutton,
                            scale: 3,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: InkWell(
                  onTap: () async {
                    Prediction? p = await PlacesAutocomplete.show(
                        offset: 0,
                        radius: 1000,
                        types: [],
                        strictbounds: false,
                        context: context,
                        apiKey: searchStoreUserController.kGoogleApiKey,
                        mode: Mode.overlay,
                        language: "en",
                        components: []);
                    searchStoreUserController.searchController.text =
                        p!.description!.toString();
                    GeoData addresses = await Geocoder2.getDataFromAddress(
                        address: p.description.toString(),
                        googleMapApiKey:
                            searchStoreUserController.kGoogleApiKey);
                    updateMap(addresses.latitude, addresses.longitude);
                  },
                  child: TextFormField(
                      enabled: false,
                      controller: searchStoreUserController.searchController,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        prefixIcon: Image.asset(
                          ImageConstants.search,
                          scale: 4,
                        ),
                        hintText: StringConstants.searchText,
                        hintStyle: const TextStyle(color: AppColors.grey),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
          horizontalTab(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchStoreUserController.selectedIndex.value == 0
                            ? nearByStoreList()
                            : searchStoreUserController.selectedIndex.value == 1
                                ? previousStoreList()
                                : favouriteSToreList()
                      ])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingIndicator() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).primaryColor,
          ),
        ));
  }

  void updateMap(lat, lng) async {
    CameraPosition kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 0.0,
        zoom: 14.15);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  void updateMarker(latitude, longitude) async {
    const MarkerId markerId = MarkerId("12345");
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageConstants.marker, 60);
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: LatLng(latitude, longitude),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  late GlobalConfigs secureData;

  void updateCurrentLocation() async {
    secureData =
        await GlobalConfigs().loadJsonFromdir('assets/config_keys.json');
    searchStoreUserController.kGoogleApiKey =
        secureData.configs['kGoogleApiKey'];
    Position currentLocation = await Utility.fetchCurrentLocation();
    updateMap(currentLocation.latitude, currentLocation.longitude);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
