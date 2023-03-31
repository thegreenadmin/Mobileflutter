import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

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
                "assets/bag.png",
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
                                  fontSize: 20)),
                          TextSpan(
                            text:
                                " ${storeHomeMainController.storeAddress.value.store?.storeName ?? ""}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
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
                                      "assets/nodata.png",
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
                                            child: Image.network(
                                                storeHomeMainController
                                                        .offersList[index]
                                                        .image
                                                        ?.dynamicUrl ??
                                                    "",
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : Image.asset("assets/nopicfound.png"),
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
                    StringConstants.featuredProductText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                ),
              ),
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
                                      "assets/nodata.png",
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
                              return width5SizedBox;
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: storeHomeMainController
                                .featureProductList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    await storeHomeMainController
                                        .apiGetShopProductDetailApi(
                                            productId: storeHomeMainController
                                                .featureProductList[index]
                                                .productId
                                                .toString());
                                    Get.to(const AddToOrderScreen());
                                    await storeHomeMainController
                                        .apiGetCartListApi();
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          storeHomeMainController
                                                      .featureProductList[index]
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
                                              ? Image.network(
                                                  storeHomeMainController
                                                          .featureProductList[
                                                              index]
                                                          .productImages
                                                          ?.first
                                                          .image
                                                          ?.dynamicUrl ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                  height: 180,
                                                )
                                              : Image.asset(
                                                  'assets/nopicfound.png',
                                                  fit: BoxFit.fill,
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeHomeMainController
                                                        .featureProductList[
                                                            index]
                                                        .isFavouriteProduct ==
                                                    true
                                                ? Image.asset(
                                                    "assets/liked.png",
                                                    scale: 3,
                                                  )
                                                : Image.asset(
                                                    "assets/fav.png",
                                                    scale: 3,
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
                                      height4SizedBox,
                                      Text(
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
                                        "Unit price: \$${storeHomeMainController.featureProductList[index].productPrice ?? ""}",
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
