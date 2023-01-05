import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? heightAndWidth;

  CustomCircularProgressIndicator({Key? key, this.color, this.heightAndWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightAndWidth ?? 20,
      width: heightAndWidth ?? 20,
      child: CircularProgressIndicator(
        color: color ?? ColorsRes.appColor,
      ),
    );
  }
}
