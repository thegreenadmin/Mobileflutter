import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/notification_list_controller.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/dashboard/offers/view/offers_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/order_confirmation_screen.dart';
import 'package:thegreenmall/dashboard/orders/view/orders_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final NotificationListController notificationListController =
      Get.put(NotificationListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
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
                      separatorBuilder: (BuildContext context, int index) {
                        return height12SizedBox;
                      },
                      itemCount:
                          notificationListController.notificationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            //  SharedPreferenceStorage.setData("context", context);
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

                            Get.parameters["isFromNotification"] = "true";

                            notificationListController
                                        .notificationList[index].orderId !=
                                    null
                                ? /*Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const OrdersScreen(),
                                  ))*/

                                notificationListController
                                        .notificationList[index]
                                        .isNotificationForStore!
                                    ? Get.to(const OrdersHomeMainScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                            "isFromNotification": true,
                                            "storeId":
                                                notificationListController
                                                        .notificationList[index]
                                                        .storeId ??
                                                    ""
                                          })
                                    : Get.to(const OrderConfirmationScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                            "isFromNotification": true,
                                            "storeId":
                                                notificationListController
                                                        .notificationList[index]
                                                        .storeId ??
                                                    ""
                                          })
                                : notificationListController
                                            .notificationList[index].offerId !=
                                        null
                                    ? /*Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (_) => const OrdersScreen(),
                                      ))*/
                                    Get.to(const OffersScreen(),
                                        id: pageIdApp.value,
                                        arguments: {
                                            "isFromNotification": true,
                                          })
                                    : notificationListController
                                                .notificationList[index]
                                                .messageHeadId !=
                                            null
                                        ? roleApp.value == Role.customerRoleText
                                            ? /*Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                builder: (_) =>
                                                    const OwnerInboxDetailScreen(),
                                              ))*/
                                            Get.to(
                                                const OwnerInboxDetailScreen(),
                                                id: pageIdApp.value,
                                                arguments: {
                                                    "storeId":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .storeId,
                                                    "storeName":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .store!
                                                            .storeName,
                                                    "messageHeadId":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .messageHeadId,
                                                  })
                                            : /*Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                builder: (_) =>
                                                    const UserInboxDetailScreen(),
                                              ))*/
                                            Get.to(
                                                const UserInboxDetailScreen(),
                                                id: pageIdApp.value,
                                                arguments: {
                                                    "storeId":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .storeId,
                                                    "storeName":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .store!
                                                            .storeName,
                                                    "messageHeadId":
                                                        notificationListController
                                                            .notificationList[
                                                                index]
                                                            .messageHeadId,
                                                  })
                                        : null;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                                color: AppColors.greylight,
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
                                      child: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage:
                                            notificationListController
                                                            .notificationList[
                                                                index]
                                                            .store
                                                            ?.logo
                                                            ?.dynamicUrl ==
                                                        null ||
                                                    notificationListController
                                                        .notificationList[index]
                                                        .store!
                                                        .logo!
                                                        .dynamicUrl!
                                                        .isEmpty
                                                ? const AssetImage(
                                                    ImageConstants.nopicfound,
                                                  ) as ImageProvider
                                                : NetworkImage(
                                                    notificationListController
                                                            .notificationList[
                                                                index]
                                                            .store
                                                            ?.logo
                                                            ?.dynamicUrl
                                                            .toString() ??
                                                        ""),
                                        backgroundColor: Colors.transparent,
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
                                              color: AppColors.blacklight,
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
        ));
  }
}
