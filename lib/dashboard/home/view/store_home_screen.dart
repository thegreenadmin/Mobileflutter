import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  List<String> imgList = [
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
    'assets/examplee.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: StringConstants.welcomeToText,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontWeight: FontWeight.w400,
                                fontSize: 22)),
                        const TextSpan(
                          text: ' click & collect',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height20SizedBox,
              Image.asset("assets/examplee.png"),
              height30SizedBox,
              Text(
                StringConstants.featuredProductText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
              SizedBox(
                height: 280,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return width8SizedBox;
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: imgList.length,
                  itemBuilder: (BuildContext context, int index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: 180,
                          width: 180,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/example.png",
                              fit: BoxFit.cover,
                            ),
                          )),
                      height8SizedBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Skin toner cosmetic",
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          height4SizedBox,
                          Text(
                            "Lorem Ipsum is simply",
                            maxLines: 2,
                            style: TextStyle(
                                color: AppColors.blacklight,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          height4SizedBox,
                          const Text(
                            "Unit price: \$20.00",
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
