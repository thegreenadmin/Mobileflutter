import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                                StringConstants.noNearbyStoreFoundText,
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
                            onTap: () {
                              Get.to(const StoreHomeMainScreen(), arguments: {
                                "storeAddress": searchStoreUserController
                                    .storeAddresses[index]
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
                                                  color: AppColors.white,
                                                  width: 1)),
                                          child: CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: searchStoreUserController
                                                            .storeAddresses[
                                                                index]
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
                                              ImageConstants.nopicfound,)
                                                    as ImageProvider
                                                : NetworkImage(
                                                    searchStoreUserController
                                                            .storeAddresses[
                                                                index]
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
                                          width: MediaQuery.of(context).size.width*0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                searchStoreUserController.storeAddresses[index].store?.storeName ?? "",
                                                style: const TextStyle(
                                                    fontSize: 17.0, color: AppColors.black, fontWeight: FontWeight.w600),
                                              ),
                                              height4SizedBox,
                                              Visibility(
                                                visible: searchStoreUserController
                                                    .storeAddresses[index].store!.storeTimings!.isNotEmpty,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      ImageConstants.loc, scale: 3.2,
                                                    ),
                                                    width4SizedBox,
                                                    Expanded(
                                                      child: Text(
                                                        searchStoreUserController.storeAddresses[index].addressLine1 ?? "",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        softWrap: false,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: AppColors.blacklight,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              height4SizedBox,
                                              Text(
                                                  searchStoreUserController.storeAddresses[index]
                                                          .store!.storeTimings!.isNotEmpty
                                                      ? searchStoreUserController
                                                                  .storeAddresses[index].store?.storeTimings?.first.is24HoursActive == false
                                                          ? "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                              "${Utility.formatDateTime(searchStoreUserController.storeAddresses[index].store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                          : StringConstants.storeHoursText : StringConstants.storeHoursText,
                                                  style: TextStyle(
                                                      fontSize: 14.0, color: AppColors.blacklight,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        searchStoreUserController.storeAddresses[index].store?.isFavouriteStore == true
                                            ? InkWell(
                                          onTap: () {
                                            searchStoreUserController.apiRemoveFavouriteStore(searchStoreUserController.storeAddresses[index].store?.storeId);
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
                                                    .storeAddresses[
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
                                              width: 1.0,
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(28.0),
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
                                searchStoreUserController.scrollController.position.maxScrollExtent);
                          });
                          return _loadingIndicator();
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
}
