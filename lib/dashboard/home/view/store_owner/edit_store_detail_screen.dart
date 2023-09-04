import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

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
                      StringConstants.storeDetailsText,
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
                              text: StringConstants.storeLogoText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.storeBannerImageText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

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
                                                .tapTouploadStoreImageText)
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
                                        child: CommonWidgets.cachedNetworkImage(
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
                                        )),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    height15SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.storeNameText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.einBusinessId,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    height4SizedBox,
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(20),
                        ],
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        controller: ownerStoreController.einTextController,
                        keyboardType: TextInputType.number,
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
                      style: const TextStyle(
                          color: AppColors.black,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.emailIdText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                        keyboardType: TextInputType.emailAddress,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.phoneNumberText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                        hintText: StringConstants.phoneNumberText,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.addressLine1Text,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

                          ///ADDRESSES BY GoogleMapsGeocoding

                          final geocoding = GoogleMapsGeocoding(
                              apiKey: ownerStoreController.kGoogleApiKey);

                          GeocodingResponse response = await geocoding
                              .searchByAddress(p.description.toString() ?? "");
                          // log("GeocodingResponse web services:------------");
                          // log(jsonEncode(response.results));

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

                          /*List<geocoding.Location> locations = await geocoding.locationFromAddress(p?.description.toString()??"");

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
                                locations.first.longitude.toString();
                            ownerStoreController.lat =
                                locations.first.latitude.toString();
                          }
*/

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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.townOrCityText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.postalCodeText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.zoneText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

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
                            return AlertStringConstants.pleaseEnterStateText;
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
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.countryText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                            return AlertStringConstants.pleaseEnterCountryText;
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
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: StringConstants
                                                    .openingTimeText,
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const TextSpan(
                                              text: "*",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
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
                                              initialEntryMode:
                                                  TimePickerEntryMode.input,
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
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: StringConstants
                                                    .closingTimeText,
                                                style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const TextSpan(
                                              text: "*",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
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
                                              initialEntryMode:
                                                  TimePickerEntryMode.input,
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
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: StringConstants.workingDaysText,
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                const TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.deliveryMethodsText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.storeTermsText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    height20SizedBox,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: StringConstants.storePrivacyText,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

                    height40SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        if (ownerStoreController.isLoading.value != true) {
                          ownerStoreController.isLoading.value = true;
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
      ),
    );
  }
}
