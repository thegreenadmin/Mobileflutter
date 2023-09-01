import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/owner_inbox_detail_controller.dart';
import 'package:thegreenmall/dashboard/home/model/owner_message_list_model.dart';
import 'package:thegreenmall/dashboard/home/view/inbox/user_Inbox/image_preview_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class OwnerInboxDetailScreen extends StatefulWidget {
  const OwnerInboxDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  OwnerInboxDetailScreenState createState() => OwnerInboxDetailScreenState();
}

class OwnerInboxDetailScreenState extends State<OwnerInboxDetailScreen> {
  final OwnerInboxDetailController ownerInboxDetailController =
      Get.put(OwnerInboxDetailController());

  // Container buildCameraGridView() {
  //   return Container(
  //       height: 120,
  //       child: Stack(
  //         alignment: Alignment.topRight,
  //         children: [
  //           Container(
  //             margin: const EdgeInsets.all(10),
  //             width: 100,
  //             height: 110,
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               border: Border.all(color: AppColors.primary, width: 2),
  //               borderRadius: BorderRadius.circular(10),
  //               image: DecorationImage(
  //                 fit: BoxFit.cover,
  //                 image: FileImage(
  //                   File(personalChatDetailController.imageFile.value.path),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               setState(() {
  //                 personalChatDetailController.pickedFile = null;
  //               });
  //             },
  //             child: const CircleAvatar(
  //               backgroundColor: Colors.red,
  //               radius: 10,
  //               child: Icon(
  //                 Icons.horizontal_rule,
  //                 color: AppColors.white,
  //                 size: 10.0,
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }

  SizedBox buildPhotoLibraryGridView() {
    return SizedBox(
        height: 120,
        child:

            // ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     itemCount: personalChatDetailController.files.isEmpty
            //         ? 1
            //         : personalChatDetailController.files.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return
            Stack(
          alignment: Alignment.topRight,
          children: [
            // personalChatDetailController.files[index].path
            //                 .split('.')
            //                 .last
            //                 .toString() ==
            //             "jpg" ||
            //         personalChatDetailController.files[index].path
            //                 .split('.')
            //                 .last
            //                 .toString() ==
            //             "png" ||
            //         personalChatDetailController.files[index].path
            //                 .split('.')
            //                 .last
            //                 .toString() ==
            //             "jpeg"
            //     ?
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
                  image: NetworkImage(ownerInboxDetailController
                      .userSelectedImageDynamicLinkFromServer.value),
                ),
              ),
            ),
            // : Container(
            //     margin: const EdgeInsets.all(10),
            //     width: 100,
            //     height: 110,
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       border:
            //           Border.all(color: AppColors.primaryColor, width: 2),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Image.asset(
            //       "assets/file.png",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            InkWell(
              onTap: () {
                setState(() {
                  ownerInboxDetailController
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
        // })
        );
  }

  // sendMediaBottomSheet(context) {
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       isDismissible: true,
  //       barrierColor: AppColors.darkGreyColor.withOpacity(0.5),
  //       context: context,
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) => Container(
  //             color: Colors.transparent,
  //             height: 150,
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(30.0),
  //                     topRight: Radius.circular(30.0),
  //                   )),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.only(left: 10, right: 10),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             Get.back();
  //                             personalChatDetailController
  //                                 .loadFilesFromDevice(FileType.image);
  //                           },
  //                           child: const Text(
  //                             "Photo Library",
  //                             style: TextStyle(
  //                                 color: AppColors.blackColor,
  //                                 fontSize: 16,
  //                                 fontFamily: "Gilroy",
  //                                 fontWeight: FontWeight.w700),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           height: 20,
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Get.back();
  //                             personalChatDetailController
  //                                 .loadFilesFromDevice(FileType.any);
  //                           },
  //                           child: const Text(
  //                             "File",
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: AppColors.blackColor,
  //                                 fontFamily: "Gilroy",
  //                                 fontWeight: FontWeight.w700),
  //                           ),
  //                         ),
  //                         const Divider(
  //                           thickness: 2,
  //                           height: 20,
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Get.back();
  //                           },
  //                           child: const Text(
  //                             "CANCEL",
  //                             style: TextStyle(
  //                                 color: AppColors.primaryColor,
  //                                 fontSize: 16,
  //                                 fontFamily: "Gilroy",
  //                                 fontWeight: FontWeight.w800),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ));
  // }

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
                      color: AppColors.greylight,
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
                    controller:
                        ownerInboxDetailController.messageTextController,
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
                              ownerInboxDetailController
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
                      hintText: " Start typing here...",
                      hintStyle: TextStyle(
                          color: AppColors.blacklight,
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
                if (ownerInboxDetailController
                    .messageTextController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please write something",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                      fontSize: 14.0);
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await ownerInboxDetailController.apiSendMessage();
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

  // Future<String> getFilePath(String fileName) async {
  //   String dir = (await getExternalStorageDirectory()).path;
  //   String savePath = '$dir/$fileName';
  //   return savePath;
  // }

  _buildMessage(
    List<Message> messageList,
    int index,
  ) {
    if (messageList[index].senderType! ==
        StringConstants.userText.toLowerCase()) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 24, top: 0, bottom: 0),
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 12, right: 12),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                                radius: 25.0,
                                backgroundImage: AssetImage(
                                  ImageConstants.userAccount,
                                ))),
                        width10SizedBox,
                        Flexible(
                          child: Container(
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
                                border: Border.all(
                                    color: AppColors.white, width: 1),
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
                                        onTap: () async {
                                          // SharedPreferenceStorage.setData(
                                          //     "context", context);
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (_) => ImagePreviewScreen(
                                          //     image: messageList[index]
                                          //         .image!
                                          //         .dynamicUrl
                                          //         .toString(),
                                          //   ),
                                          // ));
                                          await Get.to(
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
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            child: CommonWidgets
                                                .cachedNetworkImage(
                                              messageList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                              height:
                                                  WidgetConstants.screenHeight *
                                                      0.25,
                                              placeholder: (context, url) =>
                                                  SizedBox(
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
                                messageList[index].image!.dynamicUrl == "" ||
                                        messageList[index].image!.dynamicUrl ==
                                            null
                                    ? height0SizedBox
                                    : height15SizedBox,
                                InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                          text: messageList[index].message ??
                                              ""));
                                      Utility.showTopMessage(
                                          StringConstants.messageText,
                                          StringConstants
                                              .copiedToClipBoardText);
                                    },
                                    child:
                                        Text(messageList[index].message ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w400,
                                            )))
                              ],
                            ),
                          ),
                        ),
                        width10SizedBox,
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                              Utility.parseDateTime(
                                DateTime.parse(
                                  messageList[index].createdAt.toString(),
                                ),
                                secFormat: '',
                              ).toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                              )),
                        )
                      ]))));
    } else {
      return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                          Utility.parseDateTime(
                            DateTime.parse(
                              messageList[index].createdAt.toString(),
                            ),
                            secFormat: '',
                          ).toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.blacklight,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primarylight,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.1),
                              )
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            )),
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(
                                text: messageList[index].message.toString()));
                            Utility.showTopMessage(StringConstants.messageText,
                                StringConstants.copiedToClipBoardText);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              messageList[index].image!.dynamicUrl == "" ||
                                      messageList[index].image!.dynamicUrl ==
                                          null
                                  ? height0SizedBox
                                  : InkWell(
                                      onTap: () async {
                                        await Get.to(
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
                                            fit: BoxFit.fill,
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
                                          /* child: Image.network(
                                              messageList[index]
                                                  .image!
                                                  .dynamicUrl
                                                  .toString(),
                                              height: 220,
                                              // width: 200,
                                              fit: BoxFit.fill,
                                            )*/
                                        ),
                                      ),
                                    ),
                              height10SizedBox,
                              Text(messageList[index].message.toString(),
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

                                  // Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Obx(() => Text(
                                    ownerInboxDetailController.storeName.value,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Column(
              children: [
                Obx(() => Expanded(
                      child: ownerInboxDetailController.messageList.isEmpty
                          ? SizedBox(
                              height: WidgetConstants.screenHeight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ownerInboxDetailController.isLoading.value
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
                              controller:
                                  ownerInboxDetailController.scrollController,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount:
                                  ownerInboxDetailController.messageList.isEmpty
                                      ? 1
                                      : ownerInboxDetailController
                                          .messageList.length,
                              itemBuilder: (context, index) {
                                return _buildMessage(
                                  ownerInboxDetailController.messageList,
                                  index,
                                );
                              }),
                    )),
                _buildMessageComposer(),
                GetBuilder<OwnerInboxDetailController>(
                    builder: (inboxdetailController) => inboxdetailController
                            .userSelectedImageDynamicLinkFromServer.isNotEmpty
                        ? buildPhotoLibraryGridView()
                        : Container()),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
