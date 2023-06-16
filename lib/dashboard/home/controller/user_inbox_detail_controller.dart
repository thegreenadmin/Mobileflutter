import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/user_message_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:dio/dio.dart' as mdio;
import 'dart:convert';
import 'package:http_parser/http_parser.dart' show MediaType;

class UserInboxDetailController extends GetxController {
  RxBool isloading = false.obs;

  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString messageHeadId = "".obs;
  RxInt pageId = 0.obs;

  UserMessageListModel messageListModel = UserMessageListModel();
  RxList<Messages> messageList = <Messages>[].obs;
  RxList<Messages> pastMessagesList = <Messages>[].obs;

  Rx<XFile> userSelectedImage = XFile("").obs;
  RxString userSelectedImageOrigionalLinkfromServer = "".obs;
  RxString userSelectedImageDynamicLinkfromServer = "".obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    messageHeadId.value = Get.parameters["messageHeadId"] ?? "";
    print("store name--->" + storeName.value);
    print("store storeId--->" + storeId.value);
    print("store messageHeadId--->" + messageHeadId.value);
    apiGetMessagesList();
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      // Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
                                  // Navigator.of(context).pop();
      // Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        userSelectedImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {
        // api();
      }
    }, onCameraClick: () async {
      // Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
                                  // Navigator.of(context).pop();
      // Get.back();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
          imageQuality: 50,
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900);
      if (pickedFile != null) {
        userSelectedImage.value = pickedFile;
        await apiUploadImage();
        update();
      } else {
        // api();
      }
    });
  }

  //Api upload image to server
  Future apiUploadImage() async {
    try {
      final dio = mdio.Dio();
      mdio.FormData formData = mdio.FormData.fromMap({});
      Map<String, String> headers = {
        'Authorization':
            "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
      };
      formData.files.add(MapEntry(
          "file",
          mdio.MultipartFile.fromBytes(
              await userSelectedImage.value.readAsBytes(),
              contentType: MediaType.parse("image/png"),
              filename: "file-name.png".toString())));
      final res = await dio.post(
          ServerCommunicator().baseUrl + ServerCommunicator().fileUpload,
          data: formData,
          options: mdio.Options(headers: headers));
      final responseData = res.data;
      debugPrint(
          "IMAGE UPLOAD URL LINK ******* ${ServerCommunicator().baseUrl}${ServerCommunicator().fileUpload}");
      debugPrint("IMAGE UPLOAD URL LINK *******$responseData");
      if (res.statusCode == 200 || res.statusCode == 201) {
        userSelectedImageOrigionalLinkfromServer.value =
            responseData['data']['urls']['orignal_url'];
        userSelectedImageDynamicLinkfromServer.value =
            responseData['data']['urls']['dynamic_url'];

        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode401) {
        Utility.showToast(responseData['message'].toString());
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      if (e is mdio.DioError) {
        if (e.type == mdio.DioErrorType.badResponse) {
          debugPrint("${e.response?.data ?? ""}");
          final responseData =
              json.decode(e.response?.data) as Map<String, dynamic>;
          return responseData;
        }
      }
      throw Exception('Failed to load data ! $e');
    }
  }

  //Get Messages List Api
  Future apiGetMessagesList() async {
    pageId.value =await SharedPreferenceStorage.getData("pageId");
    isloading.value = true;
    debugPrint(
        "MESSAGE LIST URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().messageList}?page=1&page_size=10&message_head_id=${messageHeadId.value}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().messageList}?page=1&page_size=10&message_head_id=${messageHeadId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isloading.value = false;
      debugPrint("MESSAGE LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        messageListModel = UserMessageListModel.fromJson(value.body);
        messageList.value = messageListModel.data?.messages ?? [];
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Send message by user api
  Future apiSendMessage() async {
    debugPrint(
        "MESSAGE SEND URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().messageSend}");
    var token = await SharedPreferenceStorage.getData('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${token.toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "message_head_id": messageHeadId.value,
      "message": messageTextController.text.trim(),
      "image_url": userSelectedImageOrigionalLinkfromServer.value.isEmpty
          ? null
          : userSelectedImageOrigionalLinkfromServer.value
    };
    debugPrint("MESSAGE SEND BODY ********** $body");
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().messageSend}",
            headers,
            showLoading: true)
        .then((value) async {
      isloading.value = false;
      debugPrint("MESSAGE SEND RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        messageTextController.clear();
        userSelectedImageOrigionalLinkfromServer.value = "";
        userSelectedImageDynamicLinkfromServer.value = "";
        userSelectedImage.value = XFile("");
        messageListModel = UserMessageListModel.fromJson(value.body);
        messageList.value = messageListModel.data?.messages ?? [];
        update();
        await apiGetMessagesList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        await await Get.offAll(const StartJourneyScreen());
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }
}
