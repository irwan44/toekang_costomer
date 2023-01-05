import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:flutter/material.dart';

profileMenuWidget({required var profileMenus}) {
  return ListView.separated(
      padding: EdgeInsetsDirectional.only(end: 5, start: 10),
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
      itemCount: profileMenus.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            profileMenus[index]['clickFunction'](context);
          },
          contentPadding: EdgeInsets.zero,
          leading: Container(
              decoration: DesignConfig.boxDecoration(
                  ColorsRes.appColorLightHalfTransparent, 5),
              padding: EdgeInsets.all(5),
              child: Widgets.defaultImg(
                  image: profileMenus[index]['icon'],
                  iconColor: ColorsRes.appColor,
                  height: 20,
                  width: 20)),
          title: Text(
            profileMenus[index]['label'],
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(TextStyle(letterSpacing: 0.5)),
          ),
          trailing: Icon(Icons.navigate_next),
        );
      });
}
