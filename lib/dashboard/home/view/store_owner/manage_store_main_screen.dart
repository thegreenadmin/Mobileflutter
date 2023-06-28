import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_store_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/my_store_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class ManageStoreMainScreen extends StatefulWidget {
  const ManageStoreMainScreen({super.key});

  @override
  State<ManageStoreMainScreen> createState() => _ManageStoreMainScreenState();
}

class _ManageStoreMainScreenState extends State<ManageStoreMainScreen> {
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  RxList horizontalTabList = [
    StringConstants.myStoreText,
    StringConstants.manageStoreText,
  ].obs;

  Padding horizontalTabs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 22,
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
                        ownerStoresController.selectedIndex.value = i;
                        // if (i == 0) {
                        //   ownerStoresController.apiGetFeaturedProducts();

                        // } else {
                        ownerStoresController.selectedIndex.value = i;
                        // }
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
                              ownerStoresController.selectedIndex.value == i
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color: ownerStoresController.selectedIndex.value == i
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

  /* @override
  initState() {
    super.initState();
    ownerStoresController.selectedIndex.value = 0;
    ownerStoresController.firstName?.value =
        SharedPreferenceStorage.getData(StringConstants.firstNameText);
    ownerStoresController.lastName?.value =
        SharedPreferenceStorage.getData(StringConstants.lastNameText);
    ownerStoresController.getApiData();
    ownerStoresController.getGkey();
    if (Get.parameters['isFromHome'] == "true") {
      ownerStoresController.storeId.value = Get.parameters['storeId'] ?? "";
      ownerStoresController.apiGetParticularStore();
    }
  }

  getApiData() async {
    await ownerStoresController.apiGetStoreList();
    await ownerStoresController.apiGetDeliveryServices();
    await ownerStoresController.apiGetOwnerOffersList();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.black45, BlendMode.darken),
                      image: ownerStoresController
                              .editStoreImageDynamicLinkFromServer.value.isEmpty
                          ? const AssetImage(
                              ImageConstants.nopicfound,
                            ) as ImageProvider
                          : NetworkImage(ownerStoresController
                              .editStoreImageDynamicLinkFromServer.value),
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
                                    Get.delete<OwnerStoresController>();
                                    Get.back(id: pageIdApp.value);
                                    // Navigator.of(context).pop();
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
                                  backgroundImage: ownerStoresController
                                          .editStoreLogoDynamicLinkFromServer
                                          .value
                                          .isEmpty
                                      ? const AssetImage(
                                          ImageConstants.nopicfound,
                                        ) as ImageProvider
                                      : NetworkImage(ownerStoresController
                                          .editStoreLogoDynamicLinkFromServer
                                          .value),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              width10SizedBox,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                          ownerStoresController.storeName.value,
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
                                          ImageConstants.loc,
                                          color: AppColors.white,
                                          scale: 2.5,
                                        ),
                                        width4SizedBox,
                                        Obx(
                                          () => Expanded(
                                            child: Text(
                                                ownerStoresController
                                                    .storeLocation.value,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height8SizedBox,
                                    Obx(() => ownerStoresController
                                            .is247Time.value
                                        ? Text(StringConstants.storeHoursText,
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400))
                                        : Text(
                                            "${StringConstants.storeHourText} ${ownerStoresController.openingTime.value} to ${ownerStoresController.closingTime.value}",
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
                ))
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
          ownerStoresController.selectedIndex.value == 0
              ? const Expanded(child: MyStoreScreen())
              : ownerStoresController.selectedIndex.value == 1
                  ? const Expanded(child: ManageStoreScreen())
                  : const Expanded(child: MyStoreScreen())
        ],
      ),
    );
  }
}
