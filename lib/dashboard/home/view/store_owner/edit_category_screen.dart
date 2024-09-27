import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_category_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> with GlobalVarMixin {
  AddNewCategoryController addNewCategoryController =
      Get.put(AddNewCategoryController());

  @override
  initState() {
    super.initState();
    addNewCategoryController.storeId.value = Get.parameters["storeId"] ?? "";
    addNewCategoryController.categoryId.value =
        Get.parameters["categoryId"] ?? "";
    addNewCategoryController.isFeaturedTypeSelected.value =
        Get.parameters["isFeaturedSelectedType"] == "true" ? true : false;

    if (addNewCategoryController.categoryId.value.isNotEmpty) {
      addNewCategoryController.apiGetCategoryDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                Get.delete<AddNewCategoryController>();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Text(
                              StringConstants.updateCategoryText,
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
                      ]),
                ],
              )),
        ));
  }

  GestureDetector buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        child: Form(
          key: addNewCategoryController.updateFormKey,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(StringConstants.uploadCategoryImageText, StringConstants.starText,),

                  height25SizedBox,
                  Obx(
                    () => addNewCategoryController
                            .categoryImageDynamicLinkFromServer.value.isEmpty
                        ? InkWell(
                            onTap: () {
                              addNewCategoryController
                                  .showSelectionDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DottedBorder(
                                  color: AppColors.blackLight,
                                  strokeWidth: 1,
                                  dashPattern: const [4, 4],
                                  child: Container(
                                    width: WidgetConstants.screenWidth * 0.8,
                                    padding: const EdgeInsets.only(
                                        top: 35, bottom: 35),
                                    color: AppColors.primaryLight,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.upload,
                                            scale: 2.5,
                                          ),
                                          height6SizedBox,
                                          Text(StringConstants
                                              .uploadCategoryImageText)
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              addNewCategoryController
                                  .showSelectionDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DottedBorder(
                                  color: AppColors.blackLight,
                                  strokeWidth: 1,
                                  dashPattern: const [4, 4],
                                  child: Container(
                                    width: WidgetConstants.screenWidth * 0.8,
                                    height:
                                        WidgetConstants.screenHeight * 0.2,
                                    color: AppColors.primaryLight,
                                    child: CommonWidgets.cachedNetworkImage(
                                      addNewCategoryController
                                          .categoryImageDynamicLinkFromServer
                                          .value,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => SizedBox(
                                          height:
                                              WidgetConstants.screenHeight *
                                                  0.2,
                                          width:
                                              WidgetConstants.screenHeight *
                                                  0.8,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    ),
                                    /* child: Image.network(
                                          addNewCategoryController
                                              .categoryImageDynamicLinkFromServer
                                              .value,
                                          fit: BoxFit.cover)*/
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  height35SizedBox,
                  buildText(StringConstants.categoryNameText, StringConstants.starText,),

                  CustomInputField(
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    maxLines: null,
                    controller:
                        addNewCategoryController.categoryNameTextController,
                    hintText: StringConstants.enterNameText,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants
                            .pleaseEnterCategoryNameText;
                      }
                      return null;
                    },
                  ),
                  height50SizedBox,
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      if (addNewCategoryController.isLoading.value != true) {
                        addNewCategoryController.isLoading.value = true;
                        addNewCategoryController.validateAndSubmitUpdate();
                      }
                    },
                    height: 50,
                    text: StringConstants.saveAndUpdateCategoryText,
                    borderRadius: 12,
                    fontWeight: FontWeight.w500,
                    iconL: false,
                    fontSize: 16,
                  ),
                ],
              )),
        ),
      ),
    );
  }
  Text buildText(title,starText) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: title,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          TextSpan(
            text:starText,
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.red,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
