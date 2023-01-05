import 'package:egrocer/helper/generalWidgets/orderTrackingHistoryBottomsheet.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';

class TrackMyOrderButton extends StatelessWidget {
  final double width;
  final List<List<dynamic>> status;

  TrackMyOrderButton({Key? key, required this.status, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            context: context,
            builder: (context) => OrderTrackingHistoryBottomsheet(
                  listOfStatus: status,
                ));
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          StringsRes.lblTrackMyOrder,
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }
}
