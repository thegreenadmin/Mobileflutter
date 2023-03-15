import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_store_controller.dart';
import 'package:thegreenmall/dashboard/home/model/get_countries_model.dart';
import 'package:thegreenmall/dashboard/home/model/get_state_model.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/multi_drop_class.dart';

import '../../../utils/sizedbox_constants.dart';

class AddNewStoreScreen extends StatefulWidget {
  const AddNewStoreScreen({super.key});

  @override
  State<AddNewStoreScreen> createState() => _AddNewStoreScreenState();
}

class _AddNewStoreScreenState extends State<AddNewStoreScreen> {
  final AddNewStoreController addNewStoreController =
      Get.put(AddNewStoreController());

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
                                StringConstants.addStoreText,
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
            key: addNewStoreController.formKey,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.storeDetailsText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    height15SizedBox,
                    Text(
                      StringConstants.storeImageText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height20SizedBox,
                    Obx(
                      () => addNewStoreController
                              .storeImageDynamicLinkfromServer.value.isEmpty
                          ? InkWell(
                              onTap: () {
                                addNewStoreController
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
                                addNewStoreController
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
                                            addNewStoreController
                                                .storeImageDynamicLinkfromServer
                                                .value,
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    height20SizedBox,
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
                            addNewStoreController.storeNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStoreNameText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorMaxLines: 3,
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
                        controller: addNewStoreController.einTextController,
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
                            addNewStoreController.nickNameTextController,
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
                        controller:
                            addNewStoreController.storeEmailTextController,
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
                        controller:
                            addNewStoreController.storePhoneTextController,
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
                            addNewStoreController.addressLine1TextController,
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
                            addNewStoreController.addressLine2TextController,
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
                            addNewStoreController.townOrCityTextController,
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
                      StringConstants.zipCodeText,
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
                        controller: addNewStoreController.zipCodeTextController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterZipCodeText;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringConstants.zipCodeText,
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
                    height20SizedBox,
                    Text(
                      StringConstants.countryText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    Obx(() => addNewStoreController.countriesList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<CountriesList>(
                            isExpanded: true,
                            value: addNewStoreController.countriesList.last,
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
                            items: addNewStoreController.countriesList
                                .map<DropdownMenuItem<CountriesList>>(
                                    (CountriesList value) {
                              return DropdownMenuItem<CountriesList>(
                                value: value,
                                child: Text(value.countryName.toString()),
                              );
                            }).toList(),
                            onChanged: (CountriesList? newValue) {
                              setState(() {
                                addNewStoreController.countryDropdownValue
                                    .value = newValue!.countryName.toString();
                                addNewStoreController.countryId!.value =
                                    newValue.countryId.toString();
                                addNewStoreController.apiGetStates();
                                print(addNewStoreController.countryId!.value);
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
                    Obx(() => addNewStoreController.statesList.isEmpty
                        ? height0SizedBox
                        : DropdownButtonFormField<StatesList>(
                            isExpanded: true,
                            value: addNewStoreController.statesList.last,
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
                            items: addNewStoreController.statesList
                                .map<DropdownMenuItem<StatesList>>(
                                    (StatesList value) {
                              return DropdownMenuItem<StatesList>(
                                value: value,
                                child: Text(value.stateName.toString()),
                              );
                            }).toList(),
                            onChanged: (StatesList? newValue) {
                              setState(() {
                                addNewStoreController.stateDropdownValue.value =
                                    newValue!.stateName.toString();
                                addNewStoreController.stateId.value =
                                    newValue.stateId.toString();
                                debugPrint(addNewStoreController.stateId.value);
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
                                  groupValue: addNewStoreController
                                      .radioGroupValue.value,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    addNewStoreController.radioGroupValue
                                        .value = value?.toInt() ?? 0;
                                    addNewStoreController.is247Time.value =
                                        false;
                                    print(addNewStoreController
                                        .radioGroupValue.value);
                                    print(
                                        addNewStoreController.is247Time.value);
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
                                  groupValue: addNewStoreController
                                      .radioGroupValue.value,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    addNewStoreController.radioGroupValue
                                        .value = value?.toInt() ?? 0;
                                    addNewStoreController.is247Time.value =
                                        true;
                                    print(addNewStoreController
                                        .radioGroupValue.value);
                                    print(
                                        addNewStoreController.is247Time.value);
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
                      () => addNewStoreController.is247Time.value != true
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
                                          controller: addNewStoreController
                                              .openingTimeTextController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseSelectOpeningTimeText;
                                            } else if (value.trim() ==
                                                addNewStoreController
                                                    .closingTimeTextController
                                                    .text) {
                                              return AlertStringConstants
                                                  .openingTimeAlertText;
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            if (addNewStoreController
                                                    .is247Time.value !=
                                                true) {
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
                                                          const ColorScheme
                                                                  .light(
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
                                              addNewStoreController
                                                      .openingTimeTextController
                                                      .text =
                                                  date
                                                      .format(context)
                                                      .toString();

                                              addNewStoreController
                                                      .openingTime.value =
                                                  "${date.hour}:${date.minute}:00";

                                              print(
                                                  "${date.hour}:${date.minute}:00");
                                            }
                                          },
                                          decoration: InputDecoration(
                                            errorMaxLines: 3,
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
                                          controller: addNewStoreController
                                              .closingTimeTextController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseSelectClosingTimeText;
                                            } else if (value.trim() ==
                                                addNewStoreController
                                                    .openingTimeTextController
                                                    .text) {
                                              return AlertStringConstants
                                                  .closingTimeAlertText;
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            if (addNewStoreController
                                                    .is247Time.value !=
                                                true) {
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
                                                          const ColorScheme
                                                                  .light(
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
                                              addNewStoreController
                                                      .closingTimeTextController
                                                      .text =
                                                  date
                                                      .format(context)
                                                      .toString();
                                              addNewStoreController
                                                      .closingTime.value =
                                                  "${date.hour}:${date.minute}:00";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            errorMaxLines: 3,
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
                    Obx(() => addNewStoreController.is247Time.value != true
                        ? Text(
                            StringConstants.workingDaysText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : height0SizedBox),
                    height4SizedBox,
                    Obx(
                      () => addNewStoreController.is247Time.value != true
                          ? MultiDropClass(
                              onChanged: (v) {
                                addNewStoreController.storeTimmingList.clear();
                                String selectedDays = "";
                                for (int i = 0;
                                    i <
                                        addNewStoreController
                                            .weekDaysList.length;
                                    i++) {
                                  if (addNewStoreController.weekDaysList[i]
                                      ['isSelected']) {
                                    if (selectedDays.isEmpty) {
                                      selectedDays =
                                          "${addNewStoreController.weekDaysList[i]['day']}";
                                    } else {
                                      selectedDays =
                                          "$selectedDays, ${addNewStoreController.weekDaysList[i]['day']}";
                                    }
                                    addNewStoreController.storeTimmingList.add({
                                      "is_24_hours_active": false,
                                      "day_of_week": (i + 1).toString(),
                                      "opening_time": addNewStoreController
                                          .openingTime.value,
                                      "closing_time": addNewStoreController
                                          .closingTime.value,
                                    });
                                  }
                                }
                                print("top list" + v.toString());
                                print("LISTTTTTTTTTTTTT" +
                                    addNewStoreController.storeTimmingList
                                        .toString());
                                addNewStoreController.workingDaysTextController
                                    .text = selectedDays;
                              },
                              controller: addNewStoreController
                                  .workingDaysTextController,
                              hintText: StringConstants.selectDaysText,
                              title: StringConstants.selectDaysText,
                              list: addNewStoreController.weekDaysList)
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
                        addNewStoreController.validateAndSubmit();
                      },
                      height: 50,
                      text: StringConstants.saveText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconL: false,
                      fontSize: 16,
                    ),
                    height20SizedBox,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
