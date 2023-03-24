import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/edit_offer_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final OffersController offersController = Get.put(OffersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
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
                                  "Hi, ${offersController.firstName!.value} ${offersController.lastName!.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                )),
                            height4SizedBox,
                            Text(
                              StringConstants.offersText,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                ],
              )),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              SharedPreferenceStorage.getData(Role.role.value).toString() ==
                      Role.customerRoleText
                  ? height0SizedBox
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => offersController.getOwnerOfferlist.isEmpty
                              ? height0SizedBox
                              : Text(
                                  StringConstants.activeOffersText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Get.to(const AddOfferScreen())!.then((value) {
                              offersController.role!.value ==
                                      Role.customerRoleText
                                  ? offersController.apiGetUserOffersList()
                                  : offersController.apiGetOwnerOffersList();
                            });
                          },
                          child: Text(StringConstants.addOfferText,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.primary)),
                        ),
                      ],
                    ),
              height20SizedBox,
              Expanded(
                child: Obx(() => offersController.role!.value ==
                        Role.customerRoleText
                    ? offersController.getUserOfferlist.isEmpty
                        ? offersController.isLoading!.value == true
                            ? height0SizedBox
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/nodata.png",
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
                            itemCount: offersController.getUserOfferlist.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                        child: CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage: offersController
                                                          .getUserOfferlist[
                                                              index]
                                                          .logo!
                                                          .dynamicUrl ==
                                                      null ||
                                                  offersController
                                                      .getUserOfferlist[index]
                                                      .logo!
                                                      .dynamicUrl!
                                                      .isEmpty
                                              ? const AssetImage(
                                                  "assets/offercheck.png",
                                                ) as ImageProvider
                                              : NetworkImage(offersController
                                                  .getUserOfferlist[index]
                                                  .logo!
                                                  .dynamicUrl
                                                  .toString()),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      width10SizedBox,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 270,
                                            child: Text(
                                              offersController
                                                      .getUserOfferlist[index]
                                                      .storeName ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          height8SizedBox,
                                          SizedBox(
                                            width: 270,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/loc.png",
                                                  scale: 3,
                                                ),
                                                width6SizedBox,
                                                Text(
                                                  offersController
                                                          .getUserOfferlist[
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  height12SizedBox,
                                  SizedBox(
                                    height: 160,
                                    width: WidgetConstants.screenWidth,
                                    child: ListView.separated(
                                        separatorBuilder:
                                            (BuildContext context, int i) {
                                          return width8SizedBox;
                                        },
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: offersController
                                            .getUserOfferlist[index]
                                            .offers!
                                            .length,
                                        itemBuilder: (BuildContext context,
                                                int i) =>
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    offersController
                                                                    .getUserOfferlist[
                                                                        index]
                                                                    .offers![i]
                                                                    .image!
                                                                    .dynamicUrl ==
                                                                null ||
                                                            offersController
                                                                .getUserOfferlist[
                                                                    index]
                                                                .offers![i]
                                                                .image!
                                                                .dynamicUrl!
                                                                .isEmpty
                                                        ? Image.asset(
                                                            "assets/medicine.png",
                                                            width: WidgetConstants
                                                                    .screenWidth *
                                                                0.8,
                                                          )
                                                        : Image.network(
                                                            offersController
                                                                .getUserOfferlist[
                                                                    index]
                                                                .offers![i]
                                                                .image!
                                                                .dynamicUrl!
                                                                .toString(),
                                                            fit: BoxFit.fill,
                                                            width: WidgetConstants
                                                                    .screenWidth *
                                                                0.8,
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
                                                                        .getUserOfferlist[
                                                                            index]
                                                                        .offers![
                                                                            i]
                                                                        .offerName ??
                                                                    "",
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14),
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
                                            )),
                                  )
                                ]),
                              );
                            })
                    : offersController.getOwnerOfferlist.isEmpty
                        ? offersController.isLoading!.value == true
                            ? height0SizedBox
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/nodata.png",
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
                            itemCount:
                                offersController.getOwnerOfferlist.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                        child: CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage: offersController
                                                          .getOwnerOfferlist[
                                                              index]
                                                          .store!
                                                          .logo!
                                                          .dynamicUrl ==
                                                      null ||
                                                  offersController
                                                      .getOwnerOfferlist[index]
                                                      .store!
                                                      .logo!
                                                      .dynamicUrl!
                                                      .isEmpty
                                              ? const AssetImage(
                                                  "assets/offercheck.png",
                                                ) as ImageProvider
                                              : NetworkImage(offersController
                                                  .getOwnerOfferlist[index]
                                                  .store!
                                                  .logo!
                                                  .dynamicUrl!),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      width10SizedBox,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 230,
                                                child: Text(
                                                  offersController
                                                          .getOwnerOfferlist[
                                                              index]
                                                          .store!
                                                          .storeName ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(
                                                      const EditOfferScreen(),
                                                      arguments: {
                                                        "storeId": offersController
                                                            .getOwnerOfferlist[
                                                                index]
                                                            .store!
                                                            .storeId,
                                                        "offerId": offersController
                                                            .getOwnerOfferlist[
                                                                index]
                                                            .offerId!
                                                      });
                                                },
                                                child: Image.asset(
                                                  "assets/edit.png",
                                                  scale: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          height8SizedBox,
                                          SizedBox(
                                            width: 270,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/loc.png",
                                                  scale: 3,
                                                ),
                                                width6SizedBox,
                                                Text(
                                                  offersController
                                                          .getOwnerOfferlist[
                                                              index]
                                                          .store!
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  height12SizedBox,
                                  SizedBox(
                                      height: 160,
                                      width: WidgetConstants.screenWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              offersController
                                                              .getOwnerOfferlist[
                                                                  index]
                                                              .image!
                                                              .dynamicUrl ==
                                                          null ||
                                                      offersController
                                                          .getOwnerOfferlist[
                                                              index]
                                                          .image!
                                                          .dynamicUrl!
                                                          .isEmpty
                                                  ? Image.asset(
                                                      "assets/medicine.png",
                                                      width: WidgetConstants
                                                              .screenWidth *
                                                          0.8,
                                                    )
                                                  : Image.network(
                                                      offersController
                                                          .getOwnerOfferlist[
                                                              index]
                                                          .image!
                                                          .dynamicUrl
                                                          .toString(),
                                                      fit: BoxFit.fill,
                                                      width: WidgetConstants
                                                              .screenWidth *
                                                          0.8,
                                                    ),
                                              SizedBox(
                                                height: 55,
                                                child: Card(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                    Radius.circular(10),
                                                  )),
                                                  color: Colors.white,
                                                  elevation: 2.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              .getOwnerOfferlist[
                                                                  index]
                                                              .offerName!,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
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
                              );
                            })),
              ),
            ],
          )),
    );
  }
}
