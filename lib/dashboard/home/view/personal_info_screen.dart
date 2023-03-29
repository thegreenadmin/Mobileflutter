import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/personal_info_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final AccountController accountController = Get.put(AccountController());
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
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.personalInformationText,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/homeMall.png",
                            scale: 5,
                          )
                        ]),
                  ],
                )),
          )),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.personalDetailText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(const PersonalInfoEditScreen());
                      },
                      child: Text(StringConstants.editText,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppColors.primary)),
                    ),
                  ],
                ),
                height30SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.firstNameText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Obx(() => Expanded(
                        flex: 6,
                        child: Text(
                          accountController.firstName!.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.lastNameText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    Obx(() => Expanded(
                        flex: 6,
                        child: Text(
                          accountController.lastName!.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.nickNameText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    Obx(() => Expanded(
                        flex: 6,
                        child: Text(
                          accountController.nickName!.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.emailIdText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    Obx(() => Expanded(
                        flex: 6,
                        child: Text(
                          accountController.email.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.phoneNumberText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Obx(() => Expanded(
                        flex: 6,
                        child: Text(
                          accountController.phone.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Text(
                  StringConstants.addressText,
                  style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                height30SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.addressLine1Text,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Expanded(
                        flex: 6,
                        child: Text(
                          accountController.addressLine1.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.addressLine2Text,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Expanded(
                        flex: 6,
                        child: Text(
                          accountController.addressLine2.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.townOrCityText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Expanded(
                        flex: 6,
                        child: Text(
                          accountController.city.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.postalCodeText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    Expanded(
                        flex: 6,
                        child: Text(
                          accountController.postalCode.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                height4SizedBox,
                const Divider(
                  thickness: 1,
                ),
                height15SizedBox,
                // Text(
                //   StringConstants.collectTheIdentityInfoText,
                //   style: const TextStyle(
                //       color: AppColors.black,
                //       fontWeight: FontWeight.w600,
                //       fontSize: 20),
                // ),
                // height20SizedBox,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     DottedBorder(
                //       color: AppColors.blacklight,
                //       strokeWidth: 1,
                //       dashPattern: const [4, 4],
                //       child: Container(
                //         padding: const EdgeInsets.only(
                //             left: 50, right: 50, top: 18, bottom: 18),
                //         color: AppColors.primarylight,
                //         child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Image.asset(
                //                 "assets/upload.png",
                //                 scale: 2.5,
                //               ),
                //               height6SizedBox,
                //               Text(
                //                 StringConstants
                //                     .uploadLicenseStateIdPasswordText,
                //                 style: TextStyle(color: AppColors.blacklight),
                //               ),
                //               height5SizedBox,
                //               SizedBox(
                //                 width: 130,
                //                 child: ElevatedButton(
                //                   onPressed: () {},
                //                   style: ButtonStyle(
                //                       foregroundColor:
                //                           MaterialStateProperty.all<Color>(
                //                               AppColors.primary),
                //                       shape: MaterialStateProperty.all<
                //                               RoundedRectangleBorder>(
                //                           RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(18.0),
                //                               side: const BorderSide(
                //                                   color: AppColors.primary)))),
                //                   child: const Text(
                //                     "Upload",
                //                     style: TextStyle(color: AppColors.white),
                //                   ),
                //                 ),
                //               )
                //             ]),
                //       ),
                //     ),
                //   ],
                // ),
                height20SizedBox,
              ],
            )),
      ),
    );
  }
}
