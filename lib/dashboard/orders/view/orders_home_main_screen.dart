import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/component/order_home_main_appbar.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OrdersHomeMainScreen extends StatefulWidget {
  const OrdersHomeMainScreen({super.key});

  @override
  State<OrdersHomeMainScreen> createState() => _OrdersHomeMainScreenState();
}

class _OrdersHomeMainScreenState extends State<OrdersHomeMainScreen> {
  final OrdersHomeMainController ordersHomeMainController =
      Get.put(OrdersHomeMainController());
  Padding horizontalTabs() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 18,
        width: WidgetConstants.screenWidth,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return width40SizedBox;
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: ordersHomeMainController.horizontalTabList.length,
            itemBuilder: (_, i) {
              return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    //  ordersHomeMainController.onIndexChange(i);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ordersHomeMainController.horizontalTabList[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight:
                          //     storeHomeMainController.selectedIndex.value == i
                          //         ? FontWeight.w500
                          //         : FontWeight.w400,
                          // color:
                          //     storeHomeMainController.selectedIndex.value == i
                          //         ? AppColors.primary
                          //         : AppColors.blacklight,
                        ),
                      ),
                    ],
                  ));
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const OrderHomeMainAppBar(),
      body: Column(
        children: const [],
      ),
    );
  }
}
