import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/notificationListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatefulWidget {
  NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<NotificationProvider>().hasMoreData) {
        context
            .read<NotificationProvider>()
            .getNotificationProvider(params: {}, context: context);
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context
          .read<NotificationProvider>()
          .getNotificationProvider(params: {}, context: context);
    });

    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          StringsRes.lblNotification,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          context.read<NotificationProvider>().notifications.clear();
          context.read<NotificationProvider>().offset = 0;
          return context
              .read<NotificationProvider>()
              .getNotificationProvider(params: {}, context: context);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          child: notificationItemsWidget(),
        ),
      ),
    );
  }

  notificationItemsWidget() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
      List<NotificationListData> notifications =
          notificationProvider.notifications;
      if (notificationProvider.itemsState == NotificationState.initial) {
        return getNotificationListShimmer();
      } else if (notificationProvider.itemsState == NotificationState.loading) {
        return getNotificationListShimmer();
      } else if (notificationProvider.itemsState == NotificationState.loaded ||
          notificationProvider.itemsState == NotificationState.loadingMore) {
        return Column(
          children: List.generate(notifications.length, (index) {
            NotificationListData notification = notifications[index];
            return GestureDetector(
              onTap: () {
                if (notification.type == "category") {
                  Navigator.pushNamed(context, productListScreen, arguments: [
                    "category",
                    notification.typeId.toString(),
                    ""
                  ]);
                } else if (notification.type == "product") {
                  Navigator.pushNamed(context, productDetailScreen, arguments: [
                    notification.typeId.toString(),
                    "",
                    "",
                    null
                  ]);
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Constant.paddingOrMargin5,
                      horizontal: Constant.paddingOrMargin5),
                  margin: EdgeInsets.symmetric(
                      vertical: Constant.paddingOrMargin5,
                      horizontal: Constant.paddingOrMargin10),
                  decoration: DesignConfig.boxDecoration(
                    Theme.of(context).cardColor,
                    10,
                  ),
                  child: Row(
                    children: [
                      notification.imageUrl != ""
                          ? ClipRRect(
                              borderRadius: Constant.borderRadius10,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Widgets.setNetworkImg(
                                height: 60,
                                width: 60,
                                boxFit: BoxFit.fill,
                                image: notification.imageUrl,
                              ))
                          : Container(
                              height: 60,
                              width: 60,
                              decoration: DesignConfig.boxGradient(10),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Constant.paddingOrMargin10,
                                    horizontal: Constant.paddingOrMargin10),
                                child: Widgets.defaultImg(
                                    height: 20,
                                    width: 20,
                                    image: "notification_icon",
                                    iconColor: ColorsRes.appColorWhite),
                              )),
                      Widgets.getSizedBox(width: 20),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Widgets.getSizedBox(height: 10),
                          Text(
                            notification.message,
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: notification.type == "category"
                                ? Text(
                                    StringsRes.lblGoToCategory,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: ColorsRes.appColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                : notification.type == "product"
                                    ? Text(
                                        StringsRes.lblGoToProduct,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: ColorsRes.appColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(),
                          )
                        ],
                      ))
                    ],
                  )),
            );
          }),
        );
      } else if (notificationProvider.itemsState == NotificationState.error) {
        return DefaultBlankItemMessageScreen(
          title: StringsRes.lblEmptyNotificationListMessage,
          description: StringsRes.lblEmptyNotificationListDescription,
          image: "no_notification_icon",
        );
      } else {
        return Container();
      }
    });
  }

  getNotificationListShimmer() {
    return Column(
      children: List.generate(20, (index) => notificationItemShimmer()),
    );
  }

  notificationItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin5,
          horizontal: Constant.paddingOrMargin10),
      height: 70,
      width: MediaQuery.of(context).size.width,
    );
  }
}
