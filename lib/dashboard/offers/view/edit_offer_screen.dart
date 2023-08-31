import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/offers/controller/add_offer_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
                            StringConstants.updateOfferText,
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
        child: SingleChildScrollView(
          child: Form(
            key: addOffersController.formKey,
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
                        controller: addOffersController.offerNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterOfferNameText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: StringConstants.enterOfferNameText,
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
                    height15SizedBox,
                    Obx(() => addOffersController.radioValue.value == "store"
                        ? Text(StringConstants.storeText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))
                        : Text(StringConstants.productText,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))),

                    height12SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.selectedStoreText,
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

                    Obx(() => Text(
                          addOffersController.storeName.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                              fontSize: 16),
                        )),

                    // Obx(() => addOffersController.storeList.isEmpty
                    //     ? height0SizedBox
                    //     : DropdownButtonFormField<String>(
                    //         autovalidateMode:
                    //             AutovalidateMode.onUserInteraction,
                    //         value: addOffersController.storeIdValue.value != ""
                    //             ? addOffersController.storeList
                    //                 .firstWhere((element) =>
                    //                     element.storeId ==
                    //                     addOffersController.storeIdValue.value)
                    //                 .storeId
                    //             : null,
                    //         isExpanded: true,
                    //         decoration: InputDecoration(
                    //           enabledBorder: UnderlineInputBorder(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             borderSide: const BorderSide(
                    //               color: AppColors.grey,
                    //               width: 1.0,
                    //             ),
                    //           ),
                    //           border: UnderlineInputBorder(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             borderSide: const BorderSide(
                    //               color: AppColors.primary,
                    //               width: 1.0,
                    //             ),
                    //           ),
                    //           focusedBorder: UnderlineInputBorder(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             borderSide: const BorderSide(
                    //               color: AppColors.primary,
                    //               width: 1.0,
                    //             ),
                    //           ),
                    //           errorBorder: UnderlineInputBorder(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             borderSide: const BorderSide(
                    //               color: AppColors.primary,
                    //               width: 1.0,
                    //             ),
                    //           ),
                    //         ),
                    //         hint: Text(
                    //           StringConstants.selectTypeText,
                    //           style: const TextStyle(
                    //               color: AppColors.grey, fontSize: 14),
                    //         ),
                    //         items: addOffersController.storeList
                    //             .map((dynamic value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value.storeId,
                    //             child: Text(
                    //               value.storeName,
                    //               style: const TextStyle(
                    //                   color: AppColors.black,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w500),
                    //             ),
                    //           );
                    //         }).toList(),
                    //         onChanged: (value) async {
                    //           addOffersController.storeIdValue.value =
                    //               value.toString();
                    //           if (addOffersController.radioValue.value !=
                    //               "store") {
                    //             await addOffersController.apiGetStoreProducts();
                    //             setState(() {});
                    //           }
                    //           setState(() {});
                    //         },
                    //       )),
                    height5SizedBox,
                    Obx(
                      () => addOffersController.radioValue.value == "store"
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
                                                  addOffersController
                                                      .selectedProducts
                                                      .clear();
                                                  addOffersController
                                                          .storeProductList[i]
                                                          .offerStatus =
                                                      addOffersController
                                                                  .storeProductList[
                                                                      i]
                                                                  .offerStatus ==
                                                              "deleted"
                                                          ? "active"
                                                          : "deleted";

                                                  if (addOffersController
                                                      .offerProductDetail
                                                      .isNotEmpty) {
                                                    for (int i = 0;
                                                        i <
                                                            addOffersController
                                                                .storeProductList
                                                                .length;
                                                        i++) {
                                                      for (var ele
                                                          in addOffersController
                                                              .offerProductDetail) {
                                                        if (ele.offerProductId ==
                                                            addOffersController
                                                                .storeProductList[
                                                                    i]
                                                                .offerProductId) {
                                                          addOffersController
                                                              .selectedProducts
                                                              .add({
                                                            "offer_product_id":
                                                                addOffersController
                                                                    .storeProductList[
                                                                        i]
                                                                    .offerProductId,
                                                            "product_id":
                                                                addOffersController
                                                                    .storeProductList[
                                                                        i]
                                                                    .productId,
                                                            "status":
                                                                addOffersController
                                                                    .storeProductList[
                                                                        i]
                                                                    .offerStatus
                                                          });
                                                        }
                                                      }

                                                      if (addOffersController
                                                                  .storeProductList[
                                                                      i]
                                                                  .offerStatus ==
                                                              "active" &&
                                                          !addOffersController
                                                              .offerProductDetail
                                                              .any((element) =>
                                                                  element
                                                                      .offerProductId ==
                                                                  addOffersController
                                                                      .storeProductList[
                                                                          i]
                                                                      .offerProductId)) {
                                                        addOffersController
                                                            .selectedProducts
                                                            .add({
                                                          "offer_product_id":
                                                              addOffersController
                                                                  .storeProductList[
                                                                      i]
                                                                  .offerProductId,
                                                          "product_id":
                                                              addOffersController
                                                                  .storeProductList[
                                                                      i]
                                                                  .productId,
                                                          "status":
                                                              addOffersController
                                                                  .storeProductList[
                                                                      i]
                                                                  .offerStatus
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    for (var data
                                                        in addOffersController
                                                            .storeProductList) {
                                                      if (data.offerStatus ==
                                                          "active") {
                                                        addOffersController
                                                            .selectedProducts
                                                            .add({
                                                          "offer_product_id":
                                                              null,
                                                          "product_id":
                                                              data.productId,
                                                          "status":
                                                              data.offerStatus
                                                        });
                                                      }
                                                    }
                                                  }

                                                  setState(() {});
                                                },
                                                child: Obx(() => Container(
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
                                                                  .storeProductList[
                                                                      i]
                                                                  .offerStatus ==
                                                              "deleted"
                                                          ? AppColors
                                                              .primarylight
                                                          : AppColors.primary,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(100),
                                                      ),
                                                    ),
                                                    child: Obx(() => Text(
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
                                                                  FontWeight
                                                                      .w500,
                                                              color: addOffersController
                                                                          .storeProductList[
                                                                              i]
                                                                          .offerStatus ==
                                                                      "deleted"
                                                                  ? AppColors
                                                                      .primary
                                                                  : AppColors
                                                                      .white),
                                                        )))),
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
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Obx(() => addOffersController
                                  .discountType.value.isEmpty
                              ? height0SizedBox
                              : DropdownButtonFormField<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  value: addOffersController
                                          .discountType.value.isNotEmpty
                                      ? addOffersController.discountType.value
                                      : "",
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              controller: addOffersController
                                  .discountOrOfferTextController,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseEnterValueText;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
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
                    height35SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        addOffersController.validateAndSubmit(false, context);
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
