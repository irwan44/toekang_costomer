import 'dart:async';

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/cityByLatLongProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/mapDeliveredMarker.dart';
import 'package:egrocer/helper/utils/markergenerator.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/geoAddress.dart';
import 'package:egrocer/screens/confirmLocationScreen/widget/confirmButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ConfirmLocation extends StatefulWidget {
  final GeoAddress address;
  final String from;

  ConfirmLocation({Key? key, required this.address, required this.from})
      : super(key: key);

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;

  List<Marker> customMarkers = [];

  @override
  void initState() {
    super.initState();
    kMapCenter = LatLng(widget.address.lattitud!, widget.address.longitude!);
    setMarkerIcon();
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    setMarkerIcon();
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: 14.4746,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  }

  setMarkerIcon() async {
    MarkerGenerator(MapDeliveredMarker(), (bitmaps) {
      setState(() {
        bitmaps.asMap().forEach((i, bmp) {
          customMarkers.add(Marker(
            markerId: MarkerId("$i"),
            position: kMapCenter,
            icon: BitmapDescriptor.fromBytes(bmp),
          ));
        });
      });
    }).generate(context);

    Constant.cityAddressMap =
        await GeneralMethods.getCityNameAndAddress(kMapCenter, context);

    if (widget.from == "location") {
      Map<String, dynamic> params = {};
      params[ApiAndParams.cityName] = Constant.cityAddressMap["city"];

      params[ApiAndParams.longitude] = kMapCenter.longitude.toString();
      params[ApiAndParams.latitude] = kMapCenter.latitude.toString();

      await context
          .read<CityByLatLongProvider>()
          .getCityByLatLongApiProvider(context: context, params: params);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              StringsRes.lblConfirmLocation,
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: WillPopScope(
          onWillPop: () async {
            return Future.delayed(Duration(milliseconds: 500))
                .then((value) => true);
          },
          child: Column(children: [
            Expanded(
              child: mapWidget(),
            ),
            confirmBtnWidget(),
          ]),
        ));
  }

  mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onTap: (argument) async {
        updateMap(argument.latitude, argument.longitude);
      },
      onMapCreated: _onMapCreated,
      markers: customMarkers.toSet(),

      // markers: markers,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
    if (Constant.session.getBoolData(SessionManager.isDarkTheme)) {
      controllerParam.setMapStyle(
          await rootBundle.loadString('assets/mapTheme/nightMode.json'));
    }
  }

  confirmBtnWidget() {
    return Card(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringsRes.lblSelectYourLocation,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  IconButton(
                      onPressed: () {
                        GeneralMethods.determinePosition().then((value) {
                          updateMap(value.latitude, value.longitude);
                        });
                      },
                      icon: Icon(
                        Icons.my_location_rounded,
                        color: ColorsRes.appColor,
                      ))
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
            ),
            ListTile(
              leading: Padding(
                  padding: EdgeInsets.all(8),
                  child: Widgets.defaultImg(
                      image: "address_icon", iconColor: ColorsRes.appColor)),
              title: (widget.from == "location" &&
                      !context.read<CityByLatLongProvider>().isDeliverable)
                  ? Text(StringsRes.lblDoesNotDeliveryLongMessage,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(color: ColorsRes.appColorRed))
                  : SizedBox.shrink(),
              subtitle: Text(Constant.cityAddressMap["address"] ?? ""),
              trailing: GestureDetector(
                onTap: (() async {
                  Navigator.of(context).pop();
                  await context
                      .read<CartListProvider>()
                      .getAllCartItems(context: context);
                }),
                child: Container(
                    child: Text(
                      StringsRes.lblChange,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .apply(color: ColorsRes.appColor),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin8,
                        vertical: Constant.paddingOrMargin5),
                    decoration: DesignConfig.boxDecoration(
                        ColorsRes.appColorLightHalfTransparent, 5,
                        isboarder: true, bordercolor: ColorsRes.appColor)),
              ),
            ),
            ConfirmButtonWidget(voidCallback: () {
              if (widget.from == "location") {
                context
                    .read<CartListProvider>()
                    .getAllCartItems(context: context);
                Constant.session.setData(SessionManager.keyAddress,
                    Constant.cityAddressMap["address"], true);

                Navigator.of(context).pushNamedAndRemoveUntil(
                    mainHomeScreen, (Route<dynamic> route) => false);
              } else {
                Future.delayed(Duration(milliseconds: 500)).then((value) {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                });
              }
            })
          ],
        ));
  }
}
