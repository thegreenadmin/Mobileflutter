import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/home_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account_screen.dart';
import 'package:thegreenmall/dashboard/home/view/history_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox_screen.dart';
import 'package:thegreenmall/dashboard/home/view/search_store_owner_screen.dart';
import 'package:thegreenmall/dashboard/home/view/search_store_user_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final HomeController homeController = Get.put(HomeController());
  List<String> imgList = [
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  "Hi, ${homeController.firstName!.value} ${homeController.lastName!.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                )),
                            const Text(
                              "Welcome to the greenmall",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: () {
                              Get.to(const InboxScreen());
                            },
                            constraints: const BoxConstraints(),
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 2.0, 10.0, 2.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.0, color: AppColors.primary),
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            fillColor: AppColors.white,
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.asset(
                                      "assets/message.png",
                                      scale: 2.5,
                                      color: AppColors.white,
                                    )),
                                width5SizedBox,
                                const Text(
                                  'Inbox',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          width10SizedBox,
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: () {
                              if (SharedPreferenceStorage.getData(
                                      Role.role.value) ==
                                  Role.customerRoleText) {
                                Get.to(
                                  const SearchStoreUserScreen(),
                                  arguments: {
                                    "firstName":
                                        homeController.firstName!.value,
                                    "lastName": homeController.lastName!.value,
                                  },
                                );
                              } else {
                                Get.to(
                                  () => const SearchStoreOwnerScreen(),
                                  arguments: {
                                    "firstName":
                                        homeController.firstName!.value,
                                    "lastName": homeController.lastName!.value,
                                  },
                                );
                              }
                            },
                            constraints: const BoxConstraints(),
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 2.0, 10.0, 2.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.0, color: AppColors.primary),
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            fillColor: AppColors.white,
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.asset(
                                      "assets/storeUnion.png",
                                      scale: 2.2,
                                      color: AppColors.white,
                                    )),
                                width5SizedBox,
                                const Text(
                                  'Stores',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.to(const HistoryScreen());
                              },
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(14.0),
                              shape: const CircleBorder(
                                side: BorderSide(
                                    width: 1.0, color: AppColors.primary),
                              ),
                              fillColor: AppColors.white,
                              child: Image.asset(
                                "assets/union.png",
                                scale: 2.4,
                              )),
                          width10SizedBox,
                          RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.to(const AccountScreen());
                              },
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(14.0),
                              shape: const CircleBorder(
                                side: BorderSide(
                                    width: 1.0, color: AppColors.primary),
                              ),
                              fillColor: AppColors.white,
                              child: Image.asset(
                                "assets/user.png",
                                scale: 2.5,
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: WidgetConstants.screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CarouselSlider(
              items: imgList
                  .map((item) => Center(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.asset(item,
                            fit: BoxFit.cover,
                            width: WidgetConstants.screenWidth),
                      )))
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1.2,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            height5SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
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
            Text(
              StringConstants.featuredProductText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22),
            ),
            height12SizedBox,
            SizedBox(
              height: WidgetConstants.screenHeight * 0.28,
              width: WidgetConstants.screenWidth,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return width8SizedBox;
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imgList.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          "assets/example.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    height8SizedBox,
                    const Text(
                      'Skin toner cosmetic',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
