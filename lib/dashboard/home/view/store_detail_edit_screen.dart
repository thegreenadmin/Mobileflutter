import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/multi_drop_class.dart';
import '../../../utils/mutli_select_drop_down.dart';
import '../../../utils/sizedbox_constants.dart';

class StoreDetailEditScreen extends StatefulWidget {
  const StoreDetailEditScreen({super.key});

  @override
  State<StoreDetailEditScreen> createState() => _StoreDetailEditScreenState();
}

class _StoreDetailEditScreenState extends State<StoreDetailEditScreen> {
  final SearchStoreController searchStoreController =
      Get.put(SearchStoreController());

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
                                StringConstants.editStoreText,
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
                        ]),
                  ],
                )),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: searchStoreController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.editStoreText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    height15SizedBox,
                    Text(
                      StringConstants.uploadLogoText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height15SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Row(
                            children: [
                              DottedBorder(
                                color: AppColors.blacklight,
                                strokeWidth: 1,
                                dashPattern: const [4, 4],
                                child: Container(
                                  width: WidgetConstants.screenWidth * 0.3,
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
                                          "assets/uploadpic.png",
                                          scale: 2.5,
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        width20SizedBox,
                        Flexible(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height10SizedBox,
                              Text(StringConstants.uploadStoreLogoText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              height10SizedBox,
                              // Text(StringConstants.theImageMustBeAtleaseText,
                              //     style: const TextStyle(
                              //         color: AppColors.black,
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.w400)),
                              height10SizedBox,
                            ],
                          ),
                        )
                      ],
                    ),
                    height20SizedBox,

                    Text(
                      StringConstants.bannerImageText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height20SizedBox,
                    Obx(
                      () => searchStoreController
                              .editStoreImageDynamicLinkfromServer.value.isEmpty
                          ? InkWell(
                              onTap: () {
                                searchStoreController
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
                                      width: WidgetConstants.screenWidth * 0.85,
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
                                            Text(StringConstants
                                                .uploadStoreImageText)
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                searchStoreController
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
                                            WidgetConstants.screenWidth * 0.85,
                                        height:
                                            WidgetConstants.screenHeight * 0.2,
                                        color: AppColors.primarylight,
                                        child: Image.network(
                                            searchStoreController
                                                .editStoreImageDynamicLinkfromServer
                                                .value,
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    height15SizedBox,
                    Text(
                      StringConstants.storeNameText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller:
                            searchStoreController.storeNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStoreNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.storeNameText,
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
                      StringConstants.einBusinessId,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller: searchStoreController.einTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterEinText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.einBusinessId,
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
                      StringConstants.nickNameText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller:
                            searchStoreController.nickNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterNickNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.nickNameText,
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
                      StringConstants.emailIdText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller: searchStoreController.emailTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterEmailText;
                          } else if (!GetUtils.isEmail(value.trim())) {
                            return AlertStringConstants
                                .pleaseEnterValidEmailText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.emailIdText,
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
                      StringConstants.phoneNumberText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller: searchStoreController.phoneTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterPhoneText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.phoneNumberText,
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
                      StringConstants.addressText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    height20SizedBox,
                    Text(
                      StringConstants.addressLine1Text,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(500),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            searchStoreController.addressLine1TextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterAddressText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.addressLine1Text,
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
                      StringConstants.addressLine2Text,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(500),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            searchStoreController.addressLine2TextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterAddressText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.addressLine2Text,
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
                      StringConstants.townOrCityText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(500),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            searchStoreController.townOrCityTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterTownOrCityText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.townOrCityText,
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
                      StringConstants.postalCodeText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            searchStoreController.postalCodeTextController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterPostalCodeText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.postalCodeText,
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
                      StringConstants.countryText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    Obx(() => searchStoreController.countriesList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<CountriesList>(
                            isExpanded: true,
                            value: searchStoreController.countriesList.last,
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
                              hintText: 'Organisation Type',
                              errorStyle: const TextStyle(color: Colors.yellow),
                            ),
                            items: searchStoreController.countriesList
                                .map<DropdownMenuItem<CountriesList>>(
                                    (CountriesList value) {
                              return DropdownMenuItem<CountriesList>(
                                value: value,
                                child: Text(value.countryName.toString()),
                              );
                            }).toList(),
                            onChanged: (CountriesList? newValue) {
                              setState(() {
                                searchStoreController.countryDropdownValue
                                    .value = newValue!.countryName.toString();
                                searchStoreController.countryId!.value =
                                    newValue.countryId.toString();
                                searchStoreController.apiGetState();
                                print(searchStoreController.countryId!.value);
                              });
                            },
                          )),
                    height20SizedBox,
                    Text(
                      StringConstants.zoneText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    Obx(() => searchStoreController.statesList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<StatesList>(
                            isExpanded: true,
                            value: searchStoreController.statesList.last,
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
                              hintText: 'Organisation Type',
                              errorStyle: const TextStyle(color: Colors.yellow),
                            ),
                            items: searchStoreController.statesList
                                .map<DropdownMenuItem<StatesList>>(
                                    (StatesList value) {
                              return DropdownMenuItem<StatesList>(
                                value: value,
                                child: Text(value.stateName.toString()),
                              );
                            }).toList(),
                            onChanged: (StatesList? newValue) {
                              setState(() {
                                searchStoreController.stateDropdownValue.value =
                                    newValue!.stateName.toString();
                                searchStoreController.stateId.value =
                                    newValue.stateId.toString();
                                print(searchStoreController.stateId.value);
                              });
                            },
                          )),
                    height25SizedBox,
                    Text(
                      StringConstants.storeTimingText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    height25SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                  value: 0,
                                  groupValue: searchStoreController
                                      .radioGroupValue.value,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    searchStoreController.radioGroupValue
                                        .value = value?.toInt() ?? 0;
                                    searchStoreController.is247Time.value =
                                        false;
                                    print(searchStoreController
                                        .radioGroupValue.value);
                                    print(
                                        searchStoreController.is247Time.value);
                                  },
                                ),
                              ),
                            ),
                            width15SizedBox,
                            Text(
                              StringConstants.customTimeText,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        width30SizedBox,
                        Row(
                          children: [
                            Obx(
                              () => SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                  value: 1,
                                  groupValue: searchStoreController
                                      .radioGroupValue.value,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    searchStoreController.radioGroupValue
                                        .value = value?.toInt() ?? 0;
                                    searchStoreController.is247Time.value =
                                        true;
                                    print(searchStoreController
                                        .radioGroupValue.value);
                                    print(
                                        searchStoreController.is247Time.value);
                                  },
                                ),
                              ),
                            ),
                            width15SizedBox,
                            Text(
                              StringConstants.twentyFourSevenText,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                    height25SizedBox,
                    Obx(
                      () => searchStoreController.is247Time.value != true
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringConstants.openingTimeText,
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      height4SizedBox,
                                      TextFormField(
                                          textInputAction: TextInputAction.next,
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
                                          controller: searchStoreController
                                              .openingTimeTextController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseSelectOpeningTimeText;
                                            } else if (value.trim() ==
                                                searchStoreController
                                                    .closingTimeTextController
                                                    .text) {
                                              return AlertStringConstants
                                                  .openingTimeAlertText;
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            TimeOfDay date = TimeOfDay.now();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            date = (await showTimePicker(
                                              helpText: "Select Time",
                                              initialTime: TimeOfDay.now(),
                                              context: context,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                            primary: AppColors
                                                                .primary),
                                                    buttonTheme:
                                                        const ButtonThemeData(
                                                            textTheme:
                                                                ButtonTextTheme
                                                                    .primary),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            ))!;

                                            searchStoreController
                                                    .openingTimeTextController
                                                    .text =
                                                date.format(context).toString();
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                StringConstants.openingTimeText,
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
                                ),
                                width15SizedBox,
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringConstants.closingTimeText,
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      height4SizedBox,
                                      TextFormField(
                                          textInputAction: TextInputAction.next,
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
                                          controller: searchStoreController
                                              .closingTimeTextController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseSelectClosingTimeText;
                                            } else if (value.trim() ==
                                                searchStoreController
                                                    .openingTimeTextController
                                                    .text) {
                                              return AlertStringConstants
                                                  .closingTimeAlertText;
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            TimeOfDay date = TimeOfDay.now();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            date = (await showTimePicker(
                                              helpText: "Select Time",
                                              initialTime: TimeOfDay.now(),
                                              context: context,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                            primary: AppColors
                                                                .primary),
                                                    buttonTheme:
                                                        const ButtonThemeData(
                                                            textTheme:
                                                                ButtonTextTheme
                                                                    .primary),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            ))!;
                                            searchStoreController
                                                    .closingTimeTextController
                                                    .text =
                                                date.format(context).toString();
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                StringConstants.closingTimeText,
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
                              ],
                            )
                          : height0SizedBox,
                    ),
                    height20SizedBox,
                    Obx(() => searchStoreController.is247Time.value != true
                        ? Text(
                            StringConstants.workingDaysText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : height0SizedBox),
                    height4SizedBox,
                    // Obx(
                    //   () => searchStoreController.is247Time.value != true
                    //       ? MultiDropClass(
                    //           onChanged: (v) {
                    //             searchStoreController.storeTimmingList.clear();
                    //             //  String selectedDays = "";
                    //             for (int i = 0;
                    //                 i <
                    //                     searchStoreController
                    //                         .weekDaysList.length;
                    //                 i++) {
                    //               if (searchStoreController.weekDaysList[i]
                    //                   ['isSelected']) {
                    //                 // selectedDays = searchStoreController
                    //                 //         .weekDaysList[i]['day'] +
                    //                 //     "," +
                    //                 //     selectedDays;
                    //                 searchStoreController.storeTimmingList.add({
                    //                   "is_24_hours_active": false,
                    //                   "day_of_week": (i + 1).toString(),
                    //                   "opening_time": searchStoreController
                    //                       .openingTimeTextController.text
                    //                       .trim(),
                    //                   "closing_time": searchStoreController
                    //                       .closingTimeTextController.text
                    //                       .trim()
                    //                 });
                    //               }
                    //             }
                    //             print("top list" + v.toString());
                    //             print("LISTTTTTTTTTTTTT" +
                    //                 searchStoreController.storeTimmingList
                    //                     .toString());
                    //             // searchStoreController.workingDaysTextController.clear();
                    //             // searchStoreController.workingDaysTextController
                    //             //     .text = selectedDays;
                    //           },
                    //           controller: searchStoreController
                    //               .workingDaysTextController,
                    //           hintText: StringConstants.selectDaysText,
                    //           title: StringConstants.selectDaysText,
                    //           list: searchStoreController.weekDaysList)
                    //       : height0SizedBox,
                    // ),
                    Obx(
                      () => searchStoreController.is247Time.value != true
                          ? MultiCustomDropDown(
                              onChanged: (v) {
                                searchStoreController.storeTimmingList.clear();
                                String selectedDays = "";
                                for (int i = 0;
                                    i <
                                        searchStoreController
                                            .weekDaysList.length;
                                    i++) {
                                  if (searchStoreController
                                          .weekDaysList[i].isSelected ==
                                      true) {
                                    if (selectedDays.isEmpty) {
                                      selectedDays =
                                          "${searchStoreController.weekDaysList[i].name}";
                                    } else {
                                      selectedDays =
                                          "$selectedDays, ${searchStoreController.weekDaysList[i].name}";
                                    }
                                    searchStoreController.storeTimmingList.add({
                                      "is_24_hours_active": false,
                                      "day_of_week": searchStoreController
                                          .weekDaysList[i].id,
                                      //(i + 1).toString(),
                                      "opening_time": searchStoreController
                                          .openingTimeTextController.text
                                          .trim(),
                                      "closing_time": searchStoreController
                                          .closingTimeTextController.text
                                          .trim()
                                    });
                                  }
                                }
                                print("top list" + v.toString());
                                print("LISTTTTTTTTTTTTT" +
                                    searchStoreController.storeTimmingList
                                        .toString());
                                searchStoreController.workingDaysTextController
                                    .text = selectedDays;
                              },
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AlertStringConstants
                                      .pleaseEnterWeekDaysText;
                                }
                                return null;
                              },
                              controller: searchStoreController
                                  .workingDaysTextController,
                              hintText: StringConstants.selectDaysText,
                              title: StringConstants.selectDaysText,
                              list: searchStoreController.weekDaysList)
                          : height0SizedBox,
                    ),
                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        searchStoreController.validateAndSubmit();
                      },
                      height: 50,
                      text: StringConstants.updateText,
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
