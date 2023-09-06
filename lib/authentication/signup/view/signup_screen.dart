import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/authentication/login/view/login_screen.dart';
import 'package:thegreenmall/authentication/signup/controller/signup_controller.dart';
import 'package:thegreenmall/dashboard/more/view/webview_page_screen.dart';
import 'package:thegreenmall/utils/custom_textfield.dart';
import 'package:thegreenmall/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  final bool isFromOwner;
  const SignupScreen({super.key, this.isFromOwner = false});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupController signupController = Get.put(SignupController());

  String? formattedDate;
  String? formattedDateToCompare;
  TimeOfDay selectedTime = TimeOfDay.now();

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
                    CustomInputField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(40),
                      ],
                      borderColor: AppColors.primary,
                      borderRadius: 5,
                      enableBorderColor: AppColors.grey,
                      enableBorderRadius: 5,
                      disabledBorderColor: AppColors.primary,
                      disabledBorderRadius: 5,
                      focusedBorderColor: AppColors.primary,
                      focusedBorderRadius: 5,
                      errorBorderColor: AppColors.red,
                      errorBorderRadius: 5,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      prefixIcon: Image.asset(
                        ImageConstants.profile,
                        scale: 2.8,
                      ),
                      fillColor: AppColors.white,
                      controller: signupController.firstNameTextController,
                      hintText: StringConstants.firstNameText,
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                      ),
                      labelText: StringConstants.firstNameText,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blacklight,
                          decoration: TextDecoration.none),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        signupController.firstName.value = value!;
                      },
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AlertStringConstants.pleaseEnterFirstNameText;
                        }
                        return null;
                      },
                    ),
                    height15SizedBox,
                    CustomInputField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(40),
                      ],
                      borderColor: AppColors.primary,
                      borderRadius: 5,
                      enableBorderColor: AppColors.grey,
                      enableBorderRadius: 5,
                      disabledBorderColor: AppColors.primary,
                      disabledBorderRadius: 5,
                      focusedBorderColor: AppColors.primary,
                      focusedBorderRadius: 5,
                      errorBorderColor: AppColors.red,
                      errorBorderRadius: 5,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      prefixIcon: Image.asset(
                        ImageConstants.profile,
                        scale: 2.8,
                      ),
                      fillColor: AppColors.white,
                      controller: signupController.lastNameTextController,
                      hintText: StringConstants.lastNameText,
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                      ),
                      labelText: StringConstants.lastNameText,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blacklight,
                          decoration: TextDecoration.none),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        signupController.lastName.value = value!;
                      },
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AlertStringConstants.pleaseEnterLastNameText;
                        }
                        return null;
                      },
                    ),
                    height15SizedBox,
                    CustomInputField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                      ],
                      borderColor: AppColors.primary,
                      borderRadius: 5,
                      enableBorderColor: AppColors.grey,
                      enableBorderRadius: 5,
                      disabledBorderColor: AppColors.primary,
                      disabledBorderRadius: 5,
                      focusedBorderColor: AppColors.primary,
                      focusedBorderRadius: 5,
                      errorBorderColor: AppColors.red,
                      errorBorderRadius: 5,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      prefixIcon: Image.asset(
                        ImageConstants.email,
                        scale: 2.8,
                      ),
                      fillColor: AppColors.white,
                      controller: signupController.emailTextController,
                      hintText: StringConstants.emailText,
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                      ),
                      labelText: StringConstants.emailText,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blacklight,
                          decoration: TextDecoration.none),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        signupController.email.value = value!;
                      },
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
                    height15SizedBox,
                    IntlPhoneField(
                      initialCountryCode: 'US',
                      controller: signupController.phoneNumberTextController,
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
                          scale: 2.8,
                        ),
                        alignLabelWithHint: true,
                        hintText: StringConstants.mobileText,
                        hintStyle: TextStyle(
                            color: AppColors.blacklight, fontSize: 15),
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
                        signupController.countryCode.value =
                            "+${value.dialCode}";
                      },
                      onChanged: (phone) {
                        signupController.phoneNumber.value =
                            phone.number.toString();
                        signupController.countryCode.value =
                            phone.countryCode.toString();
                      },
                    ),
                    height8SizedBox,
                    CustomInputField(
                      onTap: () async {
                        DateTime date = DateTime.now();
                        FocusScope.of(context).requestFocus(FocusNode());
                        date = (await showDatePicker(
                          helpText: StringConstants.selectDateText,
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

                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        formattedDate = formatter.format(date);
                        signupController.dateTextController.text =
                            formattedDate!;
                        signupController.dateOfEvent.value =
                            date.toIso8601String();

                        signupController.isAdultCheck(
                            signupController.dateTextController.text);
                        bool result = signupController.isAdultCheck(
                            signupController.dateTextController.text);
                        if (!result) {
                          signupController.ageAlertDailogue(Get.context);
                          signupController.dateTextController.clear();
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                      ],
                      borderColor: AppColors.primary,
                      borderRadius: 5,
                      enableBorderColor: AppColors.grey,
                      enableBorderRadius: 5,
                      disabledBorderColor: AppColors.primary,
                      disabledBorderRadius: 5,
                      focusedBorderColor: AppColors.primary,
                      focusedBorderRadius: 5,
                      errorBorderColor: AppColors.red,
                      errorBorderRadius: 5,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      prefixIcon: Image.asset(
                        ImageConstants.calendar,
                        scale: 2.8,
                      ),
                      fillColor: AppColors.white,
                      controller: signupController.dateTextController,
                      hintText: StringConstants.ageText,
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                      ),
                      labelText: StringConstants.dobText,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blacklight,
                          decoration: TextDecoration.none),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        signupController.email.value = value!;
                      },
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return AlertStringConstants.pleaseSelectDateText;
                        }
                        return null;
                      },
                    ),
                    // TextFormField(
                    //   onTap: () async {
                    //     DateTime date = DateTime.now();
                    //     FocusScope.of(context).requestFocus(FocusNode());
                    //     date = (await showDatePicker(
                    //       helpText: StringConstants.selectDateText,
                    //       builder: (BuildContext context, Widget? child) {
                    //         return Theme(
                    //           data: ThemeData.light().copyWith(
                    //             colorScheme: const ColorScheme.light(
                    //                 primary: AppColors.primary),
                    //             buttonTheme: const ButtonThemeData(
                    //                 textTheme: ButtonTextTheme.primary),
                    //           ),
                    //           child: child!,
                    //         );
                    //       },
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime.utc(1200, 1, 1),
                    //       lastDate: DateTime.now(),
                    //     ))!;

                    //     final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    //     formattedDate = formatter.format(date);
                    //     signupController.dateTextController.text =
                    //         formattedDate!;
                    //     signupController.dateOfEvent.value =
                    //         date.toIso8601String();

                    //     signupController.isAdultCheck(
                    //         signupController.dateTextController.text);
                    //     bool result = signupController.isAdultCheck(
                    //         signupController.dateTextController.text);
                    //     if (!result) {
                    //       signupController.ageAlertDailogue(Get.context);
                    //       signupController.dateTextController.clear();
                    //     }
                    //   },
                    //   validator: (value) {
                    //     if (value!.trim().isEmpty) {
                    //       return AlertStringConstants.pleaseSelectDateText;
                    //     }
                    //     return null;
                    //   },
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   textInputAction: TextInputAction.done,
                    //   enabled: true,
                    //   style: const TextStyle(
                    //       color: AppColors.black,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w400),
                    //   controller: signupController.dateTextController,
                    //   decoration: InputDecoration(
                    //     labelText: StringConstants.dobText,
                    //     labelStyle: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w400,
                    //         color: AppColors.blacklight,
                    //         decoration: TextDecoration.none),
                    //     fillColor: Colors.white,
                    //     contentPadding: const EdgeInsets.only(
                    //         left: 10, right: 10, top: 5, bottom: 5),
                    //     hintText: StringConstants.ageText,
                    //     hintStyle: const TextStyle(color: AppColors.primary),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     errorBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.red,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     disabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       borderSide: const BorderSide(
                    //         color: AppColors.grey,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //     prefixIcon: Image.asset(
                    //       ImageConstants.calendar,
                    //       scale: 2.8,
                    //     ),
                    //   ),
                    // ),
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
                        Flexible(
                          flex: 9,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: StringConstants.byCheckingText),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(WebviewPageScreen(
                                          isFrom: "terms",
                                          url: Uri.parse(ServerCommunicator()
                                                      .baseUrlWithoutApi +
                                                  ServerCommunicator()
                                                      .pagePolicy)
                                              .toString()));
                                    },
                                  text: StringConstants.termsAndConditionsText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: StringConstants.acknowledgeText),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(WebviewPageScreen(
                                          isFrom: StringConstants.privacyText,
                                          url: Uri.parse(ServerCommunicator()
                                                      .baseUrlWithoutApi +
                                                  ServerCommunicator()
                                                      .pagePolicy)
                                              .toString()));
                                    },
                                  text: StringConstants.privacyPolicyText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
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
                          signupController.validateAndSubmit(
                              isFromOwner: widget.isFromOwner);
                        },
                        height: 50,
                        text: StringConstants.signUpText,
                        borderRadius: 12,
                        fontWeight: FontWeight.w500,
                        iconR: true,
                        fontSize: 16,
                        imageR: Image.asset(
                          ImageConstants.arrowright,
                          scale: 3,
                        )),
                    height20SizedBox,
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.back();
                        Get.to(() => const LoginScreen());
                      },
                      child: Center(
                        child: Text(
                          StringConstants.loginYourAccountText,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
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
