import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_product_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with GlobalVarMixin{
  final ManageStoreController manageStoreController =
      Get.put(ManageStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

   _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppbar(),
            Expanded(child:Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${StringConstants.viewText} ${StringConstants.productText}s",
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
                                    manageStoreController.storeId.value &&
                                    element.isStoreOwner == true ||
                                    element.storeId ==
                                        manageStoreController.storeId.value
                                            .toString() &&
                                        element.controllers!.any((ele) =>
                                        ele.controllerKey ==
                                            PermissionKey
                                                .createProduct.statusName))
                                ? Get.to(() =>  AddNewProductScreen(
                              categoryName: manageStoreController.categoryName.value,categoryId: manageStoreController.categoryId.value,
                            ),
                                id: pageIdApp.value)
                                ?.then((value) {
                              manageStoreController.apiGetStoreProducts();
                            })
                                : Utility.showAlertMessage(
                                AlertStringConstants.notAuthorizedToStoreText);
                            manageStoreController.resetForm();
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
                          : _buildNoDataMethod()
                          : _buildListViewMethod())),
                ],
              ),
            ), ),

          ],
        ),
      ],
    );
  }

  ListView _buildListViewMethod() {
    return ListView.separated(
        padding: EdgeInsets.zero,
                    separatorBuilder: (BuildContext context, int index) {
                      return height12SizedBox;
                    },
                    itemCount:
                        manageStoreController.storeProductList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildListCard(index);
                    });
  }

  Dismissible _buildListCard(int index) {
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
                                    element.storeId == manageStoreController.storeId.value &&
                                        element.isStoreOwner == true ||
                                    element.storeId ==
                                            manageStoreController.storeId.value
                                                .toString() &&
                                        element.controllers!.any((ele) =>
                                            ele.controllerKey ==
                                            PermissionKey
                                                .editProduct.statusName))
                            ? Utility.showConfirmAlertMessage(
                                AlertStringConstants.areYouSureText,
                                okay: StringConstants.deleteText,
                                okayTap: () {
                                // Navigator.pop(Get.context!);
                                manageStoreController.productId.value =
                                    manageStoreController
                                        .storeProductList[index].productId
                                        .toString();
                                manageStoreController.apiDeleteProduct();
                              })
                            : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                        return null;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            )),
                        child: InkWell(
                          onTap: () {
                            manageStoreController.productId.value =
                                manageStoreController
                                        .storeProductList[index]
                                        .productId ??
                                    "";
                            manageStoreController.apiGetProductDetails();

                            hasStoreAccess.value && permissionStoreList.isEmpty ||
                                    permissionStoreList.any((element) =>
                                        element.storeId ==
                                                manageStoreController
                                                    .storeId.value &&
                                            element.isStoreOwner ==
                                                true ||
                                        element.storeId ==
                                                manageStoreController
                                                    .storeId.value
                                                    .toString() &&
                                            element.controllers!.any((ele) =>
                                                ele.controllerKey ==
                                                PermissionKey.editProduct
                                                    .statusName))
                                ? Get.to(() =>  EditProductScreen(
                              storeId: manageStoreController.storeId.value,
                              productId: manageStoreController
                                  .storeProductList[index]
                                  .productId ??
                                  "",
                              categoryName: manageStoreController.categoryName.value,
                            ), id: pageIdApp.value)!.then((value) {
                                    manageStoreController
                                        .apiGetStoreProducts();
                                    manageStoreController.update();
                                  })
                                : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                          },
                          child: Column(children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: AppColors.white,
                                              width: 1)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        child: CommonWidgets
                                            .cachedNetworkImage(
                                          manageStoreController
                                                          .storeProductList[
                                                              index]
                                                          .productImages ==
                                                      null ||
                                                  manageStoreController
                                                      .storeProductList[
                                                          index]
                                                      .productImages!
                                                      .isEmpty ||
                                                  manageStoreController
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
                                                      .productImages!
                                                      .isEmpty
                                              ? ""
                                              : manageStoreController
                                                  .storeProductList[index]
                                                  .productImages![0]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                          fit: BoxFit.fill,
                                          height: 100.0,
                                          width: WidgetConstants
                                                  .screenWidth *
                                              0.3,
                                        ),
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
                                          : Text(
                                              manageStoreController
                                                      .storeProductList[
                                                          index]
                                                      .description ??
                                                  "",
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors
                                                      .blackLight,
                                                  fontWeight:
                                                      FontWeight.w400),
                                            ),
                                      manageStoreController
                                              .storeProductList[index]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : height5SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${StringConstants.unitPriceText}: ",
                                                overflow:
                                                    TextOverflow.visible,
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
                                                    : "\$${manageStoreController.storeProductList[index].productPrice.toStringAsFixed(2)}",
                                                overflow:
                                                    TextOverflow.visible,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color:
                                                        AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          Image.asset(
                                            ImageConstants.circleedit,
                                            scale: 2.8,
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
  }

  Column _buildNoDataMethod() {
    return Column(
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
                      );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
      preferredSize:  Size.fromHeight(WidgetConstants.screenHeight*0.125),
      child: Container(
        color: AppColors.primaryLight,
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20, top: 50,bottom: 10),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConstants.homeMall,
                            scale: 4,
                          ),
                          width10SizedBox,
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
                              Obx(() => Text(
                                    manageStoreController.categoryName.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ]),
                height20SizedBox,
              ],
            )),
      ),
    );
  }
}
