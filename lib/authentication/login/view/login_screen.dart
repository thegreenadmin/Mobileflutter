
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/authentication/login/controller/login_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
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
        body: SingleChildScrollView(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Form(
                  key: loginController.formKey,
                  child: Container(
                    height: WidgetConstants.screenHeight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.loginYourAccountText,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 30),
                        ),
                        height10SizedBox,
                        Text(
                          StringConstants.enterMobileNumberText,
                          style: const TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        IntlPhoneField(
                          initialCountryCode: 'US',
                          // countries:loginController.countryCodes,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: loginController.phoneTextController,
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
                            hintStyle: const TextStyle(
                                color: AppColors.black, fontSize: 15),
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
                            loginController.countryCode.value =
                                "+${value.dialCode}";
                          },
                          onChanged: (phone) {
                            loginController.phoneNumber.value =
                                phone.number.toString();
                            loginController.countryCode.value =
                                phone.countryCode.toString();
                          },
                        ),
                        height40SizedBox,
                        CustomButton(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.primary, AppColors.primary],
                            ),
                            onTap: () {
                              loginController.validateAndSubmit();
                            },
                            height: 50,
                            text: StringConstants.sendConfirmationCodeText,
                            borderRadius: 12,
                            fontWeight: FontWeight.w500,
                            iconR: true,
                            iconL: false,
                            fontSize: 16,
                            imageR: Image.asset(
                              ImageConstants.arrowright,
                              scale: 3,
                            )),
                      ],
                    ),
                  ),
                ))));
  }
}
