import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_controller.dart';
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

class _BottomNavigationState extends State<BottomNavigation>  with GlobalVarMixin{
  final BottomNavController bottomNavigationPageController =
      Get.put(BottomNavController());
  final AccountController accountController = Get.put(AccountController());

  // Tab Navigator keys and observers owned by this dashboard instance.
  // Get.nestedKey(id) hands out one GlobalKey per id for the whole app, but
  // a second dashboard can be built while the previous one is still mounted
  // (guest -> login: Get.offAllNamed keeps the old route alive until the new
  // one has animated in), and both then claim the same key ("Multiple widgets
  // used the same GlobalKey"). Each instance makes fresh keys and registers
  // them with GetX, so Get.to(..., id: n) targets the newest dashboard.
  final Map<int, GlobalKey<NavigatorState>> _navKeys = {};
  final Map<int, TabRouteObserverProxy> _navObservers = {};

  @override
  void initState() {
    Get.parameters["isController"] = "no";
    for (var id = 0; id <= 6; id++) {
      final key =
          GlobalKey<NavigatorState>(debugLabel: 'Getx nested key: $id');
      _navKeys[id] = key;
      Get.keys[id] = key;
      // A Navigator observer can only be attached to one Navigator at a time.
      _navObservers[id] = TabRouteObserverProxy();
    }

    super.initState();
  }

  _TabNav _tabNav(int id, Widget tab) =>
      _TabNav(id, tab, _navKeys[id]!, _navObservers[id]!);

  late HttpClient client;

  void clearConnectionPool() {
    HttpClient().close(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) async {
        Utility.showConfirmAlertMessage(StringConstants.exitAppConfirmText,
            description: StringConstants.exitAppConfirmText, okay: "OK", okayTap: () {
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
                          TextStyle(color: AppColors.primary),
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
                                  : AppColors.blackLight,
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
                                      : AppColors.blackLight,
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
                                  : AppColors.blackLight,
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
                                      : AppColors.blackLight,
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
                                  : AppColors.blackLight,
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
                                      : AppColors.blackLight,
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
                                  : AppColors.blackLight,
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
                                      : AppColors.blackLight,
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
                                          .selectedIndex.value == 4
                                  ? ImageConstants.morefill
                                  : ImageConstants.more,
                              color: bottomNavigationPageController
                                          .selectedIndex.value == 4
                                  ? AppColors.primary
                                  : AppColors.blackLight,
                              scale: 3.8,
                            ),
                            height4SizedBox,
                            Text(
                              BottomNavStringConstants.moreText,
                              style: TextStyle(
                                  color: bottomNavigationPageController
                                              .selectedIndex.value == 4
                                      ? AppColors.primary
                                      : AppColors.blackLight,
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
              _tabNav(0, HomeScreen()),
              _tabNav(1, const WalletScreen()),
              roleApp.value == Role.storeOwnerRoleText
                  ? bottomNavigationPageController.storeList.length > 1 ||
                          bottomNavigationPageController.storeList.isEmpty
                      ? _tabNav(2, const OrderStoresListScreen())
                      : _tabNav(3, const OrdersHomeMainScreen())
                  : _tabNav(4, const OrdersScreen()),
              _tabNav(5, const OffersScreen()),
              _tabNav(6, const MoreScreen()),
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
  final GlobalKey<NavigatorState> navigatorKey;
  final TabRouteObserverProxy observer;
  // Key the widget by its navKey. The Orders slot can change its navKey in
  // place (e.g. 4 = customer OrdersScreen -> 2 = OrderStoresListScreen) when a
  // guest is converted to a store owner and roleApp updates. Without a Key,
  // Flutter reuses the same _TabNav element and merely swaps the inner
  // Navigator's GlobalKey (Get.nestedKey), which leaves the new nested
  // Navigator mounted with no visible route -> permanently blank/white screen.
  // A ValueKey forces a fresh element + Navigator when the navKey changes.
  _TabNav(this.navKey, this.tab, this.navigatorKey, this.observer)
      : super(key: ValueKey('tabNav_$navKey'));

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      // One observer per tab Navigator (owned by the dashboard state and
      // reused across rebuilds); sharing one between Navigators trips
      // 'observer.navigator == null'.
      observers: [observer],
      pages: [
        MaterialPage(child: tab),
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}
