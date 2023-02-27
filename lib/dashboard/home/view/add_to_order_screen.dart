import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/view/cart_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AddToOrderScreen extends StatefulWidget {
  const AddToOrderScreen({super.key});

  @override
  State<AddToOrderScreen> createState() => _AddToOrderScreenState();
}

class _AddToOrderScreenState extends State<AddToOrderScreen> {
  void addToCartDailogue(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height10SizedBox,
            Center(
              child: Image.asset(
                'assets/tick.png',
                scale: 3,
              ),
            ),
            height10SizedBox,
            Text(
              StringConstants.itemAddedInCart,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              style: TextStyle(
                  color: AppColors.blacklight,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            height25SizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        'More Product',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.to(const CartScreen());
                  },
                  child: Container(
                    height: 50.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Go to Cart',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const <Widget>[],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(145.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken),
                  image: NetworkImage(
                    'https://picsum.photos/250?image=9',
                  ),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 24.0,
                              ),
                            ),
                            Image.asset(
                              "assets/favoutline.png",
                              scale: 2.8,
                            ),
                          ]),
                      height10SizedBox,
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 1)),
                            child: const CircleAvatar(
                              radius: 28.0,
                              backgroundImage: NetworkImage(
                                  'https://picsum.photos/250?image=9'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          width10SizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Click & Collect",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              height8SizedBox,
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/loc.png",
                                    color: AppColors.white,
                                    scale: 2,
                                  ),
                                  width4SizedBox,
                                  const Text("Gate Village 10 Dubai 10017",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              height8SizedBox,
                              const Text("Store Hours 9:00 am to 9:00PM",
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringConstants.orderText,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.black),
              ),
              height20SizedBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Image.asset(
                      "assets/example.png",
                      scale: 5,
                    ),
                  ),
                  width10SizedBox,
                  Flexible(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Supplement bottle",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600)),
                            Image.asset(
                              "assets/fav.png",
                              scale: 2.8,
                            )
                          ],
                        ),
                        height8SizedBox,
                        SizedBox(
                          width: 200,
                          child: Text(
                              "Lorem Ipsum is simply Lorem Ipsum is simply Lorem Ipsum is simply Lorem Ipsum is simply ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.blacklight,
                                  fontWeight: FontWeight.w400)),
                        ),
                        height20SizedBox,
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: StringConstants.unitPriceText,
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
                        height20SizedBox,
                        Row(
                          children: [
                            InkWell(
                                child: Image.asset(
                              "assets/subtract.png",
                              scale: 2.5,
                            )),
                            width10SizedBox,
                            const Text(
                              "01",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.black),
                            ),
                            width10SizedBox,
                            InkWell(
                              child: Image.asset(
                                "assets/add.png",
                                scale: 2.5,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              height20SizedBox,
              Text(
                StringConstants.aboutProductText,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.black),
              ),
              height10SizedBox,
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since ",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black),
              ),
              height20SizedBox,
              CustomButton(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                onTap: () {
                  addToCartDailogue(context);
                },
                height: 50,
                text: StringConstants.addToOrderText,
                borderRadius: 12,
                fontWeight: FontWeight.w500,
                icon: false,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
