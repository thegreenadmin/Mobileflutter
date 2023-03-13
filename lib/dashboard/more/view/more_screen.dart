import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/more/controller/more_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final MoreController moreController = Get.put(MoreController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  "Hi, ${moreController.firstName!.value}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400),
                                )),
                            height4SizedBox,
                            Text(
                              StringConstants.moreText,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                  height10SizedBox,
                ],
              )),
        ),
      ),
      // body: Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {},
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(vertical: 10),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Row(
      //               children: [
      //                 Image.asset(
      //                   "assets/aboutUs.png",
      //                   color: AppColors.primary,
      //                   scale: 2.5,
      //                 ),
      //                 width18SizedBox,
      //                 Text(StringConstants.aboutUsText,
      //                     style: const TextStyle(
      //                         fontSize: 16,
      //                         color: AppColors.black,
      //                         fontWeight: FontWeight.w500)),
      //               ],
      //             ),
      //             Image.asset(
      //               "assets/arrowForward.png",
      //               scale: 3.4,
      //               color: AppColors.blacklight,
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //     const Divider(
      //       thickness: 1,
      //       height: 40,
      //     ),
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {},
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Image.asset(
      //                 "assets/faq.png",
      //                 color: AppColors.primary,
      //                 scale: 2.5,
      //               ),
      //               width18SizedBox,
      //               Text(StringConstants.faqText,
      //                   style: const TextStyle(
      //                       fontSize: 16,
      //                       color: AppColors.black,
      //                       fontWeight: FontWeight.w500)),
      //             ],
      //           ),
      //           Image.asset(
      //             "assets/arrowForward.png",
      //             scale: 3.4,
      //             color: AppColors.blacklight,
      //           )
      //         ],
      //       ),
      //     ),
      //     const Divider(
      //       thickness: 1,
      //       height: 40,
      //     ),
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {
      //         Get.to(const ContactUsScreen());
      //       },
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Image.asset(
      //                 "assets/contactUs.png",
      //                 color: AppColors.primary,
      //                 scale: 2.5,
      //               ),
      //               width18SizedBox,
      //               Text(StringConstants.contactUsText,
      //                   style: const TextStyle(
      //                       fontSize: 16,
      //                       color: AppColors.black,
      //                       fontWeight: FontWeight.w500)),
      //             ],
      //           ),
      //           Image.asset(
      //             "assets/arrowForward.png",
      //             scale: 3.4,
      //             color: AppColors.blacklight,
      //           )
      //         ],
      //       ),
      //     ),
      //     const Divider(
      //       thickness: 1,
      //       height: 40,
      //     ),
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {},
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Image.asset(
      //                 "assets/terms.png",
      //                 color: AppColors.primary,
      //                 scale: 2.5,
      //               ),
      //               width18SizedBox,
      //               Text(StringConstants.termsOfServiceText,
      //                   style: const TextStyle(
      //                       fontSize: 16,
      //                       color: AppColors.black,
      //                       fontWeight: FontWeight.w500)),
      //             ],
      //           ),
      //           Image.asset(
      //             "assets/arrowForward.png",
      //             scale: 3.4,
      //             color: AppColors.blacklight,
      //           )
      //         ],
      //       ),
      //     ),
      //     const Divider(
      //       thickness: 1,
      //       height: 40,
      //     ),
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {},
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Image.asset(
      //                 "assets/privacy.png",
      //                 color: AppColors.primary,
      //                 scale: 2.5,
      //               ),
      //               width18SizedBox,
      //               Text(StringConstants.privacyPolicyText,
      //                   style: const TextStyle(
      //                       fontSize: 16,
      //                       color: AppColors.black,
      //                       fontWeight: FontWeight.w500)),
      //             ],
      //           ),
      //           Image.asset(
      //             "assets/arrowForward.png",
      //             scale: 3.4,
      //             color: AppColors.blacklight,
      //           )
      //         ],
      //       ),
      //     ),
      //   ]),
      // ),
    );
  }
}
