import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class UserProductListScreen extends StatefulWidget {
  const UserProductListScreen({super.key});

  @override
  State<UserProductListScreen> createState() => _UserProductListScreenState();
}

class _UserProductListScreenState extends State<UserProductListScreen>  with GlobalVarMixin{
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return userProductWidget();
  }

  Widget userProductWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storeHomeMainController.categoryName.value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.black),
                ),
                PopupMenuButton(
                  offset: const Offset(0, 25),
                  shape: const TooltipShape(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Image.asset(
                    ImageConstants.productFilter,
                    scale: 2.5,
                  ),
                  onSelected: (String value) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  itemBuilder: (context) =>
                      productFilterCreateOptionsPopUpList(context)!,
                ),
              ],
            ),
          ),
          height10SizedBox,
          Obx(
            () => storeHomeMainController.featureProductList.isEmpty
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
                              StringConstants.noProductFoundText,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                : Expanded(
                    child: GridView.builder(
                      itemCount:
                          storeHomeMainController.featureProductList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (WidgetConstants.screenWidth +
                                WidgetConstants.screenHeight) /
                            WidgetConstants.screenHeight *
                            0.45,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 10.0,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () async {
                            storeHomeMainController.productId.value = storeHomeMainController
                                .featureProductList[i].productId
                                .toString();
                            Get.parameters['productId'] =
                                storeHomeMainController
                                    .featureProductList[i].productId
                                    .toString();

                            Get.parameters['isFromFav'] = "false";
                            Get.parameters["isFromHome"] = "false";
                            Get.parameters['isFromMenu'] = "true";
                            Get.parameters["isFromOptions"] = "false";
                            storeHomeMainController.apiGetUserDetailsApi();
                            if (storeHomeMainController.storeId.value != "" &&
                                storeHomeMainController.productId.value != "") {
                              await  storeHomeMainController.apiGetShopProductDetailApi();
                            }
                            await storeHomeMainController.apiGetUserWalletBalance();
                            storeHomeMainController.invokedIndex.value++;
                          },
                          child: Card(
                            elevation: 0,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CommonWidgets.cachedNetworkImage(
                                        storeHomeMainController
                                                    .featureProductList[i]
                                                    .productImages!
                                                    .isNotEmpty &&
                                                storeHomeMainController
                                                        .featureProductList[i]
                                                        .productImages
                                                        ?.first
                                                        .image
                                                        ?.dynamicUrl !=
                                                    null
                                            ? storeHomeMainController
                                                    .featureProductList[i]
                                                    .productImages
                                                    ?.first
                                                    .image!
                                                    .dynamicUrl ??
                                                ""
                                            : "",
                                        fit: BoxFit.fill,
                                        height:
                                            WidgetConstants.screenHeight * 0.19,
                                        width:
                                            WidgetConstants.screenWidth * 0.4,
                                      ),
                                      /*  storeHomeMainController
                                                  .featureProductList[i]
                                                  .productImages!
                                                  .isNotEmpty &&
                                              storeHomeMainController
                                                      .featureProductList[i]
                                                      .productImages
                                                      ?.first
                                                      .image
                                                      ?.dynamicUrl !=
                                                  null
                                          ? Image.network(
                                              storeHomeMainController
                                                      .featureProductList[i]
                                                      .productImages
                                                      ?.first
                                                      .image!
                                                      .dynamicUrl ??
                                                  "",
                                              fit: BoxFit.fill,
                                              height: 148,
                                              width: 148,
                                            )
                                          : Image.asset(
                                              ImageConstants.defaultProduct,
                                              fit: BoxFit.fill,
                                              height: 148,
                                              width: 148,
                                            ),*/
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: storeHomeMainController
                                                    .featureProductList[i]
                                                    .isFavouriteProduct!.value==
                                                true
                                            ? InkWell(
                                                onTap: () {
                                                  storeHomeMainController
                                                      .featureProductList[i]
                                                      .isFavouriteProduct!.value= false;
                                                  if (storeHomeMainController
                                                          .isLoading.value ==
                                                      false) {
                                                    storeHomeMainController
                                                        .apiRemoveFavouriteProduct(
                                                            storeHomeMainController
                                                                .featureProductList[
                                                                    i]
                                                                .productId);
                                                  }
                                                },
                                                child: Image.asset(
                                                  ImageConstants.liked,
                                                  scale: 3,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  storeHomeMainController
                                                      .featureProductList[i]
                                                      .isFavouriteProduct!.value= true;
                                                  if (storeHomeMainController
                                                          .isLoading.value ==
                                                      false) {
                                                    storeHomeMainController
                                                        .apiCreateFavouriteProduct(
                                                            storeHomeMainController
                                                                .featureProductList[
                                                                    i]
                                                                .productId);
                                                  }
                                                },
                                                child: Image.asset(
                                                  ImageConstants.fav,
                                                  scale: 3,
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                height5SizedBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeHomeMainController
                                              .featureProductList[i]
                                              .productName ??
                                          "",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    storeHomeMainController
                                            .featureProductList[i]
                                            .description!
                                            .isEmpty
                                        ? height0SizedBox
                                        : height4SizedBox,
                                    storeHomeMainController
                                            .featureProductList[i]
                                            .description!
                                            .isEmpty
                                        ? height0SizedBox
                                        : Text(
                                            storeHomeMainController
                                                    .featureProductList[i]
                                                    .description ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: AppColors.blackLight,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                    storeHomeMainController
                                            .featureProductList[i]
                                            .description!
                                            .isEmpty
                                        ? height0SizedBox
                                        : height4SizedBox,
                                    Text(
                                      "${StringConstants.unitPriceText}: \$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>>? productFilterCreateOptionsPopUpList(
      BuildContext cont) {
    return List.generate(2, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.lowToHighText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    await storeHomeMainController.apiFeatureProductListApi(
                        categoryId: storeHomeMainController.categoryId.value,
                        orderBy: "2",
                        orderType: "2");
                    // Navigator.of(contx).pop();
                    Get.back(id: pageIdApp.value);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${StringConstants.priceText} ${StringConstants.lowToHighText.toLowerCase()}",
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return PopupMenuItem<String>(
        value: StringConstants.highToLowText,
        child: SizedBox(
          width: 130,
          child: GestureDetector(
            onTap: () async {
              await storeHomeMainController.apiFeatureProductListApi(
                categoryId: storeHomeMainController.categoryId.value,
                orderBy: "2",
              );
              // Navigator.of(contx).pop();
              Get.back(id: pageIdApp.value);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${StringConstants.priceText} ${StringConstants.highToLowText.toLowerCase()}",
                  style: const TextStyle(
                      color: AppColors.black, fontFamily: "", fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
