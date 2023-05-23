import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/mutli_select_drop_down.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class EditStoreDetailScreen extends StatefulWidget {
  const EditStoreDetailScreen({super.key});

  @override
  State<EditStoreDetailScreen> createState() => _EditStoreDetailScreenState();
}

class _EditStoreDetailScreenState extends State<EditStoreDetailScreen> {
  final OwnerStoresController ownerStoreController =
      Get.put(OwnerStoresController());

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
                              Navigator.of(context).pop();
                              // Get.back();
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
                        ImageConstants.homeMall,
                        scale: 4,
                      )
                    ])),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: ownerStoreController.formKey,
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
                            child: Obx(() => ownerStoreController
                                    .editStoreLogoDynamicLinkfromServer
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
                                          color: AppColors.blacklight,
                                          strokeWidth: 1,
                                          dashPattern: const [4, 4],
                                          child: Container(
                                            width: WidgetConstants.screenWidth *
                                                0.3,
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
                                      ownerStoreController
                                          .showSelectionDialog(context);
                                      ownerStoreController
                                          .isStoreLogoSelected.value = true;
                                    },
                                    child: Row(
                                      children: [
                                        DottedBorder(
                                          color: AppColors.blacklight,
                                          strokeWidth: 1,
                                          dashPattern: const [4, 4],
                                          child: Container(
                                            width: WidgetConstants.screenWidth *
                                                0.3,
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            color: AppColors.primarylight,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                      ownerStoreController
                                                          .editStoreLogoDynamicLinkfromServer
                                                          .value,
                                                      fit: BoxFit.cover)
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
                    Text(
                      StringConstants.bannerImageText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height20SizedBox,
                    Obx(
                      () => ownerStoreController
                              .editStoreImageDynamicLinkfromServer.value.isEmpty
                          ? InkWell(
                              onTap: () {
                                ownerStoreController
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
                                              ImageConstants.upload,
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
                                ownerStoreController
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
                                            ownerStoreController
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
                        controller:
                            ownerStoreController.storeNameTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStoreNameText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
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
                        controller: ownerStoreController.einTextController,
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
                        controller: ownerStoreController.nickNameTextController,
                        keyboardType: TextInputType.text,
                        /* validator: (value) {
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
                      StringConstants.emailIdText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
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
                        controller: ownerStoreController.emailTextController,
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
                        hintText: StringConstants.mobileText,
                        hintStyle: TextStyle(
                            color: AppColors.blacklight, fontSize: 15),
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

                          int idx = p!.description!.indexOf(",");
                          List parts = [
                            p.description!.substring(0, idx).trim(),
                            p.description!.substring(idx + 1).trim()
                          ];
                          ownerStoreController.addressLine1TextController.text =
                              parts[0].toString();


                          ///ADDRESSES BY GEOCODING

                          List<geocoding.Location> locations = await geocoding.locationFromAddress(p?.description.toString()??"");

                          List<geocoding.Placemark> placeMark = await geocoding.placemarkFromCoordinates(locations.first.latitude, locations.first.longitude);
                          String address = "${ placeMark.first.name??""}, ${ placeMark.first.subLocality??""}, ${ placeMark.first.locality??""}, ${ placeMark.first.administrativeArea??""} ${ placeMark.first.postalCode??""}, ${ placeMark.first.country??""}";

                          debugPrint("ADDRESSES---->$address");

                          if(placeMark.isNotEmpty){
                            ownerStoreController.townOrCityTextController
                                .text = placeMark.first.locality??"";

                            ownerStoreController.countryTextController.text =
                                placeMark.first.country??"";

                            ownerStoreController.postalCodeTextController.text =
                                placeMark.first.postalCode??"";

                            ownerStoreController.stateTextController.text =
                                placeMark.first.administrativeArea??"";

                          }
                          if(locations.isNotEmpty){
                            ownerStoreController.lng =
                                locations.first.longitude.toString()??"";
                            ownerStoreController.lat =
                                locations.first.latitude.toString()??"";
                          }


                          ///--------------------------------------
                       /*   GeoData addresses =
                              await Geocoder2.getDataFromAddress(
                                  address: p.description.toString(),
                                  googleMapApiKey:
                                      ownerStoreController.kGoogleApiKey);

                          if (addresses.address != null) {
                            if (addresses.city.isNotEmpty) {
                              ownerStoreController.townOrCityTextController
                                  .text = addresses.city;
                            }
                            if (addresses.country.isNotEmpty) {
                              ownerStoreController.countryTextController.text =
                                  addresses.country;
                            }

                            if (addresses.postalCode.isNotEmpty) {
                              ownerStoreController.postalCodeTextController
                                  .text = addresses.postalCode;
                            }
                            if (addresses.state.isNotEmpty) {
                              ownerStoreController.stateTextController.text =
                                  addresses.state;
                            }
                            if (addresses.latitude != null ||
                                addresses.longitude != null) {
                              ownerStoreController.lng =
                                  addresses.longitude.toString();
                              ownerStoreController.lat =
                                  addresses.latitude.toString();
                            }
                          }
                          debugPrint("ADDRESSES--*************-->${addresses.toString()}");
                          debugPrint("ADDRESSES---->${addresses.address}");
                          debugPrint("CITY---->${addresses.city}");
                          debugPrint("COUNTRY---->${addresses.country}");
                          debugPrint(
                              "COUNTRY CODE---->${addresses.countryCode}");
                          debugPrint("POSTALCODE---->${addresses.postalCode}");
                          debugPrint("STATE---->${addresses.state}");
                          debugPrint(
                              "STREETNUMBER---->${addresses.streetNumber}");
                          debugPrint("LAT---->${addresses.latitude}");
                          debugPrint("LONG---->${addresses.longitude}");*/
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //enabled: false,
                        readOnly: true,
                        minLines: 1,
                        maxLines: 5,
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
                            ownerStoreController.addressLine1TextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants.pleaseEnterAddressText;
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            ownerStoreController.addressLine2TextController,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            ownerStoreController.townOrCityTextController,
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
                      StringConstants.postalCodeText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            ownerStoreController.postalCodeTextController,
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
                    // Obx(() => DropdownButtonFormField<CountriesList>(
                    //       isExpanded: true,
                    //       value:
                    //           ownerStoreController.countriesList.isEmpty
                    //               ? CountriesList()
                    //               : ownerStoreController.countriesList[
                    //                   ownerStoreController
                    //                       .countryIndex.value],
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
                    //       items: ownerStoreController.countriesList
                    //           .map<DropdownMenuItem<CountriesList>>(
                    //               (CountriesList value) {
                    //         return DropdownMenuItem<CountriesList>(
                    //           value: value,
                    //           child: Text(value.countryName.toString()),
                    //         );
                    //       }).toList(),
                    //       onChanged: (CountriesList? newValue) {
                    //         ownerStoreController.countryDropdownValue
                    //             .value = newValue!.countryName.toString();
                    //         ownerStoreController.countryId!.value =
                    //             newValue.countryId.toString();
                    //         ownerStoreController.stateId.value = "";
                    //         ownerStoreController.apiGetState();
                    //         print(ownerStoreController.countryId!.value);
                    //       },
                    //     )),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(500),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: ownerStoreController.countryTextController,
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
                      StringConstants.zoneText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    // Obx(() => DropdownButtonFormField<StatesList>(
                    //       isExpanded: true,
                    //       value: ownerStoreController.statesList.isEmpty
                    //           ? StatesList()
                    //           : ownerStoreController.statesList[
                    //               ownerStoreController.stateIndex.value],
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
                    //         errorStyle: const TextStyle(color: Colors.yellow),
                    //       ),
                    //       items: ownerStoreController.statesList
                    //           .map<DropdownMenuItem<StatesList>>(
                    //               (StatesList value) {
                    //         return DropdownMenuItem<StatesList>(
                    //           value: value,
                    //           child: Text(value.stateName.toString()),
                    //         );
                    //       }).toList(),
                    //       onChanged: (StatesList? newValue) {
                    //         ownerStoreController.stateDropdownValue
                    //             .value = newValue!.stateName.toString();
                    //         ownerStoreController.stateId.value =
                    //             newValue.stateId.toString();
                    //       },
                    //     )),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(500),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: ownerStoreController.stateTextController,
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
                                    ownerStoreController.storeTimmingList
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
                                      Text(
                                        StringConstants.openingTimeText,
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      height4SizedBox,
                                      TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                          controller: ownerStoreController
                                              .openingTimeTextController,
                                          keyboardType: TextInputType.phone,
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

                                            ownerStoreController
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                          controller: ownerStoreController
                                              .closingTimeTextController,
                                          keyboardType: TextInputType.phone,
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
                                            ownerStoreController
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
                    Obx(() => ownerStoreController.is247Time.value != true
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
                      () => ownerStoreController.is247Time.value != true
                          ? MultiCustomDropDown(
                              onChanged: (v) {
                                ownerStoreController.storeTimmingList.clear();
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
                                        ownerStoreController.storeTimmingList
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
                                                  secFormat: "hh:mm:ss")
                                              .toString(),
                                          "closing_time": Utility.formatDateTime(
                                                  ownerStoreController
                                                      .closingTimeTextController
                                                      .text
                                                      .trim(),
                                                  firstFormat: "hh:mm a",
                                                  secFormat: "hh:mm:ss")
                                              .toString()
                                        });
                                      }
                                    }
                                    if (ownerStoreController
                                            .weekDaysList[i].isSelected ==
                                        true) {
                                      if (!ownerStoreController.storeTimmingList
                                          .any((element) =>
                                              element["day_of_week"] ==
                                              ownerStoreController
                                                  .weekDaysList[i].id)) {
                                        ownerStoreController.storeTimmingList
                                            .add({
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
                                } else {
                                  for (int i = 0;
                                      i <
                                          ownerStoreController
                                              .weekDaysList.length;
                                      i++) {
                                    if (ownerStoreController
                                            .weekDaysList[i].isSelected ==
                                        true) {
                                      ownerStoreController.storeTimmingList
                                          .add({
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
                    Text(
                      StringConstants.deliveryMethodsText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.enabledText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blacklight,
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
                                color: AppColors.greylight,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: AppColors.greylight,
                              ),
                              activeColor: AppColors.greymediumlight,
                              inactiveColor: AppColors.greymediumlight,
                              onToggle: (val) {
                                ownerStoreController.isEnabled.value = val;
                              },
                            )),
                      ],
                    ),
                    height15SizedBox,
                    Text(
                      StringConstants.storeTermsText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        onTap: () {
                          ownerStoreController.isTermsSelected.value = true;
                          ownerStoreController.filePicker();
                        },
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            ownerStoreController.storeTermsTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStoreTermsText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                ownerStoreController.isTermsSelected.value =
                                    true;
                                ownerStoreController.filePicker();
                              },
                              icon: const Icon(Icons.attach_file_rounded)),
                          hintText: StringConstants.uploadStoreTermsAsPdfText,
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
                    height20SizedBox, height15SizedBox,
                    Text(
                      StringConstants.storePrivacyText,
                      style: TextStyle(
                          color: AppColors.blacklight,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    TextFormField(
                        onTap: () {
                          ownerStoreController.isTermsSelected.value = false;
                          ownerStoreController.filePicker();
                        },
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                        ],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller:
                            ownerStoreController.storePrivacyTextController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AlertStringConstants
                                .pleaseEnterStorePrivacyText;
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                ownerStoreController.isTermsSelected.value =
                                    false;
                                ownerStoreController.filePicker();
                              },
                              icon: const Icon(Icons.attach_file_rounded)),
                          hintText: StringConstants.uploadStorePolicyAsPdfText,
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

                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        ownerStoreController.validateAndSubmit(context);
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
