import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/common_models/store_addresses_model.dart' as offer;
import 'package:thegreenmall/dashboard/home/controller/controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/store_home_main_args.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class OfferProductScreen extends StatelessWidget {
  final bool isFromStore;
  final offer.Offer? offerObj;
  final String? storeId;

   OfferProductScreen({
    super.key,
    this.isFromStore = false,
    this.offerObj,
    this.storeId,
  });

  final OffersController offersController = Get.put(OffersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !isFromStore
            ? PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: Container(
                  color: AppColors.primaryLight,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                          fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w600),
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
            : const PreferredSize(preferredSize: Size.fromHeight(80.0), child: SizedBox()),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                      // Get.parameters["isFromHome"] = "false";
                      // Get.parameters["isFromFav"] = "false";
                      // Get.parameters["isFromMenu"] = "true";
                      // Get.parameters["isFromOptions"] = "false";
                      //
                      // Get.parameters["storeId"] = storeId ?? "";
                      //
                      // if(  offerObj?.isOfferForStore == true){
                      //
                      //   Get.parameters["invokedIndex"] = "0";
                      // }else{
                      //   Get.parameters["productId"] =
                      //       offersController.featuredUserProductList[0].productId ?? "";
                      //   Get.parameters["storeId"] =
                      //       offersController.featuredUserProductList[0].storeId ?? "";
                      //   Get.parameters["invokedIndex"] = "2";
                      // }

                      await Get.to(
                        () =>  StoreHomeMainScreen(
                            args:  StoreHomeMainArgs(
                              storeId: offerObj?.isOfferForStore == true? storeId ?? "" : offersController.featuredUserProductList[0].storeId ?? "",

                              productId: offerObj?.isOfferForStore == true
                                  ? null
                                  : offersController.featuredUserProductList[0].productId ?? "",
                              invokedIndex: offerObj?.isOfferForStore == true?0:2,
                              isFromMenu: true,isFromFav: false,
                              isFromHome: false, isFromOptions: false,
                            )
                        ),
                        id: pageIdApp.value,
                      );

                  },
                  child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                  width: WidgetConstants.screenWidth,
                                  height: WidgetConstants.screenHeight * 0.25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: AppColors.primary, width: 0)),
                                  child: CommonWidgets.cachedNetworkImage(
                                    offerObj?.image?.dynamicUrl == null || offerObj!.image!.dynamicUrl!.isEmpty
                                        ? "" : offerObj?.image?.dynamicUrl ?? "",
                                    fit: BoxFit.fill,
                                  )),
                            ),
                            height10SizedBox,
                            Text(
                              offerObj?.offerName ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            height4SizedBox,
                            Text(
                              "${StringConstants.offerTypeText}: ${offerObj?.isOfferForStore == true ? "Store" : "Products"}",
                              style: const TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            height4SizedBox,
                            Text(
                              offerObj?.offerType != null && offerObj!.offerType.toString().contains("per")
                                  ? "${StringConstants.offerPriceText}: ${offerObj?.offerValue}%"
                                  : "${StringConstants.offerPriceText}: \$${offerObj?.offerValue}",
                              style: const TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                ),
                Obx(() {
                  return Visibility(
                    visible: offerObj?.isOfferForStore == false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height10SizedBox,
                        Text(
                          StringConstants.offerProductsText,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                        ),
                        height10SizedBox,
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: offersController.featuredUserProductList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  // Get.parameters["isFromHome"] = "false";
                                  // Get.parameters["isFromFav"] = "false";
                                  // Get.parameters["isFromMenu"] = "true";
                                  // Get.parameters["isFromOptions"] = "false";
                                  // Get.parameters["invokedIndex"] = "2";
                                  // Get.parameters["productId"] =
                                  //     offersController.featuredUserProductList[index].productId ?? "";
                                  // Get.parameters["storeId"] =
                                  //     offersController.featuredUserProductList[index].storeId ?? "";
                                  await Get.to(
                                    () => StoreHomeMainScreen(
                                      args:  StoreHomeMainArgs(
                                        storeId: offersController.featuredUserProductList[index].storeId ?? "",

                                        productId: offersController.featuredUserProductList[index].productId ?? "",
                                        invokedIndex: 2,
                                        isFromMenu: true,isFromFav: false,
                                        isFromHome: false, isFromOptions: false,
                                    ),
                                    ),
                                    id: pageIdApp.value,
                                  );
                                },
                                child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Container(
                                                  width: 100,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(color: AppColors.primary, width: 0)),
                                                  child: CommonWidgets.cachedNetworkImage(
                                                    offersController.featuredUserProductList[index].productImages ==
                                                                null ||
                                                            offersController.featuredUserProductList[index]
                                                                .productImages!.isEmpty ||
                                                            offersController.featuredUserProductList[index]
                                                                    .productImages![0].image!.dynamicUrl ==
                                                                null ||
                                                            offersController
                                                                .featuredUserProductList[index].productImages!.isEmpty
                                                        ? ""
                                                        : offersController.featuredUserProductList[index].productImages!
                                                                .first.image!.dynamicUrl ??
                                                            "",
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                          width20SizedBox,
                                          Flexible(
                                            flex: 6,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                "${StringConstants.productNameText}: ${offersController.featuredUserProductList[index].productName}",
                                                style: const TextStyle(
                                                    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                              height4SizedBox,
                                              offersController.featuredUserProductList[index].description!.isEmpty
                                                  ? height0SizedBox
                                                  : Text(
                                                      "${StringConstants.descriptionText}: ${offersController.featuredUserProductList[index].description}",
                                                      style: const TextStyle(color: Colors.black, fontSize: 12),
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
                                                style: const TextStyle(color: Colors.black, fontSize: 12),
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
                                                style: const TextStyle(color: Colors.black, fontSize: 12),
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
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
