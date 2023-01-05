import 'package:egrocer/helper/generalWidgets/productVariantDropDownMenu.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'productWishListIcon.dart';
import 'widgets.dart';

class ProductListItemContainer extends StatefulWidget {
  final ProductListItem product;

  ProductListItemContainer({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductListItemContainer> createState() => _State();
}

class _State extends State<ProductListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants> variants = product.variants;
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 10),
      child: GestureDetector(
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
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<SelectedVariantItemProvider>(
                          builder:
                              (context, selectedVariantItemProvider, child) {
                            return Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: Constant.borderRadius10,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Widgets.setNetworkImg(
                                      boxFit: BoxFit.fill,
                                      image: product.imageUrl,
                                      height: 125,
                                      width: 125,
                                    )),
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
                                          height: 125,
                                          width: 125,
                                          textSize: 15)),
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
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Constant.paddingOrMargin10,
                                horizontal: Constant.paddingOrMargin10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets.getSizedBox(height: 10),
                                Text(
                                  product.name,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Widgets.getSizedBox(height: 10),
                                ProductVariantDropDownMenu(
                                  variants: variants,
                                  from: "",
                                  product: product,
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                  PositionedDirectional(
                    end: 5,
                    top: 5,
                    child: ProductWishListIcon(
                      product: product,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
