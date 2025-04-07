import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/more/controller/more_controller.dart';
import 'package:thegreenmall/dashboard/more/view/contact_us_screen.dart';
import 'package:thegreenmall/dashboard/more/view/webview_page_screen.dart';
import 'package:thegreenmall/utils/common_appBar.dart';
import 'package:thegreenmall/utils/utils.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with GlobalVarMixin{
  final MoreController moreController = Get.put(MoreController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Column(
        children: [

          Obx(() => CommonAppBar(
                showActiveCart: false,
                role: moreController.role!.value,
                cartCount: moreController.searchStoreUserController.cartCount.value,
                storeId:
                    moreController.searchStoreUserController.storeIdValue.value,
                cartLength:
                    moreController.searchStoreUserController.cartCount.value,
                firstName: moreController.firstName!.value,
                labelText: StringConstants.moreText,
                lastName: moreController.lastName!.value,
                okayTap: () {
                  moreController.searchStoreUserController.apiActiveCartApi();
                },
                isFromNotification: false)),

          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    /* SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => WebviewPageScreen(
                            isFrom: "aboutus",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pageAbout)
                                .toString())));*/
                    Get.to(
                        WebviewPageScreen(
                            isFrom: "aboutus",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pageAbout)
                                .toString()),
                        id: pageIdApp.value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageConstants.aboutUs,
                              color: AppColors.primary,
                              scale: 2.5,
                            ),
                            width18SizedBox,
                            Text(StringConstants.aboutUsText,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Image.asset(
                          ImageConstants.arrowForward,
                          scale: 3.4,
                          color: AppColors.blackLight,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => WebviewPageScreen(
                    //         isFrom: "faq",
                    //         url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                    //                 ServerCommunicator.pageFaq)
                    //             .toString())));
                    Get.to(
                        WebviewPageScreen(
                            isFrom: "faq",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pageFaq)
                                .toString()),
                        id: pageIdApp.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConstants.faq,
                            color: AppColors.primary,
                            scale: 2.5,
                          ),
                          width18SizedBox,
                          Text(StringConstants.faqText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Image.asset(
                        ImageConstants.arrowForward,
                        scale: 3.4,
                        color: AppColors.blackLight,
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (_) => const ContactUsScreen(),
                    // ));
                    Get.to(() =>  ContactUsScreen(), id: pageIdApp.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConstants.contactUs,
                            color: AppColors.primary,
                            scale: 2.5,
                          ),
                          width18SizedBox,
                          Text(StringConstants.contactUsText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Image.asset(
                        ImageConstants.arrowForward,
                        scale: 3.4,
                        color: AppColors.blackLight,
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    /* SharedPreferenceStorage.setData("context", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => WebviewPageScreen(
                            isFrom: "terms",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pageTerms)
                                .toString())));*/
                    Get.to(
                        WebviewPageScreen(
                            isFrom: "terms",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pageTerms)
                                .toString()),
                        id: pageIdApp.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConstants.terms,
                            color: AppColors.primary,
                            scale: 2.5,
                          ),
                          width18SizedBox,
                          Text(StringConstants.termsOfServiceText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Image.asset(
                        ImageConstants.arrowForward,
                        scale: 3.4,
                        color: AppColors.blackLight,
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 40,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    // SharedPreferenceStorage.setData("context", context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => WebviewPageScreen(
                    //         isFrom: "privacy",
                    //         url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                    //                 ServerCommunicator.pagePolicy)
                    //             .toString())));
                    Get.to(
                        WebviewPageScreen(
                            isFrom: "privacy",
                            url: Uri.parse(ServerCommunicator.baseUrlWithoutApi +
                                    ServerCommunicator.pagePolicy)
                                .toString()),
                        id: pageIdApp.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImageConstants.privacy,
                            color: AppColors.primary,
                            scale: 2.5,
                          ),
                          width18SizedBox,
                          Text(StringConstants.privacyPolicyText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Image.asset(
                        ImageConstants.arrowForward,
                        scale: 3.4,
                        color: AppColors.blackLight,
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
