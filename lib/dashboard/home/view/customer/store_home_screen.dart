import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/common_models/store_addresses_model.dart'
as offer;
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> with GlobalVarMixin {
  final StoreHomeMainController storeHomeMainController = Get.put(StoreHomeMainController());

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
              Center(
                  child: Image.asset(
                    ImageConstants.bag,
                    scale: 3,
                  )),
              height5SizedBox,
              Obx(
                    () =>
                    Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        TextSpan(
                          children: [
                            TextSpan(
                                text: StringConstants.welcomeToText,
                                style: TextStyle(
                                    color: AppColors.blackLight,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18)),
                            TextSpan(
                              text:
                              " ${storeHomeMainController.storeDetailsResponse.value.data?.store?.storeName ?? ""}",
                              style: const TextStyle(

                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
              height20SizedBox,
              _buildCarouselSlider(offersCarouselList: storeHomeMainController.offersList),
              height20SizedBox,
              GetX<StoreHomeMainController>(
                builder: (controller) =>
                    Visibility(
                      visible:
                      controller.featureProductList.isNotEmpty &&
                          controller.isLoading.value == false,
                      child: Text(
                        StringConstants.featuredProductsText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
              ),
              height12SizedBox,
              _buildFeatureProducts(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFeatureProducts() {
    return Obx(() {
      if (storeHomeMainController.isLoading.value) {
        return const SizedBox.shrink();
      }

      if (storeHomeMainController.featureProductList.isEmpty) {
        return SizedBox(
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageConstants.nodata, scale: 8),
              height4SizedBox,
               Text(
                StringConstants.noProductFoundText,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: 280,
        child: _buildProductsCarousel(),
      );
    });
  }

  _buildProductsCarousel() {
    return Obx(() {
      return CarouselSlider(
        key: UniqueKey(),
        items: storeHomeMainController.featureProductList
            .map(
              (item) =>
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      storeHomeMainController.storeId.value = item.storeId.toString();
                      storeHomeMainController.productId.value = item.productId.toString();
                      storeHomeMainController.isFromFav.value = false;
                      storeHomeMainController.isFromHome.value = true;
                      storeHomeMainController.isFromMenu.value = false;
                      storeHomeMainController.isFromOptions.value = false;
                      Get.parameters["productId"] = item.productId.toString();
                      Get.parameters['isFromFav'] = "false";
                      Get.parameters["isFromHome"] = "true";
                      Get.parameters["isFromMenu"] = "false";
                      Get.parameters["isFromOptions"] = "false";

                      await storeHomeMainController.openProductDetail(
                        targetInvokedIndex: 1,
                        loadData: () async {
                          await storeHomeMainController.apiGetUserDetailsApi();
                          if (storeHomeMainController.storeId.value != "" &&
                              storeHomeMainController.productId.value != "") {
                            await storeHomeMainController
                                .apiGetShopProductDetailApi();
                          }
                          await storeHomeMainController
                              .apiGetUserWalletBalance();
                        },
                      );
                      storeHomeMainController.update();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CommonWidgets.cachedNetworkImage(
                              item.productImages!.isNotEmpty &&
                                  item.productImages?.first.image
                                      ?.dynamicUrl !=
                                      null
                                  ? item.productImages?.first.image?.dynamicUrl ??
                                  ""
                                  : "",
                              fit: BoxFit.fill,
                              height: WidgetConstants.screenHeight * 0.20,
                              width: WidgetConstants.screenWidth * 0.4,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:

                                InkWell(
                                  onTap: () {
                                    // Check if user is guest - show modal and prevent API call
                                    if (isGuest.value == true) {
                                      GuestAccessModal.show(
                                        title: "Login Required",
                                        message: "Please login to add products to favourites",
                                        onContinueAsGuest: () {
                                          // Allow guest to continue - just close modal
                                        },
                                      );
                                      return; // Don't toggle or make API call
                                    }

                                    if (!storeHomeMainController.isLoading.value) {
                                      item.isFavouriteProduct!.value = !item.isFavouriteProduct!.value; // Toggle
                                      if (item.isFavouriteProduct!.value) {
                                        storeHomeMainController.apiCreateFavouriteProduct(item.productId);
                                      } else {
                                        storeHomeMainController.apiRemoveFavouriteProduct(item.productId);
                                      }
                                    }
                                  },
                                  child: Image.asset(
                                    item.isFavouriteProduct!.value
                                        ? ImageConstants.liked : ImageConstants.fav,
                                    scale: 3,
                                  ),
                                )
                              /*item.isFavouriteProduct!.value == true
                                  ? InkWell(
                                onTap: () {
                                  item.isFavouriteProduct!.value = false;
                                  if (storeHomeMainController
                                      .isLoading.value ==
                                      false) {
                                    storeHomeMainController
                                        .apiRemoveFavouriteProduct(
                                        item.productId);
                                  }
                                },
                                child: Image.asset(
                                  ImageConstants.liked,
                                  scale: 3,
                                ),
                              )
                                  : InkWell(
                                onTap: () {
                                  item.isFavouriteProduct!.value = true;
                                  if (storeHomeMainController
                                      .isLoading.value ==
                                      false) {
                                    storeHomeMainController
                                        .apiCreateFavouriteProduct(
                                        item.productId);
                                  }
                                },
                                child: Image.asset(
                                  ImageConstants.fav,
                                  scale: 3,
                                ),
                              ),*/
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        item.description!.isEmpty
                            ? height0SizedBox
                            : height4SizedBox,
                        item.description!.isEmpty
                            ? height0SizedBox
                            : Text(
                          item.description ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              color: AppColors.blackLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        Text(
                          "${StringConstants.unitPriceText}: \$${item.productPrice ?? ""}",
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
        ).toList(),
        carouselController: _controllerProducts,
        options: CarouselOptions(
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlayCurve: Curves.fastOutSlowIn,
          viewportFraction: 0.5,
          enlargeCenterPage: false,
          autoPlay: true,
          aspectRatio: 1.5,
        ),
      );
    });
  }

  _buildCarouselSlider({RxList<offer.Offer>? offersCarouselList}) =>
      Obx(() =>
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            offersCarouselList!.isEmpty
                ? storeHomeMainController.isLoading.value == true
                ? height0SizedBox
                : _buildNoOffers()
                : CarouselSlider(
              items: offersCarouselList
                  .take(5)
                  .map((item) =>
                  InkWell(
                    onTap: () async {
                      if (storeHomeMainController.isLoading.value == false) {
                        storeHomeMainController.storeId.value = item.storeId.toString();
                        storeHomeMainController.offerObj.value = item;
                        storeHomeMainController.invokedIndex.value = item.isOfferForStore == true ? 0 : 2;
                        if (item.isOfferForStore == false) {
                          await storeHomeMainController.offersController.apiGetOffersProducts(
                              offerId: item.offerId.toString(),
                              storeId: item.storeId.toString()).then((v) {
                            storeHomeMainController.productId.value =
                                storeHomeMainController.offersController.featuredUserProductList.first.productId ?? "0";
                          });
                          storeHomeMainController.selectedIndex.value = 1;
                          if (storeHomeMainController.storeId.value != "" &&
                              storeHomeMainController.productId.value != "") {
                            storeHomeMainController.apiGetShopProductDetailApi();
                          }
                        } else {
                          storeHomeMainController.selectedIndex.value = 1;
                          storeHomeMainController.apiGetStoreCategoriesApi();
                        }
                      }
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CommonWidgets.cachedNetworkImage(
                                    item.image?.dynamicUrl.toString() ??
                                        "",
                                    assetImg: ImageConstants.nopicfound,
                                    height: WidgetConstants.screenHeight *
                                        0.28,
                                    width: WidgetConstants.screenWidth *
                                        0.85),
                              ),
                              Positioned(
                                bottom: 0.0,
                                child: Center(
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
                                      child: Text(
                                        item.offerName ?? "",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                  ))
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
                    storeHomeMainController.currentIndex.value = index;
                  }),
            ),
            height5SizedBox,
            Obx(() =>
            offersCarouselList.isEmpty
                ? height0SizedBox
                : InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: offersCarouselList
                    .take(5)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  return GestureDetector(
                    onTap: () {
                      if (storeHomeMainController.isLoading.value == false) {
                        _controller.animateToPage(entry.key);
                      }
                    },
                    child: Container(
                      width: storeHomeMainController.currentIndex.value ==
                          entry.key
                          ? 25
                          : 10,
                      height: 5.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          shape: BoxShape.rectangle,
                          color: storeHomeMainController.currentIndex.value ==
                              entry.key
                              ? AppColors.primary
                              : AppColors.grey),
                    ),
                  );
                }).toList(),
              ),
            ))
          ]));

  _buildNoOffers() {
    return SizedBox(
      height: WidgetConstants.screenHeight *
          0.28,
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
        ],
      ),
    );
  }
}
