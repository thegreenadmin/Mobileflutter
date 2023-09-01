import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/transaction_detail_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class OwnerTransactionDetailScreen extends StatefulWidget {
  const OwnerTransactionDetailScreen({super.key});

  @override
  State<OwnerTransactionDetailScreen> createState() =>
      _OwnerTransactionDetailScreenState();
}

class _OwnerTransactionDetailScreenState
    extends State<OwnerTransactionDetailScreen> {
  final TransactionDetailController transactionDetailController =
      Get.put(TransactionDetailController());

  @override
  void initState() {
    super.initState();

    transactionDetailController.storeWalletTransactionId!.value =
        Get.parameters['store_wallet_transaction_id'] ?? "";
    transactionDetailController.storeId!.value =
        Get.parameters['store_id'] ?? "";
    transactionDetailController.isCurrentMonthSelected.value = true;
    if (SharedPreferenceStorage.getData(Role.role) == Role.customerRoleText) {
      transactionDetailController.role!.value = Role.customerRoleText;
      // apiGetUserOrderTransactionHistory();
    } else {
      transactionDetailController.role!.value = Role.storeOwnerRoleText;
      transactionDetailController.apiGetOwnerTransactionDetail();
    }
  }

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
                                  Get.back(id: pageIdApp.value);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.detailText,
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
                          Obx(() => Text(
                                "${StringConstants.orderidText} - #${transactionDetailController.orderId!.value}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              )),
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
                                    Obx(() => Text(
                                        transactionDetailController
                                            .customerName!.value,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16))),
                                    height4SizedBox,
                                    Row(children: [
                                      Text(
                                          "${StringConstants.orderedDateText}: ",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      Text(
                                          transactionDetailController.orderDate
                                              .toString(),
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
                                              "\$${transactionDetailController.orderAmount!.value}",
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
              // Obx(() => Expanded(
              //     child: transactionDetailController.getOrderItems.isEmpty
              //         ? transactionDetailController.isLoading.value == true
              //             ? height0SizedBox
              //             : Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Center(
              //                     child: Image.asset(
              //                       ImageConstants.nodata,
              //                       scale: 8,
              //                       color: AppColors.primary,
              //                     ),
              //                   ),
              //                   height4SizedBox,
              //                   Center(
              //                     child: Text(
              //                       AlertStringConstants
              //                           .noProductFoundForThisStore,
              //                       style: const TextStyle(
              //                           fontStyle: FontStyle.italic,
              //                           fontSize: 16),
              //                     ),
              //                   ),
              //                 ],
              //               )
              //         : ListView.separated(
              //             separatorBuilder: (BuildContext context, int index) {
              //               return width40SizedBox;
              //             },
              //             itemCount:
              //                 transactionDetailController.getOrderItems.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               return InkWell(
              //                 onTap: () {},
              //                 child: Container(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 10, vertical: 5),
              //                   decoration: const BoxDecoration(
              //                       color: AppColors.greylight,
              //                       borderRadius: BorderRadius.all(
              //                         Radius.circular(10.0),
              //                       )),
              //                   child: Column(children: [
              //                     Row(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Flexible(
              //                           flex: 2,
              //                           child: Container(
              //                             decoration: BoxDecoration(
              //                                 shape: BoxShape.rectangle,
              //                                 border: Border.all(
              //                                     color: AppColors.white,
              //                                     width: 1)),
              //                             child: transactionDetailController
              //                                             .getOrderItems[index]
              //                                             .product!
              //                                             .productImages!
              //                                             .first
              //                                             .image!
              //                                             .dynamicUrl ==
              //                                         null ||
              //                                     transactionDetailController
              //                                         .getOrderItems[index]
              //                                         .product!
              //                                         .productImages!
              //                                         .first
              //                                         .image!
              //                                         .dynamicUrl!
              //                                         .isEmpty
              //                                 ? Image.asset(
              //                                     ImageConstants.nopicfound,
              //                                   )
              //                                 : Image.network(
              //                                     transactionDetailController
              //                                         .getOrderItems[index]
              //                                         .product!
              //                                         .productImages!
              //                                         .first
              //                                         .image!
              //                                         .dynamicUrl
              //                                         .toString()),
              //                           ),
              //                         ),
              //                         width10SizedBox,
              //                         Flexible(
              //                           flex: 8,
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Text(
              //                                   transactionDetailController
              //                                           .getOrderItems[index]
              //                                           .product!
              //                                           .productName ??
              //                                       "",
              //                                   style: const TextStyle(
              //                                       color: AppColors.black,
              //                                       fontWeight: FontWeight.w600,
              //                                       fontSize: 16)),
              //                               height5SizedBox,
              //                               Text(
              //                                   transactionDetailController
              //                                           .getOrderItems[index]
              //                                           .product!
              //                                           .description ??
              //                                       "",
              //                                   style: TextStyle(
              //                                       color: AppColors.blacklight,
              //                                       fontWeight: FontWeight.w400,
              //                                       fontSize: 14)),
              //                               height12SizedBox,
              //                               Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment
              //                                         .spaceBetween,
              //                                 children: [
              //                                   Row(
              //                                     children: [
              //                                       Text(
              //                                           "${StringConstants.qtyText.toUpperCase()}: ",
              //                                           style: TextStyle(
              //                                               color: AppColors
              //                                                   .blacklight,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                               fontSize: 14)),
              //                                       Text(
              //                                           transactionDetailController
              //                                               .getOrderItems[
              //                                                   index]
              //                                               .product!
              //                                               .quantity
              //                                               .toString(),
              //                                           style: TextStyle(
              //                                               color: AppColors
              //                                                   .blacklight,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                               fontSize: 14)),
              //                                     ],
              //                                   ),
              //                                   Row(
              //                                     children: [
              //                                       Text(
              //                                           "${StringConstants.unitPriceText}: ",
              //                                           style: TextStyle(
              //                                               color: AppColors
              //                                                   .blacklight,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                               fontSize: 14)),
              //                                       Text(
              //                                           transactionDetailController
              //                                               .getOrderItems[
              //                                                   index]
              //                                               .product!
              //                                               .productPrice
              //                                               .toString(),
              //                                           style: TextStyle(
              //                                               color: AppColors
              //                                                   .blacklight,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                               fontSize: 14)),
              //                                     ],
              //                                   )
              //                                 ],
              //                               ),
              //                               height6SizedBox,
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ]),
              //                 ),
              //               );
              //             }))
              // )
            ]),
          ),
        ],
      ),
    );
  }
}
