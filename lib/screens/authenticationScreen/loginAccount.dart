import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginAccount extends StatefulWidget {
  const LoginAccount({Key? key}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {
  CountryCode? selectedCountryCode;
  bool isLoading = false, isAcceptedTerms = false;
  TextEditingController edtPhoneNumber =
      TextEditingController(text: "9876543210");
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  String otpVerificationId = "";
  String phoneNumber = "";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    try {
      if (Platform.isIOS)
        FirebaseMessaging.instance
            .requestPermission(alert: true, sound: true, badge: true);

      FirebaseMessaging.instance.getToken().then((token) {
        if (Constant.session.getData(SessionManager.keyFCMToken).isEmpty) {
          Constant.session.setData(SessionManager.keyFCMToken, token!, false);
        }
      });
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblLogin,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin20),
              child: Widgets.defaultImg(
                  image: "logo", iconColor: ColorsRes.appColor)),
          Expanded(
            child: Card(
              shape: DesignConfig.setRoundedBorderSpecific(10,
                  istop: true, isbtm: true),
              margin: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin5,
                  vertical: Constant.paddingOrMargin5),
              child: loginWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  proceedBtn() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Widgets.gradientBtnWidget(context, 10,
            isSetShadow: false,
            title: StringsRes.lblLogin.toUpperCase(), callback: () {
            loginWithPhoneNumber();
          });
  }

  skipLoginText() {
    return GestureDetector(
      onTap: () async {
        Constant.session.setBoolData(SessionManager.keySkipLogin, true, false);
        await getRedirection();
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          StringsRes.lblSkipLogin,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorsRes.appColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  loginWidgets() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constant.paddingOrMargin30,
            horizontal: Constant.paddingOrMargin20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              StringsRes.lblWelcome,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 30),
            ),
            subtitle: Text(
              StringsRes.lblLoginEnterNumberMessage,
              style: TextStyle(color: ColorsRes.grey),
            ),
          ),
          Widgets.getSizedBox(height: 40),
          Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: mobileNoWidget()),
          Widgets.getSizedBox(height: 15),
          Row(
            children: [
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: isAcceptedTerms,
                onChanged: (bool? val) {
                  setState(() {
                    isAcceptedTerms = val!;
                  });
                },
              ),
              //padding: const EdgeInsets.only(top: 15.0),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .merge(const TextStyle(fontWeight: FontWeight.w400)),
                    text: "${StringsRes.lblAgreementMsg1}\t",
                    children: <TextSpan>[
                      TextSpan(
                          text: StringsRes.lblTermsOfService,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, webViewScreen,
                                  arguments: "terms");
                            }),
                      TextSpan(text: "\t${StringsRes.lblAnd}\t"),
                      TextSpan(
                          text: StringsRes.lblPrivacyPolicy,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, webViewScreen,
                                  arguments: "privacy");
                            }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Widgets.getSizedBox(height: 40),
          proceedBtn(),
          Widgets.getSizedBox(height: 40),
          skipLoginText(),
        ]),
      ),
    );
  }

  mobileNoWidget() {
    return Row(
      children: [
        const SizedBox(width: 5),
        Icon(
          Icons.phone_android,
          color: ColorsRes.mainTextColor,
        ),
        IgnorePointer(
          ignoring: isLoading,
          child: CountryCodePicker(
            onInit: (countryCode) {
              selectedCountryCode = countryCode;
            },
            onChanged: (countryCode) {
              selectedCountryCode = countryCode;
            },
            initialSelection: Constant.initialCountryCode,
            textOverflow: TextOverflow.ellipsis,
            showCountryOnly: false,
            alignLeft: false,
            backgroundColor: isDark ? Colors.black : Colors.white,
            textStyle: TextStyle(color: ColorsRes.mainTextColor),
            dialogBackgroundColor: isDark ? Colors.black : Colors.white,
            padding: EdgeInsets.zero,
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: ColorsRes.grey,
          size: 15,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: TextField(
            controller: edtPhoneNumber,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              hintText: "999-999-9999",
            ),
          ),
        )
      ],
    );
  }

  getRedirection() async {
    if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
        Constant.session.getBoolData(SessionManager.isUserLogin)) {
      if (Constant.session.getData(SessionManager.keyLatitude) == "" &&
          Constant.session.getData(SessionManager.keyLongitude) == "") {
        Navigator.pushReplacementNamed(context, getLocationScreen,
            arguments: "location");
      } else if (Constant.session
          .getData(SessionManager.keyUserName)
          .isNotEmpty) {
        Navigator.pushReplacementNamed(context, mainHomeScreen);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, mainHomeScreen, (route) => false);
      }
    }
  }

  Future<String> mobileNumberValidation() async {
    String? mobileValidate = await GeneralMethods.phoneValidation(
        edtPhoneNumber.text, StringsRes.lblEnterValidMobile);
    if (mobileValidate != null) {
      return mobileValidate;
    } else if (!isAcceptedTerms) {
      return StringsRes.lblAcceptTermsAndCondition;
    } else {
      return "";
    }
  }

  loginWithPhoneNumber() async {
    bool checkInternet = await GeneralMethods.checkInternet();
    String? msg = "";
    String? mobileValidation = await mobileNumberValidation();

    if (checkInternet) {
      if (mobileValidation != "") {
        msg = mobileValidation;
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        firebaseLoginProcess();
      }
    } else {
      msg = StringsRes.lblCheckInternet;
    }

    if (msg != "") {
      GeneralMethods.showSnackBarMsg(context, msg, snackBarSecond: 2);
    }
  }

  firebaseLoginProcess() async {
    if (edtPhoneNumber.text.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber: '${selectedCountryCode!.dialCode}${edtPhoneNumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          GeneralMethods.showSnackBarMsg(context, e.message!);
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading = false;
          setState(() {
            phoneNumber =
                '${selectedCountryCode!.dialCode} - ${edtPhoneNumber.text}';
            otpVerificationId = verificationId;

            List<dynamic> firebaseArguments = [
              firebaseAuth,
              otpVerificationId,
              edtPhoneNumber.text,
              selectedCountryCode!
            ];
            Navigator.pushNamed(context, otpScreen,
                arguments: firebaseArguments);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
