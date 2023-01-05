import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/paymentMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getPaymentMethods(
    PaymentMethodsData? paymentMethodsData, BuildContext context) {
  return paymentMethodsData != null
      ? Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(Constant.paddingOrMargin10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsRes.lblPaymentMethod,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor)),
                Widgets.getSizedBox(height: 5),
                Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
                Widgets.getSizedBox(height: 5),
                Column(
                  children: [
                    if (paymentMethodsData.codPaymentMethod == "1" &&
                        context.read<CheckoutProvider>().isCodAllowed == true)
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CheckoutProvider>()
                              .setSelectedPaymentMethod("COD");
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.symmetric(
                              vertical: Constant.paddingOrMargin5),
                          decoration: BoxDecoration(
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "COD"
                                  ? Constant.session.getBoolData(
                                          SessionManager.isDarkTheme)
                                      ? ColorsRes.appColorBlack
                                      : ColorsRes.appColorWhite
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.8),
                              borderRadius: Constant.borderRadius7,
                              border: Border.all(
                                width: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "COD"
                                    ? 1
                                    : 0.3,
                                color: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "COD"
                                    ? ColorsRes.appColor
                                    : ColorsRes.grey,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Widgets.defaultImg(
                                    image: "ic_cod", width: 25, height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Text(StringsRes.lblCashOnDelivery),
                              ),
                              Spacer(),
                              Radio(
                                value: "COD",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                onChanged: (value) {
                                  context
                                      .read<CheckoutProvider>()
                                      .setSelectedPaymentMethod("COD");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.razorpayPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CheckoutProvider>()
                              .setSelectedPaymentMethod("Razorpay");
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.symmetric(
                              vertical: Constant.paddingOrMargin5),
                          decoration: BoxDecoration(
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Razorpay"
                                  ? Constant.session.getBoolData(
                                          SessionManager.isDarkTheme)
                                      ? ColorsRes.appColorBlack
                                      : ColorsRes.appColorWhite
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.8),
                              borderRadius: Constant.borderRadius7,
                              border: Border.all(
                                width: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "Razorpay"
                                    ? 1
                                    : 0.3,
                                color: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "Razorpay"
                                    ? ColorsRes.appColor
                                    : ColorsRes.grey,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Widgets.defaultImg(
                                    image: "ic_razorpay",
                                    width: 35,
                                    height: 35),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Text(StringsRes.lblRazorpay),
                              ),
                              Spacer(),
                              Radio(
                                value: "Razorpay",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                onChanged: (value) {
                                  context
                                      .read<CheckoutProvider>()
                                      .setSelectedPaymentMethod("Razorpay");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (paymentMethodsData.paystackPaymentMethod == "1")
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CheckoutProvider>()
                              .setSelectedPaymentMethod("Paystack");
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.symmetric(
                              vertical: Constant.paddingOrMargin5),
                          decoration: BoxDecoration(
                              color: context
                                          .read<CheckoutProvider>()
                                          .selectedPaymentMethod ==
                                      "Paystack"
                                  ? Constant.session.getBoolData(
                                          SessionManager.isDarkTheme)
                                      ? ColorsRes.appColorBlack
                                      : ColorsRes.appColorWhite
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.8),
                              borderRadius: Constant.borderRadius7,
                              border: Border.all(
                                width: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "Paystack"
                                    ? 1
                                    : 0.3,
                                color: context
                                            .read<CheckoutProvider>()
                                            .selectedPaymentMethod ==
                                        "Paystack"
                                    ? ColorsRes.appColor
                                    : ColorsRes.grey,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Widgets.defaultImg(
                                    image: "ic_paystack",
                                    width: 25,
                                    height: 25),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin10),
                                child: Text(StringsRes.lblPaystack),
                              ),
                              Spacer(),
                              Radio(
                                value: "Paystack",
                                groupValue: context
                                    .read<CheckoutProvider>()
                                    .selectedPaymentMethod,
                                onChanged: (value) {
                                  context
                                      .read<CheckoutProvider>()
                                      .setSelectedPaymentMethod("Paystack");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        )
      : SizedBox.shrink();
}
