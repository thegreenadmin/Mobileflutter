import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/store_home_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreHomeMainScreen extends StatefulWidget {
  const StoreHomeMainScreen({super.key});

  @override
  State<StoreHomeMainScreen> createState() => _StoreHomeMainScreenState();
}

class _StoreHomeMainScreenState extends State<StoreHomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: NetworkImage(
                    'https://picsum.photos/250?image=9',
                  ),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 24.0,
                              ),
                            ),
                            Image.asset(
                              "assets/favoutline.png",
                              scale: 2.8,
                            ),
                          ]),
                      height10SizedBox,
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 1)),
                            child: const CircleAvatar(
                              radius: 28.0,
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
                                "Click & Collect",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              height8SizedBox,
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/loc.png",
                                    color: AppColors.white,
                                    scale: 2,
                                  ),
                                  width4SizedBox,
                                  const Text("Gate Village 10 Dubai 10017",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              height8SizedBox,
                              Row(
                                children: [
                                  const Text("Store Hours 9:00 am to 9:00PM",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  width10SizedBox,
                                  Image.asset(
                                    "assets/door.png",
                                    scale: 2.5,
                                  ),
                                  width8SizedBox,
                                  Image.asset(
                                    "assets/call.png",
                                    scale: 2.5,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: StringConstants.welcomeToText,
                          style: TextStyle(
                              color: AppColors.blacklight,
                              fontWeight: FontWeight.w400,
                              fontSize: 22)),
                      const TextSpan(
                        text: ' click & collect',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height30SizedBox,
            Image.asset("assets/examplee.png"),
            height30SizedBox,
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Get.to(const StoreHomeScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/storeproduct.png",
                        color: AppColors.primary,
                        scale: 2.4,
                      ),
                      width18SizedBox,
                      Text(StringConstants.exploreStoreProductText,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Image.asset(
                    "assets/arrowForward.png",
                    scale: 3.4,
                    color: AppColors.blacklight,
                  )
                ],
              ),
            ),
            const Divider(
              height: 40,
              thickness: 1,
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/terms.png",
                        color: AppColors.primary,
                        scale: 2.5,
                      ),
                      width18SizedBox,
                      Text(StringConstants.storeOffersAndDiscountText,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Image.asset(
                    "assets/arrowForward.png",
                    scale: 3.4,
                    color: AppColors.blacklight,
                  )
                ],
              ),
            ),
            const Divider(
              height: 40,
              thickness: 1,
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/privacy.png",
                        color: AppColors.primary,
                        scale: 2.5,
                      ),
                      width18SizedBox,
                      Text(StringConstants.storePolicyText,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Image.asset(
                    "assets/arrowForward.png",
                    scale: 3.4,
                    color: AppColors.blacklight,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
