import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  child: Obx(
                    () => ownerStoresController.getOwnerOfferlist.isEmpty
                        ? ownerStoresController.isLoading.value == true
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
                                  height30SizedBox,
                                  CustomButton(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primary
                                      ],
                                    ),
                                    onTap: () {
                                      Get.parameters["isFrom"] =
                                          StringConstants.addOfferText;
                                      // SharedPreferenceStorage.setData(
                                      //     "context", context);
                                      // Navigator.of(context)
                                      //     .push(MaterialPageRoute(
                                      //   builder: (_) => const AddOfferScreen(),
                                      // ))
                                          Get.to(const AddOfferScreen(),
                                              id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ),
                                              arguments: {
                                            "isFrom": StringConstants.addOfferText,
                                          })?.then((v) {
                                        ownerStoresController.getApiData();
                                      });
                                    },
                                    height: 50,
                                    width: WidgetConstants.screenWidth * 0.3,
                                    text: StringConstants.addOfferText,
                                    borderRadius: 12,
                                    fontWeight: FontWeight.w500,
                                    iconL: false,
                                    fontSize: 16,
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
                                ownerStoresController.getOwnerOfferlist.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ownerStoresController.getOwnerOfferlist[index]
                                                  .image?.dynamicUrl !=
                                              null &&
                                          ownerStoresController
                                                  .getOwnerOfferlist[index]
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
                                                ownerStoresController
                                                        .getOwnerOfferlist[
                                                            index]
                                                        .image
                                                        ?.dynamicUrl ??
                                                    "",
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : Image.asset(
                                          ImageConstants.nopicfound,   color: AppColors.grey.withOpacity(0.4),
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
                                              ownerStoresController
                                                      .getOwnerOfferlist[index]
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
                () => ownerStoresController.storeProductList.isEmpty
                    ? height0SizedBox
                    : Text(
                        StringConstants.featuredProductsText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
              ),
              height15SizedBox,
              Obx(
                () => ownerStoresController.storeProductList.isEmpty
                    ? height0SizedBox
                    : SizedBox(
                        height: 280,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return width10SizedBox;
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              ownerStoresController.storeProductList.length,
                          itemBuilder: (BuildContext context, int i) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 150,
                                width: 140,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ownerStoresController
                                          .storeProductList[i]
                                          .productImages!
                                          .isEmpty
                                      ? Image.asset(
                                          ImageConstants.nopicfound,   color: AppColors.grey.withOpacity(0.4),
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          ownerStoresController
                                              .storeProductList[i]
                                              .productImages![0]
                                              .image!
                                              .dynamicUrl
                                              .toString(),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              height8SizedBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ownerStoresController
                                            .storeProductList[i].productName ??
                                        "",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  ownerStoresController.storeProductList[i]
                                          .description!.isEmpty
                                      ? height0SizedBox
                                      : height4SizedBox,
                                  ownerStoresController.storeProductList[i]
                                          .description!.isEmpty
                                      ? height0SizedBox
                                      : SizedBox(
                                          width: 130,
                                          child: Text(
                                            ownerStoresController
                                                    .storeProductList[i]
                                                    .description ??
                                                "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: AppColors.blacklight,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                  ownerStoresController.storeProductList[i]
                                          .description!.isEmpty
                                      ? height0SizedBox
                                      : height4SizedBox,
                                  Text(
                                    "\$${ownerStoresController.storeProductList[i].productPrice!.toStringAsFixed(2)}",
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
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
