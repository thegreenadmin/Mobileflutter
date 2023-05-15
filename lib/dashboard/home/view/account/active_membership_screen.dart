import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/select_membership_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class ActiveMembershipScreen extends StatefulWidget {
  const ActiveMembershipScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ActiveMembershipScreenState();
  }
}

class ActiveMembershipScreenState extends State<ActiveMembershipScreen> {
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
                          StringConstants.activeMembershipText,
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
      body: Stack(
        children: <Widget>[
          Obx(
            () => Container(
              height: WidgetConstants.screenHeight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: accountController.activeMembershipList.isEmpty
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
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return height15SizedBox;
                      },
                      itemCount: accountController.activeMembershipList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 2,
                            child: ClipPath(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: AppColors.primary,
                                            width: 5))),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 15, bottom: 15),
                                  color: AppColors.primarylight,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Membership Plan Type: ${accountController.activeMembershipList[index].membershipPlan!.planType!.toUpperCase()}",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                height10SizedBox,
                                                Text(
                                                  "Plan charges: \$${accountController.activeMembershipList[index].membershipPlan!.planCharge}",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                height10SizedBox,
                                                accountController
                                                            .activeMembershipList[
                                                                index]
                                                            .membershipPlan!
                                                            .planDays! >
                                                        1
                                                    ? Text(
                                                        "Plan days: ${accountController.activeMembershipList[index].membershipPlan!.planDays}",
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    : Text(
                                                        "Plan day: ${accountController.activeMembershipList[index].membershipPlan!.planDays}",
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ));
                      }),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: CustomButton(
              border: Border.all(
                color: AppColors.primary,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.white, AppColors.white],
              ),
              onTap: () async {
                Get.to(const SelectMembershipPlan())!.then(
                    (value) => accountController.apiGetActiveMembershipList());
              },
              height: 50,
              text: StringConstants.selectMembershipPlanText,
              textColor: AppColors.primary,
              borderRadius: 14,
              fontWeight: FontWeight.w500,
              iconL: false,
              iconR: false,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
