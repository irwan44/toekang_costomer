import 'package:egrocer/helper/generalWidgets/productVariantDropDownMenu.dart';
import 'package:egrocer/helper/generalWidgets/productWishListIcon.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productListProvider.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenProductListItem extends StatefulWidget {
  final ProductListItem product;
  final int position;

  HomeScreenProductListItem(
      {Key? key, required this.product, required this.position})
      : super(key: key);

  @override
  State<HomeScreenProductListItem> createState() => _State();
}

class _State extends State<HomeScreenProductListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants> variants = product.variants;
    return variants.isNotEmpty
        ? Consumer<ProductListProvider>(
            builder: (context, productListProvider, _) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productDetailScreen,
                    arguments: [product.id.toString(), product.name, product]);
              },
              child: ChangeNotifierProvider<SelectedVariantItemProvider>(
                create: (context) => SelectedVariantItemProvider(),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.45,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor, 8),
                  child: Stack(
                    children: [
                      Column(children: [
                        Expanded(
                          child: Consumer<SelectedVariantItemProvider>(
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
                                          height:
                                              MediaQuery.of(context).size.width,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width)),
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
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width)),
                                  PositionedDirectional(
                                      bottom: 5,
                                      end: 5,
                                      child: Column(
                                        children: [
                                          if (product.indicator == 1)
                                            Widgets.defaultImg(
                                                height: 24,
                                                width: 24,
                                                image: "veg_indicator",
                                                boxFit: BoxFit.cover),
                                          if (product.indicator == 2)
                                            Widgets.defaultImg(
                                                height: 24,
                                                width: 24,
                                                image: "non_veg_indicator",
                                                boxFit: BoxFit.cover),
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
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              ProductVariantDropDownMenu(
                                  variants: variants,
                                  from: "",
                                  product: product),
                            ],
                          ),
                        )
                      ]),
                      PositionedDirectional(
                          end: 5,
                          top: 5,
                          child: ProductWishListIcon(
                            product: product,
                          )),
                    ],
                  ),
                ),
              ),
            );
          })
        : SizedBox.shrink();
  }
}
