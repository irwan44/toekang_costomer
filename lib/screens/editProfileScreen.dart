import 'dart:io';

import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/userProfileProvider.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String? from;

  EditProfile({Key? key, this.from}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUsername = TextEditingController();
  late TextEditingController edtEmail = TextEditingController();
  late TextEditingController edtMobile = TextEditingController();
  bool isLoading = false;
  String tempName = "";
  String tempEmail = "";
  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      tempName = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyUserName);
      tempEmail = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyEmail);

      edtUsername = TextEditingController(text: tempName);
      edtEmail = TextEditingController(text: tempEmail);
      edtMobile = TextEditingController(
          text: Constant.session.getData(SessionManager.keyPhone));
      selectedImagePath = "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            widget.from == "register"
                ? StringsRes.lblRegister
                : StringsRes.lblEditProfile,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin15),
          children: [
            imgWidget(),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.paddingOrMargin10,
                    vertical: Constant.paddingOrMargin15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  userInfoWidget(),
                  SizedBox(height: 50),
                  proceedBtn()
                ]),
              ),
            ),
          ]),
    );
  }

  proceedBtn() {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, _) {
        return userProfileProvider.profileState == ProfileState.loading
            ? Center(child: CircularProgressIndicator())
            : Widgets.gradientBtnWidget(context, 10,
                title: StringsRes.lblUpdateProfile, callback: () {
                if (tempName != edtUsername.text ||
                    tempEmail != edtEmail.text ||
                    selectedImagePath.isNotEmpty ||
                    _formKey.currentState!.validate()) {
                  Map<String, String> params = {};
                  params[ApiAndParams.name] = edtUsername.text.trim();
                  params[ApiAndParams.email] = edtEmail.text.trim();
                  userProfileProvider
                      .updateUserProfile(
                          context: context,
                          selectedImagePath: selectedImagePath,
                          params: params)
                      .then((value) {
                    if (widget.from == "register")
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          getLocationScreen, (Route<dynamic> route) => false,
                          arguments: "location");
                  });
                }
              });
      },
    );
  }

  userInfoWidget() {
    return Form(
        key: _formKey,
        child: Column(children: [
          Widgets.textFieldWidget(
              edtUsername,
              GeneralMethods.emptyValidation,
              StringsRes.lblUserName,
              TextInputType.text,
              StringsRes.lblEnterUserName,
              context,
              hint: StringsRes.lblUserName,
              floatingLbl: false,
              borderRadius: 8,
              sicon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "user_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint: BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
          SizedBox(height: 15),
          Widgets.textFieldWidget(
              edtEmail,
              GeneralMethods.emailValidation,
              StringsRes.lblEmail,
              TextInputType.emailAddress,
              StringsRes.lblEnterValidEmail,
              context,
              hint: StringsRes.lblEmail,
              floatingLbl: false,
              borderRadius: 8,
              sicon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "mail_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint: BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
          SizedBox(height: 15),
          Widgets.textFieldWidget(
              edtMobile,
              GeneralMethods.phoneValidation,
              edtMobile.text.trim().isEmpty ? StringsRes.lblMobileNumber : "",
              TextInputType.phone,
              StringsRes.lblEnterValidMobile,
              context,
              hint: StringsRes.lblMobileNumber,
              borderRadius: 8,
              floatingLbl: false,
              iseditable: false,
              sicon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "phone_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint: BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
        ]));
  }

  imgWidget() {
    return Center(
      child: Stack(children: [
        Padding(
            padding: EdgeInsetsDirectional.only(bottom: 15, end: 15),
            child: ClipRRect(
                borderRadius: Constant.borderRadius10,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: selectedImagePath.isEmpty
                    ? Widgets.setNetworkImg(
                        height: 100,
                        width: 100,
                        boxFit: BoxFit.fill,
                        image: Constant.session
                            .getData(SessionManager.keyUserImage))
                    : Image(
                        image: FileImage(File(selectedImagePath)),
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ))),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () async {
              // Single file path
              FilePicker.platform
                  .pickFiles(
                      allowMultiple: false,
                      allowCompression: true,
                      type: FileType.image,
                      lockParentWindow: true)
                  .then((value) {
                setState(() {
                  selectedImagePath = value!.paths.first.toString();
                });
              });
            },
            child: Container(
              decoration: DesignConfig.boxGradient(5),
              padding: EdgeInsets.all(5),
              margin: EdgeInsetsDirectional.only(end: 8, top: 8),
              child: Widgets.defaultImg(
                  image: "edit_icon",
                  iconColor: Colors.white,
                  height: 15,
                  width: 15),
            ),
          ),
        )
      ]),
    );
  }
}
