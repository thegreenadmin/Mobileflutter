import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class SelectMembershipPlan extends StatefulWidget {
  const SelectMembershipPlan({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SelectMembershipPlanState();
  }
}

class SelectMembershipPlanState extends State<SelectMembershipPlan> {
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Row(
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
                          StringConstants.selectMembershipPlanText,
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Image.asset(
                      ImageConstants.homeMall,
                      scale: 4,
                    )
                  ])),
        ),
      ),
      body: Obx(
        () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              accountController.membershipList.isEmpty
                  ? accountController.isLoading.value == true
                      ? height0SizedBox
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  ImageConstants.nodata,
                                  scale: 8,
                                  color: AppColors.primary,
                                ),
                              ),
                              height4SizedBox,
                              Center(
                                child: Text(
                                  StringConstants.noPlansYetText,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                  : Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 50),
                          separatorBuilder: (BuildContext context, int index) {
                            return height15SizedBox;
                          },
                          itemCount: accountController.membershipList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            accountController.selectedMembershipPlanId.value =
                                accountController
                                    .membershipList[index].membershipPlanId!;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  accountController.selectedIndex = index;
                                });
                                accountController
                                        .selectedMembershipPlanId.value =
                                    accountController.membershipList[index]
                                        .membershipPlanId!;
                                debugPrint(accountController
                                    .selectedMembershipPlanId.value);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                ),
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15, bottom: 15),
                                color: AppColors.primarylight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${accountController.membershipList[index].planName!.toUpperCase()} PLAN",
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    height8SizedBox,
                                    Text(
                                      accountController.membershipList[index]
                                          .planDescription!,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    height15SizedBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              accountController
                                                  .membershipList[index]
                                                  .selectedPlan = "plan30";
                                              debugPrint(index.toString());
                                              debugPrint(accountController
                                                  .membershipList[index]
                                                  .selectedPlan);
                                              setState(() {});
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      accountController
                                                                  .membershipList[
                                                                      index]
                                                                  .selectedPlan ==
                                                              "plan30"
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    const Text("Monthly Plan",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                Text(
                                                    "\$${accountController.membershipList[index].plan30Charge!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              accountController
                                                  .membershipList[index]
                                                  .selectedPlan = "plan90";
                                              debugPrint(index.toString());
                                              debugPrint(accountController
                                                  .membershipList[index]
                                                  .selectedPlan);
                                              setState(() {});
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      accountController
                                                                  .membershipList[
                                                                      index]
                                                                  .selectedPlan ==
                                                              "plan90"
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    const Text("Quaterly Plan",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                Text(
                                                    "\$${accountController.membershipList[index].plan90Charge!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height20SizedBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              accountController
                                                  .membershipList[index]
                                                  .selectedPlan = "plan180";
                                              debugPrint(index.toString());
                                              debugPrint(accountController
                                                  .membershipList[index]
                                                  .selectedPlan);
                                              setState(() {});
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      accountController
                                                                  .membershipList[
                                                                      index]
                                                                  .selectedPlan ==
                                                              "plan180"
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    const Text("Half Yearly",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                Text(
                                                    "\$${accountController.membershipList[index].plan180Charge!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              accountController
                                                  .membershipList[index]
                                                  .selectedPlan = "plan365";
                                              debugPrint(index.toString());
                                              debugPrint(accountController
                                                  .membershipList[index]
                                                  .selectedPlan);
                                              setState(() {});
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      accountController
                                                                  .membershipList[
                                                                      index]
                                                                  .selectedPlan ==
                                                              "plan365"
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    const Text("Yearly Plan   ",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                Text(
                                                    "\$${accountController.membershipList[index].plan365Charge!.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height10SizedBox,
                                    Center(
                                      child: CustomButton(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primary
                                          ],
                                        ),
                                        onTap: () async {
                                          Utility.showConfirmAlertMessage(
                                              AlertStringConstants
                                                  .areYouSurePlanText,
                                              cancelText:
                                                  StringConstants.noText,
                                              okay: StringConstants.yesText,
                                              okayTap: () {
                                            accountController
                                                .apiCreateMembershipPlan(
                                                    index: index,
                                                    membershipPlanId:
                                                        accountController
                                                            .membershipList[
                                                                index]
                                                            .membershipPlanId!,
                                                    planDays: accountController
                                                        .membershipList[index]
                                                        .selectedPlan!);
                                          });
                                        },
                                        height: 50,
                                        width: 170,
                                        fontSize: 16,
                                        textColor: AppColors.white,
                                        text: StringConstants
                                            .confirmSelectionText,
                                        borderRadius: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
            ])),
      ),
    );
  }
}
