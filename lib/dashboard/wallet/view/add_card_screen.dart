import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';

import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddCardScreenState();
  }
}

class AddCardScreenState extends State<AddCardScreen> {
  final AddCardController addCardController = Get.put(AddCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: AppColors.primarylight,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // Get.back();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.black,
                            size: 24.0,
                          ),
                        ),
                        width10SizedBox,
                        Text(
                          StringConstants.cardAndPaymentText,
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Image.asset(
                      ImageConstants.homeMall,
                      scale: 4,
                    )
                  ])),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Obx(
            () => Container(
              height: WidgetConstants.screenHeight,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: addCardController.cardList.isEmpty
                  ? addCardController.isLoading.value == true
                      ? height0SizedBox
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                ImageConstants.nodata,
                                scale: 8,
                                color: AppColors.primary,
                              ),
                            ),
                            height4SizedBox,
                            Center(
                              child: Text(
                                StringConstants.noCardsFoundText,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return height15SizedBox;
                      },
                      itemCount: addCardController.cardList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 15, bottom: 15),
                          color: AppColors.primarylight,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Image.asset(
                                          ImageConstants.mastercard,
                                          fit: BoxFit.cover,
                                          scale: 5),
                                    ),
                                    width15SizedBox,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addCardController
                                              .cardList[index].card!.funding
                                              .toString(),
                                          style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        height10SizedBox,
                                        Text(
                                          "**** **** **** **** ${addCardController.cardList[index].card!.last4}",
                                          style: TextStyle(
                                              color: AppColors.blacklight,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                    onTap: () async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              StringConstants.alertText,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.black,
                                                  fontSize: 20),
                                            ),
                                            content: Text(
                                                AlertStringConstants
                                                    .areYouSureText,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black,
                                                    fontSize: 20)),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                    addCardController.apiDeleteCard(
                                                        userStripeCardId:
                                                            addCardController
                                                                    .cardList[
                                                                        index]
                                                                    .userStripeCardId ??
                                                                "");
                                                  },
                                                  child: Text(StringConstants
                                                      .deleteText)),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                    StringConstants.cancelText),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                      ImageConstants.deleteicon,
                                      scale: 3.0,
                                    )),
                              ]),
                        );
                      }),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: CustomButton(
              border: Border.all(
                color: AppColors.primary,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.white, AppColors.white],
              ),
              onTap: () {
                Get.to(AddCardDetailScreen())!
                    .then((value) => addCardController.apiGetCardList());
              },
              height: 50,
              text: StringConstants.addNewCardText,
              textColor: AppColors.primary,
              borderRadius: 14,
              fontWeight: FontWeight.w500,
              iconL: false,
              iconR: false,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
