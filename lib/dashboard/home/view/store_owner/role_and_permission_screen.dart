import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/add_edit_role.dart';
import 'package:thegreenmall/utils/utils.dart';

class RoleAndPermissionScreen extends StatefulWidget {
  final String? storeId;
  final String? storeName;
  const RoleAndPermissionScreen({super.key, this.storeId, this.storeName});

  @override
  State<RoleAndPermissionScreen> createState() =>
      _RoleAndPermissionScreenState();
}

class _RoleAndPermissionScreenState extends State<RoleAndPermissionScreen> with GlobalVarMixin{
  AddNewRoleController addNewRoleController = Get.put(AddNewRoleController());



  @override
  void initState() {
    addNewRoleController.storeId.value = widget.storeId??"";
    addNewRoleController.storeName.value = widget.storeName??"";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

   buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Container(
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
                                    ? Get.to(() => const AddNewRoleScreen(), id: pageIdApp.value)!
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
                            padding: EdgeInsets.zero,
                                itemCount: addNewRoleController.storeRoleList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 20),
                                    decoration: const BoxDecoration(
                                        color: AppColors.greyLight,
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
                                                        addNewRoleController
                                                                .roleId.value =
                                                            addNewRoleController
                                                                .storeRoleList[index]
                                                                .roleId
                                                                .toString();
                                                        addNewRoleController
                                                            .apiDeleteRole();
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
                                                  child: addNewRoleController
                                                                  .storeRoleList[index]
                                                                  .roleName ==
                                                              "Store Manager" ||
                                                          addNewRoleController
                                                                  .storeRoleList[index]
                                                                  .roleName ==
                                                              "Store Worker"
                                                      ? height0SizedBox
                                                      : Image.asset(
                                                          ImageConstants.deleteicon,
                                                          scale: 2.8,
                                                        )),
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
                                                    ? Get.to(() => const AddNewRoleScreen(), id: pageIdApp.value)!
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
            ),
          ],
        ),
        //LOADING OVERLAY
        Obx(() {
          return addNewRoleController.isLoading.value
              ? Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),)
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 20, top: 50, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImageConstants.homeMall,
                          scale: 4,
                        ),
                        width10SizedBox,
                        IconButton(
                          padding: EdgeInsets.all(5),
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
                          StringConstants.rolesAndPermissionText,
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ])),
        ));
  }
}
