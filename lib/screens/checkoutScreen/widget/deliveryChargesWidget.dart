import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getDeliveryCharges(BuildContext context) {
  return Container(
    padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: Constant.borderRadius10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsRes.lblOrderSummary,
            softWrap: true,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor)),
        Widgets.getSizedBox(height: 5),
        Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
        Widgets.getSizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(StringsRes.lblSubTotal,
                softWrap: true, style: TextStyle(fontSize: 17)),
            Text(
                GeneralMethods.getCurrencyFormat(
                    context.read<CheckoutProvider>().subTotalAmount),
                softWrap: true,
                style: TextStyle(fontSize: 17))
          ],
        ),
        Widgets.getSizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(StringsRes.lblDeliveryCharge,
                    softWrap: true, style: TextStyle(fontSize: 17)),
                GestureDetector(
                  onTapDown: (details) async {
                    await showMenu(
                      semanticLabel: "Hello",
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      )),
                      context: context,
                      position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy - 60,
                          details.globalPosition.dx,
                          details.globalPosition.dy),
                      items: List.generate(
                        context
                                .read<CheckoutProvider>()
                                .sellerWiseDeliveryCharges
                                .length +
                            1,
                        (index) => PopupMenuItem(
                          child: index == 0
                              ? Column(
                                  children: [
                                    Text(
                                      StringsRes
                                          .lblSellerWiseDeliveryChargesDetail,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context
                                          .read<CheckoutProvider>()
                                          .sellerWiseDeliveryCharges[index - 1]
                                          .sellerName,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                        GeneralMethods.getCurrencyFormat(context
                                            .read<CheckoutProvider>()
                                            .sellerWiseDeliveryCharges[
                                                index - 1]
                                            .deliveryCharge),
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                        ),
                      ),
                      elevation: 8.0,
                    );
                  },
                  child: Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
            Text(
                GeneralMethods.getCurrencyFormat(
                    context.read<CheckoutProvider>().deliveryCharge),
                softWrap: true,
                style: TextStyle(fontSize: 17))
          ],
        ),
        Widgets.getSizedBox(height: 5),
        Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
        Widgets.getSizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(StringsRes.lblTotal,
                softWrap: true, style: TextStyle(fontSize: 17)),
            Text(
                GeneralMethods.getCurrencyFormat(
                    context.read<CheckoutProvider>().totalAmount),
                softWrap: true,
                style: TextStyle(
                    fontSize: 17,
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}
