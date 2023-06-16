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

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavController bottomNavigationPageController =
      Get.put(BottomNavController());

  /* Map<int, GlobalKey<NavigatorState>>  navigatorKeysAll = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };*/

  GlobalKey<TabNavigatorState> tabNavigator = GlobalKey<TabNavigatorState>();
  GlobalKey<NavigatorState> tab1 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> tab2 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> tab3 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> tab4 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> tab5 = GlobalKey<NavigatorState>();
  RxString roleInApp = "".obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roleInApp!.value = SharedPreferenceStorage.getData(Role.role.value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int id = bottomNavigationPageController.selectedIndex.toInt();
        Get.back(id: id);
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
        //       bottomNavigationPageController.onItemTapped(2);
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
                    bottomNavigationPageController.selectedIndex.value,
                    onTap: (i) async {
                      await bottomNavigationPageController.onItemTapped(i);
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
        body: Obx(
              () => IndexedStack(
            index: bottomNavigationPageController.selectedIndex.value,
            // children: controller.menuPages,
            children: [ _TabNav(0, const HomeScreen()),
              _TabNav(1, const WalletScreen()),
              SharedPreferenceStorage.getData(Role.role.value) ==
                  Role.storeOwnerRoleText ?
              bottomNavigationPageController.storeList.length > 1 ||
                  bottomNavigationPageController.storeList.isEmpty
                  ? _TabNav(2, const OrderStoresListScreen())
                  : _TabNav(2, const OrdersHomeMainScreen())
                  : _TabNav(2, const OrdersScreen()),
              _TabNav(3, const OffersScreen()),
              _TabNav(4, const MoreScreen()),],
          ),
        ),
        // body: TabNavigator(
        //   key: tabNavigator,
        //   tabs: <TabItem>[
        //     TabItem(tab1, const HomeScreen()),
        //     TabItem(tab2, const WalletScreen()),
        //     SharedPreferenceStorage.getData(Role.role.value) ==
        //                 Role.storeOwnerRoleText ?
        //             bottomNavigationPageController.storeList.length > 1 ||
        //                 bottomNavigationPageController.storeList.isEmpty
        //         ? TabItem(tab3, const OrderStoresListScreen())
        //             : TabItem(tab3, const OrdersHomeMainScreen())
        //         : TabItem(tab3, const OrdersScreen()),
        //     TabItem(tab4, const OffersScreen()),
        //     TabItem(tab5, const MoreScreen()),
        //   ],
        //   selectedIndex: bottomNavigationPageController.selectedIndex.value,
        //   popStack: true,
        // ),

        // body: buildNavigator(),
        // body: Obx(
        //       () => IndexedStack(
        //     children:bottomNavigationPageController.tabs,
        //     index: bottomNavigationPageController.selectedIndex.toInt()??0,
        //   ),
        // ),
        // body: bottomNavigationPageController.selectedTab,
      ),
    );
  }

/*  Widget  buildNavigator() {
    return Navigator(
      key: navigatorKeysAll[bottomNavigationPageController.selectedIndex.value],
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(builder: (_) => bottomNavigationPageController.tabs.elementAt(bottomNavigationPageController.selectedIndex.value));
      },
    );
  }*/
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
}

/*


/// screen model
class ScreenModel {
  final String? name;
  final int? navKey;
  final MaterialColor? colors;
  static const _shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  get shades => _shades;
  ScreenModel({this.name, this.colors, this.navKey});
  Color? getColorByShade(shade) => colors?[shade];
}

/// screens models list
final screensData = <ScreenModel>[
  ScreenModel(name: 'red', colors: Colors.red, navKey: 1),
  ScreenModel(name: 'green', colors: Colors.green, navKey: 2),
  ScreenModel(name: 'blue', colors: Colors.blue, navKey: 3),
];

/// main controller
class _RootController extends GetxController {
  final navMenuIndex = 0.obs;

  ScreenModel get currentScreenModel => screensData[navMenuIndex()];
  MaterialColor? get navMenuItemColor => currentScreenModel.colors;

  // store the pages stack.
  List<Widget>? _pages;

  // get navigators.
  // List<Widget> get menuPages =>
  //     _pages ??= screensData.map((e) => _TabNav(e)).toList();

  // widget stuffs.
  List<BottomNavigationBarItem> get navMenuItems => screensData
      .map((e) =>
      BottomNavigationBarItem(icon: Icon(Icons.widgets), label: e.name))
      .toList();

  void openDetails(int shade) {
    final model = currentScreenModel;
    Get.to(
      PageColorDetails(
        title: model.name ??"",
        color: model.colors ?? Colors.grey,
        shade: shade,
      ),
      transition: Transition.fade,
      id: model.navKey,
    );
  }
}

/// entry page (persistent)
class _Root extends GetView<_RootController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.navMenuIndex(),
          children: controller.menuPages,
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.navMenuIndex(),
          items: controller.navMenuItems,
          onTap: controller.navMenuIndex,
          selectedItemColor: controller.navMenuItemColor,
        ),
      ),
    );
  }
}
*/

/// sub navigators.
class _TabNav extends GetView<BottomNavController> {
  final int navKey;
  final Widget tab;
  _TabNav(this.navKey,this.tab);
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(navKey),
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => tab),
    );
  }
}
/*

/// home of each subnavigator
class PageColorList extends StatelessWidget {
  final ScreenModel? model;
  const PageColorList({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model?.name??""), backgroundColor: model?.colors?? Colors.grey),
      body: ListView.builder(
        itemBuilder: (_, idx) {
          final shade = model?.shades[idx];
          return Container(
            color: model?.colors?[shade],
            child: ListTile(
              title: Text(
                'shade [$shade]',
                style: Get.textTheme.bodyText2?.copyWith(
                    color: Colors.white, backgroundColor: Colors.black26),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Get.find<_RootController>().openDetails(shade),
            ),
          );
        },
        itemCount: model?.shades.length??0,
      ),
    );
  }
}

/// details of colors.
class PageColorDetails extends StatelessWidget {
  final String? title;
  final int? shade;
  final MaterialColor? color;

  const PageColorDetails({Key? key, this.title, this.shade, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title??""),
        backgroundColor: color,
      ),
      backgroundColor: color?[shade??0],
      body: Center(
        child: Text(
          '$title [$shade]',
          style: Get.textTheme.headline3?.copyWith(
            color: Colors.white,
            backgroundColor: Colors.black45,
          ),
        ),
      ),
    );
  }
}*/
