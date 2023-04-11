import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/owner_inbox_controller.dart';
import 'package:thegreenmall/dashboard/home/controller/user_inbox_controller.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/user_inbox_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OwnerInboxScreen extends StatefulWidget {
  const OwnerInboxScreen({Key? key}) : super(key: key);

  @override
  State<OwnerInboxScreen> createState() => _OwnerInboxScreenState();
}

class _OwnerInboxScreenState extends State<OwnerInboxScreen> {
  final OwnerInboxController ownerInboxController =
      Get.put(OwnerInboxController());

  Container _messageTab() {
    return Container(
      height: 47,
      width: WidgetConstants.screenWidth * 0.90,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
            width: 0, //
            color: AppColors.blacklight),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (ownerInboxController.isInboxSelected.value == true) {
                  } else {
                    ownerInboxController.showPreviousMessages.value = false;
                    ownerInboxController.isInboxSelected.value =
                        !ownerInboxController.isInboxSelected.value;
                    ownerInboxController.apiGetInboxList();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: ownerInboxController.isInboxSelected.value
                      ? AppColors.primarylight
                      : AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.messageText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ownerInboxController.isInboxSelected.value
                              ? AppColors.primary
                              : AppColors.blacklight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (ownerInboxController.isInboxSelected.value == false) {
                  } else {
                    ownerInboxController.showPreviousMessages.value = true;
                    ownerInboxController.isInboxSelected.value =
                        !ownerInboxController.isInboxSelected.value;
                    ownerInboxController.apiGetInboxList();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 47,
                  width: WidgetConstants.screenWidth * 0.40,
                  color: ownerInboxController.isInboxSelected.value
                      ? AppColors.white
                      : AppColors.primarylight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.pastMessagesText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ownerInboxController.isInboxSelected.value
                              ? AppColors.blacklight
                              : AppColors.primary,
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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
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
                                  StringConstants.inboxText,
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
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(children: [
            Center(child: _messageTab()),
            height20SizedBox,
            Expanded(
              child: Obx(() => ownerInboxController.inboxList.isEmpty
                  ? ownerInboxController.isLoading.value == true
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
                                StringConstants.noMessagesFountText,
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
                      itemCount: ownerInboxController.inboxList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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
                                            color: AppColors.white, width: 1)),
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage: ownerInboxController
                                                      .inboxList[index]
                                                      .store
                                                      ?.logo
                                                      ?.dynamicUrl ==
                                                  null ||
                                              ownerInboxController
                                                  .inboxList[index]
                                                  .store!
                                                  .logo!
                                                  .dynamicUrl!
                                                  .isEmpty
                                          ? const AssetImage(
                                              ImageConstants.nopicfound,
                                            ) as ImageProvider
                                          : NetworkImage(ownerInboxController
                                                  .inboxList[index]
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
                                        ownerInboxController.inboxList[index]
                                                .store!.storeName ??
                                            "",
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      height4SizedBox,
                                      Text(
                                        ownerInboxController
                                                    .inboxList[index].orderId ==
                                                null
                                            ?
                                            // ownerInboxController
                                            //             .inboxList[index].offer ==
                                            //         null
                                            //     ?
                                            ownerInboxController
                                                    .inboxList[index]
                                                    .offer!
                                                    .offerName ??
                                                ""
                                            // :
                                            //  ownerInboxController
                                            //         .inboxList[index].orderId ??
                                            //     ""
                                            : "Order: "
                                                "#${ownerInboxController.inboxList[index].orderId}",
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      height4SizedBox,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RawMaterialButton(
                                            elevation: 0,
                                            onPressed: () {
                                              Get.to(
                                                  const UserInboxDetailScreen(),
                                                  arguments: {
                                                    "storeName":
                                                        ownerInboxController
                                                                .inboxList[
                                                                    index]
                                                                .store!
                                                                .storeName ??
                                                            "",
                                                    "storeId":
                                                        ownerInboxController
                                                                .inboxList[
                                                                    index]
                                                                .store!
                                                                .storeId ??
                                                            "",
                                                    "messageHeadId":
                                                        ownerInboxController
                                                                .inboxList[
                                                                    index]
                                                                .messageHeadId ??
                                                            ""
                                                  });
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.fromLTRB(
                                                16.0, 8.0, 16.0, 8.0),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: AppColors.primary),
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                            ),
                                            fillColor: AppColors.primary,
                                            child: Text(
                                              StringConstants.seeMoreText,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          width10SizedBox,
                                          RawMaterialButton(
                                            elevation: 0,
                                            onPressed: () async {
                                              return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      StringConstants.alertText,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 20),
                                                    ),
                                                    content: Text(
                                                        AlertStringConstants
                                                            .areYouSureText,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 20)),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                              StringConstants
                                                                  .deleteText)),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors.primary,
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                            StringConstants
                                                                .cancelText),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.fromLTRB(
                                                18.0, 8.0, 18.0, 8.0),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: AppColors.primary),
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                            ),
                                            fillColor: AppColors.white,
                                            child: Text(
                                              StringConstants.removeText,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                  color: AppColors.black),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]),
                        );
                      })),
            ),
          ]),
        ));
  }
}
