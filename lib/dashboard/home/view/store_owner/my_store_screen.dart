import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  final SearchStoreOwnerController searchStoreOwnerController =
      Get.put(SearchStoreOwnerController());

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
                () => searchStoreOwnerController.getOwnerOfferlist.isEmpty
                    ? searchStoreOwnerController.isLoading.value == true
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
                    : SizedBox(
                        height: 200,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return width8SizedBox;
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: searchStoreOwnerController
                              .getOwnerOfferlist.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: searchStoreOwnerController
                                    .getOwnerOfferlist[index]
                                    .image!
                                    .dynamicUrl!
                                    .isEmpty
                                ? Image.asset(
                                    'assets/nopicfound.png',
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    searchStoreOwnerController
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
                () => searchStoreOwnerController.storeProductList.isEmpty
                    ? height0SizedBox
                    : Text(
                        StringConstants.featuredProductText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 22),
                      ),
              ),
              Obx(
                () => searchStoreOwnerController.storeProductList.isEmpty
                    ? height0SizedBox
                    : SizedBox(
                        height: 280,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return width8SizedBox;
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: searchStoreOwnerController
                              .storeProductList.length,
                          itemBuilder: (BuildContext context, int i) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 180,
                                width: 150,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: searchStoreOwnerController
                                          .storeProductList[i]
                                          .productImages!
                                          .isEmpty
                                      ? Image.asset(
                                          'assets/nopicfound.png',
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          searchStoreOwnerController
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
                                    searchStoreOwnerController
                                            .storeProductList[i].productName ??
                                        "",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  height4SizedBox,
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      searchStoreOwnerController
                                              .storeProductList[i]
                                              .description ??
                                          "",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: AppColors.blacklight,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  height4SizedBox,
                                  Text(
                                    "\$${searchStoreOwnerController.storeProductList[i].productPrice}",
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
