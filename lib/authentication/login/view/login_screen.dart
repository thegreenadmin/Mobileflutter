import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/authentication/login/controller/login_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
          backgroundColor: AppColors.white,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.primary,
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
                        height30SizedBox,
                        IntlPhoneField(
                          initialCountryCode: StringConstants.usText,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: loginController.phoneTextController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          enabled: true,
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
                            hintStyle: const TextStyle(fontSize: 15),
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
