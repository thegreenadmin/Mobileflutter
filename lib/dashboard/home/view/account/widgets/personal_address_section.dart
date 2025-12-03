import 'package:flutter/material.dart';
import 'package:thegreenmall/dashboard/home/controller/account_controller.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class AddressSection extends StatelessWidget {
  final AccountController a;

  const AddressSection(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    return a.addressLine1.value != "" ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.addressText,
          style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
        height30SizedBox,
        infoTile(StringConstants.addressLine1Text, a.addressLine1.value),
        infoTile(StringConstants.addressLine2Text, a.addressLine2.value),
        infoTile(StringConstants.cityText, a.city.value),
        infoTile(StringConstants.postalCodeText, a.postalCode.value),
        infoTile(StringConstants.countryText, a.country.value),
        infoTile(StringConstants.stateText, a.state.value),
      ],
    ): SizedBox.shrink();
  }


  Widget infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
            color: AppColors.blackLight,
            fontWeight: FontWeight.w400,
            fontSize: 16),),
        height10SizedBox,
        Text(value,   style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16),),
        Divider(height: 40, thickness: 1),
      ],
    );
  }

}
