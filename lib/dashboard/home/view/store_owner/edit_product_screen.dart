import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/manage_store_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  final bool? isFromHome;
  final String? storeId;
  final String? productId;
  final String? categoryName;

  const EditProductScreen({
    Key? key,
     this.isFromHome =false,
    this.storeId,
    this.productId,
    this.categoryName,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> with GlobalVarMixin{
  final ManageStoreController manageStoreController =
      Get.put(ManageStoreController());


  @override
  void initState() {
      manageStoreController.storeId.value = widget.storeId ??"";
      manageStoreController.productId.value =  widget.productId ??"";
      manageStoreController.categoryName.value = widget.categoryName ??"";
       manageStoreController.apiGetCategoriesList();
       manageStoreController.apiGetQuantityList();
      manageStoreController.apiGetProductDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: buildAppBar(),
        body: buildBody(context));
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primaryLight,
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 20, top: 50,bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(5),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              for (var element
                                  in manageStoreController.categoriesList) {
                                element.isSelected = false;
                              }
                              if (Get.parameters['isFromHome'] == 'true') {
                                Get.delete<ManageStoreController>();
                              }
                              manageStoreController.resetForm();
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
                          SizedBox(
                                width: 200,
                                child: Text(
                                  widget.categoryName??"",
                                  overflow: TextOverflow.ellipsis,
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
          ));
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
                                    : Column(
                                        children: [
                                          Text(StringConstants.uploadProductPhotosText,
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                          height6SizedBox
                                        ],
                                      ),
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
                                          child: ListView.separated(
                                              padding: EdgeInsets.zero,
                                              separatorBuilder:
                                                  (BuildContext context, int index) {
                                                return width5SizedBox;
                                              },
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
                                                                    0.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      8),
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
                                                                  EdgeInsets.all(2),
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
                                                    color: AppColors.blackLight,
                                                    strokeWidth: 1,
                                                    dashPattern: const [4, 4],
                                                    child: Container(
                                                      width:
                                                          WidgetConstants.screenWidth *
                                                              0.3,
                                                      padding: const EdgeInsets.only(
                                                          top: 30, bottom: 30),
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
                              buildText(StringConstants.productNameText, StringConstants.starText,),
                              height4SizedBox,
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
                                    manageStoreController.productNameTextController,
                                hintText: StringConstants.enterProductNameText,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants
                                        .pleaseEnterProductNameText;
                                  }
                                  return null;
                                },
                              ),
                              height20SizedBox,
                              buildText(StringConstants.categoriesText, StringConstants.starText,),

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
                                                      : AppColors.primaryLight,
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
                                                        ? AppColors.primaryLight
                                                        : AppColors.primary,
                                                  ),
                                                )),
                                          )
                                      ],
                                    )),
                              height20SizedBox,
                              buildText(StringConstants.quantityUnitText, StringConstants.starText,),

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
                                      value: manageStoreController.quantityValue.value.isNotEmpty &&
                                          manageStoreController.quantityTypeList.isNotEmpty &&
                                          manageStoreController.quantityTypeList
                                              .any((e) => e.quantityTypeId == manageStoreController.quantityValue.value)
                                          ? manageStoreController.quantityValue.value
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
                                    child: CustomInputField(
                                      isBorderOutline: false,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(100),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      autofocus: false,
                                      maxLines: null,
                                      controller:
                                          manageStoreController.quantityTextController,
                                      hintText: StringConstants.enterQuantityText,
                                      textCapitalization: TextCapitalization.words,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterQuantityText;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              height20SizedBox,
                              buildText(StringConstants.pricePerUnitText, StringConstants.starText,),

                              height4SizedBox,
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                                ],
                                textInputAction: TextInputAction.next,
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                autofocus: false,
                                maxLines: null,
                                hintText: StringConstants.enterPriceText,
                                controller:
                                    manageStoreController.pricePerUnitTextController,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants.pleaseEnterPriceText;
                                  }
                                  return null;
                                },
                              ),
                              height20SizedBox,
                              Text(
                                StringConstants.shortDescriptionText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height4SizedBox,
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                maxLines: null,
                                hintText: StringConstants.shortDescriptionText,
                                controller: manageStoreController
                                    .shortDescriptionTextController,
                              ),
                              height20SizedBox,
                              Text(
                                StringConstants.contentsAndStrainsText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height4SizedBox,
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                maxLines: null,
                                textCapitalization: TextCapitalization.sentences,
                                hintText: StringConstants.contentsAndStrainsText,
                                controller: manageStoreController
                                    .contentsAndStrainsTextController,
                              ),
                              height20SizedBox,
                              Text(
                                StringConstants.additionalLinksToResearchText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height4SizedBox,
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter(RegExp(r"\s"),
                                      allow: false),
                                  LengthLimitingTextInputFormatter(25),
                                ],
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                maxLines: null,
                                textCapitalization: TextCapitalization.sentences,
                                hintText: StringConstants.additionalLinksToResearchText,
                                controller:
                                    manageStoreController.additionalLinkTextController,
                              ),
                              height20SizedBox,
                              Text(
                                StringConstants.discountsOrOffersText,
                                style: const TextStyle(
                                    color: AppColors.black,
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
                                    child: CustomInputField(
                                      isBorderOutline: false,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(100),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      autofocus: false,
                                      maxLines: null,
                                      textCapitalization: TextCapitalization.sentences,
                                      hintText: StringConstants.enterValueText,
                                      controller: manageStoreController
                                          .discountOrOfferTextController,
                                      validator: (value) {
                                        final input = value?.trim() ?? "";
                                        final discountType = manageStoreController.discountType.value.toLowerCase();
                                        final isPercentage = discountType == "percentage";
                                        if (discountType.isNotEmpty) {
                                          if (input.isEmpty && discountType.isNotEmpty) {
                                            return AlertStringConstants.pleaseEnterValueText;
                                          }

                                          final parsed = double.tryParse(input);
                                          if (parsed == null ) {
                                            return AlertStringConstants.invalidAmountText;
                                          }

                                          if (isPercentage && parsed >= 100) {
                                            return "Percentage value must be less than 100%";
                                          }

                                          if (!isPercentage) {
                                            final productPrice = double.tryParse(manageStoreController.pricePerUnitTextController.text) ?? 0;
                                            if (parsed >= productPrice) {
                                              return "Discount amount must be less than product price";
                                            }
                                          }
                                          return null;
                                        }


                                        return null;

                                      },
                                    ),
                                  ),
                                ],
                              ),
                              height20SizedBox,
                              buildText(StringConstants.featuredProductText, StringConstants.starText,),

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
                                        buildText( "${StringConstants.lengthText}(in)",""),

                                        CustomInputField(
                                          isBorderOutline: false,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(100),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          maxLines: null,
                                          hintText: StringConstants.lengthText,
                                          controller: manageStoreController
                                              .lengthTextController,
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
                                        buildText( "${StringConstants.breadthText}(in)",""),


                                        CustomInputField(
                                          isBorderOutline: false,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(100),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          maxLines: null,
                                          hintText: StringConstants.breadthText,
                                          controller: manageStoreController
                                              .breadthTextController,
                                        ),
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
                                        buildText( "${StringConstants.heightText}(in)",""),



                                        CustomInputField(
                                          isBorderOutline: false,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(100),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          maxLines: null,
                                          hintText: StringConstants.heightText,
                                          controller: manageStoreController
                                              .heightTextController,
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
                                        buildText( "${StringConstants.weightText}(oz)",StringConstants.starText),



                                        CustomInputField(
                                          isBorderOutline: false,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(100),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          maxLines: null,
                                          hintText: StringConstants.weightText,
                                          controller: manageStoreController
                                              .weightTextController,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseEnterWeightText;
                                            }
                                            return null;
                                          },
                                        ),
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
                                        buildText(  StringConstants
                                            .returnAvailableText,StringConstants.starText),


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
                                                buildText(  StringConstants
                                                    .daysText,StringConstants.starText),


                                                CustomInputField(
                                                  isBorderOutline: false,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    LengthLimitingTextInputFormatter(
                                                        100),
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  textInputAction: TextInputAction.next,
                                                  autofocus: false,
                                                  maxLines: null,
                                                  hintText: StringConstants.daysText,
                                                  controller: manageStoreController
                                                      .daysTextController,
                                                  validator: (value) {
                                                    if (value!.trim().isEmpty) {
                                                      return AlertStringConstants
                                                          .pleaseEnterValidDaysText;
                                                    }
                                                    return null;
                                                  },
                                                ),
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
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
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
                                          color: AppColors.greyLight,
                                        ),
                                        inactiveSwitchBorder: Border.all(
                                          color: AppColors.greyLight,
                                        ),
                                        activeColor: AppColors.greyMediumLight,
                                        inactiveColor: AppColors.greyMediumLight,
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
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if (manageStoreController.isLoading.value != true) {

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
                    ))),
            ),
          ],
        ),
        //LOADING OVERLAY
        Obx(() {
          return manageStoreController.isLoading.value
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
