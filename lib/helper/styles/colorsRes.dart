import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ColorsRes {
  static MaterialColor appColor = MaterialColor(
    0xff55AE7B,
    <int, Color>{
      50: Color(0xff55AE7B),
      100: Color(0xff55AE7B),
      200: Color(0xff55AE7B),
      300: Color(0xff55AE7B),
      400: Color(0xff55AE7B),
      500: Color(0xff55AE7B),
      600: Color(0xff55AE7B),
      700: Color(0xff55AE7B),
      800: Color(0xff55AE7B),
      900: Color(0xff55AE7B),
    },
  );

  static Color appColorLight = Color(0xffe1ffeb);
  static Color appColorLightHalfTransparent = Color(0x2651bd88);

  static Color gradient1 = Color(0xff78c797);
  static Color gradient2 = Color(0xff25b176);

  static Color defaultPageInnerCircle = Color(0x1A999999);
  static Color defaultPageOuterCircle = Color(0x0d999999);

  static Color mainTextColor = Colors.black;
  static Color subTitleTextColor = Color(0xff999999);

  static Color bgColorLight = Color(0xfff7f7f7);
  static Color bgColorDark = Color(0xff141A1F);

  static Color cardColorLight = Color(0xffffffff);
  static Color cardColorDark = Color(0xff202934);

  //This will remain same in dark and light theme as well
  static Color lightThemeTextColor = Colors.black;
  static Color darkThemeTextColor = Colors.white;

  static Color grey = Colors.grey;
  static Color appColorWhite = Colors.white;
  static Color appColorBlack = Colors.black;
  static Color appColorRed = Colors.red;
  static Color appColorGreen = Colors.green;

  static Color greyBox = Color(0x0a000000);
  static Color lightGreyBox = Color.fromARGB(9, 213, 212, 212);

  //Shimmer Colors
  static Color shimmerBaseColor = Colors.grey.shade300;
  static Color shimmerHighlightColor = Colors.grey.shade100;
  static Color shimmerContainerColor = Colors.white.withOpacity(0.85);

  static ThemeData lightTheme = ThemeData(
      primaryColor: appColor,
      brightness: Brightness.light,
      primarySwatch: ColorsRes.appColor,
      scaffoldBackgroundColor: bgColorLight,
      backgroundColor: Colors.white,
      cardColor: cardColorLight,
      fontFamily: 'Lato',
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ));

  static ThemeData darkTheme = ThemeData(
      primaryColor: appColor,
      brightness: Brightness.dark,
      primarySwatch: ColorsRes.appColor,
      scaffoldBackgroundColor: bgColorDark,
      backgroundColor: Colors.black,
      cardColor: cardColorDark,
      fontFamily: 'Lato',
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ));

  static ThemeData setAppTheme() {
    String theme = Constant.session.getData(SessionManager.appThemeName);
    bool isDarkTheme = Constant.session.getBoolData(SessionManager.isDarkTheme);

    bool isDark = false;
    if (theme == Constant.themeList[2]) {
      isDark = true;
    } else if (theme == Constant.themeList[1]) {
      isDark = false;
    } else if (theme == "" || theme == Constant.themeList[0]) {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      isDark = brightness == Brightness.dark;

      if (theme == "") {
        Constant.session
            .setData(SessionManager.appThemeName, Constant.themeList[0], false);
      }
    }

    if (isDark) {
      if (!isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, true, true);
      }
      mainTextColor = darkThemeTextColor;
      return darkTheme;
    } else {
      if (isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, false, true);
      }
      mainTextColor = lightThemeTextColor;
      return lightTheme;
    }
  }
}
