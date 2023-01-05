import 'dart:convert';

import 'package:egrocer/helper/generalWidgets/swipeButtonView.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/checkoutProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SwipeButton extends StatefulWidget {
  final BuildContext context;

  SwipeButton({Key? key, required this.context}) : super(key: key);

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  bool isFinished = false;
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late String paystackKey = "";
  late double amount = 0.00;
  late PaystackPlugin paystackPlugin;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      paystackPlugin = await PaystackPlugin();

      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
    });
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) {
    context.read<CheckoutProvider>().transactionId =
        response.paymentId.toString();
    context.read<CheckoutProvider>().addTransaction(context: context);
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    setState(() {
      isFinished = false;
      Map<dynamic, dynamic> message =
          jsonDecode(response.message ?? "")["error"];
      GeneralMethods.showSnackBarMsg(context, message["description"]);
    });
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    GeneralMethods.showSnackBarMsg(context, response.toString());
  }

  void openRazorPayGateway() async {
    final options = {
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<CheckoutProvider>().razorpayOrderId,
      'amount': (amount * 100).toInt(),
      'name': StringsRes.appName,
      'currency': 'INR',
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      }
    };

    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    await paystackPlugin.initialize(
        publicKey: context
            .read<CheckoutProvider>()
            .paymentMethodsData
            .paystackPublicKey);

    Charge charge = await Charge()
      ..amount = (amount * 100).toInt()
      ..currency = context
          .read<CheckoutProvider>()
          .paymentMethodsData
          .paystackCurrencyCode
      ..reference = context.read<CheckoutProvider>().payStackReference
      ..email = Constant.session.getData(SessionManager.keyEmail);

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      fullscreen: false,
      logo: Widgets.defaultImg(
          height: 50, width: 50, image: "logo", iconColor: ColorsRes.appColor),
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status) {
      context.read<CheckoutProvider>().addTransaction(context: context);
    } else {
      setState(() {
        isFinished = false;
        GeneralMethods.showSnackBarMsg(context, response.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(Constant.paddingOrMargin10, 0,
          Constant.paddingOrMargin10, Constant.paddingOrMargin10),
      child: SwipeButtonView(
        isActive: context.read<CheckoutProvider>().isDeliverable,
        buttonText: context.read<CheckoutProvider>().isDeliverable == false
            ? StringsRes.lblUnableToCheckout
            : StringsRes.lblSwipeToPlaceOrder,
        buttonTextStyle: TextStyle(
            color: context.read<CheckoutProvider>().isDeliverable
                ? ColorsRes.appColor
                : Constant.session.getBoolData(SessionManager.isDarkTheme)
                    ? ColorsRes.appColorWhite
                    : ColorsRes.appColorBlack),
        buttonWidget: Container(
          height: 60,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          decoration: DesignConfig.boxGradient(8,
              color1: context.read<CheckoutProvider>().isDeliverable == false
                  ? ColorsRes.grey
                  : ColorsRes.gradient1,
              color2: context.read<CheckoutProvider>().isDeliverable == false
                  ? ColorsRes.grey
                  : ColorsRes.gradient2,
              isSetShadow: false),
          child: Lottie.asset(Constant.getAssetsPath(3, "swipe_to_order")),
        ),
        disableColor: ColorsRes.grey,
        activeColor: ColorsRes.appColor.withOpacity(0.15),
        isFinished: isFinished,
        onWaitingProcess: () {
          if (context.read<CheckoutProvider>().selectedPaymentMethod == "COD") {
            context
                .read<CheckoutProvider>()
                .placeOrder(context: context)
                .then((value) {
              setState(() {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    orderPlaceScreen, (Route<dynamic> route) => false);
              });
            });
          } else if (context.read<CheckoutProvider>().selectedPaymentMethod ==
              "Razorpay") {
            razorpayKey =
                context.read<CheckoutProvider>().paymentMethodsData.razorpayKey;
            amount =
                context.read<CheckoutProvider>().deliveryChargeData.totalAmount;
            context
                .read<CheckoutProvider>()
                .placeOrder(context: context)
                .then((value) {
              context
                  .read<CheckoutProvider>()
                  .initiateRazorpayTransaction(context: context)
                  .then((value) => setState(() {
                        isFinished = true;
                        openRazorPayGateway();
                      }));
            });
          } else if (context.read<CheckoutProvider>().selectedPaymentMethod ==
              "Paystack") {
            amount =
                context.read<CheckoutProvider>().deliveryChargeData.totalAmount;
            context
                .read<CheckoutProvider>()
                .placeOrder(context: context)
                .then((value) {
              setState(() {
                isFinished = true;
                openPaystackPaymentGateway();
              });
            });
          }
        },
        onFinish: () async {
          isFinished = false;
        },
      ),
    );
  }
}
