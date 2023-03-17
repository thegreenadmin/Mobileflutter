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
import '../model/add_worker_request_model.dart' as add_worker;
import '../model/categories_model.dart';
import '../model/edit_worker_request_model.dart';
import '../model/get_worker_detail_model.dart' as worker_detail;
import '../model/get_worker_list_model.dart';

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
      name: "Monday",
      isSelected: false,
    ),
    Categories(id: 2, name: "Tuesday", isSelected: false),
    Categories(id: 3, name: "Wednesday", isSelected: false),
    Categories(id: 4, name: "Thursday", isSelected: false),
    Categories(id: 5, name: "Friday", isSelected: false),
    Categories(id: 6, name: "Saturday", isSelected: false),
    Categories(id: 7, name: "Sunday", isSelected: false),
  ].obs;

  RxBool isLoading = false.obs;
  RxBool autoValidate = false.obs;
  RxBool is247Time = false.obs;

  RxString userImageOriginalLinkFromServer = "".obs;
  RxString userImageDynamicLinkFromServer = "".obs;
  RxString workerDays = "".obs;
  RxString storeDropdownValue = "My store".obs;
  RxString storeId = "0".obs;
  RxString storeName = "".obs;
  RxString workerId = "0".obs;

  Rx<XFile> categoryImage = XFile("").obs;
  late GetUserStoreListModel getUserStoreListModel = GetUserStoreListModel();
  late WorkerListResponse workerListResponse = WorkerListResponse();
  worker_detail.WorkerDetailResponse? workerDetailResponse =
      worker_detail.WorkerDetailResponse();
  RxList<UserStoresList> getUserStoreList = <UserStoresList>[].obs;
  RxList<StoreUser> workerList = <StoreUser>[].obs;

  RxInt radioGroupValue = 0.obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.arguments["storeId"] ?? "";
    storeName.value = Get.arguments["storeName"] ?? "";
    apiGetUserStoreList();
    apiGetWorkerList();
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

  void validateAndSubmit({bool isEdit = false}) async {
    if (validateAndSave()) {
      try {
        if (isEdit) {
          apiEditWorker();
        } else {
          apiAddWorker();
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  // Add Worker Api
  Future<dynamic> apiAddWorker() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    add_worker.AddWorkerRequest addWorkerRequest =
        add_worker.AddWorkerRequest();
    addWorkerRequest.storeId = int.parse(storeId.value);
    addWorkerRequest.employeeName = employeeNameTextController.text.trim();
    addWorkerRequest.imageUrl = userImageOriginalLinkFromServer.value.trim();
    addWorkerRequest.description = shortDescriptionTextController.text.trim();
    addWorkerRequest.phone = mobileNoTextController.text.trim();
    addWorkerRequest.email = emailTextController.text.trim();
    List<add_worker.EmployeeTiming>? employeeTimings = [];
    for (var element in selectedWeekDaysList) {
      if (element.isSelected == true) {
        debugPrint("${element.id} ${element.isSelected} ${element.name} ");
        add_worker.EmployeeTiming employeeTiming = add_worker.EmployeeTiming();
        employeeTiming.dayOfWeek = element.id;
        employeeTiming.is24HrsActive = is247Time.value;
        employeeTiming.startTime = Utility.formatDateTime(
                startTimeTextController.text,
                firstFormat: "hh:mm a",
                secFormat: "hh:mm:ss")
            .toString();
        employeeTiming.endTime = Utility.formatDateTime(
                endTimeTextController.text,
                firstFormat: "hh:mm a",
                secFormat: "hh:mm:ss")
            .toString();
        employeeTimings.add(employeeTiming);
      }
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
      debugPrint("ADD WORKER RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        Utility.showToast(value?.body['message'] ?? "");
        resetForm();
        await apiGetWorkerList();
        Get.back();
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message'] ?? "");
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message'] ?? "");
      }
    });
  }

  // Edit Worker Api
  Future<dynamic> apiEditWorker() async {
    debugPrint("storeId ***${storeId.value}*");
    debugPrint(
        "EDIT WORKER***${storeId.value}*******${ServerCommunicator().baseUrl}${ServerCommunicator().editWorker}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    EditWorkerRequest editWorkerRequest = EditWorkerRequest();
    editWorkerRequest.storeId = int.parse(storeId.value);
    editWorkerRequest.storeUserId = int.parse(workerId.value);
    editWorkerRequest.description = shortDescriptionTextController.text.trim();
    List<EmployeeTiming>? employeeTimings = [];
    if (workerDetailResponse?.data?.storeUser?.storeUserTimings != null &&
        workerDetailResponse!.data!.storeUser!.storeUserTimings!.isNotEmpty) {
      for (worker_detail.StoreUserTiming data
          in workerDetailResponse?.data?.storeUser?.storeUserTimings ?? []) {
        for (var element in selectedWeekDaysList) {
          if (element.id == data.dayOfWeek) {
            EmployeeTiming employeeTiming = EmployeeTiming();
            employeeTiming.storeUserTimingId = data.storeUserTimingId;
            employeeTiming.dayOfWeek = element.id;
            employeeTiming.is24HrsActive = is247Time.value;
            if (element.isSelected == true) {
              employeeTiming.status = "active";
            } else {
              employeeTiming.status = "deleted";
            }
            employeeTiming.startTime = Utility.formatDateTime(
                    startTimeTextController.text,
                    firstFormat: "hh:mm a",
                    secFormat: "hh:mm:ss")
                .toString();
            employeeTiming.endTime = Utility.formatDateTime(
                    endTimeTextController.text,
                    firstFormat: "hh:mm a",
                    secFormat: "hh:mm:ss")
                .toString();
            employeeTimings.add(employeeTiming);
          }
        }
      }
      for (var element in selectedWeekDaysList) {
        if (element.isSelected == true) {
          EmployeeTiming employeeTiming = EmployeeTiming();
          employeeTiming.storeUserTimingId = null;
          employeeTiming.dayOfWeek = element.id;
          employeeTiming.is24HrsActive = is247Time.value;
          employeeTiming.status = "active";
          employeeTiming.startTime = Utility.formatDateTime(
                  startTimeTextController.text,
                  firstFormat: "hh:mm a",
                  secFormat: "hh:mm:ss")
              .toString();
          employeeTiming.endTime = Utility.formatDateTime(
                  endTimeTextController.text,
                  firstFormat: "hh:mm a",
                  secFormat: "hh:mm:ss")
              .toString();
          debugPrint("test isSelected dayOfWeek");
          print(element.id);
          // print(employeeTimings.firstWhere((data) => data.dayOfWeek == element.id).dayOfWeek!=element.id);
          if (!employeeTimings.any((data) => data.dayOfWeek == element.id)) {
            employeeTimings.add(employeeTiming);
          }
        }
      }
    } else {
      for (var element in selectedWeekDaysList) {
        if (element.isSelected == true) {
          EmployeeTiming employeeTiming = EmployeeTiming();
          employeeTiming.storeUserTimingId = null;
          employeeTiming.dayOfWeek = element.id;
          employeeTiming.is24HrsActive = is247Time.value;
          employeeTiming.status = "active";
          employeeTiming.startTime = Utility.formatDateTime(
                  startTimeTextController.text,
                  firstFormat: "hh:mm a",
                  secFormat: "hh:mm:ss")
              .toString();
          employeeTiming.endTime = Utility.formatDateTime(
                  endTimeTextController.text,
                  firstFormat: "hh:mm a",
                  secFormat: "hh:mm:ss")
              .toString();

          debugPrint("test else dayOfWeek");
          employeeTimings.add(employeeTiming);
        }
      }
    }
    editWorkerRequest.employeeTimings = employeeTimings;
    debugPrint("EDIT Request ***${editWorkerRequest.toJson()}*");

    UserProvider()
        .putWithHeadersApi(
            editWorkerRequest,
            ServerCommunicator().baseUrl + ServerCommunicator().editWorker,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("EDIT RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        resetForm();
        await apiGetWorkerList();
        Get.back();
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      }   else {
        Utility.showToast(value.body['message']);
      }
    });
  }

  // Edit Worker Api
  Future<dynamic> apiDeleteWorker() async {
    debugPrint("storeId ***${storeId.value}*");
    debugPrint(
        "deleteWithHeadersApi WORKER***${storeId.value}*******${ServerCommunicator().baseUrl}${ServerCommunicator().editWorker}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
     Map<String, dynamic> data = {
       "store_id": int.parse(storeId.value),
       "store_user_id":  int.parse(workerId.value),
    };

    UserProvider()
        .deleteWithHeadersApi(data,
            ServerCommunicator().baseUrl + ServerCommunicator().deleteWorker,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("deleteWorker RESPONSE *******${value!.body}");
      if (value.body["status"] == 201 || value.body["status"] == 200) {
        Utility.showToast(value.body['message']);
        await apiGetWorkerList();
      } else if (value.body["status"] == 403) {
        Utility.showToast(value.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      }else if (value.body["status"] == 409) {
        Utility.showToast(value.body['message']);
        await apiGetWorkerList();
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
        userImageOriginalLinkFromServer.value =
            responseData['data']['urls']['orignal_url'];
        userImageDynamicLinkFromServer.value =
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

  //Get Worker List Api
  Future apiGetWorkerList() async {
    workerList.clear();
    isLoading.value = true;
    debugPrint(
        "apiGetWorkerList **********${ServerCommunicator().baseUrl}${ServerCommunicator().userStore}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().workerList}?page=1&page_size=100&store_id=${int.parse(storeId.value)}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("apiGetWorkerList RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        workerListResponse = WorkerListResponse.fromJson(value?.body);
        workerList.value = workerListResponse.data?.storeUsers ?? [];
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  //Get Worker List Api
  Future apiGetWorkerDetail() async {
    isLoading.value = true;
    selectedWeekDaysList.clear();
    debugPrint(
        "GET  STORE USER DETAIL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeUserDetail}?store_user_id=${int.parse(workerId.value)}&store_id=${int.parse(storeId.value ?? "0")}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeUserDetail}?store_user_id=${int.parse(workerId.value ?? "0")}&store_id=${int.parse(storeId.value ?? "0")}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET  STORE USER DETAIL RESPONSE *******${value?.body}");
      if (value?.body["status"] == 201 || value?.body["status"] == 200) {
        workerDetailResponse =
            worker_detail.WorkerDetailResponse.fromJson(value?.body);
        employeeNameTextController.text =
            workerDetailResponse?.data?.storeUser?.user?.firstName ?? '';
        shortDescriptionTextController.text =
            workerDetailResponse?.data?.storeUser?.description ?? '';
        emailTextController.text =
            workerDetailResponse?.data?.storeUser?.user?.email ?? '';
        mobileNoTextController.text =
            workerDetailResponse?.data?.storeUser?.user?.phone ?? '';
        userImageDynamicLinkFromServer.value =
            workerDetailResponse?.data?.storeUser?.user?.image?.dynamicUrl ??
                "";
        userImageOriginalLinkFromServer.value =
            workerDetailResponse?.data?.storeUser?.user?.image?.orignalUrl ??
                "";
        List<worker_detail.StoreUserTiming>? storeUserTimings =
            workerDetailResponse?.data?.storeUser?.storeUserTimings ?? [];
        var concatenate = StringBuffer();
        if (workerDetailResponse?.data?.storeUser?.storeUserTimings != null &&
            workerDetailResponse!.data!.storeUser!.storeUserTimings!.isNotEmpty) {
          for (worker_detail.StoreUserTiming data in storeUserTimings) {
            for (Categories day in weekDaysList) {
              if (day.id == data.dayOfWeek) {
                day.isSelected = true;
                selectedWeekDaysList.add(day);
                concatenate.write(day.name);
                concatenate.write(', ');
                startTimeTextController.text = Utility.formatDateTime(
                    data.startTime ?? "",
                    firstFormat: "hh:mm:ss",
                    secFormat: "hh:mm a");
                endTimeTextController.text = Utility.formatDateTime(
                    data.endTime ?? "",
                    firstFormat: "hh:mm:ss",
                    secFormat: "hh:mm a");
              }
            }
          }
        }
        workingDaysTextController.text = concatenate.toString() ?? '';
      } else if (value?.body["status"] == 403) {
        Utility.showToast(value?.body['message']);
        SharedPreferenceStorage.clearData();
        await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showToast(value?.body['message']);
      }
    });
  }

  resetForm() {
    userImageDynamicLinkFromServer.value = "";
    userImageOriginalLinkFromServer.value = "";
    employeeNameTextController.clear();
    emailTextController.clear();
    shortDescriptionTextController.clear();
    mobileNoTextController.clear();
    workingDaysTextController.clear();
    startTimeTextController.clear();
    endTimeTextController.clear();
    selectedWeekDaysList.clear();
    for (Categories day in weekDaysList) {
      day.isSelected=false;
    }
  }
}
