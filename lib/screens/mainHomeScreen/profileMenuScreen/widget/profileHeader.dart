import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/userProfileProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

profileHeader({required BuildContext context, required bool isUserLogin}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
          context, isUserLogin ? editProfileScreen : loginScreen,
          arguments: "");
    },
    child: Card(
      elevation: 0,
      margin: EdgeInsetsDirectional.only(bottom: 5, start: 3, end: 3),
      child: Stack(
        children: [
          Row(children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: isUserLogin
                      ? Widgets.setNetworkImg(
                          height: 60,
                          width: 60,
                          boxFit: BoxFit.fill,
                          image: Constant.session
                              .getData(SessionManager.keyUserImage))
                      : Widgets.defaultImg(
                          height: 60, width: 60, image: "default_user")),
            ),
            Expanded(
                child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Consumer<UserProfileProvider>(
                  builder: (context, userProfileProvide, _) => Text(
                      Constant.session.isUserLoggedIn()
                          ? userProfileProvide.getUserDetailBySessionKey(
                              isBool: false, key: SessionManager.keyUserName)
                          : StringsRes.lblWelcome)),
              subtitle: Text(
                Constant.session.isUserLoggedIn()
                    ? Constant.session.getData(SessionManager.keyPhone)
                    : StringsRes.lblLogin,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .apply(color: ColorsRes.appColor),
              ),
            )),
          ]),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              decoration: DesignConfig.boxGradient(5),
              padding: EdgeInsets.all(5),
              margin: EdgeInsetsDirectional.only(end: 8, top: 8),
              child: Widgets.defaultImg(
                  image: "edit_icon",
                  iconColor: Colors.white,
                  height: 20,
                  width: 20),
            ),
          )
        ],
      ),
    ),
  );
}
