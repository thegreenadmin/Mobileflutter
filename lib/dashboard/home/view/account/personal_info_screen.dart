import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/personal_info_edit_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

import 'widgets/personal_address_section.dart';
import 'widgets/personal_header.dart';

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
        body: Stack(
          children: [
            Column(
              children: [
                PersonalInfoHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      child: Obx(() {
                        final a = accountController;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildEdit(),
                            height30SizedBox,
                            infoTile(StringConstants.firstNameText, a.firstName?.value ??""),
                            infoTile(StringConstants.lastNameText, a.lastName?.value ??""),
                            infoTile(StringConstants.nickNameText, a.nickName?.value??""),
                            infoTile(StringConstants.emailIdText, a.email.value),
                            infoTile(StringConstants.phoneNumberText, a.phone.value),
                            AddressSection(a),
                            Obx(() =>
                            accountController
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
                            Obx(() =>
                            accountController
                                .idProofImageDynamicLinkFromServer.value.isNotEmpty
                                ? Column(
                              children: [
                                SizedBox(
                                  width: WidgetConstants.screenWidth,
                                  height: WidgetConstants.screenHeight * 0.3,
                                  child: Obx(() =>
                                      InkWell(
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
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            //LOADING OVERLAY
            Obx(() {
              return accountController.isLoading.value
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
      ),
    );
  }

  Row buildEdit() {
    return Row(
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
                          );
  }

  Widget infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
            color: AppColors.blackLight,
            fontWeight: FontWeight.w400,
            fontSize: 16),),
        height10SizedBox,
        Text(value,   style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16),),
        Divider(height: 40, thickness: 1),
      ],
    );
  }


  Container buildAppBar() {
    return Container(
      color: AppColors.primaryLight,
      child: Padding(
          padding:
          const EdgeInsets.only(left: 15.0, right: 20, top: 50),
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
    );
  }
}
