import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';

import '../../../../../utils/global_share_data.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String image;

  const ImagePreviewScreen({Key? key, this.image = ""}) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  RxInt pageId = 0.obs;
  @override
  void initState() {
    super.initState();
    getPage();
  }

  getPage()async{
    pageId.value =await SharedPreferenceStorage.getData("pageId");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                   Get.back(id:pageIdApp.value);
                                  // Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.black,
                                    size: 24.0,
                                  ),
                                ),
                                width10SizedBox,
                                Text(
                                  StringConstants.imageText,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Image.asset(
                              ImageConstants.homeMall,
                              scale: 4,
                            )
                          ]),
                    ],
                  )),
            )),
        body: SizedBox(
          height: Get.height,
          child: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 80),
                child: SizedBox(
                    width: Get.width,
                    child: widget.image == ""
                        ? height0SizedBox
                        : Container(
                            width: Get.width,
                            constraints: BoxConstraints.loose(Size(
                              Get.width,
                              Get.height,
                            )),
                            child: Image.network(
                              widget.image,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high,
                            ))),
              ),
            )
          ]),
        ));
  }
}
