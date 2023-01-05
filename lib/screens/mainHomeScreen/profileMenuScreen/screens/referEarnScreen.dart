import 'dart:math' as math;

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/dashedRect.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarn extends StatefulWidget {
  ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  bool isCreatingLink = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblReferAndEarn,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: Stack(
        children: [
          ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin10),
              children: [
                topImage(),
                infoWidget(),
                howWorksWidget(),
                referCodeWidget()
              ]),
          if (isCreatingLink == true)
            PositionedDirectional(
              top: 0,
              end: 0,
              start: 0,
              bottom: 0,
              child: Container(
                  color: ColorsRes.appColorBlack.withOpacity(0.2),
                  child: Center(child: CircularProgressIndicator())),
            )
        ],
      ),
    );
  }

  referCodeWidget() {
    return Card(
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin15),
            child: Text(
              StringsRes.lblYourReferralCode,
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
          Divider(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text:
                      "${Constant.session.getData(SessionManager.keyReferralCode).toString()}"));
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblReferCodeCopied);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 50,
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
                    Expanded(
                        child: Text(
                      Constant.session
                          .getData(SessionManager.keyReferralCode)
                          .toString(),
                      softWrap: true,
                    )),
                    Text(
                      StringsRes.lblTapToCopy,
                      softWrap: true,
                      style: TextStyle(color: ColorsRes.appColor),
                    ),
                    SizedBox(width: 12),
                  ])
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10),
              child: btnWidget()),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  btnWidget() {
    return Widgets.gradientBtnWidget(context, 10, callback: () {
      if (isCreatingLink == false) {
        setState(() {
          isCreatingLink = true;
        });
        shareCode();
      }
    },
        otherWidgets: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Widgets.defaultImg(image: "share_icon", iconColor: Colors.white),
            SizedBox(width: 8),
            Text(
              StringsRes.lblReferNow,
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
            )
          ],
        ));
  }

  shareCode() async {
    String prefixMessage = StringsRes.lblReferAndEarnSharePrefixMessage;
    String shareMessage = await GeneralMethods.createDynamicLink(
      shareUrl:
          "${Constant.hostUrl}refer/${Constant.session.getData(SessionManager.keyReferralCode).toString()}",
    );
    await Share.share("$prefixMessage $shareMessage",
        subject: "Refer and earn app");

    setState(() {
      isCreatingLink = false;
    });
  }

  topImage() {
    return Card(
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Constant.paddingOrMargin8,
          ),
          child: Widgets.defaultImg(image: "refer_and_earn")),
    );
  }

  infoWidget() {
    String maxEarnAmount = Constant.referEarnMethod == "percentage"
        ? "${Constant.maximumReferEarnAmount}%"
        : GeneralMethods.getCurrencyFormat(
            double.parse(Constant.maximumReferEarnAmount));
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: DesignConfig.setRoundedBorder(8),
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Constant.paddingOrMargin8,
          ),
          child: Column(children: [
            infoItem(
                "${StringsRes.lblReferAndEarnShareDisplayMessage1Postfix} $maxEarnAmount ${StringsRes.lblReferAndEarnShareDisplayMessage1Prefix}"),
            infoItem(
                "${StringsRes.lblReferAndEarnShareDisplayMessage2} ${GeneralMethods.getCurrencyFormat(double.parse(Constant.minimumReferEarnOrderAmount))}."),
            infoItem(
                "${StringsRes.lblReferAndEarnShareDisplayMessage3} $maxEarnAmount."),
          ])),
    );
  }

  infoItem(String text) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 10,
      minLeadingWidth: 10,
      leading: Icon(Icons.brightness_1, color: ColorsRes.appColor, size: 15),
      title: Text(
        text,
        softWrap: true,
      ),
    );
  }

  List workflowlist = [
    {"icon": "refer_step_1", "info": StringsRes.lblInviteFriendToSignup},
    {"icon": "refer_step_2", "info": StringsRes.lblFriendDownloadApp},
    {"icon": "refer_step_3", "info": StringsRes.lblFriendPlaceFirstOrder},
    {
      "icon": "refer_step_4",
      "info": StringsRes.lblYouWillGetRewardAfterDelivered
    },
  ];

  howWorksWidget() {
    return Card(
      elevation: 0,
      color: ColorsRes.appColor,
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin15),
          child: Text(
            StringsRes.lblHowItWorks,
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.white38,
        ),
        ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin8,
              vertical: Constant.paddingOrMargin10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: workflowlist.length,
          separatorBuilder: ((context, index) {
            return Container(
                margin: EdgeInsetsDirectional.only(
                    top: 3, bottom: 5, start: index % 2 == 0 ? 5 : 17),
                alignment: Alignment.centerLeft,
                child: index % 2 == 0
                    ? Widgets.defaultImg(image: "rf_arrow_right")
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Widgets.defaultImg(image: "rf_arrow_right")));
          }),
          itemBuilder: ((context, index) => Row(children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Widgets.defaultImg(image: workflowlist[index]['icon'])),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    workflowlist[index]['info'],
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Colors.white, letterSpacing: 0.5)),
                  ),
                )
              ])),
        )
      ]),
    );
  }
}
