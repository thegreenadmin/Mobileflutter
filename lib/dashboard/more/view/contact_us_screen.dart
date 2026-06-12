import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/more/controller/contact_us_controller.dart';
import 'package:thegreenmall/utils/utils.dart';
class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with GlobalVarMixin {
  final ContactUsController contactUsController = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildImageSection(context),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: contactUsController.formKey,
                  child: Column(
                    children: [

                      _buildFormFields(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(ImageConstants.homeMall, scale: 4),
                  width10SizedBox,
                  IconButton(
                    onPressed: () => Get.back(id: pageIdApp.value),
                    icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 24.0),
                  ),
                  width10SizedBox,
                  Text(
                    StringConstants.contactUsText,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
                ],
              ),
            ],
          ),
          height10SizedBox,
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .25,
      color: AppColors.primaryLight,
      child: Image.asset(ImageConstants.image),
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstants.getInTouchText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black),
          ),
          height20SizedBox,
          _buildTextField(
            controller: contactUsController.nameTextController,
            label: StringConstants.nameText,
            validator: (value) => value!.trim().isEmpty ? AlertStringConstants.pleaseEnterNameText : null,
          ),
          _buildTextField(
            controller: contactUsController.emailTextController,
            label: StringConstants.emailText,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
            value!.trim().isEmpty
                ? AlertStringConstants.pleaseEnterEmailText
                : !GetUtils.isEmail(value.trim())
                ? AlertStringConstants.pleaseEnterValidEmailText
                : null,
          ),
          _buildTextField(
            controller: contactUsController.subjectTextController,
            label: StringConstants.subjectText,
            validator: (value) => value!.trim().isEmpty ? AlertStringConstants.pleaseEnterSubjectText : null,
          ),
          _buildTextField(
            controller: contactUsController.messageTextController,
            label: StringConstants.messageText,
            maxLines: 4,
            validator: (value) => value!.trim().isEmpty ? AlertStringConstants.pleaseEnterMessageText : null,
          ),
          height10SizedBox,
          CustomButton(
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primary]),
            onTap: () => contactUsController.validateAndSubmit(context),
            height: 50,
            text: StringConstants.sendMessageText,
            borderRadius: 12,
            fontWeight: FontWeight.w500,
            iconL: false,
            fontSize: 16,
          ),
          height40SizedBox,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.words,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.black),
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          hintStyle: TextStyle(color: AppColors.blackLight),
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.blackLight),
          border: _outlineBorder(AppColors.grey),
          errorBorder: _outlineBorder(AppColors.primary),
          focusedBorder: _outlineBorder(AppColors.primary),
          enabledBorder: _outlineBorder(AppColors.grey),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }
}