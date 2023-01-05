import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/addressListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/editBoxWidget.dart';

class AddressDetailScreen extends StatefulWidget {
  final AddressData? address;
  final BuildContext addressProviderContext;

  AddressDetailScreen({
    Key? key,
    this.address,
    required this.addressProviderContext,
  }) : super(key: key);

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController edtName = TextEditingController();
  final TextEditingController edtMobile = TextEditingController();
  final TextEditingController edtAltMobile = TextEditingController();
  final TextEditingController edtAddress = TextEditingController();
  final TextEditingController edtLandmark = TextEditingController();
  final TextEditingController edtCity = TextEditingController();
  final TextEditingController edtArea = TextEditingController();
  final TextEditingController edtZipcode = TextEditingController();
  final TextEditingController edtCountry = TextEditingController();
  final TextEditingController edtState = TextEditingController();
  bool isLoading = false;
  bool isDefaultAddress = false;
  String selectedType = Constant.addressTypes.keys.first;
  String longitude = "";
  String latitude = "";

  @override
  void initState() {
    super.initState();

    edtName.text = widget.address?.name ?? "";
    edtAltMobile.text = widget.address?.alternateMobile ?? "";
    edtMobile.text = widget.address?.mobile ?? "";
    edtAddress.text = widget.address?.address ?? "";
    edtLandmark.text = widget.address?.landmark ?? "";
    edtCity.text = widget.address?.city ?? "";
    edtArea.text = widget.address?.area ?? "";
    edtZipcode.text = widget.address?.pincode ?? "";
    edtCountry.text = widget.address?.country ?? "";
    edtState.text = widget.address?.state ?? "";
    selectedType = widget.address?.type.toLowerCase() ?? "home";
    longitude = widget.address?.longitude ?? "";
    latitude = widget.address?.latitude ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              StringsRes.lblAddressDetail,
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: Stack(
          children: [
            ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.paddingOrMargin10,
                    vertical: Constant.paddingOrMargin10),
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          contactWidget(),
                          addressDetailWidget(),
                        ],
                      )),
                  addressTypeWidget()
                ]),
            isLoading == true
                ? PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: Container(
                        color: ColorsRes.appColorBlack.withOpacity(0.2),
                        child: Center(child: CircularProgressIndicator())),
                  )
                : SizedBox.shrink()
          ],
        ));
  }

  contactWidget() {
    return Card(
        shape: DesignConfig.setRoundedBorder(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              StringsRes.lblContactDetails,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
            Divider(
              height: 15,
            ),
            editBoxWidget(
                context,
                edtName,
                GeneralMethods.emptyValidation,
                StringsRes.lblName,
                StringsRes.lblEnterName,
                TextInputType.text),
            SizedBox(height: 10),
            editBoxWidget(
              context,
              edtMobile,
              GeneralMethods.phoneValidation,
              StringsRes.lblMobileNumber,
              StringsRes.lblEnterValidMobile,
              TextInputType.phone,
            ),
            SizedBox(height: 10),
            editBoxWidget(
                context,
                edtAltMobile,
                GeneralMethods.phoneValidation,
                StringsRes.lblAltMobileNo,
                StringsRes.lblEnterValidMobile,
                TextInputType.phone),
          ]),
        ));
  }

  addressDetailWidget() {
    return Card(
        shape: DesignConfig.setRoundedBorder(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              StringsRes.lblAddressDetails,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
            Divider(
              height: 15,
            ),
            editBoxWidget(
                context,
                edtAddress,
                GeneralMethods.emptyValidation,
                StringsRes.lblAddress,
                StringsRes.lblEnterAddress,
                TextInputType.text,
                tailIcon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, getLocationScreen,
                            arguments: "address")
                        .then((value) {
                      setState(() {
                        edtAddress.text = Constant.cityAddressMap["address"];
                        edtCity.text = Constant.cityAddressMap["city"];
                        edtArea.text = Constant.cityAddressMap["area"];
                        edtLandmark.text = Constant.cityAddressMap["landmark"];
                        edtZipcode.text = Constant.cityAddressMap["pin_code"];
                        edtCountry.text = Constant.cityAddressMap["country"];
                        edtState.text = Constant.cityAddressMap["state"];
                        longitude =
                            Constant.cityAddressMap["longitude"].toString();
                        latitude =
                            Constant.cityAddressMap["latitude"].toString();
                        formKey.currentState?.validate();
                      });
                    });
                  },
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: ColorsRes.appColor,
                  ),
                )),
            SizedBox(height: 10),
            editBoxWidget(
                context,
                edtLandmark,
                GeneralMethods.emptyValidation,
                StringsRes.lblLandmark,
                StringsRes.lblEnterLandmark,
                TextInputType.text),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, getLocationScreen,
                        arguments: "address")
                    .then((value) {
                  setState(() {
                    edtAddress.text = Constant.cityAddressMap["address"];
                    edtCity.text = Constant.cityAddressMap["city"];
                    edtArea.text = Constant.cityAddressMap["area"];
                    edtLandmark.text = Constant.cityAddressMap["landmark"];
                    edtZipcode.text = Constant.cityAddressMap["pin_code"];
                    edtCountry.text = Constant.cityAddressMap["country"];
                    edtState.text = Constant.cityAddressMap["state"];
                    longitude = Constant.cityAddressMap["longitude"].toString();
                    latitude = Constant.cityAddressMap["latitude"].toString();
                    formKey.currentState?.validate();
                  });
                });
              },
              child: editBoxWidget(
                  context,
                  edtCity,
                  GeneralMethods.emptyValidation,
                  StringsRes.lblCity,
                  StringsRes.lblPleaseSelectAddressFromMap,
                  TextInputType.text,
                  isEditable: false),
            ),
            SizedBox(height: 10),
            editBoxWidget(
              context,
              edtArea,
              GeneralMethods.emptyValidation,
              StringsRes.lblArea,
              StringsRes.lblEnterArea,
              TextInputType.text,
            ),
            SizedBox(height: 10),
            editBoxWidget(
              context,
              edtZipcode,
              GeneralMethods.emptyValidation,
              StringsRes.lblPinCode,
              StringsRes.lblEnterPinCode,
              TextInputType.text,
            ),
            SizedBox(height: 10),
            editBoxWidget(
              context,
              edtState,
              GeneralMethods.emptyValidation,
              StringsRes.lblState,
              StringsRes.lblEnterState,
              TextInputType.text,
            ),
            SizedBox(height: 10),
            editBoxWidget(
              context,
              edtCountry,
              GeneralMethods.emptyValidation,
              StringsRes.lblCountry,
              StringsRes.lblEnterCountry,
              TextInputType.text,
            ),
          ]),
        ));
  }

  addressTypeWidget() {
    return Card(
        shape: DesignConfig.setRoundedBorder(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              StringsRes.lblAddressType,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
            Divider(
              height: 15,
            ),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(Constant.addressTypes.length, (index) {
                  String key = Constant.addressTypes.keys.elementAt(index);
                  String value = Constant.addressTypes[key];
                  return GestureDetector(
                    onTap: () {
                      if (selectedType != key) {
                        setState(() {
                          selectedType = key;
                        });
                      }
                    },
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: selectedType == key
                          ? ColorsRes.appColor
                          : ColorsRes.grey.withOpacity(0.3),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constant.paddingOrMargin25,
                            vertical: Constant.paddingOrMargin10),
                        child: Text(
                          value,
                          style: TextStyle(
                              color: selectedType == key
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  );
                })),
            SizedBox(height: 10),
            CheckboxListTile(
                value: isDefaultAddress,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: ColorsRes.appColor,
                title: Text(StringsRes.lblSetAsDefaultAddress),
                onChanged: (bool? isChecked) {
                  setState(() {
                    isDefaultAddress = isChecked!;
                  });
                }),
            SizedBox(height: 10),
            Widgets.gradientBtnWidget(context, 8,
                title: (widget.address?.id.toString() ?? "").isNotEmpty
                    ? StringsRes.lblUpdateAddress
                    : StringsRes.lblAddNewAddress, callback: () async {
              if (formKey.currentState!.validate() == true) {
                if (longitude.isNotEmpty && latitude.isNotEmpty) {
                  Map<String, String> params = {};

                  String id = widget.address?.id.toString() ?? "";
                  if (id.isNotEmpty) {
                    params[ApiAndParams.id] = id;
                  }

                  params[ApiAndParams.name] = edtName.text.trim().toString();
                  params[ApiAndParams.mobile] =
                      edtMobile.text.trim().toString();
                  params[ApiAndParams.type] = selectedType;
                  params[ApiAndParams.address] =
                      edtAddress.text.trim().toString();
                  params[ApiAndParams.landmark] =
                      edtLandmark.text.trim().toString();
                  params[ApiAndParams.area] = edtArea.text.trim().toString();
                  params[ApiAndParams.pinCode] =
                      edtZipcode.text.trim().toString();
                  params[ApiAndParams.city] = edtCity.text.trim().toString();
                  params[ApiAndParams.state] = edtState.text.trim().toString();
                  params[ApiAndParams.country] =
                      edtCountry.text.trim().toString();
                  params[ApiAndParams.alternateMobile] =
                      edtAltMobile.text.trim().toString();
                  params[ApiAndParams.latitude] = latitude;
                  params[ApiAndParams.longitude] = longitude;
                  params[ApiAndParams.isDefault] =
                      isDefaultAddress == true ? "1" : "0";

                  widget.addressProviderContext
                      .read<AddressProvider>()
                      .addOrUpdateAddress(
                          context: context,
                          address: widget.address ?? "",
                          params: params,
                          function: () {
                            Navigator.pop(context);
                          });
                  setState(() {
                    isLoading = !isLoading;
                  });
                } else {
                  setState(() {
                    isLoading = !isLoading;
                  });
                  GeneralMethods.showSnackBarMsg(
                      context, StringsRes.lblPleaseSelectAddressFromMap);
                }
              }
            }),
            SizedBox(height: 10),
          ]),
        ));
  }
}
