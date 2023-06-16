import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/orders/controller/orders_home_main_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import '../view/component/order_status_enum.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
class MarkReturnOrderScreen extends StatefulWidget {
  const MarkReturnOrderScreen({super.key});

  @override
  State<MarkReturnOrderScreen> createState() => _MarkReturnOrderScreenState();
}

class _MarkReturnOrderScreenState extends State<MarkReturnOrderScreen> {
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
                                 Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
                                  // Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.returnRequestText,
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
                                            overflow: TextOverflow.ellipsis,
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      Expanded(child:  Text(
                                          ordersHomeMainController
                                              .orderDate.value,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),)

                                    ]),
                                    height4SizedBox,
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              "${StringConstants.orderType}: ",
                                              style: TextStyle(
                                                  overflow: TextOverflow.visible,
                                                  color: AppColors.blacklight,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                          Expanded(child:  Text(
                                              ordersHomeMainController.getStoreOrderDetailModel.value.data?.order
                                                  ?.deliveryService?.deliveryServiceName??"",
                                              style: const TextStyle( overflow: TextOverflow.ellipsis,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),)

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
                            height: 10,
                            color: AppColors.blacklight,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: const BoxDecoration(
                                color: AppColors.greylight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1)),
                                        child: Image.asset(
                                          ImageConstants.licenseImg,
                                          fit: BoxFit.fill,
                                          height: 40,
                                          width: 55,
                                        ),
                                      ),
                                      width8SizedBox,
                                      Text(
                                          StringConstants.identityProofText,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16)),
                                    ],
                                  ),

                                  InkWell(
                                    onTap: (){
                                      if(ordersHomeMainController
                                          .getStoreOrderDetailModel.value.data
                                          ?.userProof?.image?.dynamicUrl !=
                                          null ){
                                        showDialog(
                                          context: Get.context!,
                                          barrierDismissible: false,
                                          builder: (_) => AlertDialog(
                                            icon: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  // Navigator.pop(_);
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: AppColors.primary,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            content: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  height10SizedBox,
                                                  Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          border: Border.all(
                                                              color: AppColors.white,
                                                              width: 1)),
                                                      child: ordersHomeMainController
                                                          .getStoreOrderDetailModel.value.data
                                                          ?.userProof?.image?.dynamicUrl ==
                                                          null ||
                                                          ordersHomeMainController
                                                              .getStoreOrderDetailModel.value.data
                                                          !.userProof!.image!.dynamicUrl!.isEmpty
                                                          ? Image.asset(
                                                        ImageConstants.nopicfound,
                                                        fit: BoxFit.fill,   color: AppColors.grey.withOpacity(0.4),
                                                        height: 200,
                                                      )
                                                          : Image.network(
                                                        ordersHomeMainController
                                                            .getStoreOrderDetailModel
                                                            .value.data?.userProof?.image?.dynamicUrl.toString()??"",
                                                        height: 200,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: const <Widget>[],
                                          ),
                                        );
                                      }

                                    },
                                    child:Text( StringConstants.viewText,
                                        style: const TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: AppColors
                                                .primary,
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ]),
                          ),

                          Divider(
                            height: 10,
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
                            return Visibility(
                              visible: ordersHomeMainController
                                  .getOrderItems[index].orderItemStatus == OrderStatus.returnRequest.statusName,
                              child: InkWell(
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
                                                  ? Image.asset(ImageConstants.nopicfound,   color: AppColors.grey.withOpacity(0.4),)
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
                              ),
                            );
                          })))
            ]),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  border: Border.all(
                    color: AppColors.blacklight,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.white, AppColors.white],
                  ),
                  onTap: () {
                    Utility.showConfirmAlertMessage(
                        AlertStringConstants.rejectReturnOrderAlertText,
                        okay: StringConstants.yesText,cancelText:  StringConstants.noText,
                        okayTap: (){
                          ordersHomeMainController.apiRejectReturnRequest(context);
                        });

                  },
                  height: 50,
                  width: WidgetConstants.screenWidth *0.42,
                  text: StringConstants.rejectText,
                  textColor: AppColors.red,
                  borderRadius: 14,
                  fontWeight: FontWeight.w500,
                  iconL: false,
                  iconR: false,
                  fontSize: 16,
                ),
                CustomButton(
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primary],
                  ),
                  onTap: () {
                    Utility.showConfirmAlertMessage(
                        AlertStringConstants.areYouSureToConfirmReturnText,
                        okay: StringConstants.yesText,cancelText:  StringConstants.noText,
                        okayTap: (){
                          ordersHomeMainController.apiCompleteReturnRequest(context);
                        });

                  },
                  height: 50,
                  width: WidgetConstants.screenWidth *0.42,
                  text: StringConstants.acceptText,
                  textColor: AppColors.white,
                  borderRadius: 14,
                  fontWeight: FontWeight.w500,
                  iconL: false,
                  iconR: false,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
