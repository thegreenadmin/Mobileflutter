import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/user_inbox_detail_controller.dart';
import 'package:thegreenmall/dashboard/home/model/user_message_list_model.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/image_preview_screen.dart';
import 'package:thegreenmall/utils/guest_access_modal.dart';
import 'package:thegreenmall/utils/utils.dart';

class UserInboxDetailScreen extends StatefulWidget {
  final String? storeName;
  final String? storeId;
  final String? messageHeadId;
  final String? customerName;
  const UserInboxDetailScreen({
    Key? key, this.storeName, this.storeId, this.messageHeadId, this.customerName,
  }) : super(key: key);


  @override
  UserInboxDetailScreenState createState() => UserInboxDetailScreenState();
}

class UserInboxDetailScreenState extends State<UserInboxDetailScreen> with GlobalVarMixin{
  final UserInboxDetailController userInboxDetailController =
      Get.put(UserInboxDetailController());


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
    
    userInboxDetailController.storeId.value = widget.storeId ?? "";
    userInboxDetailController.storeName.value = widget.storeName ?? "";
    userInboxDetailController.messageHeadId.value = widget.messageHeadId ?? "";
    getRole();
    super.initState();
  }

  getRole() async {
    var roleData = await SharedPreferenceStorage.getData(Role.role) ??"";
    userInboxDetailController.role?.value  = roleData;
  }

  SizedBox buildPhotoLibraryGridView() {
    return SizedBox(
        height: 120,
        child:

            Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 100,
              height: 110,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(userInboxDetailController
                      .userSelectedImageDynamicLinkFromServer.value),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  userInboxDetailController
                      .userSelectedImageDynamicLinkFromServer.value = "";
                });
              },
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 10,
                child: Icon(
                  Icons.horizontal_rule,
                  color: AppColors.white,
                  size: 10.0,
                ),
              ),
            )
          ],
        )
        );
  }

  Container _buildMessageComposer() {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        padding: const EdgeInsets.only(right: 5, left: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      )),
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 5, right: 5),
                  padding: const EdgeInsets.only(
                      right: 5, left: 2, top: 5, bottom: 5),
                  child: TextField(
                    onSubmitted: (value) async {},
                    keyboardAppearance: Brightness.light,
                    textInputAction: TextInputAction.done,
                    controller: userInboxDetailController.messageTextController,
                    style: const TextStyle(fontSize: 15),
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              userInboxDetailController
                                  .showSelectionDialog(context);
                            },
                            child: const Icon(
                              Icons.image,
                              color: AppColors.primary,
                              size: 24.0,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      isDense: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: StringConstants.startTypingHereText,
                      hintStyle: TextStyle(
                          color: AppColors.blackLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      counterText: "",
                      contentPadding: const EdgeInsets.only(
                        left: 14,
                        top: 14,
                        bottom: 12,
                        right: 12,
                      ),
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () async {
                if (userInboxDetailController
                        .messageTextController.text.isEmpty &&
                    userInboxDetailController
                        .userSelectedImageOriginalLinkFromServer
                        .value
                        .isNotEmpty) {
                  // FocusScope.of(context).requestFocus(FocusNode());
                  await userInboxDetailController.apiSendMessage();
                } else if (userInboxDetailController
                    .messageTextController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: AlertStringConstants.pleaseWriteSomethingText,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                      fontSize: 14.0);
                } else if (userInboxDetailController
                        .messageTextController.text.isNotEmpty &&
                    userInboxDetailController
                        .userSelectedImageOriginalLinkFromServer
                        .value
                        .isEmpty) {
                  // FocusScope.of(context).requestFocus(FocusNode());
                  await userInboxDetailController.apiSendMessage();
                } else if (userInboxDetailController
                        .messageTextController.text.isNotEmpty &&
                    userInboxDetailController
                        .userSelectedImageOriginalLinkFromServer
                        .value
                        .isNotEmpty) {
                  // FocusScope.of(context).requestFocus(FocusNode());
                  await userInboxDetailController.apiSendMessage();
                }
              },
              child: const Center(
                child: Icon(
                  Icons.send_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ));
  }

  _buildMessage(
    List<Messages> messageList,
    int index,
  ) {
    if (messageList[index].senderType! ==
        StringConstants.storeText.toLowerCase()) {
      return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 60),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageList[index].icon!.dynamicUrl == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: AppColors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                              radius: 25.0,
                              backgroundImage:
                                  AssetImage(ImageConstants.userAccount)))
                      : Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(60.0),
                            ),
                            child: CommonWidgets.cachedNetworkImage(
                              messageList[index].icon!.dynamicUrl.toString(),
                              width: WidgetConstants.screenHeight * 0.06,
                              height: WidgetConstants.screenHeight * 0.06,
                              placeholder: (context, url) => SizedBox(
                                  height: WidgetConstants.screenHeight * 0.05,
                                  child: const Center(
                                      child: CircularProgressIndicator())),
                            ),
                          ),
                        ),
                  width10SizedBox,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[100]!.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              color: AppColors.primary,
                              border:
                                  Border.all(color: AppColors.white, width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              messageList[index].image!.dynamicUrl == "" ||
                                      messageList[index].image!.dynamicUrl ==
                                          null
                                  ? height0SizedBox
                                  : InkWell(
                                      onTap: () {
                                        Get.to(
                                            ImagePreviewScreen(
                                              image: messageList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                            ),
                                            id: pageIdApp.value);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          child:
                                              CommonWidgets.cachedNetworkImage(
                                            messageList[index]
                                                .image!
                                                .dynamicUrl
                                                .toString(),
                                            height:
                                                WidgetConstants.screenHeight *
                                                    0.25,
                                            width: WidgetConstants.screenWidth *
                                                0.4,
                                            placeholder: (context, url) => SizedBox(
                                                height: WidgetConstants
                                                        .screenHeight *
                                                    0.25,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator())),
                                          ),
                                        ),
                                      ),
                                    ),
                              messageList[index].image!.dynamicUrl == "" ||
                                      messageList[index].image!.dynamicUrl ==
                                          null
                                  ? height0SizedBox
                                  : height15SizedBox,
                              InkWell(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            messageList[index].message ?? ""));
                                    Utility.showTopMessage(
                                        StringConstants.messageText,
                                        StringConstants.copiedToClipBoardText);
                                  },
                                  child: Text(messageList[index].message ?? "",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400,
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              //Text(messageList[index].),
                              Text(
                                  Utility.parseDateTime(
                                    DateTime.parse(
                                      messageList[index].createdAt.toString(),
                                    ),
                                    secFormat: '',
                                  ).toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
          ));
    } else {
      return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 55, right: 12),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.1),
                              )
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            )),
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(
                                text: messageList[index].message ?? ""));
                            Utility.showTopMessage(StringConstants.messageText,
                                StringConstants.copiedToClipBoardText);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              messageList[index].image?.dynamicUrl == "" ||
                                      messageList[index].image?.dynamicUrl ==
                                          null
                                  ? height0SizedBox
                                  : InkWell(
                                      onTap: () {
                                        Get.to(
                                            ImagePreviewScreen(
                                              image: messageList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                            ),
                                            id: pageIdApp.value);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          child:
                                              CommonWidgets.cachedNetworkImage(
                                            messageList[index]
                                                .image!
                                                .dynamicUrl
                                                .toString(),
                                            width: WidgetConstants.screenWidth *
                                                0.4,
                                            height:
                                                WidgetConstants.screenHeight *
                                                    0.25,
                                            placeholder: (context, url) => SizedBox(
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.4,
                                                height: WidgetConstants
                                                        .screenHeight *
                                                    0.25,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator())),
                                          ),
                                        ),
                                      ),
                                    ),
                              height10SizedBox,
                              Text(messageList[index].message ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w300,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                      Utility.parseDateTime(
                        DateTime.parse(
                          messageList[index].createdAt.toString(),
                        ),
                        secFormat: '',
                      ).toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.blackLight,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                height5SizedBox

                // messageController.messageList[index].file == null ||
                //         messageController.messageList[index].file.isEmpty
                //     ? Container()
                //     :
                // Container(
                //     width: 200,
                //     child: ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                //         shrinkWrap: true,
                //         itemCount:
                //             messageController.messageList[index].file.length,
                //         itemBuilder: (BuildContext context, int i) {
                //           return Padding(
                //             padding:const EdgeInsets.fromLTRB(0, 5, 5, 0),
                //             child: messageController
                //                             .messageList[index].file[i]
                //                             .split('.')
                //                             .last
                //                             .toString() ==
                //                         "jpg" ||
                //                     messageController
                //                             .messageList[index].file[i]
                //                             .split('.')
                //                             .last
                //                             .toString() ==
                //                         "png" ||
                //                     messageController
                //                             .messageList[index].file[i]
                //                             .split('.')
                //                             .last
                //                             .toString() ==
                //                         "jpeg"
                //                 ? InkWell(
                //                     onTap: () {
                //                       // Get.to(ImagePreviewScreen(
                //                       //     image: _chatController
                //                       //         .messageList[index].file[i]
                //                       //         .toString(),
                //                       //     senderName: widget.receiverName
                //                       //         .toString()
                //                       //         .toString()));
                //                     },
                //                     child: Container(
                //                         height: 150,
                //                         decoration: BoxDecoration(
                //                           border: Border.all(
                //                               color: AppColors.primaryColor,
                //                               width: 5),
                //                           borderRadius:
                //                               BorderRadius.circular(10),
                //                         ),
                //                         child: Image.network(
                //                           messageController
                //                               .messageList[index].file[i],
                //                           fit: BoxFit.cover,
                //                         )),
                //                   )
                //                 : InkWell(
                //                     onTap: () {},
                //                     child: Container(
                //                       padding: const EdgeInsets.all(15),
                //                       decoration: const BoxDecoration(
                //                         gradient: LinearGradient(
                //                             begin: Alignment.topLeft,
                //                             end: Alignment.bottomRight,
                //                             colors: [
                //                               AppColors.primaryColor,
                //                               AppColors.yellowColor
                //                             ]),
                //                         borderRadius: BorderRadius.only(
                //                             topRight: Radius.circular(10),
                //                             topLeft: Radius.circular(10),
                //                             bottomLeft: Radius.circular(10),
                //                             bottomRight: Radius.circular(10)),
                //                       ),
                //                       child: Row(
                //                         children: [
                //                           const Icon(
                //                             Icons.insert_drive_file_rounded,
                //                             size: 25,
                //                             color: AppColors.whiteColor,
                //                           ),
                //                           const SizedBox(
                //                             width: 5,
                //                           ),
                //                           Expanded(
                //                             child: Text(
                //                               messageController
                //                                   .messageList[index].file[i]
                //                                   .split('/')
                //                                   .last
                //                                   .toString(),
                //                               style: const TextStyle(
                //                                 fontSize: 14,
                //                                 color: AppColors.whiteColor,
                //                                 fontWeight: FontWeight.w600,
                //                               ),
                //                               overflow: TextOverflow.ellipsis,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //           );
                //         }),
                //   )
              ],
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Column(
              children: [
                PreferredSize(
                    preferredSize: const Size.fromHeight(80.0),
                    child: Container(
                      color: AppColors.primaryLight,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 20, top: 50,bottom: 10),
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
                                        Obx(() => Text(
                                          userInboxDetailController.storeName.value,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600),
                                        )),
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
                Obx(() => Expanded(
                      child: userInboxDetailController.messageList.isEmpty
                          ? SizedBox(
                              height: WidgetConstants.screenHeight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  userInboxDetailController.isLoading.value
                                      ? height0SizedBox
                                      : Column(
                                          children: [
                                            height20SizedBox,
                                            Image.asset(
                                              ImageConstants.nodata,
                                              color: AppColors.primary,
                                              scale: 8,
                                            ),
                                            Text(
                                              StringConstants.noMessagesYetText,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              primary: false,
                              controller:
                                  userInboxDetailController.scrollController,
                              padding: const EdgeInsets.only(bottom: 10),
                              // itemCount: searchStoreUserController
                              //     .storeAddresses.length +
                              //     (searchStoreUserController.isLoading.value ? 1 : 0),
                              itemCount: userInboxDetailController
                                      .messageList.isEmpty
                                  ? 1
                                  : userInboxDetailController
                                          .messageList.length +
                                      (userInboxDetailController.isLoading.value
                                          ? 1
                                          : 0),
                              itemBuilder: (context, index) {
                                if (index <
                                    userInboxDetailController
                                        .messageList.length) {
                                  return _buildMessage(
                                    userInboxDetailController.messageList,
                                    index,
                                  );
                                } else if (userInboxDetailController
                                    .isLoading.value) {
                                  Timer(const Duration(milliseconds: 10), () {
                                    userInboxDetailController.scrollController
                                        .jumpTo(userInboxDetailController
                                            .scrollController
                                            .position
                                            .maxScrollExtent);
                                  });
                                  return CommonWidgets.loadingIndicator();
                                } else {
                                  return const SizedBox();
                                }
                              }),
                    )),
                _buildMessageComposer(),
                GetBuilder<UserInboxDetailController>(
                    builder: (userInboxDetailController) =>
                        userInboxDetailController
                                .userSelectedImageDynamicLinkFromServer
                                .isNotEmpty
                            ? buildPhotoLibraryGridView()
                            : Container()),
                //LOADING OVERLAY
                Obx(() {
                  return userInboxDetailController.isLoading.value
                      ? Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),)
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
