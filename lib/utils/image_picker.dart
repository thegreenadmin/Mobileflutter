// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart' as ip;


// class ImagePickerClass {
//   static final ip.ImagePicker picker = ip.ImagePicker();
//   static Future<List<String>> pickImage(String imageSource, int count) async {
//     List<String> imageFile = [];
//     if (imageSource == 'Gallery') {
//       if (Platform.isIOS) {
//         picker.pickImage(source: ip.ImageSource.gallery).then((value) {
//           imageFile.add(value!.path);
//         }).catchError((error) {
//           (error.toString());
//         });
//         // await ImagesPicker.pick(count: count, pickType: PickType.image)
//         //     .then((value) {
//         //   imageFile.add(value!.elementAt(0).path);
//         // }).catchError((error) {
//         //   print(error.toString());
//         // });
//       } else {
//         picker.pickMultiImage().then((value) async {
//           for (int i = 0; i < (value?.length ?? 0); i++) {
//             imageFile.add(value?.elementAt(i).path ?? "");
//           }
//         }).catchError((error) {
//           debugPrint(error.toString());
//         });

//         // await MultiImagePicker.pickImages(
//         //   maxImages: count,
//         //   enableCamera: false,
//         //   materialOptions: MaterialOptions(
//         //     actionBarColor: colorPrimaryStr,
//         //     actionBarTitle: appName,
//         //     allViewTitle: "All Photos",
//         //     useDetailsView: false,
//         //     selectionLimitReachedText: "Please select $count images at a time",
//         //     selectCircleStrokeColor: colorPrimaryStr,
//         //   ),
//         // ).then((value) async {
//         //   for (int i = 0; i < value.length; i++) {
//         //     imageFile.add(value.elementAt(i).identifier!);
//         //   }
//         // }).catchError((error) {
//         //   print(error.toString());
//         // });
//       }
//     } else if (imageSource == 'Camera') {
//       picker.pickImage(source: ip.ImageSource.camera).then((value) {
//         imageFile.add(value!.path);
//       }).catchError((error) {
//         debugPrint(error.toString());
//       });

//       // await ImagesPicker.openCamera(
//       //   pickType: PickType.image,
//       //   maxTime: 30,
//       // ).then((value) {
//       //   imageFile.add(value!.elementAt(0).path);
//       // }).catchError((error) {
//       //   print(error.toString());
//       // });
//     }
//     return imageFile;
//   }
// }
