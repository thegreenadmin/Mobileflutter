import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/wallet/controller/wallet_controller.dart';
import 'package:thegreenmall/dashboard/wallet/view/add_money_to_wallet.dart';
import 'package:thegreenmall/dashboard/wallet/view/manage_wallet_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletController walletController = Get.put(WalletController());

  @override
  void initState() {
    if (SharedPreferenceStorage.getData(Role.role.value) ==
        Role.customerRoleText) {
      walletController.apiGetCardList(context);
      walletController.apiGetUserWalletBalance();
    } else {
      walletController.apiGetStoreList();
    }
    super.initState();
  }

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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, ${SharedPreferenceStorage.getData(StringConstants.firstNameText) + " " + SharedPreferenceStorage.getData(StringConstants.lastNameText)}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        height4SizedBox,
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
                      ImageConstants.homeMall,
                      scale: 4,
                    )
                  ])),
        ),
      ),
      body: Container(
        height: WidgetConstants.screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SharedPreferenceStorage.getData(Role.role.value) ==
                  Role.customerRoleText
              ? height0SizedBox
              : Obx(() => walletController.storeList.isEmpty
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
                            style: TextStyle(
                                color: AppColors.blacklight, fontSize: 18),
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
                                  color: AppColors.grey, fontSize: 14),
                            ),
                            items:
                                walletController.storeList.map((dynamic value) {
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
                              walletController.storeNameValue!.value =
                                  value.toString();

                              walletController.apiGetOwnerWalletBalance();
                            },
                          ),
                        ),
                      ],
                    )),
          height20SizedBox,
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                ImageConstants.walletCard,
              ),
              height20SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageConstants.dollar,
                    scale: 3.4,
                  ),
                  width15SizedBox,
                  SharedPreferenceStorage.getData(Role.role.value) ==
                          Role.customerRoleText
                      ? Column(
                          children: [
                            Obx(() => Text(
                                  "\$${walletController.userWalletBalance!.value}",
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500),
                                )),
                            height8SizedBox,
                             Text(StringConstants.totalBalanceText,
                              style:const TextStyle(
                                  color: AppColors.white, fontSize: 18),
                            ),
                            height12SizedBox,
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>const  AddMoneyToWallet(),
                                ))
                                // Get.to(const AddMoneyToWallet())!
                                    .then(
                                    (value) => walletController
                                        .apiGetUserWalletBalance());
                              },
                              child: Image.asset(
                                ImageConstants.addMoney,
                                scale: 3.5,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Obx(() => Text(
                                  "\$${walletController.ownerWalletBalance!.value}",
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500),
                                )),
                            height8SizedBox,
                             Text(StringConstants.totalBalanceText,
                              style: const TextStyle(
                                  color: AppColors.black, fontSize: 18),
                            ),
                            height12SizedBox,
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
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>const  ManageWalletScreen(),
                    ));
                    // Get.to(const ManageWalletScreen());
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        ImageConstants.setting,
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
              ),
              SharedPreferenceStorage.getData(Role.role.value) ==
                      Role.customerRoleText
                  ? Container(
                      color: AppColors.grey,
                      width: 1,
                      height: 40,
                    )
                  : height0SizedBox,
              SharedPreferenceStorage.getData(Role.role.value) ==
                      Role.customerRoleText
                  ? Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Image.asset(
                            ImageConstants.pickUp,
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
                    )
                  : height0SizedBox,
            ],
          )
        ]),
      ),
    );
  }
}
