import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class OrderStoresListScreen extends StatefulWidget {
  const OrderStoresListScreen({super.key});

  @override
  State<OrderStoresListScreen> createState() => _OrderStoresListScreenState();
}

class _OrderStoresListScreenState extends State<OrderStoresListScreen> with GlobalVarMixin{
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(90.0),
      //   child: Container(
      //     color: AppColors.primaryLight,
      //     child: Padding(
      //         padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
      //         child: Column(
      //           children: [
      //             Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Obx(
      //                         () => Text(
      //                           'Hi, ${firstName.value} ${lastName.value}',
      //                           style: const TextStyle(
      //                               fontSize: 20,
      //                               color: AppColors.black,
      //                               fontWeight: FontWeight.w400),
      //                         ),
      //                       ),
      //                       height4SizedBox,
      //                       Text(
      //                         StringConstants.ordersText,
      //                         style: const TextStyle(
      //                             fontSize: 22,
      //                             color: AppColors.black,
      //                             fontWeight: FontWeight.w600),
      //                       ),
      //                     ],
      //                   ),
      //                   Image.asset(
      //                     ImageConstants.homeMall,
      //                     scale: 4,
      //                   )
      //                 ]),
      //           ],
      //         )),
      //   ),
      // ),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryLight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50,),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            ImageConstants.homeMall,
                            scale: 4,
                          ),
                          width10SizedBox,
                          Expanded(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                    () => Text(
                                  'Hi, ${firstName.value}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              height4SizedBox,
                              Text(
                                StringConstants.ordersText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          ),
                        ]),
                  ],
                )),
          ),
          height8SizedBox,
          // ✅ Dynamic flexible space for list or empty state
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Obx(() {
                if (ordersController.storeList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageConstants.nodata,
                          scale: 8,
                          color: AppColors.primary,
                        ),
                        height4SizedBox,
                        Text(
                          StringConstants.noOrdersFoundText,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return ListView.separated(

                      padding: const EdgeInsets.only(bottom: 60),
                      separatorBuilder: (BuildContext context, int index) {
                        return height12SizedBox;
                      },
                      itemCount: ordersController.storeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildStoreCard(index);
                      });
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  InkWell buildStoreCard(int index) {
    return InkWell(
                            onTap: () async {
                              ordersController.storeId.value =
                                  ordersController.storeList[index].storeId ??
                                      "";
                              // Get.parameters["storeId"] =
                              //     ordersController.storeList[index].storeId ??
                              //         "";
                              // Get.parameters["orderId"] = "";

                              hasStoreAccess.value && permissionStoreList.isEmpty ||
                                      permissionStoreList.any((element) =>
                                          element.storeId ==
                                                  ordersController
                                                      .storeList[index]
                                                      .storeId &&
                                              element.isStoreOwner == true ||
                                          element.storeId ==
                                                  ordersController
                                                      .storeList[index]
                                                      .storeId &&
                                              element.controllers!.any((ele) =>
                                                  ele.controllerKey ==
                                                  PermissionKey
                                                      .manageOrders.statusName))
                                  ? Get.to(() =>  OrdersHomeMainScreen(
                                storeId: ordersController.storeList[index].storeId ??
                                    "",
                                orderId:"",
                                isHome: false,
                              ),
                                      id: pageIdApp.value)
                                  : Utility.showAlertMessage(
                                      AlertStringConstants.notAuthorizedToStoreText);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: const BoxDecoration(
                                  color: AppColors.greyLight,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )),
                              child: Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1)),
                                        child: CommonWidgets
                                            .circleCachedNetworkImage(
                                          ordersController
                                              .storeList[index].logo!.dynamicUrl
                                              .toString(),
                                          fit: BoxFit.contain,
                                          radius: 24.0,
                                          assetImg: ImageConstants.nopicfound,
                                        ),
                                      ),
                                    ),
                                    width10SizedBox,
                                    Flexible(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 190,
                                            child: Text(
                                              ordersController.storeList[index]
                                                      .storeName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          height8SizedBox,
                                          ListView.separated(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return height0SizedBox;
                                              },
                                              itemCount: ordersController
                                                  .storeList[index]
                                                  .storeAddresses!
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                ordersController
                                                    .addressListIndex!
                                                    .value = i;
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.asset(
                                                            ImageConstants.loc,
                                                            scale: 3,
                                                          ),
                                                          width3SizedBox,
                                                          Expanded(
                                                            child: Text(
                                                              ordersController
                                                                      .storeList[
                                                                          index]
                                                                      .storeAddresses![
                                                                          i]
                                                                      .addressLine1 ??
                                                                  "",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.0,
                                                                  color: AppColors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ]),
                                                    height10SizedBox,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          flex: 4,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${StringConstants.cityText}: ",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .blackLight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12)),
                                                              Expanded(
                                                                child: Text(
                                                                  ordersController
                                                                          .storeList[
                                                                              index]
                                                                          .storeAddresses![
                                                                              i]
                                                                          .city ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        width5SizedBox,
                                                        Flexible(
                                                          flex: 6,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${StringConstants.stateText}: ",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .blackLight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12)),
                                                              Expanded(
                                                                child: Text(
                                                                  ordersController
                                                                          .storeList[
                                                                              index]
                                                                          .storeAddresses![
                                                                              i]
                                                                          .state!
                                                                          .stateName ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }),
                                          height8SizedBox,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          );
  }
}
