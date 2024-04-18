import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class OfferProductScreen extends StatefulWidget {
  final bool isFromStore;
  const OfferProductScreen({super.key, this.isFromStore = false});

  @override
  State<OfferProductScreen> createState() => _OfferProductScreenState();
}

class _OfferProductScreenState extends State<OfferProductScreen> {
  final OffersController offersController = Get.put(OffersController());
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !widget.isFromStore
            ? PreferredSize(
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
                                        Get.back(id: pageIdApp.value);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.black,
                                        size: 24.0,
                                      ),
                                    ),
                                    width10SizedBox,
                                    Text(
                                      StringConstants.offerDetailText,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  ImageConstants.homeMall,
                                  scale: 4,
                                )
                              ]),
                        ],
                      )),
                ))
            : const PreferredSize(
                preferredSize: Size.fromHeight(80.0), child: SizedBox()),
        body: Obx(() => Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                        width: WidgetConstants.screenWidth,
                                        height:
                                            WidgetConstants.screenHeight * 0.25,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: AppColors.primary,
                                                width: 0)),
                                        child: CommonWidgets.cachedNetworkImage(
                                          storeHomeMainController.offerObj.value
                                                          .image?.dynamicUrl ==
                                                      null ||
                                                  storeHomeMainController
                                                      .offerObj
                                                      .value
                                                      .image!
                                                      .dynamicUrl!
                                                      .isEmpty
                                              ? ""
                                              : storeHomeMainController
                                                      .offerObj
                                                      .value
                                                      .image
                                                      ?.dynamicUrl ??
                                                  "",
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                  height10SizedBox,
                                  Text(
                                    storeHomeMainController
                                            .offerObj.value.offerName ??
                                        "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                  height4SizedBox,
                                  Text(
                                    "${StringConstants.offerTypeText}: ${storeHomeMainController.offerObj.value.isOfferForStore == true ? "Store" : "Products"}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                  height4SizedBox,
                                  Text(
                                    storeHomeMainController
                                                    .offerObj.value.offerType !=
                                                null &&
                                            storeHomeMainController
                                                .offerObj.value.offerType
                                                .toString()
                                                .contains("per")
                                        ? "${StringConstants.offerPriceText}: ${storeHomeMainController.offerObj.value.offerValue}%"
                                        : "${StringConstants.offerPriceText}: \$${storeHomeMainController.offerObj.value.offerValue}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              )),
                        )),
                    Visibility(
                      visible: storeHomeMainController
                              .offerObj.value.isOfferForStore ==
                          false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height10SizedBox,
                          Text(
                            StringConstants.offerProductsText,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          height10SizedBox,
                          ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: offersController
                                  .featuredUserProductList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Get.parameters["isFromHome"] = "true";
                                    Get.parameters["isFromFav"] = "false";
                                    Get.parameters["isFromMenu"] = "false";
                                    Get.parameters["isFromOptions"] = "false";
                                    Get.parameters["productId"] =
                                        offersController
                                                .featuredUserProductList[index]
                                                .productId ??
                                            "";
                                    Get.parameters["storeId"] = offersController
                                            .featuredUserProductList[index]
                                            .storeId ??
                                        "";
                                    storeHomeMainController.invokedIndex.value =
                                        3;
                                    Get.to(
                                      () => const StoreHomeMainScreen(),
                                      id: pageIdApp.value,
                                    );
                                  },
                                  child: Card(
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Container(
                                                    width: 100,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .primary,
                                                            width: 0)),
                                                    child: CommonWidgets
                                                        .cachedNetworkImage(
                                                      offersController
                                                                      .featuredUserProductList[
                                                                          index]
                                                                      .productImages ==
                                                                  null ||
                                                              offersController
                                                                  .featuredUserProductList[
                                                                      index]
                                                                  .productImages!
                                                                  .isEmpty ||
                                                              offersController
                                                                      .featuredUserProductList[
                                                                          index]
                                                                      .productImages![
                                                                          0]
                                                                      .image!
                                                                      .dynamicUrl ==
                                                                  null ||
                                                              offersController
                                                                  .featuredUserProductList[
                                                                      index]
                                                                  .productImages!
                                                                  .isEmpty
                                                          ? ""
                                                          : offersController
                                                                  .featuredUserProductList[
                                                                      index]
                                                                  .productImages!
                                                                  .first
                                                                  .image!
                                                                  .dynamicUrl ??
                                                              "",
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                            width20SizedBox,
                                            Flexible(
                                              flex: 6,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${StringConstants.productNameText}: ${offersController.featuredUserProductList[index].productName}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                    height4SizedBox,
                                                    offersController
                                                            .featuredUserProductList[
                                                                index]
                                                            .description!
                                                            .isEmpty
                                                        ? height0SizedBox
                                                        : Text(
                                                            "${StringConstants.descriptionText}: ${offersController.featuredUserProductList[index].description}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
                                                          ),
                                                    height4SizedBox,
                                                    /*  Text(
                                                  "${StringConstants.discountValueText}: ${offersController.featuredUserProductList[index].discountValue.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                                height4SizedBox, */
                                                    Text(
                                                      "${StringConstants.priceText}: \$${offersController.featuredUserProductList[index].offerPrice.toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                    height4SizedBox,
                                                    /* Text(
                                                  "${StringConstants.discountTypeText}: ${offersController.featuredUserProductList[index].discountType}"
                                                      .toTitleCase(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                                height4SizedBox, */
                                                    Text(
                                                      "${StringConstants.featuredProductText}: ${offersController.featuredUserProductList[index].isFeaturedProduct == true ? "Yes" : "No"}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
