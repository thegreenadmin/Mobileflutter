import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OnBoardFour extends StatefulWidget {
  const OnBoardFour({Key? key}) : super(key: key);

  @override
  OnBoardFourState createState() => OnBoardFourState();
}

class OnBoardFourState extends State<OnBoardFour> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 300.0),
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/onBoardBg.png"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: WidgetConstants.screenHeight * 0.40,
                        width: WidgetConstants.screenWidth,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset("assets/onBoardFour.png"),
                            Positioned(
                              right: 90,
                              bottom: 90,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/bottle.png",
                                    scale: 3,
                                  )),
                            ),
                          ],
                        )),
                    height20SizedBox,
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: "Add your",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 24)),
                          TextSpan(
                            text: ' product',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    height10SizedBox,
                    Text(
                      StringConstants.usingOurDigitalPlatformText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blacklight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
