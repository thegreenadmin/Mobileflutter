import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_product_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ManageStoreController manageStoreController =
      Get.put(ManageStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
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
                                Get.back(id: pageIdApp.value);
                                // Navigator.of(context).pop();
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
                                Obx(() => SizedBox(
                                      width: 250,
                                      child: Text(
                                        manageStoreController
                                            .categoryName.value,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
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
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.productsListText,
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      // SharedPreferenceStorage.setData("context", context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (_) => const AddNewProductScreen(),
                      // ));

                      permissionStoreList.any((element) =>
                      element.isStoreOwner==true )
                          || permissionStoreList.any((element) =>
                          element.controllers!.any((ele) =>
                          ele.controllerKey == PermissionKey.createProduct.statusName))
                          ? Get.to(const AddNewProductScreen(), id: pageIdApp.value)
                          : Utility.showAlertMessage(AlertStringConstants.notAuthorisedToStoreText);

                      manageStoreController.productNameTextController.clear();
                      manageStoreController.productNameTextController.clear();
                      manageStoreController.quantityTextController.clear();
                      manageStoreController.pricePerUnitTextController.clear();
                      manageStoreController.shortDescriptionTextController
                          .clear();
                      manageStoreController.discountOrOfferTextController
                          .clear();
                      manageStoreController.additionalLinkTextController
                          .clear();
                      manageStoreController.contentsAndStrainsTextController
                          .clear();
                      manageStoreController.lengthTextController.clear();
                      manageStoreController.breadthTextController.clear();
                      manageStoreController.heightTextController.clear();
                      manageStoreController.weightTextController.clear();
                      manageStoreController.daysTextController.clear();
                      manageStoreController.isEnabled.value = false;
                      manageStoreController.imageFileList!.clear();
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
                          StringConstants.addNewProductText,
                          style: const TextStyle(
                              fontSize: 16.0,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ))
              ],
            ),
            height15SizedBox,
            Expanded(
                child: Obx(() => manageStoreController.storeProductList.isEmpty
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
                                  StringConstants.noProductFoundText,
                                  style: const TextStyle(
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
                        itemCount:
                            manageStoreController.storeProductList.length,
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
                              permissionStoreList.any((element) =>
                              element.isStoreOwner==true )
                                  || permissionStoreList.any((element) => element.controllers!.any((ele) =>
                              ele.controllerKey == PermissionKey.editProduct.statusName))
                                  ? Utility.showConfirmAlertMessage(
                                  AlertStringConstants.areYouSureText,
                                  okay: StringConstants.deleteText,
                                  okayTap: () {
                                    // Navigator.pop(Get.context!);
                                    manageStoreController.productId.value =
                                        manageStoreController
                                            .storeProductList[index].productId
                                            .toString();
                                    manageStoreController.apiDeleteProduct(context);
                                  })
                                  : Utility.showAlertMessage(AlertStringConstants.notAuthorisedToStoreText);
                              return null;

                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: const BoxDecoration(
                                  color: AppColors.greylight,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              child: InkWell(
                                onTap: () async {
                                  manageStoreController.productId.value =
                                      manageStoreController
                                              .storeProductList[index]
                                              .productId ??
                                          "";
                                  await manageStoreController
                                      .apiGetProductDetails();
                                  // SharedPreferenceStorage.setData(
                                  //     "context", context);
                                  // await Navigator.of(context)
                                  //     .push(MaterialPageRoute(
                                  //   builder: (_) => const EditProductScreen(),
                                  // ))
                                  permissionStoreList.any((element) =>
                                  element.isStoreOwner==true )
                                      || permissionStoreList.any((element) => element.controllers!.any((ele) =>
                                      ele.controllerKey == PermissionKey.editProduct.statusName))
                                      ? Get.to(() => const EditProductScreen(),
                                      id: pageIdApp.value)!.then((value) {
                                        manageStoreController.apiGetStoreProducts();
                                        manageStoreController.update();
                                      })
                                      : Utility.showAlertMessage(AlertStringConstants.notAuthorisedToStoreText);


                                },
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: manageStoreController
                                                .storeProductList[index]
                                                .productImages!
                                                .isEmpty
                                            ? Image.asset(
                                                ImageConstants.nopicfound,
                                                color: AppColors.grey
                                                    .withOpacity(0.4),
                                                fit: BoxFit.fill,
                                                height: 100,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.3,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                        color: AppColors.white,
                                                        width: 1)),
                                                child: manageStoreController
                                                                .storeProductList[
                                                                    index]
                                                                .productImages![
                                                                    0]
                                                                .image!
                                                                .dynamicUrl ==
                                                            null ||
                                                        manageStoreController
                                                            .storeProductList[
                                                                index]
                                                            .productImages![0]
                                                            .image!
                                                            .dynamicUrl!
                                                            .isEmpty
                                                    ? Image.asset(
                                                        ImageConstants
                                                            .nopicfound,
                                                        fit: BoxFit.fill,
                                                        height: 100,
                                                        width: WidgetConstants
                                                                .screenWidth *
                                                            0.3,
                                                      )
                                                    : Image.network(
                                                        manageStoreController
                                                            .storeProductList[
                                                                index]
                                                            .productImages![0]
                                                            .image!
                                                            .dynamicUrl
                                                            .toString(),
                                                        fit: BoxFit.fill,
                                                        height: 100,
                                                        width: WidgetConstants
                                                                .screenWidth *
                                                            0.3,
                                                      )),
                                      ),
                                      width12SizedBox,
                                      Flexible(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 190,
                                              child: Text(
                                                manageStoreController
                                                        .storeProductList[index]
                                                        .productName ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            manageStoreController
                                                    .storeProductList[index]
                                                    .description!
                                                    .isEmpty
                                                ? height0SizedBox
                                                : height8SizedBox,
                                            manageStoreController
                                                    .storeProductList[index]
                                                    .description!
                                                    .isEmpty
                                                ? height0SizedBox
                                                : SizedBox(
                                                    width: 190,
                                                    child: Text(
                                                      manageStoreController
                                                              .storeProductList[
                                                                  index]
                                                              .description ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: AppColors
                                                              .blacklight,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                            manageStoreController
                                                    .storeProductList[index]
                                                    .description!
                                                    .isEmpty
                                                ? height0SizedBox
                                                : height8SizedBox,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${StringConstants.unitPriceText}: ",
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      manageStoreController
                                                                  .storeProductList[
                                                                      index]
                                                                  .productPrice ==
                                                              null
                                                          ? ""
                                                          : "\$${manageStoreController.storeProductList[index].productPrice}",
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          color:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Image.asset(
                                                    ImageConstants.circleedit,
                                                    scale: 2.8,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
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
