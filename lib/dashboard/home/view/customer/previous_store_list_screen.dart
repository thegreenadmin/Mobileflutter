import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/customer/search_store_user_screen.dart';
import 'package:thegreenmall/dashboard/home/view/customer/store_home_main_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class PreviousStoreListScreen extends StatefulWidget {
  const PreviousStoreListScreen({super.key});

  @override
  State<PreviousStoreListScreen> createState() =>
      _PreviousStoreListScreenState();
}

class _PreviousStoreListScreenState extends State<PreviousStoreListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/nodata.png",
                  scale: 8,
                  color: AppColors.primary,
                ),
              ),
              height4SizedBox,
              Center(
                child: Text(
                  StringConstants.noPreviousStoresFoundText,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 16),
                ),
              ),
            ],
          )
              //  ListView.builder(
              //     itemCount: 15,
              //     itemBuilder: (BuildContext context, int index) {
              //       return InkWell(
              //         onTap: () {
              //           Get.to(const StoreHomeMainScreen());
              //         },
              //         child: Container(
              //           margin: const EdgeInsets.symmetric(vertical: 6),
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 10),
              //           decoration: const BoxDecoration(
              //               color: AppColors.primarylight,
              //               borderRadius: BorderRadius.all(
              //                 Radius.circular(10.0),
              //               )),
              //           child: Column(children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Container(
              //                       decoration: BoxDecoration(
              //                           shape: BoxShape.circle,
              //                           border: Border.all(
              //                               color: AppColors.primary, width: 1)),
              //                       child: const CircleAvatar(
              //                         radius: 25.0,
              //                         backgroundImage:
              //                             AssetImage("assets/dumy.png"),
              //                         backgroundColor: Colors.transparent,
              //                       ),
              //                     ),
              //                     width10SizedBox,
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         const Text(
              //                           "Ambrosia Store",
              //                           style: TextStyle(
              //                               fontSize: 17.0,
              //                               color: AppColors.black,
              //                               fontWeight: FontWeight.w600),
              //                         ),
              //                         height4SizedBox,
              //                         Row(
              //                           children: [
              //                             Image.asset(
              //                               "assets/loc.png",
              //                               scale: 3.2,
              //                             ),
              //                             width4SizedBox,
              //                             Text(
              //                               "Gate Village 10 Dubai 10017",
              //                               style: TextStyle(
              //                                   fontSize: 14.0,
              //                                   color: AppColors.blacklight,
              //                                   fontWeight: FontWeight.w500),
              //                             ),
              //                           ],
              //                         ),
              //                         height4SizedBox,
              //                         Text("3.5 mi - Open untill 9:00 pm",
              //                             style: TextStyle(
              //                                 fontSize: 14.0,
              //                                 color: AppColors.blacklight,
              //                                 fontWeight: FontWeight.w500)),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 Row(
              //                   children: [
              //                     Image.asset(
              //                       "assets/fav.png",
              //                       scale: 3.2,
              //                     ),
              //                     width10SizedBox,
              //                     Image.asset(
              //                       "assets/info.png",
              //                       scale: 3.2,
              //                     )
              //                   ],
              //                 )
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 InkWell(
              //                   onTap: () {
              //                     Get.to(() => const SearchStoreUserScreen());
              //                   },
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         "assets/inStore.png",
              //                         scale: 2.5,
              //                       ),
              //                       width3SizedBox,
              //                       Text(
              //                         StringConstants.inStoreText,
              //                         style: const TextStyle(
              //                             fontSize: 12.0,
              //                             fontWeight: FontWeight.w500),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     Get.to(() => const SearchStoreUserScreen());
              //                   },
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         "assets/delivery.png",
              //                         scale: 2.5,
              //                       ),
              //                       width3SizedBox,
              //                       Text(
              //                         StringConstants.deliveryText,
              //                         style: const TextStyle(
              //                             fontSize: 12.0,
              //                             fontWeight: FontWeight.w500),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     Get.to(() => const SearchStoreUserScreen());
              //                   },
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         "assets/curb.png",
              //                         scale: 1.8,
              //                       ),
              //                       width3SizedBox,
              //                       Text(
              //                         StringConstants.curbSideText,
              //                         style: const TextStyle(
              //                             fontSize: 12.0,
              //                             fontWeight: FontWeight.w500),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 RawMaterialButton(
              //                   elevation: 0,
              //                   onPressed: () {},
              //                   constraints: const BoxConstraints(),
              //                   padding:
              //                       const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              //                   shape: RoundedRectangleBorder(
              //                     side: const BorderSide(
              //                         width: 1.0, color: AppColors.primary),
              //                     borderRadius: BorderRadius.circular(28.0),
              //                   ),
              //                   fillColor: AppColors.primary,
              //                   child: Text(
              //                     StringConstants.orderHereText,
              //                     style: const TextStyle(
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 14.0,
              //                         color: AppColors.white),
              //                   ),
              //                 ),
              //               ],
              //             )
              //           ]),
              //         ),
              //       );
              //     }),
              ),
        ]),
      ),
    );
  }
}
