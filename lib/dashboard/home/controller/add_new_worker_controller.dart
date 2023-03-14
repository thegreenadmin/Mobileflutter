import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_user_store_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:dio/dio.dart' as mdio;
import 'package:http_parser/http_parser.dart';

import '../model/add_worker_request.dart';
import '../model/categories.dart';

class AddNewWorkerController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController employeeNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController shortDescriptionTextController =
      TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();
  TextEditingController mobileNoTextController = TextEditingController();
  TextEditingController startTimeTextController = TextEditingController();
  TextEditingController endTimeTextController = TextEditingController();
  TextEditingController workingDaysTextController = TextEditingController();
  RxList<dynamic> selectedWeekDaysList = [].obs;
  RxList<Categories> weekDaysList = [
    Categories(
        id: 1,
        name: "Monday"
    ),
    Categories(
        id: 2,
        name: "Tuesday"
    ),Categories(
        id: 3,
        name: "Wednesday"
    ),
    Categories(
        id: 4,
        name: "Thursday"
    ),
    Categories(
        id: 5,
        name: "Friday"
    ),
    Categories(
        id: 6,
        name: "Saturday"
    ),
    Categories(
        id: 7,
        name: "Sunday"
    ),
  ].obs;


  RxString userImageOrigionalLinkfromServer = "".obs;
  RxString userImageDynamicLinkfromServer = "".obs;

  RxBool autoValidate = false.obs;
  Rx<XFile> categoryImage = XFile("").obs;
  late GetUserStoreListModel getUserStoreListModel = GetUserStoreListModel();
  RxList<UserStoresList> getUserStoreList = <UserStoresList>[].obs;

  RxString storeDropdownValue = "My store".obs;
  RxString storeId = "0".obs;

  RxInt radioGroupValue = 0.obs;
  RxBool is247Time = false.obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"];
    apiGetUserStoreList();
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
      try {
        addWorker();
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  Future<dynamic> addWorker() async{
    debugPrint("storeId ***${storeId.value}*");
    debugPrint("ADD WORKER***${storeId.value}*******${ServerCommunicator().baseUrl}${ServerCommunicator().createStoreUser}");
    Map<String, String> headers = {
      'Authorization':
      "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    AddWorkerRequest addWorkerRequest = AddWorkerRequest();
    addWorkerRequest.storeId = int.parse(storeId.value??"0");
    addWorkerRequest.employeeName = employeeNameTextController.text.trim();
    addWorkerRequest.description = shortDescriptionTextController.text.trim();
    addWorkerRequest.phone = mobileNoTextController.text.trim();
    addWorkerRequest.email = emailTextController.text.trim();
    List<EmployeeTiming>? employeeTimings = [];
    for (var element in selectedWeekDaysList) {
      debugPrint("${element.id}${element.name}");
      EmployeeTiming employeeTiming = EmployeeTiming();
      employeeTiming.dayOfWeek = element.id;
      employeeTiming.is24HrsActive = is247Time.value;
      employeeTiming.startTime = Utility.formatDateTime(startTimeTextController.text,firstFormat: "hh:mm a",secFormat: "hh:mm:ss").toString();
      employeeTiming.endTime = Utility.formatDateTime(endTimeTextController.text,firstFormat: "hh:mm a",secFormat: "hh:mm:ss").toString();
      employeeTimings.add(employeeTiming);
    }
    addWorkerRequest.employeeTimings = employeeTimings;
    debugPrint("addWorkerRequest ***${addWorkerRequest.toJson()}*");

    UserProvider()
        .postWithHeadersApi(
        addWorkerRequest,
        ServerCommunicator().baseUrl + ServerCommunicator().createStoreUser,
        headers,
        showLoading: false)
        .then((value) async {
      debugPrint("ADD WORKER RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getUserStoreListModel = GetUserStoreListModel.fromJson(value.body);
        getUserStoreList.value = getUserStoreListModel.data!.stores!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "From where do you want to take the photo?",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_sharp,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Gallery",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(
                                imageQuality: 50,
                                source: ImageSource.gallery,
                                maxWidth: 900,
                                maxHeight: 900);
                        if (pickedFile != null) {
                          categoryImage.value = pickedFile;
                          await apiUploadImage();
                          update();
                        } else {
                          // api();
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: AppColors.primary,
                            size: 24.0,
                          ),
                          width10SizedBox,
                          const Text("Camera",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      onTap: () async {
                        Get.back();
                        XFile? pickedFile = await ImagePickerClass.picker
                            .pickImage(
                                imageQuality: 50,
                                source: ImageSource.camera,
                                maxWidth: 900,
                                maxHeight: 900);
                        if (pickedFile != null) {
                          categoryImage.value = pickedFile;
                          await apiUploadImage();
                          update();
                        } else {
                          // api();
                        }
                      },
                    )
                  ],
                ),
              ));
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
          mdio.MultipartFile.fromBytes(await categoryImage.value.readAsBytes(),
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
        userImageOrigionalLinkfromServer.value =
            responseData['data']['urls']['orignal_url'];
        userImageDynamicLinkfromServer.value =
            responseData['data']['urls']['dynamic_url'];

        return responseData;
      } else if (res.statusCode == 403) {
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

  //Get User Store List Api
  Future apiGetUserStoreList() async {
    debugPrint(
        "GET USER STORE LIST URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().userStore}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            ServerCommunicator().baseUrl + ServerCommunicator().userStore,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("GET USER STORE LIST RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        getUserStoreListModel = GetUserStoreListModel.fromJson(value.body);
        getUserStoreList.value = getUserStoreListModel.data!.stores!;
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value.body['message']);
      }
    });
  }
}
