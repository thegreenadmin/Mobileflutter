import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/authentication/otpverification/controller/otp_verification_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpVerificationController otpVerificationController =
      Get.put(OtpVerificationController());

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
        body: SingleChildScrollView(
          child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Form(
                key: otpVerificationController.formKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/otpVerification.png",
                          scale: 2.4,
                        ),
                        height40SizedBox,
                        Text(
                          StringConstants.verificationCodeText,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        height10SizedBox,
                        Text(
                          "${StringConstants.verificationCodeSentText}${otpVerificationController.countryCode.value.trim()}-${otpVerificationController.phoneNumber.value.trim()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              height: 1.4,
                              fontWeight: FontWeight.w400),
                        ),
                        height30SizedBox,
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35.0,
                            right: 35,
                          ),
                          child: PinCodeTextField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AlertStringConstants.pleaseEnterOtpText;
                              } else if (value.length < 4) {
                                return AlertStringConstants.invalidOtpText;
                              }
                              return null;
                            },
                            cursorWidth: 2,
                            autoDisposeControllers: false,
                            cursorHeight: 25,
                            cursorColor: AppColors.primary,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            errorTextSpace: 20,
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w500),
                            obscureText: true,
                            appContext: context,
                            keyboardType: TextInputType.number,
                            length: 4,
                            controller:
                                otpVerificationController.otpTextController,
                            enableActiveFill: false,
                            blinkWhenObscuring: true,
                            pinTheme: PinTheme(
                                borderWidth: 1,
                                errorBorderColor: AppColors.red,
                                borderRadius: BorderRadius.circular(5.0),
                                shape: PinCodeFieldShape.box,
                                fieldHeight: 45,
                                fieldWidth: 50,
                                disabledColor: AppColors.grey,
                                inactiveFillColor: AppColors.grey,
                                activeColor: AppColors.primary,
                                activeFillColor: AppColors.grey,
                                inactiveColor: AppColors.grey),
                            onChanged: (v) {},
                            onCompleted: (value) {},
                          ),
                        ),
                        height5SizedBox,
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            // signupController.apiResendOtp();
                          },
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Didn’t get a code?",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.blacklight)),
                                  const TextSpan(
                                    text: ' Resend',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
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
                              otpVerificationController.validateAndSubmitOtp();
                            },
                            height: 50,
                            text: StringConstants.submitText,
                            borderRadius: 12,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            iconR: true,
                            imageR: Image.asset(
                              "assets/arrowright.png",
                              scale: 3,
                            )),
                        height20SizedBox,
                      ]),
                ),
              )),
        ));
  }
}
