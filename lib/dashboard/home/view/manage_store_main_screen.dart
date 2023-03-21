import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/manage_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/my_store_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class ManageStoreMainScreen extends StatefulWidget {
  const ManageStoreMainScreen({super.key});

  @override
  State<ManageStoreMainScreen> createState() => _ManageStoreMainScreenState();
}

class _ManageStoreMainScreenState extends State<ManageStoreMainScreen> {
  final SearchStoreOwnerController searchStoreOwnerController =
      Get.put(SearchStoreOwnerController());

  RxList horizontalTabList = [
    StringConstants.myStoreText,
    StringConstants.manageStoreText,
  ].obs;

  Padding horizontalTabs() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 20,
        width: WidgetConstants.screenWidth,
        child: Center(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return width0SizedBox;
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: horizontalTabList.length,
              itemBuilder: (_, i) {
                return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        searchStoreOwnerController.selectedIndex.value = i;
                        if (i == 0) {
                          searchStoreOwnerController.apiGetFeaturedProducts();
                        } else {
                          searchStoreOwnerController.selectedIndex.value = i;
                        }
                      });
                    },
                    child: SizedBox(
                      width: WidgetConstants.screenWidth * 0.45,
                      child: Text(
                        horizontalTabList[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              searchStoreOwnerController.selectedIndex.value ==
                                      i
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                          color:
                              searchStoreOwnerController.selectedIndex.value ==
                                      i
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                        ),
                      ),
                    ));
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(165.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: searchStoreOwnerController.storeImage!.value.isEmpty
                      ? const AssetImage(
                          "assets/userAccount.png",
                        ) as ImageProvider
                      : NetworkImage(
                          searchStoreOwnerController.storeImage!.value),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 65),
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
                          ]),
                      height10SizedBox,
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.white, width: 1)),
                            child: CircleAvatar(
                              radius: 28.0,
                              backgroundImage: searchStoreOwnerController
                                      .storeLogo!.value.isEmpty
                                  ? const AssetImage(
                                      "assets/userAccount.png",
                                    ) as ImageProvider
                                  : NetworkImage(searchStoreOwnerController
                                      .storeLogo!.value),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          width10SizedBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                      searchStoreOwnerController
                                          .storeName.value,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    )),
                                height8SizedBox,
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/loc.png",
                                      color: AppColors.white,
                                      scale: 2,
                                    ),
                                    width4SizedBox,
                                    Obx(
                                      () => Expanded(
                                        child: Text(
                                            searchStoreOwnerController
                                                .storeLocation.value,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ],
                                ),
                                height8SizedBox,
                                Obx(() => searchStoreOwnerController
                                        .is247Time.value
                                    ? const Text("Store Hours: 24/7 Hours",
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400))
                                    : Text(
                                        "Store Hours ${searchStoreOwnerController.openingTime.value} to ${searchStoreOwnerController.closingTime.value}",
                                        style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          horizontalTabs(),
          const Divider(
            thickness: 1,
          ),
          searchStoreOwnerController.selectedIndex.value == 0
              ? const Expanded(child: MyStoreScreen())
              : searchStoreOwnerController.selectedIndex.value == 1
                  ? const Expanded(child: ManageStoreScreen())
                  : const Expanded(child: MyStoreScreen())
        ],
      ),
    );
  }
}
