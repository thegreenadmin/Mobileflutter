import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class AccountIdScreen extends StatefulWidget {
  const AccountIdScreen({super.key});

  @override
  State<AccountIdScreen> createState() => _AccountIdScreenState();
}

class _AccountIdScreenState extends State<AccountIdScreen> with GlobalVarMixin{
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
                                    Get.back(id: pageIdApp.value);
                                    //Get.back(id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.black,
                                    size: 24.0,
                                  ),
                                ),
                                width10SizedBox,
                                Text(
                                  StringConstants.accountIdText,
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
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.greyMediumLight,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstants.userAccount,
                          scale: 3,
                        ),
                        width15SizedBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    "${accountController.firstName!.value} ${accountController.lastName!.value}",
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  )),
                          Text(
                                    "${StringConstants.accountIdText}:",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: AppColors.blackLight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                              Obx(() => Text(
                                    "#${accountController.uuId!.value}",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: AppColors.blackLight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
