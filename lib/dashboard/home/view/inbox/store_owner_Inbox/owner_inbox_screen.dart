import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/owner_inbox_controller.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/store_owner_Inbox/owner_inbox_detail_screen.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

class OwnerInboxScreen extends StatefulWidget {
  const OwnerInboxScreen({Key? key}) : super(key: key);

  @override
  State<OwnerInboxScreen> createState() => _OwnerInboxScreenState();
}

class _OwnerInboxScreenState extends State<OwnerInboxScreen> with GlobalVarMixin{
  final OwnerInboxController ownerInboxController =
      Get.put(OwnerInboxController());

  @override
  void initState() {
    // Check if user is guest - show modal for account-based features
    if (isGuest.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GuestAccessModal.show(
          title: "Login Required",
          message: "Please login to access inbox",
          onContinueAsGuest: () {
            // Allow guest to continue - just close modal and go back
            Get.back();
          },
        );
      });
      super.initState();
      return;
    }
    super.initState();
  }

  Container _messageTab() {
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
                      ? AppColors.primaryLight
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
                              : AppColors.blackLight,
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
                      : AppColors.primaryLight,
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
                              ? AppColors.blackLight
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
        body: Stack(
          children: [
            Column(
              children: [
                PreferredSize(
                    preferredSize: const Size.fromHeight(80.0),
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
                                          padding: EdgeInsets.all(10),
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
                                          StringConstants.inboxText,
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
                    )),
                Expanded(
                  child: Container(
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
                            padding: EdgeInsets.zero,
                                separatorBuilder: (BuildContext context, int index) {
                                  return height12SizedBox;
                                },
                                itemCount: ownerInboxController.inboxList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
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
                                                      color: AppColors.white, width: 1)),
                                              child:
                                                  CommonWidgets.circleCachedNetworkImage(
                                                ownerInboxController.inboxList[index]
                                                        .store?.logo?.dynamicUrl
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: ownerInboxController
                                                                              .inboxList[
                                                                                  index]
                                                                              .offer
                                                                              ?.offerName !=
                                                                          null &&
                                                                      ownerInboxController
                                                                              .inboxList[
                                                                                  index]
                                                                              .offer
                                                                              ?.offerName !=
                                                                          ""
                                                                  ? ownerInboxController
                                                                          .inboxList[
                                                                              index]
                                                                          .offer
                                                                          ?.offerName ??
                                                                      ""
                                                                  : "${ownerInboxController.inboxList[index].user?.firstName ?? ""} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}",
                                                              style: const TextStyle(
                                                                  fontSize: 16.0,
                                                                  color: AppColors.black,
                                                                  fontWeight:
                                                                      FontWeight.w600),
                                                            ),
                                                            TextSpan(
                                                              text: ownerInboxController
                                                                              .inboxList[
                                                                                  index]
                                                                              .orderId ==
                                                                          null &&
                                                                      ownerInboxController
                                                                              .inboxList[
                                                                                  index]
                                                                              .offerId ==
                                                                          null
                                                                  ? " - ${StringConstants.contactUsRequestText}"
                                                                  : ownerInboxController
                                                                              .inboxList[
                                                                                  index]
                                                                              .orderId !=
                                                                          null
                                                                      ? " - ${StringConstants.orderIdText.toUpperCase()} "
                                                                          "#${ownerInboxController.inboxList[index].orderId}"
                                                                      : ownerInboxController
                                                                                  .inboxList[
                                                                                      index]
                                                                                  .offerId !=
                                                                              null
                                                                          ? " - ${StringConstants.offerIdText.toUpperCase()} "
                                                                              "#${ownerInboxController.inboxList[index].offerId}"
                                                                          : "",
                                                              style: const TextStyle(
                                                                  fontSize: 16.0,
                                                                  color: AppColors.black,
                                                                  fontWeight:
                                                                      FontWeight.w600),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                        //overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                /* height4SizedBox,
                                                Text(
                                                  ownerInboxController
                                                              .inboxList[index].orderId ==
                                                          null
                                                      ? ownerInboxController
                                                              .inboxList[index]
                                                              .offer?.offerName ??
                                                          ""
                                                      : "Order: "
                                                          "#${ownerInboxController.inboxList[index].orderId}",
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),*/
                                                height4SizedBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    RawMaterialButton(
                                                      elevation: 0,
                                                      onPressed: () {
                                                        // Get.parameters["storeName"] =
                                                        //     ownerInboxController
                                                        //             .inboxList[index]
                                                        //             .store!
                                                        //             .storeName ??
                                                        //         "";
                                                        // Get.parameters["storeId"] =
                                                        //     ownerInboxController
                                                        //             .inboxList[index]
                                                        //             .store!
                                                        //             .storeId ??
                                                        //         "";
                                                        // Get.parameters["messageHeadId"] =
                                                        //     ownerInboxController
                                                        //             .inboxList[index]
                                                        //             .messageHeadId ??
                                                        //         "";
                                                        // Get.parameters["customerName"] =
                                                        //     " ${ownerInboxController.inboxList[index].user?.firstName} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}";
                                                        Get.to(
                                                                () =>
                                                                     OwnerInboxDetailScreen(
                                                                      storeId: ownerInboxController
                                                                          .inboxList[index]
                                                                          .store!
                                                                          .storeId ??
                                                                          "",storeName: ownerInboxController
                                                                         .inboxList[index]
                                                                         .store!
                                                                         .storeName ??
                                                                         "",customerName:  " ${ownerInboxController.inboxList[index].user?.firstName} ${ownerInboxController.inboxList[index].user?.lastName ?? ""}",
                                                                       messageHeadId: ownerInboxController
                                                                         .inboxList[index]
                                                                         .messageHeadId ??
                                                                         "",
                                                                    ),
                                                                id: pageIdApp.value,)!
                                                            .then((value) {
                                                          ownerInboxController
                                                              .apiGetInboxList(
                                                                  showLoading: false);
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
                                                    Visibility(
                                                      visible: ownerInboxController
                                                              .showPreviousMessages
                                                              .value ==
                                                          false,
                                                      child: RawMaterialButton(
                                                        elevation: 0,
                                                        onPressed: () async {
                                                          Utility.showConfirmAlertMessage(
                                                              AlertStringConstants
                                                                  .areYouSureCompleteText,
                                                              okay: StringConstants
                                                                  .completeText,
                                                              okayTap: () {
                                                            // Navigator.pop(Get.context!);
                                                            ownerInboxController
                                                                .apiDeleteStoreMessages(
                                                                    messageHeadId:
                                                                        ownerInboxController
                                                                                .inboxList[
                                                                                    index]
                                                                                .messageHeadId ??
                                                                            "",
                                                                    storeId:
                                                                        ownerInboxController
                                                                                .inboxList[
                                                                                    index]
                                                                                .storeId ??
                                                                            "");
                                                          });
                                                        },
                                                        constraints:
                                                            const BoxConstraints(),
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
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
                                                          StringConstants.completeText,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14.0,
                                                              color: AppColors.black),
                                                        ),
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
                  ),
                ),
              ],
            ),
            //LOADING OVERLAY
            Obx(() {
              return ownerInboxController.isLoading.value
                  ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),)
                  : const SizedBox.shrink();
            }),
          ],
        ));
  }
}
