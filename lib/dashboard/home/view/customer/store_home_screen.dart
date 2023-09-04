import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                ImageConstants.bag,
                scale: 3,
              )),
              height5SizedBox,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.welcomeToText,
                              style: TextStyle(
                                  color: AppColors.blacklight,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18)),
                          TextSpan(
                            text:
                                " ${storeHomeMainController.storeDetailsResponse.value.data?.store?.storeName ?? ""}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              height20SizedBox,
              SizedBox(
                  height: 200,
                  child: Obx(
                    () => storeHomeMainController.offersList.isEmpty
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
                                      StringConstants.noOffersFoundText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return width8SizedBox;
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                storeHomeMainController.offersList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  storeHomeMainController.offersList[index]
                                                  .image?.dynamicUrl !=
                                              null &&
                                          storeHomeMainController
                                                  .offersList[index]
                                                  .image
                                                  ?.dynamicUrl !=
                                              ""
                                      ? SizedBox(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CommonWidgets
                                                .cachedNetworkImage(
                                                    storeHomeMainController
                                                            .offersList[index]
                                                            .image
                                                            ?.dynamicUrl ??
                                                        "",
                                                    fit: BoxFit.cover),
                                          ),
                                        )
                                      : Image.asset(
                                          ImageConstants.nopicfound,
                                          color:
                                              AppColors.grey.withOpacity(0.4),
                                        ),
                                  SizedBox(
                                    height: 55,
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                      color: Colors.white,
                                      elevation: 2.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12,
                                            bottom: 10,
                                            top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              storeHomeMainController
                                                      .offersList[index]
                                                      .offerName ??
                                                  "",
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                  )),
              height20SizedBox,
              Obx(
                () => Visibility(
                  visible:
                      storeHomeMainController.featureProductList.isNotEmpty &&
                          storeHomeMainController.isLoading.value == false,
                  child: Text(
                    StringConstants.featuredProductsText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
              height12SizedBox,
              Obx(
                () => Visibility(
                  visible:
                      storeHomeMainController.featureProductList.isNotEmpty &&
                          storeHomeMainController.isLoading.value == false,
                  child: SizedBox(
                    height: 280,
                    child: storeHomeMainController.featureProductList.isEmpty
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
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return width8SizedBox;
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: storeHomeMainController
                                .featureProductList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    storeHomeMainController.productId.value =
                                        storeHomeMainController
                                            .featureProductList[index].productId
                                            .toString();
                                    Get.parameters["productId"] =
                                        storeHomeMainController
                                            .featureProductList[index].productId
                                            .toString();
                                    Get.parameters['isFromFav'] = "false";
                                    Get.parameters["isFromHome"] = "true";
                                    Get.parameters["isFromMenu"] = "false";
                                    Get.to(() => const AddToOrderScreen(),
                                        id: pageIdApp.value);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CommonWidgets.cachedNetworkImage(
                                            storeHomeMainController
                                                        .featureProductList[
                                                            index]
                                                        .productImages!
                                                        .isNotEmpty &&
                                                    storeHomeMainController
                                                            .featureProductList[
                                                                index]
                                                            .productImages
                                                            ?.first
                                                            .image
                                                            ?.dynamicUrl !=
                                                        null
                                                ? storeHomeMainController
                                                        .featureProductList[
                                                            index]
                                                        .productImages
                                                        ?.first
                                                        .image
                                                        ?.dynamicUrl ??
                                                    ""
                                                : "",
                                            fit: BoxFit.fill,
                                            height:
                                                WidgetConstants.screenHeight *
                                                    0.22,
                                            width: WidgetConstants.screenWidth *
                                                0.4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeHomeMainController
                                                        .featureProductList[
                                                            index]
                                                        .isFavouriteProduct ==
                                                    true
                                                ? InkWell(
                                                    onTap: () {
                                                      if (storeHomeMainController
                                                              .isLoading
                                                              .value ==
                                                          false) {
                                                        storeHomeMainController
                                                            .apiRemoveFavouriteProduct(
                                                                storeHomeMainController
                                                                    .featureProductList[
                                                                        index]
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
                                                      if (storeHomeMainController
                                                              .isLoading
                                                              .value ==
                                                          false) {
                                                        storeHomeMainController
                                                            .apiCreateFavouriteProduct(
                                                                storeHomeMainController
                                                                    .featureProductList[
                                                                        index]
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
                                  ),
                                ),
                                height8SizedBox,
                                SizedBox(
                                  width: WidgetConstants.screenWidth * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storeHomeMainController
                                                .featureProductList[index]
                                                .productName ??
                                            "",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      storeHomeMainController
                                              .featureProductList[index]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : height4SizedBox,
                                      storeHomeMainController
                                              .featureProductList[index]
                                              .description!
                                              .isEmpty
                                          ? height0SizedBox
                                          : Text(
                                              storeHomeMainController
                                                      .featureProductList[index]
                                                      .description ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: AppColors.blacklight,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                      height4SizedBox,
                                      Text(
                                        "${StringConstants.unitPriceText}: \$${storeHomeMainController.featureProductList[index].productPrice ?? ""}",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
