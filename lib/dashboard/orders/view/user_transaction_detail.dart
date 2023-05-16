import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/user_transaction_detail_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class UserTransactionDetailScreen extends StatefulWidget {
  const UserTransactionDetailScreen({super.key});

  @override
  State<UserTransactionDetailScreen> createState() =>
      _UserTransactionDetailScreenState();
}

class _UserTransactionDetailScreenState
    extends State<UserTransactionDetailScreen> {
  final UserTransactionDetailController userTransactionDetailController =
      Get.put(UserTransactionDetailController());

@override
  void initState() {
   
    super.initState();
    userTransactionDetailController.userStripeCardId!.value = Get.parameters['user_stripe_card_id'] ?? "";
    // userStripeCardId!.value = Get.arguments['user_stripe_card_id'] ?? "";
    userTransactionDetailController.apiGetUserOrderTransactionHistory();
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
                                  Navigator.of(context).pop();
                                  // Get.back();
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
                                "${StringConstants.fullFilledOrdersText} - #${userTransactionDetailController.orderId!.value}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              )),
                          height20SizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: userTransactionDetailController
                                        .storeImage!.value.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1)),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: NetworkImage(
                                              userTransactionDetailController
                                                  .storeImage
                                                  .toString()),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1)),
                                        child: const CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: AssetImage(
                                            ImageConstants.nopicfound,
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
                                        userTransactionDetailController
                                                .storeName!.isEmpty
                                            ? StringConstants
                                                .walletTransactionText
                                            : userTransactionDetailController
                                                .storeName!.value,
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
                                          userTransactionDetailController
                                              .orderDate
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
                                              "\$${userTransactionDetailController.orderAmount!.value}",
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
