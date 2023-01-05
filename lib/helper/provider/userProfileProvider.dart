import 'package:egrocer/helper/repositories/loginApi.dart';
import 'package:egrocer/helper/repositories/updateProfileApi.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

enum ProfileState { initial, loading, loaded }

class UserProfileProvider extends ChangeNotifier {
  ProfileState profileState = ProfileState.initial;

  updateUserProfile(
      {required BuildContext context,
      required String selectedImagePath,
      required Map<String, String> params}) async {
    profileState = ProfileState.loading;
    notifyListeners();

    List<String> fileParamsNames = [];
    List<String> fileParamsFilesPath = [];
    if (selectedImagePath.isNotEmpty) {
      fileParamsNames.add(ApiAndParams.profile);
      fileParamsFilesPath.add(selectedImagePath);
    }

    await getUpdateProfileApi(
            apiName: ApiAndParams.apiUpdateProfile,
            params: params,
            fileParamsNames: fileParamsNames,
            fileParamsFilesPath: fileParamsFilesPath,
            context: context)
        .then((value) {
      if (value.isNotEmpty) {
        if (value[ApiAndParams.status] == 1) {
          loginApi(context);
        } else {
          profileState = ProfileState.loaded;
          notifyListeners();
        }
      }
    });
  }

  loginApi(BuildContext context) async {
    Map<String, dynamic> params = {
      ApiAndParams.mobile: Constant.session.getData(SessionManager.keyPhone),
      ApiAndParams.authUid: Constant.session.getData(SessionManager.keyAuthUid),
      // In live this will use
      // ApiAndParams.authUid: "123456" // Temp used for testing
    };

    await getLoginApi(context: context, params: params).then((mainData) async {
      if (mainData[ApiAndParams.status] == 1) {
        setUserDataInSession(mainData);
      } else {
        profileState = ProfileState.loaded;
        notifyListeners();
        GeneralMethods.showSnackBarMsg(context, mainData[ApiAndParams.message],
            snackBarSecond: 2);
      }
    });
  }

  setUserDataInSession(Map<String, dynamic> mainData) async {
    Map<String, dynamic> data =
        await mainData[ApiAndParams.data] as Map<String, dynamic>;

    Map<String, dynamic> userData =
        await data[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session.setUserData(
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
    );

    profileState = ProfileState.loaded;
    notifyListeners();
  }

  updateUserDataInSession(Map<String, dynamic> mainData) async {
    Map<String, dynamic> userData =
        await mainData[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setUserData(
      /*firebaseUid: Constant.session.getData(SessionManager.keyFirebaseId),*/
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile],
      lblReferralCode: userData[ApiAndParams.lblReferralCode],
      status: userData[ApiAndParams.status],
      token: Constant.session.getData(SessionManager
          .keyToken), /*balance: Constant.session.getData(SessionManager.keyBalance)*/
    );

    profileState = ProfileState.loaded;
    notifyListeners();
  }

  getUserDetailBySessionKey({required bool isBool, required String key}) {
    return isBool == true
        ? Constant.session.getBoolData(key)
        : Constant.session.getData(key);
  }
}
