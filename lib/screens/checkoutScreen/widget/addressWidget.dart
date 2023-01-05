import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getAddressWidget(BuildContext context) {
  return Card(
    color: Theme.of(context).cardColor,
    elevation: 0,
    child: Padding(
      padding: EdgeInsets.all(Constant.paddingOrMargin10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringsRes.lblAddressDetail,
              softWrap: true,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor)),
          Widgets.getSizedBox(height: 5),
          Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
          Widgets.getSizedBox(height: 5),
          context.read<CheckoutProvider>().checkoutAddressState ==
                  CheckoutAddressState.addressLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context
                              .read<CheckoutProvider>()
                              .selectedAddress!
                              .name,
                          softWrap: true,
                          style: TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, addressListScreen,
                                    arguments: "checkout")
                                .then((value) {
                              context
                                  .read<CheckoutProvider>()
                                  .setSelectedAddress(context, value);
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: DesignConfig.boxGradient(5),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.zero,
                            child: Widgets.defaultImg(
                                image: "edit_icon",
                                iconColor: Colors.white,
                                height: 20,
                                width: 20),
                          ),
                        )
                      ],
                    ),
                    Widgets.getSizedBox(height: 7),
                    Text(
                      "${context.read<CheckoutProvider>().selectedAddress!.area},${context.read<CheckoutProvider>().selectedAddress!.landmark}, ${context.read<CheckoutProvider>().selectedAddress!.address}, ${context.read<CheckoutProvider>().selectedAddress!.state}, ${context.read<CheckoutProvider>().selectedAddress!.city}, ${context.read<CheckoutProvider>().selectedAddress!.country} - ${context.read<CheckoutProvider>().selectedAddress!.pincode} ",
                      softWrap: true,
                      style: TextStyle(
                          /*fontSize: 18,*/
                          color: ColorsRes.subTitleTextColor),
                    ),
                    Widgets.getSizedBox(height: 7),
                    Text(
                      context.read<CheckoutProvider>().selectedAddress!.mobile,
                      softWrap: true,
                      style: TextStyle(
                          /*fontSize: 18,*/
                          color: ColorsRes.subTitleTextColor),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, addressListScreen,
                            arguments: "checkout")
                        .then((value) {
                      if (value != null) {
                        context
                            .read<CheckoutProvider>()
                            .setSelectedAddress(context, value as AddressData);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Constant.paddingOrMargin10),
                    child: Text(StringsRes.lblAddNewAddress,
                        softWrap: true,
                        style: TextStyle(
                          color: ColorsRes.appColorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                ),
        ],
      ),
    ),
  );
}
