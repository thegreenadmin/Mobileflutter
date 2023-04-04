// import 'package:flutter/material.dart';
// import 'package:thegreenmall/utils/app_colors.dart';
// import 'package:thegreenmall/utils/constants.dart';
// import 'package:thegreenmall/utils/image_constants.dart';
// import 'package:thegreenmall/utils/sizedbox_constants.dart';

// class StoreFeaturedScreen extends StatefulWidget {
//   const StoreFeaturedScreen({super.key});

//   @override
//   State<StoreFeaturedScreen> createState() => _StoreFeaturedScreenState();
// }

// class _StoreFeaturedScreenState extends State<StoreFeaturedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Expanded(
//             child: GridView.builder(
//               itemCount: 6,
//               shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: (WidgetConstants.screenWidth + 120) /
//                     WidgetConstants.screenHeight,
//                 mainAxisSpacing: 0.0,
//                 crossAxisSpacing: 0.0,
//                 crossAxisCount: 2,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Card(
//                       shape: BeveledRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       elevation: 0,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Stack(
//                           alignment: Alignment.topRight,
//                           children: [
//                             Image.asset(
//                               ImageConstants.nopicfound,
//                               fit: BoxFit.fill,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Image.asset(
//                                 ImageConstants.fav,
//                                 scale: 3,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     height5SizedBox,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Skin toner cosmetic",
//                           style: TextStyle(
//                               color: AppColors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         height4SizedBox,
//                         Text(
//                           "Lorem Ipsum is simply",
//                           maxLines: 2,
//                           style: TextStyle(
//                               color: AppColors.blacklight,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         height4SizedBox,
//                         const Text(
//                           "Unit price: \$20.00",
//                           style: TextStyle(
//                               color: AppColors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
