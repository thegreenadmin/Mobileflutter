import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/add_to_order_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreMenuScreen extends StatefulWidget {
  const StoreMenuScreen({super.key});

  @override
  State<StoreMenuScreen> createState() => _StoreMenuScreenState();
}

class _StoreMenuScreenState extends State<StoreMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return height6SizedBox;
                },
                itemCount: 15,
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
                          color: AppColors.primarylight,
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
                                          color: AppColors.primary, width: 1)),
                                  child: const CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(
                                        'https://picsum.photos/250?image=9'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                width10SizedBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Topical medicines",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
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
