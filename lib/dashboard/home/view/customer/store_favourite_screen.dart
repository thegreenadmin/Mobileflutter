import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                          storeHomeMainController.productId.value =
                              storeHomeMainController
                                  .featureProductList[i].productId
                                  .toString();
                          storeHomeMainController.apiGetShopProductDetailApi();
                          // SharedPreferenceStorage.setData("context", context);
                          storeHomeMainController.apiGetCartListApi();
                          Get.parameters['isFromFav'] = "true";
                          Get.parameters["isFromHome"] = "false";
                          Get.parameters["isFromMenu"] = "false";
                          // await Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (_) => const AddToOrderScreen(),
                          // ));
                          await Get.to(() => const AddToOrderScreen(),
                                  id: pageIdApp.value)
                              ?.then((value) => {
                                    storeHomeMainController
                                        .apiFeatureProductListApi()
                                  });
                          // Get.to(()=>const AddToOrderScreen());
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
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                storeHomeMainController.featureProductList[i]
                                        .description!.isEmpty
                                    ? height0SizedBox
                                    : height4SizedBox,
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
