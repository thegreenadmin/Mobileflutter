import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'edit_product_screen.dart';

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
              _buildOfferListCondition(),
              height20SizedBox,
              _buildFeatureProductText(),
              height15SizedBox,
              _buildStoreProductList()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildOfferListCondition() {
    return SizedBox(
        height: 200,
        child: Obx(
          () => ownerStoresController.getOwnerOfferList.isEmpty
              ? ownerStoresController.isLoading.value == true
                  ? height0SizedBox
                  : _buildNoOfferMethod()
              : _buildOwnerOfffersList(),
        ));
  }

  Obx _buildFeatureProductText() {
    return Obx(
      () => ownerStoresController.storeProductList.isEmpty
          ? height0SizedBox
          : Text(
              StringConstants.featuredProductsText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
    );
  }

  Obx _buildStoreProductList() {
    return Obx(
      () => ownerStoresController.storeProductList.isEmpty
          ? height0SizedBox
          : SizedBox(
              height: WidgetConstants.screenHeight * 0.3,
              child: ScrollLoopAutoScroll(
                scrollDirection: Axis.horizontal,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return width8SizedBox;
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: ownerStoresController.storeProductList.length,
                  itemBuilder: (BuildContext context, int i) =>
                      _buildStoreProductCard(i),
                ),
              ),
            ),
    );
  }

  Column _buildStoreProductCard(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            Get.parameters["isFromHome"] = "true";
            Get.parameters["storeId"] =
                ownerStoresController.storeProductList[i].storeId;
            Get.parameters["productId"] =
                ownerStoresController.storeProductList[i].productId;
            Get.parameters["categoryName"] = ownerStoresController
                    .storeProductList[i]
                    .productCategories
                    ?.first
                    .category
                    ?.categoryName ??
                "";
            hasStoreAccess.value && permissionStoreList.isEmpty ||
                    permissionStoreList.any((element) =>
                        element.storeId ==
                                ownerStoresController
                                    .storeProductList[i].storeId &&
                            element.isStoreOwner == true ||
                        element.storeId ==
                                ownerStoresController
                                    .storeProductList[i].storeId &&
                            element.controllers!.any((ele) =>
                                ele.controllerKey ==
                                PermissionKey.editProduct.statusName))
                ? Get.to(() => const EditProductScreen(),
                        id: pageIdApp.value,
                        arguments: {
                        "isFromHome": true,
                        'storeId':
                            ownerStoresController.storeProductList[i].storeId
                      })!
                    .then((value) =>
                        ownerStoresController.apiGetFeaturedProducts())
                : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CommonWidgets.cachedNetworkImage(
              ownerStoresController.storeProductList[i].productImages == null ||
                      ownerStoresController
                          .storeProductList[i].productImages!.isEmpty ||
                      ownerStoresController.storeProductList[i]
                              .productImages![0].image!.dynamicUrl ==
                          null ||
                      ownerStoresController
                          .storeProductList[i].productImages!.isEmpty
                  ? ""
                  : ownerStoresController
                      .storeProductList[i].productImages![0].image!.dynamicUrl
                      .toString(),
              fit: BoxFit.fill,
              height: WidgetConstants.screenHeight * 0.18,
              width: WidgetConstants.screenWidth * 0.35,
            ),
          ),
        ),
        height8SizedBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ownerStoresController.storeProductList[i].productName ?? "",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            ownerStoresController.storeProductList[i].description!.isEmpty
                ? height0SizedBox
                : height4SizedBox,
            ownerStoresController.storeProductList[i].description!.isEmpty
                ? height0SizedBox
                : SizedBox(
                    width: 130,
                    child: Text(
                      ownerStoresController.storeProductList[i].description ??
                          "",
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.blacklight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            ownerStoresController.storeProductList[i].description!.isEmpty
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
    );
  }

  ScrollLoopAutoScroll _buildOwnerOfffersList() {
    return ScrollLoopAutoScroll(
      scrollDirection: Axis.horizontal,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return width8SizedBox;
          },
          scrollDirection: Axis.horizontal,
          itemCount: ownerStoresController.getOwnerOfferList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _buildOwnerOfferCard(index);
          }),
    );
  }

  Stack _buildOwnerOfferCard(int index) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CommonWidgets.cachedNetworkImage(
            ownerStoresController.getOwnerOfferList[index].image?.dynamicUrl ??
                "",
            fit: BoxFit.cover,
            height: WidgetConstants.screenHeight * 0.3,
            width: WidgetConstants.screenWidth * 0.87,
          ),
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
                  left: 12.0, right: 12, bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ownerStoresController.getOwnerOfferList[index].offerName ??
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
  }

  Column _buildNoOfferMethod() {
    return Column(
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
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
        ),
        height30SizedBox,
        CustomButton(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary],
          ),
          onTap: () {
            Get.parameters["isFrom"] = StringConstants.addOfferText;
            Get.to(() => const AddOfferScreen(),
                id: pageIdApp.value,
                arguments: {
                  "isFrom": StringConstants.addOfferText,
                })?.then((v) {
              ownerStoresController.getApiData();
              ownerStoresController.getCurrentLocation();
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
    );
  }
}
