import 'package:flutter/material.dart';
import 'app_colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    iconTheme: const IconThemeData(
      color: AppColors.black,
    ),
    brightness: Brightness
        .light, //Setting the Brightness to light  so that this can be used as Light ThemeData
    scaffoldBackgroundColor: AppColors.white,
    // textTheme: CustomTextTheme
    //     .textThemeLight, //Setting the Text Theme to LightTextTheme
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    iconTheme: const IconThemeData(
      color: AppColors.white,
    ),
    brightness: Brightness
        .light, //Setting the Brightness to Dark  so that this can be used as Dark ThemeData
    scaffoldBackgroundColor: AppColors.black,
    // textTheme:
    //     CustomTextTheme.textThemeDark, //Setting the Text Theme to DarkTextTheme
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
      backgroundColor: AppColors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
    )),
  );
}
