import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_category_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_category_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/product_list_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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
        border: Border.all(width: 0, color: AppColors.blacklight),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (manageStoreController.isFeaturedTypeSelected.value ==
                      false) {
                  } else {
                    manageStoreController.isFeaturedTypeSelected.value =
                        !manageStoreController.isFeaturedTypeSelected.value;

                    manageStoreController.apiGetCategoriesList();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: manageStoreController.isFeaturedTypeSelected.value
                      ? AppColors.white
                      : AppColors.primarylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.menuText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              manageStoreController.isFeaturedTypeSelected.value
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                          color:
                              manageStoreController.isFeaturedTypeSelected.value
                                  ? AppColors.blacklight
                                  : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (manageStoreController.isFeaturedTypeSelected.value ==
                      true) {
                  } else {
                    manageStoreController.isFeaturedTypeSelected.value =
                        !manageStoreController.isFeaturedTypeSelected.value;

                    manageStoreController.apiGetCategoriesList();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: manageStoreController.isFeaturedTypeSelected.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.featuredText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              manageStoreController.isFeaturedTypeSelected.value
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color:
                              manageStoreController.isFeaturedTypeSelected.value
                                  ? AppColors.primary
                                  : AppColors.blacklight,
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
                                    Get.delete<ManageStoreController>();
                                    Get.back(id: pageIdApp.value);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.black,
                                    size: 24.0,
                                  ),
                                ),
                                width10SizedBox,
                                Obx(() => SizedBox(
                                      width: 200,
                                      child: Text(
                                        manageStoreController.storeName.value,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                            Image.asset(
                              ImageConstants.homeMall,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringConstants.viewAndUpdateItemsText,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.parameters["storeId"] =
                          manageStoreController.storeId.value;
                      Get.parameters["isFeaturedSelectedType"] =
                          manageStoreController.isFeaturedTypeSelected.value ==
                                  true
                              ? "true"
                              : "false";
                      Get.parameters["IsAddCategory"] = "true";

                      Get.parameters["categoryId"] = "";

                      hasStoreAccess.value && permissionStoreList.isEmpty ||
                              permissionStoreList.any((element) =>
                                  element.storeId ==
                                          manageStoreController.storeId.value &&
                                      element.isStoreOwner == true ||
                                  element.storeId ==
                                          manageStoreController.storeId.value &&
                                      element.controllers!.any((ele) =>
                                          ele.controllerKey ==
                                          PermissionKey.createProductCategories
                                              .statusName))
                          ? Get.to(() => const AddNewCategoryScreen(),
                                  id: pageIdApp.value,
                                  arguments: {
                                  "storeId":
                                      manageStoreController.storeId.value,
                                  "isFeaturedSelectedType":
                                      manageStoreController
                                          .isFeaturedTypeSelected.value,
                                })!
                              .then((value) {
                              manageStoreController.apiGetCategoriesList();
                            })
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
                          StringConstants.addNewCategoriesText,
                          style: const TextStyle(
                              fontSize: 15.0,
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
                        return height12SizedBox;
                      },
                      itemCount: manageStoreController.categoriesList.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                        element.storeId == manageStoreController.storeId.value &&
                                            element.isStoreOwner == true ||
                                        element.storeId == manageStoreController.storeId.value &&
                                            element.controllers!.any((ele) =>
                                                ele.controllerKey ==
                                                PermissionKey
                                                    .editProductCategories
                                                    .statusName))
                                ? Utility.showConfirmAlertMessage(
                                    AlertStringConstants.areYouSureText,
                                    okay: StringConstants.deleteText,
                                    okayTap: () {
                                    manageStoreController.categoryId.value =
                                        manageStoreController
                                            .categoriesList[index].categoryId
                                            .toString();
                                    manageStoreController.apiDeleteCategory();
                                  })
                                : Utility.showAlertMessage(
                                    AlertStringConstants.notAuthorizedToStoreText);

                            return null;
                          },
                          child: InkWell(
                            onTap: () {
                              Get.parameters["categoryName"] =
                                  manageStoreController
                                          .categoriesList[index].categoryName ??
                                      "";
                              Get.parameters["categoryId"] =
                                  manageStoreController
                                          .categoriesList[index].categoryId ??
                                      "";
                              manageStoreController.categoryName.value =
                                  manageStoreController
                                          .categoriesList[index].categoryName ??
                                      "";
                              manageStoreController.categoryId.value =
                                  manageStoreController
                                          .categoriesList[index].categoryId ??
                                      "";
                              manageStoreController.apiGetStoreProducts();
                              Get.to(() => const ProductListScreen(),
                                  id: pageIdApp.value);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.white,
                                                  width: 1)),
                                          child: Obx(
                                            () => CommonWidgets
                                                .circleCachedNetworkImage(
                                              manageStoreController
                                                  .categoriesList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                              fit: BoxFit.contain,
                                              radius: 24.0,
                                              assetImg: ImageConstants
                                                  .defaultCategory,
                                            ),
                                          ),
                                        ),
                                        width10SizedBox,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() => Text(
                                                  manageStoreController
                                                          .categoriesList[index]
                                                          .categoryName ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            height4SizedBox,
                                            Obx(() => Text(
                                                  manageStoreController
                                                              .categoriesList[
                                                                  index]
                                                              .totalProducts! >
                                                          1
                                                      ? "${manageStoreController.categoriesList[index].totalProducts} Products"
                                                      : "${manageStoreController.categoriesList[index].totalProducts} Product",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color:
                                                          AppColors.blacklight,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            manageStoreController.categoryId
                                                .value = manageStoreController
                                                    .categoriesList[index]
                                                    .categoryId ??
                                                "";
                                            Get.parameters["storeId"] =
                                                manageStoreController
                                                    .storeId.value;
                                            Get.parameters["categoryId"] =
                                                manageStoreController
                                                        .categoriesList[index]
                                                        .categoryId ??
                                                    "";
                                            hasStoreAccess.value && permissionStoreList.isEmpty ||
                                                    permissionStoreList.any((element) =>
                                                        element.storeId ==
                                                                manageStoreController
                                                                    .storeId
                                                                    .value &&
                                                            element.isStoreOwner ==
                                                                true ||
                                                        element.storeId ==
                                                                manageStoreController
                                                                    .storeId
                                                                    .value
                                                                    .toString() &&
                                                            element.controllers!.any((ele) =>
                                                                ele.controllerKey ==
                                                                PermissionKey
                                                                    .editProductCategories
                                                                    .statusName))
                                                ? Get.to(() => const EditCategoryScreen(), id: pageIdApp.value, arguments: {
                                                    "storeId":
                                                        manageStoreController
                                                            .storeId.value,
                                                    "categoryId":
                                                        manageStoreController
                                                                .categoriesList[
                                                                    index]
                                                                .categoryId ??
                                                            ""
                                                  })!
                                                    .then((value) {
                                                    manageStoreController
                                                        .apiGetCategoriesList();
                                                  })
                                                : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Image.asset(
                                              ImageConstants.circleedit,
                                              scale: 3,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            manageStoreController.categoryName
                                                .value = manageStoreController
                                                    .categoriesList[index]
                                                    .categoryName ??
                                                "";
                                            manageStoreController.categoryId
                                                .value = manageStoreController
                                                    .categoriesList[index]
                                                    .categoryId ??
                                                "";
                                            manageStoreController
                                                .apiGetStoreProducts();

                                            Get.to(
                                                () => const ProductListScreen(),
                                                id: pageIdApp.value);
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.blackmedium,
                                            size: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        );
                      })),
            ),
          ]),
        ));
  }
}
