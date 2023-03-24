import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/controller/add_offer_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class EditOfferScreen extends StatefulWidget {
  const EditOfferScreen({super.key});

  @override
  State<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  final AddOffersController addOffersController =
      Get.put(AddOffersController());

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
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 24.0,
                            ),
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.updateOfferText,
                            style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/homeMall.png",
                        scale: 4,
                      )
                    ])),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: addOffersController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.uploadImageText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    height15SizedBox,
                    Obx(
                      () => addOffersController
                              .offerImageDynamicLinkfromServer.value.isEmpty
                          ? InkWell(
                              onTap: () {
                                addOffersController
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
                                              "assets/upload.png",
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
                                    color: AppColors.blacklight,
                                    strokeWidth: 1,
                                    dashPattern: const [4, 4],
                                    child: Container(
                                        width:
                                            WidgetConstants.screenWidth * 0.8,
                                        height:
                                            WidgetConstants.screenHeight * 0.2,
                                        color: AppColors.primarylight,
                                        child: Image.network(
                                            addOffersController
                                                .offerImageDynamicLinkfromServer
                                                .value,
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    height35SizedBox,
                    Text(
                      StringConstants.offerNameText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: addOffersController.offerNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterOfferNameText;
                          }
                          return null;
                        },
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
                    height20SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${StringConstants.offerFor}:",
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  activeColor: AppColors.primary,
                                  value: "store",
                                  groupValue:
                                      addOffersController.radioValue.value,
                                  onChanged: (value) {
                                    setState(() {
                                      addOffersController.radioValue.value =
                                          value.toString();

                                      addOffersController.isStoreOffer.value =
                                          true;
                                    });
                                  },
                                ),
                                Text(StringConstants.storeText)
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: AppColors.primary,
                                  value: "product",
                                  groupValue:
                                      addOffersController.radioValue.value,
                                  onChanged: (value) {
                                    setState(() {
                                      addOffersController.radioValue.value =
                                          value.toString();
                                      addOffersController.isStoreOffer.value =
                                          false;
                                    });
                                  },
                                ),
                                Text(StringConstants.productText)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    height12SizedBox,
                    Text(
                      StringConstants.selectStoreText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    height8SizedBox,
                    Obx(() => addOffersController.storeList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<String>(
                            value: addOffersController.storeIdValue.value != ""
                                ? addOffersController.storeList
                                    .firstWhere((element) =>
                                        element.storeId ==
                                        addOffersController.storeIdValue.value)
                                    .storeId
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
                              StringConstants.selectTypeText,
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
                              if (addOffersController.isStoreOffer.value ==
                                  false) {
                                await addOffersController.apiGetStoreProducts();
                                setState(() {});
                              }
                              setState(() {});
                            },
                          )),
                    height20SizedBox,
                    Obx(
                      () => addOffersController.isStoreOffer.value
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
                                                              .storeProductList[
                                                                  i]
                                                              .productId
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
                                                              .primarylight,
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
                                                                            .storeProductList[
                                                                                i]
                                                                            .productId) ==
                                                                true
                                                            ? AppColors.primary
                                                            : AppColors
                                                                .primarylight,
                                                      ),
                                                    )),
                                              )
                                          ],
                                        ),
                                      ]),
                                ),
                    ),
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
                        Flexible(
                          flex: 5,
                          child: Obx(() => addOffersController
                                  .discountType.value.isEmpty
                              ? height0SizedBox
                              : DropdownButtonFormField<String>(
                                  value: addOffersController.discountType.value,
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
                                  isExpanded: true,
                                  hint: Text(
                                    StringConstants.selectTypeText,
                                    style: const TextStyle(
                                        color: AppColors.grey, fontSize: 14),
                                  ),
                                  items: <String>["percentage", "amount"]
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
                                )),
                        ),
                        width15SizedBox,
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(100),
                              ],
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              controller: addOffersController
                                  .discountOrOfferTextController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseEnterDiscountOrOfferText;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
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
                    height35SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        addOffersController.validateAndSubmit();
                      },
                      height: 50,
                      text: StringConstants.saveText,
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
