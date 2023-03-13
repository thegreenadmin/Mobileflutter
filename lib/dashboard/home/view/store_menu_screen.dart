import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/add_to_order_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreMenuScreen extends StatefulWidget {
  const StoreMenuScreen({super.key});

  @override
  State<StoreMenuScreen> createState() => _StoreMenuScreenState();
}

class _StoreMenuScreenState extends State<StoreMenuScreen> {
  List storeCategoriesList = [
    "Topical medicines",
    "Suppositories",
    "Drops",
    "Inhalers",
    "Injections"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          height5SizedBox,
          Text(
            StringConstants.categoriesText,
            style: const TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          height5SizedBox,
          Expanded(
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return height6SizedBox;
                },
                itemCount: storeCategoriesList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.to(const AddToOrderScreen());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                          color: AppColors.greylight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.white, width: 1)),
                                  child: const CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: AssetImage(
                                      "assets/inboxexample.png",
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                width10SizedBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeCategoriesList[index],
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    height10SizedBox,
                                    Text("12 Product",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.blacklight,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.blacklight,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ]),
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
