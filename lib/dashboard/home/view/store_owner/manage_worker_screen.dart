import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_worker_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_store_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_worker_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

import '../../controller/add_new_worker_controller.dart';
import '../../model/categories_model.dart';

class ManageWorkerScreen extends StatefulWidget {
  const ManageWorkerScreen({super.key});

  @override
  State<ManageWorkerScreen> createState() => _ManageWorkerScreenState();
}

class _ManageWorkerScreenState extends State<ManageWorkerScreen> {
  final AddNewWorkerController addNewWorkerController =
      Get.put(AddNewWorkerController());

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
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                ],
              )),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    addNewWorkerController.workerList.length > 1
                        ? "${addNewWorkerController.workerList.length} ${ StringConstants.membersText}"
                        : "${addNewWorkerController.workerList.length} ${ StringConstants.memberText}",
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
                      Get.to(const AddNewWorkerScreen());
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
                          StringConstants.addNewText,
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
                                  "assets/nodata.png",
                                  scale: 8,
                                  color: AppColors.primary,
                                ),
                              ),
                              height4SizedBox,
                               Center(
                                child: Text(
                                    StringConstants.noWorkersFoundText,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )
                    : ListView.separated(
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
                              color: AppColors.redlight,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const <Widget>[
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
                            onDismissed: (direction) {
                              addNewWorkerController.workerId.value =
                                  addNewWorkerController
                                      .workerList[index].storeUserId
                                      .toString();
                              addNewWorkerController.apiDeleteWorker();
                            },
                            child: InkWell(
                              onTap: () async {
                                addNewWorkerController.workerId.value =
                                    addNewWorkerController
                                        .workerList[index].storeUserId
                                        .toString();
                                Get.to(() => const ManageWorkerEditScreen());
                                await addNewWorkerController
                                    .apiGetWorkerDetail();
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
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: AppColors.white,
                                                      width: 1)),
                                              child: addNewWorkerController
                                                              .workerList[index]
                                                              .user
                                                              ?.image
                                                              ?.dynamicUrl !=
                                                          null &&
                                                      addNewWorkerController
                                                              .workerList[index]
                                                              .user
                                                              ?.image
                                                              ?.dynamicUrl !=
                                                          ""
                                                  ? CircleAvatar(
                                                      radius: 36.0,
                                                      backgroundImage: NetworkImage(
                                                          addNewWorkerController
                                                                  .workerList[
                                                                      index]
                                                                  .user
                                                                  ?.image
                                                                  ?.dynamicUrl
                                                                  .toString() ??
                                                              ""),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 36.0,
                                                      backgroundImage: AssetImage(
                                                          "assets/userAccount.png"),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                            ),
                                            // const Divider(),
                                            // const Text(
                                            //   "",
                                            //   textAlign: TextAlign.center,
                                            //   style: TextStyle(
                                            //       fontSize: 12.0,
                                            //       color: AppColors.black,
                                            //       fontWeight: FontWeight.w500),
                                            // ),
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
                                            SizedBox(
                                              width: 190,
                                              child: Text(
                                                addNewWorkerController
                                                        .workerList[index]
                                                        .user
                                                        ?.firstName
                                                        .toString() ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            height8SizedBox,
                                            SizedBox(
                                              width: 190,
                                              child: Row(
                                                children: [
                                                  Text( "${StringConstants.storesText}:",
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    addNewWorkerController
                                                        .storeName.value,
                                                    style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            height8SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "assets/loc.png",
                                                  scale: 2.5,
                                                ),
                                                width5SizedBox,
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    addNewWorkerController
                                                        .storeName.value,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.0,
                                                        color: AppColors
                                                            .blacklight),
                                                  ),
                                                )
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
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/watch.png",
                                                        scale: 2.5,
                                                      ),
                                                      width5SizedBox,
                                                      SizedBox(
                                                        width: 120,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${concatenate.toString()} \n "
                                                              "${addNewWorkerController.workerList[index].storeUserTimings != null && addNewWorkerController.workerList[index].storeUserTimings!.isNotEmpty ? "${Utility.formatDateTime(addNewWorkerController.workerList[index].storeUserTimings?.first.startTime ?? "", firstFormat: "hh:mm:ss", secFormat: "hh:mm a").toString()} - "
                                                                  "${Utility.formatDateTime(addNewWorkerController.workerList[index].storeUserTimings?.first.endTime ?? "", firstFormat: "hh:mm:ss", secFormat: "hh:mm a").toString()} " : ""}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12.0,
                                                                  color: AppColors
                                                                      .blacklight),
                                                            ),
                                                          ],
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
                                                  "assets/email.png",
                                                  scale: 4,
                                                  color: AppColors.blacklight,
                                                ),
                                                width5SizedBox,
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    addNewWorkerController
                                                            .workerList[index]
                                                            .user
                                                            ?.email
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.0,
                                                        color: AppColors
                                                            .blacklight),
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
                                                  "assets/calling.png",
                                                  color: AppColors.blacklight,
                                                  scale: 4,
                                                ),
                                                width5SizedBox,
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    addNewWorkerController
                                                            .workerList[index]
                                                            .user
                                                            ?.phone
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.0,
                                                        color: AppColors
                                                            .blacklight),
                                                  ),
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
                                          "assets/circleedit.png",
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
    );
  }
}
