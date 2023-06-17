import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_role_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
class AddNewRoleScreen extends StatefulWidget {
  const AddNewRoleScreen({super.key});

  @override
  State<AddNewRoleScreen> createState() => _AddNewRoleScreenState();
}

class _AddNewRoleScreenState extends State<AddNewRoleScreen> {
  AddNewRoleController addNewRoleController = Get.put(AddNewRoleController());
  final selectedIndexes = <int>[];
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
                             Get.back(id:addNewRoleController.pageId.value);
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
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Form(
                key: addNewRoleController.formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height20SizedBox,
                      Text(
                        StringConstants.roleNameText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                       TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(200),
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: addNewRoleController.roleNameTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants.pleaseEnterRoleText;
                            }
                            return null;
                          },textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            errorMaxLines: 3,
                            hintText: StringConstants.enterRoleText,
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 14),
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                            ),
                          )),
                      height20SizedBox,
                      Text(
                        StringConstants.permissionText,
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
                                          StringConstants.noPermissionsFoundText,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 60),
                                itemCount: addNewRoleController.moduleList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int i) {
                                  return ListView.builder(
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
                                                  activeColor: AppColors.primary,
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
                  addNewRoleController.validateAndSubmit(context);
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
