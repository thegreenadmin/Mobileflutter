import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as m_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';

class OwnerInboxDetailController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString messageHeadId = "".obs;
  RxString? role = "".obs;
  RxString? firstName = "".obs;
  RxString? lastName = "".obs;
  RxInt pageId = 0.obs;
  OwnerMessageListModel messageListModel = OwnerMessageListModel();
  RxList<Message> messageList = <Message>[].obs;
  RxInt totalCount = 0.obs;
  RxInt page = 1.obs;
  Rx<XFile> userSelectedImage = XFile("").obs;
  RxString userSelectedImageOriginalLinkFromServer = "".obs;
  RxString userSelectedImageDynamicLinkFromServer = "".obs;

  @override
  void onInit() {
    super.onInit();

    getPage();
  }

  getPage() async {
    firstName?.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName?.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    messageHeadId.value = Get.parameters["messageHeadId"] ?? "";
    await apiGetMessagesList();
    if (roleApp.value == Role.customerRoleText) {
      setupScrollController();
    }
  }

  setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 10) {
        if (messageList.length < totalCount.value) {
          page.value++;
          apiGetMessagesList();
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
      final dio = m_dio.Dio();
      m_dio.FormData formData = m_dio.FormData.fromMap({});

      Map<String, String> headers = {
        StringConstants.authorizationText:
            "${StringConstants.bearerText} ${authToken.value}",
      };
      formData.files.add(MapEntry(
          "file",
          m_dio.MultipartFile.fromBytes(
              await userSelectedImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(
          ServerCommunicator().baseUrl + ServerCommunicator().fileUpload,
          data: formData,
          options: m_dio.Options(headers: headers));
      final responseData = res.data;
      debugPrint(
          "IMAGE UPLOAD URL LINK ******* ${ServerCommunicator().baseUrl}${ServerCommunicator().fileUpload}");
      debugPrint("IMAGE UPLOAD URL LINK *******$responseData");
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
      debugPrint(e.toString());
      if (e is m_dio.DioError) {
        if (e.type == m_dio.DioErrorType.badResponse) {
          debugPrint("${e.response?.data ?? ""}");
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
    isLoading.value = true;
    if (page.value == 1) {
      messageList.clear();
    }
    messageListModel = OwnerMessageListModel();
    debugPrint(
        "MESSAGE LIST URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageList}?page=${page.value.toString()}&page_size=10&message_head_id=${messageHeadId.value}&store_id=${storeId.value}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageList}?page=${page.value.toString()}&page_size=10&message_head_id=${messageHeadId.value}&store_id=${storeId.value}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      log("MESSAGE LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        messageListModel = OwnerMessageListModel.fromJson(value.body);
        List<Message>? messageNewList = [];
        messageNewList = messageListModel.data?.messages ?? [];
        if (messageNewList.isNotEmpty) {
          if (page.value == 1) {
            messageList.value = [];
          }
          messageList.addAll(messageNewList);
        }
        messageList.toSet().toList();
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();

        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }

  ///Send message by owner api
  Future apiSendMessage() async {
    isLoading.value = true;
    debugPrint(
        "MESSAGE SEND userSelectedImageDynamicLinkFromServer *******${userSelectedImageDynamicLinkFromServer.value}");
    var msgText = messageTextController.text;
    var selectedImageOriginalLink =
        userSelectedImageOriginalLinkFromServer.value;
    var selectedImageDynamicLink = userSelectedImageDynamicLinkFromServer.value;
    Message msg = Message();
    msg.message = msgText;
    msg.messageHeadId = messageList.first.messageHeadId;
    msg.senderType = StringConstants.storeText.toLowerCase();
    msg.isCurrentMessage = true;
    msg.isStoreRead = true;
    msg.isUserRead = false;
    msg.status = messageList.first.status;
    msg.createdAt = DateTime.now().toUtc().toString();
    msg.updatedAt = DateTime.now().toUtc().toString();
    Images? image = Images();
    image.dynamicUrl = selectedImageDynamicLink ?? "";
    image.orignalUrl = selectedImageOriginalLink ?? "";
    msg.image = image;
    msgText != "" || userSelectedImageDynamicLinkFromServer.value != ""
        ? messageList.insert(0, msg)
        : null;
    messageTextController.clear();
    userSelectedImageOriginalLinkFromServer.value = "";
    userSelectedImageDynamicLinkFromServer.value = "";
    debugPrint(
        "MESSAGE SEND URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageSend}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "message_head_id": messageHeadId.value,
      "message": msgText.trim() == null || msgText.trim().isEmpty
          ? ""
          : msgText.trim(),
      "image_url":
          selectedImageOriginalLink.isEmpty ? null : selectedImageOriginalLink,
      "store_id": storeId.value
    };
    debugPrint("MESSAGE SEND BODY ********** $body");
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageSend}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("MESSAGE SEND RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        userSelectedImage.value = XFile("");
        update();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Get.offAll(const StartJourneyScreen());
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
