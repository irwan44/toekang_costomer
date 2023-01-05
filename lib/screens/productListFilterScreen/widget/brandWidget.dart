import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productFilterProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/models/productList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getBrandWidget(List<Brands> brands, BuildContext context) {
  return GridView.builder(
    itemCount: brands.length,
    padding: EdgeInsets.symmetric(
        horizontal: Constant.paddingOrMargin10,
        vertical: Constant.paddingOrMargin10),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      Brands brand = brands[index];
      return GestureDetector(
        onTap: () {
          context
              .read<ProductFilterProvider>()
              .addRemoveBrandIds(brand.id.toString());
        },
        child: Card(
          elevation: 0,
          shape: DesignConfig.setRoundedBorder(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: Constant.borderRadius10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Widgets.setNetworkImg(
                          image: brand.imageUrl, boxFit: BoxFit.fill)),
                  if (context
                      .watch<ProductFilterProvider>()
                      .selectedBrands
                      .contains(brand.id.toString()))
                    PositionedDirectional(
                      top: 0,
                      start: 0,
                      bottom: 0,
                      end: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorsRes.appColorBlack.withOpacity(0.8),
                              borderRadius: Constant.borderRadius10),
                          child: Icon(
                            Icons.check_rounded,
                            color: ColorsRes.appColor,
                            size: 60,
                          )),
                    ),
                ],
              ),
              Widgets.getSizedBox(height: 10),
              Text(brand.name),
            ],
          ),
        ),
      );
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.74,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}
