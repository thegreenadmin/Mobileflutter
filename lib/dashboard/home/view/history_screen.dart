import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/history_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController historyController = HistoryController();
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
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.historyText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/homeMall.png",
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() => ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return height12SizedBox;
            },
            itemCount: historyController.historyList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                      color: AppColors.primarylight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      )),
                  child: Column(children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primary, width: 1)),
                          child: const CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage(
                                'https://picsum.photos/250?image=9'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        width10SizedBox,
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Order ID",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                        text: ': #45123',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.blacklight),
                                      ),
                                    ],
                                  ),
                                ),
                                width15SizedBox,
                                Text("20 Feb 2023",
                                    style: TextStyle(
                                        color: AppColors.blacklight,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                              ],
                            ),
                            height8SizedBox,
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: historyController
                                              .historyList[index],
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16)),
                                      const WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: SizedBox(width: 25)),
                                      const TextSpan(
                                        text: "\$ 30.15",
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            height6SizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "City: ",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                        text: "",
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Mobile: ",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                        text: "",
                                        style: TextStyle(
                                            color: AppColors.blacklight,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.blacklight,
                                  size: 22.0,
                                ),
                              ],
                            ),
                            height6SizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "New york: ",
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                        text: "+1230 4562 12",
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ]),
                ),
              );
            })),
      ),
    );
  }
}
