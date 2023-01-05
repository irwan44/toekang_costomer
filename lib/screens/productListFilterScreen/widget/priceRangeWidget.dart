import 'package:egrocer/helper/provider/productFilterProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getPriceRangeWidget(double minPrice, double maxPrice, BuildContext context) {
  return RangeSlider(
    values: context.watch<ProductFilterProvider>().currentRangeValues,
    divisions: (maxPrice.toInt() - minPrice.toInt()),
    labels: RangeLabels(
        "${GeneralMethods.getCurrencyFormat(double.parse(context.watch<ProductFilterProvider>().currentRangeValues.start.toString()))}",
        "${GeneralMethods.getCurrencyFormat(double.parse(context.watch<ProductFilterProvider>().currentRangeValues.end.toString()))}"),
    activeColor: ColorsRes.appColor,
    inactiveColor: ColorsRes.grey,
    min: minPrice,
    max: maxPrice,
    onChanged: (value) {
      context.read<ProductFilterProvider>().setPriceRange(value);
    },
  );
}
