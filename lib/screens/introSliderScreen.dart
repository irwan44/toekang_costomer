import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';

class IntroSliderScreen extends StatefulWidget {
  IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {
  final _pageController = PageController();
  int currentPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageView(),
    );
  }

  _buildPageView() {
    return Stack(
      children: [
        pageWidget(currentPosition),
        PageView.builder(
            itemCount: Constant.introSlider.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return Container();
            },
            onPageChanged: (int index) {
              currentPosition = index;
              setState(() {});
            }),
        Positioned(
            bottom: 50,
            left: currentPosition == Constant.introSlider.length - 1 ? 80 : 0,
            right: currentPosition == Constant.introSlider.length - 1 ? 80 : 0,
            child: buttonWidget(currentPosition)),
      ],
    );
  }

  pageWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Widgets.defaultImg(
            padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin15),
            image: Constant.introSlider[index]["image"],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                child: infoWidget(index),
                padding:
                    EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 10),
                margin: EdgeInsetsDirectional.only(
                    start: 20, end: 20, bottom: 20, top: 50),
                decoration: DesignConfig.boxDecoration(ColorsRes.appColor, 30),
              ),
              Container(
                  width: 100,
                  height: 100,
                  //child:Image.asset(Constant.getImagePath("intro_logo.png"))),
                  decoration: ShapeDecoration(
                      color: ColorsRes.appColor,
                      shape: CircleBorder(
                          side: BorderSide(width: 5, color: Colors.white))),
                  child: Center(
                      child: Widgets.defaultImg(
                    image: "logo",
                    height: 50,
                    width: 50,
                  ))),
            ],
          ),
        )
      ],
    );
  }

  infoWidget(int index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(Constant.introSlider[index]["title"],
                softWrap: true,
                style: Theme.of(context).textTheme.headline5!.merge(
                      TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
          ),
          Text(
            Constant.introSlider[index]["description"],
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                height: 1.5,
                fontWeight: FontWeight.w400)),
          ),
        ]);
  }

  buttonWidget(int index) {
    return GestureDetector(
      onTap: () {
        if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
            Constant.session.getBoolData(SessionManager.isUserLogin)) {
          if (Constant.session.getData(SessionManager.keyLatitude) == "" &&
              Constant.session.getData(SessionManager.keyLongitude) == "") {
            Navigator.pushNamed(context, getLocationScreen,
                arguments: "location");
          } else {
            Navigator.pushNamed(context, mainHomeScreen);
          }
        } else {
          Navigator.pushReplacementNamed(context, loginScreen);
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin15,
        ),
        margin: EdgeInsets.only(top: 80),
        decoration: DesignConfig.boxDecoration(
            index == Constant.introSlider.length - 1
                ? Colors.white
                : Colors.transparent,
            10),
        child: index == Constant.introSlider.length - 1
            ? Text(
                StringsRes.lblGetStarted,
                softWrap: true,
                style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.w400)),
              )
            : dotWidget(),
      ),
    );
  }

  dotWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(Constant.introSlider.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 600),
            margin: EdgeInsetsDirectional.only(end: 10.0),
            width: currentPosition == index ? 30 : 13,
            height: currentPosition == index ? 12 : 13,
            decoration: DesignConfig.boxDecoration(Colors.white, 13),
          );
        }),
      ),
    );
  }
}
