import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                for (var element
                                    in manageStoreController.categoriesList) {
                                  element.isSelected = false;
                                }
                                if (Get.parameters['isFromHome'] == 'true') {
                                  Get.delete<ManageStoreController>();
                                }
                                manageStoreController.imageUrlList.clear();
                                Get.back(id: pageIdApp.value);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: 24.0,
                              ),
                            ),
                            width10SizedBox,
                            Obx(() => SizedBox(
                                  width: 200,
                                  child: Text(
                                    manageStoreController.categoryName.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
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
              key: manageStoreController.updateFormKey,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => manageStoreController.imageFileList!.isEmpty
                            ? height0SizedBox
                            : Text(StringConstants.uploadProductPhotosText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                      ),
                      Obx(
                        () => manageStoreController.imageUrlList.isEmpty ||
                                manageStoreController.imageUrlList.every(
                                    (element) => element.status == "deleted")
                            ? height0SizedBox
                            : SizedBox(
                                height: 100,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: manageStoreController
                                          .imageUrlList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return manageStoreController
                                                    .imageUrlList[index]
                                                    .status ==
                                                "deleted"
                                            ? const SizedBox(
                                                height: 0, width: 0)
                                            : Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: CommonWidgets
                                                        .cachedNetworkImage(
                                                      manageStoreController
                                                          .imageUrlList[index]
                                                          .dynamicImageUrl!,
                                                      fit: BoxFit.cover,
                                                      height: WidgetConstants
                                                              .screenHeight *
                                                          0.1,
                                                      width: WidgetConstants
                                                              .screenHeight *
                                                          0.1,
                                                      placeholder: (context, url) => SizedBox(
                                                          height: WidgetConstants
                                                                  .screenHeight *
                                                              0.1,
                                                          width: WidgetConstants
                                                                  .screenHeight *
                                                              0.1,
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator())),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      manageStoreController
                                                          .imageUrlList[index]
                                                          .status = "deleted";
                                                      setState(() {});
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                          Icons.delete_forever,
                                                          color: AppColors
                                                              .primary),
                                                    ),
                                                  )
                                                ],
                                              );
                                      }),
                                ),
                              ),
                      ),
                      height15SizedBox,
                      Obx(
                        () => manageStoreController.imageUrlList.isEmpty ||
                                manageStoreController.imageUrlList.every(
                                    (element) => element.status == "deleted")
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: InkWell(
                                      onTap: () {
                                        manageStoreController
                                            .selectImages(true);
                                      },
                                      child: Row(
                                        children: [
                                          DottedBorder(
                                            color: AppColors.blacklight,
                                            strokeWidth: 1,
                                            dashPattern: const [4, 4],
                                            child: Container(
                                              width:
                                                  WidgetConstants.screenWidth *
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
                                        Text(
                                            StringConstants
                                                .uploadProductPhotosText,
                                            style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
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
                      Obx(() => manageStoreController
                                      .isSelectedCategory.value ==
                                  false &&
                              manageStoreController.categoriesList.isEmpty
                          ? height0SizedBox
                          : Wrap(
                              children: [
                                for (var i = 0;
                                    i <
                                        manageStoreController
                                            .categoriesList.length;
                                    i++)
                                  InkWell(
                                    onTap: () {
                                      // if (manageStoreController
                                      //         .categoriesList[i].isSelected ==
                                      //     true) {
                                      //   manageStoreController.categoriesList[i]
                                      //       .isSelected = false;
                                      //   for (var item in manageStoreController
                                      //       .selectedCategories) {
                                      //     if (item['category']['category_id'] ==
                                      //         manageStoreController
                                      //             .categoriesList[i]
                                      //             .categoryId) {
                                      //       item['status'] = "deleted";
                                      //       debugPrint(manageStoreController
                                      //           .selectedCategories
                                      //           .toString());
                                      //     }
                                      //   }
                                      // } else {
                                      //   manageStoreController.categoriesList[i]
                                      //       .isSelected = true;
                                      //   for (var item in manageStoreController
                                      //       .selectedCategories) {
                                      //     if (item['category']['category_id'] ==
                                      //         manageStoreController
                                      //             .categoriesList[i]
                                      //             .categoryId) {
                                      //       item['status'] = "active";
                                      //       debugPrint(manageStoreController
                                      //           .selectedCategories
                                      //           .toString());
                                      //     }
                                      //   }
                                      // }
                                      // setState(() {});
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
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          color: manageStoreController
                                                      .categoriesList[i]
                                                      .isSelected ==
                                                  true
                                              ? AppColors.primary
                                              : AppColors.primarylight,
                                          borderRadius: const BorderRadius.all(
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
                                                        .categoriesList[i]
                                                        .isSelected ==
                                                    true
                                                ? AppColors.primarylight
                                                : AppColors.primary,
                                          ),
                                        )),
                                  )
                              ],
                            )),
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
                            child: Obx(() => DropdownButtonFormField<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (v) {
                                    if (v == null || v.trim() == '') {
                                      return AlertStringConstants
                                          .pleaseSelectQuantityUnitText;
                                    }
                                    return null;
                                  },
                                  value: manageStoreController
                                                  .quantityValue.value !=
                                              "" &&
                                          manageStoreController
                                              .quantityTypeList.isNotEmpty
                                      ? manageStoreController.quantityTypeList
                                          .firstWhere((element) =>
                                              element.quantityTypeId ==
                                              manageStoreController
                                                  .quantityValue.value)
                                          .quantityTypeId
                                      : null,
                                  isExpanded: true,
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
                                )),
                          ),
                          width15SizedBox,
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller: manageStoreController
                                    .quantityTextController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterQuantityText;
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller:
                              manageStoreController.pricePerUnitTextController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants.pleaseEnterPriceText;
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
                      Text(
                        StringConstants.shortDescriptionText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          autofocus: false,
                          maxLines: null,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: manageStoreController
                              .shortDescriptionTextController,

                          // validator: (value) {
                          //   if (value!.trim().isEmpty) {
                          //     return AlertStringConstants
                          //         .pleaseEnterShortDescriptionText;
                          //   }
                          //   return null;
                          // },
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
                      Text(
                        StringConstants.contentsAndStrainsText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      TextFormField(
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          autofocus: false,
                          maxLines: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          controller: manageStoreController
                              .contentsAndStrainsTextController,

                          // validator: (value) {
                          //   if (value!.trim().isEmpty) {
                          //     return AlertStringConstants
                          //         .pleaseEnterContentAndStrainText;
                          //   }
                          //   return null;
                          // },
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
                      Text(
                        StringConstants.additionalLinksToResearchText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
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
                          controller: manageStoreController
                              .additionalLinkTextController,
                          keyboardType: TextInputType.emailAddress,
                          // validator: (value) {
                          // if (value!.trim().isEmpty) {
                          //   return AlertStringConstants.pleaseEnterLinkText;
                          // } else
                          //  if (!GetUtils.isURL(manageStoreController
                          //     .additionalLinkTextController.text
                          //     .trim())) {
                          //   return AlertStringConstants
                          //       .pleaseEnterValidLinkText;
                          // }
                          // return null;
                          // },
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
                      Text(
                        StringConstants.discountsOrOffersText,
                        style: TextStyle(
                            color: AppColors.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      height4SizedBox,
                      Row(
                        children: [
                          Obx(
                            () => manageStoreController
                                    .discountValueType.value.isEmpty
                                ? height0SizedBox
                                : Flexible(
                                    flex: 5,
                                    child: DropdownButtonFormField<String>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      value: manageStoreController
                                          .discountValueType.value,
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(
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
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: AppColors.primary,
                                              width: 1.0,
                                            ),
                                          )),
                                      isExpanded: true,
                                      hint: Text(
                                        StringConstants.selectTypeText,
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 14),
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
                                        manageStoreController
                                            .discountType.value = v.toString();
                                        manageStoreController.discountValueType
                                            .value = v.toString();
                                      },
                                    )),
                          ),
                          width15SizedBox,
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                                ],
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                controller: manageStoreController
                                    .discountOrOfferTextController,
                                // validator: (value) {
                                // if (value!.trim().isEmpty) {
                                //   return AlertStringConstants
                                //       .pleaseEnterDiscountOrOfferText;
                                // }
                                // return null;
                                // },
                                decoration: InputDecoration(
                                  errorMaxLines: 5,
                                  hintText: StringConstants.enterValueText,
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
                      Obx(() => manageStoreController
                              .selectedFeaturedType.value.isEmpty
                          ? height0SizedBox
                          : DropdownButtonFormField<String>(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              value: manageStoreController
                                  .selectedFeaturedType.value,
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
                                  manageStoreController.selectedFeaturedType
                                      .value = v.toString();
                                } else {
                                  manageStoreController.isFeatured.value =
                                      false;
                                  manageStoreController.selectedFeaturedType
                                      .value = v.toString();
                                }
                              },
                            )),
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
                                    ],
                                  ),
                                ),
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                                    ],
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    controller: manageStoreController
                                        .lengthTextController,
                                    // validator: (value) {
                                    //   if (value!.trim().isEmpty) {
                                    //     return AlertStringConstants
                                    //         .pleaseEnterLengthText;
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                      hintText: StringConstants.lengthText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey, fontSize: 14),
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
                                    ],
                                  ),
                                ),
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                                    ],
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    controller: manageStoreController
                                        .breadthTextController,
                                    // validator: (value) {
                                    //   if (value!.trim().isEmpty) {
                                    //     return AlertStringConstants
                                    //         .pleaseEnterBreadthText;
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                      hintText: StringConstants.breadthText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey, fontSize: 14),
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
                                    ],
                                  ),
                                ),
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                                    ],
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    controller: manageStoreController
                                        .heightTextController,
                                    // validator: (value) {
                                    //   if (value!.trim().isEmpty) {
                                    //     return AlertStringConstants
                                    //         .pleaseEnterHeightText;
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                      hintText: StringConstants.heightText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey, fontSize: 14),
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
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                                    ],
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    controller: manageStoreController
                                        .weightTextController,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AlertStringConstants
                                            .pleaseEnterWeightText;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: StringConstants.weightText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey, fontSize: 14),
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
                                          text: StringConstants
                                              .returnAvailableText,
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
                                Obx(
                                  () => manageStoreController
                                          .selectedProductReturnableType
                                          .value
                                          .isEmpty
                                      ? height0SizedBox
                                      : DropdownButtonFormField<String>(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          value: manageStoreController
                                              .selectedProductReturnableType
                                              .value,
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
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              borderSide: const BorderSide(
                                                color: AppColors.grey,
                                                width: 1.0,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
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
                                            errorBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
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
                                                color: AppColors.grey,
                                                fontSize: 14),
                                          ),
                                          items: <String>["Yes", "No"]
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            if (v == "Yes") {
                                              manageStoreController
                                                  .isProductReturnable
                                                  .value = true;
                                              manageStoreController
                                                  .selectedProductReturnableType
                                                  .value = v.toString();
                                            } else {
                                              manageStoreController
                                                  .isProductReturnable
                                                  .value = false;
                                              manageStoreController
                                                  .selectedProductReturnableType
                                                  .value = v.toString();
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                          width12SizedBox,
                          Obx(() => Flexible(
                              flex: 5,
                              child: manageStoreController
                                          .isProductReturnable.value ==
                                      true
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      StringConstants.daysText,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            inputFormatters: <TextInputFormatter>[
                                              LengthLimitingTextInputFormatter(
                                                  100),
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
                                              hintText:
                                                  StringConstants.daysText,
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
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: const BorderSide(
                                                  color: AppColors.primary,
                                                  width: 1.0,
                                                ),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: const BorderSide(
                                                  color: AppColors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                                  : height0SizedBox))
                        ],
                      ),
                      height20SizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                StringConstants.enableProductText,
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
                          if (manageStoreController.isLoading.value != true) {
                            manageStoreController.isLoading.value = true;
                            manageStoreController
                                .validateAndSubmitUpdateProduct();
                          }
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
            ))));
  }
}
