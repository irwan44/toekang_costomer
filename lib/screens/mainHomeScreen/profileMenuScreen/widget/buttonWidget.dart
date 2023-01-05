import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:flutter/material.dart';

buttonWidget(var icon, String lbl, {required Function onClickAction}) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin3),
    elevation: 0,
    child: InkWell(
      splashColor: ColorsRes.appColorLight,
      onTap: () {
        onClickAction();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8),
          Card(
              shape: DesignConfig.setRoundedBorder(8),
              color: ColorsRes.appColorLightHalfTransparent,
              elevation: 0,
              child: Padding(padding: EdgeInsets.all(5), child: icon)),
          SizedBox(height: 5),
          Text(lbl),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
