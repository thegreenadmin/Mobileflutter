// import 'package:dio/dio.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DownloadScreen extends StatefulWidget {
//   @override
//   State<DownloadScreen> createState() => _DownloadScreenState();
// }

// class _DownloadScreenState extends State<DownloadScreen> {
//   String fileurl = "https://fluttercampus.com/sample.pdf";
//   //you can save other file formats too.
//   String savePath = "";
//   downloadPdF() async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//       //add more permission to request here.
//     ].request();
//     if (statuses[Permission.storage]!.isGranted) {
//       var dir = await DownloadsPathProvider.downloadsDirectory;
//       if (dir != null) {
//         String savename = "file.pdf";
//         savePath = dir.path + "/$savename";
//         print(savePath);
//         //output:  /storage/emulated/0/Download/banner.png
//         try {
//           await Dio().download(fileurl, savePath,
//               onReceiveProgress: (received, total) {
//             if (total != -1) {
//               print("${(received / total * 100).toStringAsFixed(0)}%");
//               //you can build progressbar feature too
//             }
//           });
//           print("File is saved to download folder.");
//         } on DioError catch (e) {
//           print(e.message);
//         }
//       }
//     } else {
//       print("No permission to read and write.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text("Download File from URL"),
//           backgroundColor: Colors.deepPurpleAccent,
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 downloadPdF();
//               },
//               child: const Text("Download File."),
//             )
//           ],
//         ),
//         body: PDFView(
//           filePath: savePath,
//         ));
//   }
// }
