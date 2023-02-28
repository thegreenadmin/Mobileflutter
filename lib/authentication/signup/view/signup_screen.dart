import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/authentication/signup/controller/signup_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupController signupController = Get.put(SignupController());

  String? formattedDate;
  String? formattedDateToCompare;
  TimeOfDay selectedTime = TimeOfDay.now();
  Rx<Locale> cL = const Locale("en", "IN").obs;
  void getCurrentLocale() async {
    cL.value = (await Devicelocale.currentAsLocale)!;
    signupController.selectedRegion.value = cL.value.countryCode!;
    debugPrint("selectedRegion----" +
        signupController.selectedRegion.value.toString());
    String languageCode = Platform.localeName.split('_')[0];
    await CountryCodes
        .init(); // Optionally, you may provide a `Locale` to get countrie's localizadName
    final Locale? deviceLocale = CountryCodes.getDeviceLocale();
    final CountryDetails details = CountryCodes.detailsForLocale();
    signupController.selectedCountryCode.value = details.dialCode!;
    debugPrint("selectedCountryCode----" +
        signupController.selectedCountryCode.value.toString());
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              side: BorderSide(width: 0.0, color: AppColors.blacklight),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.black,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: signupController.formKey,
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.createAccountText,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    height10SizedBox,
                    Text(
                      StringConstants.createAccountDetailText,
                      style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height25SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        controller: signupController.firstNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterFirstNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: Image.asset(
                            "assets/profile.png",
                            scale: 2.5,
                          ),
                          hintText: StringConstants.firstNameText,
                          hintStyle: const TextStyle(color: AppColors.grey),
                          labelText: StringConstants.firstNameText,
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blacklight,
                              decoration: TextDecoration.none),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height15SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        controller: signupController.lastNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterLastNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Image.asset(
                            "assets/profile.png",
                            scale: 2.4,
                          ),
                          hintText: StringConstants.lastNameText,
                          hintStyle: const TextStyle(color: AppColors.grey),
                          labelText: StringConstants.lastNameText,
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blacklight,
                              decoration: TextDecoration.none),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height15SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        controller: signupController.emailTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterEmailText;
                          } else if (!GetUtils.isEmail(value.trim())) {
                            return AlertStringConstants
                                .pleaseEnterValidEmailText;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Image.asset(
                            "assets/email.png",
                            scale: 2.5,
                          ),
                          hintText: StringConstants.emailText,
                          hintStyle: const TextStyle(color: AppColors.grey),
                          labelText: StringConstants.emailText,
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blacklight,
                              decoration: TextDecoration.none),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                        )),
                    height15SizedBox,
                    IntlPhoneField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      showDropdownIcon: false,
                      flagsButtonMargin: const EdgeInsets.all(10),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: StringConstants.mobileText,
                        labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blacklight,
                            decoration: TextDecoration.none),
                        hintText: StringConstants.mobileText,
                        hintStyle: const TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onCountryChanged: (value) {
                        signupController.selectedCountryCode.value =
                            value.dialCode.toString();
                        signupController.selectedRegion.value = value.name;
                        print(signupController.selectedCountryCode.value);
                        print(signupController.selectedRegion.value);
                      },
                      onChanged: (phone) {},
                    ),
                    // height15SizedBox,
                    // TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     autofocus: false,
                    //     inputFormatters: <TextInputFormatter>[
                    //       LengthLimitingTextInputFormatter(40),
                    //     ],
                    //     style: const TextStyle(
                    //         color: AppColors.primary,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400),
                    //     controller: signupController.genderTextController,
                    //     keyboardType: TextInputType.text,
                    //     validator: (value) {
                    //       if (value == null || value.trim().isEmpty) {
                    //         return AlertStringConstants.pleaseEnterGenderText;
                    //       }
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //       prefixIcon: Image.asset(
                    //         "assets/gender.png",
                    //         scale: 2.4,
                    //       ),
                    //       hintText: StringConstants.genderText,
                    //       hintStyle: const TextStyle(color: AppColors.grey),
                    //       labelText: StringConstants.genderText,
                    //       labelStyle: const TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.primary,
                    //           decoration: TextDecoration.none),
                    //       fillColor: Colors.white,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       errorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.primary,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.grey,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //     )),
                    height15SizedBox,
                    InkWell(
                      onTap: () async {
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(FocusNode());
                        print("Hello date" + date.toString());
                        date = (await showDatePicker(
                          helpText: "Select a Date",
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.utc(1200, 1, 1),
                          lastDate: DateTime.now(),
                        ))!;
                        final DateFormat formatter = DateFormat('MM/dd/yyyy');
                        formattedDate = formatter.format(date);
                        signupController.dateTextController.text =
                            formattedDate!;
                        signupController.dateOfEvent.value =
                            date.toIso8601String();
                        signupController.isAdultCheck(
                            signupController.dateTextController.text);
                        bool result = signupController.isAdultCheck(
                            signupController.dateTextController.text);
                        if (result) {
                        } else {
                          await Utility.showAlert(
                              "title",
                              "This app is recommended for 18 above age group.",
                              "OK");
                          signupController.dateTextController.clear();
                        }
                      },
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        enabled: false,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        controller: signupController.dateTextController,
                        decoration: InputDecoration(
                          labelText: StringConstants.ageText,
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blacklight,
                              decoration: TextDecoration.none),
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          hintText: StringConstants.ageText,
                          hintStyle: const TextStyle(color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: AppColors.grey,
                              width: 1.0,
                            ),
                          ),
                          prefixIcon: Image.asset(
                            "assets/calendar.png",
                            scale: 2.4,
                          ),
                        ),
                      ),
                    ),
                    height20SizedBox,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Obx(
                            () => SizedBox(
                                height: 20,
                                width: 30,
                                child: Checkbox(
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0,
                                        color:
                                            AppColors.primary.withOpacity(0.5)),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0)),
                                  activeColor: AppColors.primary,
                                  value: signupController.isTermsAccepted.value,
                                  onChanged: (bool? value) {
                                    signupController.isTermsAccepted.value =
                                        value!;
                                  },
                                )),
                          ),
                        ),
                        width8SizedBox,
                        const Flexible(
                          flex: 9,
                          child: Text(
                            "By checking this box, you agree to the green mall Inc’s Terms & Conditions of use and the the green mall Apps terms & conditions and acknowledge the receipts of the green mall Inc’s privacy policy.",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 0),
                          ),
                        ),
                      ],
                    ),
                    height30SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        signupController.validateAndSubmit();
                      },
                      height: 50,
                      text: StringConstants.signUpText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconR: true,
                      fontSize: 16,
                      imageR: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    height20SizedBox,
                    Center(
                      child: Text(
                        StringConstants.loginYourAccountText,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    height20SizedBox,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
