import 'package:flutter/material.dart';
import 'package:thegreenmall/utils/app_config.dart';

//define color codes to be used throughout app........
//
// Brand and status colors are admin-configurable (Settings → App appearance),
// so they are mutable statics rather than const: [apply] overwrites them from
// the fetched config, and the defaults below are what ships in the binary.
// Widgets reading them must therefore not be `const`.
class AppColors {
  //A

  //B
  static Color black = _d.black;
  static final blackMedium = const Color(0xff26292F).withOpacity(0.8);
  static final blackLight = const Color(0xff26292F).withOpacity(0.8);
  //C

  //D

  //E

  //F

  //G
  static const grey = Colors.grey;
  static Color greyLight = _d.greyLight;
  static Color greyMediumLight = _d.greyMediumLight;

  static Color green = _d.green;
  static Color greenLight = _d.greenLight;

  //H

  //I

  //J

  //K

  //L

  //M

  //N

  //O

  //P
  static Color primary = _d.primary;
  static Color primaryBackgroundLight = _d.primaryBackgroundLight;
  static Color primaryLight = _d.primaryLight;
  static Color primaryDark = _d.primaryDark;
  //Q

  //R
  static Color red = _d.red;
  static Color redLight = _d.redLight;
  //S

  //T
  static const transparent = Colors.transparent;
  //U

  //V

  //W
  static const white = Color(0xffFFFFFF);
  //X

  //Y
  static Color yellow = _d.yellow;
  //Z

  static const _d = _DefaultColors();

  /// Overwrites the themeable colors from [config]; keys missing from the
  /// config fall back to the shipped defaults.
  static void apply(AppConfig config) {
    black = config.color('text_primary', _d.black);
    greyLight = config.color('grey_light', _d.greyLight);
    greyMediumLight = config.color('grey_medium_light', _d.greyMediumLight);
    green = config.color('success', _d.green);
    greenLight = config.color('success_light', _d.greenLight);
    primary = config.color('primary', _d.primary);
    primaryBackgroundLight =
        config.color('primary_background_light', _d.primaryBackgroundLight);
    primaryLight = config.color('primary_light', _d.primaryLight);
    primaryDark = config.color('primary_dark', _d.primaryDark);
    red = config.color('error', _d.red);
    redLight = config.color('error_light', _d.redLight);
    yellow = config.color('warning', _d.yellow);
  }
}

class _DefaultColors {
  const _DefaultColors();

  final black = const Color(0xff111413);
  final greyLight = const Color(0xffF5F8F9);
  final greyMediumLight = const Color(0xffEFEFEF);
  final green = const Color(0xff348956);
  final greenLight = const Color(0xff59BE83);
  final primary = const Color(0xff00A8D6);
  final primaryBackgroundLight = const Color(0xffE9FAFF);
  final primaryLight = const Color(0xffF4FBFD);
  final primaryDark = const Color(0xff20526D);
  final red = const Color(0xffDA1D33);
  final redLight = const Color(0xffFFF0F0);
  final yellow = const Color(0xffFF9811);
}
