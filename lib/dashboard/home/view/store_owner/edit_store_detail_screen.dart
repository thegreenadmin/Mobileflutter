import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/google_place_autocompleted.dart';
import 'package:thegreenmall/utils/utils.dart';

class EditStoreDetailScreen extends StatefulWidget {
  const EditStoreDetailScreen({super.key});

  @override
  State<EditStoreDetailScreen> createState() => _EditStoreDetailScreenState();
}

class _EditStoreDetailScreenState extends State<EditStoreDetailScreen> with GlobalVarMixin{
  final OwnerStoresController ownerStoreController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: buildBody(context),
    );
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
                child: LayoutBuilder(
                    builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child:  ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Form(
                          key: ownerStoreController.formKey,
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
                                  height20SizedBox,
                                  buildText(StringConstants.storeLogoText, StringConstants.starText,),

                                  height15SizedBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          flex: 4,
                                          child: Obx(() => ownerStoreController
                                                  .editStoreLogoDynamicLinkFromServer
                                                  .value
                                                  .isEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    ownerStoreController
                                                        .showSelectionDialog(context);
                                                    ownerStoreController
                                                        .isStoreLogoSelected.value = true;
                                                  },
                                                  child: Row(
                                                    children: [
                                                      DottedBorder(
                                                        color: AppColors.blackLight,
                                                        strokeWidth: 1,
                                                        dashPattern: const [4, 4],
                                                        child: FractionallySizedBox(
                                                          widthFactor: 1.0, // 80% of parent width
                                                          child: Container(
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
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    ownerStoreController
                                                        .showSelectionDialog(context);
                                                    ownerStoreController
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
                                                                  ownerStoreController
                                                                      .editStoreLogoDynamicLinkFromServer
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
                                                                )
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
                                                ownerStoreController
                                                    .showSelectionDialog(context);
                                                ownerStoreController
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
                                  buildText(StringConstants.storeBannerImageText, StringConstants.starText,),


                                  height15SizedBox,
                                  Obx(
                                    () => ownerStoreController
                                            .editStoreImageDynamicLinkFromServer.value.isEmpty
                                        ? InkWell(
                                            onTap: () {
                                              ownerStoreController
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
                                                    width: WidgetConstants.screenWidth * 0.85,
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
                                              ownerStoreController
                                                  .showSelectionDialog(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                DottedBorder(
                                                  color: AppColors.blackLight,
                                                  strokeWidth: 1,
                                                  dashPattern: const [4, 4],
                                                  child: CommonWidgets.cachedNetworkImage(
                                                    width: WidgetConstants.screenWidth * 0.85,
                                                    height: WidgetConstants.screenHeight * 0.2,
                                                    ownerStoreController
                                                        .editStoreImageDynamicLinkFromServer
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  height15SizedBox,buildText(StringConstants.storeNameText, StringConstants.starText,),



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
                                    controller: ownerStoreController.storeNameTextController,
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
                                    controller: ownerStoreController.einTextController,
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
                                  //NICK NAME
                                  CustomInputField(
                                    textInputAction: TextInputAction.next,
                                    isBorderOutline: false,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(35),
                                    ],
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    controller: ownerStoreController.nickNameTextController,
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
                                    controller: ownerStoreController.emailTextController,
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
                                  height20SizedBox, buildText(StringConstants.phoneNumberText, StringConstants.starText,),


                                  height4SizedBox,
                                  IntlPhoneField(
                                    initialCountryCode: 'US',
                                    controller: ownerStoreController.phoneTextController,
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
                                      hintStyle: TextStyle(
                                          color: AppColors.blackLight, fontSize: 15),
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
                                    initialValue: ownerStoreController.countryCode.value,
                                    // initialCountryCode:
                                    //     ownerStoreController.countryCode.value,
                                    onCountryChanged: (value) {
                                      ownerStoreController.countryCode.value =
                                          "+${value.dialCode}";
                                    },
                                    onChanged: (phone) {
                                      ownerStoreController.phoneNumber.value =
                                          phone.number.toString();
                                      ownerStoreController.countryCode.value =
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
                                  height20SizedBox,buildText(StringConstants.addressLine1Text, StringConstants.starText,),

                                  height4SizedBox,
                                  //ADDRESS LINE 1 TEXT
                                  GooglePlaceAutocompleteField(
                                    apiKey: ownerStoreController.kGoogleApiKey,
                                       validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return AlertStringConstants
                                                  .pleaseEnterAddressText;
                                            }
                                            return null;
                                          },
                                    controller: ownerStoreController.addressLine1TextController,
                                    onPlaceSelected: (Place place) {
                                      ownerStoreController.getLng =
                                          place.latLng?.lng.toString();
                                      ownerStoreController.getLat =
                                          place.latLng?.lat.toString();
                                      final components = place.addressComponents ?? [];

                                      String? getComponent(String type) {
                                        return components
                                            .firstWhere((c) => c.types.contains(type), orElse: () => AddressComponent( name: '', shortName: '', types: [], ))
                                            .name;
                                      }

                                      ownerStoreController.townOrCityTextController.text =
                                          getComponent('locality') ?? '';

                                      ownerStoreController.countryTextController.text =
                                          getComponent('country') ?? '';

                                      ownerStoreController.stateTextController.text =
                                          getComponent('administrative_area_level_1') ?? '';

                                      ownerStoreController.update();
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:  AppColors.transparent,
                                      errorStyle: const TextStyle(color: AppColors.red),
                                      errorMaxLines: 3,
                                      errorBorder:  CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color:  AppColors.red),
                                      focusedErrorBorder:  CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color:  AppColors.primary),
                                      hintText: StringConstants.addressLine1Text,
                                      hintStyle:
                                      const TextStyle(color: AppColors.grey, fontSize: 14),
                                      contentPadding:
                                      EdgeInsets.only(
                                          left: 0,
                                          top: WidgetConstants.screenHeight * 0.022,
                                          bottom: WidgetConstants.screenWidth * 0.034,
                                          right: 0),
                                      isDense: true,

                                      border:  CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color: AppColors.primary),
                                      enabledBorder: CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color:  AppColors.grey),
                                      focusedBorder: CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color:  AppColors.primary),
                                      disabledBorder:CommonWidgets.underlineInputBorder(
                                          borderRadius:  0.0,
                                          color:  AppColors.primary),
                                    ),
                                    // textCapitalization: TextCapitalization.words,
                                    textStyle: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),

                                  ),
                                 /* CustomInputField(
                                    onTap: () async {
                                                              Prediction? p = await PlacesAutocomplete.show(
                                          offset: 0,
                                          radius: 1000,
                                          types: [],
                                          strictbounds: false,
                                          context: context,
                                          apiKey: ownerStoreController.kGoogleApiKey,
                                          mode: Mode.overlay,
                                          language: "en",
                                          components: []);
                                                              if (p?.description != null) {
                                        int idx = p?.description?.indexOf(",") ?? 0;
                                        List parts = [
                                          p?.description?.substring(0, idx).trim(),
                                          p?.description?.substring(idx + 1).trim()
                                        ];
                                        ownerStoreController.addressLine1TextController
                                            .text = parts[0].toString();
                                      }

                                      ///ADDRESSES BY GoogleMapsGeocoding

                                      final geocoding = GoogleMapsGeocoding(
                                          apiKey: ownerStoreController.kGoogleApiKey);

                                      GeocodingResponse response = await geocoding
                                          .searchByAddress(p?.description.toString() ?? "");

                                      final result = response.results.isNotEmpty
                                          ? response.results.first
                                          : null;


                                      if (result != null) {
                                        ownerStoreController.townOrCityTextController.text =
                                            Utility.extractLocality(result, "locality");
                                        ownerStoreController.countryTextController.text =
                                            Utility.extractLocality(result, "country");
                                        ownerStoreController.postalCodeTextController.text =
                                            Utility.extractLocality(result, "postal_code");
                                        ownerStoreController.stateTextController.text =
                                            Utility.extractLocality(
                                                result, "administrative_area_level_1");
                                        ownerStoreController.lng =
                                            response.results.first.geometry.location.lng;
                                        ownerStoreController.lat =
                                            response.results.first.geometry.location.lat;
                                      }

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
                                        ownerStoreController.addressLine1TextController,
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
                                  ),*/
                                  height20SizedBox,
                                  Text(
                                    StringConstants.addressLine2Text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  height4SizedBox,
                                  //ADDRESS LINE 2 FIELD
                                  CustomInputField(
                                    textInputAction: TextInputAction.next,
                                    isBorderOutline: false,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(200),
                                    ],
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    controller:
                                        ownerStoreController.addressLine2TextController,
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
                                    controller: ownerStoreController.townOrCityTextController,
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
                                    controller: ownerStoreController.postalCodeTextController,
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
                                  height20SizedBox, buildText(StringConstants.zoneText, StringConstants.starText,),

                                  //STATE FIELD
                                  CustomInputField(
                                    textInputAction: TextInputAction.next,
                                    isBorderOutline: false,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    controller: ownerStoreController.stateTextController,
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
                                        return AlertStringConstants.pleaseEnterStateText;
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
                                    controller: ownerStoreController.countryTextController,
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
                                                groupValue: ownerStoreController
                                                    .radioGroupValue.value,
                                                activeColor: AppColors.primary,
                                                onChanged: (value) {
                                                  ownerStoreController.radioGroupValue.value =
                                                      value?.toInt() ?? 0;
                                                  ownerStoreController.is247Time.value =
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
                                                groupValue: ownerStoreController
                                                    .radioGroupValue.value,
                                                activeColor: AppColors.primary,
                                                onChanged: (value) {
                                                  ownerStoreController.radioGroupValue.value =
                                                      value?.toInt() ?? 0;
                                                  ownerStoreController.is247Time.value = true;
                                                  ownerStoreController.storeTimingList
                                                      .clear();
                                                  ownerStoreController.storeTimings.clear();
                                                  ownerStoreController
                                                      .openingTimeTextController
                                                      .clear();
                                                  ownerStoreController
                                                      .closingTimeTextController
                                                      .clear();
                                                  ownerStoreController
                                                      .workingDaysTextController
                                                      .clear();
                                                  for (var element
                                                      in ownerStoreController.weekDaysList) {
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
                                  height25SizedBox,
                                  Obx(
                                    () => ownerStoreController.is247Time.value != true
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
                                                    //OPENING TIME FIELD
                                                    CustomInputField(
                                                      onTap: () async {
                                                        TimeOfDay date = TimeOfDay.now();
                                                        FocusScope.of(context)
                                                            .requestFocus(FocusNode());
                                                        date = (await showTimePicker(
                                                          initialEntryMode:
                                                              TimePickerEntryMode.input,
                                                          helpText: "Select Time",
                                                          initialTime: TimeOfDay.now(),
                                                          context: context,
                                                          builder: (context, child) {
                                                            return Theme(
                                                              data:
                                                                  ThemeData.light().copyWith(
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

                                                        ownerStoreController
                                                                .openingTimeTextController
                                                                .text =
                                                            date.format(context).toString();
                                                        ownerStoreController.storeTimingList
                                                            .clear();
                                                        if (ownerStoreController
                                                            .storeTimings.isNotEmpty) {
                                                          for (int i = 0;
                                                              i <
                                                                  ownerStoreController
                                                                      .weekDaysList.length;
                                                              i++) {
                                                            for (var element
                                                                in ownerStoreController
                                                                    .storeTimings) {
                                                              if (element["day_of_week"] ==
                                                                  ownerStoreController
                                                                      .weekDaysList[i].id) {
                                                                element["status"] =
                                                                    ownerStoreController
                                                                                .weekDaysList[
                                                                                    i]
                                                                                .isSelected ==
                                                                            true
                                                                        ? "active"
                                                                        : "deleted";
                                                                element["opening_time"] =
                                                                    Utility.formatDateTime(
                                                                            ownerStoreController
                                                                                .openingTimeTextController
                                                                                .text
                                                                                .trim(),
                                                                            firstFormat:
                                                                                "hh:mm a",
                                                                            secFormat:
                                                                                "HH:mm:ss")
                                                                        .toString();
                                                                element["closing_time"] =
                                                                    Utility.formatDateTime(
                                                                            ownerStoreController
                                                                                .closingTimeTextController
                                                                                .text
                                                                                .trim(),
                                                                            firstFormat:
                                                                                "hh:mm a",
                                                                            secFormat:
                                                                                "HH:mm:ss")
                                                                        .toString();
                                                                ownerStoreController
                                                                    .storeTimingList
                                                                    .add(element);
                                                                /* ownerStoreController
                                                                      .storeTimingList
                                                                      .add({
                                                                    "store_timing_id": element[
                                                                        "store_timing_id"],
                                                                    "is_24_hours_active":
                                                                        false,
                                                                    "status": ownerStoreController
                                                                                .weekDaysList[
                                                                                    i]
                                                                                .isSelected ==
                                                                            true
                                                                        ? "active"
                                                                        : "deleted",
                                                                    "day_of_week":
                                                                        ownerStoreController
                                                                            .weekDaysList[i]
                                                                            .id,
                                                                    "opening_time": Utility
                                                                            .formatDateTime(
                                                                                ownerStoreController
                                                                                    .openingTimeTextController
                                                                                    .text
                                                                                    .trim(),
                                                                                firstFormat:
                                                                                    "hh:mm a",
                                                                                secFormat:
                                                                                    "hh:mm:ss")
                                                                        .toString(),
                                                                    "closing_time": Utility
                                                                            .formatDateTime(
                                                                                ownerStoreController
                                                                                    .closingTimeTextController
                                                                                    .text
                                                                                    .trim(),
                                                                                firstFormat:
                                                                                    "hh:mm a",
                                                                                secFormat:
                                                                                    "hh:mm:ss")
                                                                        .toString()
                                                                  });*/
                                                              }
                                                            }
                                                          }
                                                        }
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
                                                      controller: ownerStoreController
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
                                                            ownerStoreController
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
                                                        TimeOfDay date = TimeOfDay.now();
                                                        FocusScope.of(context)
                                                            .requestFocus(FocusNode());
                                                        date = (await showTimePicker(
                                                          initialEntryMode:
                                                              TimePickerEntryMode.input,
                                                          helpText: "Select Time",
                                                          initialTime: TimeOfDay.now(),
                                                          context: context,
                                                          builder: (context, child) {
                                                            return Theme(
                                                              data:
                                                                  ThemeData.light().copyWith(
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
                                                        ownerStoreController
                                                                .closingTimeTextController
                                                                .text =
                                                            date.format(context).toString();
                                                        ownerStoreController.storeTimingList
                                                            .clear();
                                                        if (ownerStoreController
                                                            .storeTimings.isNotEmpty) {
                                                          for (int i = 0;
                                                              i <
                                                                  ownerStoreController
                                                                      .weekDaysList.length;
                                                              i++) {
                                                            for (var element
                                                                in ownerStoreController
                                                                    .storeTimings) {
                                                              if (element["day_of_week"] ==
                                                                  ownerStoreController
                                                                      .weekDaysList[i].id) {
                                                                element["status"] =
                                                                    ownerStoreController
                                                                                .weekDaysList[
                                                                                    i]
                                                                                .isSelected ==
                                                                            true
                                                                        ? "active"
                                                                        : "deleted";
                                                                element["opening_time"] =
                                                                    Utility.formatDateTime(
                                                                            ownerStoreController
                                                                                .openingTimeTextController
                                                                                .text
                                                                                .trim(),
                                                                            firstFormat:
                                                                                "hh:mm a",
                                                                            secFormat:
                                                                                "HH:mm:ss")
                                                                        .toString();
                                                                element["closing_time"] =
                                                                    Utility.formatDateTime(
                                                                            ownerStoreController
                                                                                .closingTimeTextController
                                                                                .text
                                                                                .trim(),
                                                                            firstFormat:
                                                                                "hh:mm a",
                                                                            secFormat:
                                                                                "HH:mm:ss")
                                                                        .toString();
                                                                ownerStoreController
                                                                    .storeTimingList
                                                                    .add(element);
                                                                /* ownerStoreController
                                                                      .storeTimingList
                                                                      .add({
                                                                    "store_timing_id": element[
                                                                        "store_timing_id"],
                                                                    "is_24_hours_active":
                                                                        false,
                                                                    "status": ownerStoreController
                                                                                .weekDaysList[
                                                                                    i]
                                                                                .isSelected ==
                                                                            true
                                                                        ? "active"
                                                                        : "deleted",
                                                                    "day_of_week":
                                                                        ownerStoreController
                                                                            .weekDaysList[i]
                                                                            .id,
                                                                    "opening_time": Utility
                                                                            .formatDateTime(
                                                                                ownerStoreController
                                                                                    .openingTimeTextController
                                                                                    .text
                                                                                    .trim(),
                                                                                firstFormat:
                                                                                    "hh:mm a",
                                                                                secFormat:
                                                                                    "hh:mm:ss")
                                                                        .toString(),
                                                                    "closing_time": Utility
                                                                            .formatDateTime(
                                                                                ownerStoreController
                                                                                    .closingTimeTextController
                                                                                    .text
                                                                                    .trim(),
                                                                                firstFormat:
                                                                                    "hh:mm a",
                                                                                secFormat:
                                                                                    "hh:mm:ss")
                                                                        .toString()
                                                                  });*/
                                                              }
                                                            }
                                                          }
                                                        }
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
                                                      controller: ownerStoreController
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
                                                            ownerStoreController
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
                                  height20SizedBox,
                                  Obx(() => ownerStoreController.is247Time.value != true
                                      ?
                                  buildText(StringConstants.workingDaysText, StringConstants.starText,)


                                      : height0SizedBox),
                                  height4SizedBox,
                                  Obx(
                                    () => ownerStoreController.is247Time.value != true
                                        ? MultiCustomDropDown(
                                            onChanged: (v) {
                                              ownerStoreController.storeTimingList.clear();
                                              if (ownerStoreController
                                                  .storeTimings.isNotEmpty) {
                                                for (int i = 0;
                                                    i <
                                                        ownerStoreController
                                                            .weekDaysList.length;
                                                    i++) {
                                                  for (var element
                                                      in ownerStoreController.storeTimings) {
                                                    if (element["day_of_week"] ==
                                                        ownerStoreController
                                                            .weekDaysList[i].id) {
                                                      ownerStoreController.storeTimingList
                                                          .add({
                                                        "store_timing_id":
                                                            element["store_timing_id"],
                                                        "is_24_hours_active": false,
                                                        "status": ownerStoreController
                                                                    .weekDaysList[i]
                                                                    .isSelected ==
                                                                true
                                                            ? "active"
                                                            : "deleted",
                                                        "day_of_week": ownerStoreController
                                                            .weekDaysList[i].id,
                                                        "opening_time": Utility.formatDateTime(
                                                                ownerStoreController
                                                                    .openingTimeTextController
                                                                    .text
                                                                    .trim(),
                                                                firstFormat: "hh:mm a",
                                                                secFormat: "HH:mm:ss")
                                                            .toString(),
                                                        "closing_time": Utility.formatDateTime(
                                                                ownerStoreController
                                                                    .closingTimeTextController
                                                                    .text
                                                                    .trim(),
                                                                firstFormat: "hh:mm a",
                                                                secFormat: "HH:mm:ss")
                                                            .toString()
                                                      });
                                                    }
                                                  }
                                                  if (ownerStoreController
                                                          .weekDaysList[i].isSelected ==
                                                      true) {
                                                    if (!ownerStoreController.storeTimingList
                                                        .any((element) =>
                                                            element["day_of_week"] ==
                                                            ownerStoreController
                                                                .weekDaysList[i].id)) {
                                                      ownerStoreController.storeTimingList
                                                          .add({
                                                        "store_timing_id": null,
                                                        "is_24_hours_active": false,
                                                        "status": "active",
                                                        "day_of_week": ownerStoreController
                                                            .weekDaysList[i].id,
                                                        "opening_time": Utility.formatDateTime(
                                                                ownerStoreController
                                                                    .openingTimeTextController
                                                                    .text
                                                                    .trim(),
                                                                firstFormat: "hh:mm a",
                                                                secFormat: "HH:mm:ss")
                                                            .toString(),
                                                        "closing_time": Utility.formatDateTime(
                                                                ownerStoreController
                                                                    .closingTimeTextController
                                                                    .text
                                                                    .trim(),
                                                                firstFormat: "hh:mm a",
                                                                secFormat: "HH:mm:ss")
                                                            .toString()
                                                      });
                                                    }
                                                  }
                                                }
                                              } else {
                                                for (int i = 0;
                                                    i <
                                                        ownerStoreController
                                                            .weekDaysList.length;
                                                    i++) {
                                                  if (ownerStoreController
                                                          .weekDaysList[i].isSelected ==
                                                      true) {
                                                    ownerStoreController.storeTimingList.add({
                                                      "store_timing_id": null,
                                                      "is_24_hours_active": false,
                                                      "status": "active",
                                                      "day_of_week": ownerStoreController
                                                          .weekDaysList[i].id,
                                                      "opening_time": ownerStoreController
                                                          .openingTimeTextController.text
                                                          .trim(),
                                                      "closing_time": ownerStoreController
                                                          .closingTimeTextController.text
                                                          .trim()
                                                    });
                                                  }
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
                                            controller: ownerStoreController
                                                .workingDaysTextController,
                                            hintText: StringConstants.selectDaysText,
                                            title: StringConstants.selectDaysText,
                                            list: ownerStoreController.weekDaysList)
                                        : height0SizedBox,
                                  ),
                                  height15SizedBox,
                                  buildText(StringConstants.deliveryMethodsText, StringConstants.starText,),


                                  height4SizedBox,
                                  MultiCustomDropDown(
                                      onChanged: (v) {
                                        ownerStoreController.deliveryServicesList.clear();
                                        if (ownerStoreController
                                            .storeDeliveryServices.isNotEmpty) {
                                          for (int i = 0;
                                              i <
                                                  ownerStoreController
                                                      .deliveryServices.length;
                                              i++) {
                                            for (var element in ownerStoreController
                                                .storeDeliveryServices) {
                                              if (element["delivery_service_id"] ==
                                                  ownerStoreController
                                                      .deliveryServices[i].id) {
                                                ownerStoreController.deliveryServicesList
                                                    .add({
                                                  "store_delivery_service_id":
                                                      element["store_delivery_service_id"],
                                                  "delivery_service_id": ownerStoreController
                                                      .deliveryServices[i].id,
                                                  "is_enabled": ownerStoreController
                                                      .deliveryServices[i].isSelected,
                                                  "status": "active"
                                                });
                                              }
                                            }

                                            if (ownerStoreController
                                                        .deliveryServices[i].isSelected ==
                                                    true &&
                                                !ownerStoreController.storeDeliveryServices
                                                    .any((element) =>
                                                        element["delivery_service_id"] ==
                                                        ownerStoreController
                                                            .deliveryServices[i].id)) {
                                              ownerStoreController.deliveryServicesList.add({
                                                "delivery_service_id": ownerStoreController
                                                    .deliveryServices[i].id,
                                                "is_enabled": ownerStoreController
                                                    .deliveryServices[i].isSelected,
                                                "status": "active"
                                              });
                                            }
                                          }
                                        } else {
                                          for (int i = 0;
                                              i <
                                                  ownerStoreController
                                                      .deliveryServices.length;
                                              i++) {
                                            if (ownerStoreController
                                                    .deliveryServices[i].isSelected ==
                                                true) {
                                              ownerStoreController.deliveryServicesList.add({
                                                "store_delivery_service_id": null,
                                                "delivery_service_id": ownerStoreController
                                                    .deliveryServices[i].id,
                                                "is_enabled": ownerStoreController
                                                    .deliveryServices[i].isSelected,
                                                "status": "active"
                                              });
                                            }
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
                                      controller:
                                          ownerStoreController.deliveryServicesTextController,
                                      hintText: StringConstants.selectDeliveryServicesText,
                                      title: StringConstants.selectDeliveryServicesText,
                                      list: ownerStoreController.deliveryServices),
                                  height20SizedBox,
                                  buildText(StringConstants.storeTermsText, "",),

                                  height4SizedBox,
                                  //TERMS FIELD
                                  CustomInputField(
                                    maxLines: null,
                                    onTap: () {
                                      ownerStoreController.isTermsSelected.value = true;
                                      ownerStoreController.filePicker();
                                    },
                                    textInputAction: TextInputAction.next,
                                    isBorderOutline: false,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(25),
                                    ],
                                    autofocus: false,
                                    controller: ownerStoreController.storeTermsTextController,
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
                                          ownerStoreController.isTermsSelected.value = true;
                                          ownerStoreController.filePicker();
                                        },
                                        icon: const Icon(Icons.attach_file_rounded)),
                                  ),

                                  height20SizedBox,
                                  buildText(StringConstants.storePrivacyText, "",),

                                  height4SizedBox,
                                  //PRIVACY FIELD
                                  CustomInputField(
                                    maxLines: null,
                                    onTap: () {
                                      ownerStoreController.isTermsSelected.value = false;
                                      ownerStoreController.filePicker();
                                    },
                                    textInputAction: TextInputAction.next,
                                    isBorderOutline: false,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(25),
                                    ],
                                    autofocus: false,
                                    controller:
                                        ownerStoreController.storePrivacyTextController,
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
                                          ownerStoreController.isTermsSelected.value = false;
                                          ownerStoreController.filePicker();
                                        },
                                        icon: const Icon(Icons.attach_file_rounded)),
                                  ),
                                  height20SizedBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            StringConstants.enableStoreText,
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
                                            value: ownerStoreController.isEnabled.value,
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
                                              ownerStoreController.isEnabled.value = val;
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
                                      if (ownerStoreController.isLoading.value != true) {

                                        ownerStoreController.validateAndSubmit();
                                      }
                                    },
                                    height: 50,
                                    text:
                                        "${StringConstants.updateText} ${StringConstants.storeText}",
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
                    );
                  }
                ),
              ),
            ),

          ],
        ),
        //LOADING OVERLAY
        Obx(() {
          return ownerStoreController.isLoading.value
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
                        Image.asset(
                          ImageConstants.homeMall,
                          scale: 4,
                        ),
                        width10SizedBox,
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
                          StringConstants.editStoreText,
                          style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ])),
        ));
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
