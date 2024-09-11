import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/claim_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_store_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class OwnerStoresListScreen extends StatefulWidget {
  const OwnerStoresListScreen({super.key});

  @override
  State<OwnerStoresListScreen> createState() => _OwnerStoresListScreenState();
}

class _OwnerStoresListScreenState extends State<OwnerStoresListScreen> with GlobalVarMixin{
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _buildOwnerAppBar(),
      body: _buildStackMethod(),
    );
  }

  Stack _buildStackMethod() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            children: [
              Expanded(
                  child: Obx(() => ownerStoresController.storeList.isEmpty
                      ? ownerStoresController.isLoading.value == true
                          ? height0SizedBox
                          : _buildNoStoresFoundMethod()
                      : _buildStoreListMethod())),
            ],
          ),
        ),
        _buildClaimMethod(),
      ],
    );
  }

  ListView _buildStoreListMethod() {
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
        separatorBuilder: (BuildContext context, int index) {
          return height12SizedBox;
        },
        itemCount: ownerStoresController.storeList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListCard(index);
        });
  }

  Dismissible _buildListCard(int index) {
    return Dismissible(
          background: Container(
            color: AppColors.redlight,
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
          resizeDuration: const Duration(milliseconds: 200),
          key: UniqueKey(),
          confirmDismiss: (DismissDirection direction) async {
            hasStoreAccess.value && permissionStoreList.isEmpty ||
                    permissionStoreList.any((element) =>
                        element.storeId ==
                            ownerStoresController.storeList[index].storeId &&
                        element.isStoreOwner == true)
                ? Utility.showConfirmAlertMessage(
                    AlertStringConstants.areYouSureText,
                    okay: StringConstants.deleteText, okayTap: () {
                    ownerStoresController.apiDeleteStore(
                        storeId: ownerStoresController
                            .storeList[index].storeId
                            .toString());
                  })
                : Utility.showAlertMessage(
                    AlertStringConstants.notAuthorizedToStoreText);
            return null;
          },
          child: InkWell(
            onTap: () async {
              ownerStoresController.storeId.value =
                  ownerStoresController.storeList[index].storeId ?? "";
              Get.parameters['storeId'] =
                  ownerStoresController.storeList[index].storeId ?? "";
              await ownerStoresController.apiGetParticularStore();

              await Get.to(() => const ManageStoreMainScreen(),
                  id: pageIdApp.value);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: AppColors.primarylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.transparent, width: 1)),
                        child: CommonWidgets.circleCachedNetworkImage(
                          ownerStoresController
                              .storeList[index].logo!.dynamicUrl
                              .toString(),
                          fit: BoxFit.contain,
                          radius: 26.0,
                          assetImg: ImageConstants.nopicfound,
                        ),
                      ),
                    ),
                    width10SizedBox,
                    Flexible(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 190,
                            child: Text(
                              ownerStoresController
                                      .storeList[index].storeName ??
                                  "",
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          height8SizedBox,
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int i) {
                                return height0SizedBox;
                              },
                              itemCount: ownerStoresController
                                  .storeList[index].storeAddresses!.length,
                              itemBuilder: (BuildContext context, int i) {
                                ownerStoresController
                                    .addressListIndex!.value = i;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(ImageConstants.loc,
                                              scale: 3,
                                              color: AppColors.blackmedium),
                                          width3SizedBox,
                                          Expanded(
                                            child: Text(
                                              ownerStoresController
                                                      .storeList[index]
                                                      .storeAddresses![i]
                                                      .addressLine1 ??
                                                  "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0,
                                                  color:
                                                      AppColors.blackmedium),
                                            ),
                                          ),
                                        ]),
                                    height10SizedBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${StringConstants.cityText}: ",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .blackmedium,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                              Expanded(
                                                child: Text(
                                                  ownerStoresController
                                                          .storeList[index]
                                                          .storeAddresses![i]
                                                          .city ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${StringConstants.stateText}: ",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .blackmedium,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                              Expanded(
                                                child: Text(
                                                  ownerStoresController
                                                          .storeList[index]
                                                          .storeAddresses![i]
                                                          .state!
                                                          .stateName ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
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
                      padding: const EdgeInsets.only(top: 20.0, left: 10),
                      child: Image.asset(
                        ImageConstants.edit,
                        scale: 3,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        );
  }

  Column _buildNoStoresFoundMethod() {
    return Column(
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
            ownerStoresController.isDataComing.value == true
                ? ""
                : StringConstants.noStoresFoundText,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
        ),
      ],
    );
  }

  PreferredSize _buildOwnerAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90.0),
      child: Container(
        color: AppColors.primarylight,
        child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 20, top: 40),
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
                              Get.back(id: pageIdApp.value);
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
                              Obx(
                                () => Text(
                                  "${StringConstants.hiText}${ownerStoresController.firstName?.value} ${ownerStoresController.lastName?.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
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
                height15SizedBox,
              ],
            )),
      ),
    );
  }

  Visibility _buildClaimMethod() {
    return Visibility(
      visible: isStoreOwner.value,
      child: Positioned(
        bottom: 0,
        child: Container(
          width: WidgetConstants.screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white10,
                Colors.white54,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 60.0,right: 60.0,bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.white, AppColors.white],
                  ),
                  onTap: () {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(
                    //       builder: (_) => const AddNewStoreScreen(),
                    //     ))
                    Get.to(() => const AddNewStoreScreen(), id: pageIdApp.value)!
                        .then((value) => ownerStoresController.apiGetStoreList());
                  },
                  height: 50,
                  text: StringConstants.addANewStoreText,
                  textColor: AppColors.primary,
                  borderRadius: 14,
                  fontWeight: FontWeight.w600,
                  iconL: false,
                  iconR: false,
                  fontSize: 16,
                ),
                height10SizedBox,
                InkWell(
                  onTap: () {
                    Get.to(() => const ClaimStoreScreen(), id: pageIdApp.value);
                  },
                  child: const Text.rich(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "Check if your store already exists. ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13)),
                        TextSpan(
                          text: "Click Here.",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
