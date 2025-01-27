import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/store_home_main_controller.dart';
import 'package:thegreenmall/dashboard/home/view/customer/cart_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

mixin PreferredSizeWidget on Widget {
  Size get preferredSize =>
      Size.fromHeight(WidgetConstants.screenHeight * 0.14);
}

class CommonAppBar extends StatefulWidget with PreferredSizeWidget {
  final String firstName;
  final String role;
  final String lastName;
  final String labelText;
  final String storeId;
  final int cartCount;
  final int cartLength;
  final bool isFromNotification;
  final bool showActiveCart;
  final void Function()? okayTap;
  CommonAppBar({
    Key? key,
    this.firstName = "",
    this.role = "",
    this.lastName = "",
    this.labelText = "",
    this.storeId = "",
    this.cartCount = 0,
    this.cartLength = 0,
    this.isFromNotification = false,
    this.showActiveCart = false,
    this.okayTap,
  }) : super(key: key);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> with GlobalVarMixin{
  final StoreHomeMainController storeHomeMainController =
      Get.put(StoreHomeMainController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight,
      child: Padding(
          padding: EdgeInsets.only(
              left: 20.0, right: 20, top: WidgetConstants.screenHeight * 0.06),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            widget.isFromNotification == true
                                ? InkWell(
                                    onTap: () async {
                                      Get.until((route) => route.isFirst,
                                          id: pageIdApp.value);
                                      // Navigator.of(Get.context!).popUntil(
                                      //     (route) => route.isFirst);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.black,
                                      size: 24.0,
                                    ),
                                  )
                                : height0SizedBox,
                            widget.isFromNotification == true
                                ? width10SizedBox
                                : height0SizedBox,
                            Text(
                              "${StringConstants.hiText}${widget.firstName} ${widget.lastName}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        height4SizedBox,
                        Text(
                          widget.labelText,
                          style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: widget.role == Role.customerRoleText &&
                              widget.showActiveCart == true &&
                              widget.cartCount != 0,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        Get.parameters["storeId"] =
                                            widget.storeId;
                                        storeHomeMainController
                                            .apiGetUserDetailsApi();
                                        storeHomeMainController
                                            .apiGetUserWalletBalance();

                                        await Get.to(() => const CartScreen(),
                                                id: pageIdApp.value)
                                            ?.then((value) {
                                          // widget.okayTap;
                                          storeHomeMainController
                                              .apiActiveCartApi();
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 20.0,
                                            backgroundColor: Colors.white,
                                            child: Image.asset(
                                                ImageConstants.cart,
                                                height: 16),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(1.5),
                                                decoration: BoxDecoration(
                                                  color: AppColors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.5),
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 15,
                                                  minHeight: 15,
                                                ),
                                                child: Text(
                                                  widget.cartCount.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Image.asset(
                          ImageConstants.homeMall,
                          scale: 4,
                        )
                      ],
                    ),
                  ]),
            ],
          )),
    );
  }
}
