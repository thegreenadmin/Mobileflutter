import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class OnBoardTwo extends StatefulWidget {
  const OnBoardTwo({Key? key}) : super(key: key);

  @override
  OnBoardTwoState createState() => OnBoardTwoState();
}

class OnBoardTwoState extends State<OnBoardTwo> {
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
              padding: const EdgeInsets.only(bottom: 80.0, left: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 0),
                        height: WidgetConstants.screenHeight * 0.40,
                        //width: WidgetConstants.screenWidth * 0.35,
                        child: Image.asset("assets/onBoardTwo.png")),
                    height20SizedBox,
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: "Shop your favorite",
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
                      StringConstants.usingOurSearchText,
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
