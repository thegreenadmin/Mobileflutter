import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

bottomSheetChangePickupLocation(context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height15SizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            StringConstants.selectLocationText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              "assets/cross.png",
                              scale: 3,
                            ))
                      ],
                    ),
                    height15SizedBox,
                    ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return height12SizedBox;
                        },
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                                color: AppColors.greylight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                )),
                            child: Column(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 200,
                                        child: Text(
                                          "Gate Village 10 , Dubai 10017",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      height6SizedBox,
                                      const SizedBox(
                                        width: 200,
                                        child: Text(
                                          "Lorem Ipsum is simply dummy ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  false
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/circle.png",
                                              scale: 3.5,
                                            ),
                                            Image.asset(
                                              "assets/whitetick.png",
                                              scale: 4,
                                            ),
                                          ],
                                        )
                                      : Image.asset(
                                          "assets/circleunfill.png",
                                          scale: 4,
                                        ),
                                ],
                              ),
                            ]),
                          );
                        }),
                    height10SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {},
                      height: 50,
                      text: StringConstants.changeText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconL: false,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      }).then((value) => {});
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              color: AppColors.primarylight,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
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
                                  StringConstants.cartText,
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                StringConstants.itemsText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              height10SizedBox,
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return height12SizedBox;
                  },
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                          color: AppColors.greylight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          )),
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: 80,
                                height: 90,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: AppColors.primary, width: 0)),
                                child: Image.network(
                                  'https://picsum.photos/250?image=9',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            width10SizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Supplement bottle",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                height6SizedBox,
                                const SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Lorem Ipsum is simply dummy ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                height15SizedBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  StringConstants.unitPriceText,
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16)),
                                          const TextSpan(
                                            text: ' \$20.00',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: AppColors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width10SizedBox,
                                    Row(
                                      children: [
                                        InkWell(
                                            child: Image.asset(
                                          "assets/subtract.png",
                                          scale: 3,
                                        )),
                                        width6SizedBox,
                                        const Text(
                                          "01",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: AppColors.black),
                                        ),
                                        width6SizedBox,
                                        InkWell(
                                          child: Image.asset(
                                            "assets/add.png",
                                            scale: 3,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ]),
                    );
                  }),
              height10SizedBox,
              Text(
                StringConstants.orderType,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              height10SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: WidgetConstants.screenWidth * 0.4,
                    border: Border.all(color: AppColors.primary),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.white, AppColors.white],
                    ),
                    onTap: () {},
                    height: 45,
                    text: StringConstants.pickupText,
                    textColor: AppColors.primary,
                    borderRadius: 12,
                    fontWeight: FontWeight.w500,
                    iconL: true,
                    fontSize: 16,
                    imageL: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 24.0,
                    ),
                  ),
                  width10SizedBox,
                  CustomButton(
                    width: WidgetConstants.screenWidth * 0.4,
                    border: Border.all(color: AppColors.primary),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.white, AppColors.white],
                    ),
                    onTap: () {},
                    height: 45,
                    text: StringConstants.pickupText,
                    textColor: AppColors.primary,
                    borderRadius: 12,
                    fontWeight: FontWeight.w500,
                    iconL: true,
                    fontSize: 16,
                    imageL: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
              height20SizedBox,
              Text(
                StringConstants.pickUpLocationText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              height20SizedBox,
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: const BoxDecoration(
                      color: AppColors.greylight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/loc.png",
                                  scale: 2.5,
                                ),
                                width10SizedBox,
                                const Text(
                                  "Gate Village 10 , Dubai 10017",
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                "3 .5 Miles away",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        width10SizedBox,
                        InkWell(
                          onTap: () {
                            bottomSheetChangePickupLocation(context);
                          },
                          child: Container(
                            height: 40.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                StringConstants.changeText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ])),
              height10SizedBox,
              Text(
                StringConstants.orderSummaryText,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              height10SizedBox,
              Center(
                child: DottedBorder(
                  color: AppColors.blacklight,
                  strokeWidth: 1,
                  dashPattern: const [4, 4],
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    color: AppColors.greylight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringConstants.subtotalText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Text(
                                "\$40.00",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          height10SizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringConstants.taxText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Text(
                                "\$40.00",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          height10SizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringConstants.serviceFeesText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Text(
                                "\$40.00",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
