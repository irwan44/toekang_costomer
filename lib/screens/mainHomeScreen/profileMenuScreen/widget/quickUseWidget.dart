import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';

import 'buttonWidget.dart';

quickUseWidget({required BuildContext context}) {
  return Row(children: [
    Expanded(
        child: buttonWidget(
            Icon(Icons.directions_bike_rounded, color: ColorsRes.appColor),
            StringsRes.lblAllOrders, onClickAction: () {
      Navigator.pushNamed(context, orderHistoryScreen);
    })),
    Expanded(
        child: buttonWidget(
            Icon(
              Icons.location_on_outlined,
              color: ColorsRes.appColor,
            ),
            StringsRes.lblAddress,
            onClickAction: () => Navigator.pushNamed(context, addressListScreen,
                arguments: ""))),
    Expanded(
        child: buttonWidget(
      Icon(Icons.shopping_cart_outlined, color: ColorsRes.appColor),
      StringsRes.lblCart,
      onClickAction: () {
        if (Constant.session.isUserLoggedIn()) {
          Navigator.pushNamed(context, cartScreen);
        } else {
          GeneralMethods.showSnackBarMsg(
              context, StringsRes.lblRequiredLoginMessageForCartRedirect,
              requiredAction: true);
        }
      },
    )),
  ]);
}
