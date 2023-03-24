import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/add_to_order_screen.dart';
import 'package:thegreenmall/dashboard/home/view/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration:  BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                  const ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image:
                  storeHomeMainController.storeAddress.value.store?.image?.dynamicUrl == null ||
                      storeHomeMainController.storeAddress.value.store!.image!.dynamicUrl!.isEmpty
                      ? const AssetImage(
                      "assets/storeicon.png")
                  as ImageProvider
                      : NetworkImage(
                      storeHomeMainController.storeAddress.value.store?.image?.dynamicUrl.toString() ?? ""),
                ),
              ),
              child: Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 24.0,
                              ),
                            ),
                            storeHomeMainController.storeAddress.value.store?.isFavouriteStore==true?
                            Image.asset(
                              "assets/liked.png",
                              scale: 2.8,
                            ): Image.asset(
                              "assets/favoutline.png",
                              scale: 2.8,
                            ),
                          ]),
                      height10SizedBox,
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.white, width: 1)),
                            child:  CircleAvatar(
                              radius: 28.0,
                              backgroundImage:  storeHomeMainController.storeAddress.value.store?.logo?.dynamicUrl == null ||
                                  storeHomeMainController.storeAddress.value.store!.logo!.dynamicUrl!.isEmpty
                                  ? const AssetImage(
                                  "assets/storeicon.png")
                              as ImageProvider
                                  : NetworkImage(
                                  storeHomeMainController.storeAddress.value.store?.logo?.dynamicUrl.toString() ?? ""),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          width10SizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storeHomeMainController.storeAddress.value.store?.storeName??"",
                                style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              height8SizedBox,
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/loc.png",
                                    color: AppColors.white,
                                    scale: 2,
                                  ),
                                  width4SizedBox,
                                   Text(storeHomeMainController.storeAddress.value.addressLine1??"",
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              height8SizedBox,
                              Text( storeHomeMainController.storeAddress.value.store!.storeTimings!.isNotEmpty?
                              storeHomeMainController.storeAddress.value.store?.storeTimings?.first.is24HoursActive ==false?
                              "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                  "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                  :   StringConstants.storeHoursText:  StringConstants.storeHoursText,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      body: Container(
        // height: ,
        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeHomeMainController.category.value.categoryName??"",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.black),
            ),
            height20SizedBox,
            Obx(()=>
            storeHomeMainController.featureProductList.isEmpty
                ? storeHomeMainController.isLoading.value == true
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
                        StringConstants.noProductFoundText,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 16),
                      ),
                    ),
                  ],
                )
                : Expanded(
                  child: GridView.builder(
                    itemCount: storeHomeMainController.featureProductList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (WidgetConstants.screenWidth + 120) /
                            WidgetConstants.screenHeight,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0,
                        crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: (){
                            // Get.to(const AddToOrderScreen());
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
                                          storeHomeMainController.featureProductList[i].productImages?.first.image?.dynamicUrl!=null
                                          ?Image.network(
                                        storeHomeMainController.featureProductList[i].productImages?.first.image?.dynamicUrl,
                                        fit: BoxFit.fill,height: 148,
                                      ): Image.asset(
                                        'assets/nopicfound.png',
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: storeHomeMainController.featureProductList[i].isFavouriteProduct==true
                                            ?Image.asset(
                                          "assets/liked.png",
                                          scale: 3,
                                        ): Image.asset(
                                          "assets/fav.png",
                                          scale: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              height5SizedBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    storeHomeMainController.featureProductList[i].productName??"",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  height4SizedBox,
                                  Text(
                                    storeHomeMainController.featureProductList[i].description??"",
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: AppColors.blacklight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  height4SizedBox,
                                  Text(
                                    "Unit price: \$${storeHomeMainController.featureProductList[i].productPrice??""}",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
