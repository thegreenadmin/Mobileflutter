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

class _EditCategoryScreenState extends State<EditCategoryScreen> {
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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
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
          )),
      body: GestureDetector(
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.updateCategoryImageText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
                                    color: AppColors.blacklight,
                                    strokeWidth: 1,
                                    dashPattern: const [4, 4],
                                    child: Container(
                                      width: WidgetConstants.screenWidth * 0.8,
                                      padding: const EdgeInsets.only(
                                          top: 35, bottom: 35),
                                      color: AppColors.primarylight,
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
                                    color: AppColors.blacklight,
                                    strokeWidth: 1,
                                    dashPattern: const [4, 4],
                                    child: Container(
                                      width: WidgetConstants.screenWidth * 0.8,
                                      height:
                                          WidgetConstants.screenHeight * 0.2,
                                      color: AppColors.primarylight,
                                      child: CommonWidgets.cachedNetworkImage(
                                          addNewCategoryController
                                              .categoryImageDynamicLinkFromServer
                                              .value,
                                          fit: BoxFit.cover),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.categoryNameText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            addNewCategoryController.categoryNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterCategoryNameText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: StringConstants.enterNameText,
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
      ),
    );
  }
}
