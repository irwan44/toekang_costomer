import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:flutter/material.dart';

getOtherImagesBoxDecoration({bool? isActive}) {
  return BoxDecoration(
      borderRadius: Constant.borderRadius13,
      border: Border(
          left: BorderSide(
            width: 2,
            color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
          ),
          bottom: BorderSide(
            width: 2,
            color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
          ),
          top: BorderSide(
            width: 2,
            color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
          ),
          right: BorderSide(
            width: 2,
            color: isActive == true ? ColorsRes.appColor : ColorsRes.grey,
          )));
}
