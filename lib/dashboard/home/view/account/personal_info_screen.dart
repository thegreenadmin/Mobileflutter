import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_edit_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> with GlobalVarMixin {
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(id: pageIdApp.value);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primaryLight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 20, top: 50),
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
                        Get.to(() => const PersonalInfoEditScreen(),
                            id: pageIdApp.value);
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
                Text(
                  StringConstants.firstNameText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(StringConstants.lastNameText,
                    style: TextStyle(
                        color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(StringConstants.nickNameText,
                    style: TextStyle(
                        color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(StringConstants.emailIdText,
                    style: TextStyle(
                        color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.phoneNumberText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                Text(
                  StringConstants.addressLine1Text,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.addressLine2Text,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.townOrCityText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.postalCodeText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.countryText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Text(
                  StringConstants.stateText,
                  style: TextStyle(
                      color: AppColors.blackLight,
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
                height4SizedBox,
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                Obx(() => accountController
                        .idProofImageDynamicLinkFromServer.value.isNotEmpty
                    ? Text(
                        StringConstants.identityInfoText,
                        style: TextStyle(
                            color: AppColors.blackLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    : height0SizedBox),
                height20SizedBox,
                Obx(() => accountController
                        .idProofImageDynamicLinkFromServer.value.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            width: WidgetConstants.screenWidth,
                            height: WidgetConstants.screenHeight * 0.3,
                            child: Obx(() => InkWell(
                                  onTap: () {},
                                  child: DottedBorder(
                                    color: AppColors.blackLight,
                                    strokeWidth: 1,
                                    dashPattern: const [4, 4],
                                    child: CommonWidgets.cachedNetworkImage(
                                        accountController
                                            .idProofImageDynamicLinkFromServer
                                            .value,
                                        width: WidgetConstants.screenWidth,
                                        height:
                                            WidgetConstants.screenHeight * 0.3),
                                  ),
                                )),
                          ),
                          height10SizedBox,
                        ],
                      )
                    : height0SizedBox),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
