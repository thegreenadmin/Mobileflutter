import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/view/add_categories_screen.dart';
import 'package:thegreenmall/dashboard/home/view/view_product_list_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class MangeProductScreen extends StatefulWidget {
  const MangeProductScreen({Key? key}) : super(key: key);

  @override
  State<MangeProductScreen> createState() => _MangeProductScreenState();
}

class _MangeProductScreenState extends State<MangeProductScreen> {
  final ManageStoreController manageStoreController =
      Get.put(ManageStoreController());

  Container _horizontalTab() {
    return Container(
      height: 47,
      width: WidgetConstants.screenWidth * 0.90,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            width: 0, //
            color: AppColors.blacklight),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (manageStoreController.isMenuSelected.value == true) {
                  } else {
                    manageStoreController.isMenuSelected.value =
                        !manageStoreController.isMenuSelected.value;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: manageStoreController.isMenuSelected.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.menuText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: manageStoreController.isMenuSelected.value
                              ? AppColors.primary
                              : AppColors.blacklight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (manageStoreController.isMenuSelected.value == false) {
                  } else {
                    manageStoreController.isMenuSelected.value =
                        !manageStoreController.isMenuSelected.value;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: manageStoreController.isMenuSelected.value
                      ? AppColors.white
                      : AppColors.primarylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.featuredText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: manageStoreController.isMenuSelected.value
                              ? AppColors.blacklight
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
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
                                  manageStoreController.storeName.value,
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
                          ]),
                    ],
                  )),
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(children: [
            Center(child: _horizontalTab()),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.viewAndUpdateItemsText,
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const AddCategoriesScreen(), arguments: {
                        "storeId": manageStoreController.storeId.value
                      })!
                          .then((value) =>
                              manageStoreController.apiGetCategoriesList());
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
                          StringConstants.addCategoriesText,
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
              child: Obx(() => manageStoreController.categoriesList.isEmpty
                  ? manageStoreController.isLoading.value == true
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
                            const Center(
                              child: Text(
                                "No products found",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return height12SizedBox;
                      },
                      itemCount: manageStoreController.categoriesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            manageStoreController.categoryName.value =
                                manageStoreController
                                        .categoriesList[index].categoryName ??
                                    "";
                            manageStoreController.categoryId.value =
                                manageStoreController
                                        .categoriesList[index].categoryId ??
                                    "";
                            manageStoreController.apiGetStoreProducts();

                            Get.to(const ViewProductScreen());
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child: Obx(() => CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage: NetworkImage(
                                              manageStoreController
                                                  .categoriesList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString()),
                                          backgroundColor: Colors.transparent,
                                        )),
                                  ),
                                  width10SizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Obx(() => Text(
                                              manageStoreController
                                                      .categoriesList[index]
                                                      .categoryName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ),
                                      height4SizedBox,
                                      SizedBox(
                                        width: 250,
                                        child: Obx(() => Text(
                                              manageStoreController
                                                          .categoriesList[index]
                                                          .totalProducts! >
                                                      1
                                                  ? "${manageStoreController.categoriesList[index].totalProducts} Products"
                                                  : "${manageStoreController.categoriesList[index].totalProducts} Product",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.blacklight,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                          ),
                        );
                      })),
            ),
          ]),
        ));
  }
}
