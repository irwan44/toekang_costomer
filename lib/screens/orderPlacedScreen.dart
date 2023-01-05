import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        context.read<CartListProvider>().clearCart(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
          children: [
            Lottie.asset(
                Constant.getAssetsPath(3, "order_placed_back_animation"),
                height: double.maxFinite,
                width: double.maxFinite,
                repeat: false),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Constant.paddingOrMargin10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                      Constant.getAssetsPath(3, "order_success_tick_animation"),
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      repeat: false),
                  Widgets.getSizedBox(height: Constant.paddingOrMargin20),
                  Text(
                    StringsRes.lblOrderPlaceMessage,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5!.merge(
                        TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5)),
                  ),
                  Widgets.getSizedBox(height: Constant.paddingOrMargin20),
                  Text(
                    StringsRes.lblOrderPlaceDescription,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .merge(TextStyle(letterSpacing: 0.5)),
                  ),
                  Widgets.getSizedBox(height: Constant.paddingOrMargin20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          mainHomeScreen, (Route<dynamic> route) => false);
                    },
                    child: Text(
                      StringsRes.lblContinueShopping,
                      softWrap: true,
                    ),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(
                                color: ColorsRes.appColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
