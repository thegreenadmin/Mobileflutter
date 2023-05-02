import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/create_owner_bankaccount_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/custom_button.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class PayOutScreen extends StatefulWidget {
  const PayOutScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PayOutScreenState();
  }
}

class PayOutScreenState extends State<PayOutScreen> {
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
                          StringConstants.payoutText,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: addCardController.formKey,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => addCardController.storeList.isEmpty
                      ? Column(
                          children: [
                            Text(StringConstants.toKnowBalanceYouDontHaveText),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                StringConstants.selectStoreText,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
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
                                hint: Text(
                                  StringConstants.selectStoreText,
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                  ),
                                ),
                                items: addCardController.storeList
                                    .map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value.storeId,
                                    child: Text(
                                      value.storeName,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  addCardController.storeId!.value =
                                      value.toString();
                                },
                              ),
                            ),
                          ],
                        )),
                  height25SizedBox,
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          StringConstants.amountText,
                          style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            controller:
                                addCardController.payoutAmountTextController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AlertStringConstants
                                    .pleaseEnterAmountText;
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
                      ),
                    ],
                  ),
                  height30SizedBox,
                  Text(
                    StringConstants.bankAccountsText,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  height10SizedBox,
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: addCardController.bankAccountList.isEmpty
                            ? addCardController.isLoading.value == true
                                ? height0SizedBox
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          "${StringConstants.noBankDetailsFoundText}\n${StringConstants.pleaseAddBankDetailFirstText}!",
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
                                            Get.to(() =>
                                                    const CreateOwnerBankAccount())!
                                                .then((value) => addCardController
                                                    .apiGetBankAccountList());
                                          },
                                          height: 50,
                                          width:
                                              WidgetConstants.screenWidth * 0.3,
                                          text: StringConstants
                                              .addBankDetailsText,
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
                                    addCardController.bankAccountList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  if (addCardController
                                      .userStripeBankId!.value.isEmpty) {
                                    addCardController.userStripeBankId!.value =
                                        addCardController
                                            .bankAccountList[0].userStripeBankId
                                            .toString();
                                    debugPrint(addCardController
                                        .userStripeBankId!.value);
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 10,
                                        top: 15,
                                        bottom: 15),
                                    color: addCardController
                                                .selectedBankAccountIndex!
                                                .value ==
                                            index
                                        ? AppColors.primary
                                        : AppColors.primarylight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          addCardController
                                              .selectedBankAccountIndex!
                                              .value = index;
                                          addCardController
                                                  .userStripeCardId!.value =
                                              addCardController
                                                  .bankAccountList[index]
                                                  .userStripeBankId
                                                  .toString();
                                          debugPrint(addCardController
                                              .userStripeCardId!.value);
                                        });
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                width15SizedBox,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      addCardController
                                                          .bankAccountList[
                                                              index]
                                                          .card!
                                                          .accountHolderName
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: addCardController
                                                                      .selectedBankAccountIndex!
                                                                      .value ==
                                                                  index
                                                              ? AppColors.white
                                                              : AppColors
                                                                  .blacklight,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    height10SizedBox,
                                                    Text(
                                                      "**** **** **** **** ${addCardController.bankAccountList[index].card!.last4}",
                                                      style: TextStyle(
                                                          color: addCardController
                                                                      .selectedBankAccountIndex!
                                                                      .value ==
                                                                  index
                                                              ? AppColors.white
                                                              : AppColors
                                                                  .blacklight,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                      )),
                  height20SizedBox,
                  CustomButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.primary],
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      addCardController.validateAndSubmit(isFromPayout: true);
                    },
                    height: 50,
                    text: StringConstants.oKText,
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
      ),
    );
  }
}
