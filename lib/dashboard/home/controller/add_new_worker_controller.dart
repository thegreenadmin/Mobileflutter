import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thegreenmall/dashboard/home/model/get_user_store_list_model.dart';
import 'package:thegreenmall/dashboard/home/model/role_list_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/api_constants.dart';
import 'package:thegreenmall/utils/image_picker.dart';
import 'package:thegreenmall/utils/server_communicator.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
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
  RxString roleId = "".obs;
  RxString storeUserRoleId = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString storeOpeningTime = "".obs;
  RxString storeClosingTime = "".obs;

  Rx<XFile> categoryImage = XFile("").obs;
  late StoreRoleListResponse storeRoleListResponse = StoreRoleListResponse();
  late GetUserStoreListModel getUserStoreListModel = GetUserStoreListModel();
  late WorkerListResponse workerListResponse = WorkerListResponse();
  worker_detail.WorkerDetailResponse? workerDetailResponse =
      worker_detail.WorkerDetailResponse();
  RxList<UserStoresList> getUserStoreList = <UserStoresList>[].obs;
  RxList<StoreUser> workerList = <StoreUser>[].obs;
  RxList<StoreRole> storeRoleList = <StoreRole>[].obs;
  RxInt radioGroupValue = 0.obs;
  RxList<dynamic> storeTimings = <dynamic>[].obs;
  RxList<dynamic> storeDeliveryServices = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    storeId.value = Get.parameters["storeId"] ?? "";
    storeName.value = Get.parameters["storeName"] ?? "";
    apiGetUserStoreList();
    apiGetWorkerList();
    apiGetRoleList();
    apiGetParticularStore();
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

  void validateAndSubmit(BuildContext ctx, {bool isEdit = false}) async {
    if (validateAndSave()) {
      try {
        if (isEdit) {
          apiEditWorker(ctx);
        } else {
          apiAddWorker(ctx);
        }
      } catch (_) {}
    } else {
      autoValidate.value = true;
    }
  }

  // Add Worker Api
  Future<dynamic> apiAddWorker(BuildContext contextt) async {
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
    addWorkerRequest.phone = phoneNumber.value.trim();
    addWorkerRequest.phoneCode = countryCode.value.trim();
    addWorkerRequest.email = emailTextController.text.trim();
    if (storeRoleList.isEmpty) {
      addWorkerRequest.roleId = null;
    } else {
      addWorkerRequest.roleId = int.parse(roleId.value.toString());
    }

    List<add_worker.EmployeeTiming>? employeeTimings = [];
    for (var element in selectedWeekDaysList) {
      if (element.isSelected == true) {
        debugPrint("${element.id} ${element.isSelected} ${element.name} ");
        add_worker.EmployeeTiming employeeTiming = add_worker.EmployeeTiming();
        employeeTiming.dayOfWeek = element.id;
        employeeTiming.is24HrsActive = is247Time.value;
        employeeTiming.startTime = Utility.formatDateTime(
                startTimeTextController.text,
                firstFormat: "hh:mm",
                secFormat: "hh:mm:ss")
            .toString();
        employeeTiming.endTime = Utility.formatDateTime(
                endTimeTextController.text,
                firstFormat: "hh:mm",
                secFormat: "hh:mm:ss")
            .toString();
        employeeTimings.add(employeeTiming);
      }
    }
    addWorkerRequest.employeeTimings = employeeTimings;
    debugPrint(
        "ADD WORKER URL ***********${ServerCommunicator().baseUrl + ServerCommunicator().createStoreUser}");
    debugPrint("ADD WORKER URL ***********$headers");
    debugPrint("ADD WORKER BODY ***********${addWorkerRequest.toJson()}");

    UserProvider()
        .postWithHeadersApi(
            addWorkerRequest,
            ServerCommunicator().baseUrl + ServerCommunicator().createStoreUser,
            headers,
            showLoading: true)
        .then((value) async {
      debugPrint("ADD WORKER RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value?.body['message'] ?? "");
        resetForm();
        await apiGetWorkerList();
        // Get.back();
        Navigator.of(contextt).pop();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message'] ?? "");
        SharedPreferenceStorage.clearData();
        Navigator.of(contextt).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
        Utility.showAlertMessage(value?.body['message'] ?? "");
      }
    });
  }

  // Edit Worker Api
  Future<dynamic> apiEditWorker(BuildContext contx) async {
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
    editWorkerRequest.roleId =
        roleId.value != "" ? int.parse(roleId.value) : null;

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
          debugPrint(element.id);
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
    debugPrint("EDIT WORKER BOSY ***${editWorkerRequest.toJson()}");

    UserProvider()
        .putWithHeadersApi(
            editWorkerRequest,
            ServerCommunicator().baseUrl + ServerCommunicator().editWorker,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("EDIT WORKER RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode201 ||
          value.body["status"] == ApiConstants.statusCode200) {
        Utility.showToast(value.body['message']);
        resetForm();
        await apiGetWorkerList();
        // Get.back();
        Navigator.of(contx).pop();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(contx).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  // Delete Worker Api
  Future<dynamic> apiDeleteWorker() async {
    debugPrint("storeId ***${storeId.value}*");
    debugPrint("deleteWithHeadersApi WORKER***${storeId.value}**${workerId.value}*******${ServerCommunicator().baseUrl}${ServerCommunicator().deleteWorker}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    Map<String, dynamic> data = {
      "store_id": int.parse(storeId.value),
      "store_user_id": int.parse(workerId.value),
    };

    UserProvider()
        .deleteWithHeadersApi(
            data,
            ServerCommunicator().baseUrl + ServerCommunicator().deleteWorker,
            headers,
            showLoading: false)
        .then((value) async {
      debugPrint("deleteWorker RESPONSE *******${value!.body}");
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        Utility.showToast(value.body['message']);
        await apiGetWorkerList();
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else if (value.body["status"] == ApiConstants.statusCode409) {
        Utility.showAlertMessage(value.body['message']);
        await apiGetWorkerList();
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  Future<void> showSelectionDialog(BuildContext context) {
    return Utility.showSelectionMediaDialog(context, onGalleryClick: () async {
      // Get.back();
      // Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
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
    }, onCameraClick: () async {
      // Get.back();
      //Navigator.of(context).pop();
      XFile? pickedFile = await ImagePickerClass.picker.pickImage(
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
      if (res.statusCode == ApiConstants.statusCode200 ||
          res.statusCode == ApiConstants.statusCode201) {
        userImageOriginalLinkFromServer.value =
            responseData['data']['urls']['orignal_url'];
        userImageDynamicLinkFromServer.value =
            responseData['data']['urls']['dynamic_url'];

        return responseData;
      } else if (res.statusCode == ApiConstants.statusCode401) {
        Utility.showAlertMessage(responseData['message'].toString());
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

  //Get particular store api
  Future apiGetParticularStore() async {
    debugPrint(
        "GET PARTICULAR STORE URL**********${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetails}?store_id=$storeId");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeDetails}?store_id=$storeId",
            headers,
            showLoading: false)
        .then((value) async {
      log("GET PARTICULAR STORE RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        storeTimings.value =
            value?.body["data"]['store']['store_timings'] ?? [];
        storeDeliveryServices.value =
            value?.body["data"]['store']['store_delivery_services'] ?? [];

        if (storeTimings.isNotEmpty) {
          for (int i = 0; i < storeTimings.length; i++) {
            is247Time.value = storeTimings[i]["is_24_hours_active"] ?? false;
            if (is247Time.value == true) {
              radioGroupValue.value = 1;
            } else {
              radioGroupValue.value = 0;
              storeOpeningTime.value = Utility.formatDateTime(
                      storeTimings[i]["opening_time"] ?? '',
                      firstFormat: "hh:mm:ss",
                      secFormat: "hh:mm a")
                  .toString();

              Utility.formatDateTime(storeTimings[i]["opening_time"] ?? '',
                      firstFormat: "hh:mm:ss", secFormat: "hh:mm a")
                  .toString();

              storeClosingTime.value = Utility.formatDateTime(
                      storeTimings[i]["closing_time"] ?? '',
                      firstFormat: "hh:mm:ss",
                      secFormat: "hh:mm a")
                  .toString();

              Utility.formatDateTime(storeTimings[i]["closing_time"] ?? '',
                      firstFormat: "hh:mm:ss", secFormat: "hh:mm a")
                  .toString();
            }
          }
        } else {
          is247Time.value = true;
        }
        if (is247Time.value == false) {
          List<Categories> data = [];
          for (int i = 0; i < storeTimings.length; i++) {
            for (var element in weekDaysList) {
              if (element.id == storeTimings[i]['day_of_week']) {
                data.add(element);
              }
            }
          }
          weekDaysList.value = data;
        }
        update();
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
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
      if (value.body["status"] == ApiConstants.statusCode200 ||
          value.body["status"] == ApiConstants.statusCode201) {
        getUserStoreListModel = GetUserStoreListModel.fromJson(value.body);
        getUserStoreList.value = getUserStoreListModel.data!.stores!;
      } else if (value.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if (value.body['message']!=null) {
        Utility.showAlertMessage(value.body['message']);
      }
    }
    });
  }

  //Get Worker List Api
  Future apiGetWorkerList() async {
    workerList.clear();
    isLoading.value = true;
    debugPrint(
        "WORKER LIST URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().workerList}?store_id=${int.parse(storeId.value)}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().workerList}?store_id=${int.parse(storeId.value)}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("WORKER LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        workerListResponse = WorkerListResponse.fromJson(value?.body);
        workerList.value = workerListResponse.data?.storeUsers ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Role List Api
  Future apiGetRoleList() async {
    workerList.clear();
    isLoading.value = true;
    debugPrint(
        "API ROLE LIST URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().roleList}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().roleList}?store_id=${int.parse(storeId.value)}",
            headers,
            showLoading: true)
        .then((value) async {
      isLoading.value = false;
      debugPrint("API GET ROLE LIST RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
        storeRoleListResponse = StoreRoleListResponse.fromJson(value?.body);
        storeRoleList.value = storeRoleListResponse.data?.storeRoles ?? [];
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }

  //Get Worker Detail Api
  Future apiGetWorkerDetail() async {
    isLoading.value = true;
    selectedWeekDaysList.clear();
    debugPrint(
        "GET STORE USER DETAIL URL **********${ServerCommunicator().baseUrl}${ServerCommunicator().storeUserDetail}?store_user_id=${int.parse(workerId.value)}&store_id=${int.parse(storeId.value)}");
    Map<String, String> headers = {
      'Authorization':
          "Bearer ${SharedPreferenceStorage.getData("token").toString()}",
    };
    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator().baseUrl}${ServerCommunicator().storeUserDetail}?store_user_id=${int.parse(workerId.value)}&store_id=${int.parse(storeId.value)}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      debugPrint("GET  STORE USER DETAIL RESPONSE *******${value?.body}");
      if (value?.body["status"] == ApiConstants.statusCode201 ||
          value?.body["status"] == ApiConstants.statusCode200) {
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
        phoneNumber.value = mobileNoTextController.text.trim();
        countryCode.value =
            workerDetailResponse!.data!.storeUser!.user!.phoneCode!.trim();

        userImageDynamicLinkFromServer.value =
            workerDetailResponse?.data?.storeUser?.user?.image?.dynamicUrl ??
                "";
        userImageOriginalLinkFromServer.value =
            workerDetailResponse?.data?.storeUser?.user?.image?.orignalUrl ??
                "";

        roleId.value =
            workerDetailResponse?.data?.storeUser?.role?.roleId ?? "";

        List<worker_detail.StoreUserTiming>? storeUserTimings =
            workerDetailResponse?.data?.storeUser?.storeUserTimings ?? [];
        var concatenate = StringBuffer();
        if (workerDetailResponse?.data?.storeUser?.storeUserTimings != null &&
            workerDetailResponse!
                .data!.storeUser!.storeUserTimings!.isNotEmpty) {
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
        workingDaysTextController.text = concatenate.toString();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
          Utility.showAlertMessage(value?.body['message']);
        SharedPreferenceStorage.clearData();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const StartJourneyScreen(),
        ));
        // await Get.offAll(const StartJourneyScreen());
      } else {
       if(value?.body['message']!=null){
          Utility.showAlertMessage(value?.body['message']);
        }
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
    countryCode.value = "";
    roleId.value = "";
    for (Categories day in weekDaysList) {
      day.isSelected = false;
    }
  }
}
