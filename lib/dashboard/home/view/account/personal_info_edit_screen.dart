
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/global_share_data.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:google_maps_webservice/places.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:thegreenmall/utils/shared_prefrences.dart';
import '../../../../utils/utility.dart';

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
          Get.back(id:pageIdApp.value);
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
                                      // Get.back();
                                     Get.back(id:pageIdApp.value);
                                     // Navigator.of(context).pop();
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
                        Text(
                          StringConstants.firstNameText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.firstNameTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterFirstNameText;
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: StringConstants.firstNameText,
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
                          StringConstants.lastNameText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.lastNameTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterLastNameText;
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: StringConstants.lastNameText,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.nickNameTextController,
                            keyboardType: TextInputType.text,
                            /*  validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AlertStringConstants.pleaseEnterNickNameText;
                            }
                            return null;
                          },*/
                            textCapitalization: TextCapitalization.words,
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
                        InkWell(
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
                            int idx = p?.description?.indexOf(",") ?? 0;
                            List parts = [
                              p?.description?.substring(0, idx).trim() ?? '',
                              p?.description?.substring(idx + 1).trim()
                            ];
                            accountController.addressLine1TextController.text =
                                parts[0].toString();

                            ///ADDRESSES BY google_maps_webservice: ^0.0.19 COZ GEOCODING ios issues

                            final geocoding = GoogleMapsGeocoding(
                                apiKey: accountController.kGoogleApiKey);

                            GeocodingResponse response =
                                await geocoding.searchByAddress(
                                    p?.description.toString() ?? "");
                            // log("GeocodingResponse web services:------------");
                            // log(jsonEncode(response.results));

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

                            // accountController.townOrCityTextController.text =
                            //     response.results[0].addressComponents.firstWhere((element) => element.types.);

                            // accountController.countryTextController.text =
                            //     placeMark.first.country ?? "";
                            //
                            // accountController.postalCodeTextController.text =
                            //     placeMark.first.postalCode ?? "";

                            // accountController.stateTextController.text =
                            //     placeMark.first.administrativeArea ?? "";

                            // PlacesDetailsResponse response = await places.getDetailsByPlaceId("PLACE_ID");

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
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enabled: false,
                              minLines: 1,
                              maxLines: 5,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(500),
                              ],
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
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
                              textCapitalization: TextCapitalization.words,
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
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.addressLine2TextController,
                            keyboardType: TextInputType.text,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.townOrCityTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterTownOrCityText;
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                accountController.postalCodeTextController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterZipCodeText;
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
                        Text(
                          StringConstants.countryText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(500),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            controller: accountController.countryTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterCountryText;
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: StringConstants.countryText,
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
                        Text(
                          StringConstants.stateText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
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
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(500),
                            ],
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            controller: accountController.stateTextController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterStateText;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: StringConstants.stateText,
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
                                  .idProofImageDynamicLinkfromServer
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
                                              child: Image.network(
                                                accountController
                                                    .idProofImageDynamicLinkfromServer
                                                    .value,
                                                fit: BoxFit.cover,
                                                width:
                                                    WidgetConstants.screenWidth,
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
                                        child: const Text(
                                          "Remove",
                                          style:
                                              TextStyle(color: AppColors.white),
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
                                    // padding: const EdgeInsets.only(
                                    //     left: 0, right: 0, top: 20, bottom: 20),
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
                                              child: const Text(
                                                "Upload",
                                                style: TextStyle(
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
                            // accountController.apiUpdateUserDetail();
                            accountController.validateAndSubmit(context);
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
