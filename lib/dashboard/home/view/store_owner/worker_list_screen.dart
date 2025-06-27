import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_worker_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_worker_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../../controller/add_new_worker_controller.dart';
import '../../model/categories_model.dart';

class WorkerListScreen extends StatefulWidget {
  final String? storeId;
  final String? storeName;
  const WorkerListScreen({super.key, this.storeId, this.storeName});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> with GlobalVarMixin{
  final AddNewWorkerController addNewWorkerController =
      Get.put(AddNewWorkerController());

  @override
  void initState() {
    super.initState();
    addNewWorkerController.storeId.value =  widget.storeId??"";
    addNewWorkerController.storeName.value =  widget.storeName??"";
    addNewWorkerController.apiGetUserStoreList();
    addNewWorkerController.apiGetWorkerList();
    addNewWorkerController.apiGetRoleList();
    addNewWorkerController.apiGetParticularStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: buildBody(),
    );
  }

   buildBody() {
    return Stack(
      children: [

        Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            addNewWorkerController.workerList.isEmpty
                                ? StringConstants.noMemberText
                                : addNewWorkerController.workerList.length > 1
                                    ? "${addNewWorkerController.workerList.length} ${StringConstants.membersText}"
                                    : "${addNewWorkerController.workerList.length} ${StringConstants.memberText}",
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              hasStoreAccess.value && permissionStoreList.isEmpty ||
                                      permissionStoreList.any((element) =>
                                          element.storeId ==
                                                  addNewWorkerController
                                                      .storeId.value &&
                                              element.isStoreOwner == true ||
                                          element.storeId ==
                                                  addNewWorkerController.storeId.value
                                                      .toString() &&
                                              element.controllers!.any((ele) =>
                                                  ele.controllerKey ==
                                                  PermissionKey.createUser.statusName))
                                  ? Get.to(() => const AddNewWorkerScreen(),
                                      id: pageIdApp.value)
                                  : Utility.showAlertMessage(
                                      AlertStringConstants.notAuthorizedToStoreText);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                  size: 18.0,
                                ),
                                width2SizedBox,
                                Text(
                                  StringConstants.addNewWorkerText,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ))
                      ],
                    ),
                    height20SizedBox,
                    Expanded(
                        child: Obx(() => addNewWorkerController.workerList.isEmpty
                            ? addNewWorkerController.isLoading.value == true
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
                                          StringConstants.noWorkersFoundText,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  )
                            : ListView.separated(
                            padding: EdgeInsets.zero,
                                separatorBuilder: (BuildContext context, int index) {
                                  return height12SizedBox;
                                },
                                itemCount: addNewWorkerController.workerList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var concatenate = StringBuffer();
                                  for (var data in addNewWorkerController
                                          .workerList[index].storeUserTimings ??
                                      []) {
                                    for (Categories day
                                        in addNewWorkerController.weekDaysList) {
                                      if (data.dayOfWeek == day.id) {
                                        concatenate.write(day.name?.substring(0, 3));
                                        concatenate.write(', ');
                                      }
                                    }
                                  }
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
                                    resizeDuration: const Duration(milliseconds: 200),
                                    key: UniqueKey(),
                                    confirmDismiss: (DismissDirection direction) async {
                                      hasStoreAccess.value && permissionStoreList.isEmpty ||
                                              permissionStoreList.any((element) =>
                                                  element.storeId == addNewWorkerController.storeId.value &&
                                                      element.isStoreOwner == true ||
                                                  element.storeId ==
                                                          addNewWorkerController
                                                              .storeId.value
                                                              .toString() &&
                                                      element.controllers!.any((ele) =>
                                                          ele.controllerKey ==
                                                          PermissionKey.editStoreUsers
                                                              .statusName))
                                          ? Utility.showConfirmAlertMessage(
                                              AlertStringConstants.areYouSureText,
                                              okay: StringConstants.deleteText, okayTap: () {
                                              addNewWorkerController.workerId.value =
                                                  addNewWorkerController
                                                      .workerList[index].storeUserId
                                                      .toString();
                                              addNewWorkerController.apiDeleteWorker();
                                            })
                                          : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                                      return null;
                                    },
                                    child: InkWell(
                                      onTap: () async {
                                        addNewWorkerController.workerId.value =
                                            addNewWorkerController
                                                .workerList[index].storeUserId
                                                .toString();
                                        hasStoreAccess.value && permissionStoreList.isEmpty ||
                                                permissionStoreList.any((element) =>
                                                    element.storeId ==
                                                            addNewWorkerController
                                                                .storeId.value &&
                                                        element.isStoreOwner == true ||
                                                    element.storeId ==
                                                            addNewWorkerController
                                                                .storeId.value
                                                                .toString() &&
                                                        element.controllers!.any(
                                                            (ele) =>
                                                                ele.controllerKey ==
                                                                PermissionKey
                                                                    .editStoreUsers
                                                                    .statusName))
                                            ? Get.to(() => const EditWorkerScreen(), id: pageIdApp.value)
                                            : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);

                                        await addNewWorkerController
                                            .apiGetWorkerDetail();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: const BoxDecoration(
                                            color: AppColors.greyLight,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            )),
                                        child: Column(children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: AppColors.white,
                                                              width: 1)),
                                                      child: CommonWidgets.circleCachedNetworkImage(
                                                        addNewWorkerController
                                                            .workerList[
                                                        index]
                                                            .user
                                                            ?.image
                                                            ?.dynamicUrl
                                                            .toString() ??
                                                            "",
                                                        fit: BoxFit.contain,
                                                        radius: 36.0,
                                                        assetImg: ImageConstants.userAccount,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              width10SizedBox,
                                              Flexible(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      addNewWorkerController
                                                              .workerList[index]
                                                              .user
                                                              ?.firstName
                                                              .toString() ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          color: AppColors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    height8SizedBox,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${StringConstants.storesText}: ",
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  AppColors.blackLight,
                                                              fontWeight:
                                                                  FontWeight.w400),
                                                        ),
                                                        SizedBox(
                                                          width: 120,
                                                          child: Text(
                                                            addNewWorkerController
                                                                .storeName.value,
                                                            style: const TextStyle(
                                                                fontSize: 12.0,
                                                                color: AppColors.black,
                                                                fontWeight:
                                                                    FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    height8SizedBox,
                                                    Visibility(
                                                      visible: addNewWorkerController
                                                                  .workerList[index]
                                                                  .storeUserTimings !=
                                                              null &&
                                                          addNewWorkerController
                                                              .workerList[index]
                                                              .storeUserTimings!
                                                              .isNotEmpty,
                                                      replacement: height0SizedBox,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                ImageConstants.watch,
                                                                scale: 2.5,
                                                              ),
                                                              width5SizedBox,
                                                              Expanded(
                                                                child: Text(
                                                                  "${concatenate.toString()} \n"
                                                                  "${addNewWorkerController.workerList[index].storeUserTimings != null && addNewWorkerController.workerList[index].storeUserTimings!.isNotEmpty ? "${Utility.formatDateTime(addNewWorkerController.workerList[index].storeUserTimings?.first.startTime ?? "", firstFormat: "hh:mm:ss", secFormat: "hh:mm a").toString()} - "
                                                                      "${Utility.formatDateTime(addNewWorkerController.workerList[index].storeUserTimings?.first.endTime ?? "", firstFormat: "hh:mm:ss", secFormat: "hh:mm a").toString()} " : ""}",
                                                                  overflow: TextOverflow
                                                                      .visible,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize: 12.0,
                                                                      color: AppColors
                                                                          .blackLight),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          height8SizedBox,
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Image.asset(
                                                          ImageConstants.email,
                                                          scale: 4,
                                                          color: AppColors.blackLight,
                                                        ),
                                                        width5SizedBox,
                                                        Expanded(
                                                          child: Text(
                                                            addNewWorkerController
                                                                    .workerList[index]
                                                                    .user
                                                                    ?.email
                                                                    .toString() ??
                                                                "",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow.visible,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.w400,
                                                                fontSize: 12.0,
                                                                color: AppColors
                                                                    .blackLight),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    height8SizedBox,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Image.asset(
                                                          ImageConstants.calling,
                                                          color: AppColors.blackLight,
                                                          scale: 4,
                                                        ),
                                                        width5SizedBox,
                                                        Text(
                                                          addNewWorkerController
                                                                  .workerList[index]
                                                                  .user
                                                                  ?.phone
                                                                  .toString() ??
                                                              "",
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.visible,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize: 12.0,
                                                              color:
                                                                  AppColors.blackLight),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 10),
                                                child: Image.asset(
                                                  ImageConstants.circleedit,
                                                  scale: 2.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                }))),
                  ],
                ),
              ),
            ),
          ],
        ),
        //LOADING OVERLAY
        Obx(() {
          return addNewWorkerController.isLoading.value
              ? Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),)
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Container(
        color: AppColors.primaryLight,
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20, top: 50,bottom: 10),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(5),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringConstants.manageWorkersText,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
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
    );
  }
}
