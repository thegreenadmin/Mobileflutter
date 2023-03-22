import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_user_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class FilterOptionScreen extends StatefulWidget {
  const FilterOptionScreen({super.key});

  @override
  State<FilterOptionScreen> createState() => _FilterOptionScreenState();
}

class _FilterOptionScreenState extends State<FilterOptionScreen> {
  final SearchStoreUserController searchStoreUserController =
      Get.put(SearchStoreUserController());

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
                                StringConstants.filterText,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height15SizedBox,
              TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  controller: searchStoreUserController.zipCodeTextController,
                  keyboardType: TextInputType.phone,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return AlertStringConstants.pleaseEnterZipCodeText;
                  //   }
                  //   return null;
                  // },
                  decoration: InputDecoration(
                    hintText: StringConstants.zipCodeText,
                    hintStyle: const TextStyle(color: AppColors.grey),
                    labelText: StringConstants.zipCodeText,
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blacklight,
                        decoration: TextDecoration.none),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                  )),
              height15SizedBox,
              TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(40),
                  ],
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  controller: searchStoreUserController.mileageTextController,
                  keyboardType: TextInputType.phone,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return AlertStringConstants.pleaseEnterMileageText;
                  //   }
                  //   return null;
                  // },
                  decoration: InputDecoration(
                    hintText: StringConstants.mileageText,
                    hintStyle: const TextStyle(color: AppColors.grey),
                    labelText: StringConstants.mileageText,
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blacklight,
                        decoration: TextDecoration.none),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                  )),
              height15SizedBox,
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                isExpanded: true,
                hint: Text(
                  StringConstants.storeOpeningText,
                  style: const TextStyle(color: AppColors.grey, fontSize: 16),
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
                  if (v == "Yes") {
                    // manageStoreController.isFeatured.value = true;
                  } else {
                    //manageStoreController.isFeatured.value = false;
                  }
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
                          // controller: addNewStoreController
                          //     .openingTimeTextController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                          if (value?.trim() ==
                                searchStoreUserController
                                    .closingTimeTextController
                                    .text) {
                              return AlertStringConstants
                                  .openingTimeAlertText;
                            }
                            return null;
                          },
                          onTap: () async {
                            TimeOfDay date = TimeOfDay.now();
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = (await showTimePicker(
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
                            ))!;
                            searchStoreUserController.openingTimeTextController
                                .text = date.format(context).toString();

                            searchStoreUserController.openingTime.value =
                                "${date.hour}:${date.minute}:00";

                            print("${date.hour}:${date.minute}:00");
                          },
                          decoration: InputDecoration(
                              errorMaxLines: 3,
                              hintText: StringConstants.openingTimeText,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.grey,
                                  width: 1.0,
                                ),
                              )),
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
                              TimeOfDay date = TimeOfDay.now();
                              FocusScope.of(context).requestFocus(FocusNode());
                              date = (await showTimePicker(
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
                              ))!;
                              searchStoreUserController
                                ..closingTimeTextController.text =
                                    date.format(context).toString();
                              searchStoreUserController.closingTime.value =
                                  "${date.hour}:${date.minute}:00";
                            },
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              hintText: StringConstants.closingTimeText,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppColors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
              height15SizedBox,
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                isExpanded: true,
                hint: Text(
                  StringConstants.pickupOptionsText,
                  style: const TextStyle(
                    color: AppColors.grey,
                  ),
                ),
                items: <String>["In Store", "Delivery", "Curb Side"]
                    .map((String value) {
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
                  if (v == "Yes") {
                    // manageStoreController.isFeatured.value = true;
                  } else {
                    //manageStoreController.isFeatured.value = false;
                  }
                },
              ),
              height20SizedBox,
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                onTap: () {
                  if(searchStoreUserController.zipCodeTextController.text==""
                  && searchStoreUserController.mileageTextController.text=="" &&
                      searchStoreUserController.openingTimeTextController.text=="" &&
                      searchStoreUserController.closingTimeTextController.text==""){
                    Utility.showToast(AlertStringConstants
                        .pleaseSelectOneFilterText);
                  }
                },
                height: 50,
                text: StringConstants.saveText,
                borderRadius: 12,
                fontWeight: FontWeight.w500,
                iconL: false,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
