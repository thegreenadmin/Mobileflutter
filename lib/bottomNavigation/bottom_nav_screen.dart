import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomnavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/dashboard/home/view/home_screen.dart';
import 'package:thegreenmall/dashboard/more/view/more_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_screen.dart';
import 'package:thegreenmall/dashboard/wallet/view/wallet_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class BottomNavigation extends StatefulWidget {

  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavController _bottomNavigationPageController =
      Get.put(BottomNavController());

  Map<int, GlobalKey<NavigatorState>>  navigatorKeysAll = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  final _tabNavigator = GlobalKey<TabNavigatorState>();
  final _tab1 = GlobalKey<NavigatorState>();
  final _tab2 = GlobalKey<NavigatorState>();
  final _tab3 = GlobalKey<NavigatorState>();
  final _tab4 = GlobalKey<NavigatorState>();
  final _tab5 = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          int id = _bottomNavigationPageController.selectedIndex.toInt();
          Get.back(id:id );
          return false;
        },
        child: Scaffold(
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
          body:TabNavigator(
            key: _tabNavigator,
            tabs: <TabItem>[
              TabItem(_tab1, const HomeScreen()),
              TabItem(_tab2, const WalletScreen()),
              TabItem(_tab3, const OrdersScreen()),
              TabItem(_tab4, const OffersScreen()),
              TabItem(_tab5, const MoreScreen()),
            ],
            selectedIndex: _bottomNavigationPageController.selectedIndex.value,
            popStack:  false,
          ),

          // body: buildNavigator(),
          // body: Obx(
          //       () => IndexedStack(
          //     children:_bottomNavigationPageController.tabs,
          //     index: _bottomNavigationPageController.selectedIndex.toInt()??0,
          //   ),
          // ),
          // body: _bottomNavigationPageController.selectedTab,
        ),
      ),
    );
  }

  Widget  buildNavigator() {
    return Navigator(
      key: navigatorKeysAll[_bottomNavigationPageController.selectedIndex.value],
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(builder: (_) => _bottomNavigationPageController.tabs.elementAt(_bottomNavigationPageController.selectedIndex.value));
      },
    );
  }
}

class PageWithButton extends StatelessWidget {
  final String title;
  final int count;

  const PageWithButton({
    Key? key,
    required this.title,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: RawMaterialButton(
          child: Text("$title $count"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PageWithButton(title: title, count: count + 1),
            ));
          },
        ),
      ),
    );
  }
}

class TabItem {
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
          key: Get.nestedKey(index),
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => widget.tabs[index].tab,
          ),
        ),
      ),
    );
  }
}
