import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_store_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OwnerStoresListScreen extends StatefulWidget {
  const OwnerStoresListScreen({super.key});

  @override
  State<OwnerStoresListScreen> createState() => _OwnerStoresListScreenState();
}

class _OwnerStoresListScreenState extends State<OwnerStoresListScreen> {
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
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
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                ],
              )),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              children: [
                Expanded(
                    child: Obx(() => ownerStoresController.storeList.isEmpty
                        ? ownerStoresController.isLoading.value == true
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
                                      StringConstants.noStoresFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 60),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return height12SizedBox;
                            },
                            itemCount: ownerStoresController.storeList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  ownerStoresController.storeId.value =
                                      ownerStoresController
                                              .storeList[index].storeId ??
                                          "";

                                  ownerStoresController.storeName.value =
                                      ownerStoresController
                                              .storeList[index].storeName ??
                                          "";

                                  ownerStoresController.storeLocation.value =
                                      ownerStoresController
                                          .storeList[index]
                                          .storeAddresses![ownerStoresController
                                              .addressListIndex!.value]
                                          .addressLine1!;

                                  ownerStoresController.storeLocation.value =
                                      ownerStoresController
                                          .storeList[index]
                                          .storeAddresses![ownerStoresController
                                              .addressListIndex!.value]
                                          .addressLine1!;

                                  ownerStoresController.storeImage!.value =
                                      ownerStoresController.storeList[index]
                                              .image!.dynamicUrl ??
                                          "";

                                  ownerStoresController.storeLogo!.value =
                                      ownerStoresController.storeList[index]
                                              .logo!.dynamicUrl ??
                                          "";

                                  await ownerStoresController
                                      .apiGetParticularStore();

                                  await ownerStoresController
                                      .apiGetFeaturedProducts();
                                  ownerStoresController.onInit();

                                  await Get.to(
                                      () => const ManageStoreMainScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: AppColors.greylight,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      )),
                                  child: Column(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors.white,
                                                    width: 1)),
                                            child: CircleAvatar(
                                              radius: 24.0,
                                              backgroundImage:
                                                  ownerStoresController
                                                              .storeList[index]
                                                              .logo!
                                                              .dynamicUrl !=
                                                          null
                                                      ? NetworkImage(
                                                          ownerStoresController
                                                              .storeList[index]
                                                              .logo!
                                                              .dynamicUrl
                                                              .toString())
                                                      : const AssetImage(
                                                          "assets/nopicfound.png",
                                                        ) as ImageProvider,
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        width10SizedBox,
                                        Flexible(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 190,
                                                child: Text(
                                                  ownerStoresController
                                                          .storeList[index]
                                                          .storeName ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              height8SizedBox,
                                              ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    return height0SizedBox;
                                                  },
                                                  itemCount:
                                                      ownerStoresController
                                                          .storeList[index]
                                                          .storeAddresses!
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    ownerStoresController
                                                        .addressListIndex!
                                                        .value = i;
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                "assets/loc.png",
                                                                scale: 3,
                                                              ),
                                                              width3SizedBox,
                                                              Expanded(
                                                                child: Text(
                                                                  ownerStoresController
                                                                          .storeList[
                                                                              index]
                                                                          .storeAddresses![
                                                                              i]
                                                                          .addressLine1 ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12.0,
                                                                      color: AppColors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ]),
                                                        height10SizedBox,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              flex: 4,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "${StringConstants.cityText}: ",
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .blacklight,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              12)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ownerStoresController
                                                                              .storeList[index]
                                                                              .storeAddresses![i]
                                                                              .city ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          color: AppColors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            width5SizedBox,
                                                            Flexible(
                                                              flex: 6,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "${StringConstants.stateText}: ",
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .blacklight,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              12)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      ownerStoresController
                                                                              .storeList[index]
                                                                              .storeAddresses![i]
                                                                              .state!
                                                                              .stateName ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          color: AppColors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  }),
                                              height8SizedBox,
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0, left: 10),
                                          child: Image.asset(
                                            "assets/edit.png",
                                            scale: 2.8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            }))),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 110,
            right: 110,
            child: CustomButton(
              border: Border.all(
                color: AppColors.primary,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.white, AppColors.white],
              ),
              onTap: () {
                Get.to(const AddNewStoreScreen())!
                    .then((value) => ownerStoresController.apiGetStoreList());
              },
              height: 50,
              text: StringConstants.addANewStoreText,
              textColor: AppColors.primary,
              borderRadius: 14,
              fontWeight: FontWeight.w500,
              iconL: false,
              iconR: false,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
