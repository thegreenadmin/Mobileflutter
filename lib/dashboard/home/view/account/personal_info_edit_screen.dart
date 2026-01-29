import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/google_place_autocompleted.dart';
import 'package:thegreenmall/utils/utils.dart';

class PersonalInfoEditScreen extends StatefulWidget {
  final bool isFromCart;
  const PersonalInfoEditScreen({super.key,  this.isFromCart=false});

  @override
  State<PersonalInfoEditScreen> createState() => _PersonalInfoEditScreenState();
}

class _PersonalInfoEditScreenState extends State<PersonalInfoEditScreen> with GlobalVarMixin{
  final AccountController accountController = Get.isRegistered() ?  Get.find<AccountController>() : Get.put(AccountController());

  @override
  void initState() {
    accountController.isFromCart.value = widget.isFromCart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back(id: pageIdApp.value);
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: AppColors.primaryLight,
                    child: Padding(
                        padding:
                        const EdgeInsets.only(left: 15.0, right: 20, top: 50),
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
                  ),
                  Expanded(
                    child: GestureDetector(
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
                                  sectionTitle(StringConstants.personalDetailText),
                                  formFields(StringConstants.firstNameText,true, controller: accountController.firstNameTextController,hint:StringConstants.firstNameText,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AlertStringConstants
                                          .pleaseEnterFirstNameText;
                                    }
                                    return null;
                                  }),
                                  formFields(StringConstants.lastNameText,true, controller: accountController.lastNameTextController,hint:StringConstants.lastNameText,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterLastNameText;
                                        }
                                        return null;
                                      }),

                                  formFields(StringConstants.nickNameText,false, controller: accountController.nickNameTextController,hint:StringConstants.nickNameText,),

                                  height20SizedBox,

                                  sectionTitle(StringConstants.addressText),
                                  height20SizedBox,
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: StringConstants.addressLine1Text,
                                            style: TextStyle(
                                                color: AppColors.blackLight,
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
                                  GooglePlaceAutocompleteField(
                                    apiKey: accountController.kGoogleApiKey,
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AlertStringConstants
                                            .pleaseEnterAddressText;
                                      }
                                      return null;
                                    },
                                    controller: accountController.addressLine1TextController,
                                    onPlaceSelected: (Place place) {
                                      final components = place.addressComponents ?? [];

                                      String? getComponent(String type) {
                                        return components
                                            .firstWhere((c) => c.types.contains(type), orElse: () => AddressComponent( name: '', shortName: '', types: []))
                                            .name;
                                      }

                                      accountController.townOrCityTextController.text =
                                          getComponent('locality') ?? '';

                                      accountController.countryTextController.text =
                                          getComponent('country') ?? '';

                                      accountController.postalCodeTextController.text =
                                          getComponent('postal_code') ?? '';

                                      accountController.stateTextController.text =
                                          getComponent('administrative_area_level_1') ?? '';

                                      accountController.postalCodeTextController.text =
                                          getComponent('postal_code') ?? '';
                                      accountController.update();
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
                                      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
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
                                    textStyle: TextStyle(fontSize: 16),
                                    // textInputAction: TextInputAction.next, autofocus: false,
                                    // maxLines: 5,

                                  ),

                                  formFields(StringConstants.addressLine2Text,false, controller: accountController.addressLine2TextController,hint:StringConstants.addressLine2Text,),
                                  formFields(StringConstants.townOrCityText,true, controller: accountController.townOrCityTextController,hint:StringConstants.townOrCityText,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterTownOrCityText;
                                        }
                                        return null;
                                      }),
                                  formFields(StringConstants.zipCodeText,true, controller: accountController.postalCodeTextController,hint:StringConstants.zipCodeText,
                                      action: TextInputAction.next,
                                      digitsOnly: true,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterZipCodeText;
                                        }
                                        return null;
                                      }),

                                  formFields(StringConstants.countryText,true, controller: accountController.countryTextController,hint:StringConstants.countryText,
                                      action: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterCountryText;
                                        }
                                        return null;
                                      },),
                                  formFields(StringConstants.stateText,true, controller: accountController.stateTextController,hint:StringConstants.stateText,
                                      action: TextInputAction.next,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AlertStringConstants
                                              .pleaseEnterStateText;
                                        }
                                        return null;
                                      },),

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

                                  height15SizedBox,
                                  Text(
                                    StringConstants.collectTheIdentityInfoText,
                                    style: TextStyle(
                                        color: AppColors.blackLight,
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
                                                        color: AppColors.blackLight,
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
                                                          WidgetStateProperty.all<
                                                              Color>(AppColors.primary),
                                                      shape: WidgetStateProperty.all<
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
                                                        color: AppColors.primaryDark),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : DottedBorder(
                                            color: AppColors.blackLight,
                                            strokeWidth: 1,
                                            dashPattern: const [4, 4],
                                            child: Container(
                                              width: WidgetConstants.screenWidth,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      WidgetConstants.screenWidth * 0.15,
                                                  vertical: 20),
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
                                                    height8SizedBox,
                                                    Text(
                                                      StringConstants
                                                          .uploadIdentityProofText,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors.blackLight),
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
                                                                WidgetStateProperty.all<Color>(
                                                                    AppColors.primary),
                                                            shape: WidgetStateProperty.all<
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
                                                          style:  TextStyle(
                                                              color: AppColors.blackLight),
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
                  ),
                ],
              ),
              //LOADING OVERLAY
              Obx(() {
                return accountController.isLoading.value
                    ? Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ));
  }

  Text sectionTitle(String label) {
    return Text(
      label,
      style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20),
    );
  }

   formFields(String label, isRequired ,{
     required final TextEditingController controller,
     required final String hint,
     final FormFieldValidator<String>? validator,
     final TextInputAction? action,
    bool digitsOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20SizedBox,
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: label,
                  style: TextStyle(
                      color: AppColors.blackLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              if (isRequired)
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
            if (digitsOnly)
             FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.next,
          autofocus: false,
          maxLines: null,
          errorMaxLines: 3,
          hintText: hint,
          textCapitalization: TextCapitalization.words,
          controller: controller,
          keyboardType: TextInputType.text,
          validator: validator,
        ),
      ],
    );
  }
}
