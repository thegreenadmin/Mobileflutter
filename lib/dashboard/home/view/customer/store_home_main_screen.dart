import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_menu_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/tool_tip.dart';
import 'package:thegreenmall/utils/utility.dart';

class StoreHomeMainScreen extends StatefulWidget {
  const StoreHomeMainScreen({super.key});

  @override
  State<StoreHomeMainScreen> createState() => _StoreHomeMainScreenState();
}

class _StoreHomeMainScreenState extends State<StoreHomeMainScreen> {
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  RxList horizontalTabList = [
    StringConstants.storeText,
    StringConstants.menuText,
    StringConstants.favoriteText,
    StringConstants.optionsText,
  ].obs;

  Padding horizontalTabs() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 18,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width40SizedBox;
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: horizontalTabList.length,
            itemBuilder: (_, i) {
              return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    storeHomeMainController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        horizontalTabList[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              storeHomeMainController.selectedIndex.value == i
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                          color:
                              storeHomeMainController.selectedIndex.value == i
                                  ? AppColors.primary
                                  : AppColors.blacklight,
                        ),
                      ),
                      i != 3
                          ? height0SizedBox
                          : PopupMenuButton(
                              offset: const Offset(0, 25),
                              shape: const TooltipShape(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: storeHomeMainController
                                            .selectedIndex.value ==
                                        i
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                size: 22,
                              ),
                              onSelected: (String value) async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              itemBuilder: (context) =>
                                  createOptionsPopUpList(Get.context)!,
                            )
                    ],
                  ));
            }),
      ),
    );
  }

  List<PopupMenuEntry<String>>? createOptionsPopUpList(context) {
    return List.generate(4, (index) {
      if (index == 0) {
        return PopupMenuItem<String>(
          value: StringConstants.previousText,
          child: Column(
            children: [
              SizedBox(
                width: 130,
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.previousText,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: "",
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (index == 1) {
        return PopupMenuItem<String>(
          value: StringConstants.contactText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.contactText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (index == 2) {
        return PopupMenuItem<String>(
          value: StringConstants.storePolicyText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.storePolicyText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (index == 3) {
        return PopupMenuItem<String>(
          value: StringConstants.termsAndConditionsText,
          child: SizedBox(
            width: 130,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstants.termsAndConditionsText,
                    style: const TextStyle(
                        color: AppColors.black, fontFamily: "", fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return null!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
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
                        image: storeHomeMainController.storeAddress.value.store
                                        ?.image?.dynamicUrl ==
                                    null ||
                                storeHomeMainController.storeAddress.value
                                    .store!.image!.dynamicUrl!.isEmpty
                            ? const AssetImage(
                                ImageConstants.nopicfound,
                              ) as ImageProvider
                            : NetworkImage(storeHomeMainController
                                    .storeAddress.value.store?.image?.dynamicUrl
                                    .toString() ??
                                ""),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 50),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  storeHomeMainController.storeAddress.value
                                              .store?.isFavouriteStore ==
                                          true
                                      ? Image.asset(
                                          ImageConstants.liked,
                                          scale: 2.8,
                                        )
                                      : Image.asset(
                                          ImageConstants.favoutline,
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
                                  child: CircleAvatar(
                                    radius: 28.0,
                                    backgroundImage: storeHomeMainController
                                                    .storeAddress
                                                    .value
                                                    .store
                                                    ?.logo
                                                    ?.dynamicUrl ==
                                                null ||
                                            storeHomeMainController
                                                .storeAddress
                                                .value
                                                .store!
                                                .logo!
                                                .dynamicUrl!
                                                .isEmpty
                                        ? const AssetImage(
                                            ImageConstants.nopicfound,
                                          ) as ImageProvider
                                        : NetworkImage(storeHomeMainController
                                                .storeAddress
                                                .value
                                                .store
                                                ?.logo
                                                ?.dynamicUrl
                                                .toString() ??
                                            ""),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                width10SizedBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeHomeMainController.storeAddress.value
                                              .store?.storeName ??
                                          "",
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    height8SizedBox,
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImageConstants.loc,
                                          color: AppColors.white,
                                          scale: 2,
                                        ),
                                        width4SizedBox,
                                        Text(
                                            storeHomeMainController.storeAddress
                                                    .value.addressLine1 ??
                                                "",
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                    height8SizedBox,
                                    Row(
                                      children: [
                                        Text(
                                            storeHomeMainController
                                                    .storeAddress
                                                    .value
                                                    .store!
                                                    .storeTimings!
                                                    .isNotEmpty
                                                ? storeHomeMainController
                                                            .storeAddress
                                                            .value
                                                            .store
                                                            ?.storeTimings
                                                            ?.first
                                                            .is24HoursActive ==
                                                        false
                                                    ? "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.openingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")} - "
                                                        "${Utility.formatDateTime(storeHomeMainController.storeAddress.value.store?.storeTimings?.first.closingTime ?? "0", firstFormat: "hh:mm:ss", secFormat: "hh:mm a")}"
                                                    : StringConstants
                                                        .storeHoursText
                                                : StringConstants
                                                    .storeHoursText,
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                        width10SizedBox,
                                        Image.asset(
                                          ImageConstants.door,
                                          scale: 2.5,
                                        ),
                                        width8SizedBox,
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {},
                                          child: Image.asset(
                                            ImageConstants.call,
                                            scale: 2.5,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                  ))
            ],
          ),
        ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              horizontalTabs(),
              const Divider(
                thickness: 1,
              ),
              storeHomeMainController.selectedIndex.value == 0
                  ? const Expanded(child: StoreHomeScreen())
                  : storeHomeMainController.selectedIndex.value == 1
                      ? const Expanded(child: StoreMenuScreen())
                      : storeHomeMainController.selectedIndex.value == 2
                          ? const Expanded(child: StoreFavouriteScreen())
                          : storeHomeMainController.selectedIndex.value == 3
                              ? const Expanded(child: StoreFavouriteScreen())
                              : const Expanded(child: StoreHomeScreen())
            ],
          ),
        ));
  }
}
