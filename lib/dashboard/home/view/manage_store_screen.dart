import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_controller.dart';
import 'package:thegreenmall/dashboard/home/view/manage_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/manage_worker_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_detail_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final SearchStoreController searchStoreController =
      Get.put(SearchStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          height5SizedBox,
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Get.to(const StoreDetailEditScreen());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white, width: 1)),
                              child: const CircleAvatar(
                                radius: 28.0,
                                backgroundImage: AssetImage(
                                  "assets/blackcircle.png",
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Image.asset(
                              "assets/editstore.png",
                              scale: 3,
                            ),
                          ],
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.editStoreDetailText,
                          style: const TextStyle(
                              fontSize: 16.0,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.blacklight,
                      size: 24.0,
                    ),
                  ],
                ),
              ]),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Get.to(const MangeProductScreen(), arguments: {
                "storeId": searchStoreController.storeId.value,
                "storeName": searchStoreController.storeName.value,
                "storeLocation": searchStoreController.storeLocation.value,
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white, width: 1)),
                              child: const CircleAvatar(
                                radius: 28.0,
                                backgroundImage: AssetImage(
                                  "assets/blackcircle.png",
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Image.asset(
                              "assets/manageproduct.png",
                              scale: 3,
                            ),
                          ],
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.manageProdcutText,
                          style: const TextStyle(
                              fontSize: 16.0,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.blacklight,
                      size: 24.0,
                    ),
                  ],
                ),
              ]),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Get.to(const ManageWorkerScreen(), arguments: {
                "storeId": searchStoreController.storeId.value,
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white, width: 1)),
                              child: const CircleAvatar(
                                radius: 28.0,
                                backgroundImage: AssetImage(
                                  "assets/blackcircle.png",
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Image.asset(
                              "assets/worker.png",
                              scale: 3,
                            ),
                          ],
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.manageWorkersText,
                          style: const TextStyle(
                              fontSize: 16.0,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.blacklight,
                      size: 24.0,
                    ),
                  ],
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
