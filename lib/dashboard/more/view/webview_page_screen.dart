import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPageScreen extends StatefulWidget {
  final String url;
  final String isFrom;

  const WebviewPageScreen({super.key, this.url = "", this.isFrom = ""});

  @override
  State<WebviewPageScreen> createState() => _WebviewPageScreenState();
}

class _WebviewPageScreenState extends State<WebviewPageScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    print(widget.url);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://docs.google.com/gview?embedded=true&url=${widget.url}"));
    // #enddocregion webview_controller
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
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
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  // Get.back();
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                widget.isFrom == "terms"
                                    ? StringConstants.termsOfServiceText
                                    : widget.isFrom == "aboutus"
                                        ? StringConstants.aboutUsText
                                        : widget.isFrom == "faq"
                                            ? StringConstants.faqText
                                            : widget.isFrom == "privacy"
                                                ? StringConstants
                                                    .privacyPolicyText
                                                : "",
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
      body: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
