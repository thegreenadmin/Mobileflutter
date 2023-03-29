import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersController ordersController = Get.put(OrdersController());

  Container ordersTab() {
    return Container(
      height: 47,
      width: WidgetConstants.screenWidth * 0.90,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            width: 0, //
            color: AppColors.blacklight),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (ordersController.isActiveOrders.value == true) {
                  } else {
                    ordersController.isActiveOrders.value =
                        !ordersController.isActiveOrders.value;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: ordersController.isActiveOrders.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.activeOrderText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.isActiveOrders.value
                              ? AppColors.primary
                              : AppColors.blacklight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (ordersController.isActiveOrders.value == false) {
                  } else {
                    ordersController.isActiveOrders.value =
                        !ordersController.isActiveOrders.value;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: ordersController.isActiveOrders.value
                      ? AppColors.white
                      : AppColors.primarylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.completedOrders,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.isActiveOrders.value
                              ? AppColors.blacklight
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hi, ${SharedPreferenceStorage.getData(StringConstants.firstNameText) + " " + SharedPreferenceStorage.getData(StringConstants.lastNameText)}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            height4SizedBox,
                            Text(
                              StringConstants.ordersText,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                ],
              )),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() => Column(
              children: [
                Center(
                  child: ordersTab(),
                ),
                height25SizedBox,
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/nodata.png",
                        scale: 8,
                        color: AppColors.primary,
                      ),
                    ),
                    height4SizedBox,
                    Center(
                      child: Text(
                        StringConstants.noOrdersFoundText,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 16),
                      ),
                    ),
                  ],
                )
                    //ListView.separated(
                    //       separatorBuilder: (BuildContext context, int index) {
                    //         return height12SizedBox;
                    //       },
                    //       itemCount: ordersController.orderList.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return InkWell(
                    //           onTap: () {},
                    //           child: Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 10, vertical: 10),
                    //             decoration: const BoxDecoration(
                    //                 color: AppColors.primarylight,
                    //                 borderRadius: BorderRadius.all(
                    //                   Radius.circular(10.0),
                    //                 )),
                    //             child: Column(children: [
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Container(
                    //                     decoration: BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         border: Border.all(
                    //                             color: AppColors.primary,
                    //                             width: 1)),
                    //                     child: const CircleAvatar(
                    //                       radius: 22.0,
                    //                       backgroundImage: NetworkImage(
                    //                           'https://picsum.photos/250?image=9'),
                    //                       backgroundColor: Colors.transparent,
                    //                     ),
                    //                   ),
                    //                   width5SizedBox,
                    //                   Column(
                    //                     mainAxisSize: MainAxisSize.max,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Row(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.spaceBetween,
                    //                         children: [
                    //                           Text.rich(
                    //                             TextSpan(
                    //                               children: [
                    //                                 TextSpan(
                    //                                     text: "Order ID",
                    //                                     style: TextStyle(
                    //                                         color: AppColors
                    //                                             .blacklight,
                    //                                         fontWeight:
                    //                                             FontWeight.w400,
                    //                                         fontSize: 14)),
                    //                                 TextSpan(
                    //                                   text: ': #45123',
                    //                                   style: TextStyle(
                    //                                       fontWeight:
                    //                                           FontWeight.w600,
                    //                                       fontSize: 14,
                    //                                       color:
                    //                                           AppColors.blacklight),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           width12SizedBox,
                    //                           Text.rich(
                    //                             TextSpan(
                    //                               children: [
                    //                                 TextSpan(
                    //                                     text: "14 Feb",
                    //                                     style: TextStyle(
                    //                                         color: AppColors
                    //                                             .blacklight,
                    //                                         fontWeight:
                    //                                             FontWeight.w400,
                    //                                         fontSize: 14)),
                    //                                 TextSpan(
                    //                                   text: '2023-03:30 AM',
                    //                                   style: TextStyle(
                    //                                       color:
                    //                                           AppColors.blacklight,
                    //                                       fontWeight:
                    //                                           FontWeight.w400,
                    //                                       fontSize: 14),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       height8SizedBox,
                    //                       Row(
                    //                         children: [
                    //                           SizedBox(
                    //                             width: 180,
                    //                             child: Text(
                    //                                 ordersController
                    //                                     .orderList[index],
                    //                                 style: const TextStyle(
                    //                                     color: AppColors.black,
                    //                                     fontWeight: FontWeight.w500,
                    //                                     fontSize: 16)),
                    //                           ),
                    //                           const Text(
                    //                             "\$ 30.15",
                    //                             style: TextStyle(
                    //                                 color: AppColors.primary,
                    //                                 fontWeight: FontWeight.w600,
                    //                                 fontSize: 16),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //               height6SizedBox,
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   const Text.rich(
                    //                     softWrap: true,
                    //                     TextSpan(
                    //                       children: [
                    //                         TextSpan(
                    //                             text: "Status: ",
                    //                             style: TextStyle(
                    //                                 color: AppColors.black,
                    //                                 fontWeight: FontWeight.w400,
                    //                                 fontSize: 14)),
                    //                         TextSpan(
                    //                           text: "In Progress",
                    //                           style: TextStyle(
                    //                               color: AppColors.yellow,
                    //                               fontWeight: FontWeight.w600,
                    //                               fontSize: 14),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const Text.rich(
                    //                     TextSpan(
                    //                       children: [
                    //                         TextSpan(
                    //                             text: "Product: ",
                    //                             style: TextStyle(
                    //                                 color: AppColors.black,
                    //                                 fontWeight: FontWeight.w400,
                    //                                 fontSize: 14)),
                    //                         TextSpan(
                    //                           text: "02",
                    //                           style: TextStyle(
                    //                               color: AppColors.primary,
                    //                               fontWeight: FontWeight.w600,
                    //                               fontSize: 14),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Icon(
                    //                     Icons.chevron_right,
                    //                     color: AppColors.blacklight,
                    //                     size: 22.0,
                    //                   ),
                    //                 ],
                    //               )
                    //             ]),
                    //           ),
                    //         );
                    //       }),
                    ),
              ],
            )),
      ),
    );
  }
}
