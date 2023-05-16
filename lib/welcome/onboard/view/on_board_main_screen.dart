import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_four_screen.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_one_screen.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_three_screen.dart';
import 'package:thegreenmall/welcome/onboard/view/on_board_two_screen.dart';
import 'package:thegreenmall/welcome/startjourney/view/start_journey_screen.dart';
import 'package:thegreenmall/welcome/onboard/controller/on_board_controller.dart';

class OnBoardMainScreen extends StatefulWidget {
  const OnBoardMainScreen({Key? key}) : super(key: key);

  @override
  OnBoardMainScreenState createState() => OnBoardMainScreenState();
}

class OnBoardMainScreenState extends State<OnBoardMainScreen> {
  final OnboardController onboardController = Get.put(OnboardController());
  int previousPageValue = 0;
  late PageController controller;
  double _moveBar = 0.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    controller = PageController(initialPage: onboardController.page.value);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> introWidgetsList = <Widget>[
      const OnBoardOne(),
      const OnBoardTwo(),
      const OnBoardThree(),
      const OnBoardFour()
    ];
    return (Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const StartJourneyScreen(),
                ));
                // Get.offAll(const StartJourneyScreen());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              child: Text(StringConstants.skipText,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: AppColors.blacklight))),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: introWidgetsList.length,
            onPageChanged: (int page) {
              onboardController.page.value = page;
              debugPrint("object $page");
              getChangedPageAndMoveBar(page);
              setState(() {});
            },
            controller: controller,
            itemBuilder: (context, index) {
              return introWidgetsList[index];
            },
          ),
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: Platform.isIOS ? 130 : 105),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < introWidgetsList.length; i++)
                      if (i == onboardController.page.value) ...[
                        circleBar(true)
                      ] else
                        circleBar(false),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Material(
          type: MaterialType
              .transparency, //Makes it usable on any background color, thanks @IanSmith
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.0),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(
                    1000.0), //Something large to ensure a circle
                onTap: () {
                  controller.animateToPage(
                    onboardController.page.value + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                  if (onboardController.page.value == 3) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => const StartJourneyScreen(),
                    ));
                    // Get.offAll(const StartJourneyScreen());
                  }
                },
                child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: AppColors.white,
                    )),
              ),
            ),
          )),
      //  SizedBox(
      //   width: 50.0,
      //   height: 50.0,
      //   child: FloatingActionButton(
      //     elevation: 5,
      //     isExtended: true,
      //     backgroundColor: AppColors.primary,
      //     onPressed: () async {
      //       controller.animateToPage(
      //         onboardController.page.value + 1,
      //         duration: const Duration(milliseconds: 500),
      //         curve: Curves.ease,
      //       );
      //       if (onboardController.page.value == 3) {
      //         // SharedPreferences prefs =
      //         //     await SharedPreferences.getInstance();
      //         // prefs.setBool("onBoard", true);

      //         Get.offAll(const StartJourneyScreen());
      //       }
      //     },
      //     child: const Icon(Icons.arrow_forward_ios, size: 20),
      //   ),
      // ),
    ));
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 16 : 8,
      width: isActive ? 16 : 8,
      decoration: BoxDecoration(
          border: Border.all(
              color: isActive ? AppColors.primary : AppColors.grey,
              width: isActive ? 4.0 : 3.0),
          color: isActive ? AppColors.white : AppColors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  Widget expandingBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 25 : 8,
      decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.primarylight,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    onboardController.page.value = page;
    if (previousPageValue == 0) {
      previousPageValue = onboardController.page.value;
      _moveBar = _moveBar + 0.14;
    } else {
      if (previousPageValue < onboardController.page.value) {
        previousPageValue = onboardController.page.value;
        _moveBar = _moveBar + 0.14;
      } else {
        previousPageValue = onboardController.page.value;
        _moveBar = _moveBar - 0.14;
      }
    }

    setState(() {});
  }
}
