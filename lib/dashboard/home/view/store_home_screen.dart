import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/store_favourite_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_featured_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_menu_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_previous_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController1;
  @override
  void initState() {
    _tabController1 = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: NetworkImage(
                    'https://picsum.photos/250?image=9',
                  ),
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
                            Image.asset(
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
                                    color: AppColors.primary, width: 1)),
                            child: const CircleAvatar(
                              radius: 28.0,
                              backgroundImage: NetworkImage(
                                  'https://picsum.photos/250?image=9'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          width10SizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Click & Collect",
                                style: TextStyle(
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
                                  const Text("Gate Village 10 Dubai 10017",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              height8SizedBox,
                              Row(
                                children: [
                                  const Text("Store Hours 9:00 am to 9:00PM",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  width10SizedBox,
                                  Image.asset(
                                    "assets/door.png",
                                    scale: 2.5,
                                  ),
                                  width8SizedBox,
                                  Image.asset(
                                    "assets/call.png",
                                    scale: 2.5,
                                  )
                                ],
                              )
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            isScrollable: true,
            unselectedLabelColor: AppColors.blacklight,
            labelColor: AppColors.primary,
            tabs: [
              Tab(
                child: Text(
                  StringConstants.menuText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  StringConstants.featuredText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  StringConstants.previousText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  StringConstants.favoriteText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
            controller: _tabController1,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController1,
              children: const [
                StoreMenuScreen(),
                StoreFeaturedScreen(),
                StorePreviousScreen(),
                StoreFavouriteScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
