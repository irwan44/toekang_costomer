import 'package:egrocer/helper/generalWidgets/customCircularProgressIndicator.dart';
import 'package:egrocer/helper/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnOrderDialog extends StatelessWidget {
  final String orderId;

  ReturnOrderDialog({
    required this.orderId,
    Key? key,
  }) : super(key: key);

  void onReturnOrderSuccess(BuildContext context) {
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
        title: Text(StringsRes.lblSureToReturnOrder),
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
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<UpdateOrderStatusProvider>().updateStatus(
                        orderId: orderId,
                        status: Constant.orderStatusCode[7], //8 is for returned
                        callBack: () {
                          onReturnOrderSuccess(context);
                        },
                        context: context);
                  },
                  child: Text(
                    StringsRes.lblYes,
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
