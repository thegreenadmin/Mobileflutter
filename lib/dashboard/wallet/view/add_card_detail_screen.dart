import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';
import 'package:thegreenmall/utils/utility.dart';

class AddCardDetailScreen extends StatefulWidget {
  AddCardDetailScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddCardDetailScreenState();
  }
}

class AddCardDetailScreenState extends State<AddCardDetailScreen> {
  final AddCardController addCardController = Get.put(AddCardController());
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 1.0,
      ),
    );
    super.initState();
  }

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
                          StringConstants.addCardText,
                          style: const TextStyle(
                              fontSize: 22,
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
      body: Column(
        children: <Widget>[
          Obx(
            () => CreditCardWidget(
              cardNumber: addCardController.cardNumber.value,
              expiryDate: addCardController.expiryDate.value,
              cardHolderName: addCardController.cardHolderName.value,
              cvvCode: addCardController.cvvCode.value,
              showBackView: addCardController.isCvvFocused.value,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.lightBlue,
              // backgroundImage:
              //     useBackgroundImage ? 'assets/card_bg.png' : null,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    ImageConstants.mastercard,
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: addCardController.cardNumber.value,
                    cvvCode: addCardController.cvvCode.value,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: addCardController.cardHolderName.value,
                    expiryDate: addCardController.expiryDate.value,
                    themeColor: Colors.blue,
                    textColor: Colors.black,
                    cardNumberDecoration: InputDecoration(
                      labelText: StringConstants.numberText,// 'Number',
                      hintText: StringConstants.x4Text,//'XXXX XXXX XXXX XXXX',
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                    expiryDateDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: StringConstants.expiredDateText,//'Expired Date',
                      hintText: StringConstants.x2Text,//'XX/XX',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: StringConstants.cvvText,//'CVV',
                      hintText: StringConstants.x1Text,//'XXX',
                    ),
                    cardHolderDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: StringConstants.cardHolderText,//'Card Holder',
                    ),
                    onCreditCardModelChange:
                        addCardController.onCreditCardModelChange,
                  ),
                  height30SizedBox,
                  CustomButton(
                    width: WidgetConstants.screenWidth * 0.9,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () async {
                      if (addCardController.cardHolderName.isEmpty) {
                        Utility.showToast(AlertStringConstants.pleaseFillAllDetailsText);
                      } else if (formKey.currentState!.validate()) {
                        addCardController.apiCreateStripeToken();
                      }
                    },
                    height: 50,
                    textColor: AppColors.white,
                    text: StringConstants.addCardText,
                    borderRadius: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
