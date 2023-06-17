import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
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
    return WillPopScope(
      onWillPop: () async {
        Get.back(id:accountController.pageId.value);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                  Get.back(id:accountController.pageId.value);
                                  // Navigator.of(context).pop();
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
                              ImageConstants.homeMall,
                              scale: 5,
                            )
                          ]),
                    ],
                  )),
            )),
        body: SingleChildScrollView(
          child: Padding(
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
                        // SharedPreferenceStorage.setData("context", context);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (_) => const PersonalInfoEditScreen(),
                        // ));
                        Get.to(const PersonalInfoEditScreen(),id:accountController.pageId.value);
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.firstNameText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.firstName!.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(StringConstants.lastNameText,
                    style: TextStyle(
                        color: AppColors.blacklight,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                height10SizedBox,
                Obx(() => Text(
                      accountController.lastName!.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(StringConstants.nickNameText,
                    style: TextStyle(
                        color: AppColors.blacklight,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                height10SizedBox,
                Obx(() => Text(
                      accountController.nickName!.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(StringConstants.emailIdText,
                    style: TextStyle(
                        color: AppColors.blacklight,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                height10SizedBox,
                Obx(() => Text(
                      accountController.email.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.phoneNumberText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.phone.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.addressText,
                  style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                height30SizedBox,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.addressLine1Text,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.addressLine1.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.addressLine2Text,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.addressLine2.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.townOrCityText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.city.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.postalCodeText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.postalCode.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.countryText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.country.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Text(
                  StringConstants.stateText,
                  style: TextStyle(
                      color: AppColors.blacklight,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                height10SizedBox,
                Obx(() => Text(
                      accountController.state.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
                //   ],
                // ),
                height4SizedBox,
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
