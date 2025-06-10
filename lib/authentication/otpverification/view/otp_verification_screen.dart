import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thegreenmall/authentication/otpverification/controller/otp_verification_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

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
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: Form(
                      key: otpVerificationController.formKey,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Column(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                                        child:  Icon(
                                          Icons.chevron_left,
                                          color: AppColors.blackLight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  height40SizedBox,
                                  Image.asset(
                                    ImageConstants.otpVerification,
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
                                        color: AppColors.blackLight,
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
                                          color: AppColors.blackLight,
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
                                      onCompleted: (value) {
                                        if (otpVerificationController.isLoading.value ==
                                            false) {
                                          otpVerificationController
                                              .validateAndSubmitOtp();
                                        }
                                      },
                                    ),
                                  ),
                                  height5SizedBox,
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(StringConstants.didNotGetACodeText,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.blackLight)),
                                        width5SizedBox,
                                        InkWell(
                                          onTap: () {
                                            if (otpVerificationController
                                                    .isLoading.value ==
                                                false) {
                                              otpVerificationController.apiResendOtp();
                                              // otpVerificationController
                                              //     .validateAndSubmitOtp();
                                            }
                                          },
                                          child: Text(
                                            StringConstants.resendText,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary),
                                          ),
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
                                        if (otpVerificationController.isLoading.value ==
                                            false) {
                                          otpVerificationController
                                              .validateAndSubmitOtp();
                                        }
                                      },
                                      height: 50,
                                      text: StringConstants.submitText,
                                      borderRadius: 12,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      iconR: true,
                                      imageR: Image.asset(
                                        ImageConstants.arrowRight,
                                        scale: 3,
                                      )),
                                  height20SizedBox,
                                ]),
                          ],
                        ),
                      ),
                    )),
              ),
              //LOADING OVERLAY
              Obx(() {
                return otpVerificationController.isLoading.value
                    ? Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ));
  }
}
