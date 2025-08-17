import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/notification_list_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
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
                                /*  onTap: () {
                                    Get.parameters["storeId"] =
                                        notificationListController
                                                .notificationList[index].storeId ??
                                            "";
                                    Get.parameters["storeName"] =
                                        notificationListController
                                                .notificationList[index]
                                                .store
                                                ?.storeName ??
                                            "";
                                    Get.parameters["messageHeadId"] =
                                        notificationListController
                                                .notificationList[index]
                                                .messageHeadId ??
                                            "";

                                    Get.parameters["orderStatus"] =
                                        notificationListController
                                                .notificationList[index].orderId ??
                                            "";
                                    Get.parameters["orderId"] =
                                        notificationListController
                                                .notificationList[index].orderId ??
                                            "";
                                    Get.parameters["isController"] = "yes";
                                    Get.parameters["isFromNotification"] = "true";

                                    notificationListController.notificationList[index]
                                        .isNotificationForStore!
                                        ? roleApp(Role.storeOwnerRoleText)
                                        : roleApp(Role.customerRoleText);
                                    notificationListController
                                                    .notificationList[index].orderId !=
                                                null &&
                                            notificationListController
                                                .notificationList[index]
                                                .isNotificationForStore!
                                        ? Get.put(OrdersHomeMainController()).onInit()
                                        : null;
                                    notificationListController
                                                .notificationList[index].orderId !=
                                            null
                                        ? notificationListController
                                                .notificationList[index]
                                                .isNotificationForStore!
                                            ? Get.to(
                                                () =>  OrdersHomeMainScreen(
                                                  isFromTransaction: false,
                                                  isFromNotification: true,
                                                  orderId: notificationListController
                                                      .notificationList[index].orderId ??
                                                      "",
                                                  orderStatus: notificationListController
                                                      .notificationList[index].orderId ??
                                                      "",
                                                  storeId: notificationListController
                                                      .notificationList[index].storeId ??
                                                      "",
                                                  isHome: false,
                                                    storeName:notificationListController
                                                        .notificationList[index].storeId ??
                                                        ""
                                                ),
                                                id: pageIdApp.value,
                                              )
                                            : Get.to(
                                                () =>  OrderConfirmationScreen(
                                                  isFromTransaction: false,
                                                  isFromNotification: true,
                                                  orderId: notificationListController
                                                      .notificationList[index].orderId ??
                                                      "",
                                                  orderStatus: notificationListController
                                                      .notificationList[index].orderId ??
                                                      "",
                                                  storeId: notificationListController
                                                      .notificationList[index].storeId ??
                                                      "",
                                                  isHome: false,
                                                ),
                                                id: pageIdApp.value,
                                              )
                                        : notificationListController
                                                    .notificationList[index].offerId !=
                                                null
                                            ? Get.to(() =>  StoreHomeMainScreen(
                                        args:  StoreHomeMainArgs(
                                          storeId: notificationListController
                                              .notificationList[index].storeId ??
                                              "",
                                          isFromMenu: false,isFromFav: false,
                                          isFromHome: true, isFromOptions: false,
                                        )
                                    ),
                                                id: pageIdApp.value,
                                                *//*arguments: {
                                                    "isFromNotification": true,
                                                  }*//*)
                                            : notificationListController
                                                        .notificationList[index]
                                                        .messageHeadId !=
                                                    null
                                                ? roleApp.value == Role.customerRoleText
                                                    ? Get.to(
                                                        () =>
                                                            UserInboxDetailScreen(
                                                              storeId: notificationListController
                                                                  .notificationList[
                                                              index]
                                                                  .storeId ??
                                                                  "",storeName: notificationListController
                                                                .notificationList[
                                                            index]
                                                                .store!
                                                                .storeName ??
                                                                "",

                                                              // customerName:  " ${ownerInboxController.inboxList[index].user?.firstName} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}",
                                                              messageHeadId: notificationListController
                                                                  .notificationList[
                                                              index]
                                                                  .messageHeadId ??
                                                                  "",
                                                            ),
                                                        id: pageIdApp.value,)
                                                    : Get.to(
                                                        () =>
                                                             OwnerInboxDetailScreen(
                                                               storeId: notificationListController
                                                                   .notificationList[
                                                               index]
                                                                   .storeId ??
                                                                   "",storeName: notificationListController
                                                                 .notificationList[
                                                             index]
                                                                 .store!
                                                                 .storeName ??
                                                                 "",

                                                               // customerName:  " ${ownerInboxController.inboxList[index].user?.firstName} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}",
                                                               messageHeadId: notificationListController
                                                                   .notificationList[
                                                               index]
                                                                   .messageHeadId ??
                                                                   "",
                                                             ),
                                                        id: pageIdApp.value,
                                                        )
                                                : null;
                                  },*/

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

                                      // Navigation Logic
                                      if (orderId.isNotEmpty) {
                                        if (isStoreNotification) {
                                          Get.to(
                                                () => OrdersHomeMainScreen(
                                              isFromTransaction: false,
                                              isFromNotification: true,
                                              orderId: orderId,
                                              orderStatus: orderId,
                                              storeId: storeId,
                                              isHome: false,
                                              storeName: storeName,
                                            ),
                                            id: pageIdApp.value,
                                          );
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
                                            flex: 2,
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
                                                assetImg: ImageConstants.nopicfound,
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
                                                  notificationListController
                                                          .notificationList[index]
                                                          .store!
                                                          .storeName ??
                                                      "",
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                height4SizedBox,
                                                Text(
                                                  notificationListController
                                                          .notificationList[index]
                                                          .title ??
                                                      "",
                                                  textAlign: TextAlign.justify,
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
                                                  textAlign: TextAlign.justify,
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
                          Image.asset(
                            ImageConstants.homeMall,
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          ));
  }
}
