import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hi, Julia Adrew",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.black,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              StringConstants.walletText,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/homeMall.png",
                          scale: 4,
                        )
                      ]),
                ],
              )),
        ),
      ),
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/walletCard.png"),
              height20SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/dollar.png",
                    scale: 3.4,
                  ),
                  width15SizedBox,
                  Column(
                    children: [
                      const Text(
                        "\$30,420",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w500),
                      ),
                      height8SizedBox,
                      const Text(
                        "Total Balance",
                        style: TextStyle(color: AppColors.white, fontSize: 18),
                      ),
                      height12SizedBox,
                      Image.asset(
                        "assets/addMoney.png",
                        scale: 3.5,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          height20SizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/setting.png",
                      scale: 3.5,
                    ),
                    Text(
                      StringConstants.manageText,
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              // Divider(color: AppColors.red),
              Container(
                color: AppColors.grey,
                width: 1,
                height: 40,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/pickup.png",
                      scale: 3.5,
                    ),
                    Text(
                      StringConstants.pickupPackageText,
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
