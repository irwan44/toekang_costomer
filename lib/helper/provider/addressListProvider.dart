import 'package:egrocer/helper/repositories/addressApi.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/address.dart';
import 'package:flutter/material.dart';

enum AddressState {
  initial,
  loading,
  loaded,
  loadingMore,
  editing,
  error,
}

class AddressProvider extends ChangeNotifier {
  AddressState addressState = AddressState.initial;
  String message = '';
  List<AddressData> addresses = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedAddressId = 0;

  getAddressProvider({required BuildContext context}) async {
    if (offset == 0) {
      addressState = AddressState.loading;
    } else {
      addressState = AddressState.loadingMore;
    }
    notifyListeners();

    try {
      Map<String, String> params = {};

      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getAddressApi(context: context, params: params));

      if (getData[ApiAndParams.status] == 1) {
        totalData = getData[ApiAndParams.total];
        List<AddressData> tempAddresses = (getData['data'] as List)
            .map((e) => AddressData.fromJson(Map.from(e)))
            .toList();

        if (offset == 0) {
          selectedAddressId = tempAddresses[0].id;
        }

        addresses.addAll(tempAddresses);

        hasMoreData = totalData > addresses.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }
        addressState = AddressState.loaded;
        notifyListeners();
      } else {
        addressState = AddressState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      addressState = AddressState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  setSelectedAddress(int addressId) {
    selectedAddressId = addressId;
    notifyListeners();
  }

  void deleteAddress(
      {required BuildContext context, required AddressData address}) async {
    addressState = AddressState.editing;
    notifyListeners();

    try {
      Map<String, String> params = {ApiAndParams.id: address.id.toString()};

      Map<String, dynamic> getData =
          (await deleteAddressApi(context: context, params: params));

      if (getData[ApiAndParams.status] == 1) {
        addresses.remove(address);
        addressState = AddressState.loaded;
        notifyListeners();
      } else {
        addressState = AddressState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      addressState = AddressState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  void addOrUpdateAddress(
      {required BuildContext context,
      var address,
      required Map<String, String> params,
      required Function function}) async {
    addressState = AddressState.editing;
    notifyListeners();

    try {
      Map<String, dynamic> getData = {};

      if (params.containsKey(ApiAndParams.id)) {
        getData = (await updateAddressApi(context: context, params: params));
      } else {
        getData = (await addAddressApi(context: context, params: params));
      }
      late AddressData tempAddress;
      if (getData[ApiAndParams.status] == 1) {
        tempAddress = AddressData.fromJson(getData[ApiAndParams.data]);
        if (params.containsKey(ApiAndParams.id)) {
          addresses.remove(address);
        }

        addresses.add(tempAddress);

        if (tempAddress.isDefault == 1) {
          selectedAddressId = tempAddress.id;
        }

        addressState = AddressState.loaded;
        notifyListeners();

        function();
      } else {
        addressState = AddressState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      addressState = AddressState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }
}
