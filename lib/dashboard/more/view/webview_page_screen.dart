import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPageScreen extends StatefulWidget {
  final String url;
  final String isFrom;

  const WebviewPageScreen({super.key, this.url = "", this.isFrom = ""});

  @override
  State<WebviewPageScreen> createState() => _WebviewPageScreenState();
}

class _WebviewPageScreenState extends State<WebviewPageScreen> with GlobalVarMixin{
  late final WebViewController controller;
  var pageId = 0;
  bool _hasReturnedFromConnect = false;
  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _handleConnectAccountReturn(url);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    // #enddocregion webview_controller
  }

  // After a successful Stripe Connect onboarding, Stripe redirects to the
  // backend return_url (".../stripe?messageType=return"). When we land there,
  // pop back to the wallet screen so the caller can refresh account details.
  void _handleConnectAccountReturn(String url) {
    if (widget.isFrom != 'connectAccount' || _hasReturnedFromConnect) {
      return;
    }
    if (url.contains('messageType=return')) {
      _hasReturnedFromConnect = true;
      pageIdApp.value == 0 ? Get.back() : Get.back(id: pageIdApp.value);
    }
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primaryLight,
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
                              Image.asset(
                                ImageConstants.homeMall,
                                scale: 4,
                              ),
                              width10SizedBox,
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  pageIdApp.value == 0
                                      ? Get.back()
                                      : Get.back(id: pageIdApp.value);
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
                                                : widget.isFrom ==
                                                        'connectAccount'
                                                    ? "Connect Account"
                                                    : "",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ]),
                  ],
                )),
          )),
      body: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5, top: 0),
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
