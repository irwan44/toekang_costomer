import 'package:egrocer/helper/generalWidgets/trackMyOrderButton.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/order.dart';
import 'package:egrocer/screens/orderSummary/widgets/cancelProductDialog.dart';
import 'package:egrocer/screens/orderSummary/widgets/returnProductDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late List<OrderItem> _orderItems = widget.order.items;

  String getStatusCompleteDate(int currentStatus) {
    if (widget.order.status.isNotEmpty) {
      final statusValue = widget.order.status.where((element) {
        return element.first.toString() == currentStatus.toString();
      }).toList();

      if (statusValue.isNotEmpty) {
        //[2, 04-10-2022 06:13:45am] so fetching last value
        return statusValue.first.last;
      }
    }

    return "";
  }

  Widget _buildCancelItemButton(OrderItem orderItem) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: CancelProductDialog(
                      orderId: widget.order.id.toString(),
                      orderItemId: orderItem.id.toString()),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 7
          if (value != null) {
            if (value) {
              final orderItemIndex = _orderItems
                  .indexWhere((element) => element.id == orderItem.id);

              //Update order items
              if (orderItemIndex != -1) {
                _orderItems[orderItemIndex] = orderItem.updateStatus(
                    Constant.orderStatusCode[6]); //Cancelled status

                setState(() {});
              }
            } else {
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblUnableToCancelProduct);
            }
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Text(
          StringsRes.lblCancel,
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColorRed),
        ),
      ),
    );
  }

  Widget _buildReturnItemButton(OrderItem orderItem) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: ReturnProductDialog(
                      orderId: widget.order.id.toString(),
                      orderItemId: orderItem.id.toString()),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 8
          if (value != null) {
            if (value) {
              final orderItemIndex = _orderItems
                  .indexWhere((element) => element.id == orderItem.id);

              //Update order items
              if (orderItemIndex != -1) {
                _orderItems[orderItemIndex] = orderItem.updateStatus(
                    Constant.orderStatusCode[7]); //Returned status

                setState(() {});
              }
            } else {
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblUnableToReturnProduct);
            }
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Text(
          StringsRes.lblReturn,
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColorRed),
        ),
      ),
    );
  }

  Widget _buildOrderStatusContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  StringsRes.lblOrder,
                  softWrap: true,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  "#${widget.order.id}",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.order.activeStatus.isEmpty
                    ? SizedBox()
                    : Text(Constant.getOrderActiveStatusLabelFromCode(
                        widget.order.activeStatus)),
                SizedBox(
                  height: 5,
                ),
                widget.order.activeStatus.isEmpty
                    ? SizedBox()
                    : Text(
                        getStatusCompleteDate(
                            int.parse(widget.order.activeStatus)),
                        style: TextStyle(
                            color: ColorsRes.subTitleTextColor, fontSize: 12.5),
                      ),
              ],
            ),
          ),
          Divider(),
          Center(
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return TrackMyOrderButton(
                  status: widget.order.status,
                  width: boxConstraints.maxWidth * (0.5));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildOrderItemContainer(OrderItem orderItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: Constant.borderRadius10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Widgets.setNetworkImg(
                      boxFit: BoxFit.fill,
                      image: orderItem.imageUrl,
                      width: boxConstraints.maxWidth * (0.25),
                      height: boxConstraints.maxWidth * (0.25),
                    )),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderItem.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "x ${orderItem.quantity}",
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${orderItem.measurement} ${orderItem.unit}",
                      style: TextStyle(color: ColorsRes.subTitleTextColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      GeneralMethods.getCurrencyFormat(
                          double.parse(orderItem.price.toString())),
                      style: TextStyle(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500),
                    ),
                    orderItem.cancelStatus == Constant.orderStatusCode[2]
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              _buildCancelItemButton(orderItem),
                            ],
                          )
                        : SizedBox(),
                    orderItem.returnStatus == Constant.orderStatusCode[2]
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              _buildReturnItemButton(orderItem),
                            ],
                          )
                        : SizedBox(),
                    (orderItem.activeStatus == Constant.orderStatusCode[6] ||
                            orderItem.activeStatus ==
                                Constant.orderStatusCode[7])
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                Constant.getOrderActiveStatusLabelFromCode(
                                    orderItem.activeStatus),
                                style: TextStyle(color: ColorsRes.appColorRed),
                              )
                            ],
                          )
                        : SizedBox(),
                  ],
                )),
              ],
            ),
            Divider(),
          ],
        );
      }),
    );
  }

  Widget _buildOrderItemsDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              StringsRes.lblItems,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: widget.order.items
                  .map((orderItem) => _buildOrderItemContainer(orderItem))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDeliveryInformationContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              StringsRes.lblDeliveryInformation,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsRes.lblDeliverTo,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 2.5,
                ),
                Text(
                  widget.order.address,
                  style: TextStyle(
                      color: ColorsRes.subTitleTextColor, fontSize: 13.0),
                ),
                Text(
                  widget.order.mobile,
                  style: TextStyle(
                      color: ColorsRes.subTitleTextColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              StringsRes.lblBillingDetails,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      StringsRes.lblPaymentMethod,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(widget.order.paymentMethod),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                widget.order.transactionId.isEmpty
                    ? SizedBox()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                StringsRes.lblTransactionId,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Text(
                                widget.order.transactionId,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                Row(
                  children: [
                    Text(
                      StringsRes.lblTotal,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                        GeneralMethods.getCurrencyFormat(
                            double.parse(widget.order.finalTotal)),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorsRes.appColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pop(widget.order.copyWith(orderItems: _orderItems));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            StringsRes.lblOrderSummary,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(widget.order.copyWith(orderItems: _orderItems));
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          child: Column(
            children: [
              _buildOrderStatusContainer(),
              _buildOrderItemsDetails(),
              _buildDeliveryInformationContainer(),
              _buildBillDetails()
            ],
          ),
        ),
      ),
    );
  }
}
