import 'dart:convert';

import 'package:dio/dio.dart' as mdio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class UserInboxDetailController extends GetxController with GlobalVarMixin{
  RxBool isLoading = false.obs;
  SharedPreferenceStorage storage = SharedPreferenceStorage();
  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString messageHeadId = "".obs;
  RxInt pageId = 0.obs;
  RxInt page = 1.obs;
  late UserMessageListModel messageListModel = UserMessageListModel();
  RxList<Messages> messageList = <Messages>[].obs;
  RxList<Messages> pastMessagesList = <Messages>[].obs;
  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;
  Rx<XFile> userSelectedImage = XFile("").obs;
  RxString userSelectedImageOriginalLinkFromServer = "".obs;
  RxString userSelectedImageDynamicLinkFromServer = "".obs;
  RxInt totalCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // storeId.value = Get.parameters["storeId"] ?? "";
    // storeName.value = Get.parameters["storeName"] ?? "";
    // messageHeadId.value = Get.parameters["messageHeadId"] ?? "";
    page.value = 1;
    role?.value =  await SharedPreferenceStorage.getData(Role.role) ??
        "";
    await apiGetMessagesList();
    role?.value = roleApp.value;
    if (roleApp.value == Role.customerRoleText) {
      setupScrollController();
    }
  }

  setupScrollController() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (messageList.length < totalCount.value) {
          page.value++;
          await   apiGetMessagesList();
        }
      }
    });
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        userSelectedImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {}
    }, onCameraClick: () async {
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        userSelectedImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {}
    });
  }

  ///Api upload image to server
  Future apiUploadImage() async {
    try {
      final dio = mdio.Dio();
      mdio.FormData formData = mdio.FormData.fromMap({});

      Map<String, String> headers = {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
      };
      formData.files.add(MapEntry(
          "file",
          mdio.MultipartFile.fromBytes(
              await userSelectedImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(
          ServerCommunicator.baseUrl + ServerCommunicator.fileUpload,
          data: formData,
          options: mdio.Options(headers: headers));
      final responseData = res.data;
                    if (res.statusCode == 200 || res.statusCode == 201) {
        userSelectedImageOriginalLinkFromServer.value =
            responseData['data']['urls']['orignal_url'];
        userSelectedImageDynamicLinkFromServer.value =
            responseData['data']['urls']['dynamic_url'];

        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode401) {
        Utility.showToast(responseData['message'].toString());
      } else {}
    } catch (e) {
             if (e is mdio.DioException) {
        if (e.type == mdio.DioExceptionType.badResponse) {
                     final responseData =
              json.decode(e.response?.data) as Map<String, dynamic>;
          return responseData;
        }
      }
      throw Exception('Failed to load data ! $e');
    }
  }

  ///Get Messages List Api
  Future apiGetMessagesList() async {
    if (page.value == 1) {
      messageList.clear();
    }
    messageListModel = UserMessageListModel();
    isLoading.value = true;
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.messageList}?page=${page.value.toString()}&page_size=10&message_head_id=${messageHeadId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        messageListModel = UserMessageListModel.fromJson(value?.body);
        totalCount.value = messageListModel.data?.totalCount ?? 0;
        List<Messages>? messageNewList = [];
        messageNewList = messageListModel.data?.messages ?? [];
        if (messageNewList.isNotEmpty) {
          if (page.value == 1) {
            messageList.value = [];
          }
          messageList.addAll(messageNewList);
        }
        messageList.toSet().toList();
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  ///Send message by user api
  Future apiSendMessage() async {
    isLoading.value = true;
    var msgText = messageTextController.text;
    var selectedImageOriginalLink =
        userSelectedImageOriginalLinkFromServer.value;
    var selectedImageDynamicLink = userSelectedImageDynamicLinkFromServer.value;
    Messages msg = Messages();
    msg.message = msgText;
    msg.messageHeadId = messageList.isEmpty
        ? messageHeadId.value
        : messageList.first.messageHeadId;
    msg.senderType = StringConstants.userText.toLowerCase();
    msg.isCurrentMessage = true;
    msg.isStoreRead = false;
    msg.isUserRead = true;
    msg.status = messageList.isEmpty ? "" : messageList.first.status;
    msg.createdAt = DateTime.now().toUtc().toString();
    msg.updatedAt = DateTime.now().toUtc().toString();
    Images? image = Images();
    image.dynamicUrl = selectedImageDynamicLink;
    image.orignalUrl = selectedImageOriginalLink;
    msg.image = image;
    msgText != "" || userSelectedImageDynamicLinkFromServer.value != ""
        ? messageList.insert(0, msg)
        : null;
    messageTextController.clear();
    userSelectedImageOriginalLinkFromServer.value = "";
    userSelectedImageDynamicLinkFromServer.value = "";
     
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
         Map body = {
      "message_head_id": messageHeadId.value,
      "message": msgText.trim().isEmpty ? "" : msgText.trim(),
      "image_url":
          selectedImageOriginalLink.isEmpty ? null : selectedImageOriginalLink
    };
         UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator.baseUrl}${ServerCommunicator.messageSend}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
             if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        userSelectedImage.value = XFile("");
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
