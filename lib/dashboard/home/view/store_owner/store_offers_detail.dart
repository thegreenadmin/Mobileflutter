import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_offer_detail_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
class StoreOfferDetailScreen extends StatefulWidget {
  const StoreOfferDetailScreen({super.key});

  @override
  State<StoreOfferDetailScreen> createState() => _StoreOfferDetailScreenState();
}

class _StoreOfferDetailScreenState extends State<StoreOfferDetailScreen> {
  final StoreOfferDetailController storeOfferDetailController =
      Get.put(StoreOfferDetailController());

  @override
  initState() {
    super.initState();
    storeOfferDetailController.storeId.value = Get.parameters["storeId"] ?? "";
    storeOfferDetailController.offerId.value = Get.parameters["offerId"] ?? "";
    storeOfferDetailController.apiGetStoreOffersDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                             Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
                                  // Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.offerProductDetailText,
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
                    ])),
          )),
      body: Obx(() => storeOfferDetailController.storeOfferDetailList.isEmpty
          ? storeOfferDetailController.isLoading.value == true
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
                            fontStyle: FontStyle.italic, fontSize: 16),
                      ),
                    ),
                  ],
                )
          : Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              height: 1000,
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return height12SizedBox;
                  },
                  itemCount:
                      storeOfferDetailController.storeOfferDetailList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: const BoxDecoration(
                            color: AppColors.primarylight,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.white, width: 1)),
                                    child: Obx(() => CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage: NetworkImage(
                                              storeOfferDetailController
                                                  .storeOfferDetailList[index]
                                                  .productImages![0]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString()),
                                          backgroundColor: Colors.transparent,
                                        )),
                                  ),
                                  width10SizedBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Obx(() => Text(
                                              storeOfferDetailController
                                                      .storeOfferDetailList[
                                                          index]
                                                      .productName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ),
                                      height4SizedBox,
                                      SizedBox(
                                        width: 200,
                                        child: Obx(() => Row(
                                              children: [
                                                const Text(
                                                  "Product price: ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "\$${storeOfferDetailController.storeOfferDetailList[index].productPrice}",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ),
                                      height4SizedBox,
                                      SizedBox(
                                        width: 200,
                                        child: Obx(() => Row(
                                              children: [
                                                const Text(
                                                  "Offer price: ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "\$${storeOfferDetailController.storeOfferDetailList[index].offerPrice}",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ),
                                      height4SizedBox,
                                      SizedBox(
                                          width: 200,
                                          child: Obx(() => Row(
                                                children: [
                                                  const Text(
                                                    "Offer type: ",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    storeOfferDetailController
                                                        .storeOfferDetailList[
                                                            index]
                                                        .offer!
                                                        .offerType
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ))),
                                      height4SizedBox,
                                      SizedBox(
                                        width: 200,
                                        child: Obx(() => Row(
                                              children: [
                                                const Text(
                                                  "Offer is for: ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  storeOfferDetailController
                                                              .storeOfferDetailList[
                                                                  index]
                                                              .offer!
                                                              .isOfferForStore ==
                                                          true
                                                      ? "Store"
                                                      : "Product",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ),
                                      height4SizedBox,
                                      SizedBox(
                                        width: 250,
                                        child: Obx(() => Row(
                                              children: [
                                                const Text(
                                                  "Offer name: ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  storeOfferDetailController
                                                          .storeOfferDetailList[
                                                              index]
                                                          .offer!
                                                          .offerName ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    );
                  }),
            )),
    );
  }
}
