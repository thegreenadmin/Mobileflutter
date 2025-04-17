import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class AddNewRoleScreen extends StatefulWidget {
  final bool isEdit;
  final String? roleId;
  const AddNewRoleScreen({super.key, this.isEdit = false, this.roleId});

  @override
  State<AddNewRoleScreen> createState() => _AddNewRoleScreenState();
}

class _AddNewRoleScreenState extends State<AddNewRoleScreen> with GlobalVarMixin{
  AddNewRoleController addNewRoleController = Get.put(AddNewRoleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            buildAppBar(),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Form(
                        key: addNewRoleController.formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height20SizedBox,
                              Text(
                                StringConstants.roleText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              height20SizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.roleNameText,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    TextSpan(
                                      text: StringConstants.starText,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              height4SizedBox,
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(200),
                                ],
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                maxLines: null,
                                errorMaxLines: 3,
                                controller: addNewRoleController.roleNameTextController,
                                hintText: StringConstants.enterRoleText,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  final trimmedValue = value?.trim() ?? "";

                                  if (trimmedValue.isEmpty) {
                                    return AlertStringConstants.pleaseEnterRoleText;
                                  }

                                  // Normalize input: lowercase and remove all spaces
                                  final normalizedInput = trimmedValue.toLowerCase().replaceAll(' ', '');

                                  // Set of restricted roles (normalized: lowercase + no spaces)
                                  final restrictedRoles = {
                                    'storeworker',
                                    'worker',
                                    'manager',
                                    'storemanager',
                                  };

                                  if (restrictedRoles.contains(normalizedInput)) {
                                    return '$trimmedValue ${AlertStringConstants.thisRoleIsNotAvailableText}';
                                  }

                                  return null;
                                },
                              ),
                              height20SizedBox,
                              Text(
                                StringConstants.permissionsText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ), height20SizedBox,
                              widget.isEdit
                                  ? _buildEditPermissionsList()
                                  : _buildAddPermissionsList(),
                              // _buildAddPermissionsList(),
                            ]),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 60,
                      right: 60,
                      child: CustomButton(
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        onTap: () {
                          if (addNewRoleController.isLoading.value != true) {
                           if(widget.isEdit ){
                             addNewRoleController.validateAndSubmit(true);
                           }else{
                             addNewRoleController.validateAndSubmit(false);
                           }

                          }
                        },
                        height: 50,
                        text: StringConstants.saveText,
                        textColor: AppColors.white,
                        borderRadius: 14,
                        fontWeight: FontWeight.w500,
                        iconL: false,
                        iconR: false,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
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


  Expanded _buildEditPermissionsList() {
    return Expanded(
        child: Obx(
              () => addNewRoleController.moduleList.isEmpty
              ? _buildNoDataView()
              : ListView.builder(
              padding:
              const EdgeInsets.only(bottom: 60, top: 0),
              shrinkWrap: true,
              itemCount: addNewRoleController
                  .permissionListMerged.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Obx(
                          () => SizedBox(
                        height: 20,
                        width: 30,
                        child: Checkbox(
                          side: WidgetStateBorderSide
                              .resolveWith(
                                (states) => BorderSide(
                                width: 1.0,
                                color: AppColors.primary
                                    .withOpacity(0.5)),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(6.0)),
                          activeColor: AppColors.primary,
                          value: addNewRoleController
                              .permissionListMerged[index]
                              .isSelected,
                          onChanged: (bool? value) {
                            addNewRoleController
                                .permissionListMerged[index]
                                .isSelected = value;
                            addNewRoleController
                                .permissionListMerged[index]
                                .status = (value ??
                                false
                                ? "active"
                                : "deleted");
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    width10SizedBox,
                    Text(addNewRoleController
                        .permissionListMerged[index]
                        .controller!
                        .controllerName ??
                        "")
                  ]),
                );
              }),
        ));
  }

  Expanded _buildAddPermissionsList() {
    return Expanded(
        child: Obx(
              () => addNewRoleController.moduleList.isEmpty
                  ? _buildNoDataView()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.only(bottom: 60, top: 0),
                      itemCount:
                          addNewRoleController.moduleList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: addNewRoleController
                                .moduleList[i].controllers!.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Obx(
                                    () => SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: Checkbox(
                                        side: MaterialStateBorderSide
                                            .resolveWith(
                                          (states) => BorderSide(
                                              width: 1.0,
                                              color: AppColors.primary
                                                  .withOpacity(0.5)),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    6.0)),
                                        activeColor:
                                            AppColors.primary,
                                        value: addNewRoleController
                                            .moduleList[i]
                                            .controllers![index]
                                            .isSelected,
                                        onChanged: (bool? value) {
                                          if (addNewRoleController
                                                  .moduleList[i]
                                                  .controllers![index]
                                                  .isSelected ==
                                              false) {
                                            addNewRoleController
                                                .controllerIdsList
                                                .add({
                                              "controller_id":
                                                  addNewRoleController
                                                      .moduleList[i]
                                                      .controllers![
                                                          index]
                                                      .controllerId
                                                      .toString()
                                            });
                                            addNewRoleController
                                                .moduleList[i]
                                                .controllers![index]
                                                .isSelected = true;
                                          } else {
                                            addNewRoleController
                                                .controllerIdsList
                                                .removeWhere((item) =>
                                                    item[
                                                        'controller_id'] ==
                                                    addNewRoleController
                                                        .moduleList[i]
                                                        .controllers![
                                                            index]
                                                        .controllerId);

                                            addNewRoleController
                                                .moduleList[i]
                                                .controllers![index]
                                                .isSelected = false;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  width10SizedBox,
                                  Text(addNewRoleController
                                      .moduleList[i]
                                      .controllers![index]
                                      .controllerName
                                      .toString())
                                ]),
                              );
                            });
                      }),
            ));
  }

  Column _buildNoDataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          CrossAxisAlignment.center,
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
            StringConstants
                .noPermissionsFoundText,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16),
          ),
        ),
      ],
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
          child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20, top: 50, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(10),
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
                        Text( widget.isEdit ? StringConstants.updateRoleText:
                          StringConstants.addRoleText,
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
        ));
  }
}
