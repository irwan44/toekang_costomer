import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:flutter/material.dart';

class MapDeliveredMarker extends StatefulWidget {
  MapDeliveredMarker({Key? key}) : super(key: key);

  //MapMarker();

  @override
  _MapDeliveredMarkerState createState() => _MapDeliveredMarkerState();
}

class _MapDeliveredMarkerState extends State<MapDeliveredMarker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: ColorsRes.appColor,
            size: 65,
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
