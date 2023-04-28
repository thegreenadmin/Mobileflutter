import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/component/peroidically.dart';
import 'package:thegreenmall/dashboard/wallet/view/component/threshold.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
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
        initialIndex: 0,
        length: 2,
        vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: WidgetConstants.screenHeight*0.7,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Obx(()=>  SizedBox(
            width: WidgetConstants.screenWidth ,
            child: TabBar(
              unselectedLabelColor: AppColors.blacklight,
              labelColor: AppColors.primary,
              onTap: (i) {
                walletController.type?.value = i;
              },
              tabs: [
                Tab(
                  child: Container(
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        border: Border.all(color:  walletController.type?.value == 0? AppColors.primary:AppColors.blacklight,)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        walletController.type?.value== 0?
                        Stack(children: [
                          Image.asset(ImageConstants.circleunfill,scale: 2.1,),
                          Image.asset(ImageConstants.circle,scale: 2.5,),
                        ],) :
                        Image.asset(ImageConstants.circleBlackUnFill,scale: 2.1,),
                        width8SizedBox,
                        Text(
                          StringConstants.thresholdText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        border: Border.all(color:  walletController.type?.value == 1? AppColors.primary:AppColors.blacklight,)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        walletController.type?.value== 1?
                        Stack(children: [
                          Image.asset(ImageConstants.circleunfill,scale: 2.5,),
                          Image.asset(ImageConstants.circle,scale: 2.5,),
                        ],) :
                        Image.asset(ImageConstants.circleBlackUnFill,scale: 2.5,),
                        width8SizedBox,
                        Text(
                          StringConstants.periodicallyText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
              controller: _tabController,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),),

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
