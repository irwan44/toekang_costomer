import 'package:egrocer/helper/repositories/promoCodeApi.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/promoCode.dart';
import 'package:flutter/material.dart';

enum PromoCodeState {
  initial,
  loading,
  loaded,
  error,
}

class PromoCodeProvider extends ChangeNotifier {
  PromoCodeState promoCodeState = PromoCodeState.initial;
  String message = '';
  late PromoCode promoCode;

  getPromoCodeProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    promoCodeState = PromoCodeState.loading;

    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getPromoCodeApi(context: context, params: params));

      promoCode = PromoCode.fromJson(getData);

      promoCodeState = PromoCodeState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      promoCodeState = PromoCodeState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  applyPromoCode(PromoCodeData promoCode) {
    Constant.isPromoCodeApplied = true;
    Constant.selectedCoupon = promoCode.promoCode;
    Constant.discountedAmount = promoCode.discountedAmount;
    Constant.discount = promoCode.discount;
    notifyListeners();
  }
}
