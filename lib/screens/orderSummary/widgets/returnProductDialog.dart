import 'package:egrocer/helper/generalWidgets/customCircularProgressIndicator.dart';
import 'package:egrocer/helper/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnProductDialog extends StatelessWidget {
  final String orderId;
  final String orderItemId;

  ReturnProductDialog({
    required this.orderId,
    required this.orderItemId,
    Key? key,
  }) : super(key: key);

  void onReturnProductSuccess(BuildContext context) {
    //Need to pass true so we can update order item status
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<UpdateOrderStatusProvider>().getUpdateOrderStatus() ==
            UpdateOrderStatus.inProgress) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: AlertDialog(
        title: Text(
          StringsRes.lblSureToReturnProduct,
          softWrap: true,
        ),
        actions: [
          Consumer<UpdateOrderStatusProvider>(builder: (context, provider, _) {
            if (provider.getUpdateOrderStatus() ==
                UpdateOrderStatus.inProgress) {
              return Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    StringsRes.lblNo,
                    softWrap: true,
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<UpdateOrderStatusProvider>().updateStatus(
                        orderId: orderId,
                        orderItemId: orderItemId,
                        status: Constant.orderStatusCode[7],
                        //8 is for returned
                        callBack: () {
                          onReturnProductSuccess(context);
                        },
                        context: context);
                  },
                  child: Text(
                    StringsRes.lblYes,
                    softWrap: true,
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
