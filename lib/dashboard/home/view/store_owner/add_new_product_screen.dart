import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final ManageStoreController manageStoreController =
      Get.put(ManageStoreController());

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
                              Navigator.of(context).pop();
                              // Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          SizedBox(
                            width: 250,
                            child: Text(
                              manageStoreController.categoryName.value,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            ),
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
        child: SingleChildScrollView(
          child: Form(
            key: manageStoreController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => manageStoreController.imageFileList!.isEmpty
                        ? height0SizedBox
                        : Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        StringConstants.uploadProductPhotosText,
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
                          )),
                    Obx(
                      () => manageStoreController.imageFileList!.isEmpty
                          ? height0SizedBox
                          : SizedBox(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return width8SizedBox;
                                    },
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: manageStoreController
                                        .imageFileList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Image.file(
                                        File(manageStoreController
                                            .imageFileList![index].path),
                                        fit: BoxFit.cover,
                                      );
                                    }),
                              ),
                            ),
                    ),
                    height15SizedBox,
                    Obx(
                      () => manageStoreController.imageFileList!.isEmpty
                          ? height0SizedBox
                          : InkWell(
                              onTap: () {
                                manageStoreController.selectImages(true);
                              },
                              child: Image.asset(
                                ImageConstants.uploadbutton,
                                scale: 3,
                              ),
                            ),
                    ),
                    Obx(
                      () => manageStoreController.imageFileList!.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: () {
                                      manageStoreController.selectImages(true);
                                    },
                                    child: Row(
                                      children: [
                                        DottedBorder(
                                          color: AppColors.blacklight,
                                          strokeWidth: 1,
                                          dashPattern: const [4, 4],
                                          child: Container(
                                            width: WidgetConstants.screenWidth *
                                                0.3,
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 30),
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
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                width20SizedBox,
                                Flexible(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      height10SizedBox,
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: StringConstants
                                                    .uploadProductPhotosText,
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
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
                                      height10SizedBox,
                                      Text(
                                          StringConstants
                                              .theImageMustBeAtLeastText,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                      height10SizedBox,
                                    ],
                                  ),
                                )
                              ],
                            )
                          : height0SizedBox,
                    ),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.productNameText,
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
                    height4SizedBox,
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
                            manageStoreController.productNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterProductNameText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: StringConstants.enterProductNameText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.categoriesText,
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
                    height10SizedBox,
                    Obx(
                      () => manageStoreController.categoriesList.isEmpty
                          ? height0SizedBox
                          : SizedBox(
                              width: Get.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        for (var i = 0;
                                            i <
                                                manageStoreController
                                                    .categoriesList.length;
                                            i++)
                                          InkWell(
                                            onTap: () {
                                              if (manageStoreController
                                                      .categoriesList[i]
                                                      .isSelected ==
                                                  true) {
                                                for (var item
                                                    in manageStoreController
                                                        .selectedCategories) {
                                                  if (item['category_id'] ==
                                                      manageStoreController
                                                          .categoriesList[i]
                                                          .categoryId) {
                                                    item['status'] = "deleted";
                                                  }
                                                }
                                                manageStoreController
                                                    .categoriesList[i]
                                                    .isSelected = false;
                                              } else {
                                                for (var item
                                                    in manageStoreController
                                                        .selectedCategories) {
                                                  if (item['category_id'] ==
                                                      manageStoreController
                                                          .categoriesList[i]
                                                          .categoryId) {
                                                    item['status'] = "active";
                                                  }
                                                }
                                                manageStoreController
                                                    .categoriesList[i]
                                                    .isSelected = true;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10,
                                                    bottom: 10),
                                                margin: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                  color: manageStoreController
                                                              .categoriesList[i]
                                                              .isSelected ==
                                                          true
                                                      ? AppColors.primary
                                                      : AppColors.primarylight,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                child: Text(
                                                  manageStoreController
                                                          .categoriesList[i]
                                                          .categoryName ??
                                                      "",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: manageStoreController
                                                                .categoriesList[
                                                                    i]
                                                                .isSelected ==
                                                            true
                                                        ? AppColors.primarylight
                                                        : AppColors.primary,
                                                  ),
                                                )),
                                          )
                                      ],
                                    ),
                                  ]),
                            ),
                    ),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.quantityUnitText,
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
                    height4SizedBox,
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              if (v == null || v.trim() == '') {
                                return AlertStringConstants
                                    .pleaseSelectQuantityUnitText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.grey,
                                  width: 1.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
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
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            hint: Text(
                              StringConstants.selectTypeText,
                              style: const TextStyle(
                                  color: AppColors.grey, fontSize: 14),
                            ),
                            items: manageStoreController.quantityTypeList
                                .map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value.quantityTypeId,
                                child: Text(
                                  value.quantityTypeName,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              manageStoreController.quantityValue.value =
                                  value.toString();
                            },
                          ),
                        ),
                        width15SizedBox,
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              controller:
                                  manageStoreController.quantityTextController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseEnterQuantityText;
                                } else if (double.parse(value) == 0.0) {
                                  return AlertStringConstants
                                      .invalidQuantityText;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: StringConstants.enterQuantityText,
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
                        ),
                      ],
                    ),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.pricePerUnitText,
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
                    height4SizedBox,
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
                            manageStoreController.pricePerUnitTextController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterPriceText;
                          } else if (double.parse(value) == 0.0) {
                            return AlertStringConstants.invalidAmountText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.enterPriceText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.shortDescriptionText,
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
                    height4SizedBox,
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
                        controller: manageStoreController
                            .shortDescriptionTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterShortDescriptionText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: StringConstants.shortDescriptionText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.contentsAndStrainsText,
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
                    height4SizedBox,
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
                        controller: manageStoreController
                            .contentsAndStrainsTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterContentAndStrainText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: StringConstants.contentsAndStrainsText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  StringConstants.additionalLinksToResearchText,
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
                    height4SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r"\s"),
                              allow: false),
                          LengthLimitingTextInputFormatter(25),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            manageStoreController.additionalLinkTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterLinkText;
                          } else if (!GetUtils.isURL(manageStoreController
                              .additionalLinkTextController.text
                              .trim())) {
                            return AlertStringConstants
                                .pleaseEnterValidLinkText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText:
                              StringConstants.additionalLinksToResearchText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.discountsOrOffersText,
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
                    height4SizedBox,
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: DropdownButtonFormField<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (v) {
                            //   if (v==null || v?.trim()=='') {
                            //     return AlertStringConstants.pleaseSelectDiscountTypeText;
                            //   }
                            //   return null;
                            // },
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.grey,
                                  width: 1.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
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
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            isExpanded: true,
                            hint: Text(
                              StringConstants.selectTypeText,
                              style: const TextStyle(
                                  color: AppColors.grey, fontSize: 14),
                            ),
                            items: <String>["Percentage", "Amount"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              manageStoreController.discountType.value =
                                  v.toString();
                            },
                          ),
                        ),
                        width15SizedBox,
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                              ],
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              controller: manageStoreController
                                  .discountOrOfferTextController,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseEnterAmountText;
                                } else if (double.parse(value) == 0.0) {
                                  return AlertStringConstants.invalidAmountText;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: StringConstants.discountsOrOffersText,
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
                        ),
                      ],
                    ),
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.featuredProductText,
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
                    height4SizedBox,
                    DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) {
                        if (v == null || v.trim() == '') {
                          return AlertStringConstants.pleaseSelectAnyOneText;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorMaxLines: 3,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                        border: UnderlineInputBorder(
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
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                      ),
                      isExpanded: true,
                      hint: Text(
                        StringConstants.selectTypeText,
                        style: const TextStyle(
                            color: AppColors.grey, fontSize: 14),
                      ),
                      items: <String>["Yes", "No"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") {
                          manageStoreController.isFeatured.value = true;
                        } else {
                          manageStoreController.isFeatured.value = false;
                        }
                      },
                    ),
                    height20SizedBox,
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "${StringConstants.lengthText}(in)",
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller:
                                    manageStoreController.lengthTextController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterLengthText;
                                  } else if (double.parse(value) == 0.0) {
                                    return AlertStringConstants
                                        .invalidInputText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: StringConstants.lengthText,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        width12SizedBox,
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "${StringConstants.breadthText}(in)",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  controller: manageStoreController
                                      .breadthTextController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .pleaseEnterBreadthText;
                                    } else if (double.parse(value) == 0.0) {
                                      return AlertStringConstants
                                          .invalidInputText;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: StringConstants.breadthText,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    height20SizedBox,
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "${StringConstants.heightText}(in)",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  controller: manageStoreController
                                      .heightTextController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .pleaseEnterHeightText;
                                    } else if (double.parse(value) == 0.0) {
                                      return AlertStringConstants
                                          .invalidInputText;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: StringConstants.heightText,
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
                            ],
                          ),
                        ),
                        width12SizedBox,
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "${StringConstants.weightText}(oz)",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  controller: manageStoreController
                                      .weightTextController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .pleaseEnterWeightText;
                                    } else if (double.parse(value) == 0.0) {
                                      return AlertStringConstants
                                          .invalidInputText;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: StringConstants.weightText,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    height20SizedBox,
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            StringConstants.returnAvailableText,
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
                              DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  if (v == null || v.trim() == '') {
                                    return AlertStringConstants
                                        .pleaseSelectAnyOneText;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
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
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                hint: Text(
                                  StringConstants.selectTypeText,
                                  style: const TextStyle(
                                      color: AppColors.grey, fontSize: 14),
                                ),
                                items:
                                    <String>["Yes", "No"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  if (v == "Yes") {
                                    manageStoreController
                                        .isProductReturnable.value = true;
                                  } else {
                                    manageStoreController
                                        .isProductReturnable.value = false;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        width12SizedBox,
                        Obx(() => manageStoreController
                                    .isProductReturnable.value ==
                                true
                            ? Flexible(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringConstants.daysText,
                                      style: TextStyle(
                                          color: AppColors.blacklight,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textInputAction: TextInputAction.next,
                                        autofocus: false,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(100),
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        controller: manageStoreController
                                            .daysTextController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return AlertStringConstants
                                                .pleaseEnterValidDaysText;
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: StringConstants.daysText,
                                          hintStyle: const TextStyle(
                                              color: AppColors.grey,
                                              fontSize: 14),
                                          fillColor: Colors.white,
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.primary,
                                              width: 1.0,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.primary,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.primary,
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            : height0SizedBox)
                      ],
                    ),
                    height20SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.enabledText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blacklight,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => FlutterSwitch(
                              height: 28,
                              width: 50,
                              value: manageStoreController.isEnabled.value,
                              activeToggleColor: AppColors.primary,
                              inactiveToggleColor: AppColors.grey,
                              activeSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              activeColor: AppColors.greymediumlight,
                              inactiveColor: AppColors.greymediumlight,
                              onToggle: (val) {
                                manageStoreController.isEnabled.value = val;
                              },
                            )),
                      ],
                    ),
                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        manageStoreController.selectedCategories.clear();
                        for (int i = 0;
                            i < manageStoreController.categoriesList.length;
                            i++) {
                          if (manageStoreController
                                  .categoriesList[i].isSelected ??
                              false) {
                            manageStoreController.selectedCategories.add({
                              "category_id": manageStoreController
                                  .categoriesList[i].categoryId
                            });
                          }
                        }
                        manageStoreController.validateAndSubmit(context);
                      },
                      height: 50,
                      text: StringConstants.saveText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconL: false,
                      fontSize: 16,
                    ),
                    height40SizedBox,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
