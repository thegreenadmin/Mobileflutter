import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/home/view/nearby_store_list_screen.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class SearchStoreUserScreen extends StatefulWidget {
  const SearchStoreUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchStoreUserScreen> createState() => _SearchStoreUserScreenState();
}

class _SearchStoreUserScreenState extends State<SearchStoreUserScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Hi, Julia Adrew",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  StringConstants.searchForStoreText,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height20SizedBox,
                ],
              )),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            color: AppColors.primary,
            child: const Center(
              child: Text(
                'Map',
              ),
            ),
          ),
          TabBar(
            unselectedLabelColor: AppColors.blacklight,
            labelColor: AppColors.primary,
            tabs: [
              Tab(
                child: Text(
                  StringConstants.nearbyText,
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
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: NearbyStoreListScreen()),
                Center(
                  child: Text(
                    'Screen 2',
                  ),
                ),
                Center(
                  child: Text(
                    'Screen 3',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
