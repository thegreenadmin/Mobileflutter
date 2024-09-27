import 'package:dotted_border/dotted_border.dart' show BorderType, DottedBorder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_worker_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditWorkerScreen extends StatefulWidget {
  const EditWorkerScreen({super.key});

  @override
  State<EditWorkerScreen> createState() => _EditWorkerScreenState();
}

class _EditWorkerScreenState extends State<EditWorkerScreen> with GlobalVarMixin{
  final AddNewWorkerController addNewWorkerController =
      Get.put(AddNewWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  GestureDetector buildBody(BuildContext context) {
    return GestureDetector(
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
                            color: AppColors.blackLight,
                            strokeWidth: 1,
                            dashPattern: const [4, 4],
                            child: Obx(
                              () => Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CommonWidgets.circleCachedNetworkImage(
                                  addNewWorkerController
                                      .userImageDynamicLinkFromServer.value
                                      .toString(),
                                  fit: BoxFit.contain,
                                  radius: 50.0,
                                  assetBackgroundColor:
                                      AppColors.primaryLight,
                                  assetImg: ImageConstants.userAccount,
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                          radius: 25.0,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
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
                  buildText(StringConstants.employeeNameText, StringConstants.starText,),
                  height4SizedBox,
                  //EMPLOYEE NAME FIELD
                  CustomInputField(
                    disabledBorderColor: AppColors.grey,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    fillColor: AppColors.transparent,
                    controller:
                        addNewWorkerController.employeeNameTextController,
                    hintText: StringConstants.enterNameText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants
                            .pleaseEnterEmployeeNameText;
                      }
                      return null;
                    },
                  ),
                  // TextFormField(
                  //     textInputAction: TextInputAction.newline,
                  //     keyboardType: TextInputType.multiline,
                  //     autofocus: false,
                  //     maxLines: null,
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     readOnly: true,
                  //     inputFormatters: <TextInputFormatter>[
                  //       LengthLimitingTextInputFormatter(100),
                  //     ],
                  //     style: const TextStyle(
                  //         color: AppColors.black,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500),
                  //     controller:
                  //         addNewWorkerController.employeeNameTextController,
                  //     validator: (value) {
                  //       if (value!.trim().isEmpty) {
                  //         return AlertStringConstants
                  //             .pleaseEnterStoreNameText;
                  //       }
                  //       return null;
                  //     },
                  //     textCapitalization: TextCapitalization.words,
                  //     decoration: InputDecoration(
                  //       hintText: StringConstants.enterNameText,
                  //       hintStyle: const TextStyle(
                  //           color: AppColors.grey, fontSize: 14),
                  //       fillColor: Colors.white,
                  //       border: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       errorBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       focusedBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.grey,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //     )),
                  height20SizedBox,buildText(StringConstants.emailIdText, StringConstants.starText,),


                  height4SizedBox,
//WORKER EMAIL FIELD

                  CustomInputField(
                    disabledBorderColor: AppColors.grey,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    fillColor: AppColors.transparent,
                    controller: addNewWorkerController.emailTextController,
                    hintText: StringConstants.enterEmailIdText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterEmailText;
                      } else if (!GetUtils.isEmail(value.trim())) {
                        return AlertStringConstants.pleaseEnterValidEmailText;
                      }
                      return null;
                    },
                  ),

                  height20SizedBox,buildText(StringConstants.primaryStoreText, StringConstants.starText,),


                  height4SizedBox,
                  Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: Text(
                        addNewWorkerController.storeName.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryLight,
                        ),
                      )),
                  height20SizedBox,
                  buildText(StringConstants.shortDescriptionText, "",),

                  height4SizedBox,
                  CustomInputField(
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(200),
                    ],
                    keyboardType: TextInputType.multiline,
                    autofocus: false,
                    fillColor: AppColors.transparent,
                    controller:
                        addNewWorkerController.shortDescriptionTextController,
                    hintText: StringConstants.addDescriptionText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      return null;
                    },
                  ),
                  // TextFormField(
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     textInputAction: TextInputAction.next,
                  //     autofocus: false,
                  //     inputFormatters: <TextInputFormatter>[
                  //       LengthLimitingTextInputFormatter(100),
                  //     ],
                  //     style: const TextStyle(
                  //         color: AppColors.black,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500),
                  //     controller: addNewWorkerController
                  //         .shortDescriptionTextController,
                  //     keyboardType: TextInputType.text,
                  //     // validator: (value) {
                  //     //   if (value!.trim().isEmpty) {
                  //     //     return AlertStringConstants
                  //     //         .pleaseEnterShortDescriptionText;
                  //     //   }
                  //     //   return null;
                  //     // },
                  //     textCapitalization: TextCapitalization.sentences,
                  //     decoration: InputDecoration(
                  //       hintText: StringConstants.addDescriptionText,
                  //       hintStyle: const TextStyle(
                  //           color: AppColors.grey, fontSize: 14),
                  //       fillColor: Colors.white,
                  //       border: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       errorBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       focusedBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.primary,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: const BorderSide(
                  //           color: AppColors.grey,
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //     )),
                  height20SizedBox,buildText(StringConstants.workingDaysText, StringConstants.starText,),


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
                          children: [ buildText(StringConstants.startTimeText, StringConstants.starText,),


                            height4SizedBox,
                            //START TIME FIELD
                            CustomInputField(
                              textInputAction: TextInputAction.next,
                              isBorderOutline: false,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(25),
                              ],
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              fillColor: AppColors.transparent,
                              controller: addNewWorkerController
                                  .startTimeTextController,
                              hintText: StringConstants.startTimeText,
                              hintStyle: const TextStyle(
                                  color: AppColors.grey, fontSize: 14),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseSelectOpeningTimeText;
                                } else if (value.trim() ==
                                    addNewWorkerController
                                        .endTimeTextController.text) {
                                  return AlertStringConstants
                                      .startTimeAlertText;
                                }
                                return null;
                              },
                              onTap: () async {
                                TimeOfDay? date = TimeOfDay.now();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                date = (await showTimePicker(
                                  initialEntryMode: TimePickerEntryMode.input,
                                  helpText: StringConstants.selectTimeText,
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                            primary: AppColors.primary),
                                        buttonTheme: const ButtonThemeData(
                                            textTheme:
                                                ButtonTextTheme.primary),
                                      ),
                                      child: child!,
                                    );
                                  },
                                ));

                                addNewWorkerController
                                        .startTimeTextController.text =
                                    date?.format(context).toString() ?? "";
                              },
                            ),

                          ],
                        ),
                      ),
                      width15SizedBox,
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ buildText(StringConstants.endTimeText, StringConstants.starText,),

                            height4SizedBox,
                            CustomInputField(
                              textInputAction: TextInputAction.next,
                              isBorderOutline: false,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(25),
                              ],
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              fillColor: AppColors.transparent,
                              controller: addNewWorkerController
                                  .endTimeTextController,
                              hintText: StringConstants.startTimeText,
                              hintStyle: const TextStyle(
                                  color: AppColors.grey, fontSize: 14),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseSelectClosingTimeText;
                                } else if (value.trim() ==
                                    addNewWorkerController
                                        .startTimeTextController.text) {
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
                                  initialEntryMode: TimePickerEntryMode.input,
                                  helpText: StringConstants.selectTimeText,
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
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
                            ),
                            // TextFormField(
                            //     autovalidateMode:
                            //         AutovalidateMode.onUserInteraction,
                            //     textInputAction: TextInputAction.next,
                            //     autofocus: false,
                            //     inputFormatters: <TextInputFormatter>[
                            //       LengthLimitingTextInputFormatter(100),
                            //       FilteringTextInputFormatter.digitsOnly,
                            //     ],
                            //     style: const TextStyle(
                            //         color: AppColors.black,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w500),
                            //     controller: addNewWorkerController
                            //         .endTimeTextController,
                            //     keyboardType: TextInputType.phone,
                            //     validator: (value) {
                            //       if (value!.trim().isEmpty) {
                            //         return AlertStringConstants
                            //             .endTimeAlertText;
                            //       }
                            //       return null;
                            //     },
                            //     onTap: () async {
                            //       TimeOfDay? date = TimeOfDay.now();
                            //       FocusScope.of(context)
                            //           .requestFocus(FocusNode());
                            //       date = (await showTimePicker(
                            //         initialEntryMode:
                            //             TimePickerEntryMode.input,
                            //         helpText: StringConstants.selectTimeText,
                            //         initialTime: TimeOfDay.now(),
                            //         context: context,
                            //         builder: (context, child) {
                            //           return Theme(
                            //             data: ThemeData.light().copyWith(
                            //               colorScheme:
                            //                   const ColorScheme.light(
                            //                       primary: AppColors.primary),
                            //               buttonTheme: const ButtonThemeData(
                            //                   textTheme:
                            //                       ButtonTextTheme.primary),
                            //             ),
                            //             child: child!,
                            //           );
                            //         },
                            //       ));
                            //       addNewWorkerController
                            //               .endTimeTextController.text =
                            //           date?.format(context).toString() ?? "";
                            //     },
                            //     decoration: InputDecoration(
                            //       errorMaxLines: 3,
                            //       hintText: StringConstants.endTimeText,
                            //       hintStyle: const TextStyle(
                            //           color: AppColors.grey, fontSize: 14),
                            //       fillColor: Colors.white,
                            //       border: UnderlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       errorBorder: UnderlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       focusedBorder: UnderlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.primary,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       enabledBorder: UnderlineInputBorder(
                            //         borderRadius: BorderRadius.circular(5.0),
                            //         borderSide: const BorderSide(
                            //           color: AppColors.grey,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //     )),
                          ],
                        ),
                      )
                    ],
                  ),
                  height20SizedBox, buildText(StringConstants.mobileNoText, StringConstants.starText,),

                  height4SizedBox,
                  IntlPhoneField(
                    initialCountryCode: 'US',
                    controller: addNewWorkerController.mobileNoTextController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    showDropdownIcon: false,
                    flagsButtonMargin: const EdgeInsets.all(10),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        ImageConstants.calling,
                      ),
                      alignLabelWithHint: true,
                      hintText: StringConstants.mobileText,
                      hintStyle: TextStyle(
                          color: AppColors.blackLight, fontSize: 15),
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
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
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
                    ),
                    initialValue: addNewWorkerController.countryCode.value,
                    onCountryChanged: (value) {
                      addNewWorkerController.countryCode.value =
                          "+${value.dialCode}";
                    },
                    onChanged: (phone) {
                      addNewWorkerController.phoneNumber.value =
                          phone.number.toString();
                      addNewWorkerController.countryCode.value =
                          phone.countryCode.toString();
                    },
                  ),
                  height20SizedBox,
                  addNewWorkerController.storeRoleList.isEmpty
                      ? height0SizedBox
                      :
                  buildText(StringConstants.roleText, StringConstants.starText,),
                  addNewWorkerController.storeRoleList.isEmpty
                      ? height0SizedBox
                      : Obx(
                          () => DropdownButtonFormField<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (addNewWorkerController
                                      .storeRoleList.isNotEmpty &&
                                  value == null) {
                                return AlertStringConstants
                                    .pleaseSelectRoleText;
                              }
                              return null;
                            },
                            value: addNewWorkerController.roleId.value != ""
                                ? addNewWorkerController.storeRoleList
                                    .firstWhere((element) =>
                                        element.roleId ==
                                        addNewWorkerController.roleId.value)
                                    .roleId
                                : null,
                            isExpanded: true,
                            decoration: InputDecoration(
                              errorMaxLines: 3,
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
                            ),
                            hint: Text(
                              StringConstants.selectTypeText,
                              style: const TextStyle(
                                  color: AppColors.grey, fontSize: 14),
                            ),
                            items: addNewWorkerController.storeRoleList
                                .map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value.roleId,
                                child: Text(
                                  value.roleName,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              addNewWorkerController.roleId.value =
                                  value.toString();
                            },
                          ),
                        ),
                  height40SizedBox,
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      if (addNewWorkerController.isLoading.value = true) {
                        addNewWorkerController.isLoading.value = true;
                        addNewWorkerController.validateAndSubmit(
                            isEdit: true);
                      }
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
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
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
                                addNewWorkerController.formKey.currentState
                                    ?.reset();
                                addNewWorkerController.resetForm();
                                Get.back(id: pageIdApp.value);
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
                          ImageConstants.homeMall,
                          scale: 4,
                        )
                      ]),
                ],
              )),
        ));
  }
  Text buildText(title,starText) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: title,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          TextSpan(
            text:starText,
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.red,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
