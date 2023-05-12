import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';

import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    accountController.membershipList.isEmpty
                        ? accountController.isLoading.value == true
                            ? height0SizedBox
                            : Column(
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
                                      StringConstants.noActiveMembershipText,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                        : Expanded(
                            child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return height15SizedBox;
                                },
                                itemCount:
                                    accountController.membershipList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  accountController
                                          .selectedMembershipPlanId.value =
                                      accountController.membershipList[index]
                                          .membershipPlanId!;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        accountController.selectedIndex = index;
                                      });
                                      accountController
                                              .selectedMembershipPlanId.value =
                                          accountController
                                              .membershipList[index]
                                              .membershipPlanId!;
                                      debugPrint(accountController
                                          .selectedMembershipPlanId.value);

                                      accountController
                                          .noOfDaysForMembershipDailogue(
                                              context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 4,
                                        right: 4,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 15,
                                          bottom: 15),
                                      color: accountController.selectedIndex ==
                                              index
                                          ? AppColors.primary
                                          : AppColors.primarylight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Plan Type: ${accountController.membershipList[index].planType}",
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          height20SizedBox,
                                          Row(
                                            children: [
                                              Container(
                                                height: 6.0,
                                                width: 6.0,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              width10SizedBox,
                                              const Text("Plan Days",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                          height4SizedBox,
                                          Text(
                                              accountController
                                                          .membershipList[index]
                                                          .planDays! >
                                                      1
                                                  ? "${accountController.membershipList[index].planDays} Days"
                                                  : "${accountController.membershipList[index].planDays} Day",
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          height20SizedBox,
                                          Row(
                                            children: [
                                              Container(
                                                height: 6.0,
                                                width: 6.0,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              width10SizedBox,
                                              const Text("Plan Charges",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                          height4SizedBox,
                                          Text(
                                              "\$" +
                                                  accountController
                                                      .membershipList[index]
                                                      .planCharge
                                                      .toString(),
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ])),
        ));
  }
}
