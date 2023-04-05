import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
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
              Obx(
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
                            ],
                          )
                    : SizedBox(
                        height: 200,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return width8SizedBox;
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              ownerStoresController.getOwnerOfferlist.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: ownerStoresController
                                    .getOwnerOfferlist[index]
                                    .image!
                                    .dynamicUrl!
                                    .isEmpty
                                ? Image.asset(
                                    ImageConstants.nopicfound,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    ownerStoresController
                                        .getOwnerOfferlist[index]
                                        .image!
                                        .dynamicUrl!,
                                    fit: BoxFit.fill,
                                    width: WidgetConstants.screenWidth * 0.8,
                                  ),
                          ),
                        ),
                      ),
              ),
              height30SizedBox,
              Obx(
                () => ownerStoresController.storeProductList.isEmpty
                    ? height0SizedBox
                    : Text(
                        StringConstants.featuredProductText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 22),
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
                                          ImageConstants.nopicfound,
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
                                  height4SizedBox,
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      ownerStoresController.storeProductList[i]
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
                                  height4SizedBox,
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
