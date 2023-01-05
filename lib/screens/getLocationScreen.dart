import 'dart:async';
import 'dart:convert';

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/geoAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class GetLocation extends StatefulWidget {
  final String from;

  GetLocation({Key? key, required this.from}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final TextEditingController edtAddress = TextEditingController();
  late GeoAddress selectedAddress;

  List<GeoAddress> recentAddressList = [];
  List addressPlaceIdList = [];
  final recentAddressController = StreamController<GeoAddress>.broadcast();
  bool visibleRecentWidget = false;

  @override
  void initState() {
    super.initState();
    recentAddressData();
  }

  recentAddressData() {
    String recentadr =
        Constant.session.getData(SessionManager.keyRecentAddressSearch);
    if (recentadr.trim().isNotEmpty) {
      var addressJson = jsonDecode(recentadr)["address"] as List;

      recentAddressList.addAll(addressJson.map((e) {
        GeoAddress address = GeoAddress.fromJson(e);
        addressPlaceIdList.add(address.placeId);
        return address;
      }).toList());
      visibleRecentWidget = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblSelectLocation,
            softWrap: true,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
          )),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          children: [
            lblSelectLocation(),
            if (visibleRecentWidget) recentAddressWidget(),
          ]),
    );
  }

  recentAddressWidget() {
    return Card(
        shape: DesignConfig.setRoundedBorder(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin12),
            child: Text(
              StringsRes.lblRecentSearches,
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1,
          ),
          recentAdrListWidget()
        ]));
  }

  lblSelectLocation() {
    return Card(
      shape: DesignConfig.setRoundedBorder(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin12),
          child: Text(
            StringsRes.lblSelectDeliveryLocation,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: 1,
        ),
        TextButton.icon(
          onPressed: () async {
            await GeneralMethods.determinePosition().then((value) {
              GeoAddress getAddress = GeoAddress(
                  lattitud: value.latitude, longitude: value.longitude);

              Navigator.pushNamed(context, confirmLocationScreen,
                  arguments: [getAddress, widget.from]);
            });
          },
          icon: Icon(
            Icons.my_location_rounded,
            color: ColorsRes.appColor,
          ),
          label: Text(
            StringsRes.lblUseMyCurrentLocation,
            softWrap: true,
            style: TextStyle(color: ColorsRes.appColor, letterSpacing: 0.5),
          ),
        ),
        Row(children: [
          Expanded(
              child: Divider(
            height: 1,
          )),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin5),
            child: Text(
              StringsRes.lblOr.toUpperCase(),
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, height: 0.5),
            ),
          ),
          Expanded(
              child: Divider(
            height: 1,
          )),
        ]),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin12),
            child: Widgets.textFieldWidget(
                edtAddress,
                GeneralMethods.emptyValidation,
                StringsRes.lblTypeLocationManually,
                TextInputType.text,
                StringsRes.lblTypeLocationManually,
                context,
                currfocus: AlwaysDisabledFocusNode(),
                hint: StringsRes.lblTypeLocationManually,
                floatingLbl: false,
                borderRadius: 8,
                bgcolor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: EdgeInsets.symmetric(
                    vertical: Constant.paddingOrMargin5,
                    horizontal: Constant.paddingOrMargin10),
                tapCallback: () => searchAddress)),
      ]),
    );
  }

  searchAddress() {
    try {
      Future.delayed(Duration.zero, () async {
        Prediction? p = await PlacesAutocomplete.show(
            context: context,
            apiKey: Constant.googleApiKey,
            onError: (PlacesAutocompleteResponse response) {},
            mode: Mode.overlay,
            components: [],
            types: [],
            strictbounds: false,
            logo: SizedBox(
              width: double.maxFinite,
              height: 0,
            ));

        await GeneralMethods.displayPrediction(p, context)
            .then((value) => getRedirects(value));
      });
    } catch (e) {}
  }

  getRedirects(GeoAddress? value) {
    if (value != null) {
      if (!addressPlaceIdList.contains(value.placeId)) {
        if (!visibleRecentWidget) {
          visibleRecentWidget = true;
          recentAddressList.add(value);
          setState(() {});
        }
        addressPlaceIdList.add(value.placeId);
        recentAddressController.sink.add(value);
      }
      edtAddress.text = value.address!;
      selectedAddress = value;

      Navigator.pushNamed(context, confirmLocationScreen,
          arguments: [value, widget.from]);
    }
  }

  recentAdrListWidget() {
    return StreamBuilder(
        stream: recentAddressController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            recentAddressList.insert(0, snapshot.data as GeoAddress);
          }
          return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                GeoAddress address = recentAddressList[index];
                return ListTile(
                  leading: Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Widgets.defaultImg(
                            image: "search_icon",
                            iconColor: ColorsRes.appColor)),
                  ),
                  title: Text(address.city ?? ""),
                  subtitle: Text(address.address ?? ""),
                  onTap: () {
                    Navigator.pushNamed(context, confirmLocationScreen,
                        arguments: [address, widget.from]);
                  },
                );
              }),
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              itemCount: recentAddressList.length);
        });
  }

  @override
  void dispose() {
    if (recentAddressList.isNotEmpty) {
      Map data = {"address": recentAddressList};
      Constant.session.setData(
          SessionManager.keyRecentAddressSearch, jsonEncode(data), false);
    }
    recentAddressController.close();
    super.dispose();
  }
}
