import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatelessWidget {
  final VoidCallback voidCallback;

  ConfirmButtonWidget({Key? key, required this.voidCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Constant.paddingOrMargin15,
            vertical: Constant.paddingOrMargin15),
        child: Widgets.gradientBtnWidget(context, 10,
            title: StringsRes.lblConfirmLocation, callback: voidCallback));
  }
}
