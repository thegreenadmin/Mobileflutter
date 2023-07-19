import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/home/view/account/select_membership_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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
                            Get.back(id: accountController.pageId.value);
                            //Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
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
                          StringConstants.activeMembershipsText,
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image.asset(
                                                      ImageConstants.membership,
                                                      color: AppColors.primary,
                                                      scale: 20,
                                                    ),
                                                    width12SizedBox,
                                                    Text(
                                                      "${accountController.activeMembershipList[index].membershipPlan!.planName.toString().toUpperCase()} PLAN",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.primary,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                SizedBox(
                                                  width: WidgetConstants
                                                          .screenWidth *
                                                      0.7,
                                                  child: Text(
                                                    accountController
                                                        .activeMembershipList[
                                                            index]
                                                        .membershipPlan!
                                                        .planDescription
                                                        .toString(),
                                                    maxLines: 5,
                                                    style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                height10SizedBox,
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Amount: ",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "\$${accountController.activeMembershipList[index].membershipCharge!.toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                height10SizedBox,
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Status: ",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${accountController.activeMembershipList[index].status!.capitalizeFirst} till ${DateFormat('MM-dd-yyyy').format(DateTime.parse(accountController.activeMembershipList[index].expiredAt.toString()))}",
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                height10SizedBox,
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
                // SharedPreferenceStorage.setData("context", context);
                // Navigator.of(context)
                //     .push(MaterialPageRoute(
                //       builder: (_) => const SelectMembershipPlan(),
                //     ))
                Get.to(() => const SelectMembershipPlan(), id: pageIdApp.value)!
                    .then((value) =>
                        accountController.apiGetActiveMembershipList());
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
