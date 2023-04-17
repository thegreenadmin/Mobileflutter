import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreFavouriteScreen extends StatefulWidget {
  const StoreFavouriteScreen({super.key});

  @override
  State<StoreFavouriteScreen> createState() => _StoreFavouriteScreenState();
}

class _StoreFavouriteScreenState extends State<StoreFavouriteScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Obx(
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
                              StringConstants.noFavouriteProductFoundText,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                : GridView.builder(
                    itemCount:
                        storeHomeMainController.featureProductList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (WidgetConstants.screenWidth + 120) /
                          WidgetConstants.screenHeight,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onTap: () async {

                          storeHomeMainController.productId.value = storeHomeMainController.featureProductList[i].productId.toString()??"";
                          await storeHomeMainController
                              .apiGetShopProductDetailApi();
                          Get.to(const AddToOrderScreen());
                          await storeHomeMainController.apiGetCartListApi();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
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
                                        ? Image.network(
                                            storeHomeMainController
                                                .featureProductList[i]
                                                .productImages
                                                ?.first
                                                .image
                                                ?.dynamicUrl,
                                            fit: BoxFit.fill,
                                            height: 148,
                                            width: 148,
                                          )
                                        : Image.asset(
                                            ImageConstants.nopicfound,
                                            fit: BoxFit.fill,
                                            height: 148,
                                            width: 148,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: storeHomeMainController
                                                  .featureProductList[i]
                                                  .isFavouriteProduct ==
                                              true
                                          ? Image.asset(
                                              ImageConstants.liked,
                                              scale: 3,
                                            )
                                          : Image.asset(
                                              ImageConstants.fav,
                                              scale: 3,
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            height5SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storeHomeMainController
                                          .featureProductList[i].productName ??
                                      "",
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                height4SizedBox,
                                Text(
                                  storeHomeMainController
                                          .featureProductList[i].description ??
                                      "",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: AppColors.blacklight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                height4SizedBox,
                                Text(
                                  "Unit price: \$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          )),
        ]),
      ),
    );
  }
}
