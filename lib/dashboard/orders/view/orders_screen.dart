
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_controller.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/utils/common_appBar.dart';
import 'package:thegreenmall/utils/utils.dart';

class OrdersScreen extends StatefulWidget {
  final String? orderId;
  final String? storeId;
  final String? orderStatus;
  final bool? isFromNotification;
  final bool? isFromTransaction;
  const OrdersScreen({super.key, this.orderId, this.storeId, this.isFromNotification, this.isFromTransaction, this.orderStatus});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with GlobalVarMixin{
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  initState(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersController.isFromNotification.value =
          widget.isFromNotification ?? false;
      ordersController.storeId.value = widget.storeId ?? "";

      if (ordersController.storeId.value != "") {
        ordersController.apiGetStoreDetailsApi();
      }

      ordersController.orderStatus.value = widget.orderStatus ?? "";
    });
      super.initState();

  }

  Container userOrdersTab() {
    return Container(
      height: 47,
      width: WidgetConstants.screenWidth * 0.90,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            width: 0, //
            color: AppColors.blackLight),
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
                    // ordersController.orderStatusId.value = 2;
                    ordersController.page.value = 1;
                    ordersController.uerSelectedTab.value = 0;
                    ordersController.orderList.clear();
                    ordersController.apiGetOrderListApi();
                  } else {
                    ordersController.isActiveOrders.value = !ordersController.isActiveOrders.value;
                    ordersController.page.value = 1;
                    ordersController.uerSelectedTab.value = 0;
                    ordersController.orderList.clear();
                    ordersController.apiGetOrderListApi();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.uerSelectedTab.value == 0 ? AppColors.primaryLight : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.activeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.uerSelectedTab.value == 0 ? AppColors.primary : AppColors.blackLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ordersController.isActiveOrders.value = false;
                  ordersController.page.value = 1;
                  ordersController.uerSelectedTab.value = 1;
                  ordersController.orderList.clear();
                  ordersController.apiGetOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.uerSelectedTab.value == 1 ? AppColors.primaryLight : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.completeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.uerSelectedTab.value == 1 ? AppColors.primary : AppColors.blackLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ordersController.isActiveOrders.value = false;
                  ordersController.page.value = 1;
                  ordersController.uerSelectedTab.value = 2;
                  ordersController.orderList.clear();
                  ordersController.apiGetOrderListApi();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.25,
                  color: ordersController.uerSelectedTab.value == 2 ? AppColors.primaryLight : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.cancelledText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ordersController.uerSelectedTab.value == 2 ? AppColors.primary : AppColors.blackLight,
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
      body: Stack(
        children: [
          Column(
            children: [
              Obx(() => CommonAppBar(
                showActiveCart: true,
                role: ordersController.role!.value,
                cartCount: ordersController.searchStoreUserController.cartCount.value,
                storeId: ordersController.searchStoreUserController.storeIdValue.value,
                cartLength: ordersController.searchStoreUserController.cartCount.value,
                firstName: firstName.value,
                labelText: StringConstants.ordersText,
                lastName: lastName.value,
                okayTap: () {
                  ordersController.searchStoreUserController.apiActiveCartApi();
                },
                isFromNotification: false,
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Center(child: userOrdersTab()),
                      height25SizedBox,
                      Obx(() {
                        final isEmpty = ordersController.orderList.isEmpty;
                        if (isEmpty) {
                          return buildNoDataFound();
                        }
                        return Flexible(
                          child: ListView.separated( padding: EdgeInsets.zero,
                            controller: ordersController.scrollController,
                            separatorBuilder: (context, index) => height12SizedBox,
                            itemCount: (ordersController.orderList.length) +
                                (ordersController.isDataLoading.value ? 1 : 0),
                            itemBuilder: (context, i) {
                              if (i <  ordersController.orderList.length) {
                                return  buildCustomerOrders(i) ;
                              } else if (ordersController.isDataLoading.value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  ordersController.scrollController.jumpTo(
                                      ordersController.scrollController.position.maxScrollExtent);
                                });
                                return CommonWidgets.loadingIndicator();
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // LOADING OVERLAY
          Obx(() {
            return ordersController.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      )

    );
  }


  InkWell buildCustomerOrders(int i) {
    return InkWell(
                                          onTap: () async {
                                            ordersController.storeId.value = ordersController.orderList[i].storeId ?? "";
                                            ordersController.orderStatus.value = ordersController.orderList[i].orderId ?? "";
                                            ordersController.apiGetStoreDetailsApi();
                                            // Get.parameters["orderStatus"] = ordersController.orderList[i].orderId ?? "";
                                            ordersController.apiGetOrderDetailsApi();
                                            // Get.parameters["isFromTransaction"] = "false";
                                            // Get.parameters["isHome"] = "false";
                                            // Get.parameters["isFromNotification"] = "false";
                                            // Get.parameters["storeId"] = ordersController.orderList[i].store?.storeId.toString() ?? "";

                                            Get.to(() =>  OrderConfirmationScreen(
                                              orderStatus: ordersController.orderList[i].orderId ?? "",
                                              isHome: false,
                                              isFromNotification: false,
                                              isFromTransaction:false ,
                                              storeId: ordersController.orderList[i].store?.storeId.toString() ?? ""
                                            ), id: pageIdApp.value)?.then((value) {
                                              ordersController.apiGetOrderListApi();
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            decoration: const BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                )),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 1)),
                                                    child: CommonWidgets.circleCachedNetworkImage(
                                                      ordersController.orderList[i].store?.logo?.dynamicUrl.toString() ?? "",
                                                      fit: BoxFit.contain,
                                                      radius: 22.0,
                                                      assetImg: ImageConstants.nopicfound,
                                                    ),
                                                  ),
                                                  width5SizedBox,
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text: StringConstants.orderIDText,
                                                                        style: TextStyle(
                                                                            color: AppColors.blackLight,
                                                                            fontWeight: FontWeight.w400,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontSize: 14)),
                                                                    TextSpan(
                                                                      text: ': ${ordersController.orderList[i].orderId ?? "0"}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          fontSize: 14,
                                                                          color: AppColors.blackLight),
                                                                    ),
                                                                  ],
                                                                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                                                                ),
                                                                style: const TextStyle(overflow: TextOverflow.ellipsis),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text: Utility.parseDateTime(
                                                                          DateTime.parse(ordersController.orderList[i].orderDate.toString()),
                                                                          secFormat: '',
                                                                        ).toString(),
                                                                        style: TextStyle(
                                                                            color: AppColors.blackLight,
                                                                            fontWeight: FontWeight.w400,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontSize: 14)),
                                                                    TextSpan(
                                                                      text:
                                                                          "-${Utility.formatDateTime('${ordersController.orderList[i].createdAt.toString().substring(0, 10)} ${ordersController.orderList[i].createdAt.toString().substring(11, 23)}', firstFormat: "yyyy-MM-dd HH:mm:ss", secFormat: "hh:mm a")}",
                                                                      style: TextStyle(
                                                                          color: AppColors.blackLight,
                                                                          fontWeight: FontWeight.w400,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          fontSize: 14),
                                                                    ),
                                                                  ],
                                                                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                                                                ),
                                                                style: const TextStyle(overflow: TextOverflow.ellipsis),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        height8SizedBox,
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(ordersController.orderList[i].store?.storeName ?? "",
                                                                style: const TextStyle(
                                                                    color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16)),
                                                            Text(
                                                              "\$${ordersController.orderList[i].totalAmount?.toStringAsFixed(2)}",
                                                              style: const TextStyle(
                                                                  color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              height6SizedBox,
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text.rich(
                                                    softWrap: true,
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "${StringConstants.statusText} : ",
                                                            style: const TextStyle(
                                                                color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14)),
                                                        TextSpan(
                                                          text: ordersController.orderList[i].orderHistories?.first.orderStatus?.orderStatusName
                                                                  ?.toTitleCase() ??
                                                              "",
                                                          style:
                                                              const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w600, fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: "${StringConstants.productsText}: ",
                                                                style: const TextStyle(
                                                                    color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14)),
                                                            TextSpan(
                                                              text: ordersController.orderList[i].orderItems?.length.toString() ?? "0",
                                                              style: const TextStyle(
                                                                  color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: AppColors.blackLight,
                                                        size: 22.0,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ]),
                                          ),
                                        );
  }

  Expanded buildNoDataFound() {
    return Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            ImageConstants.nodata,
                                            scale: 8,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        height4SizedBox,
                                        Center(
                                          child: Text(
                                            StringConstants.noOrdersFoundText,
                                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
  }
}
