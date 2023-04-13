import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class ReturnConfirmOrderScreen extends StatefulWidget {
  const ReturnConfirmOrderScreen({super.key});

  @override
  State<ReturnConfirmOrderScreen> createState() => _ReturnConfirmOrderScreenState();
}

class _ReturnConfirmOrderScreenState extends State<ReturnConfirmOrderScreen> {
  final OrdersHomeMainController ordersHomeMainController =
  Get.put(OrdersHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
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
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.returnConfirmText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            ImageConstants.homeMall,
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          )),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 25, vertical: 25),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => SizedBox(
                height: 150,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${StringConstants.fullFillOrdersText} - #${ordersHomeMainController.orderId.value}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      height20SizedBox,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white, width: 1)),
                              child: const CircleAvatar(
                                radius: 30.0,
                                backgroundImage: AssetImage(
                                  ImageConstants.userAccount,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          width10SizedBox,
                          Flexible(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    ordersHomeMainController
                                        .customerName.value.toTitleCase(),
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                height4SizedBox,
                                Row(children: [
                                  Text(
                                      "${StringConstants.orderedDateText}: ",
                                      style: TextStyle(
                                          color: AppColors.blacklight,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  Text(
                                      ordersHomeMainController
                                          .orderDate.value,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ]),
                                height4SizedBox,
                                Row(
                                  children: [
                                    Text(
                                        "${StringConstants.orderAmountText}: ",
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                    Obx(() => Text(
                                      "\$${ordersHomeMainController.orderAmount.value}",
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )),
                                  ],
                                ),
                                height6SizedBox,
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        color: AppColors.blacklight,
                      ),
                    ]),
              )),
              Obx(() => Expanded(
                  child: ordersHomeMainController.getOrderItems.isEmpty
                      ? ordersHomeMainController.isLoading.value == true
                      ? height0SizedBox
                      : Column(
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
                          AlertStringConstants
                              .noProductFoundForThisStore,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  )
                      : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return width40SizedBox;
                      },
                      itemCount:
                      ordersHomeMainController.getOrderItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: const BoxDecoration(
                                color: AppColors.greylight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                            child: Column(children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(color: AppColors.white,
                                              width: 1)),
                                      child: ordersHomeMainController
                                          .getOrderItems[index].product!
                                          .productImages!.first.image!.dynamicUrl == null ||
                                          ordersHomeMainController.getOrderItems[index].product!.productImages!.first
                                              .image!.dynamicUrl!.isEmpty
                                          ? Image.asset(ImageConstants.nopicfound,)
                                          :  Image.network(
                                          ordersHomeMainController
                                              .getOrderItems[index]
                                              .product!.productImages!
                                              .first.image!.dynamicUrl.toString()),),),
                                  width10SizedBox,
                                  Flexible(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            ordersHomeMainController
                                                .getOrderItems[index]
                                                .product!
                                                .productName ??
                                                "",
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                        height5SizedBox,
                                        Text(
                                            ordersHomeMainController
                                                .getOrderItems[index]
                                                .product!
                                                .description ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.blacklight,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        height12SizedBox,
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    "${StringConstants.qtyText.toUpperCase()}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 14)),
                                                Text(
                                                    ordersHomeMainController
                                                        .getOrderItems[
                                                    index]
                                                        .product!
                                                        .quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "${StringConstants.unitPriceText}: ",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 14)),
                                                Text(
                                                    ordersHomeMainController
                                                        .getOrderItems[
                                                    index]
                                                        .product!
                                                        .productPrice
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blacklight,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            )
                                          ],
                                        ),
                                        height6SizedBox,
                                      ],
                                    ),
                                  ),
                                  width10SizedBox,
                                  Flexible(
                                    flex: 1,
                                    child: Obx(
                                          () => SizedBox(
                                          height: 20,
                                          width: 30,
                                          child: Checkbox(
                                            side: MaterialStateBorderSide.resolveWith(
                                                  (states) => BorderSide(
                                                  width: 1.0, color:
                                              AppColors.primary.withOpacity(0.5)),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6.0)),
                                            activeColor: AppColors.primary,
                                            value:
                                            ordersHomeMainController.getOrderItems[index].isSelected??false ,
                                            onChanged: (bool? value) {
                                               setState(() {
                                                  ordersHomeMainController.getOrderItems.elementAt(index).isSelected = value;
                                                });
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        );
                      })))
            ]),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              border: Border.all(
                color: AppColors.primary,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primary],
              ),
              onTap: () {
                ordersHomeMainController.apiCompleteReturnRequest();
                // if(ordersHomeMainController.getOrderItems.every((element) => element.isSelected==true)){
                //   ordersHomeMainController.apiCompleteReturnRequest();
                // }else{
                //   Utility.alertDialog(context,title: StringConstants.alertText,
                //     description:StringConstants.alertText,
                //     ok: StringConstants.okText,cancel: StringConstants.cancelText,
                //     onOk: (){
                //       ordersHomeMainController.apiCompleteReturnRequest();
                //     },onCancel: (){
                //     Get.back();
                //       }
                //   );
                // }
              },
              height: 50,
              width: WidgetConstants.screenWidth *0.42,
              text: StringConstants.completeReturnOrderText,
              textColor: AppColors.white,
              borderRadius: 14,
              fontWeight: FontWeight.w500,
              iconL: false,
              iconR: false,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
