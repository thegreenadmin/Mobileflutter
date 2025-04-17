import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/utils/utils.dart';

class FilterOptionScreen extends StatefulWidget {
  const FilterOptionScreen({super.key});

  @override
  State<FilterOptionScreen> createState() => _FilterOptionScreenState();
}

class _FilterOptionScreenState extends State<FilterOptionScreen> with GlobalVarMixin{
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPreferredSize(),
      body: buildSingleChildScrollView(context),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: buildColumn(context),
      ),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height15SizedBox,
          Center(
              child: Image.asset(
            ImageConstants.greenmall420,
            scale: 4,
          )),
          height30SizedBox,
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              autofocus: false,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(100),
                FilteringTextInputFormatter
                    .digitsOnly,
              ],
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: searchStoreUserController.zipCodeTextController,
              keyboardType: TextInputType.phone,
              decoration: buildInputDecoration(StringConstants.zipCodeText)
            ),
          height15SizedBox,
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              autofocus: false,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(50),
                FilteringTextInputFormatter
                    .digitsOnly,
              ],
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              controller: searchStoreUserController.mileageTextController,
              onChanged: (value) {
                searchStoreUserController.miles.value =
                    searchStoreUserController.mileageTextController.text;
              },
              keyboardType: TextInputType.phone,
              decoration:  buildInputDecoration(StringConstants.milesText)
          ),
          height15SizedBox,
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: StringConstants.storeOpeningText,
              hintStyle: TextStyle(
                  color: AppColors.blackLight,
                  fontWeight: FontWeight.w400),
              fillColor: Colors.white,
              border: buildOutlineInputBorder(AppColors.primary),
              errorBorder: buildOutlineInputBorder(AppColors.primary),
              focusedBorder: buildOutlineInputBorder(AppColors.primary),
              enabledBorder:  buildOutlineInputBorder(AppColors.grey),
            ),
            isExpanded: true,
            hint: Text(
              StringConstants.storeOpeningText,
              style: TextStyle(
                color: AppColors.blackLight,
              ),
            ),
            items: <String>["Open Now", "Closed"].map((String value) {
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
              searchStoreUserController.isOpenNow.value = v ?? "";
              /*if (v == "Open Now") {
                searchStoreUserController.isOpenNow.value = true;
              } else {
                searchStoreUserController.isOpenNow.value = false;
              }*/
            },
          ),
          height15SizedBox,
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: searchStoreUserController
                          .openingTimeTextController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.trim() ==
                            searchStoreUserController
                                .closingTimeTextController.text) {
                          return AlertStringConstants.openingTimeAlertText;
                        }
                        return null;
                      },
                      onTap: () async {
                        TimeOfDay? date = TimeOfDay.now();
                        FocusScope.of(context).requestFocus(FocusNode());
                        date = (await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.input,
                          helpText: StringConstants.selectTimeText,
                          initialTime: TimeOfDay.now(),
                          context: context,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        ));
                        searchStoreUserController.openingTimeTextController
                            .text = date!.format(context).toString();

                        searchStoreUserController.openingTime.value =
                            Utility.formatDateTime(
                                    searchStoreUserController
                                        .openingTimeTextController.text,
                                    firstFormat: "hh:mm",
                                    secFormat: "HH:mm:ss")
                                .toString();
                      },
                      decoration: buildInputDecoration(StringConstants.openingTimeText),
                    )
                  ],
                ),
              ),
              width15SizedBox,
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        controller: searchStoreUserController
                            .closingTimeTextController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.trim() ==
                              searchStoreUserController
                                  .openingTimeTextController.text) {
                            return AlertStringConstants
                                .closingTimeAlertText;
                          }
                          return null;
                        },
                        onTap: () async {
                          TimeOfDay? date = TimeOfDay.now();
                          FocusScope.of(context).requestFocus(FocusNode());
                          date = (await showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            helpText: StringConstants.selectTimeText,
                            initialTime: TimeOfDay.now(),
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child!,
                              );
                            },
                          ));
                          searchStoreUserController
                              .closingTimeTextController
                              .text = date!.format(context).toString();
                          searchStoreUserController.closingTime.value =
                              Utility.formatDateTime(
                                      searchStoreUserController
                                          .closingTimeTextController.text,
                                      firstFormat: "hh:mm",
                                      secFormat: "HH:mm:ss")
                                  .toString();
                        },
                        decoration: buildInputDecoration(StringConstants.closingTimeText))
                  ],
                ),
              )
            ],
          ),
          height15SizedBox,
          MultiCustomDropDown(
              inputDecoration: InputDecoration(
                counterText: '',
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.blackLight,
                  ),
                ),
                labelText: StringConstants.pickupOptionsText,
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackLight,
                    decoration: TextDecoration.none),
                hintText: StringConstants.pickupOptionsText,
                hintStyle:
                    TextStyle(color: AppColors.blackLight, fontSize: 16),
                fillColor: Colors.white,
                filled: false,
                errorBorder: buildOutlineInputBorder( AppColors.grey,),
                focusedBorder: buildOutlineInputBorder( AppColors.grey,),
                enabledBorder:buildOutlineInputBorder( AppColors.grey,),
              ),
              onChanged: (v) {
                searchStoreUserController.deliveryServicesList.clear();
                for (int i = 0;
                    i < searchStoreUserController.deliveryServices.length;
                    i++) {
                  if (searchStoreUserController
                          .deliveryServices[i].isSelected ==
                      true) {
                    searchStoreUserController.deliveryServicesList.add(
                        searchStoreUserController.deliveryServices[i].name);
                  }
                }
              },
              controller:
                  searchStoreUserController.deliveryServicesController,
              hintText: StringConstants.pickupOptionsText,
              title: StringConstants.pickupOptionsText,
              list: searchStoreUserController.deliveryServices),
          height20SizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                onTap: () {
                  if (searchStoreUserController.zipCodeTextController.text.isEmpty&& searchStoreUserController.zipCodeTextController.text == "" &&
                      searchStoreUserController.mileageTextController.text.isEmpty &&     searchStoreUserController.mileageTextController.text ==
                          "" &&    searchStoreUserController
                      .openingTimeTextController.text.isEmpty &&
                      searchStoreUserController
                              .openingTimeTextController.text ==
                          "" && searchStoreUserController
                      .closingTimeTextController.text.isEmpty &&
                      searchStoreUserController
                              .closingTimeTextController.text ==
                          "" &&  searchStoreUserController.isOpenNow.value=="" &&
                      searchStoreUserController.deliveryServicesList.isEmpty) {
                    Utility.showAlertMessage(
                        AlertStringConstants.pleaseSelectOneFilterText);
                  } else {
                    searchStoreUserController.placeId.value = "";
                    searchStoreUserController.apiGetNearByStores(
                      isFilter: true,
                    );
                  }
                },
                height: 50,
                width: WidgetConstants.screenWidth * 0.43,
                text: StringConstants.saveText,
                borderRadius: 12,
                fontWeight: FontWeight.w500,
                iconL: false,
                fontSize: 16,
              ),
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.white, AppColors.white],
                ),
                onTap: () async {
                  // Utility.showConfirmAlertMessage(
                  //     AlertStringConstants.areYouSureLogoutAccountText,
                  //     cancelText: StringConstants.noText,
                  //     okay: StringConstants.yesText, okayTap: () {
                  //   // accountController.apiLogOutUser();
                  // });
                  searchStoreUserController.clearNearbyPArms();
                  log("CALL apiGetNearByStores FILTER");
                  searchStoreUserController.apiGetNearByStores();
                  Get.back(id: pageIdApp.value);
                }, border: Border.all(
                color: AppColors.primary,
              ),
                height: 50,   width: WidgetConstants.screenWidth * 0.43,
                textColor: AppColors.primary,
                text: StringConstants.clearFiltersText,
                borderRadius: 12,

                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      );
  }

  PreferredSize buildPreferredSize() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primaryLight,
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
                              StringConstants.filterOptionsText,
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
                      ]),
                ],
              )),
        ));
  }

  OutlineInputBorder buildOutlineInputBorder(color) {
    return OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:  BorderSide(
                    color: color,
                    width: 1.0,
                  ),
                );
  }

  InputDecoration buildInputDecoration(hintText) {
    return InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.blackLight,
            decoration: TextDecoration.none),

                            errorMaxLines: 3,
                            hintText: hintText,
                            hintStyle: TextStyle(
                                color: AppColors.blackLight,
                                fontWeight: FontWeight.w400),
                            fillColor: Colors.white,
                            border: buildOutlineInputBorder( AppColors.primary,),
                            errorBorder: buildOutlineInputBorder( AppColors.primary,),
                            focusedBorder: buildOutlineInputBorder( AppColors.primary,),
                            enabledBorder: buildOutlineInputBorder( AppColors.grey,));
  }
}
