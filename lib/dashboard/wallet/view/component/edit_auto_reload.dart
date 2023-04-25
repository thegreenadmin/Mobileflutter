import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/component/peroidically.dart';
import 'package:thegreenmall/dashboard/wallet/view/component/threshold.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class EditAutoReload extends StatefulWidget {
  const EditAutoReload({Key? key}) : super(key: key);

  @override
  State<EditAutoReload> createState() => _EditAutoReloadState();
}

class _EditAutoReloadState extends State<EditAutoReload>  with SingleTickerProviderStateMixin{
  final WalletController walletController = Get.put(WalletController());
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(
        // initialIndex: 0,
        length: 2,
        vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height15SizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  StringConstants.editAutoReloadText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    ImageConstants.cross,
                    scale: 3,
                  ))
            ],
          ),
          height15SizedBox,
          SizedBox(
            width: WidgetConstants.screenWidth * 0.5,
            child: TabBar(
              unselectedLabelColor: AppColors.blacklight,
              labelColor: AppColors.primary,
              onTap: (i) {
                // searchStoreUserController.storeAddresses.clear();
                // searchStoreUserController.page.value = 1;
                // searchStoreUserController.type.value = i;
                // searchStoreUserController.apiGetNearByStores();
              },
              tabs: [
                Tab(
                  child: Text(
                    StringConstants.thresholdText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    StringConstants.periodicallyText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: ThresholdView()),
                Center(child: PeriodicallyView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
