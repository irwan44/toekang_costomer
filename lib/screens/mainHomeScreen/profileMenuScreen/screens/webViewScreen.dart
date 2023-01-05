import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WebViewScreen extends StatefulWidget {
  final String dataFor;

  WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool privacyPolicyExpanded = false;
  bool returnExchangePolicyExpanded = false;
  bool shippingPolicyExpanded = false;
  bool cancellationPolicyExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          title: Text(
            widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: widget.dataFor == StringsRes.lblPolicies
            ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: DesignConfig.boxDecoration(
                        Theme.of(context).cardColor,
                        10,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: privacyPolicyExpanded,
                        onExpansionChanged: (bool expanded) {
                          setState(() => privacyPolicyExpanded = expanded);
                        },
                        title: Text(
                          StringsRes.lblPrivacyPolicy,
                          style: TextStyle(color: ColorsRes.mainTextColor),
                        ),
                        trailing: Icon(
                          privacyPolicyExpanded ? Icons.remove : Icons.add,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.paddingOrMargin30,
                                top: Constant.paddingOrMargin5,
                                bottom: Constant.paddingOrMargin10,
                                end: Constant.paddingOrMargin10),
                            child: HtmlWidget(
                              Constant.privacyPolicy,
                              isSelectable: false,
                              enableCaching: true,
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: DesignConfig.boxDecoration(
                        Theme.of(context).cardColor,
                        10,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: returnExchangePolicyExpanded,
                        onExpansionChanged: (bool expanded) {
                          setState(
                              () => returnExchangePolicyExpanded = expanded);
                        },
                        title: Text(
                          StringsRes.lblReturnsAndExchangesPolicy,
                          style: TextStyle(color: ColorsRes.mainTextColor),
                        ),
                        trailing: Icon(
                          returnExchangePolicyExpanded
                              ? Icons.remove
                              : Icons.add,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.paddingOrMargin30,
                                top: Constant.paddingOrMargin5,
                                bottom: Constant.paddingOrMargin10,
                                end: Constant.paddingOrMargin10),
                            child: HtmlWidget(
                              Constant.returnAndExchangesPolicy,
                              isSelectable: false,
                              enableCaching: true,
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: DesignConfig.boxDecoration(
                        Theme.of(context).cardColor,
                        10,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: shippingPolicyExpanded,
                        onExpansionChanged: (bool expanded) {
                          setState(() => shippingPolicyExpanded = expanded);
                        },
                        title: Text(
                          StringsRes.lblShippingPolicy,
                          style: TextStyle(color: ColorsRes.mainTextColor),
                        ),
                        trailing: Icon(
                          shippingPolicyExpanded ? Icons.remove : Icons.add,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.paddingOrMargin30,
                                top: Constant.paddingOrMargin5,
                                bottom: Constant.paddingOrMargin10,
                                end: Constant.paddingOrMargin10),
                            child: HtmlWidget(
                              Constant.shippingPolicy,
                              isSelectable: false,
                              enableCaching: true,
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: DesignConfig.boxDecoration(
                        Theme.of(context).cardColor,
                        10,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: cancellationPolicyExpanded,
                        onExpansionChanged: (bool expanded) {
                          setState(() => cancellationPolicyExpanded = expanded);
                        },
                        title: Text(
                          StringsRes.lblCancellationPolicy,
                          style: TextStyle(color: ColorsRes.mainTextColor),
                        ),
                        trailing: Icon(
                          cancellationPolicyExpanded ? Icons.remove : Icons.add,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.paddingOrMargin30,
                                top: Constant.paddingOrMargin5,
                                bottom: Constant.paddingOrMargin10,
                                end: Constant.paddingOrMargin10),
                            child: HtmlWidget(
                              Constant.cancellationPolicy,
                              isSelectable: false,
                              enableCaching: true,
                            ),
                          )
                        ],
                      )),
                ],
              )
            : Padding(
                padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
                child: HtmlWidget(
                  widget.dataFor == StringsRes.lblContactUs
                      ? Constant.contactUs
                      : widget.dataFor == StringsRes.lblAboutUs
                          ? Constant.aboutUs
                          : Constant.termsConditions,
                  isSelectable: false,
                  enableCaching: true,
                ),
              ),
      ),
    );
  }
}
