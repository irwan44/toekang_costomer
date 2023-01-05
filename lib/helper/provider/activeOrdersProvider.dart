import 'package:egrocer/helper/repositories/ordersApi.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/order.dart';
import 'package:flutter/material.dart';

enum ActiveOrdersState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class ActiveOrdersProvider extends ChangeNotifier {
  ActiveOrdersState activeOrdersState = ActiveOrdersState.initial;
  String message = '';
  List<Order> orders = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  void updateOrder(Order order) {
    final orderIndex = orders.indexWhere((element) => element.id == order.id);
    if (orderIndex != -1) {
      orders[orderIndex] = order;
      notifyListeners();
    }
  }

  getOrders({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      activeOrdersState = ActiveOrdersState.loading;
    } else {
      activeOrdersState = ActiveOrdersState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await fetchOrders(context: context, params: params));

      if (getData[ApiAndParams.status] == 1) {
        totalData = getData[ApiAndParams.total];
        List<Order> tempOrders = (getData['data'] as List)
            .map((e) => Order.fromJson(Map.from(e ?? {})))
            .toList();

        orders.addAll(tempOrders);
      }

      hasMoreData = totalData > orders.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      activeOrdersState = ActiveOrdersState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      activeOrdersState = ActiveOrdersState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  void getMoreOrders({required BuildContext context}) async {
    if (activeOrdersState == ActiveOrdersState.loadingMore) {
      return;
    }
    activeOrdersState = ActiveOrdersState.loadingMore;
    notifyListeners();

    try {
      Map<String, dynamic> moreOrders =
          (await fetchOrders(context: context, params: {
        ApiAndParams.limit: Constant.defaultDataLoadLimitAtOnce.toString(),
        ApiAndParams.offset: offset.toString(),
      }));

      if (moreOrders[ApiAndParams.status] == 1) {
        totalData = moreOrders[ApiAndParams.total];

        List<Order> tempOrders = (moreOrders['data'] as List)
            .map((e) => Order.fromJson(Map.from(e ?? {})))
            .toList();

        orders.addAll(tempOrders);

        hasMoreData = totalData > orders.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }
        activeOrdersState = ActiveOrdersState.loaded;

        notifyListeners();
      }
    } catch (e) {
      activeOrdersState = ActiveOrdersState.loaded;
      notifyListeners();
    }
  }
}
