import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

class ContactUsController extends GetxController with GlobalVarMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController subjectTextController = TextEditingController();
  TextEditingController messageTextController = TextEditingController();

  RxBool autoValidate = false.obs;
  RxInt pageId = 0.obs;
  RxString? role = "".obs;
  // RxString? firstName = "".obs;
  // RxString? lastName = "".obs;

  @override
  void onInit() {
    super.onInit();
    getPage();
  }

  getPage() async {
    firstName.value =
        await SharedPreferenceStorage.getData(StringConstants.firstNameText) ??
            "";
    lastName.value =
        await SharedPreferenceStorage.getData(StringConstants.lastNameText) ??
            "";

    var roleVal = await SharedPreferenceStorage.getData(Role.role);
    role?.value = roleVal;
  }

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

  ///Contact us Api
  Future apiContactUs(BuildContext ctx) async {
    Map data = {
      "name": nameTextController.text.trim(),
      "email": emailTextController.text.trim(),
      "subject": subjectTextController.text.trim(),
      "message": messageTextController.text.trim(),
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
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
      debugPrint("CREATE USER RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value?.body['message']);
        nameTextController.clear();
        emailTextController.clear();
        subjectTextController.clear();
        messageTextController.clear();
        Get.back(id: pageIdApp.value);
      } else if (value?.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value?.body['message']);
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
