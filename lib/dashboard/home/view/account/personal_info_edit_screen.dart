import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class PersonalInfoEditScreen extends StatefulWidget {
  const PersonalInfoEditScreen({super.key});

  @override
  State<PersonalInfoEditScreen> createState() => _PersonalInfoEditScreenState();
}

class _PersonalInfoEditScreenState extends State<PersonalInfoEditScreen> {
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back(id: pageIdApp.value);
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                color: AppColors.primarylight,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                    child: Text(
                                      StringConstants.personalInformationText,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                ImageConstants.homeMall,
                                scale: 5,
                              )
                            ]),
                      ],
                    )),
              )),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              child: Form(
                key: accountController.formKey,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.personalDetailText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        height15SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.firstNameText,
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.firstNameText,
                          textCapitalization: TextCapitalization.words,
                          controller: accountController.firstNameTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterFirstNameText;
                            }
                            return null;
                          },
                        ),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.lastNameText,
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.lastNameText,
                          textCapitalization: TextCapitalization.words,
                          controller: accountController.lastNameTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterLastNameText;
                            }
                            return null;
                          },
                        ),
                        height20SizedBox,
                        Text(
                          StringConstants.nickNameText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.nickNameText,
                          textCapitalization: TextCapitalization.words,
                          controller: accountController.nickNameTextController,
                          keyboardType: TextInputType.text,
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
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.addressLine1Text,
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          onTap: () async {
                            Prediction? p = await PlacesAutocomplete.show(
                                offset: 0,
                                radius: 1000,
                                types: [],
                                strictbounds: false,
                                context: context,
                                apiKey: accountController.kGoogleApiKey,
                                mode: Mode.overlay,
                                language: "en",
                                components: []);

                            if (p?.description != null) {
                              int idx = p?.description?.indexOf(",") ?? 0;
                              List parts = [
                                p?.description?.substring(0, idx).trim() ?? '',
                                p?.description?.substring(idx + 1).trim()
                              ];
                              accountController.addressLine1TextController
                                  .text = parts[0].toString();
                            }

                            ///ADDRESSES BY google_maps_webservice: ^0.0.19 COZ GEOCODING ios issues

                            final geocoding = GoogleMapsGeocoding(
                                apiKey: accountController.kGoogleApiKey);

                            GeocodingResponse response =
                                await geocoding.searchByAddress(
                                    p?.description.toString() ?? "");
                            final result = response.results.isNotEmpty
                                ? response.results.first
                                : null;
                            if (result != null) {
                              accountController.townOrCityTextController.text =
                                  Utility.extractLocality(result, "locality");
                              accountController.countryTextController.text =
                                  Utility.extractLocality(result, "country");
                              accountController.postalCodeTextController.text =
                                  Utility.extractLocality(
                                      result, "postal_code");
                              accountController.stateTextController.text =
                                  Utility.extractLocality(
                                      result, "administrative_area_level_1");
                            }

                            /// ADDRESSES BY GEOCODING COZ Geocodr2 RETURNS
                            /// subAdministrativeArea INSTEAD OF CITY
/*
                          List<geocodingPack.Location> locations =
                              await geocodingPack.locationFromAddress(
                                  p?.description.toString() ?? "");

                          List<geocodingPack.Placemark> placeMark =
                              await geocodingPack.placemarkFromCoordinates(
                                  locations.first.latitude,
                                  locations.first.longitude);
                          String address =
                              "${placeMark.first.name ?? ""}, ${placeMark.first.subLocality ?? ""}, ${placeMark.first.locality ?? ""}, ${placeMark.first.administrativeArea ?? ""} ${placeMark.first.postalCode ?? ""}, ${placeMark.first.country ?? ""}";

                          debugPrint("ADDRESSES---->$address");

                          if (placeMark.isNotEmpty) {
                            accountController.townOrCityTextController.text =
                                placeMark.first.locality ?? "";

                            accountController.countryTextController.text =
                                placeMark.first.country ?? "";

                            accountController.postalCodeTextController.text =
                                placeMark.first.postalCode ?? "";

                            // accountController.stateTextController.text =
                            //     placeMark.first.administrativeArea ?? "";
                          }*/

                            /// state BY Geocodr2  COZ GEOCODING RETURNS abbreviation
                            /// of administrativeArea instead of full name

                            GeoData addresses =
                                await Geocoder2.getDataFromAddress(
                                    address: p?.description.toString() ?? "",
                                    googleMapApiKey:
                                        accountController.kGoogleApiKey);

                            if (addresses.state.isNotEmpty) {
                              // accountController.stateTextController.text =
                              //     addresses.state;
                            }
                          },
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(500),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          readOnly: true,
                          maxLines: 5,
                          errorMaxLines: 3,
                          hintText: StringConstants.addressLine1Text,
                          textCapitalization: TextCapitalization.words,
                          controller:
                              accountController.addressLine1TextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterAddressText;
                            }
                            return null;
                          },
                        ),
                        height20SizedBox,
                        Text(
                          StringConstants.addressLine2Text,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(500),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.addressLine2Text,
                          textCapitalization: TextCapitalization.words,
                          controller:
                              accountController.addressLine2TextController,
                          keyboardType: TextInputType.text,
                        ),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.townOrCityText
                                      .toTitleCase(),
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(500),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.townOrCityText,
                          textCapitalization: TextCapitalization.words,
                          controller:
                              accountController.townOrCityTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterTownOrCityText;
                            }
                            return null;
                          },
                        ),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      StringConstants.zipCodeText.toTitleCase(),
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.zipCodeText,
                          textCapitalization: TextCapitalization.words,
                          controller:
                              accountController.postalCodeTextController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterZipCodeText;
                            }
                            return null;
                          },
                        ),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      StringConstants.countryText.toTitleCase(),
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(500),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.countryText,
                          textCapitalization: TextCapitalization.words,
                          controller: accountController.countryTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants
                                  .pleaseEnterCountryText;
                            }
                            return null;
                          },
                        ),
                        // Obx(() => DropdownButtonFormField<CountriesList>(
                        //       isExpanded: true,
                        //       value: accountController.countriesList.isEmpty
                        //           ? CountriesList()
                        //           : accountController.countriesList[
                        //               accountController.countryIndex.value],
                        //       decoration: InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.grey,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         border: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         focusedBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         errorBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         hintText: StringConstants.countryText,
                        //         errorStyle: const TextStyle(color: Colors.yellow),
                        //       ),
                        //       items: accountController.countriesList
                        //           .map<DropdownMenuItem<CountriesList>>(
                        //               (CountriesList value) {
                        //         return DropdownMenuItem<CountriesList>(
                        //           value: value,
                        //           child: Text(value.countryName.toString()),
                        //         );
                        //       }).toList(),
                        //       onChanged: (CountriesList? newValue) {
                        //         accountController.countryDropdownValue.value =
                        //             newValue!.countryName.toString();
                        //         accountController.countryId!.value =
                        //             newValue.countryId.toString();

                        //         accountController.stateId.value = "";

                        //         accountController.apiGetStates();
                        //         print(accountController.countryId!.value);
                        //       },
                        //     )),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.stateText.toTitleCase(),
                                  style: TextStyle(
                                      color: AppColors.blacklight,
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
                        // Obx(() => DropdownButtonFormField<StatesList>(
                        //       isExpanded: true,
                        //       value: accountController.statesList.isEmpty
                        //           ? StatesList()
                        //           : accountController.statesList[
                        //               accountController.stateIndex.value],
                        //       decoration: InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.grey,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         border: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         focusedBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         errorBorder: UnderlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           borderSide: const BorderSide(
                        //             color: AppColors.primary,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         hintText: StringConstants.stateText,
                        //         errorStyle: const TextStyle(color: Colors.red),
                        //       ),
                        //       items: accountController.statesList
                        //           .map<DropdownMenuItem<StatesList>>(
                        //               (StatesList value) {
                        //         return DropdownMenuItem<StatesList>(
                        //           value: value,
                        //           child: Text(value.stateName.toString()),
                        //         );
                        //       }).toList(),
                        //       onChanged: (StatesList? newValue) {
                        //         accountController.stateDropdownValue.value =
                        //             newValue!.stateName.toString();
                        //         accountController.stateId.value =
                        //             newValue.stateId.toString();
                        //         print(accountController.stateId.value);
                        //       },
                        //     )),

                        CustomInputField(
                          isBorderOutline: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(500),
                          ],
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          maxLines: null,
                          errorMaxLines: 3,
                          hintText: StringConstants.stateText,
                          textCapitalization: TextCapitalization.words,
                          controller: accountController.stateTextController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants.pleaseEnterStateText;
                            }
                            return null;
                          },
                        ),
                        height15SizedBox,
                        Text(
                          StringConstants.collectTheIdentityInfoText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height20SizedBox,
                        Obx(
                          () => accountController
                                  .idProofImageDynamicLinkFromServer
                                  .value
                                  .isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: WidgetConstants.screenWidth,
                                      height:
                                          WidgetConstants.screenHeight * 0.3,
                                      child: Obx(() => InkWell(
                                            onTap: () {
                                              accountController
                                                  .showSelectionDialog(context);
                                            },
                                            child: DottedBorder(
                                              color: AppColors.blacklight,
                                              strokeWidth: 1,
                                              dashPattern: const [4, 4],
                                              child: CommonWidgets
                                                  .cachedNetworkImage(
                                                accountController
                                                    .idProofImageDynamicLinkFromServer
                                                    .value,
                                                fit: BoxFit.cover,
                                                width:
                                                    WidgetConstants.screenWidth,
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                        width:
                                                            WidgetConstants
                                                                .screenWidth,
                                                        height: WidgetConstants
                                                                .screenHeight *
                                                            0.3,
                                                        child: const Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                              ),
                                            ),
                                          )),
                                    ),
                                    height10SizedBox,
                                    SizedBox(
                                      width:
                                          WidgetConstants.screenHeight * 0.15,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          accountController
                                              .showSelectionDialog(context);
                                        },
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AppColors.primary),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: const BorderSide(
                                                        color: AppColors
                                                            .primary)))),
                                        child: Text(
                                          StringConstants.removeText,
                                          style: const TextStyle(
                                              color: AppColors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : DottedBorder(
                                  color: AppColors.blacklight,
                                  strokeWidth: 1,
                                  dashPattern: const [4, 4],
                                  child: Container(
                                    width: WidgetConstants.screenWidth,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            WidgetConstants.screenWidth * 0.15,
                                        vertical: 20),
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
                                          height8SizedBox,
                                          Text(
                                            StringConstants
                                                .uploadIdentityProofText,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppColors.blacklight),
                                          ),
                                          height8SizedBox,
                                          SizedBox(
                                            width:
                                                WidgetConstants.screenHeight *
                                                    0.15,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                accountController
                                                    .showSelectionDialog(
                                                        context);
                                              },
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          AppColors.primary),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  18.0),
                                                          side: const BorderSide(
                                                              color: AppColors
                                                                  .primary)))),
                                              child: Text(
                                                StringConstants.uploadText,
                                                style: const TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                        ),
                        height20SizedBox,

                        height40SizedBox,
                        CustomButton(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primary, AppColors.primary],
                          ),
                          onTap: () {
                            accountController.validateAndSubmit();
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
        ));
  }
}
