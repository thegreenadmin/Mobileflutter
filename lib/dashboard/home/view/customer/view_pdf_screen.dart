import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewPdfScreen extends StatefulWidget {
  String url = "";
  ViewPdfScreen({super.key, this.url = ""});

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PDFView(
      filePath: widget.url,
      autoSpacing: true,
      enableSwipe: true,
    ));
  }
}
