import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/cartData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'productCartButton.dart';
import 'widgets.dart';

class CartListItemContainer extends StatefulWidget {
  final Cart cart;
  final String from;

  CartListItemContainer({Key? key, required this.cart, required this.from})
      : super(key: key);

  @override
  State<CartListItemContainer> createState() => _State();
}

class _State extends State<CartListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = widget.cart;
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 10),
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
                    ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Widgets.setNetworkImg(
                          height: 125,
                          width: 125,
                          boxFit: BoxFit.fill,
                          image: cart.imageUrl,
                        )),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Constant.paddingOrMargin10,
                            horizontal: Constant.paddingOrMargin10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<SelectedVariantItemProvider>(
                              builder: (context, selectedVariantItemProvider,
                                  child) {
                                return (cart.status == 0)
                                    ? Text(
                                        StringsRes.lblOutOfStock,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsRes.appColorRed),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                            Widgets.getSizedBox(height: 10),
                            Text(
                              cart.name,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Widgets.getSizedBox(height: 10),
                            RichText(
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                              // maxLines: 1,
                              text: TextSpan(children: [
                                TextSpan(
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.mainTextColor,
                                      decorationThickness: 2),
                                  text: "${cart.measurement} ${cart.unit}",
                                ),
                                TextSpan(
                                  text: cart.discountedPrice != 0 ? " | " : "",
                                ),
                                TextSpan(
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.subTitleTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2),
                                  text: cart.discountedPrice != 0
                                      ? "${cart.price}"
                                      : "",
                                ),
                              ]),
                            ),
                            Widgets.getSizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    cart.discountedPrice != 0
                                        ? GeneralMethods.getCurrencyFormat(
                                            cart.discountedPrice)
                                        : GeneralMethods.getCurrencyFormat(
                                            cart.price),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: ColorsRes.appColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Consumer<CartListProvider>(
                                  builder: (context, cartListProvider, child) {
                                    return cart.status == 1
                                        ? ProductCartButton(
                                            productId:
                                                cart.productId.toString(),
                                            productVariantId: cart
                                                .productVariantId
                                                .toString(),
                                            count: cart.status == 0
                                                ? -1
                                                : cart.qty,
                                            isUnlimitedStock:
                                                cart.isUnlimitedStock == 1,
                                            maximumAllowedQuantity:
                                                double.parse(cart
                                                    .totalAllowedQuantity
                                                    .toString()),
                                            availableStock: double.parse(
                                                cart.stock.toString()),
                                            from: "cartList")
                                        : SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Widgets.gradientBtnWidget(
                                              context,
                                              5,
                                              callback: () async {
                                                Map<String, String> params = {};
                                                params[ApiAndParams.productId] =
                                                    cart.productId.toString();
                                                params[ApiAndParams
                                                        .productVariantId] =
                                                    cart.productVariantId
                                                        .toString();
                                                params[ApiAndParams.qty] = "0";

                                                await cartListProvider.addRemoveCartItem(
                                                    context: context,
                                                    params: params,
                                                    isUnlimitedStock:
                                                        cart.isUnlimitedStock ==
                                                            1,
                                                    maximumAllowedQuantity: cart
                                                        .totalAllowedQuantity,
                                                    availableStock: cart.stock,
                                                    from: widget.from);
                                              },
                                              otherWidgets: Widgets.defaultImg(
                                                  image: "cart_delete",
                                                  width: 20,
                                                  height: 20,
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          5),
                                                  iconColor:
                                                      ColorsRes.appColorWhite),
                                              height: 30,
                                              isSetShadow: false,
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
