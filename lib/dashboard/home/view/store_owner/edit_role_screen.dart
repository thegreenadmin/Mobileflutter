import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditRoleScreen extends StatefulWidget {
  const EditRoleScreen({super.key});

  @override
  State<EditRoleScreen> createState() => _EditRoleScreenState();
}

class _EditRoleScreenState extends State<EditRoleScreen> {
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
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.updateRoleText,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Form(
                key: addNewRoleController.updateFormKey,
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
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterRoleText;
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
                      ),
                      Expanded(
                          child: Obx(
                        () => addNewRoleController.moduleList.isEmpty
                            ? addNewRoleController.isLoading.value == true
                                ? height0SizedBox
                                : Column(
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
                                  )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(bottom: 60, top: 20),
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
                                            side: MaterialStateBorderSide
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
                      )),
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
                    addNewRoleController.isLoading.value = true;
                    addNewRoleController.validateAndSubmitUpdate();
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
    );
  }
}
