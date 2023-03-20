import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AddNewRoleScreen extends StatefulWidget {
  const AddNewRoleScreen({super.key});

  @override
  State<AddNewRoleScreen> createState() => _AddNewRoleScreenState();
}

class _AddNewRoleScreenState extends State<AddNewRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
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
                          Text(
                            StringConstants.addRoleText,
                            style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/homeMall.png",
                        scale: 4,
                      )
                    ])),
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(children: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.managerText,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  height4SizedBox,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/deleteicon.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                      width12SizedBox,
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/circleedit.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.deliveryBoyText,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  height4SizedBox,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/deleteicon.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                      width12SizedBox,
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/circleedit.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.storePersonText,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  height4SizedBox,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/deleteicon.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                      width12SizedBox,
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/circleedit.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.adminText,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  height4SizedBox,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/deleteicon.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                      width12SizedBox,
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            "assets/circleedit.png",
                            scale: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
