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
  final ContactUsController contactUsController =
      Get.put(ContactUsController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
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
                                StringConstants.contactUsText,
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
                    height10SizedBox,
                  ],
                )),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            key: contactUsController.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: WidgetConstants.screenWidth,
                    height: MediaQuery.of(context).size.height * .25,
                    color: AppColors.primaryLight,
                    child: Image.asset(
                      ImageConstants.image,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(right: 20.0, left: 20.0, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height10SizedBox,
                        Text(
                          StringConstants.getInTouchText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        height20SizedBox,
                        TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(50),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            controller: contactUsController.nameTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AlertStringConstants.pleaseEnterNameText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: StringConstants.nameText,
                              hintStyle: TextStyle(color: AppColors.blackLight),
                              labelText: StringConstants.nameText,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackLight,
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
                        height20SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(100),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            controller: contactUsController.emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterEmailText;
                              } else if (!GetUtils.isEmail(value.trim())) {
                                return AlertStringConstants
                                    .pleaseEnterValidEmailText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: StringConstants.emailText,
                              hintStyle: TextStyle(color: AppColors.blackLight),
                              labelText: StringConstants.emailText,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackLight,
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
                        height20SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(300),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            controller:
                                contactUsController.subjectTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterSubjectText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: StringConstants.subjectText,
                              hintStyle: TextStyle(color: AppColors.blackLight),
                              labelText: StringConstants.subjectText,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackLight,
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
                        height20SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(800),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            controller:
                                contactUsController.messageTextController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterMessageText;
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: StringConstants.messageText,
                              hintStyle: TextStyle(color: AppColors.blackLight),
                              labelText: StringConstants.messageText,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackLight,
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
                        height20SizedBox,
                        CustomButton(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primary, AppColors.primary],
                          ),
                          onTap: () {
                            contactUsController.validateAndSubmit(context);
                          },
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
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
