import 'package:egrocer/helper/generalWidgets/productWishListIcon.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'productVariantDropDownMenu.dart';
import 'widgets.dart';

class ProductGridItemContainer extends StatefulWidget {
  final ProductListItem product;

  ProductGridItemContainer({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductGridItemContainer> createState() => _State();
}

class _State extends State<ProductGridItemContainer> {
  late BuildContext context1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;
    ProductListItem product = widget.product;
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, productDetailScreen,
              arguments: [product.id.toString(), product.name, product]);
        },
        child: ChangeNotifierProvider<SelectedVariantItemProvider>(
          create: (context) => SelectedVariantItemProvider(),
          child: Container(
            decoration:
                DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
            child: Stack(
              children: [
                Column(children: [
                  Expanded(
                    child: Consumer<SelectedVariantItemProvider>(
                      builder: (context, selectedVariantItemProvider, child) {
                        return Stack(
                          children: [
                            ClipRRect(
                                borderRadius: Constant.borderRadius10,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Widgets.setNetworkImg(
                                    boxFit: BoxFit.fill,
                                    image: product.imageUrl,
                                    height: double.maxFinite,
                                    width: double.maxFinite)),
                            if (product
                                    .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                    .status ==
                                0)
                              PositionedDirectional(
                                  top: 0,
                                  end: 0,
                                  start: 0,
                                  bottom: 0,
                                  child: getOutOfStockWidget(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                  )),
                            PositionedDirectional(
                                bottom: 5,
                                end: 5,
                                child: Column(
                                  children: [
                                    if (product.indicator == 1)
                                      Widgets.defaultImg(
                                          height: 24,
                                          width: 24,
                                          image: "veg_indicator"),
                                    if (product.indicator == 2)
                                      Widgets.defaultImg(
                                          height: 24,
                                          width: 24,
                                          image: "non_veg_indicator"),
                                  ],
                                )),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin7,
                        vertical: Constant.paddingOrMargin5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Widgets.getSizedBox(height: 5),
                        ProductVariantDropDownMenu(
                          from: "",
                          product: product,
                          variants: product.variants,
                        ),
                      ],
                    ),
                  )
                ]),
                PositionedDirectional(
                    end: 5,
                    top: 5,
                    child: ProductWishListIcon(product: product)),
              ],
            ),
          ),
        ));
  }
}
