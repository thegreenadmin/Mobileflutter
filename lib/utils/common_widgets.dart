// /*
// * add icon to add game view*/
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taskroulette/utils/app_colors.dart';


// class CommonWidgets {
//   //Bold
//   // static Widget txtViewBold(
//   //     String text, Color color, double size, double height,
//   //     {FontWeight weight}) {
//   //   return Text(
//   //     text,
//   //     overflow: TextOverflow.ellipsis,
//   //     style: TextStyle(
//   //         color: color,
//   //         fontSize: size,
//   //         height: 0,
//   //         fontWeight: weight ?? FontWeight.bold,
//   //         fontFamily: 'Poppins'),
//   //   );
//   // }

//   //500
//   // static Widget txtViewMediumBold(String text, Color color, double size,
//   //     {FontWeight weight}) {
//   //   return Text(
//   //     text,
//   //     overflow: TextOverflow.ellipsis,
//   //     style: TextStyle(
//   //         color: color,
//   //         fontSize: size,
//   //         fontWeight: FontWeight.w500,
//   //         fontFamily: 'Poppins'),
//   //   );
//   // }

//   // //400
//   // static Widget txtViewSemiBold(String text, Color color, double size,
//   //     {FontWeight weight}) {
//   //   return Text(
//   //     text,
//   //     overflow: TextOverflow.ellipsis,
//   //     style: TextStyle(
//   //         color: color,
//   //         fontSize: size,
//   //         fontWeight: FontWeight.w400,
//   //         fontFamily: 'Poppins'),
//   //   );
//   // }

//   //Italics
//   static Widget txtViewItalics(String text, Color color, double size) {
//     return Text(
//       text,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(
//           fontStyle: FontStyle.italic,
//           color: color,
//           fontSize: size,
//           fontWeight: FontWeight.w500,
//           fontFamily: 'Poppins'),
//     );
//   }

//   static Widget txtView(String text, Color color, double size) {
//     return Text(
//       text,
//       overflow: TextOverflow.ellipsis,
//       style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins'),
//     );
//   }

//   static Widget imageView(String image) {
//     return Image.asset(
//       image,
//       fit: BoxFit.fill,
//     );
//   }

//   static Widget appBar() {
//     return AppBar(
//       backgroundColor: AppColors.primary,
//       elevation: 0,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 30.0),
//         child: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: AppColors.blacklight,
//             size: 35,
//           ),
//         ),
//       ),
//     );
//   }

//   // static Widget appBarHome(String title) {
//   //   return AppBar(
//   //       leading: Padding(
//   //         padding: const EdgeInsets.all(10.0),
//   //         child: Container(
//   //           height: 45,
//   //           width: 45,
//   //           decoration: const BoxDecoration(
//   //             image: DecorationImage(
//   //               image: AssetImage("assets/images/splash_logo.png"),
//   //               fit: BoxFit.fill,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //       automaticallyImplyLeading: false,
//   //       backgroundColor: Colors.transparent,
//   //       elevation: 0,
//   //       centerTitle: true,
//   //       title: CommonWidgets.txtViewMediumBold(
//   //         title,
//   //         AppColors.blacklightColor,
//   //         18,
//   //       ));
//   // }

//   // static Widget mainInternetTopSnackBar(Widget furtherWidget) {
//   //   return Obx(
//   //     () => Column(
//   //       children: [
//   //         AnimatedSwitcher(
//   //             duration: const Duration(seconds: 2),
//   //             child: !isNetworkConnected.value
//   //                 ? Material(
//   //                     elevation: 0.0,
//   //                     borderOnForeground: false,
//   //                     child: Container(
//   //                       color: Colors.redAccent,
//   //                       child: SafeArea(
//   //                         top: true,
//   //                         left: false,
//   //                         right: false,
//   //                         bottom: false,
//   //                         child: Container(
//   //                           width: WidgetConstants.screenWidth,
//   //                           height: 30,
//   //                           color: Colors.redAccent,
//   //                           child: const Center(
//   //                             child: Text(
//   //                               "No Internet Connection",
//   //                               textAlign: TextAlign.center,
//   //                               style: TextStyle(
//   //                                   fontSize: 15,
//   //                                   fontWeight: FontWeight.w500,
//   //                                   color: Colors.white),
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   )
//   //                 : const SizedBox()),
//   //         Expanded(child: furtherWidget)
//   //       ],
//   //     ),
//   //   );
//   // }
// }
