import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thegreenmall/dashboard/home/model/categories_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_order_list_model.dart'
    as order_list;
import 'package:thegreenmall/dashboard/orders/model/get_order_status_list_model.dart';
import 'package:thegreenmall/dashboard/orders/model/get_store_order_list_model.dart'
    as store_order;
import 'package:thegreenmall/dashboard/home/model/user_store_details_response.dart'
    as store;
import 'package:thegreenmall/dashboard/orders/model/order_detail_model.dart'
    as order_detail;
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import '../../../utils/constants.dart';
import '../../home/model/get_store_list_model.dart' as stores;
import '../view/component/order_status_enum.dart';

class OrdersController extends GetxController {
  TextEditingController reviewController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  RxBool isActiveOrders = false.obs;
  RxBool isFromNotification = false.obs;
  RxBool isHome = false.obs;
  RxBool isLoading = false.obs;
  RxBool preventCall = false.obs;
  RxBool isDataLoading = false.obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxString? nickName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString? role = "".obs;
  RxString orderStatus = "".obs;
  RxString storeId = "0".obs;
  RxString productId = "".obs;
  RxString orderType = "".obs;
  RxDouble totalAmount = 0.0.obs;
  RxString orderDate = "".obs;
  RxInt page = 1.obs;
  RxInt uerSelectedTab = 0.obs;
  RxInt totalCount = 1.obs;
  RxInt pageStore = 1.obs;
  RxInt? addressListIndex = 0.obs;
  RxInt activeStep = 0.obs;
  RxInt orderStatusId = 2.obs;
  RxString orderStatusName = OrderStatus.receivedOrder.statusName.obs;
  RxString orderStatusTypeName = OrderStatus.receivedOrder.statusName.obs;
  RxDouble ratingValue = 0.0.obs;
  Rx<store.StoreDetailsResponse> storeDetailsResponse =
      store.StoreDetailsResponse().obs;
  late store_order.StoreOrderListResponse storeOrderListResponse =
      store_order.StoreOrderListResponse();
  late order_list.OrderListResponse orderListResponse =
      order_list.OrderListResponse();
  late OrderStatusListResponse orderStatusListResponse =
      OrderStatusListResponse();
  late order_detail.OrderDetailResponse orderDetailResponse =
      order_detail.OrderDetailResponse();

  late stores.GetStoreListModel getStoreListModel = stores.GetStoreListModel();
  RxList<stores.Stores> storeList = <stores.Stores>[].obs;
  Rx<order_detail.OrderItem> orderItemObj = order_detail.OrderItem().obs;
  RxList<order_detail.OrderItem> orderItems = <order_detail.OrderItem>[].obs;
  RxList<OrderStatusList> orderStatusList = <OrderStatusList>[].obs;
  RxList<order_list.Order> orderList = <order_list.Order>[].obs;
  RxList<store_order.StoreOrder> storeOrderList =
      <store_order.StoreOrder>[].obs;
  RxBool isFavouriteStore = false.obs;
  RxList<Categories> stepInd = [
    Categories(id: 0, name: "Received", isSelected: false),
    Categories(id: 1, name: "In Progress", isSelected: false),
    Categories(id: 2, name: "In-transit", isSelected: false),
    Categories(id: 3, name: "Complete", isSelected: false),
  ].obs;

  @override
  void onInit() {
    firstName?.value =
        SharedPreferenceStorage.getData(StringConstants.firstNameText) ?? "";
    lastName?.value =
        SharedPreferenceStorage.getData(StringConstants.lastNameText) ?? "";
    if ( Get.parameters['isFromNotification'] != "false") {
      isFromNotification.value =
          Get.parameters["isFromNotification"] == "true" ? true : false;
    }
    if (Get.parameters['storeId'] != "" && Get.parameters['storeId'] != null) {
      storeId.value = Get.parameters["storeId"] ?? "";
      if (Get.parameters['isFromTransaction'] == "true" ? true : false) {
        storeId.value = Get.parameters["storeId"] ?? "";
        apiGetStoreDetailsApi();
      }
      apiGetStoreDetailsApi();
    }

    if (Get.parameters["orderStatus"] != null) {
      orderStatus.value = Get.parameters["orderStatus"] ?? "";
    }
    if (Get.parameters["isHome"] != null) {
      isHome.value = Get.parameters["isHome"] == "true" ? true : false;
    }

    isActiveOrders.value = true;
    orderStatusId.value = 2;
    orderStatusName.value = OrderStatus.receivedOrder.statusName;
    role!.value = SharedPreferenceStorage.getData(Role.role.value);
    if (role!.value == Role.customerRoleText) {
      page.value = 1;
      apiGetOrderListApi();
      if (orderStatus.value != "") {
        apiGetOrderDetailsApi();
      }
    } else {
      apiGetStoreList();
      page.value = 1;
      apiGetStoreOrderListApi();
    }

    apiGetOrderStatusListApi();
    setupScrollController();
    super.onInit();
  }

  final scrollController = ScrollController();
  final scrollController1 = ScrollController();

  setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (role!.value == Role.customerRoleText) {
          orderListResponse = order_list.OrderListResponse();
          if (orderList.length < totalCount.value) {
            page.value++;
            apiGetOrderListApi().then((_) => preventCall.value = false);
            preventCall.value = true;
          }
        } else {
          storeOrderListResponse = store_order.StoreOrderListResponse();
          if (storeOrderList.length < totalCount.value) {
            page.value++;
            apiGetStoreOrderListApi().then((_) => preventCall.value = false);
            preventCall.value = true;
          }
        }
      }
    });
  }

  bottomSheetRateNow(BuildContext ctx) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: ctx,
        builder: (BuildContext _ ) {
          return StatefulBuilder(
              builder: (BuildContext ctxX, StateSetter setState) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              StringConstants.ratingText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                reviewController.clear();
                                ratingValue.value = 0.0;
                                Navigator.of(Get.context!).pop();
                                // Get.back();
                              },
                              child: Image.asset(
                                ImageConstants.cross,
                                scale: 2.5,
                              ))
                        ],
                      ),
                      height15SizedBox,
                      Text(
                        StringConstants.shareYourFeedbackText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      height15SizedBox,
                      RatingBar.builder(
                        initialRating: 1.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        unratedColor: Colors.amber.withAlpha(50),
                        itemCount: 5,
                        itemSize: 35.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          // _selectedIcon ?? Icons.star,
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratingValue.value = rating;
                        },
                        updateOnDrag: true,
                      ),
                      height15SizedBox,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          StringConstants.yourThoughtText,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      height4SizedBox,
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: reviewController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterProductNameText;
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: StringConstants.yourThoughtText,
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 14),
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                            ),
                          )),
                      height10SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          Navigator.pop(ctxX);
                          apiCreateReview(ctx);
                        },
                        height: 50,
                        text: StringConstants.submitText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        }).then((value) => {});
  }

  bottomSheetReturnOrder(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        context: context,
        builder: (BuildContext _) {
          return StatefulBuilder(
              builder: (BuildContext ctxx, StateSetter setState) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              StringConstants.returnOrderText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(ctxx).pop();
                                // Get.back();
                              },
                              child: Image.asset(
                                ImageConstants.cross,
                                scale: 2.5,
                              ))
                        ],
                      ),
                      height15SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                    color: AppColors.white, width: 1)),
                            child: orderItemObj.value.product?.productImages
                                            ?.first.image?.dynamicUrl ==
                                        null ||
                                    orderItemObj.value.product!.productImages!
                                        .first.image!.dynamicUrl!.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      ImageConstants.storeicon,
                                      fit: BoxFit.fill,
                                    ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      orderItemObj.value.product?.productImages
                                              ?.first.image?.dynamicUrl ??
                                          "",
                                      fit: BoxFit.fill,
                                    )),
                          ),
                          width5SizedBox,
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderItemObj.value.product?.productName ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: AppColors.black),
                                ),
                                height6SizedBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${StringConstants.unitPriceText}: ",
                                              style: TextStyle(
                                                  color: AppColors.blacklight,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16)),
                                          TextSpan(
                                            text:
                                                "\$${orderItemObj.value.product?.productPrice.toString() ?? ""}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: AppColors.blacklight),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width20SizedBox,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height15SizedBox,
                      Text(
                        StringConstants.writeReasonText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: reasonController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterProductNameText;
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: StringConstants.yourThoughtText,
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 14),
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                            ),
                          )),
                      height10SizedBox,
                      CustomButton(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          apiReturnOrder(ctxx);
                        },
                        height: 50,
                        text: StringConstants.submitText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        }).then((value) => {});
  }

  void addToCartDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                ImageConstants.tick,
                scale: 3,
              ),
            ),
            height10SizedBox,
            Text(
              StringConstants.returnRequestSentText,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                StringConstants.continueShoppingWithGreenMallText,
                style: TextStyle(
                    color: AppColors.blacklight,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
            ),
            height25SizedBox,
            CustomButton(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primary],
              ),
              onTap: () {},
              height: 50,
              text: StringConstants.backToShoppingText,
              borderRadius: 12,
              fontWeight: FontWeight.w500,
              iconL: false,
              fontSize: 16,
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  //CREATE ITEM REVIEW
  Future apiCreateReview(BuildContext ctx) async {
    isLoading.value = true;
    debugPrint("CREATE ITEM REVIEW URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createItemReview}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "order_id": int.parse(orderStatus.value),
      "product_id": int.parse(productId.value),
      "review": reviewController.text,
      "rating": ratingValue.value.toInt()
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createItemReview,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("CREATE ITEM REVIEW *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        reviewController.clear();
        ratingValue.value = 0.0;
        // Navigator.of(ctx).pop();
        // Get.back();
        // Get.offAll(BottomNavigation());
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(ctx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //RETURN ORDER
  Future apiReturnOrder(BuildContext ctx) async {
    isLoading.value = true;
    debugPrint("RETURN ORDER URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().returnOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderStatus.value),
      "order_items": [
        {
          "order_item_id": int.parse(orderItemObj.value.orderItemId ?? "0"),
          "return_items_count": orderItemObj.value.orderItemCount ?? 0,
          "remarks": reasonController.text
        }
      ]
    };

    debugPrint("REQUEST ********** $data");
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().returnOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("RETURN ORDER *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        reasonController.clear();
        apiGetOrderDetailsApi();
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(ctx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Order Status List Api
  Future apiGetOrderStatusListApi() async {
    isLoading.value = true;
    debugPrint("Order Status List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderStatusList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().orderStatusList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Order Status List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderStatusListResponse = OrderStatusListResponse.fromJson(value?.body);
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Order List Api
  Future apiGetOrderListApi() async {
    if (page.value == 1) {
      orderList.clear();
    }
    orderListResponse = order_list.OrderListResponse();
    isDataLoading.value = orderList.isNotEmpty ? true : false;
    // orderListResponse = order_list.OrderListResponse();
    isLoading.value = orderList.isNotEmpty ? true : false;
    debugPrint("role List URL**********${role!.value}");
    debugPrint("Order List URL****${page.value}******"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map<String, dynamic> data = {
      "store_id": null,
      "page": page.value,
      "page_size": 10,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": null,
      "order_statuses": uerSelectedTab.value ==0 ?
      [
          {
          "order_status_name": OrderStatus.receivedOrder.statusName,
          },
          {
          "order_status_name": OrderStatus.inProgress.statusName,
          },
          {
          "order_status_name": OrderStatus.readyForPickup.statusName,
          },
          {
          "order_status_name": OrderStatus.inTransit.statusName,
          },
          {
          "order_status_name": OrderStatus.returnRequest.statusName,
          },
        ]
          : uerSelectedTab.value ==1 ?
      [
        {
        "order_status_name": OrderStatus.completed.statusName,
        },
        {
        "order_status_name": OrderStatus.returned.statusName,
        },
        {
        "order_status_name": OrderStatus.returnCancelled.statusName,
        },
      ]
          : uerSelectedTab.value ==2 ?
      [
        {
        "order_status_name": OrderStatus.cancelled.statusName,
        },

      ]: []
    };

    log("Order List data ********** ${jsonEncode(data)}");
    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().orderList}",
            headers,
            showLoading: page.value == 1)
        .then((value) async {
      log("Order List *******${page.value}*******${value?.body}");
      isLoading.value = false;
      isDataLoading.value = false;

      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderListResponse = order_list.OrderListResponse.fromJson(value?.body);
        totalCount.value = orderListResponse.data!.totalCount;
        List<order_list.Order>? orders = [];
        orders = orderListResponse.data!.orders ?? [];
        if (orders.isNotEmpty) {
          if (page.value == 1) {
            orderList.value = [];
          }
          orderList.addAll(orders);
        }
        orderList.toSet().toList();

        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);

        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Store Order List Api
  Future apiGetStoreOrderListApi() async {
    if (pageStore.value == 1) {
      storeOrderList.value = [];
    }
    storeOrderListResponse = store_order.StoreOrderListResponse();
    isDataLoading.value = storeOrderList.isNotEmpty ? true : false;
    isLoading.value = storeOrderList.isNotEmpty ? true : false;
    debugPrint("Order List URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": storeId.value,
      "page": page.value,
      "page_size": 10,
      "order_by": "order_id",
      "order_type": "DESC",
      "from_date": null,
      "to_date": null,
      "only_active_orders": null,
      "order_statuses": orderStatusName.value == OrderStatus.receivedOrder.statusName
          ? [
              {"order_status_name": OrderStatus.receivedOrder.statusName},
              {"order_status_name": OrderStatus.returnRequest.statusName},
              {"order_status_name": OrderStatus.returnConfirmed.statusName},
            ]
          : [
              {"order_status_name": orderStatusName.value}
            ]
    };

    debugPrint("PARAMETERS ********** ${jsonEncode(data)}");
    debugPrint("TOKEN ********** ${jsonEncode(headers)}");
    UserProvider()
        .postWithHeadersApi(
            data,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeOrderList}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Order  List *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeOrderListResponse =
            store_order.StoreOrderListResponse.fromJson(value?.body);
        List<store_order.StoreOrder>? orders = [];
        orders = storeOrderListResponse.data!.orders ?? [];
        if (orders.isNotEmpty) {
          if (pageStore.value == 1) {
            storeOrderList.value = [];
          }
          storeOrderList.addAll(orders);
        }
        storeOrderList.toSet().toList();
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Store Details Api
  Future apiGetStoreDetailsApi() async {
    isLoading.value = true;
    debugPrint("STORE DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=&longitude=");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().shopStoreDetails}?store_id=${storeId.value}&latitude=&longitude=",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Store Details*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        debugPrint(
            "isFavouriteStore  *******${storeDetailsResponse.value.data?.store?.isFavouriteStore}");
        storeDetailsResponse.value =
            store.StoreDetailsResponse.fromJson(value?.body);
        isFavouriteStore.value =
            storeDetailsResponse.value.data?.store?.isFavouriteStore ?? false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Store List Api
  Future apiGetStoreList() async {
    isLoading.value = true;
    debugPrint(
        "GET STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeList}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
      "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
        ServerCommunicator().baseUrl + ServerCommunicator().storeList,
        headers,
        showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getStoreListModel = stores.GetStoreListModel.fromJson(value.body);
        storeList.clear();
        storeList.addAll(getStoreListModel.data!.stores as Iterable<stores.Stores>);
        Get.parameters["storeCount"] = storeList.length.toString();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message']!=null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  //Get Order Details Api
  Future apiGetOrderDetailsApi() async {
    isLoading.value = true;
    debugPrint("ORDER DETAIL URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().orderDetail}?store_id=${storeId.value}&order_id=${orderStatus.value}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().orderDetail}?store_id=${storeId.value}&order_id=${orderStatus.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      log("ORDER Details*******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        orderDetailResponse =
            order_detail.OrderDetailResponse.fromJson(value?.body);
        orderItems.value = orderDetailResponse.data?.order?.orderItems ?? [];
        totalAmount.value = orderDetailResponse.data?.order?.totalAmount ?? 0.0;
        orderType.value = orderDetailResponse.data?.order?.deliveryService?.deliveryServiceId ?? "1";
        orderDate.value = orderDetailResponse.data?.order?.createdAt.toString() ?? "0.0";

        orderDetailResponse.data?.order?.orderHistories?.forEach((element) {
          if (element.isCurrentStatus == true) {
            orderStatusTypeName.value = element.orderStatus?.orderStatusName ?? "";

            activeStep.value = element.orderStatus?.orderStatusName ==
                    OrderStatus.receivedOrder.statusName
                ? 0
                :
                element.orderStatus?.orderStatusName ==
                    OrderStatus.inProgress.statusName
                    ? 1
                    : element.orderStatus?.orderStatusName ==
                            OrderStatus.inTransit.statusName ||
                        element.orderStatus?.orderStatusName ==
                        OrderStatus.readyForPickup.statusName
                        ? 2
                        : element.orderStatus?.orderStatusName ==
                                OrderStatus.completed.statusName ||
                             element.orderStatus?.orderStatusName ==
                                 OrderStatus.cancelled.statusName
                            ? 3
                            : 0;
          }
        });

        if (orderDetailResponse.data?.order?.deliveryServiceId == "2") {
          stepInd.firstWhere((element) => element.id == 2).name = "In-transit";
        }else{
          stepInd.firstWhere((element) => element.id == 2).name = "Ready for pickup";
        }

        for (var element in stepInd) {
          if (element.id! <= activeStep.value) {
            element.isSelected = true;
          } else {
            element.isSelected = false;
          }
        }
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Cancel Order Api
  Future apiCancelOrder(context) async {
    isLoading.value = true;
    debugPrint("Cancel Order URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().cancelOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderStatus.value),
      "order_items": [
        {
          "order_item_id": int.parse(orderItemObj.value.orderItemId ?? "0"),
        }
      ]
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().cancelOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Cancel Order *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        // Navigator.of(context).pop();
        BuildContext rContext = SharedPreferenceStorage.getData(
          "context",
        );
        print(rContext);
        Navigator.of(rContext).popUntil((route) => route.isFirst);
        // Get.back();
        // Get.offAll(BottomNavigation());
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Cancel Order Api
  Future apiCancelReturnRequestOrder(context) async {
    isLoading.value = true;
    debugPrint("Cancel Return Request URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().cancelReturnOrder}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderStatus.value),
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().cancelReturnOrder,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Cancel Return Request  *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        orderStatusName.value = OrderStatus.receivedOrder.statusName;
        isActiveOrders.value = true;
        page.value = 1;
        orderList.clear();
        apiGetOrderListApi();
        BuildContext rContext = SharedPreferenceStorage.getData(
          "context",
        );
        Navigator.of(rContext).popUntil((route) => route.isFirst);
        // Get.back();
        // Get.offAll(BottomNavigation());
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Cancel Order Api
  Future apiReadyPickupOrder(BuildContext ctx) async {
    isLoading.value = true;
    debugPrint("Ready Pickup URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().readyPickup}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value),
      "order_id": int.parse(orderStatus.value),
    };

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().readyPickup,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Ready Pickup Response *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        apiGetOrderDetailsApi();
        // Get.back();
        // Get.offAll(BottomNavigation());
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(ctx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Create Favourite Store Api
  Future apiCreateFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Create Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().createFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().createFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Create Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = true;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {

          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Remove Favourite Store Api
  Future apiRemoveFavouriteStore(String? id) async {
    isLoading.value = true;
    debugPrint("Remove Favourite Store URL**********"
        "${ServerCommunicator().baseUrl}${ServerCommunicator().removeFavouriteStore}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };

    Map data = {"store_id": int.parse(id ?? "0")};

    debugPrint("TOKEN ********** $headers");
    debugPrint("data ********** ${data.toString()}");
    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().removeFavouriteStore,
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("Remove Favourite Store *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        isFavouriteStore.value = false;
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
