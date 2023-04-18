import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class BottomNavigation extends StatelessWidget {
  final BottomNavController _bottomNavigationPageController =
      Get.put(BottomNavController());

  BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // extendBody: true,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: AppColors.primary,
        //     child: Image.asset(
        //       "assets/orders.png",
        //       scale: 4,
        //     ),
        //     onPressed: () {
        //       _bottomNavigationPageController.onItemTapped(2);
        //       // OrdersController controller = Get.find<OrdersController>();
        //       // controller.onInit();
        //     }),
        backgroundColor: AppColors.white,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          color: AppColors.white,
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[],
              color: AppColors.white,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Obx(
                  () => BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedLabelStyle:
                        const TextStyle(color: AppColors.primary),
                    selectedFontSize: 0.0,
                    elevation: 0,
                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    backgroundColor: AppColors.white,
                    currentIndex:
                        _bottomNavigationPageController.selectedIndex.value,
                    onTap: _bottomNavigationPageController.onItemTapped,
                    items: [
                      BottomNavigationBarItem(
                        icon: Column(children: [
                          Image.asset(
                            _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    0
                                ? ImageConstants.homefill
                                : ImageConstants.home,
                            color: _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    0
                                ? AppColors.primary
                                : AppColors.blacklight,
                            scale: 3.8,
                          ),
                          height4SizedBox,
                          Text(
                            BottomNavStringConstants.homeText,
                            style: TextStyle(
                                color: _bottomNavigationPageController
                                            .selectedIndex.value ==
                                        0
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ]),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Column(children: [
                          Image.asset(
                            _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    1
                                ? ImageConstants.walletfill
                                : ImageConstants.wallet,
                            color: _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    1
                                ? AppColors.primary
                                : AppColors.blacklight,
                            scale: 3.8,
                          ),
                          height4SizedBox,
                          Text(
                            BottomNavStringConstants.walletText,
                            style: TextStyle(
                                color: _bottomNavigationPageController
                                            .selectedIndex.value ==
                                        1
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ]),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Column(children: [
                          Image.asset(
                            _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    2
                                ? ImageConstants.orderfillIcon
                                : ImageConstants.orderIcon,
                            color: _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    2
                                ? AppColors.primary
                                : AppColors.blacklight,
                            scale: 3.6,
                          ),
                          height4SizedBox,
                          Text(
                            BottomNavStringConstants.ordersText,
                            style: TextStyle(
                                color: _bottomNavigationPageController
                                            .selectedIndex.value ==
                                        2
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ]),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Column(children: [
                          Image.asset(
                            _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    3
                                ? ImageConstants.offersfill
                                : ImageConstants.offers,
                            color: _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    3
                                ? AppColors.primary
                                : AppColors.blacklight,
                            scale: 3.6,
                          ),
                          height4SizedBox,
                          Text(
                            BottomNavStringConstants.offersText,
                            style: TextStyle(
                                color: _bottomNavigationPageController
                                            .selectedIndex.value ==
                                        3
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ]),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Column(children: [
                          Image.asset(
                            _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    4
                                ? ImageConstants.morefill
                                : ImageConstants.more,
                            color: _bottomNavigationPageController
                                        .selectedIndex.value ==
                                    4
                                ? AppColors.primary
                                : AppColors.blacklight,
                            scale: 3.8,
                          ),
                          height4SizedBox,
                          Text(
                            BottomNavStringConstants.moreText,
                            style: TextStyle(
                                color: _bottomNavigationPageController
                                            .selectedIndex.value ==
                                        4
                                    ? AppColors.primary
                                    : AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ]),
                        label: "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _bottomNavigationPageController.selectedTab,
      ),
    );
  }
}
