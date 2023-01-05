import 'package:egrocer/helper/generalWidgets/productCartButton.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class ProductVariantDropDownMenu extends StatefulWidget {
  final List<Variants> variants;
  final String from;
  final ProductListItem product;

  ProductVariantDropDownMenu({
    Key? key,
    required this.variants,
    required this.from,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductVariantDropDownMenu> createState() =>
      _ProductVariantDropDownMenuState();
}

class _ProductVariantDropDownMenuState
    extends State<ProductVariantDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedVariantItemProvider>(
        builder: (context, selectedVariantItemProvider, _) {
      return widget.variants.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.variants.length > 1
                          ? Constant.paddingOrMargin5
                          : 0,
                      horizontal: widget.variants.length > 1
                          ? Constant.paddingOrMargin5
                          : 0),
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: Constant.borderRadius5,
                      border: Border(
                          left: BorderSide(
                              color: widget.variants.length > 1
                                  ? ColorsRes.appColor
                                  : Colors.transparent,
                              width: 1),
                          right: BorderSide(
                              color: widget.variants.length > 1
                                  ? ColorsRes.appColor
                                  : Colors.transparent,
                              width: 1),
                          top: BorderSide(
                              color: widget.variants.length > 1
                                  ? ColorsRes.appColor
                                  : Colors.transparent,
                              width: 1),
                          bottom: BorderSide(
                              color: widget.variants.length > 1
                                  ? ColorsRes.appColor
                                  : Colors.transparent,
                              width: 1))),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.variants.length > 1) {
                        {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            shape: DesignConfig.setRoundedBorderSpecific(20,
                                istop: true),
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin15,
                                    end: Constant.paddingOrMargin15,
                                    top: Constant.paddingOrMargin15,
                                    bottom: Constant.paddingOrMargin15),
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.paddingOrMargin15,
                                          end: Constant.paddingOrMargin15),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                              Constant.borderRadius10,
                                              clipBehavior: Clip
                                                  .antiAliasWithSaveLayer,
                                              child: Widgets.setNetworkImg(
                                                  boxFit: BoxFit.fill,
                                                  image: widget
                                                      .product.imageUrl,
                                                  height: 70,
                                                  width: 70)),
                                          Widgets.getSizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              widget.product.name,
                                              softWrap: true,
                                              style:
                                              TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.paddingOrMargin15,
                                          end: Constant.paddingOrMargin15,
                                          top: Constant.paddingOrMargin15,
                                          bottom: Constant.paddingOrMargin15),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: widget.variants.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: RichText(
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        // maxLines: 1,
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                decorationThickness:
                                                                    2),
                                                            text:
                                                                "${widget.variants[index].measurement} ",
                                                          ),
                                                          WidgetSpan(
                                                            child: Text(
                                                              widget.variants[index]
                                                                  .stockUnitName,
                                                              softWrap: true,
                                                              //superscript is usually smaller in size
                                                              // textScaleFactor: 0.7,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                              text: widget
                                                                          .variants[
                                                              index]
                                                                          .discountedPrice !=
                                                                      0
                                                                  ? " | "
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: ColorsRes
                                                                      .mainTextColor)),
                                                          TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationThickness:
                                                                    2),
                                                            text: widget
                                                                        .variants[
                                                            index]
                                                                        .discountedPrice !=
                                                                    0
                                                                ? GeneralMethods
                                                                    .getCurrencyFormat(widget
                                                                        .variants[
                                                            index]
                                                                        .price)
                                                                : "",
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.variants[index]
                                                                  .discountedPrice !=
                                                              0
                                                          ? GeneralMethods
                                                              .getCurrencyFormat(
                                                                  widget
                                                                      .variants[
                                                                          index]
                                                                      .discountedPrice)
                                                          : GeneralMethods
                                                              .getCurrencyFormat(
                                                                  widget
                                                                      .variants[
                                                                          index]
                                                                      .price),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: ColorsRes
                                                              .appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ProductCartButton(
                                                productId: widget.product.id
                                                    .toString(),
                                                productVariantId: widget
                                                    .variants[index].id
                                                    .toString(),
                                                count: widget.variants[index]
                                                            .status ==
                                                        0
                                                    ? -1
                                                    : widget.variants[index]
                                                        .cartCount,
                                                isUnlimitedStock: widget.product
                                                        .isUnlimitedStock ==
                                                    1,
                                                maximumAllowedQuantity:
                                                    double.parse(widget.product
                                                        .totalAllowedQuantity
                                                        .toString()),
                                                availableStock: widget
                                                    .variants[index].stock,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    Constant.paddingOrMargin7),
                                            child: Divider(
                                              color: ColorsRes.grey,
                                              height: 5,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: RichText(
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        // maxLines: 1,
                        text: TextSpan(children: [
                          TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorsRes.mainTextColor,
                                decorationThickness: 2),
                            text: "${widget.variants[0].measurement} ",
                          ),
                          WidgetSpan(
                            child: Text(
                              widget.variants[0].stockUnitName,
                              softWrap: true,
                              //superscript is usually smaller in size
                              // textScaleFactor: 0.7,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: widget.variants[0].discountedPrice != 0
                                  ? " | "
                                  : "",
                              style: TextStyle(color: ColorsRes.mainTextColor)),
                          TextSpan(
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorsRes.mainTextColor,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2),
                            text: widget.variants[0].discountedPrice != 0
                                ? GeneralMethods.getCurrencyFormat(
                                    widget.variants[0].price)
                                : "",
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Widgets.getSizedBox(height: widget.variants.length > 1 ? 5 : 0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget
                                    .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                    .discountedPrice !=
                                0
                            ? GeneralMethods.getCurrencyFormat(widget
                                .variants[selectedVariantItemProvider
                                    .getSelectedIndex()]
                                .discountedPrice)
                            : GeneralMethods.getCurrencyFormat(widget
                                .variants[selectedVariantItemProvider
                                    .getSelectedIndex()]
                                .price),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 17,
                            color: ColorsRes.appColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ProductCartButton(
                      productId: widget.product.id.toString(),
                      productVariantId: widget
                          .variants[
                              selectedVariantItemProvider.getSelectedIndex()]
                          .id
                          .toString(),
                      count: widget
                                  .variants[selectedVariantItemProvider
                                      .getSelectedIndex()]
                                  .status ==
                              0
                          ? -1
                          : widget
                              .variants[selectedVariantItemProvider
                                  .getSelectedIndex()]
                              .cartCount,
                      isUnlimitedStock: widget.product.isUnlimitedStock == 1,
                      maximumAllowedQuantity: double.parse(
                          widget.product.totalAllowedQuantity.toString()),
                      availableStock: widget
                          .variants[
                              selectedVariantItemProvider.getSelectedIndex()]
                          .stock,
                    ),
                  ],
                ),
              ],
            )
          : SizedBox.shrink();
    });
  }
}
