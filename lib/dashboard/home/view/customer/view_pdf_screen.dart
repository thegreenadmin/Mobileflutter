import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';

class PdfViewScreen extends StatefulWidget {
 final bool isShowPrivacy ;
 final String? url;
  const PdfViewScreen({Key? key, this.url, this.isShowPrivacy = false})
      : super(key: key);

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            color: AppColors.white,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5,bottom: 5),
                child: Text(
                  widget.isShowPrivacy
                      ? StringConstants.privacyPolicyText
                      : StringConstants.termsAndConditionsText,
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                )),
          )),
      body: SfPdfViewer.network(
        widget.url.toString(),
      ),
    );
  }
}
