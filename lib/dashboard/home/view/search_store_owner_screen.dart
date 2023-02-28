import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/add_new_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/manage_store_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class SearchStoreOwnerScreen extends StatefulWidget {
  const SearchStoreOwnerScreen({super.key});

  @override
  State<SearchStoreOwnerScreen> createState() => _SearchStoreOwnerScreenState();
}

class _SearchStoreOwnerScreenState extends State<SearchStoreOwnerScreen> {
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
                                const Text(
                                  "Hi, Julia Adrew",
                                  style: TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
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
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.primary,
                                            width: 1)),
                                    child: const CircleAvatar(
                                      radius: 24.0,
                                      backgroundImage: NetworkImage(
                                          'https://picsum.photos/250?image=9'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  width10SizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 190,
                                        child: Text(
                                          "Healthy  Store",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      height8SizedBox,
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/loc.png",
                                            scale: 3,
                                          ),
                                          width3SizedBox,
                                          const Text(
                                            "132, My Street, Kingston-36001",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: AppColors.black),
                                          ),
                                        ],
                                      ),
                                      height8SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text.rich(
                                            softWrap: true,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${StringConstants.cityText}:",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12)),
                                                const TextSpan(
                                                  text: " Los Angeles",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          width10SizedBox,
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${StringConstants.stateText}:",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14)),
                                                const TextSpan(
                                                  text: "California",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(MangeStoreScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 10),
                                      child: Image.asset(
                                        "assets/edit.png",
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
          Positioned(
            bottom: 20,
            left: 90,
            right: 90,
            child: CustomButton(
              border: Border.all(color: AppColors.primary),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.white, AppColors.white],
              ),
              onTap: () {
                Get.to(const AddNewStoreScreen());
              },
              height: 50,
              text: StringConstants.addANewStoreText,
              textColor: AppColors.primary,
              borderRadius: 12,
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
