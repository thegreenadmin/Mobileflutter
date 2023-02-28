import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/personal_info_edit.dart';
import 'package:thegreenmall/dashboard/home/view/store_detail_edit_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
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
                                StringConstants.storeDetailsText,
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
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.storeDetailsText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(const StoreDetailEditScreen());
                      },
                      child: Text(StringConstants.editText,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppColors.primary)),
                    ),
                  ],
                ),
                height30SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.storeNameText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "Healthy  Store",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.einBusinessId,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "BUS4512",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.nickNameText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "Joco",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(StringConstants.emailIdText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 16))),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "Johnjocon@gmail.com",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.phoneNumberText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "91 0123 4562 203",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Text(
                  StringConstants.addressText,
                  style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                height30SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.addressLine1Text,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "91 0123 4562 203",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.addressLine2Text,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "91 0123 4562 203",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.townOrCityText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "91 0123 4562 203",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.postalCodeText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "91 0123 4562 203",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.countryText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "New york",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
