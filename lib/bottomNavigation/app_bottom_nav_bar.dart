import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/bottomNavigation/bottom_nav_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Shared bottom navigation bar for screens that live OUTSIDE the main shell's
/// IndexedStack (e.g. the Payments flow, which is pushed on the root navigator).
///
/// Tapping a tab pops back to the main [BottomNavigation] shell and switches to
/// the selected tab, so the bar behaves exactly like the in-shell one.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  BottomNavController get _controller => Get.isRegistered<BottomNavController>()
      ? Get.find<BottomNavController>()
      : Get.put(BottomNavController());

  void _onTap(int index) {
    final controller = _controller;
    // Leave the pushed flow (root-navigator stack) and return to the shell.
    Get.until((route) => route.isFirst);
    controller.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return BottomAppBar(
      notchMargin: 5,
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      color: AppColors.white,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[],
          color: AppColors.white,
        ),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(color: AppColors.primary),
            selectedFontSize: 0.0,
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: AppColors.white,
            currentIndex: controller.selectedIndex.value.clamp(0, 4),
            onTap: _onTap,
            items: [
              _item(
                index: 0,
                activeIcon: ImageConstants.homefill,
                icon: ImageConstants.home,
                label: BottomNavStringConstants.homeText,
                active: controller.selectedIndex.value == 0,
              ),
              _item(
                index: 1,
                activeIcon: ImageConstants.walletfill,
                icon: ImageConstants.wallet,
                label: BottomNavStringConstants.walletText,
                active: controller.selectedIndex.value == 1,
              ),
              _item(
                index: 2,
                activeIcon: ImageConstants.orderfillIcon,
                icon: ImageConstants.orderIcon,
                label: BottomNavStringConstants.ordersText,
                active: controller.selectedIndex.value == 2,
                scale: 3.6,
              ),
              _item(
                index: 3,
                activeIcon: ImageConstants.offersfill,
                icon: ImageConstants.offers,
                label: BottomNavStringConstants.offersText,
                active: controller.selectedIndex.value == 3,
                scale: 3.6,
              ),
              _item(
                index: 4,
                activeIcon: ImageConstants.morefill,
                icon: ImageConstants.more,
                label: BottomNavStringConstants.moreText,
                active: controller.selectedIndex.value == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _item({
    required int index,
    required String activeIcon,
    required String icon,
    required String label,
    required bool active,
    double scale = 3.8,
  }) {
    final color = active ? AppColors.primary : AppColors.blackLight;
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Image.asset(active ? activeIcon : icon, color: color, scale: scale),
          height4SizedBox,
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
      label: "",
    );
  }
}
