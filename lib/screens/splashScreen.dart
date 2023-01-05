import 'dart:async';

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/repositories/appSettingsApi.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      getAppSettings(context: context);
      startTime();
    });
  }

  startTime() async {
    return Timer(Duration(seconds: 1), () async {
      if (!Constant.session.getBoolData(SessionManager.introSlider)) {
        Constant.session.setBoolData(SessionManager.introSlider, true, false);
        Navigator.pushReplacementNamed(context, introSliderScreen);
      } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
          Constant.session.getIntData(SessionManager.keyUserStatus) == 0) {
        Navigator.pushReplacementNamed(context, editProfileScreen,
            arguments: "register");
      } else {
        if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
            Constant.session.getBoolData(SessionManager.isUserLogin)) {
          if (Constant.session.getData(SessionManager.keyLatitude) == "" &&
              Constant.session.getData(SessionManager.keyLongitude) == "") {
            Navigator.pushReplacementNamed(context, getLocationScreen,
                arguments: "location");
          } else {
            await context
                .read<CartListProvider>()
                .getAllCartItems(context: context);

            Navigator.pushReplacementNamed(context, mainHomeScreen);
          }
        } else {
          Navigator.pushReplacementNamed(context, loginScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsRes.appColor,
      body: Container(
        alignment: Alignment.center,
        child: Widgets.defaultImg(image: 'splash_logo'),
      ),
    );
  }
}
