import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

abstract class ThemeTextMontserratMedium {
  static const fontWeight = FontWeight.w500;
  static const fontFamily = "MontserratMedium";
  static var fontColor = ThemeColors.white;

  static final size9 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.4,
    fontSize: 9,
  );
}

abstract class ThemeTextMontserratBold {
  static const fontWeight = FontWeight.w700;
  static const fontFamily = "MontserratBold";
  static const fontColor = ThemeColors.black;

  static final size21 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.3,
    height: 1.4,
    fontSize: 21,
  );
  static final size18 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.3,
    height: 1.4,
    fontSize: 20,
  );
  static final size16 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.3,
    height: 1.4,
    fontSize: 16,
  );

  static final size22 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.4,
    fontSize: 22,
  );

  // Добавлен новый стиль с увеличенным размером текста
  static final size24 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.4,
    fontSize: 24,
  );
}

abstract class ThemeTextInterMedium {
  static const fontWeight = FontWeight.w500;
  static const fontFamily = "InterMedium";
  static Color fontColor = ThemeColors.white;

  static final size15 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.4,
    fontSize: 15,
  );
}

abstract class ThemeTextInterRegular {
  static const fontWeight = FontWeight.w400;
  static const fontFamily = "InterRegular";
  static const fontColor = ThemeColors.grey5;

  static final size11 = TextStyle(
    color: fontColor,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.4,
    fontSize: 11,
  );
}
