import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
      body: Container(
          height: WidgetConstants.screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height5SizedBox,
              Text(
                StringConstants.previousOrdersText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
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
                              height60SizedBox,
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
                                  StringConstants.noOrdersFoundText,
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
                                (WidgetConstants.screenWidth + 200) /
                                    WidgetConstants.screenHeight,
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 10.0,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () async {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
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
                                                width: 148,
                                                color: AppColors.grey
                                                    .withOpacity(0.4),
                                              ),
                                      ],
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
                                          maxLines: 1,
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
