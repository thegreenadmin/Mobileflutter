import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/controller/add_offer_controller.dart';
import 'package:thegreenmall/utils/utils.dart';
enum OfferType { store, product }
enum DiscountType { percentage, amount }
extension DiscountTypeExtension on DiscountType {
  String get label {
    switch (this) {
      case DiscountType.percentage:
        return 'Percentage';
      case DiscountType.amount:
        return 'Amount';
    }
  }
}

class AddOfferScreen extends StatefulWidget {
  final String? isFrom;
  const AddOfferScreen({super.key, this.isFrom});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen>with GlobalVarMixin {
  final AddOffersController addOffersController =
      Get.put(AddOffersController());

  @override
  initState() {
    super.initState();
    addOffersController.isFrom.value = widget.isFrom ??"";
    addOffersController.offerNameTextController.clear();
    addOffersController.discountOrOfferTextController.clear();
    addOffersController.offerImageDynamicLinkFromServer.value = "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addOffersController.apiGetStoreList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: AppColors.primaryLight,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20, top: 50),
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
                                  Get.delete<AddOffersController>();
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
                                StringConstants.addOfferText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ])),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: SingleChildScrollView(
                    child: Form(
                      key: addOffersController.formKey,
                      child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.uploadImageText,
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
                              height15SizedBox,
                              Obx(
                                () => addOffersController
                                        .offerImageDynamicLinkFromServer.value.isEmpty
                                    ? InkWell(
                                        onTap: () {
                                          addOffersController
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
                                                      Text(
                                                          StringConstants.uploadImageText)
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          addOffersController
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
                                                  width:
                                                      WidgetConstants.screenWidth * 0.8,
                                                  height:
                                                      WidgetConstants.screenHeight * 0.2,
                                                  color: AppColors.primaryLight,
                                                  child: CommonWidgets.cachedNetworkImage(
                                                    addOffersController
                                                        .offerImageDynamicLinkFromServer
                                                        .value,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => SizedBox(
                                                        width:
                                                            WidgetConstants.screenWidth *
                                                                0.8,
                                                        height:
                                                            WidgetConstants.screenHeight *
                                                                0.2,
                                                        child: const Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                                  )),
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
                                        text: StringConstants.offerNameText,
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
                              CustomInputField(
                                isBorderOutline: false,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                maxLines: null,
                                errorMaxLines: 3,
                                controller: addOffersController.offerNameTextController,
                                hintText: StringConstants.enterOfferNameText,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return AlertStringConstants.pleaseEnterOfferNameText;
                                  }
                                  return null;
                                },
                              ),
                              height20SizedBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: StringConstants.offerFor,
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
                                  ),
                                  Row(
                                    children: OfferType.values.map((type) {
                                      return Row(
                                        children: [
                                          Obx(() => Radio<OfferType>(
                                            activeColor: AppColors.primary,
                                            value: type,
                                            groupValue: addOffersController.radioValue.value,
                                            onChanged: (value) {
                                              if (value != null) {
                                                addOffersController.radioValue.value = value;
                                                addOffersController.storeProductList.clear();

                                                if (value == OfferType.product &&
                                                    addOffersController.storeIdValue.value.isNotEmpty) {
                                                  addOffersController.apiGetStoreProducts();
                                                }
                                              }
                                            },
                                          )),
                                          Text(
                                            type == OfferType.store
                                                ? StringConstants.storeText
                                                : StringConstants.productText,
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),

                                /*  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Obx(() => Radio(
                                                activeColor: AppColors.primary,
                                                value: "store",
                                                groupValue:
                                                    addOffersController.radioValue.value,
                                                onChanged: (value) {
                                                  addOffersController.radioValue.value =
                                                      value.toString();
                                                  addOffersController.storeProductList
                                                      .clear();
                                                },
                                              )),
                                          Text(StringConstants.storeText)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Obx(() => Radio(
                                                activeColor: AppColors.primary,
                                                value: "product",
                                                groupValue:
                                                    addOffersController.radioValue.value,
                                                onChanged: (value) {
                                                  addOffersController.radioValue.value =
                                                      value.toString();
                                                  addOffersController.storeProductList
                                                      .clear();
                
                                                  if (addOffersController
                                                          .storeIdValue.value !=
                                                      "") {
                                                    addOffersController
                                                        .apiGetStoreProducts();
                                                  }
                                                },
                                              )),
                                          Text(StringConstants.productText)
                                        ],
                                      ),
                                    ],
                                  )*/
                                ],
                              ),
                              height12SizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.selectStoreText,
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
                              height8SizedBox,
                              Obx(() => DropdownButtonFormField<String>(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    value: addOffersController.storeIdValue.value != ""
                                        ? addOffersController.storeIdValue.value
                                        : null,
                                    isExpanded: true,
                                    decoration: InputDecoration(
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
                                      StringConstants.selectStoreText,
                                      style: const TextStyle(
                                          color: AppColors.grey, fontSize: 14),
                                    ),
                                    items: addOffersController.storeList
                                        .map((dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value.storeId,
                                        child: Text(
                                          value.storeName,
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      addOffersController.storeIdValue.value =
                                          value.toString();
                                      if (addOffersController.radioValue.value !=
                                         OfferType.store) {
                                        await addOffersController.apiGetStoreProducts();
                                      }
                                      setState(() {});
                                    },
                                  )),
                              height20SizedBox,
                              Obx(
                                () => addOffersController.radioValue.value == OfferType.store
                                    ? height0SizedBox
                                    : addOffersController.storeProductList.isEmpty
                                        ? height0SizedBox
                                        : SizedBox(
                                            width: Get.width,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      for (var i = 0;
                                                          i <
                                                              addOffersController
                                                                  .storeProductList
                                                                  .length;
                                                          i++)
                                                        InkWell(
                                                          onTap: () {
                                                            if (addOffersController
                                                                    .storeProductList[i]
                                                                    .isSelected ==
                                                                false) {

                                                              addOffersController
                                                                  .selectedProducts
                                                                  .add({
                                                                "product_id":
                                                                    addOffersController
                                                                        .storeProductList[i]
                                                                        .productId,
                                                                 "product_price":
                                                                    addOffersController
                                                                        .storeProductList[i]
                                                                        .productPrice,

                                                              });
                                                              addOffersController
                                                                  .storeProductList[i]
                                                                  .isSelected = true;
                                                            } else {
                                                              addOffersController
                                                                  .selectedProducts
                                                                  .removeWhere((item) =>
                                                                      item[
                                                                          'product_id'] ==
                                                                      addOffersController
                                                                          .storeProductList[
                                                                              i]
                                                                          .productId);
                                                              addOffersController
                                                                  .storeProductList[i]
                                                                  .isSelected = false;
                                                            }
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom: 10),
                                                              margin:
                                                                  const EdgeInsets.all(3),
                                                              decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey
                                                                        .withOpacity(0.1),
                                                                    spreadRadius: 5,
                                                                    blurRadius: 7,
                                                                    offset: const Offset(
                                                                        0, 2),
                                                                  ),
                                                                ],
                                                                color: addOffersController
                                                                            .selectedProducts
                                                                            .any((item) =>
                                                                                item[
                                                                                    'product_id'] ==
                                                                                addOffersController
                                                                                    .storeProductList[
                                                                                        i]
                                                                                    .productId) ==
                                                                        true
                                                                    ? AppColors.primary
                                                                    : AppColors
                                                                        .primaryLight,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius.circular(100),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                addOffersController
                                                                        .storeProductList[
                                                                            i]
                                                                        .productName ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  color: addOffersController
                                                                              .selectedProducts
                                                                              .any((item) =>
                                                                                  item[
                                                                                      'product_id'] ==
                                                                                  addOffersController
                                                                                      .storeProductList[i]
                                                                                      .productId) ==
                                                                          true
                                                                      ? AppColors.white
                                                                      : AppColors.primary,
                                                                ),
                                                              )),
                                                        )
                                                    ],
                                                  ),
                                                ]),
                                          ),
                              ),
                              height15SizedBox,
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StringConstants.discountsOrOffersText,
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
                             /* Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: DropdownButtonFormField<String>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseSelectDiscountType;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        errorMaxLines: 4,
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
                                            color: AppColors.red,
                                            width: 2.0,
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
                                        addOffersController.discountType.value =
                                            v.toString();
                                      },
                                    ),
                                  ),
                                  width15SizedBox,
                                  Flexible(
                                      flex: 5,
                                      child: CustomInputField(
                                        isBorderOutline: false,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(100),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}'))
                                        ],
                                        textInputAction: TextInputAction.next,
                                        autofocus: false,
                                        maxLines: null,
                                        errorMaxLines: 3,
                                        hintText: StringConstants.enterValueText,
                                        textCapitalization: TextCapitalization.words,
                                        controller: addOffersController
                                            .discountOrOfferTextController,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return AlertStringConstants
                                                .pleaseEnterValueText;
                                          } else if (double.parse(value) == 0) {
                                            return AlertStringConstants.invalidAmountText;
                                          }
                                          return null;
                                        },
                                      )),
                                ],
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Obx(() {
                                      final isStore = addOffersController.radioValue.value == OfferType.store;

                                      return DropdownButtonFormField<DiscountType>(
                                        value: isStore ? DiscountType.percentage : null,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (!isStore && value == null) {
                                            return AlertStringConstants.pleaseSelectDiscountType;
                                          }
                                          return null;
                                        },
                                        onChanged: isStore
                                            ? null
                                            : (v) {
                                          addOffersController.discountType.value = v!;
                                        },
                                        decoration: InputDecoration(
                                          errorMaxLines: 4,
                                          enabledBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(color: AppColors.red, width: 2.0),
                                          ),
                                        ),
                                        isExpanded: true,
                                        hint: Text(
                                          StringConstants.selectTypeText,
                                          style: const TextStyle(color: AppColors.grey, fontSize: 14),
                                        ),
                                        items: DiscountType.values.map((DiscountType value) {
                                          return DropdownMenuItem<DiscountType>(
                                            value: value,
                                            child: Text(
                                              value.label,
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }),
                                  ),
                                  width15SizedBox,
                                  Flexible(
                                    flex: 5,
                                    child: CustomInputField(
                                      isBorderOutline: false,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(100),
                                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      ],
                                      textInputAction: TextInputAction.next,
                                      autofocus: false,
                                      maxLines: null,
                                      errorMaxLines: 3,
                                      hintText: StringConstants.enterValueText,
                                      textCapitalization: TextCapitalization.none,
                                      controller: addOffersController.discountOrOfferTextController,
                                      validator: (value) {
                                        final v = value?.trim();
                                        if (v == null || v.isEmpty) {
                                          return AlertStringConstants.pleaseEnterValueText;
                                        }

                                        final parsed = double.tryParse(v);
                                        if (parsed == null || parsed == 0) {
                                          return AlertStringConstants.invalidAmountText;
                                        }

                                        final isPercentage = addOffersController.discountType.value == DiscountType.percentage;
                                        if (isPercentage && parsed >= 100) {
                                          return "Percentage value must be less than 100%";
                                        }


                                        // Rule 2: For amount, it must not exceed any selected product's price
                                        if (!isPercentage && addOffersController.selectedProducts.isNotEmpty) {
                                          for (var product in addOffersController.selectedProducts) {
                                            final productPrice = double.tryParse(product["product_price"].toString()) ?? 0;
                                            if (parsed >= productPrice) {
                                              return "Discount amount must be less than all selected product prices";
                                            }
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              height35SizedBox,
                              CustomButton(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [AppColors.primary, AppColors.primary],
                                ),
                                onTap: () {
                                  addOffersController.validateAndSubmit(true, context);
                                },
                                height: 50,
                                text: StringConstants.addOfferText,
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
              ),
            ],
          ),
          //LOADING OVERLAY
          Obx(() {
            return addOffersController.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),)
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
