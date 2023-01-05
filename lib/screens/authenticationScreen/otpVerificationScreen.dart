import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/repositories/loginApi.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otpVerificationId;
  final String phoneNumber;
  final FirebaseAuth firebaseAuth;
  final CountryCode selectedCountryCode;

  OtpVerificationScreen(
      {Key? key,
      required this.otpVerificationId,
      required this.phoneNumber,
      required this.firebaseAuth,
      required this.selectedCountryCode})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<OtpVerificationScreen> {
  String editOtp = "";
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  int otpLength = 6;
  int otpResendTime = Constant.otpResendSecond + 1;
  Timer? _timer;
  bool isLoading = false;
  String resendOtpVerificationId = "";
  OtpFieldController otpFieldController = OtpFieldController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        otpFieldController.set(['1', '2', '3', '4', '5', '6']);
      }
    });
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
              shape: DesignConfig.setRoundedBorder(10),
              margin: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin5,
                  vertical: Constant.paddingOrMargin5),
              child: otpWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  otpWidgets() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constant.paddingOrMargin30,
            horizontal: Constant.paddingOrMargin30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          headerWidget(StringsRes.lblEnterVerificationCode,
              StringsRes.lblOtpSendMessage),
          Text(
            "${widget.selectedCountryCode}-${widget.phoneNumber}",
          ),
          const SizedBox(height: 30),
          otpPinWidget(),
          const SizedBox(height: 30),
          proceedBtn(),
          const SizedBox(height: 30),
          resendOtpWidget(),
        ]),
      ),
    );
  }

  resendOtpWidget() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .merge(const TextStyle(fontWeight: FontWeight.w400)),
          text: "${StringsRes.lblDidNotGetCode}\t",
          children: <TextSpan>[
            TextSpan(
                text: _timer != null && _timer!.isActive
                    ? otpResendTime.toString()
                    : StringsRes.lblResendOtp,
                style: TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (_timer == null || !_timer!.isActive) {
                      firebaseLoginProcess();
                      startResendTimer();
                    }
                  }),
          ],
        ),
      ),
    );
  }

  proceedBtn() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Widgets.gradientBtnWidget(context, 10,
            title: StringsRes.lblVerifyAndProceed, callback: () {
            verifyOtp();
          });
  }

  headerWidget(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: ColorsRes.grey),
      ),
    );
  }

  verifyOtp() async {
    String msg = await checkOtpValidation();

    if (msg != "") {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: resendOtpVerificationId.isNotEmpty
                ? resendOtpVerificationId
                : widget.otpVerificationId,
            smsCode: editOtp);

        widget.firebaseAuth.signInWithCredential(credential).then((value) {
          User? user = value.user!;
          backendApiProcess(user);
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });

          msg = e.toString();
          if (msg.contains("]")) {
            msg = msg.split("]").last;
          }
        });
      });
    }

    if (msg.isNotEmpty) {
      GeneralMethods.showSnackBarMsg(context, msg, snackBarSecond: 2);
    }
  }

  backendApiProcess(User user) async {
    Map<String, dynamic> params = {
      ApiAndParams.mobile: widget.phoneNumber,
      // ApiAndParams.authUid: "123456", // Temp used for testing
      ApiAndParams.authUid: user.uid,
      // In live this will use
      ApiAndParams.countryCode:
          widget.selectedCountryCode.dialCode?.replaceAll("+", ""),
      // In live this will use
      ApiAndParams.fcmToken:
          Constant.session.getData(SessionManager.keyFCMToken)
    };

    await getLoginApi(context: context, params: params).then((mainData) async {
      if (mainData[ApiAndParams.status] == 1) {
        setUserDataInSession(user, mainData);
      } else {
        GeneralMethods.showSnackBarMsg(context, mainData[ApiAndParams.message],
            snackBarSecond: 2);
      }
    });
  }

  setUserDataInSession(User firebaseUser, Map<String, dynamic> mainData) async {
    Map<String, dynamic> data =
        await mainData[ApiAndParams.data] as Map<String, dynamic>;

    Map<String, dynamic> userData =
        await data[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session
        .setData(SessionManager.keyAuthUid, firebaseUser.uid, false);

    Constant.session
        .setUserData(
          /*firebaseUid: Constant.session.getData(SessionManager.keyFirebaseId),*/
          name: userData[ApiAndParams.name],
          email: userData[ApiAndParams.email],
          profile: userData[ApiAndParams.profile].toString(),
          countryCode: userData[ApiAndParams.countryCode],
          mobile: userData[ApiAndParams.mobile],
          lblReferralCode: userData[ApiAndParams.lblReferralCode],
          status: userData[ApiAndParams.status],
          token: data[ApiAndParams
              .accessToken], /*balance: userData[ApiAndParams.balance].toString()*/
        )
        .then((value) async => await getRedirection());
  }

  getRedirection() async {
    if (Constant.session.getIntData(SessionManager.keyUserStatus) == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          editProfileScreen, (Route<dynamic> route) => false,
          arguments: "register");
    } else {
      if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
          Constant.session.getBoolData(SessionManager.isUserLogin)) {
        if (Constant.session.getData(SessionManager.keyLatitude) == "" &&
            Constant.session.getData(SessionManager.keyLongitude) == "") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              getLocationScreen, (Route<dynamic> route) => false,
              arguments: "location");
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              mainHomeScreen, (Route<dynamic> route) => false);
        }
      }
    }
  }

  Widget otpPinWidget() {
    return OTPTextField(
      length: otpLength,
      controller: otpFieldController,
      fieldWidth: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceEvenly,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 10,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      otpFieldStyle: OtpFieldStyle(
          borderColor: ColorsRes.appColor,
          enabledBorderColor: ColorsRes.appColor),
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: ColorsRes.appColor,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) => () {},
      onCompleted: (value) {
        editOtp = value;
      },
    );
  }

  checkOtpValidation() async {
    bool checkInternet = await GeneralMethods.checkInternet();
    String? msg;

    if (checkInternet) {
      if (editOtp.length < otpLength) {
        msg = StringsRes.lblEnterOtp;
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        return "";
      }
    } else {
      msg = StringsRes.lblCheckInternet;
    }

    if (msg != "") {
      GeneralMethods.showSnackBarMsg(context, msg, snackBarSecond: 2);
    }
  }

  firebaseLoginProcess() async {
    if (widget.phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber:
            '${widget.selectedCountryCode.dialCode} - ${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          GeneralMethods.showSnackBarMsg(context, e.message!);
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            isLoading = false;
            setState(() {
              resendOtpVerificationId = verificationId;
            });
          }
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

  void startResendTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (otpResendTime == 0) {
            timer.cancel();
            Constant.otpResendSecond + 1;
          } else {
            otpResendTime--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
