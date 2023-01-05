import 'dart:async';

import 'package:egrocer/helper/generalWidgets/cartListItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/cartProvider.dart';
import 'package:egrocer/helper/provider/promoCodeProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/dashedRect.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/cartData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartListScreen extends StatefulWidget {
  CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  @override
  void initState() {
    super.initState();

    Constant.isPromoCodeApplied = false;
    Constant.selectedCoupon = "";
    Constant.discountedAmount = 0.0;
    Constant.discount = 0.0;

    //fetch cartList from api
    Future.delayed(Duration.zero).then((value) async {
      await context.read<CartProvider>().getCartListProvider(context: context);
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              StringsRes.lblCart,
              softWrap: true,
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: Stack(
          children: [
            setRefreshIndicator(
                refreshCallback: () async {
                  await context
                      .read<CartProvider>()
                      .getCartListProvider(context: context);
                },
                child: Stack(
                  children: [
                    (context.watch<CartListProvider>().cartList.length > 0 ||
                            context.read<CartProvider>().cartState ==
                                CartState.error)
                        ? cartWidget()
                        : PositionedDirectional(
                            top: 0,
                            start: 0,
                            end: 0,
                            bottom: 0,
                            child: DefaultBlankItemMessageScreen(
                              image: "cart_empty",
                              title: StringsRes.lblEmptyCartListMessage,
                              description:
                                  StringsRes.lblEmptyCartListDescription,
                              btntext: StringsRes.lblEmptyCartListButtonName,
                              callback: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                  ],
                )),
            Consumer<CartListProvider>(
              builder: (context, cartListProvider, child) {
                return cartListProvider.cartListState == CartListState.loading
                    ? PositionedDirectional(
                        top: 0,
                        end: 0,
                        start: 0,
                        bottom: 0,
                        child: Container(
                            color: ColorsRes.appColorBlack.withOpacity(0.2),
                            child: Center(child: CircularProgressIndicator())),
                      )
                    : SizedBox.shrink();
              },
            )
          ],
        ));
  }

  btnWidget() {
    return Widgets.gradientBtnWidget(context, 10, isSetShadow: false,
        callback: () {
      Navigator.pushNamed(context, checkoutScreen);
    },
        otherWidgets: Text(
          StringsRes.lblProceedToCheckout,
          softWrap: true,
          style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500)),
        ));
  }

  cartWidget() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return (cartProvider.cartState == CartState.initial ||
                cartProvider.cartState == CartState.loading)
            ? getCartListShimmer(
                context: context,
              )
            : (cartProvider.cartState == CartState.loaded)
                ? Column(
                    children: [
                      Expanded(
                          child: ListView(
                        padding: EdgeInsetsDirectional.only(
                            bottom: Constant.paddingOrMargin10),
                        children: List.generate(
                            cartProvider.cartData.data.cart.length, (index) {
                          Cart cart = cartProvider.cartData.data.cart[index];
                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: Constant.paddingOrMargin10,
                              end: Constant.paddingOrMargin10,
                            ),
                            child: CartListItemContainer(
                              cart: cart,
                              from: 'cartList',
                            ),
                          );
                        }),
                      )),
                      Container(
                        padding: EdgeInsetsDirectional.all(
                            Constant.paddingOrMargin10),
                        margin: EdgeInsetsDirectional.only(
                            bottom: Constant.paddingOrMargin10,
                            start: Constant.paddingOrMargin10,
                            end: Constant.paddingOrMargin10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: Constant.borderRadius10),
                        child: Column(
                          children: [
                            /*Consumer<PromoCodeProvider>(
                                builder: (context, promoCodeProvider, _) {
                              return */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection: Directionality.of(context),
                              children: [
                                Text(
                                    "${StringsRes.lblSubTotal} (${cartProvider.cartData.data.cart.length} ${cartProvider.cartData.data.cart.length > 1 ? StringsRes.lblItems : StringsRes.lblItem})",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 17)),
                                Text(
                                    "${GeneralMethods.getCurrencyFormat(Constant.isPromoCodeApplied == true ? Constant.discountedAmount : double.parse(cartProvider.subTotal.toString()))}",
                                    softWrap: true,
                                    style: TextStyle(fontSize: 17)),
                              ],
                            ),
                            // }),
                            SizedBox(height: 15),
                            btnWidget()
                          ],
                        ),
                      )
                    ],
                  )
                : DefaultBlankItemMessageScreen(
                    title: StringsRes.lblEmptyCartListMessage,
                    description: StringsRes.lblEmptyCartListDescription,
                    btntext: StringsRes.lblEmptyCartListButtonName,
                    callback: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          mainHomeScreen, (Route<dynamic> route) => false);
                    },
                    image: "no_product_icon",
                  );
      },
    );
  }

  promoCodeLayoutWidget(BuildContext context) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, promoCodeScreen,
                        arguments:
                            context.read<CartProvider>().cartData.data.subTotal)
                    .then((value) {
                  if (value == true) {
                    setState(() {});
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 45,
                    decoration: DesignConfig.boxDecoration(
                        ColorsRes.appColor.withOpacity(0.2), 10),
                    child: DashedRect(
                      color: ColorsRes.appColor,
                      strokeWidth: 1.0,
                      gap: 10,
                    ),
                  ),
                  Row(children: [
                    SizedBox(width: 12),
                    Container(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          backgroundColor: ColorsRes.appColor,
                          radius: 100,
                          child: Widgets.defaultImg(
                              image: "discount_coupon_icon",
                              height: 15,
                              width: 15,
                              iconColor: ColorsRes.appColorWhite),
                        )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      Constant.isPromoCodeApplied == true
                          ? Constant.selectedCoupon
                          : StringsRes.lblApplyDiscountCode,
                      softWrap: true,
                    )),
                    Text(
                      StringsRes.lblChangeCoupon,
                      style: TextStyle(color: ColorsRes.appColor),
                    ),
                    SizedBox(width: 12),
                  ])
                ],
              ),
            ),
            SizedBox(height: 12),
            if (Constant.isPromoCodeApplied == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: Directionality.of(context),
                children: [
                  Text("${StringsRes.lblCoupon} (${Constant.selectedCoupon})",
                      softWrap: true, style: TextStyle(fontSize: 17)),
                  Text("${GeneralMethods.getCurrencyFormat(Constant.discount)}",
                      softWrap: true, style: TextStyle(fontSize: 17)),
                ],
              ),
          ],
        );
      },
    );
  }

  getCartListShimmer({required BuildContext context}) {
    return ListView(
      children: List.generate(10, (index) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
      }),
    );
  }
}
