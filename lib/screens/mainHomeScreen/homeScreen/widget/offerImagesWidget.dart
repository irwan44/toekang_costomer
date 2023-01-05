import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:flutter/material.dart';

getOfferImages(List<String>? offerImages) {
  return Column(
      children: List.generate(
    offerImages!.length,
    (index) {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 10,end: 10),
        child: ClipRRect(
            borderRadius: Constant.borderRadius10,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Widgets.setNetworkImg(
                image: offerImages[index], boxFit: BoxFit.fill)),
      );
    },
  ));
}
