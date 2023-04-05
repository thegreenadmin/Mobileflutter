import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/components/user_store_order_appbar.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';

class UserProductListScreen extends StatefulWidget {
  const UserProductListScreen({super.key});

  @override
  State<UserProductListScreen> createState() => _UserProductListScreenState();
}

class _UserProductListScreenState extends State<UserProductListScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const UserStoreOrderAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  storeHomeMainController.category.value.categoryName ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: AppColors.black),
                ),
                PopupMenuButton(
                  offset: const Offset(0, 25),
                  shape: const TooltipShape(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Image.asset(
                    ImageConstants.productFilter,
                    scale: 2.5,
                  ),
                  onSelected: (String value) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  itemBuilder: (context) =>
                      createOptionsPopUpList(Get.context)!,
                ),
                // InkWell(
                //     onTap: (){
                //
                //     },
                //     child: Image.asset(ImageConstants.productFilter,scale: 2.5,))
              ],
            ),
            height20SizedBox,
            Obx(
              () => storeHomeMainController.featureProductList.isEmpty
                  ? storeHomeMainController.isLoading.value == true
                      ? height0SizedBox
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                ImageConstants.nopicfound,
                                scale: 8,
                                color: AppColors.primary,
                              ),
                            ),
                            height4SizedBox,
                            Center(
                              child: Text(
                                StringConstants.noProductFoundText,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : Expanded(
                      child: GridView.builder(
                        itemCount:
                            storeHomeMainController.featureProductList.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              (WidgetConstants.screenWidth + 120) /
                                  WidgetConstants.screenHeight,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () async {
                              await storeHomeMainController
                                  .apiGetShopProductDetailApi(
                                      productId: storeHomeMainController
                                          .featureProductList[i].productId
                                          .toString());
                              Get.to(const AddToOrderScreen());
                              await storeHomeMainController.apiGetCartListApi();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        storeHomeMainController.featureProductList[i].productImages!.isNotEmpty &&
                                                storeHomeMainController.featureProductList[i].productImages?.first.image
                                                        ?.dynamicUrl != null
                                            ? Image.network(
                                                storeHomeMainController.featureProductList[i].productImages?.first.image?.dynamicUrl,
                                                fit: BoxFit.fill,
                                                height: 148,
                                              )
                                            : Image.asset(
                                                ImageConstants.nopicfound,
                                                fit: BoxFit.fill,
                                                height: 148,
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: storeHomeMainController.featureProductList[i].isFavouriteProduct == true
                                              ? InkWell(onTap: (){
                                                storeHomeMainController.
                                                apiRemoveFavouriteProduct(storeHomeMainController
                                                    .featureProductList[i].productId);
                                                },
                                                child: Image.asset(
                                                    ImageConstants.liked,
                                                    scale: 3,
                                                  ),
                                              )
                                              :InkWell(onTap: (){
                                                 storeHomeMainController.apiCreateFavouriteProduct(storeHomeMainController
                                                .featureProductList[i].productId);},
                                                child: Image.asset(
                                                    ImageConstants.fav,
                                                    scale: 3,
                                                  ),
                                              ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                height5SizedBox,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storeHomeMainController
                                                .featureProductList[i]
                                                .productName ??
                                            "",
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      height4SizedBox,
                                      Text(
                                        storeHomeMainController
                                                .featureProductList[i]
                                                .description ??
                                            "",
                                        maxLines: 2,
                                        style: TextStyle(
                                            overflow: TextOverflow.visible,
                                            color: AppColors.blacklight,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      height4SizedBox,
                                      Text(
                                        "Unit price: \$${storeHomeMainController.featureProductList[i].productPrice ?? ""}",
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
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>>? createOptionsPopUpList(context) {
    return List.generate(2, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.lowToHighText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    await storeHomeMainController.apiFeatureProductListApi(
                        categoryId:
                            storeHomeMainController.category.value.categoryId ??
                                "0",
                        orderBy: "2",
                        orderType: "2");
                    Get.back();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${StringConstants.priceText} ${StringConstants.lowToHighText.toLowerCase()}",
                        style:  TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return PopupMenuItem<String>(
        value: StringConstants.highToLowText,
        child: SizedBox(
          width: 130,
          child: GestureDetector(
            onTap: () async {
              await storeHomeMainController.apiFeatureProductListApi(
                categoryId:
                    storeHomeMainController.category.value.categoryId ?? "0",
                orderBy: "2",
              );
              Get.back();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${StringConstants.priceText} ${StringConstants.highToLowText.toLowerCase()}",
                  style: const TextStyle(
                      color: AppColors.black, fontFamily: "", fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
