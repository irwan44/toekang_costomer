import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/promoCodeProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/dashedRect.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/promoCode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoCodeListScreen extends StatefulWidget {
  final double amount;

  PromoCodeListScreen({Key? key, required this.amount}) : super(key: key);

  @override
  State<PromoCodeListScreen> createState() => _PromoCodeListScreenState();
}

class _PromoCodeListScreenState extends State<PromoCodeListScreen> {
  @override
  void initState() {
    super.initState();

    //fetch PromoCodeList from api
    Future.delayed(Duration.zero).then((value) async {
      await context.read<PromoCodeProvider>().getPromoCodeProvider(
          params: {ApiAndParams.amount: widget.amount.toString()},
          context: context);
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
              StringsRes.lblPromoCodes,
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return true;
          },
          child: setRefreshIndicator(
            refreshCallback: () async {
              await context.read<PromoCodeProvider>().getPromoCodeProvider(
                  params: {ApiAndParams.amount: widget.amount.toString()},
                  context: context);
            },
            child: SingleChildScrollView(
              child: Consumer<PromoCodeProvider>(
                builder: (context, promoCodeProvider, _) {
                  return promoCodeProvider.promoCodeState ==
                          PromoCodeState.loading
                      ? promoCodeListShimmer()
                      : promoCodeProvider.promoCodeState ==
                              PromoCodeState.loaded
                          ? Column(
                              children: List.generate(
                                  promoCodeProvider.promoCode.data.length,
                                  (index) => promoCodeItemWidget(
                                      promoCodeProvider.promoCode.data[index])),
                            )
                          : Container();
                },
              ),
            ),
          ),
        ));
  }

  promoCodeItemWidget(PromoCodeData promoCode) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Container(
          padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: Constant.borderRadius10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Widgets.setNetworkImg(
                    boxFit: BoxFit.fill,
                    image: promoCode.imageUrl,
                    height: 50,
                    width: 50,
                  )),
              Widgets.getSizedBox(height: 7),
              Text(
                promoCode.promoCodeMessage,
                softWrap: true,
                style: TextStyle(fontSize: 16),
              ),
              Widgets.getSizedBox(height: 7),
              Text(
                promoCode.isApplicable == 0
                    ? promoCode.message
                    : "You will save ${GeneralMethods.getCurrencyFormat(promoCode.discount)} on this coupon",
                softWrap: true,
                style: TextStyle(
                    color: promoCode.isApplicable == 0
                        ? ColorsRes.appColorRed
                        : ColorsRes.subTitleTextColor),
              ),
              Widgets.getSizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            end: Constant.paddingOrMargin12),
                        child: promoCodeWidget(
                            promoCode.promoCode,
                            promoCode.isApplicable == 0
                                ? ColorsRes.grey
                                : ColorsRes.appColor)),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (promoCode.isApplicable == 1 &&
                            Constant.selectedCoupon != promoCode.promoCode) {
                          context
                              .read<PromoCodeProvider>()
                              .applyPromoCode(promoCode);
                          Navigator.pop(context, true);
                        }
                      },
                      child: Constant.selectedCoupon != promoCode.promoCode
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Constant.paddingOrMargin5,
                                  horizontal: Constant.paddingOrMargin7),
                              decoration: DesignConfig.boxDecoration(
                                  promoCode.isApplicable == 0
                                      ? ColorsRes.grey.withOpacity(0.2)
                                      : ColorsRes.appColorLightHalfTransparent,
                                  5,
                                  bordercolor: promoCode.isApplicable == 0
                                      ? ColorsRes.grey
                                      : ColorsRes.appColor,
                                  isboarder: true,
                                  borderwidth: 1),
                              child: Center(
                                child: Text(StringsRes.lblApply,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: promoCode.isApplicable == 0
                                                ? ColorsRes.grey
                                                : ColorsRes.appColor)),
                              ),
                            )
                          : Center(
                              child: Text(StringsRes.lblApplied,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          fontSize: 13,
                                          color: ColorsRes.appColor)),
                            ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  promoCodeWidget(String promoCode, Color color) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return GestureDetector(
            onTap: () {
              //
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  height: 30,
                  decoration:
                      DesignConfig.boxDecoration(color.withOpacity(0.2), 7),
                  child: DashedRect(
                    color: color,
                    strokeWidth: 1.0,
                    gap: 10,
                  ),
                ),
                Center(
                  child: Text(promoCode),
                )
              ],
            ));
      },
    );
  }

  promoCodeListShimmer() {
    return Column(
      children: List.generate(10, (index) {
        return CustomShimmer(
          height: 150,
          width: double.maxFinite,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(5),
        );
      }),
    );
  }
}
