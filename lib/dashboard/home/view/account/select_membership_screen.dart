import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                                                      .selectedPlan =
                                                  StringConstants.plan30Text;
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
                                                              StringConstants
                                                                  .plan30Text
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    Text(
                                                        StringConstants
                                                            .monthlyPlanText,
                                                        style: const TextStyle(
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
                                                      .selectedPlan =
                                                  StringConstants.plan90Text;
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
                                                              StringConstants
                                                                  .plan90Text
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    Text(
                                                        StringConstants
                                                            .quaterlyPlanText,
                                                        style: const TextStyle(
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
                                                      .selectedPlan =
                                                  StringConstants.plan180Text;
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
                                                              StringConstants
                                                                  .plan180Text
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    Text(
                                                        StringConstants
                                                            .halfYearlyText,
                                                        style: const TextStyle(
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
                                                      .selectedPlan =
                                                  StringConstants.plan365Text;
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
                                                              StringConstants
                                                                  .plan365Text
                                                          ? ImageConstants.radio
                                                          : ImageConstants
                                                              .radioUnfill,
                                                      scale: 30,
                                                    ),
                                                    width10SizedBox,
                                                    Text(
                                                        StringConstants
                                                            .yearlyPlanText,
                                                        style: const TextStyle(
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
                                        onTap: () {
                                          if (accountController
                                              .membershipList[index]
                                              .selectedPlan!
                                              .isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select plan first",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                backgroundColor:
                                                    AppColors.primary,
                                                textColor: AppColors.white,
                                                fontSize: 14.0);
                                          } else {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyAlertDialog(index);
                                              },
                                            );
                                          }
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

  RxInt selectIndex = 1.obs;
}

class MyAlertDialog extends StatefulWidget {
  final int activemenbershipIndex;

  const MyAlertDialog(
    this.activemenbershipIndex, {
    Key? key,
  }) : super(key: key);
  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final AccountController accountController = Get.put(AccountController());
  RxInt selectIndex = (-1).obs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select store for which you want to buy this plan.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accountController.storeList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectIndex.value = index;
                      accountController.selectedStoreId!.value =
                          accountController.storeList[index].storeId.toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 10.0),
                      color: selectIndex.value == index
                          ? AppColors.primary
                          : AppColors.primarylight,
                      child: Text(
                        accountController.storeList[index].storeName ?? "",
                        style: TextStyle(
                          color: selectIndex.value != index
                              ? AppColors.primary
                              : AppColors.primarylight,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          height15SizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                onTap: () {
                  accountController.selectedStoreId!.value = "";
                  Get.back();
                },
                height: 50,
                width: 120,
                fontSize: 16,
                textColor: AppColors.white,
                text: StringConstants.cancelText,
                borderRadius: 12,
                fontWeight: FontWeight.w600,
              ),
              width5SizedBox,
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                onTap: () {
                  if (accountController.selectedStoreId!.value.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please select store first",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                        fontSize: 14.0);
                  } else {
                    Utility.showConfirmAlertMessage(
                        AlertStringConstants.areYouSurePlanText,
                        cancelText: StringConstants.noText,
                        okay: StringConstants.yesText, okayTap: () {
                      Get.back();
                      accountController.apiCreateMembershipPlan(
                          index: widget.activemenbershipIndex,
                          membershipPlanId: accountController
                              .membershipList[widget.activemenbershipIndex]
                              .membershipPlanId!,
                          planDays: accountController
                              .membershipList[widget.activemenbershipIndex]
                              .selectedPlan!);
                    });
                  }
                },
                height: 50,
                width: 120,
                fontSize: 16,
                textColor: AppColors.white,
                text: StringConstants.yesText,
                borderRadius: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
