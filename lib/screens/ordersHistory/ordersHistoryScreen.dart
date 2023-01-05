import 'package:egrocer/helper/generalWidgets/trackMyOrderButton.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/activeOrdersProvider.dart';
import 'package:egrocer/helper/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/order.dart';
import 'package:egrocer/screens/ordersHistory/widgets/cancelOrderDialog.dart';
import 'package:egrocer/screens/ordersHistory/widgets/returnOrderDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersHistoryScreen extends StatefulWidget {
  OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen>
    with TickerProviderStateMixin {

  late ScrollController activeScrollController = ScrollController()
    ..addListener(activeOrdersScrollListener);

  void activeOrdersScrollListener() {
    if (activeScrollController.position.maxScrollExtent ==
        activeScrollController.offset) {
      if (context.read<ActiveOrdersProvider>().hasMoreData) {
        context.read<ActiveOrdersProvider>().getMoreOrders(context: context);
      }
    }
  }

  bool _showCancelOrderButton(Order order) {
    bool cancelOrder = true;

    for (var orderItem in order.items) {
      if (orderItem.cancelStatus == "0") {
        cancelOrder = false;
        break;
      }
    }

    return cancelOrder;
  }

  bool _showReturnOrderButton(Order order) {
    bool returnOrder = true;

    for (var orderItem in order.items) {
      if (orderItem.returnStatus == "0") {
        returnOrder = false;
        break;
      }
    }

    return returnOrder;
  }

  bool _showTrackOrderButton(Order order) {
    return order.activeStatus.isNotEmpty
        ? int.parse(order.activeStatus) >= 3
        : false; //3 is processed/confirmed order
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<ActiveOrdersProvider>()
          .getOrders(params: {}, context: context);
    });
  }

  @override
  void dispose() {
    activeScrollController.removeListener(activeOrdersScrollListener);
    activeScrollController.dispose();
    super.dispose();
  }

  String getOrderedItemNames(List<OrderItem> orderItems) {
    String itemNames = "";
    for (var i = 0; i < orderItems.length; i++) {
      if (i == orderItems.length - 1) {
        itemNames = itemNames + orderItems[i].productName;
      } else {
        itemNames = "${orderItems[i].productName}, ";
      }
    }
    return itemNames;
  }

  Widget _buildOrderDetailsContainer(Order order) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${StringsRes.lblOrder} #${order.id}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  CircleAvatar(
                    radius: 2.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    Constant.getOrderActiveStatusLabelFromCode(
                        order.activeStatus),
                    style: TextStyle(fontSize: 12.5),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, orderDetailScreen,arguments: order)
                          .then((value) {
                        if (value != null) {
                          context
                              .read<ActiveOrdersProvider>()
                              .updateOrder(value as Order);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent)),
                      padding: EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            StringsRes.lblViewDetails,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: ColorsRes.subTitleTextColor),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12.0,
                            color: ColorsRes.subTitleTextColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.5,
              ),
              Text(
                "${StringsRes.lblPlacedOrderOn} ${GeneralMethods.formatDate(DateTime.parse(order.createdAt))}",
                style: TextStyle(
                    fontSize: 12.5, color: ColorsRes.subTitleTextColor),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                getOrderedItemNames(order.items),
                style: TextStyle(fontSize: 12.5),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "${StringsRes.lblBy} ${order.items.first.sellerName}",
                style: TextStyle(fontSize: 12.5, color: ColorsRes.appColor),
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                StringsRes.lblTotal,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                GeneralMethods.getCurrencyFormat(
                    double.parse(order.finalTotal)),
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildReturnOrderButton(
      {required Order order, required double width}) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: ReturnOrderDialog(orderId: order.id.toString()),
                )).then((value) {
          if (value != null) {
            //
            if (value) {
              //
              //change order status to returned and also all it's products
              List<OrderItem> orderItems = List.from(order.items);

              for (var i = 0; i < order.items.length; i++) {
                orderItems[i] = order.items[i]
                    .updateStatus(Constant.orderStatusCode[7]); //Returned
              }

              context.read<ActiveOrdersProvider>().updateOrder(order.copyWith(
                  orderItems: orderItems,
                  updatedActiveStatus: Constant.orderStatusCode[7] //Returned
                  ));
            } else {
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblUnableToReturnOrder);
            }
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          StringsRes.lblReturn,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildCancelOrderButton(
      {required Order order, required double width}) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: CancelOrderDialog(orderId: order.id.toString()),
                )).then((value) {
          if (value != null) {
            //
            if (value) {
              //
              //change order status to cancelled and also all it's products
              List<OrderItem> orderItems = List.from(order.items);

              for (var i = 0; i < order.items.length; i++) {
                orderItems[i] = order.items[i]
                    .updateStatus(Constant.orderStatusCode[6]); //Cancelled
              }

              context.read<ActiveOrdersProvider>().updateOrder(order.copyWith(
                  orderItems: orderItems,
                  updatedActiveStatus: Constant.orderStatusCode[6] //Cancelled
                  ));
            } else {
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblUnableToCancelOrder);
            }
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          StringsRes.lblCancel,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildOrderContainer(Order order) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.paddingOrMargin10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: Constant.paddingOrMargin5),
      child: Column(
        children: [
          _buildOrderDetailsContainer(order),
          SizedBox(
            height: 5,
          ),
          LayoutBuilder(builder: (context, boxConstraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _showCancelOrderButton(order)
                    ? _buildCancelOrderButton(
                        order: order, width: boxConstraints.maxWidth * (0.5))
                    : SizedBox(),
                _showReturnOrderButton(order)
                    ? _buildReturnOrderButton(
                        order: order, width: boxConstraints.maxWidth * (0.5))
                    : SizedBox(),
                _showTrackOrderButton(order)
                    ? Column(
                        children: [
                          TrackMyOrderButton(
                              status: order.status,
                              width: boxConstraints.maxWidth * (0.5)),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrders() {
    return Consumer<ActiveOrdersProvider>(builder: (context, provider, _) {
      if (provider.activeOrdersState == ActiveOrdersState.loaded ||
          provider.activeOrdersState == ActiveOrdersState.loadingMore) {
        return ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin10),
            controller: activeScrollController,
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              if (index == provider.orders.length - 1) {
                if (provider.hasMoreData) {
                  return _buildOrderContainerShimmer();
                }
              }
              return _buildOrderContainer(provider.orders[index]);
            });
      }

      if (provider.activeOrdersState == ActiveOrdersState.error) {
        return SizedBox();
      }
      return _buildOrdersHistoryShimmer();
    });
  }

  Widget _buildOrderContainerShimmer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CustomShimmer(
                  height: 8,
                  width: boxConstraints.maxWidth * (0.25),
                ),
                Spacer(),
                CustomShimmer(
                  height: 8,
                  width: boxConstraints.maxWidth * (0.25),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomShimmer(
              margin: EdgeInsetsDirectional.only(
                  end: boxConstraints.maxWidth * (0.5)),
              height: 6,
            ),
            SizedBox(
              height: 20,
            ),
            CustomShimmer(
              height: 6,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: boxConstraints.maxWidth * (0.125),
                ),
                CustomShimmer(
                  width: boxConstraints.maxWidth * (0.25),
                ),
                Spacer(),
                CustomShimmer(
                  width: boxConstraints.maxWidth * (0.25),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.125),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrdersHistoryShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (index) => index)
              .map((e) => _buildOrderContainerShimmer())
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblOrdersHistory,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: _buildOrders(),
    );
  }
}
