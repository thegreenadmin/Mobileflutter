import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/controller/offers_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class OfferProductScreen extends StatefulWidget {
  const OfferProductScreen({super.key});

  @override
  State<OfferProductScreen> createState() => _OfferProductScreenState();
}

class _OfferProductScreenState extends State<OfferProductScreen> {
  final OffersController offersController = Get.put(OffersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
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
                                StringConstants.offerProductsText,
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
          )),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: ListView.builder(
              itemCount: offersController.featuredUserProductList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                  width: 80,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: AppColors.primary, width: 0)),
                                  child: CommonWidgets.cachedNetworkImage(
                                    offersController
                                                    .featuredUserProductList[
                                                        index]
                                                    .productImages ==
                                                null ||
                                            offersController
                                                .featuredUserProductList[index]
                                                .productImages!
                                                .isEmpty ||
                                            offersController
                                                    .featuredUserProductList[
                                                        index]
                                                    .productImages![0]
                                                    .image!
                                                    .dynamicUrl ==
                                                null ||
                                            offersController
                                                .featuredUserProductList[index]
                                                .productImages!
                                                .isEmpty
                                        ? ""
                                        : offersController
                                                .featuredUserProductList[index]
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${StringConstants.productNameText}: ${offersController.featuredUserProductList[index].productName}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  offersController
                                          .featuredUserProductList[index]
                                          .description!
                                          .isEmpty
                                      ? height0SizedBox
                                      : Text(
                                          "${StringConstants.descriptionText}: ${offersController.featuredUserProductList[index].description}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                  Text(
                                    "${StringConstants.discountValueText}: " +
                                        offersController
                                            .featuredUserProductList[index]
                                            .discountValue
                                            .toStringAsFixed(2),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    "${StringConstants.offerPriceText}: \$" +
                                        offersController
                                            .featuredUserProductList[index]
                                            .offerPrice
                                            .toStringAsFixed(2),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    "${StringConstants.discountTypeText}: ${offersController.featuredUserProductList[index].discountType}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${StringConstants.featuredProductText}: ",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        offersController
                                                    .featuredUserProductList[
                                                        index]
                                                    .isFeaturedProduct ==
                                                true
                                            ? "Yes"
                                            : "No",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ));
              }),
        ),
      ),
    );
  }
}
