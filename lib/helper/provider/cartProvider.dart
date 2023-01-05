import 'package:egrocer/helper/repositories/cartApi.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/cartData.dart';
import 'package:flutter/material.dart';

enum CartState {
  initial,
  loading,
  loaded,
  error,
}

class CartProvider extends ChangeNotifier {
  CartState cartState = CartState.initial;
  String message = '';
  late CartData cartData;
  late double subTotal = 0.0;
  bool isOneOrMoreItemsOutOfStock = false;

  Future<void> getCartListProvider({required BuildContext context}) async {
    cartState = CartState.loading;
    notifyListeners();

    try {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      Map<String, dynamic> getData =
          await getCartListApi(context: context, params: params);

      if (getData[ApiAndParams.status] == 1) {
        cartData = CartData.fromJson(getData);
        subTotal = cartData.data.subTotal;
        await checkCartItemsStockStatus();
        cartState = CartState.loaded;
        notifyListeners();
      } else {
        cartState = CartState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      cartState = CartState.error;
      notifyListeners();
    }
  }

  Future setSubTotal(double newSubtotal) async {
    subTotal = newSubtotal;
    notifyListeners();
  }

  Future removeItemFromCartList(
      {required int productId, required int variantId}) async {
    for (int i = 0; i < cartData.data.cart.length; i++) {
      Cart cartItem = cartData.data.cart[i];
      if (cartItem.productId == productId &&
          cartItem.productVariantId == variantId) {
        cartData.data.cart.remove(cartItem);
        notifyListeners();
      }
    }
  }

  Future checkCartItemsStockStatus() async {
    isOneOrMoreItemsOutOfStock = false;
    for (int i = 0; i < cartData.data.cart.length; i++) {
      if (cartData.data.cart[i].status == 0) {
        isOneOrMoreItemsOutOfStock = true;
      }
    }
  }
}
