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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Form(
                key: signupController.formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackButton(),
                      height30SizedBox,
                      _buildTitle(),
                      height10SizedBox,
                      _buildSubTitle(),
                      height25SizedBox,
                      _buildInputFields(),
                      height20SizedBox,
                      _buildTermsAndConditions(),
                      height30SizedBox,
                      _buildSignupButton(),
                      height20SizedBox,
                      _buildLoginRedirect(),
                      height20SizedBox,
                    ],
                  ),
                ),
              ),
              _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  /// Back Button
  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.chevron_left, color: AppColors.blackLight),
      ),
    );
  }

  /// Page Title
  Widget _buildTitle() {
    return Text(
      StringConstants.createAccountText,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Page Subtitle
  Widget _buildSubTitle() {
    return Text(
      StringConstants.createAccountDetailText,
      style: const TextStyle(
        color: AppColors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Input Fields Section
  Widget _buildInputFields() {
    return Column(
      children: [
        _buildCustomInputField(signupController.firstNameTextController,
            StringConstants.firstNameText, ImageConstants.profile,
            validator: (value) => value!.trim().isEmpty
                ? AlertStringConstants.pleaseEnterFirstNameText
                : null),
        height15SizedBox,
        _buildCustomInputField(signupController.lastNameTextController,
            StringConstants.lastNameText, ImageConstants.profile,
            validator: (value) => value!.trim().isEmpty
                ? AlertStringConstants.pleaseEnterLastNameText
                : null),
        height15SizedBox,
        _buildCustomInputField(signupController.emailTextController,
            StringConstants.emailText, ImageConstants.email,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return AlertStringConstants.pleaseEnterEmailText;
              } else if (!GetUtils.isEmail(value.trim())) {
                return AlertStringConstants.pleaseEnterValidEmailText;
              }
              return null;
            }),
        height15SizedBox,
        _buildPhoneField(),
        height8SizedBox,
        _buildDateField(),
      ],
    );
  }

  /// Custom Input Field Generator
  Widget _buildCustomInputField(
      TextEditingController controller, String hintText, String prefixIcon,
      {required String? Function(String?) validator}) {
    return CustomInputField(
      isBorderOutline: true,
      inputFormatters: [LengthLimitingTextInputFormatter(40)],
      prefixIcon: Image.asset(prefixIcon, scale: 2.8),
      controller: controller,
      hintText: hintText,
      labelText: hintText,
      textCapitalization: TextCapitalization.words,
      validator: validator,
    );
  }

  /// Phone Input Field
  Widget _buildPhoneField() {
    return IntlPhoneField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
      value == null || value.number.isEmpty ? AlertStringConstants.pleaseEnterPhoneText : null,
      initialCountryCode: 'US',
      controller: signupController.phoneNumberTextController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w400),
      showDropdownIcon: false,
      flagsButtonMargin: const EdgeInsets.all(10),
      textInputAction: TextInputAction.done,
      decoration: _phoneInputDecoration(),
      onCountryChanged: (value) => signupController.countryCode.value = "+${value.dialCode}",
      onChanged: (phone) {
        signupController.phoneNumber.value = phone.number;
        signupController.countryCode.value = phone.countryCode;
      },
    );
  }

  /// Phone Input Decoration (Maintains Same Colors & Design)
  InputDecoration _phoneInputDecoration() {
    return InputDecoration(
      prefixIcon: Image.asset(ImageConstants.calling, scale: 2.8),
      alignLabelWithHint: true,
      hintText: StringConstants.mobileText,
      hintStyle:  TextStyle(color: AppColors.blackLight, fontSize: 15),
      border: _outlineBorder(AppColors.primary),
      errorBorder: _outlineBorder(AppColors.primary),
      enabledBorder: _outlineBorder(AppColors.grey),
      focusedBorder: _outlineBorder(AppColors.primary),
    );
  }

  /// Reusable Outline Border Style
  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }

  /// Date of Birth Input Field (Date Picker Unchanged)
  Widget _buildDateField() {
    return CustomInputField(
      isBorderOutline: true,
      controller: signupController.dateTextController,
      hintText: StringConstants.dobText,
      labelText: StringConstants.dobText,
      prefixIcon: Image.asset(ImageConstants.calendar, scale: 2.8),
      validator: (value) =>
      value!.trim().isEmpty ? AlertStringConstants.pleaseSelectDateText : null,
      onTap: () async {
        FocusScope.of(context).unfocus();
        DateTime? date = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime.utc(1200, 1, 1),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: AppColors.primary),
              ),
              child: child!,
            );
          },
        );

        if (date != null) {
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          signupController.dateTextController.text = formatter.format(date);
        }
      },
    );
  }

  /// Terms & Conditions Checkbox (Unchanged)
  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Obx(
              () => Checkbox(
                side: WidgetStateBorderSide.resolveWith(
                      (states) => BorderSide(
                      width: 1.0,
                      color:
                      AppColors.primary.withOpacity(0.5)),
                ),
            value: signupController.isTermsAccepted.value,
            onChanged: (value) => signupController.isTermsAccepted.value = value!,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                activeColor: AppColors.primary,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: StringConstants.byCheckingText),
                _buildLinkText(StringConstants.termsAndConditionsText, "terms"),
                TextSpan(text: StringConstants.acknowledgeText),
                _buildLinkText(StringConstants.privacyPolicyText, StringConstants.privacyText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Link Text for Terms & Conditions
  TextSpan _buildLinkText(String text, String page) {
    return TextSpan(
      recognizer: TapGestureRecognizer()
        ..onTap = () => Get.to(() => WebviewPageScreen(isFrom: page, url: 'URL')),
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    );
  }

  /// Signup Button
  Widget _buildSignupButton() {
    return CustomButton(
      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primary]),
      onTap: () => signupController.validateAndSubmit(isFromOwner: widget.isFromOwner),
      height: 50,
      text: StringConstants.signUpText,
      borderRadius: 12,
      fontSize: 16,
    );
  }

  /// Login Redirect
  Widget _buildLoginRedirect() {
    return InkWell(
      onTap: () {
        Get.back();
        Get.to(() => const LoginScreen());
      },
      child: Center(
        child: Text(
          StringConstants.loginYourAccountText,
          style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Loading Overlay
  Widget _buildLoadingOverlay() {
    return Obx(() => signupController.isLoading.value
        ? Container(
      color: Colors.black.withOpacity(0.2),
      child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    )
        : const SizedBox.shrink());
  }

}
