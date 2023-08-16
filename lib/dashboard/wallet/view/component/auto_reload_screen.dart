import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/add_card_controller.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_card_detail_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class AutoReloadScreen extends StatefulWidget {
  final bool isFromEdit;
  const AutoReloadScreen({Key? key, this.isFromEdit = false}) : super(key: key);

  @override
  State<AutoReloadScreen> createState() => _AutoReloadScreenState();
}

class _AutoReloadScreenState extends State<AutoReloadScreen> {
  final WalletController walletController = Get.put(WalletController());
  final AddCardController addCardController = Get.put(AddCardController());

  @override
  initState() {
    super.initState();
    addCardController.selectPaymentType.value = "";
    walletController.monthDays();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        height: WidgetConstants.screenHeight * 0.9,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: walletController.formKeyAutoCharge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height15SizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        StringConstants.autoReloadText,
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
                          Get.back(id: pageIdApp.value);
                          // Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          ImageConstants.cross,
                          scale: 3,
                        ))
                  ],
                ),
                height20SizedBox,
                Obx(
                  () => Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: InkWell(
                          onTap: () {
                            walletController.autoChargeType.value = "threshold";
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                                border: Border.all(
                                  color:
                                      walletController.autoChargeType.value ==
                                              "threshold"
                                          ? AppColors.primary
                                          : AppColors.blacklight,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                walletController.autoChargeType.value ==
                                        "threshold"
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.circleunfill,
                                            scale: 4,
                                          ),
                                          Image.asset(
                                            ImageConstants.circle,
                                            scale: 7,
                                          ),
                                        ],
                                      )
                                    : Image.asset(
                                        ImageConstants.circleBlackUnFill,
                                        scale: 2.8,
                                      ),
                                width8SizedBox,
                                Text(
                                  StringConstants.thresholdText,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      width20SizedBox,
                      Flexible(
                        flex: 4,
                        child: InkWell(
                          onTap: () {
                            walletController.autoChargeType.value = "cyclic";
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                                border: Border.all(
                                  color:
                                      walletController.autoChargeType.value ==
                                              "cyclic"
                                          ? AppColors.primary
                                          : AppColors.blacklight,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                walletController.autoChargeType.value ==
                                        "cyclic"
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            ImageConstants.circleunfill,
                                            scale: 4,
                                          ),
                                          Image.asset(
                                            ImageConstants.circle,
                                            scale: 7,
                                          ),
                                        ],
                                      )
                                    : Image.asset(
                                        ImageConstants.circleBlackUnFill,
                                        scale: 2.8,
                                      ),
                                width8SizedBox,
                                Text(
                                  StringConstants.periodicallyText,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                height20SizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.amountToBeAddedText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height4SizedBox,
                    Obx(
                      () => walletController.autoChargeType.value == "threshold"
                          ? TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(100),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ],
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              controller:
                                  walletController.chargeAmountTextController,
                              validator: (value) {
                                if (walletController.autoChargeType.value ==
                                        "threshold" &&
                                    (value == null || value.trim().isEmpty)) {
                                  return AlertStringConstants
                                      .pleaseEnterChargeAmountText;
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "eg \$10",
                                hintStyle:
                                    const TextStyle(color: AppColors.grey),
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
                              ))
                          : TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(100),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ],
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              controller: walletController
                                  .periodChargeAmountTextController,
                              validator: (value) {
                                if (walletController.autoChargeType.value ==
                                        "cyclic" &&
                                    (value == null || value.trim() == "")) {
                                  return AlertStringConstants
                                      .pleaseEnterChargeAmountText;
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "eg \$10.00",
                                hintStyle:
                                    const TextStyle(color: AppColors.grey),
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
                    height20SizedBox,
                    Obx(
                      () => walletController.autoChargeType.value == "threshold"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringConstants.whenBalanceBelowText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                height4SizedBox,
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(100),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                                    ],
                                    style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    controller: walletController
                                        .thresholdAmountTextController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return AlertStringConstants
                                            .pleaseEnterAmountText;
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "eg \$10.00",
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey),
                                      fillColor: Colors.white,
                                      border: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: AppColors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringConstants.paymentTypeText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                height6SizedBox,
                                DropdownButtonFormField<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  value: widget.isFromEdit
                                      ? walletController.frequencyTextController
                                                  .text ==
                                              "30"
                                          ? "Monthly"
                                          : "Weekly"
                                      : null,
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
                                  items: <String>["Monthly", "Weekly"]
                                      .map((String value) {
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
                                    addCardController
                                        .selectedPaymentForFrequency
                                        .value = v.toString();
                                    if (v.toString() == "Monthly") {
                                      walletController.selectedFrequency.value =
                                          "30";
                                    } else {
                                      walletController.selectedFrequency.value =
                                          "7";
                                    }
                                  },
                                ),
                              ],
                            ),
                    ),
                    Obx(() => walletController.autoChargeType.value !=
                                "threshold" &&
                            walletController.selectedFrequency.value == "30"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height20SizedBox,
                              Text(
                                StringConstants.daysText,
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              height6SizedBox,
                              DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                value: widget.isFromEdit
                                    ? walletController
                                                .frequencyTextController.text ==
                                            "30"
                                        ? walletController.day.value != ""
                                            ? walletController.day.value
                                            : null
                                        : null
                                    : null,
                                validator: (value) {
                                  if (walletController.autoChargeType.value !=
                                          "threshold" &&
                                      walletController
                                              .selectedFrequency.value ==
                                          "30") {
                                    if (value == null || value.trim().isEmpty) {
                                      return AlertStringConstants
                                          .pleaseSelectDayOfMonthText;
                                    }
                                    return null;
                                  }
                                  return null;
                                },
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
                                  StringConstants.selectDayMonthText,
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                  ),
                                ),
                                items: walletController.monthDayList
                                    .map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (month) {
                                  walletController.day.value = month.toString();
                                },
                              ),
                            ],
                          )
                        : height0SizedBox),
                    Obx(
                      () => walletController.autoChargeType.value !=
                                  "threshold" &&
                              walletController.selectedFrequency.value == "7"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height20SizedBox,
                                Text(
                                  StringConstants.daysText,
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                height6SizedBox,
                                DropdownButtonFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  value: widget.isFromEdit
                                      ? walletController.frequencyTextController
                                                  .text ==
                                              "7"
                                          ? walletController.day.value != ""
                                              ? int.parse(walletController
                                                          .day.value) <=
                                                      7
                                                  ? walletController.day.value
                                                  : null
                                              : null
                                          : null
                                      : null,
                                  validator: (value) {
                                    if (walletController.autoChargeType.value !=
                                            "threshold" &&
                                        walletController
                                                .selectedFrequency.value ==
                                            "7") {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return AlertStringConstants
                                            .pleaseSelectDayOfWeekText;
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
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
                                    StringConstants.selectDayWeekText,
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  items: walletController.weekDaysList
                                      .map((dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value.id.toString(),
                                      child: Text(
                                        value.name,
                                        style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (day) {
                                    walletController.day.value = day.toString();
                                  },
                                ),
                              ],
                            )
                          : height0SizedBox,
                    ),
                    height20SizedBox,
                    Text(
                      StringConstants.selectCardText,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    height6SizedBox,
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                              // SharedPreferenceStorage.setData(
                                              //     "context", context);
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (_) =>
                                              //       const AddCardDetailScreen(),
                                              // ));
                                              Get.to(
                                                () =>
                                                    const AddCardDetailScreen(),
                                                id: pageIdApp.value,
                                              );
                                            },
                                            height: 50,
                                            width: WidgetConstants.screenWidth *
                                                0.3,
                                            text: StringConstants.addCardText,
                                            borderRadius: 12,
                                            fontWeight: FontWeight.w500,
                                            iconL: false,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return height15SizedBox;
                                  },
                                  itemCount: addCardController.cardList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (addCardController
                                        .userStripeCardId!.value.isEmpty) {
                                      addCardController
                                              .userStripeCardId!.value =
                                          addCardController
                                              .cardList[0].userStripeCardId
                                              .toString();
                                      walletController.userStripeCardId!.value =
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
                                            addCardController
                                                .selectedIndex!.value = index;

                                            addCardController
                                                    .userStripeCardId!.value =
                                                addCardController
                                                    .cardList[index]
                                                    .userStripeCardId
                                                    .toString();
                                            walletController
                                                    .userStripeCardId!.value =
                                                addCardController
                                                    .cardList[index]
                                                    .userStripeCardId
                                                    .toString();
                                            debugPrint(
                                                "USER STRIPE CARD ID${addCardController.userStripeCardId!.value}");
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Image.asset(
                                                      walletController
                                                                  .cardList[
                                                                      index]
                                                                  .card!
                                                                  .brand ==
                                                              "Visa"
                                                          ? ImageConstants
                                                              .visacard
                                                          : walletController
                                                                      .cardList[
                                                                          index]
                                                                      .card!
                                                                      .brand ==
                                                                  "MasterCard"
                                                              ? ImageConstants
                                                                  .mastercard
                                                              : walletController
                                                                          .cardList[
                                                                              index]
                                                                          .card!
                                                                          .brand ==
                                                                      "American Express"
                                                                  ? ImageConstants
                                                                      .americanexpress
                                                                  : walletController
                                                                              .cardList[
                                                                                  index]
                                                                              .card!
                                                                              .brand ==
                                                                          "Discover"
                                                                      ? ImageConstants
                                                                          .discovecard
                                                                      : ImageConstants
                                                                          .card,
                                                      height: 20,
                                                    ),
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
                                                            .brand
                                                            .toString()
                                                            .toUpperCase(),
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
                        )),
                    height10SizedBox,
                    CustomButton(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary],
                      ),
                      onTap: () {
                        widget.isFromEdit == true
                            ? walletController.validateAndSubmit(
                                isFromAutoRecharge: true, updateAutoData: true)
                            //walletController.apiUpdateAutoRecharge(context)
                            : walletController.validateAndSubmit(
                                isFromAutoRecharge: true);
                      },
                      height: 50,
                      text: StringConstants.okText,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      iconL: false,
                      fontSize: 16,
                    ),
                    height20SizedBox
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
