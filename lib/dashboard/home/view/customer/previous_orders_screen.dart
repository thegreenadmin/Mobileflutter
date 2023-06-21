import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class PreviousOrdersScreen extends StatefulWidget {
  const PreviousOrdersScreen({super.key});

  @override
  State<PreviousOrdersScreen> createState() => _PreviousOrdersScreenState();
}

class _PreviousOrdersScreenState extends State<PreviousOrdersScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: PreferredSize(
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
                              Get.back(id:storeHomeMainController.pageId.value);

                              // Navigator.of(context).pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.previousOrdersText,
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
          )),*/
      body: Container(
          height: WidgetConstants.screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              height5SizedBox,
              Text(
                StringConstants.previousOrdersText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              height20SizedBox,
              Obx(
                () => storeHomeMainController.previousOrderList.isEmpty
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
                           color: AppColors.grey.withOpacity(0.4),
                                ),
                              ),
                              height4SizedBox,
                              Center(
                                child: Text(
                                  StringConstants.noProductFoundText,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )
                    : Expanded(
                        child: GridView.builder(
                          itemCount:
                              storeHomeMainController.previousOrderList.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                (WidgetConstants.screenWidth + 120) /
                                    WidgetConstants.screenHeight,
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 0.0,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () async {},
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
                                          storeHomeMainController
                                                      .previousOrderList[i]
                                                      .productImages!
                                                      .isNotEmpty &&
                                                  storeHomeMainController
                                                          .previousOrderList[i]
                                                          .productImages
                                                          ?.first
                                                          .image
                                                          ?.dynamicUrl !=
                                                      null
                                              ? Image.network(
                                                  storeHomeMainController
                                                      .previousOrderList[i]
                                                      .productImages!
                                                      .first
                                                      .image!
                                                      .dynamicUrl
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                  height: 148,
                                                  width: 148,
                                                )
                                              : Image.asset(
                                                  ImageConstants.nopicfound,
                                                  fit: BoxFit.fill,
                                                  height: 148,
                                                  width: 148,   color: AppColors.grey.withOpacity(0.4),
                                                ),
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
                                                  .previousOrderList[i]
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
                                                  .previousOrderList[i]
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
                                          "Unit price: \$${storeHomeMainController.previousOrderList[i].productPrice ?? ""}",
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
          )),
    );
  }
}
