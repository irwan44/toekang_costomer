import 'package:egrocer/helper/repositories/ordersApi.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:flutter/material.dart';

enum UpdateOrderStatus { initial, inProgress, success, failure }

class UpdateOrderStatusProvider extends ChangeNotifier {
  UpdateOrderStatus _updateOrderStatus = UpdateOrderStatus.initial;
  String errorMessage = "";

  UpdateOrderStatus getUpdateOrderStatus() {
    return _updateOrderStatus;
  }

  void updateStatus(
      {required String orderId,
      String? orderItemId,
      required String status,
      required Function callBack,
      required BuildContext context}) async {
    try {
      _updateOrderStatus = UpdateOrderStatus.inProgress;
      notifyListeners();

      Map<String, String> params = {
        "order_id": orderId,
        "order_item_id": orderItemId ?? "",
        "status": status
      };

      if (orderItemId == null) {
        params.remove("order_item_id");
      }

      final result = await updateOrderStatus(
        params: params,
        context: context,
      );

      if (result[ApiAndParams.status] == "1") {
        callBack.call();
      } else {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      _updateOrderStatus = UpdateOrderStatus.failure;
      errorMessage = e.toString();
      notifyListeners();
      Navigator.of(context).pop(false);
    }
  }
}
