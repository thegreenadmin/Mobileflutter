import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/dashboard/home/view/add_new_role_screen.dart';
import 'package:thegreenmall/dashboard/home/view/role_update_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class RoleAndPermissionScreen extends StatefulWidget {
  const RoleAndPermissionScreen({super.key});

  @override
  State<RoleAndPermissionScreen> createState() =>
      _RoleAndPermissionScreenState();
}

class _RoleAndPermissionScreenState extends State<RoleAndPermissionScreen> {
  AddNewRoleController addNewRoleController = Get.put(AddNewRoleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
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
                            StringConstants.roleAndPermissionText,
                            style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/homeMall.png",
                        scale: 4,
                      )
                    ])),
          )),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringConstants.rolesText,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(const AddNewRoleScreen());
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 18.0,
                          ),
                          width2SizedBox,
                          Text(
                            StringConstants.addRoleText,
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                ],
              ),
              height20SizedBox,
              Expanded(
                child: Obx(() => ListView.builder(
                    itemCount: addNewRoleController.storeRoleList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: const BoxDecoration(
                              color: AppColors.greylight,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                addNewRoleController
                                        .storeRoleList[index].roleName ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              height4SizedBox,
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      addNewRoleController.roleId.value =
                                          addNewRoleController
                                              .storeRoleList[index].roleId
                                              .toString();
                                      addNewRoleController.apiDeleteRole();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/deleteicon.png",
                                        scale: 2.5,
                                      ),
                                    ),
                                  ),
                                  width12SizedBox,
                                  InkWell(
                                    onTap: () async {
                                      addNewRoleController.roleId.value =
                                          addNewRoleController
                                              .storeRoleList[index].roleId
                                              .toString();
                                      await addNewRoleController
                                          .apiGetStoreRoleDetail();
                                      Get.to(const RoleUpdateScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/pencil.png",
                                        scale: 2.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
              ),
            ],
          )),
    );
  }
}
