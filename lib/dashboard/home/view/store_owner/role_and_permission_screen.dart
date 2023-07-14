import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_new_role_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_role_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

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
                              Get.back(id: pageIdApp.value);
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
                            StringConstants.rolesAndPermissionText,
                            style: const TextStyle(
                                fontSize: 22,
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
                        addNewRoleController.roleNameTextController.clear();
                        addNewRoleController.controllerIdsList.clear();
                        for (int i = 0;
                            i < addNewRoleController.moduleList.length;
                            i++) {
                          for (int j = 0;
                              j <
                                  addNewRoleController
                                      .moduleList[i].controllers!.length;
                              j++) {
                            addNewRoleController.moduleList[i].controllers![j]
                                .isSelected = false;
                          }
                        }
                        // SharedPreferenceStorage.setData("context", context);
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(
                        //       builder: (_) => const AddNewRoleScreen(),
                        //     ))
                        hasStoreAccess.value && permissionStoreList.isEmpty ||
                                permissionStoreList.any((element) =>
                                    element.storeId ==
                                            addNewRoleController
                                                .storeId.value &&
                                        element.isStoreOwner == true ||
                                    element.storeId ==
                                            addNewRoleController.storeId.value
                                                .toString() &&
                                        element.controllers!.any((ele) =>
                                            ele.controllerKey ==
                                            PermissionKey.assignDesignationUser
                                                .statusName))
                            ? Get.to(const AddNewRoleScreen(),
                                    id: pageIdApp.value)!
                                .then((value) => addNewRoleController.apiGetStoreRole())
                            : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
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
                            StringConstants.addNewRoleText,
                            style: const TextStyle(
                                fontSize: 15.0,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                ],
              ),
              height20SizedBox,
              Expanded(
                child: Obx(() => addNewRoleController.storeRoleList.isEmpty
                    ? addNewRoleController.isLoading.value == true
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
                                  StringConstants.noRolesFoundText,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )
                    : ListView.builder(
                        itemCount: addNewRoleController.storeRoleList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
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
                                      fontSize: 16.0,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                height4SizedBox,
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        hasStoreAccess.value && permissionStoreList.isEmpty ||
                                                permissionStoreList.any((element) =>
                                                    element.storeId == addNewRoleController.storeId.value && element.isStoreOwner == true ||
                                                    element.storeId ==
                                                            addNewRoleController
                                                                .storeId.value
                                                                .toString() &&
                                                        element.controllers!.any((ele) =>
                                                            ele.controllerKey ==
                                                            PermissionKey
                                                                .editDesignation
                                                                .statusName))
                                            ? Utility.showConfirmAlertMessage(
                                                AlertStringConstants.areYouSureText,
                                                okay: StringConstants.deleteText, okayTap: () {
                                                // Navigator.pop(Get.context!);
                                                addNewRoleController
                                                        .roleId.value =
                                                    addNewRoleController
                                                        .storeRoleList[index]
                                                        .roleId
                                                        .toString();
                                                addNewRoleController
                                                    .apiDeleteRole(context);
                                              })
                                            : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);

                                        // addNewRoleController.roleId.value =
                                        //     addNewRoleController
                                        //         .storeRoleList[index].roleId
                                        //         .toString();
                                        // addNewRoleController.apiDeleteRole();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Image.asset(
                                          ImageConstants.deleteicon,
                                          scale: 2.8,
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
                                        // SharedPreferenceStorage.setData(
                                        //     "context", context);
                                        // await Navigator.of(context)
                                        //     .push(MaterialPageRoute(
                                        //       builder: (_) =>
                                        //           const EditRoleScreen(),
                                        //     ))
                                        hasStoreAccess.value && permissionStoreList.isEmpty ||
                                                permissionStoreList.any((element) =>
                                                    element.storeId == addNewRoleController.storeId.value &&
                                                        element.isStoreOwner ==
                                                            true ||
                                                    element.storeId ==
                                                            addNewRoleController
                                                                .storeId.value
                                                                .toString() &&
                                                        element.controllers!.any((ele) =>
                                                            ele.controllerKey ==
                                                            PermissionKey
                                                                .editDesignation
                                                                .statusName))
                                            ? Get.to(const EditRoleScreen(), id: pageIdApp.value)!
                                                .then((value) => addNewRoleController.apiGetStoreRole())
                                            : Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Image.asset(
                                          ImageConstants.pencil,
                                          scale: 2.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })),
              ),
            ],
          )),
    );
  }
}
