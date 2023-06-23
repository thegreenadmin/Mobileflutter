import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/more/view/more_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/wallet_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import '../dashboard/orders/view/order_store_list_screen.dart';
import '../utils/shared_prefrences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavController bottomNavigationPageController =
      Get.put(BottomNavController());

  // GlobalKey<TabNavigatorState> tabNavigator = GlobalKey<TabNavigatorState>();
  final GlobalKey<NavigatorState> tab1 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab2 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab3 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab4 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab5 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab6 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int id = bottomNavigationPageController.selectedIndex.toInt();
        Get.back(id: id);
        return false;
      },
      child: Obx(()=> Scaffold(
         /* extendBody: true,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: Image.asset(
                "assets/orders.png",
                scale: 4,
              ),
              onPressed: () {
                bottomNavigationPageController.onItemTapped(2);
                // OrdersController controller = Get.find<OrdersController>();
                // controller.onInit();
              }),*/
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
                  Obx(() => BottomNavigationBar(
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
                      onTap: (i) { bottomNavigationPageController.onItemTapped(i);
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
                bottomNavigationPageController.roleInApp.value ==
                Role.storeOwnerRoleText ?
                bottomNavigationPageController.storeList.length > 1 ||
                    bottomNavigationPageController.storeList.isEmpty
                    ? const _TabNav(2, OrderStoresListScreen())
                    : const _TabNav(3, OrdersHomeMainScreen())
                    : const _TabNav(4, OrdersScreen()),
                  const _TabNav(5, OffersScreen()),
                  const _TabNav(6, MoreScreen()),],
            ),



         /* body: TabNavigator(
            key: tabNavigator,
            tabs: <TabItem>[
              TabItem(tab1, const HomeScreen()),
              TabItem(tab2, const WalletScreen()),
              SharedPreferenceStorage.getData(Role.role) ==
                          Role.storeOwnerRoleText ?
                      bottomNavigationPageController.storeList.length > 1 ||
                          bottomNavigationPageController.storeList.isEmpty
                  ? TabItem(tab3, const OrderStoresListScreen())
                      : TabItem(tab4, const OrdersHomeMainScreen())
                  : TabItem(tab5, const OrdersScreen()),
              TabItem(tab6, const OffersScreen()),
              TabItem(tab7, const MoreScreen()),
            ],
            selectedIndex: bottomNavigationPageController.selectedIndex.value,
            popStack: true,
          ),*/
          /*body: buildNavigator(),*/
         /* body: Obx(
                () => IndexedStack(
              children:bottomNavigationPageController.tabs,
              index: bottomNavigationPageController.selectedIndex.toInt()??0,
            ),
          ),*/
         /* body: bottomNavigationPageController.selectedTab,*/
        ),
      ),
    );
  }
}

/*class TabItem {
  final GlobalKey<NavigatorState> key;
  final Widget tab;

  const TabItem(this.key, this.tab);
}

class TabNavigator extends StatefulWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final bool popStack;

  const TabNavigator({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    this.popStack = false,
  }) : super(key: key);

  @override
  TabNavigatorState createState() => TabNavigatorState();
}

class TabNavigatorState extends State<TabNavigator> {
  ///
  /// Try to pop widget, return true if popped
  ///
  Future<bool>? maybePop() {
    return widget.tabs[widget.selectedIndex].key.currentState?.maybePop(true);
  }

  _popStackIfRequired(BuildContext context) async {
    if (widget.popStack) {
      widget.tabs[widget.selectedIndex].key.currentState
          ?.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    _popStackIfRequired(context);
    return Stack(
      children: List.generate(widget.tabs.length, _buildTab),
    );
  }

  Widget _buildTab(int index) {
    return Offstage(
      offstage: widget.selectedIndex != index,
      child: Opacity(
        opacity: widget.selectedIndex == index ? 1.0 : 0.0,
        child: Navigator(
          initialRoute: "/splashView",
          key: Get.nestedKey(index),
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => widget.tabs[index].tab,
          ),
        ),
      ),
    );
  }
}*/


/// sub navigators.
class _TabNav extends GetView<BottomNavController> {
  final int navKey;
  final Widget tab;
   const _TabNav(this.navKey,this.tab);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // key: navigatorKey,
      key: Get.nestedKey(navKey),
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => tab),
    );
  }
}
