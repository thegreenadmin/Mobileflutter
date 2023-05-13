import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/owner_message_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:dio/dio.dart' as mdio;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class OwnerInboxDetailController extends GetxController {
  RxBool isloading = false.obs;

  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString storeId = "".obs;
  RxString storeName = "".obs;
  RxString messageHeadId = "".obs;

  OwnerMessageListModel messageListModel = OwnerMessageListModel();
  RxList<Message> messageList = <Message>[].obs;

  Rx<XFile> userSelectedImage = XFile("").obs;
  RxString userSelectedImageOrigionalLinkfromServer = "".obs;
  RxString userSelectedImageDynamicLinkfromServer = "".obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    messageHeadId.value = Get.parameters["messageHeadId"] ?? "";
    apiGetMessagesList();
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick:
        ()async{
          Navigator.of(context).pop();
          // Get.back();
          XFile? pickedFile = await ImagePickerClass.picker
              .pickImage(
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
    }, onCameraClick: ()async{
      Navigator.of(context).pop();
      // Get.back();
      XFile? pickedFile = await ImagePickerClass.picker
          .pickImage(
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
    isloading.value = true;
    debugPrint(
        "MESSAGE LIST URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageList}?page=1&page_size=10&message_head_id=${messageHeadId.value}&store_id=${storeId.value}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageList}?page=1&page_size=10&message_head_id=${messageHeadId.value}&store_id=${storeId.value}",
            headers,
            showLoading: true)
        .then((value) async {
      isloading.value = false;
      debugPrint("MESSAGE LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        messageListModel = OwnerMessageListModel.fromJson(value.body);
        messageList.value = messageListModel.data?.messages ?? [];
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        
         await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  //Send message by owner api
  Future apiSendMessage() async {
    debugPrint(
        "MESSAGE SEND URL********** ${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageSend}");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    debugPrint("TOKEN ********** $headers");
    Map body = {
      "message_head_id": messageHeadId.value,
      "message": messageTextController.text.trim(),
      "image_url": userSelectedImageOrigionalLinkfromServer.value.isEmpty
          ? null
          : userSelectedImageOrigionalLinkfromServer.value,
      "store_id": storeId.value
    };
    debugPrint("MESSAGE SEND BODY ********** $body");
    UserProvider()
        .postWithHeadersApi(
            body,
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeMessageSend}",
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
        messageListModel = OwnerMessageListModel.fromJson(value.body);
        messageList.value = messageListModel.data?.messages ?? [];
        update();
        await apiGetMessagesList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
         await Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) =>  const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
