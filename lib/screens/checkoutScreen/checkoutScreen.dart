import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/addressWidget.dart';
import 'widget/deliveryChargesWidget.dart';
import 'widget/paymentMethodWidget.dart';
import 'widget/swipeButtonWidget.dart';
import 'widget/timeSlotsWidget.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late AddressData selectedAddress;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await context
          .read<CheckoutProvider>()
          .getSingleAddressProvider(context: context)
          .then(
        (value) async {
          String lat;
          String long;
          String cityId;
          if (value.containsKey("address")) {
            selectedAddress = value["address"];
            lat = selectedAddress.latitude.toString();
            long = selectedAddress.longitude.toString();
            cityId = selectedAddress.cityId.toString();
          } else {
            lat = Constant.session.getData(ApiAndParams.latitude);
            long = Constant.session.getData(ApiAndParams.longitude);
            cityId = Constant.session.getData(ApiAndParams.cityId);
          }

          await context
              .read<CheckoutProvider>()
              .getOrderChargesProvider(context: context, params: {
            ApiAndParams.cityId: cityId,
            ApiAndParams.latitude: lat,
            ApiAndParams.longitude: long,
            ApiAndParams.isCheckout: "1"
          }).then((value) async {
            await context
                .read<CheckoutProvider>()
                .getTimeSlotsSettings(context: context);

            await context
                .read<CheckoutProvider>()
                .getPaymentMethods(context: context);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              StringsRes.lblCheckout,
              softWrap: true,
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    if (checkoutProvider.checkoutAddressState ==
                            CheckoutAddressState.addressLoading ||
                        checkoutProvider.checkoutTimeSlotsState ==
                            CheckoutTimeSlotsState.timeSlotsLoading ||
                        checkoutProvider.checkoutPaymentMethodsState ==
                            CheckoutPaymentMethodsState.paymentMethodLoading)
                      getCheckoutShimmer(),
                    if (checkoutProvider.checkoutAddressState ==
                            CheckoutAddressState.addressLoaded ||
                        checkoutProvider.checkoutAddressState ==
                            CheckoutAddressState.addressBlank)
                      getAddressWidget(context),
                    if (checkoutProvider.checkoutTimeSlotsState ==
                        CheckoutTimeSlotsState.timeSlotsLoaded)
                      getTimeSlots(checkoutProvider.timeSlotsData, context),
                    if (checkoutProvider.checkoutPaymentMethodsState ==
                        CheckoutPaymentMethodsState.paymentMethodLoaded)
                      getPaymentMethods(
                          checkoutProvider.paymentMethodsData, context),
                  ],
                )),
                Card(
                  child: Column(
                    children: [
                      if (checkoutProvider.checkoutDeliveryChargeState ==
                          CheckoutDeliveryChargeState.deliveryChargeLoaded)
                        getDeliveryCharges(context),
                      if (checkoutProvider.checkoutDeliveryChargeState ==
                          CheckoutDeliveryChargeState.deliveryChargeLoading)
                        getDeliveryChargeShimmer(),
                      SwipeButton(
                        context: context,
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  getCheckoutShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomShimmer(
          margin: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
          borderRadius: 7,
          width: double.maxFinite,
          height: 150,
        ),
        CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return CustomShimmer(
                width: 50,
                height: 80,
                borderRadius: 10,
                margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              );
            }),
          ),
        ),
        CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
      ],
    );
  }

  getDeliveryChargeShimmer() {
    return Padding(
      padding: EdgeInsets.all(Constant.paddingOrMargin10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(width: Constant.paddingOrMargin10),
              Expanded(
                child: CustomShimmer(
                  height: 20,
                  width: 80,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(height: Constant.paddingOrMargin7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(width: Constant.paddingOrMargin10),
              Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(height: Constant.paddingOrMargin7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(width: Constant.paddingOrMargin10),
              Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(height: Constant.paddingOrMargin7),
        ],
      ),
    );
  }
}
