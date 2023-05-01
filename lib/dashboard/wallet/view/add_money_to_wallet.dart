import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class AddMoneyToWallet extends StatefulWidget {
  const AddMoneyToWallet({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddMoneyToWalletState();
  }
}

class AddMoneyToWalletState extends State<AddMoneyToWallet> {
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
                          StringConstants.addMoneyToMyWalletText,
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
      body: SingleChildScrollView(
        child: Form(
          key: addCardController.formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height15SizedBox,
                Text(
                  StringConstants.amountText,
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                height12SizedBox,
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {},
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(40),
                    ],
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    controller: addCardController.amountTextController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AlertStringConstants.pleaseEnterAmountText;
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: StringConstants.amountText,
                      hintStyle: const TextStyle(color: AppColors.grey),
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                    )),
                height20SizedBox,
                Text(
                  StringConstants.paymentText,
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                height15SizedBox,
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.grey,
                        width: 1.0,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    StringConstants.selectTypeText,
                    style: const TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                  items: <String>["Google Pay", "Cards"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    addCardController.selectPaymentType.value = v.toString();
                    print(addCardController.selectPaymentType.value);
                  },
                ),
                height10SizedBox,
                Obx(
                  () => addCardController.selectPaymentType.value ==
                          "Google Pay"
                      ? height20SizedBox
                      : addCardController.selectPaymentType.value == "Cards"
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 30),
                              child: addCardController.cardList.isEmpty
                                  ? addCardController.isLoading.value == true
                                      ? height0SizedBox
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                "${StringConstants.noCardsFoundText}\n${StringConstants.pleaseAddCardFirstText}!",
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            height20SizedBox,
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: CustomButton(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    AppColors.primary,
                                                    AppColors.primary
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (_) =>  AddCardDetailScreen(),
                                                  ));
                                                  // Get.to(() =>
                                                  //     AddCardDetailScreen());
                                                },
                                                height: 50,
                                                width: WidgetConstants
                                                        .screenWidth *
                                                    0.3,
                                                text:
                                                    StringConstants.addCardText,
                                                borderRadius: 12,
                                                fontWeight: FontWeight.w500,
                                                iconL: false,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                  : ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return height15SizedBox;
                                      },
                                      itemCount:
                                          addCardController.cardList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (addCardController
                                            .userStripeCardId!.value.isEmpty) {
                                          addCardController
                                                  .userStripeCardId!.value =
                                              addCardController
                                                  .cardList[0].userStripeCardId
                                                  .toString();
                                          debugPrint(addCardController
                                              .userStripeCardId!.value);
                                        }
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              top: 15,
                                              bottom: 15),
                                          color: addCardController
                                                      .selectedIndex!.value ==
                                                  index
                                              ? AppColors.primary
                                              : AppColors.primarylight,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                addCardController.selectedIndex!
                                                    .value = index;

                                                addCardController
                                                        .userStripeCardId!
                                                        .value =
                                                    addCardController
                                                        .cardList[index]
                                                        .userStripeCardId
                                                        .toString();
                                                debugPrint(addCardController
                                                    .userStripeCardId!.value);
                                              });
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Image.asset(
                                                            ImageConstants
                                                                .mastercard,
                                                            fit: BoxFit.cover,
                                                            scale: 5),
                                                      ),
                                                      width15SizedBox,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            addCardController
                                                                .cardList[index]
                                                                .card!
                                                                .funding
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: addCardController
                                                                            .selectedIndex!
                                                                            .value ==
                                                                        index
                                                                    ? AppColors
                                                                        .white
                                                                    : AppColors
                                                                        .blacklight,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          height10SizedBox,
                                                          Text(
                                                            "**** **** **** **** ${addCardController.cardList[index].card!.last4}",
                                                            style: TextStyle(
                                                                color: addCardController
                                                                            .selectedIndex!
                                                                            .value ==
                                                                        index
                                                                    ? AppColors
                                                                        .white
                                                                    : AppColors
                                                                        .blacklight,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                        );
                                      }),
                            )
                          : height20SizedBox,
                ),
                CustomButton(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primary],
                  ),
                  onTap: () {
                    addCardController.validateAndSubmit(context);
                  },
                  height: 50,
                  text: StringConstants.okText,
                  borderRadius: 12,
                  fontWeight: FontWeight.w500,
                  iconL: false,
                  fontSize: 16,
                ),
                height20SizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
