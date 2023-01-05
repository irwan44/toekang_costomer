import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productFilterProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/productList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/brandWidget.dart';
import 'widget/priceRangeWidget.dart';
import 'widget/sizeWidget.dart';

class ProductListFilterScreen extends StatefulWidget {
  final List<Brands> brands;
  final List<Sizes> sizes;
  final double maxPrice;
  final double minPrice;

  ProductListFilterScreen({
    Key? key,
    required this.brands,
    required this.sizes,
    required this.maxPrice,
    required this.minPrice,
  }) : super(key: key);

  @override
  State<ProductListFilterScreen> createState() =>
      _ProductListFilterScreenState();
}

class _ProductListFilterScreenState extends State<ProductListFilterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await setTempValues().then((value) => context
          .read<ProductFilterProvider>()
          .currentRangeValues = RangeValues(widget.minPrice, widget.maxPrice));
      context.read<ProductFilterProvider>().setCurrentIndex(0);
    });
  }

  Future<bool> setTempValues() async {
    context.read<ProductFilterProvider>().currentRangeValues =
        Constant.currentRangeValues;
    context.read<ProductFilterProvider>().selectedBrands =
        Constant.selectedBrands;
    context.read<ProductFilterProvider>().selectedSizes =
        Constant.selectedSizes;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          StringsRes.lblFilter,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return true;
        },
        child: Stack(
          children: [
            //Filter list screen
            PositionedDirectional(
                top: 0,
                bottom: 0,
                start: 0,
                end: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: List.generate(
                              StringsRes.lblFilterTypesList.length, (index) {
                            return (index == 2 &&
                                    widget.minPrice == widget.maxPrice)
                                ? SizedBox.shrink()
                                : ListTile(
                                    onTap: () {
                                      context
                                          .read<ProductFilterProvider>()
                                          .setCurrentIndex(index);
                                    },
                                    selected: context
                                            .watch<ProductFilterProvider>()
                                            .currentSelectedFilterIndex ==
                                        index,
                                    selectedTileColor:
                                        Theme.of(context).cardColor,
                                    title: Text(
                                        StringsRes.lblFilterTypesList[index]),
                                  );
                          }),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ProductFilterProvider>()
                              .resetAllFilters();
                          setState(() {});
                        },
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.all(20),
                          child: Center(
                              child: Text(
                            StringsRes.lblClearAll,
                            textScaleFactor: 1.2,
                          )),
                          padding: EdgeInsets.all(20),
                          decoration: DesignConfig.boxGradient(10,
                              color1: Colors.transparent,
                              color2: Colors.transparent),
                        ),
                      )
                    ],
                  ),
                )),
            //Filter list's values screen
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: MediaQuery.of(context).size.width * 0.4,
              end: 0,
              child: Card(
                color: Theme.of(context).cardColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: context
                                  .watch<ProductFilterProvider>()
                                  .currentSelectedFilterIndex ==
                              0
                          ? getBrandWidget(widget.brands, context)
                          : context
                                      .watch<ProductFilterProvider>()
                                      .currentSelectedFilterIndex ==
                                  1
                              ? getSizeWidget(widget.sizes, context)
                              : widget.minPrice != widget.maxPrice
                                  ? getPriceRangeWidget(
                                      widget.minPrice, widget.maxPrice, context)
                                  : SizedBox.shrink(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.all(20),
                        child: Center(
                            child: Text(
                          StringsRes.lblApply,
                          style: TextStyle(color: ColorsRes.appColorWhite),
                        )),
                        padding: EdgeInsets.all(20),
                        decoration: DesignConfig.boxGradient(10),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
