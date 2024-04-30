import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/controller.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/more/view/more_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/wallet_screen.dart';
import 'package:thegreenmall/utils/utils.dart';
import '../dashboard/orders/view/order_store_list_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavController bottomNavigationPageController =
      Get.put(BottomNavController());
  final AccountController accountController = Get.put(AccountController());

  @override
  void initState() {
    Get.parameters["isController"] = "no";

    super.initState();
  }

  late HttpClient client;

  void clearConnectionPool() {
    HttpClient().close(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) async {
        Utility.showConfirmAlertMessage("Click OK to exit the app.",
            description: "Click OK to exit the app.", okay: "OK", okayTap: () {
          Get.back();
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return Future.value(true);
        });
        return Future.value(true);
      },
      child: Obx(
        () => Scaffold(
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
                          bottomNavigationPageController.selectedIndex.value,
                      onTap: (i) {
                        bottomNavigationPageController.onItemTapped(i);
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: Column(children: [
                            Image.asset(
                              bottomNavigationPageController
                                          .selectedIndex.value ==
                                      0
                                  ? ImageConstants.homefill
                                  : ImageConstants.home,
                              color: bottomNavigationPageController
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
                                  color: bottomNavigationPageController
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
                              bottomNavigationPageController
                                          .selectedIndex.value ==
                                      1
                                  ? ImageConstants.walletfill
                                  : ImageConstants.wallet,
                              color: bottomNavigationPageController
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
                                  color: bottomNavigationPageController
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
                              bottomNavigationPageController
                                          .selectedIndex.value ==
                                      2
                                  ? ImageConstants.orderfillIcon
                                  : ImageConstants.orderIcon,
                              color: bottomNavigationPageController
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
                                  color: bottomNavigationPageController
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
                              bottomNavigationPageController
                                          .selectedIndex.value ==
                                      3
                                  ? ImageConstants.offersfill
                                  : ImageConstants.offers,
                              color: bottomNavigationPageController
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
                                  color: bottomNavigationPageController
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
                              bottomNavigationPageController
                                          .selectedIndex.value ==
                                      4
                                  ? ImageConstants.morefill
                                  : ImageConstants.more,
                              color: bottomNavigationPageController
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
                                  color: bottomNavigationPageController
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
          body: IndexedStack(
            index: bottomNavigationPageController.selectedIndex.value,
            children: [
              const _TabNav(0, HomeScreen()),
              const _TabNav(1, WalletScreen()),
              roleApp.value == Role.storeOwnerRoleText
                  ? bottomNavigationPageController.storeList.length > 1 ||
                          bottomNavigationPageController.storeList.isEmpty
                      ? const _TabNav(2, OrderStoresListScreen())
                      : const _TabNav(3, OrdersHomeMainScreen())
                  : const _TabNav(4, OrdersScreen()),
              const _TabNav(5, OffersScreen()),
              const _TabNav(6, MoreScreen()),
            ],
          ),

          /* body: bottomNavigationPageController.selectedTab,*/
        ),
      ),
    );
  }
}

class _TabNav extends GetView<BottomNavController> {
  final int navKey;
  final Widget tab;
  const _TabNav(this.navKey, this.tab);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(navKey),
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => tab),
    );
  }
}
