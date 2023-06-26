import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_worker_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/mutli_select_drop_down.dart';
import '../../../../utils/sizedbox_constants.dart';

class AddNewWorkerScreen extends StatefulWidget {
  const AddNewWorkerScreen({super.key});

  @override
  State<AddNewWorkerScreen> createState() => _AddNewWorkerScreenState();
}

class _AddNewWorkerScreenState extends State<AddNewWorkerScreen> {
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
                                  Get.back(id: pageIdApp.value);
                                  // Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.addWorkerText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.profilePicText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    height20SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DottedBorder(
                              borderType: BorderType.Circle,
                              radius: const Radius.circular(20),
                              color: AppColors.blacklight,
                              strokeWidth: 1,
                              dashPattern: const [4, 4],
                              child: Obx(() => Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: addNewWorkerController
                                                    .userImageDynamicLinkFromServer
                                                    .value ==
                                                "" ||
                                            addNewWorkerController
                                                .userImageDynamicLinkFromServer
                                                .value
                                                .isEmpty
                                        ? const CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: AssetImage(
                                              ImageConstants.userAccount,
                                            ),
                                            backgroundColor:
                                                AppColors.primarylight,
                                          )
                                        : CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: NetworkImage(
                                                addNewWorkerController
                                                    .userImageDynamicLinkFromServer
                                                    .value),
                                            backgroundColor: Colors.transparent,
                                          ),
                                  )),
                            ),
                          ],
                        ),
                        width20SizedBox,
                        Column(
                          children: [
                            height20SizedBox,
                            Text(StringConstants.uploadPhotoHereText,
                                style: TextStyle(
                                    color: AppColors.blacklight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            height10SizedBox,
                            InkWell(
                              onTap: () {
                                addNewWorkerController
                                    .showSelectionDialog(context);
                              },
                              child: Image.asset(
                                ImageConstants.uploadbutton,
                                scale: 3,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.employeeNameText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    height4SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
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
                                .pleaseEnterEmployeeNameText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.emailIdText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    height4SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.primaryStoreText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
                            color: AppColors.primarylight,
                          ),
                        )),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.shortDescriptionText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        autofocus: false,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: addNewWorkerController
                            .shortDescriptionTextController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterShortDescriptionText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.workingDaysText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.startTimeText,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              height4SizedBox,
                              TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                    TimeOfDay date = TimeOfDay.now();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    date = (await showTimePicker(
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                      helpText: StringConstants.selectTimeText,
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
                                    errorMaxLines: 3,
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
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.endTimeText,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    const TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              height4SizedBox,
                              TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                      helpText: StringConstants.selectTimeText,
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

                                    /* final startDT = DateTime(9, 9, 9, date.hour, date.minute);
                                    final endDT = DateTime(9, 9, 9, Utility.stringToTimeOfDay(addNewWorkerController.storeClosingTime.toString()).hour, Utility.stringToTimeOfDay(addNewWorkerController.storeClosingTime.toString()).minute);
                                    print(startDT);
                                    print(endDT);
                                    if (startDT.isBefore(endDT)) {
                                      Utility.showToast("Please select time before ${addNewWorkerController.storeClosingTime.toString()}");
                                    } else {
                                      addNewWorkerController.endTimeTextController
                                          .text = date.format(context).toString();
                                    }*/
                                    addNewWorkerController.endTimeTextController
                                        .text = date.format(context).toString();
                                  },
                                  decoration: InputDecoration(
                                    errorMaxLines: 3,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.mobileNoText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
                        prefixIcon: Image.asset(ImageConstants.calling),
                        alignLabelWithHint: true,
                        hintText: StringConstants.mobileText,
                        hintStyle: TextStyle(
                            color: AppColors.blacklight, fontSize: 15),
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
                    Obx(
                      () => addNewWorkerController.storeRoleList.isEmpty
                          ? height0SizedBox
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: StringConstants.roleText,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      const TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  validator: (value) {
                                    if (addNewWorkerController
                                            .storeRoleList.isNotEmpty &&
                                        value == null) {
                                      return AlertStringConstants
                                          .pleaseSelectRoleText;
                                    }
                                    return null;
                                  },
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
                              ],
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
                        addNewWorkerController.validateAndSubmit(context);
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
