import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class StoreMenuScreen extends StatefulWidget {
  const StoreMenuScreen({super.key});

  @override
  State<StoreMenuScreen> createState() => _StoreMenuScreenState();
}

class _StoreMenuScreenState extends State<StoreMenuScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          height5SizedBox,
          Text(
            StringConstants.categoriesText,
            style: const TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          height5SizedBox,
          Expanded(
              child: Obx(
            () => storeHomeMainController.categoriesList.isEmpty
                ? storeHomeMainController.isLoading.value == true
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
                              StringConstants.noCategoriesFoundText,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return height6SizedBox;
                    },
                    itemCount: storeHomeMainController.categoriesList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          storeHomeMainController.apiFeatureProductListApi(
                              categoryId: storeHomeMainController
                                      .categoriesList[index].categoryId ??
                                  "0");
                          Get.parameters["categoryName"] =
                              storeHomeMainController
                                  .categoriesList[index].categoryName;
                          Get.parameters["categoryId"] = storeHomeMainController
                              .categoriesList[index].categoryId;
                          storeHomeMainController.categoryName.value =
                              storeHomeMainController
                                      .categoriesList[index].categoryName ??
                                  '';
                          storeHomeMainController.categoryId.value =
                              storeHomeMainController
                                      .categoriesList[index].categoryId ??
                                  '';
                          storeHomeMainController.invokedIndex.value++;
                          // Get.parameters["isAddToOrderScreen"]=="false";
                          /* await Get.to(() => const UserProductListScreen(),
                              id: pageIdApp.value);*/
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.white,
                                              width: 1)),
                                      child: CommonWidgets
                                          .circleCachedNetworkImage(
                                        storeHomeMainController.categoriesList
                                                    .isNotEmpty &&
                                                storeHomeMainController
                                                        .categoriesList[index]
                                                        .image
                                                        ?.dynamicUrl !=
                                                    null
                                            ? storeHomeMainController
                                                    .categoriesList[index]
                                                    .image
                                                    ?.dynamicUrl
                                                    .toString() ??
                                                ""
                                            : "",
                                        fit: BoxFit.contain,
                                        radius: 25.0,
                                        assetImg:
                                            ImageConstants.defaultCategory,
                                      ),
                                    ),
                                    width10SizedBox,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          storeHomeMainController
                                                  .categoriesList[index]
                                                  .categoryName ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        height4SizedBox,
                                        Text(
                                            storeHomeMainController
                                                        .categoriesList[index]
                                                        .totalProducts! >
                                                    1
                                                ? "${storeHomeMainController.categoriesList[index].totalProducts.toString()} products"
                                                : "${storeHomeMainController.categoriesList[index].totalProducts.toString()} product",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w400)),
                                      ],
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
                      );
                    }),
          )),
        ]),
      ),
    );
  }
}
