import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/utility.dart';

class AddNewStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressLine1TextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController townOrCityTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();

  RxBool autoValidate = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {});
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {} catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  //Create Store Api
  Future apiCreateStore() async {
    Map data = {"store_name": "Demo store 12"};
    debugPrint("CREATE STORE BODY********** $data");
    debugPrint(
        "CREATE STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().createStore}");
    UserProvider()
        .postApi(data,
            ServerCommunicator().baseUrl + ServerCommunicator().createStore,
            showLoading: true)
        .then((value) async {
      debugPrint("CREATE STORE RESPONSE *******${value!.body}");
      if (value.body["status"] == 201) {
        Utility.showMessage(StringConstants.successText, value.body['message']);
      } else if (value.body["status"] == 409) {
        //User not exist
        Utility.showMessage(StringConstants.alertText, value.body['message']);
      } else if (value.body["status"] == 400) {
        //Phone Number is not valid
        Utility.showMessage(StringConstants.alertText, value.body['message']);
      } else {
        Utility.showMessage(
            StringConstants.alertText, value.body['message'].toString());
      }
    });
  }
}
