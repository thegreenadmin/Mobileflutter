import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/utility.dart';

class ContactUsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController subjectTextController = TextEditingController();
  TextEditingController messageTextController = TextEditingController();

  RxBool autoValidate = false.obs;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(BuildContext contx) async {
    if (validateAndSave()) {
      try {
        apiContactUs(contx);
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Contact us Api
  Future apiContactUs(BuildContext ctx) async {
    Map data = {
      "name": nameTextController.text.trim(),
      "email": emailTextController.text.trim(),
      "subject": subjectTextController.text.trim(),
      "message": messageTextController.text.trim(),
    };
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
      "Content-Type": "application/json"
    };
    debugPrint("CREATE USER BODY********** $data");
    debugPrint(
        "CREATE USER URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().utilsQueryCreate}");
    UserProvider()
        .postWithHeadersApi(
            data,
            ServerCommunicator().baseUrl +
                ServerCommunicator().utilsQueryCreate,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE USER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        nameTextController.clear();
        emailTextController.clear();
        subjectTextController.clear();
        messageTextController.clear();
        // Get.back();
        Navigator.of(ctx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
      } else {
        if (value.body['message'] != null) {
          Utility.showAlertMessage(value.body['message']);
        }
      }
    });
  }
}
