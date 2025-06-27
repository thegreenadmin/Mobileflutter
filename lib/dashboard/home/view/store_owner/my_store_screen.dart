import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_store_product_model.dart';
import 'package:thegreenmall/dashboard/offers/view/add_offer_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import '../../model/user_offers_model.dart';
import 'edit_product_screen.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> with GlobalVarMixin{
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final CarouselSliderController _controllerProducts = CarouselSliderController();

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
              _buildProductsCarousel()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildOfferListCondition() {
    return SizedBox(
      child: Obx(
            () {
          // Deferring state changes to the end of the current frame
          if (ownerStoresController.isLoading.value) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              // Ensure this code is executed after the build phase

            });
          }

          return ownerStoresController.getOwnerOfferList.isEmpty
              ? _buildNoOfferMethod()
              : _buildCarouselSlider();
        },
      ),
    );
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

   _buildProductsCarousel() {
    return  Obx(
          () => ownerStoresController.storeProductList.isEmpty  ?
      height0SizedBox
          : CarouselSlider(
          items: ownerStoresController.storeProductList
            .map(
              (item) =>   _buildStoreProductCard(item),
        ).toList(),
        carouselController: _controllerProducts,
        options: CarouselOptions(
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlayCurve: Curves.fastOutSlowIn,
          viewportFraction: 0.5,
          enlargeCenterPage: false,
          autoPlay: true,
          aspectRatio: 1.4,
        ),
      ),
    );
  }


 /* Obx _buildStoreProductList() {
    return Obx(
      () => ownerStoresController.storeProductList.isEmpty
          ? height0SizedBox
          : SizedBox(
              height: WidgetConstants.screenHeight * 0.3,
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
    );
  }*/

  Column _buildStoreProductCard(Products storeProduct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            // Get.parameters["isFromHome"] = "true";
            // Get.parameters["storeId"] =
            //     storeProduct.storeId;
            // Get.parameters["productId"] =
            //     storeProduct.productId;
            // Get.parameters["categoryName"] = storeProduct.productCategories
            //         ?.first
            //         .category
            //         ?.categoryName ??
            //     "";
            hasStoreAccess.value && permissionStoreList.isEmpty ||
                    permissionStoreList.any((element) =>
                        element.storeId ==
                            storeProduct.storeId &&
                            element.isStoreOwner == true ||
                        element.storeId ==
                            storeProduct.storeId &&
                            element.controllers!.any((ele) =>
                                ele.controllerKey ==
                                PermissionKey.editProduct.statusName))
                ? Get.to(() =>  EditProductScreen(
              isFromHome:true,
              storeId: storeProduct.storeId,
              productId: storeProduct.productId,
              categoryName: storeProduct.productCategories
                  ?.first
                  .category
                  ?.categoryName ??
                  "",
            ),
                        id: pageIdApp.value,
                        /*arguments: {
                        "isFromHome": true,
                        'storeId':
                        storeProduct.storeId
                      }*/
            )!
                    .then((value) =>
                        ownerStoresController.apiGetFeaturedProducts())
                : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CommonWidgets.cachedNetworkImage(
              storeProduct.productImages == null ||
                  storeProduct.productImages!.isEmpty ||
    storeProduct.productImages![0].image!.dynamicUrl ==
                          null ||
                  storeProduct.productImages!.isEmpty
                  ? ""
                  : storeProduct.productImages![0].image!.dynamicUrl
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
              storeProduct.productName ?? "", maxLines: 1,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            storeProduct.description!.isEmpty
                ? height0SizedBox
                : height4SizedBox,
            storeProduct.description!.isEmpty
                ? height0SizedBox
                : SizedBox(
                    width: 130,
                    child: Text(
                      storeProduct.description ?? "",
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.blackLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            storeProduct.description!.isEmpty
                ? height0SizedBox
                : height4SizedBox,
            Text(
              "\$${storeProduct.productPrice!.toStringAsFixed(2)}", maxLines: 1,
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

       _buildCarouselSlider() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ownerStoresController.getOwnerOfferList.isEmpty
            ? SizedBox(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageConstants.greenmall420,
                ),
                Text(
                  StringConstants.welcomeToGreenMallText,
                  style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary),
                )
              ],
            ),
          ),
        )
            : CarouselSlider(
          items:  ownerStoresController.getOwnerOfferList
              .take(5)
              .map((item) => _buildOwnerOfferCard(item))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              autoPlayCurve: Curves.fastOutSlowIn,
              viewportFraction: 1.2,
              enlargeCenterPage: false,
              autoPlay: true,
              aspectRatio: 1.5,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        height5SizedBox,
        Obx(() => ownerStoresController.getOwnerOfferList.isEmpty
            ? height0SizedBox
            : InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ownerStoresController.getOwnerOfferList
                .take(5)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              return GestureDetector(
                onTap: () {
                    _controller.animateToPage(entry.key);
                },
                child: Container(
                  width: _current == entry.key ? 25 : 10,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle,
                      color: _current == entry.key
                          ? AppColors.primary
                          : AppColors.grey),
                ),
              );
            }).toList(),
          ),
        ))
      ]);


 /*  _buildOwnerOfffersList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return width8SizedBox;
        },
        scrollDirection: Axis.horizontal,
        itemCount: ownerStoresController.getOwnerOfferList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildOwnerOfferCard(index);
        });
  }*/

  Stack _buildOwnerOfferCard(OffersList item) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CommonWidgets.cachedNetworkImage(
            item.image?.dynamicUrl ??
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
                    item.offerName ??
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

   _buildNoOfferMethod() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
              Get.to(() =>  AddOfferScreen(isFrom:StringConstants.addOfferText),
                  id: pageIdApp.value,
                 )?.then((v) {
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
      ),
    );
  }
}
