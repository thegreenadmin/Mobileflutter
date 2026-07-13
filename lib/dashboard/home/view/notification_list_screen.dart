import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/notification_list_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_order_status_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/mark_return_order_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'customer/components/store_home_main_args.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> with GlobalVarMixin{
  final NotificationListController notificationListController =
      Get.put(NotificationListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildBody());
  }

   buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            buildPreferredSize(),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Column(children: [
                    Expanded(
                      child: Obx(() => notificationListController
                              .notificationList.isEmpty
                          ? notificationListController.isLoading.value == true
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
                                        StringConstants.noNotificationFoundYetText,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                          : ListView.separated(
                          padding: EdgeInsets.zero,
                              separatorBuilder: (BuildContext context, int index) {
                                return height12SizedBox;
                              },
                              itemCount:
                                  notificationListController.notificationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      final notification = notificationListController.notificationList[index];
                                      final storeId = notification.storeId ?? "";
                                      final storeName = notification.store?.storeName ?? "";
                                      final orderId = notification.orderId ?? "";

                                      final messageHeadId = notification.messageHeadId ?? "";
                                      final offerId = notification.offerId;

                                      // Role check
                                      final isStoreNotification = notification.isNotificationForStore == true;
                                      final isCustomer = roleApp.value == Role.customerRoleText;

                                      // Role assignment
                                      roleApp(isStoreNotification ? Role.storeOwnerRoleText : Role.customerRoleText);
                                      // return;
                                      // Navigation Logic
                                      if (orderId.isNotEmpty) {
                                        if (isStoreNotification) {
                                          // Redirect to order detail

                                          final orderStatus = notification.title!.toLowerCase().contains("received a new order") ? "received"
                                              : notification.title!.toLowerCase().contains("received a return request") ? "returnRequest"
                                              : notification.title!.toLowerCase().contains("reached the store for pickup the Order") ? "pickup"
                                              :"delivered";
                                         /* if(orderStatus == "received"){
                                            Get.to(() =>  MarkOrderStatusScreen(
                                              orderId: orderId, storeId: storeId,
                                              orderStatus: orderStatus,
                                              isFromNotification: true,
                                            ), id: pageIdApp.value);

                                          }else if (orderStatus == "returnRequest"){
                                            // Get.to(() =>  MarkReturnOrderScreen(
                                            //   orderId: orderId, storeId: storeId,
                                            // ), id: pageIdApp.value);

                                          }else if (orderStatus == "pickup"){
                                            Get.to(() =>  MarkOrderStatusScreen(
                                              orderId: orderId, storeId: storeId,
                                              orderStatus: orderStatus,
                                              isFromNotification: true,
                                            ), id: pageIdApp.value);

                                          }else{*/
                                            Get.to(() =>  MarkOrderStatusScreen(
                                              orderId: orderId, storeId: storeId,
                                              orderStatus: "delivered", //orderStatus
                                              isFromNotification: true,
                                            ), id: pageIdApp.value);

                                          // }
                                        } else {
                                          Get.to(
                                                () => OrderConfirmationScreen(
                                              isFromTransaction: false,
                                              isFromNotification: true,
                                              orderId: orderId,
                                              orderStatus: orderId,
                                              storeId: storeId,
                                              isHome: false,
                                            ),
                                            id: pageIdApp.value,
                                          );
                                        }
                                      } else if (offerId != null) {
                                        Get.to(
                                              () => StoreHomeMainScreen(
                                            args: StoreHomeMainArgs(
                                              storeId: storeId,
                                              isFromMenu: false,
                                              isFromFav: false,
                                              isFromHome: true,
                                              isFromOptions: false,
                                            ),
                                          ),
                                          id: pageIdApp.value,
                                        );
                                      } else if (messageHeadId.isNotEmpty) {
                                        Get.to(
                                              () => isCustomer
                                              ? UserInboxDetailScreen(
                                            storeId: storeId,
                                            storeName: storeName,
                                            messageHeadId: messageHeadId,
                                          )
                                              : OwnerInboxDetailScreen(
                                            storeId: storeId,
                                            storeName: storeName,
                                            messageHeadId: messageHeadId,
                                          ),
                                          id: pageIdApp.value,
                                        );
                                      } else if (notification.type == "payment" ||
                                          notification.store == null) {
                                        // Storeless payment notification: nothing
                                        // to open, so don't surface an error.
                                      } else {
                                        Utility.showAlertMessage("Unable to process notification.");
                                      }
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
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: AppColors.white,
                                                      width: 1)),
                                              child: CommonWidgets
                                                  .circleCachedNetworkImage(
                                                notificationListController
                                                        .notificationList[index]
                                                        .store
                                                        ?.logo
                                                        ?.dynamicUrl
                                                        .toString() ??
                                                    "",
                                                fit: BoxFit.contain,
                                                radius: 22.0,
                                                // Storeless payment notification:
                                                // fall back to the app logo.
                                                assetImg: notificationListController
                                                            .notificationList[index]
                                                            .store ==
                                                        null
                                                    ? ImageConstants.homeMall
                                                    : ImageConstants.nopicfound,
                                              ),
                                            ),
                                          ),
                                          width8SizedBox,
                                          Flexible(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  // Payment rows: bold title
                                                  // ("Payment sent"). Store rows:
                                                  // the store name.
                                                  ((notificationListController
                                                                      .notificationList[index]
                                                                      .type ==
                                                                  "payment" ||
                                                              notificationListController
                                                                      .notificationList[index]
                                                                      .store ==
                                                                  null)
                                                          ? notificationListController
                                                              .notificationList[index]
                                                              .title
                                                          : notificationListController
                                                              .notificationList[index]
                                                              .store
                                                              ?.storeName) ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                height4SizedBox,
                                                Text(
                                                  // Payment rows: the detail line
                                                  // ("You paid $20.00 to qwerty.").
                                                  // Store rows: the notification
                                                  // title.
                                                  ((notificationListController
                                                                      .notificationList[index]
                                                                      .type ==
                                                                  "payment" ||
                                                              notificationListController
                                                                      .notificationList[index]
                                                                      .store ==
                                                                  null)
                                                          ? notificationListController
                                                              .notificationList[index]
                                                              .message
                                                          : notificationListController
                                                              .notificationList[index]
                                                              .title) ??
                                                      "",

                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                height4SizedBox,
                                                Text(
                                                  Utility.parseDateTime(
                                                    DateTime.parse(
                                                      notificationListController
                                                              .notificationList[index]
                                                              .createdAt ??
                                                          "",
                                                    ),
                                                    secFormat: '',
                                                  ).toString(),

                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: AppColors.blackLight,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ]),
                                  ),
                                );
                              })),
                    ),
                  ]),
                ),
            ),
          ],
        ),
        //LOADING OVERLAY
        Obx(() {
          return notificationListController.isLoading.value
              ? Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),)
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
          preferredSize: Size.fromHeight(WidgetConstants.screenHeight * 0.112),
          child: Container(
            color: AppColors.primaryLight,
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 20, top: 50,bottom: 10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageConstants.homeMall,
                                scale: 4,
                              ),
                              width10SizedBox,
                              IconButton(
                                padding: EdgeInsets.all(5),
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
                                StringConstants.notificationsText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ]),
                  ],
                )),
          ));
  }
}
