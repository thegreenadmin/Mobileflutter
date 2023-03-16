import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';

import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/mutli_select_drop_down.dart';

import '../../../utils/sizedbox_constants.dart';
import '../controller/add_new_worker_controller.dart';
import '../model/get_user_store_list_model.dart';

class ManageWorkerEditScreen extends StatefulWidget {
  const ManageWorkerEditScreen({super.key});

  @override
  State<ManageWorkerEditScreen> createState() => _ManageWorkerEditScreenState();
}

class _ManageWorkerEditScreenState extends State<ManageWorkerEditScreen> {
  final AddNewWorkerController addNewWorkerController =
      Get.put(AddNewWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  addNewWorkerController.formKey.currentState?.reset();
                                  addNewWorkerController.resetForm();
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.updateWorkerText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/homeMall.png",
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: addNewWorkerController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            DottedBorder(
                              borderType: BorderType.Circle,
                              radius: const Radius.circular(20),
                              color: AppColors.blacklight,
                              strokeWidth: 1,
                              dashPattern: const [4, 4],
                              child:  Obx(()=> Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child:
                                    addNewWorkerController
                                                        .userImageDynamicLinkFromServer.value ==
                                                    "" ||
                                        addNewWorkerController
                                                    .userImageDynamicLinkFromServer.isEmpty
                                            ?
                                        const CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: AssetImage(
                                        "assets/userAccount.png",
                                      ),
                                      backgroundColor: AppColors.primarylight,
                                    )
                                    : CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                          addNewWorkerController
                                                  .userImageDynamicLinkFromServer.toString(),
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        // DottedBorder(
                        //   color: AppColors.blacklight,
                        //   strokeWidth: 1,
                        //   dashPattern: const [4, 4],
                        //   child: Container(
                        //     width: WidgetConstants.screenWidth * 0.3,
                        //     padding: const EdgeInsets.only(top: 35, bottom: 35),
                        //     color: AppColors.primarylight,
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Image.asset(
                        //             "assets/upload.png",
                        //             scale: 3,
                        //           ),
                        //         ]),
                        //   ),
                        // ),
                        width20SizedBox,
                      /*  Column(
                          children: [
                            height20SizedBox,
                            Text("Upload photo here",
                                style: TextStyle(
                                    color: AppColors.blacklight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            height10SizedBox,
                            Image.asset(
                              "assets/uploadbutton.png",
                              scale: 3,
                            ),
                          ],
                        )*/
                      ],
                    ),
                    height20SizedBox,
                    Text(
                      StringConstants.employeeNameText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        readOnly: true,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            addNewWorkerController.employeeNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStoreNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.enterNameText,
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 14),
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height20SizedBox,
                    Text(
                      StringConstants.emailIdText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false, readOnly: true,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: addNewWorkerController.emailTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterEmailText;
                          } else if (!GetUtils.isEmail(value.trim())) {
                            return AlertStringConstants
                                .pleaseEnterValidEmailText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.enterEmailIdText,
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 14),
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height20SizedBox,
                    Text(
                      StringConstants.primaryStoreText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    Obx(() => addNewWorkerController.getUserStoreList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<UserStoresList>(
                            isExpanded: true,
                            value:  addNewWorkerController.storeId.toString()!=null
                                && addNewWorkerController.storeId.toString()!="0"?
                            addNewWorkerController.getUserStoreList.firstWhere((element) =>
                            element.storeId == addNewWorkerController.storeId.toString()):null,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.grey,
                                  width: 1.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'Organisation Type',
                              errorStyle: const TextStyle(color: Colors.yellow),
                            ),
                            items: addNewWorkerController.getUserStoreList
                                .map<DropdownMenuItem<UserStoresList>>(
                                    (dynamic value) {
                              return DropdownMenuItem<UserStoresList>(
                                value: value,
                                child: Text(value.storeName.toString()),
                              );
                            }).toList(),
                            onChanged: (UserStoresList? newValue) {
                              setState(() {
                                addNewWorkerController.storeDropdownValue
                                    .value = newValue!.storeName.toString();
                                addNewWorkerController.storeId.value =
                                    newValue.storeId.toString();
                              });
                            },
                          )),
                    height20SizedBox,
                    Text(
                      StringConstants.shortDescriptionText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: addNewWorkerController
                            .shortDescriptionTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterEinText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.addDescriptionText,
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 14),
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height20SizedBox,
                    Text(
                      StringConstants.workingDaysText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    MultiCustomDropDown(
                        onChanged: (v) {
                          addNewWorkerController.selectedWeekDaysList.value = v;
                        },
                        validator: (v) {
                          if (v!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterWeekDaysText;
                          }
                          return null;
                        },
                        controller:
                        addNewWorkerController.workingDaysTextController,
                        hintText: StringConstants.selectDaysText,
                        title: StringConstants.selectDaysText,
                        list: addNewWorkerController.weekDaysList),
                    height20SizedBox,
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringConstants.startTimeText,
                                style: TextStyle(
                                    color: AppColors.blacklight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height4SizedBox,
                              TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  controller: addNewWorkerController
                                      .startTimeTextController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .startTimeAlertText;
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay date = TimeOfDay.now();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    date = (await showTimePicker(
                                      helpText: "Select Time",
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    primary: AppColors.primary),
                                            buttonTheme: const ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ))!;

                                    addNewWorkerController
                                        .startTimeTextController
                                        .text = date.format(context).toString();
                                  },
                                  decoration: InputDecoration(
                                    hintText: StringConstants.startTimeText,
                                    hintStyle: const TextStyle(
                                        color: AppColors.grey, fontSize: 14),
                                    fillColor: Colors.white,
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        width15SizedBox,
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringConstants.endTimeText,
                                style: TextStyle(
                                    color: AppColors.blacklight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height4SizedBox,
                              TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  controller: addNewWorkerController
                                      .endTimeTextController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .endTimeAlertText;
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    TimeOfDay date = TimeOfDay.now();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    date = (await showTimePicker(
                                      helpText: "Select Time",
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    primary: AppColors.primary),
                                            buttonTheme: const ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ))!;
                                    addNewWorkerController.endTimeTextController
                                        .text = date.format(context).toString();
                                  },
                                  decoration: InputDecoration(
                                    hintText: StringConstants.endTimeText,
                                    hintStyle: const TextStyle(
                                        color: AppColors.grey, fontSize: 14),
                                    fillColor: Colors.white,
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: AppColors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    height20SizedBox,
                    Text(
                      StringConstants.mobileNoText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false, readOnly: true,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            addNewWorkerController.mobileNoTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterMobileNoText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.enterMobileText,
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 14),
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height20SizedBox,
                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        addNewWorkerController.validateAndSubmit(isEdit:true);
                      },
                      height: 50,
                      text: StringConstants.saveText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconL: false,
                      fontSize: 16,
                    ),
                    height40SizedBox,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
