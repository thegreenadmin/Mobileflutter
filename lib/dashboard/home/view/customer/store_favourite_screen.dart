import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class StoreFavouriteScreen extends StatefulWidget {
  const StoreFavouriteScreen({super.key});

  @override
  State<StoreFavouriteScreen> createState() => _StoreFavouriteScreenState();
}

class _StoreFavouriteScreenState extends State<StoreFavouriteScreen> {
  final StoreHomeMainController storeHomeMainController =
  Get.isRegistered<StoreHomeMainController>()
      ? Get.find<StoreHomeMainController>()
      : Get.put(StoreHomeMainController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          height15SizedBox,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              StringConstants.favoritesText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          height15SizedBox,
          Expanded(
            child: Obx(() => _buildBody()),
          ),
        ]),
      ),
    );
  }

  GridView _buildGrid() {
    return GridView.builder(
            padding: EdgeInsets.zero,
                  itemCount:
                      storeHomeMainController.featureProductList.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (WidgetConstants.screenHeight * 0.47 +
                            WidgetConstants.screenHeight * 0.22) /
                        WidgetConstants.screenHeight,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    return buildProductCard(i);
                  },
                );
  }

  Column _buildNoData() {
    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: WidgetConstants.screenHeight *0.09,),
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
                            StringConstants.noFavouriteProductFoundText,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 16),
                          ),
                        ),
                      ],
                    );
  }

  Widget _buildBody() {
    if (storeHomeMainController.featureProductList.isEmpty) return _buildNoData();
    return _buildGrid();
  }


  InkWell buildProductCard(int i) {
    return InkWell(onTap: () => storeHomeMainController.openProductFromFav(i),
                      child: Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
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
                                    height:
                                        WidgetConstants.screenHeight * 0.19,
                                    width: WidgetConstants.screenWidth * 0.4,
                                  ),
                                  /*storeHomeMainController
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
                                          // color:
                                          //     AppColors.grey.withOpacity(0.4),
                                        ),*/
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: storeHomeMainController
                                        .featureProductList[i]
                                        .isFavouriteProduct!.value ==
                                        true
                                        ? InkWell(
                                      onTap: () => storeHomeMainController.toggleFavProduct(i),
                                      child: Image.asset(
                                        ImageConstants.liked,
                                        scale: 3,
                                      ),
                                    )
                                        : Image.asset(
                                          ImageConstants.fav,
                                          scale: 3,
                                        ),
                                  ),
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
                                storeHomeMainController.featureProductList[i]
                                        .description!.isEmpty
                                    ? height0SizedBox
                                    : height4SizedBox,
                                storeHomeMainController.featureProductList[i]
                                        .description!.isEmpty
                                    ? height0SizedBox
                                    : Text(
                                        storeHomeMainController
                                                .featureProductList[i]
                                                .description ??
                                            "",
                                        maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                        style: TextStyle(

                                            color: AppColors.blackLight,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                storeHomeMainController.featureProductList[i]
                                        .description!.isEmpty
                                    ? height0SizedBox
                                    : height4SizedBox,
                                Text(
                                  "${StringConstants.unitPriceText}: "
                                  "\$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
                                  overflow: TextOverflow.ellipsis,
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
  }
}
