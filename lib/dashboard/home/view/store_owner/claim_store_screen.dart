import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class ClaimStoreScreen extends StatefulWidget {
  const ClaimStoreScreen({super.key});

  @override
  State<ClaimStoreScreen> createState() => _ClaimStoreScreenState();
}

class _ClaimStoreScreenState extends State<ClaimStoreScreen> with GlobalVarMixin{
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildStack(),
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75.0),
      child: Container(
        color: AppColors.primaryLight,
        child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 20, top: 40),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Get.back(id: pageIdApp.value);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.claimStoreText,
                            style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Image.asset(
                        ImageConstants.homeMall,
                        scale: 4,
                      )
                    ]),
              ],
            )),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            children: [
              Expanded(
                  child: Obx(() => ownerStoresController
                          .unclaimedStoreList.isEmpty
                      ? ownerStoresController.loadingData.value == true ||
                              ownerStoresController.isDataComing.value
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
                                    ownerStoresController
                                                .isDataComing.value ==
                                            true
                                        ? ""
                                        : StringConstants.noStoresFoundText,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                      : buildListView())),
            ],
          ),
        ),
      ],
    );
  }

  ListView buildListView() {
    return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 60),
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return height12SizedBox;
                          },
                          itemCount:
                              ownerStoresController.unclaimedStoreList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              background: Container(
                                color: AppColors.redLight,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                            element.storeId ==
                                                ownerStoresController
                                                    .unclaimedStoreList[index]
                                                    .store!
                                                    .storeId &&
                                            element.isStoreOwner == true)
                                    ? Utility.showConfirmAlertMessage(
                                        AlertStringConstants.areYouSureText,
                                        okay: StringConstants.deleteText,
                                        okayTap: () {
                                        ownerStoresController.apiDeleteStore(
                                            storeId: ownerStoresController
                                                .unclaimedStoreList[index]
                                                .store!
                                                .storeId
                                                .toString());
                                      })
                                    : Utility.showAlertMessage(
                                        AlertStringConstants
                                            .notAuthorizedToStoreText);
                                return null;
                              },
                              child: InkWell(
                                onTap: () async {
                                  // ownerStoresController.storeId.value =
                                  //     ownerStoresController
                                  //             .unclaimedStoreList[index]
                                  //             .store!
                                  //             .storeId ??
                                  //         "";
                                  // Get.parameters['storeId'] =
                                  //     ownerStoresController
                                  //             .unclaimedStoreList[index]
                                  //             .store!
                                  //             .storeId ??
                                  //         "";
                                  // await ownerStoresController
                                  //     .apiGetParticularStore();

                                  // await Get.to(
                                  //     () => const ManageStoreMainScreen(),
                                  //     id: pageIdApp.value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      )),
                                  child: Column(children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color:
                                                        AppColors.transparent,
                                                    width: 1)),
                                            child: CommonWidgets
                                                .circleCachedNetworkImage(
                                              ownerStoresController
                                                  .unclaimedStoreList[index]
                                                  .store!
                                                  .logo!
                                                  .dynamicUrl
                                                  .toString(),
                                              fit: BoxFit.contain,
                                              radius: 26.0,
                                              assetImg:
                                                  ImageConstants.nopicfound,
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
                                                          .unclaimedStoreList[
                                                              index]
                                                          .store!
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
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                        ImageConstants.loc,
                                                        scale: 3,
                                                        color: AppColors
                                                            .blackMedium),
                                                    width3SizedBox,
                                                    Expanded(
                                                      child: Text(
                                                        ownerStoresController
                                                                .unclaimedStoreList[
                                                                    index]
                                                                .addressLine1 ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                            fontSize: 12.0,
                                                            color: AppColors
                                                                .blackMedium),
                                                      ),
                                                    ),
                                                  ]),
                                              height10SizedBox,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                                    .blackMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    12)),
                                                        Expanded(
                                                          child: Text(
                                                            ownerStoresController
                                                                    .unclaimedStoreList[
                                                                        index]
                                                                    .city ??
                                                                "",
                                                            style: const TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
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
                                                                color: AppColors.blackMedium,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 12)),
                                                        Expanded(
                                                          child: Text(
                                                            ownerStoresController.unclaimedStoreList[index]
                                                                    .state!.stateName ?? "",
                                                            style: const TextStyle(
                                                                color: AppColors.black,
                                                                fontWeight: FontWeight.w600, fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              height8SizedBox,
                                            ],
                                          ),
                                        ),
                                        // ownerStoresController
                                        //                 .storeAddresses[index]
                                        //                 .store!
                                        //                 .isVerified ==
                                        //             false &&
                                        //         hasStoreAccess.value
                                        //     ?
                                        Visibility(
                                          visible: ownerStoresController.getUserDetailModel.data!.user!.phone ==  ownerStoresController
                                              .unclaimedStoreList[index].store!.storePhone,
                                          child: RawMaterialButton(
                                            elevation: 0,
                                            onPressed: () {
                                              ownerStoresController
                                                  .enterEinNumberAlert(
                                                      context,
                                                      ownerStoresController
                                                          .unclaimedStoreList[index].store!.storeId.toString());
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
                                              StringConstants.claimStoreText,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                  color: hasStoreAccess.value
                                                      ? AppColors.white
                                                      : AppColors.grey),
                                            ),
                                          ),
                                        )
                                        //  : height0SizedBox
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            );
                          });
  }
}
