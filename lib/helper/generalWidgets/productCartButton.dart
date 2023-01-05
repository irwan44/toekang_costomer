import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCartButton extends StatefulWidget {
  final int count;
  final String productId;
  final String productVariantId;
  final bool isUnlimitedStock;
  final double maximumAllowedQuantity;
  final double availableStock;
  final String? from;

  ProductCartButton({
    Key? key,
    required this.count,
    required this.productId,
    required this.productVariantId,
    required this.isUnlimitedStock,
    required this.maximumAllowedQuantity,
    required this.availableStock,
    this.from,
  }) : super(key: key);

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState
    extends State<ProductCartButton> /*with TickerProviderStateMixin*/ {
  late AnimationController animationController;
  late Animation animation;
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartListProvider>(
      builder: (context, cartListProvider, child) {
        return (int.parse(cartListProvider.getItemCartItemQuantity(
                        widget.productId, widget.productVariantId)) ==
                    0 &&
                widget.count != -1)
            ? SizedBox(
                width: 30,
                height: 30,
                child: Widgets.gradientBtnWidget(
                  context,
                  5,
                  callback: () async {
                    if (Constant.session.isUserLoggedIn()) {
                      Map<String, String> params = {};
                      params[ApiAndParams.productId] = widget.productId;
                      params[ApiAndParams.productVariantId] =
                          widget.productVariantId;
                      params[ApiAndParams.qty] = (int.parse(
                                  cartListProvider.getItemCartItemQuantity(
                                      widget.productId,
                                      widget.productVariantId)) +
                              1)
                          .toString();
                      await cartListProvider.addRemoveCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: widget.isUnlimitedStock,
                          maximumAllowedQuantity: widget.maximumAllowedQuantity,
                          availableStock: widget.availableStock,
                          actionFor: "add",
                          from: widget.from);
                    } else {
                      GeneralMethods.showSnackBarMsg(
                          context, StringsRes.lblRequiredLoginMessageForCart,
                          requiredAction: true);
                    }
                  },
                  otherWidgets: Widgets.defaultImg(
                      image: "cart_icon",
                      width: 20,
                      height: 20,
                      padding: EdgeInsetsDirectional.all(5),
                      iconColor: ColorsRes.appColorWhite),
                  height: 30,
                  isSetShadow: false,
                ),
              )
            : (int.parse(cartListProvider.getItemCartItemQuantity(
                            widget.productId, widget.productVariantId)) !=
                        0 &&
                    widget.count != -1)
                ? Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Widgets.gradientBtnWidget(
                          context,
                          5,
                          callback: () async {
                            Map<String, String> params = {};
                            params[ApiAndParams.productId] = widget.productId;
                            params[ApiAndParams.productVariantId] =
                                widget.productVariantId;
                            params[ApiAndParams.qty] = (int.parse(
                                        cartListProvider
                                            .getItemCartItemQuantity(
                                                widget.productId,
                                                widget.productVariantId)) -
                                    1)
                                .toString();

                            await cartListProvider.addRemoveCartItem(
                                context: context,
                                params: params,
                                isUnlimitedStock: widget.isUnlimitedStock,
                                maximumAllowedQuantity:
                                    widget.maximumAllowedQuantity,
                                availableStock: widget.availableStock,
                                from: widget.from);
                          },
                          otherWidgets: int.parse(
                                      cartListProvider.getItemCartItemQuantity(
                                          widget.productId,
                                          widget.productVariantId)) ==
                                  1
                              ? Widgets.defaultImg(
                                  image: "cart_delete",
                                  width: 20,
                                  height: 20,
                                  padding: EdgeInsetsDirectional.all(5),
                                  iconColor: ColorsRes.appColorWhite)
                              : Widgets.defaultImg(
                                  image: "cart_remove",
                                  width: 20,
                                  height: 20,
                                  padding: EdgeInsetsDirectional.all(5),
                                  iconColor: ColorsRes.appColorWhite),
                          height: 30,
                          isSetShadow: false,
                        ),
                      ),
                      Container(
                          alignment: AlignmentDirectional.center,
                          width: 30,
                          height: 30,
                          child: Text(
                            cartListProvider.getItemCartItemQuantity(
                                widget.productId, widget.productVariantId),
                            softWrap: true,
                          )),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Widgets.gradientBtnWidget(
                          context,
                          5,
                          callback: () async {
                            Map<String, String> params = {};
                            params[ApiAndParams.productId] = widget.productId;
                            params[ApiAndParams.productVariantId] =
                                widget.productVariantId;
                            params[ApiAndParams.qty] = (int.parse(
                                        cartListProvider
                                            .getItemCartItemQuantity(
                                                widget.productId,
                                                widget.productVariantId)) +
                                    1)
                                .toString();

                            await cartListProvider.addRemoveCartItem(
                                context: context,
                                params: params,
                                isUnlimitedStock: widget.isUnlimitedStock,
                                maximumAllowedQuantity:
                                    widget.maximumAllowedQuantity,
                                availableStock: widget.availableStock,
                                actionFor: "add",
                                from: widget.from);
                          },
                          otherWidgets: Widgets.defaultImg(
                              image: "cart_add",
                              width: 20,
                              height: 20,
                              padding: EdgeInsetsDirectional.all(5),
                              iconColor: ColorsRes.appColorWhite),
                          height: 30,
                          isSetShadow: false,
                        ),
                      )
                    ],
                  )
                : SizedBox.shrink();
      },
    );
  }
}
