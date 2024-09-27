import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/add_new_store_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class AddNewStoreScreen extends StatefulWidget {
  const AddNewStoreScreen({super.key});

  @override
  State<AddNewStoreScreen> createState() => _AddNewStoreScreenState();
}

class _AddNewStoreScreenState extends State<AddNewStoreScreen> with GlobalVarMixin{
  final AddNewStoreController addNewStoreController =
      Get.put(AddNewStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  GestureDetector buildBody(BuildContext context) {
    return GestureDetector(
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
                  //STORE LOGO TEXT

                  buildText(StringConstants.storeLogoText, StringConstants.starText,),


                  height15SizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 4,
                          child: Obx(() => addNewStoreController
                                  .storeLogoDynamicLinkFromServer
                                  .value
                                  .isEmpty
                              ? InkWell(
                                  onTap: () {
                                    addNewStoreController
                                        .showSelectionDialog(context);
                                    addNewStoreController
                                        .isStoreLogoSelected.value = true;
                                  },
                                  child: Row(
                                    children: [
                                      DottedBorder(
                                        color: AppColors.blackLight,
                                        strokeWidth: 1,
                                        dashPattern: const [4, 4],
                                        child: Container(
                                          width: WidgetConstants.screenWidth *
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
                                                  ImageConstants.uploadpic,
                                                  scale: 2.5,
                                                ),
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
                                    addNewStoreController
                                        .isStoreLogoSelected.value = true;
                                  },
                                  child: Row(
                                    children: [
                                      DottedBorder(
                                        color: AppColors.blackLight,
                                        strokeWidth: 1,
                                        dashPattern: const [4, 4],
                                        child: Container(
                                          width: WidgetConstants.screenWidth *
                                              0.3,
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          color: AppColors.primaryLight,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CommonWidgets
                                                    .cachedNetworkImage(
                                                  addNewStoreController
                                                      .storeLogoDynamicLinkFromServer
                                                      .value,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => SizedBox(
                                                      width: WidgetConstants
                                                              .screenWidth *
                                                          0.85,
                                                      height: WidgetConstants
                                                              .screenHeight *
                                                          0.2,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator())),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                      width20SizedBox,
                      Flexible(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(StringConstants.uploadStoreLogoText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            height10SizedBox,
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                addNewStoreController
                                    .showSelectionDialog(context);
                                addNewStoreController
                                    .isStoreLogoSelected.value = true;
                              },
                              child: Image.asset(
                                ImageConstants.picupload,
                                scale: 2.5,
                              ),
                            ),
                            height10SizedBox,
                          ],
                        ),
                      )
                    ],
                  ),
                  height20SizedBox,
                  //STORE BANNER TEXT
                  buildText(StringConstants.storeBannerImageText, StringConstants.starText,),


                  height15SizedBox,
                  Obx(
                    () => addNewStoreController
                            .storeImageDynamicLinkFromServer.value.isEmpty
                        ? InkWell(
                            onTap: () {
                              addNewStoreController
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
                                    width: WidgetConstants.screenWidth * 0.80,
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
                                              .tapToUploadStoreImageText)
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
                                  color: AppColors.blackLight,
                                  strokeWidth: 1,
                                  dashPattern: const [4, 4],
                                  child: Container(
                                      width:
                                          WidgetConstants.screenWidth * 0.80,
                                      height:
                                          WidgetConstants.screenHeight * 0.2,
                                      color: AppColors.primaryLight,
                                      child: CommonWidgets.cachedNetworkImage(
                                        addNewStoreController
                                            .storeImageDynamicLinkFromServer
                                            .value,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => SizedBox(
                                            width:
                                                WidgetConstants.screenWidth *
                                                    0.85,
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
                  height20SizedBox,
                  buildText(StringConstants.storeNameText, StringConstants.starText,),

                  height4SizedBox,
                  //STORE NAME FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: addNewStoreController.storeNameTextController,
                    hintText: StringConstants.storeNameText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterStoreNameText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.einBusinessId, StringConstants.starText,),


                  height4SizedBox,
                  //EIN NUMBER FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
                    ],
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: addNewStoreController.einTextController,
                    hintText: StringConstants.einBusinessId,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterEinText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  Text(
                    StringConstants.nickNameText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  height4SizedBox,
                  //NICK NAME FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(35),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller:
                        addNewStoreController.storeNickNameTextController,
                    hintText: StringConstants.nickNameText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.emailIdText, StringConstants.starText,),

                  height4SizedBox,
                  //EMAIL FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    controller:
                        addNewStoreController.storeEmailTextController,
                    hintText: StringConstants.emailText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterEmailText;
                      } else if (!GetUtils.isEmail(value.trim())) {
                        return AlertStringConstants.pleaseEnterValidEmailText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,

                  buildText(StringConstants.phoneNumberText, StringConstants.starText,),


                  height4SizedBox,
                  //MOBILE FIELD
                  IntlPhoneField(
                    initialCountryCode: 'US',
                    controller:
                        addNewStoreController.storePhoneTextController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    showDropdownIcon: false,
                    flagsButtonMargin: const EdgeInsets.all(10),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        ImageConstants.calling,
                      ),
                      alignLabelWithHint: true,
                      hintText: StringConstants.phoneNumberText,
                      hintStyle: const TextStyle(
                          color: AppColors.grey, fontSize: 14),
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
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
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
                    ),
                    onCountryChanged: (value) {
                      addNewStoreController.countryCode.value =
                          "+${value.dialCode}";
                    },
                    onChanged: (phone) {
                      addNewStoreController.phoneNumber.value =
                          phone.number.toString();
                      addNewStoreController.countryCode.value =
                          phone.countryCode.toString();
                    },
                  ),
                  height20SizedBox,
                  Text(
                    StringConstants.addressText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  height20SizedBox,
                  buildText(StringConstants.addressLine1Text, StringConstants.starText,),
                  height4SizedBox,
                  //ADDRESS LINE 1 TEXT
                  CustomInputField(
                    onTap: () async {
                      Prediction? p = await PlacesAutocomplete.show(
                          offset: 0,
                          radius: 1000,
                          types: [],
                          strictbounds: false,
                          context: context,
                          apiKey: addNewStoreController.kGoogleApiKey,
                          mode: Mode.overlay,
                          language: "en",
                          components: []);
                      debugPrint(
                          "ADDRESSES---description->${p?.description}");
                      if (p?.description != null) {
                        int idx = p?.description?.indexOf(",") ?? 0;
                        List parts = [
                          p?.description?.substring(0, idx).trim(),
                          p?.description?.substring(idx + 1).trim()
                        ];
                        addNewStoreController.addressLine1TextController
                            .text = parts[0].toString();
                      }

                      ///ADDRESSES BY GoogleMapsGeocoding

                      final geocoding = GoogleMapsGeocoding(
                          apiKey: addNewStoreController.kGoogleApiKey);

                      GeocodingResponse response = await geocoding
                          .searchByAddress(p?.description.toString() ?? "");

                      final result = response.results.isNotEmpty
                          ? response.results.first
                          : null;

                      debugPrint(
                          "ADDRESSES---lat lng ->${jsonEncode(result)}");
                      debugPrint(
                          "ADDRESSES---lat  ->${response.results.first.geometry.location.lat}");
                      debugPrint(
                          "ADDRESSES--- lng ->${response.results.first.geometry.location.lng}");

                      if (result != null) {
                        addNewStoreController.townOrCityTextController.text =
                            Utility.extractLocality(result, "locality");
                        addNewStoreController.countryTextController.text =
                            Utility.extractLocality(result, "country");
                        addNewStoreController.zipCodeTextController.text =
                            Utility.extractLocality(result, "postal_code");
                        addNewStoreController.stateTextController.text =
                            Utility.extractLocality(
                                result, "administrative_area_level_1");
                        addNewStoreController.lng =
                            response.results.first.geometry.location.lng;
                        addNewStoreController.lat =
                            response.results.first.geometry.location.lat;
                      }
                      /*List<geocoding.Location> locations =
                            await geocoding.locationFromAddress(
                                p?.description.toString() ?? "");

                        List<geocoding.Placemark> placeMark =
                            await geocoding.placemarkFromCoordinates(
                                locations.first.latitude,
                                locations.first.longitude);
                        String address =
                            "${placeMark.first.name ?? ""}, ${placeMark.first.subLocality ?? ""}, ${placeMark.first.locality ?? ""}, ${placeMark.first.administrativeArea ?? ""} ${placeMark.first.postalCode ?? ""}, ${placeMark.first.country ?? ""}";

                        debugPrint("ADDRESSES---->$address");

                        if (placeMark.isNotEmpty) {
                          addNewStoreController.townOrCityTextController
                              .text = placeMark.first.locality ?? "";

                          addNewStoreController.countryTextController.text =
                              placeMark.first.country ?? "";

                          addNewStoreController.zipCodeTextController.text =
                              placeMark.first.postalCode ?? "";

                          // addNewStoreController.stateTextController.text =
                          //     placeMark.first.administrativeArea ?? "";
                        }
                        if (locations.isNotEmpty) {
                          addNewStoreController.lng =
                              locations.first.longitude.toString();
                          addNewStoreController.lat =
                              locations.first.latitude.toString();
                        }*/

                      ///--------------------------------------
                      /* GeoData addresses =
                            await Geocoder2.getDataFromAddress(
                                address: p?.description.toString() ?? "",
                                googleMapApiKey:
                                    addNewStoreController.kGoogleApiKey);

                        if (addresses.state.isNotEmpty) {
                          addNewStoreController.stateTextController.text =
                              addresses.state;
                        }*/
                    },
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(1000),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    minLines: 1,
                    maxLines: 5,
                    controller:
                        addNewStoreController.addressLine1TextController,
                    hintText: StringConstants.addressLine1Text,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterAddressText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  Text(
                    StringConstants.addressLine2Text,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  height4SizedBox,
                  //ADDRESS LINE 2 TEXT
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(200),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller:
                        addNewStoreController.addressLine2TextController,
                    hintText: StringConstants.addressLine2Text,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.townOrCityText, StringConstants.starText,),

                  height4SizedBox,
                  //TOWN OR CITY FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(500),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller:
                        addNewStoreController.townOrCityTextController,
                    hintText: StringConstants.townOrCityText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterTownOrCityText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.postalCodeText, StringConstants.starText,),


                  height4SizedBox,
                  //ZIP CODE FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    controller: addNewStoreController.zipCodeTextController,
                    hintText: StringConstants.postalCodeText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterPostalCodeText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.zoneText, StringConstants.starText,),

                  height4SizedBox,
                  //STATE FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: addNewStoreController.stateTextController,
                    hintText: StringConstants.zoneText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterTownOrCityText;
                      }
                      return null;
                    },
                  ),
                  height20SizedBox,
                  buildText(StringConstants.countryText, StringConstants.starText,),


                  height4SizedBox,
                  //COUNTRY FIELD
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: addNewStoreController.countryTextController,
                    hintText: StringConstants.countryText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterCountry;
                      }
                      return null;
                    },
                  ),

                  height20SizedBox,
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
                                  addNewStoreController.storeTimingList
                                      .clear();
                                  addNewStoreController
                                      .openingTimeTextController
                                      .clear();
                                  addNewStoreController
                                      .closingTimeTextController
                                      .clear();
                                  addNewStoreController
                                      .workingDaysTextController
                                      .clear();
                                  for (var element
                                      in addNewStoreController.weekDaysList) {
                                    element.isSelected = false;
                                  }
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
                  Obx(
                    () => addNewStoreController.is247Time.value
                        ? height0SizedBox
                        : height25SizedBox,
                  ),
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
                                    buildText(StringConstants.openingTimeText, StringConstants.starText,),

                                    height4SizedBox,
                                    //OPENING TIME TEXTFORM FIELD
                                    CustomInputField(
                                      onTap: () async {
                                        await selectTimeAndSetController(
                                            addNewStoreController
                                                .openingTimeTextController,
                                            addNewStoreController
                                                .openingTime);
                                      },
                                      textInputAction: TextInputAction.next,
                                      isBorderOutline: false,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      autofocus: false,
                                      controller: addNewStoreController
                                          .openingTimeTextController,
                                      hintText:
                                          StringConstants.openingTimeText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 14),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
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
                                    ),
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
                                    buildText(StringConstants.closingTimeText, StringConstants.starText,),


                                    height4SizedBox,
                                    //CLOSING TIME TEXTFORM FIELD
                                    CustomInputField(
                                      onTap: () async {
                                        await selectTimeAndSetController(
                                            addNewStoreController
                                                .closingTimeTextController,
                                            addNewStoreController
                                                .closingTime);
                                      },
                                      textInputAction: TextInputAction.next,
                                      isBorderOutline: false,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      autofocus: false,
                                      controller: addNewStoreController
                                          .closingTimeTextController,
                                      hintText:
                                          StringConstants.closingTimeText,
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 14),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
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
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : height0SizedBox,
                  ),
                  Obx(
                    () => addNewStoreController.is247Time.value
                        ? height0SizedBox
                        : height20SizedBox,
                  ),
                  Obx(() => addNewStoreController.is247Time.value != true
                      ?
                  buildText(StringConstants.workingDaysText, StringConstants.starText,)


                      : height0SizedBox),
                  height4SizedBox,
                  Obx(
                    () => addNewStoreController.is247Time.value != true
                        ? MultiCustomDropDown(
                            onChanged: (v) {
                              addNewStoreController.storeTimingList.clear();

                              for (int i = 0;
                                  i <
                                      addNewStoreController
                                          .weekDaysList.length;
                                  i++) {
                                if (addNewStoreController
                                        .weekDaysList[i].isSelected ==
                                    true) {
                                  addNewStoreController.storeTimingList.add({
                                    "is_24_hours_active": false,
                                    "day_of_week": addNewStoreController
                                        .weekDaysList[i].id,
                                    "opening_time": addNewStoreController
                                        .openingTime.value,
                                    "closing_time": addNewStoreController
                                        .closingTime.value,
                                  });
                                }
                              }
                            },
                            validator: (v) {
                              if (v!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterWeekDaysText;
                              }
                              return null;
                            },
                            controller: addNewStoreController
                                .workingDaysTextController,
                            hintText: StringConstants.selectDaysText,
                            title: StringConstants.selectDaysText,
                            list: addNewStoreController.weekDaysList)
                        : height0SizedBox,
                  ),
                  height15SizedBox,
                  buildText(StringConstants.deliveryMethodsText, StringConstants.starText,),

                  height4SizedBox,
                  MultiCustomDropDown(
                      onChanged: (v) {
                        addNewStoreController.deliveryServicesList.clear();

                        for (int i = 0;
                            i < addNewStoreController.deliveryServices.length;
                            i++) {
                          if (addNewStoreController
                                  .deliveryServices[i].isSelected ==
                              true) {
                            addNewStoreController.deliveryServicesList.add({
                              "delivery_service_id": addNewStoreController
                                  .deliveryServices[i].id,
                              "is_enabled": true,
                              "status": "active"
                            });
                          }
                        }
                      },
                      validator: (v) {
                        if (v!.trim().isEmpty) {
                          return AlertStringConstants
                              .pleaseEnterDeliveryServicesText;
                        }
                        return null;
                      },
                      controller: addNewStoreController
                          .deliveryServicesTextController,
                      hintText: StringConstants.selectDeliveryServicesText,
                      title: StringConstants.selectDeliveryServicesText,
                      list: addNewStoreController.deliveryServices),
                  height15SizedBox,
                  buildText(StringConstants.storeTermsText, "",),

                  height4SizedBox,
                  //STORE TERMS FIELD
                  CustomInputField(
                    maxLines: null,
                    onTap: () {
                      addNewStoreController.isTermsSelected.value = true;
                      addNewStoreController.filePicker();
                    },
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
                    ],
                    autofocus: false,
                    controller: addNewStoreController.termsTextController,
                    keyboardType: TextInputType.text,
                    hintText: StringConstants.uploadStoreTermsAsPdfText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    /* validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterStoreTermsText;
                      }
                      return null;
                    },*/
                    suffixIcon: IconButton(
                        onPressed: () {
                          addNewStoreController.isTermsSelected.value = true;
                          addNewStoreController.filePicker();
                        },
                        icon: const Icon(Icons.attach_file_rounded)),
                  ),
                  height15SizedBox,
                  buildText(StringConstants.storePrivacyText, "",),
                  height4SizedBox,
                  //STORE PRIVACY TERMS
                  CustomInputField(
                    maxLines: null,
                    onTap: () {
                      addNewStoreController.isTermsSelected.value = false;
                      addNewStoreController.filePicker();
                    },
                    textInputAction: TextInputAction.next,
                    isBorderOutline: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
                    ],
                    autofocus: false,
                    controller: addNewStoreController.privacyTextController,
                    keyboardType: TextInputType.text,
                    hintText: StringConstants.uploadStorePolicyAsPdfText,
                    hintStyle:
                        const TextStyle(color: AppColors.grey, fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    /*validator: (value) {
                      if (value!.trim().isEmpty) {
                        return AlertStringConstants
                            .pleaseEnterStorePrivacyText;
                      }
                      return null;
                    },*/
                    suffixIcon: IconButton(
                        onPressed: () {
                          addNewStoreController.isTermsSelected.value = false;
                          addNewStoreController.filePicker();
                        },
                        icon: const Icon(Icons.attach_file_rounded)),
                  ),
                  height40SizedBox,
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      print(addNewStoreController.isLoading.value);
                      if (addNewStoreController.isLoading.value != true) {
                        addNewStoreController.isLoading.value = true;
                        addNewStoreController.validateAndSubmit();
                      }
                    },
                    height: 50,
                    text:
                        "${StringConstants.addText} ${StringConstants.storeText}",
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
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
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

                            Get.delete<AddNewStoreController>();
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
                      ImageConstants.homeMall,
                      scale: 4,
                    )
                  ])),
        ));
  }

  Future<void> selectTimeAndSetController(
      TextEditingController controller, RxString timeValue) async {
    if (addNewStoreController.is247Time.value != true) {
      TimeOfDay date = TimeOfDay.now();
      FocusScope.of(context).requestFocus(FocusNode());
      date = (await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        helpText: StringConstants.selectTimeText,
        initialTime: TimeOfDay.now(),
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      ))!;
      controller.text = date.format(context).toString();
      timeValue.value = "${date.hour}:${date.minute}:00";

      debugPrint("${date.hour}:${date.minute}:00");

      if (addNewStoreController.weekDaysList.isNotEmpty) {
        for (int i = 0; i < addNewStoreController.weekDaysList.length; i++) {
          if (addNewStoreController.weekDaysList[i].isSelected == true) {
            for (int j = 0;
                j < addNewStoreController.storeTimingList.length;
                j++) {
              if (timeValue == addNewStoreController.openingTime) {
                addNewStoreController.storeTimingList[j]["opening_time"] =
                    timeValue.value;
              } else if (timeValue == addNewStoreController.closingTime) {
                addNewStoreController.storeTimingList[j]["closing_time"] =
                    timeValue.value;
              }
            }
          }
        }
      }
    }
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
