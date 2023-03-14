import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/add_new_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/add_new_worker_screen.dart';
import 'package:thegreenmall/dashboard/home/view/manage_store_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/manage_worker_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

import '../controller/add_new_worker_controller.dart';

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
                const Text(
                  "3 Member",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
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
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return height12SizedBox;
                    },
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                            color: AppColors.greylight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: const CircleAvatar(
                                        radius: 36.0,
                                        backgroundImage: AssetImage(
                                          "assets/workerpic.png",
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    const Divider(),
                                    const Text(
                                      "Primary Store",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              width10SizedBox,
                              Flexible(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 190,
                                      child: Text(
                                        "Joe M Smith",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    height8SizedBox,
                                    SizedBox(
                                      width: 190,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Stores:",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const Text(
                                            " Healthy  Store",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500),
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
                                            "AvenueErie Rhode Island 24975",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: AppColors.blacklight),
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
                                          "assets/watch.png",
                                          scale: 2.5,
                                        ),
                                        width5SizedBox,
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "M to F - 9:00 – 5:00 PM",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: AppColors.blacklight),
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
                                          "assets/email.png",
                                          scale: 4,
                                          color: AppColors.blacklight,
                                        ),
                                        width5SizedBox,
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Michael@gmail.com",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: AppColors.blacklight),
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
                                            "572-736-3746",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: AppColors.blacklight),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const ManageWorkerEditScreen());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Image.asset(
                                    "assets/circleedit.png",
                                    scale: 2.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
