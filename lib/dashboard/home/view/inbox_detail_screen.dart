import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/inbox_controller.dart';

class InboxDetailScreen extends StatefulWidget {
  const InboxDetailScreen({super.key});

  @override
  State<InboxDetailScreen> createState() => _InboxDetailScreenState();
}

class _InboxDetailScreenState extends State<InboxDetailScreen> {
  final InboxController inboxController = Get.put(InboxController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Hi"),
    );
  }
}
