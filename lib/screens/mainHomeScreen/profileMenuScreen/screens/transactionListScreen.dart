import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/transactionListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionListScreen extends StatefulWidget {
  TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<TransactionProvider>().hasMoreData) {
        context
            .read<TransactionProvider>()
            .getTransactionProvider(params: {}, context: context);
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context
          .read<TransactionProvider>()
          .getTransactionProvider(params: {}, context: context);
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
            StringsRes.lblTransactions,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
          refreshCallback: () {
            context.read<TransactionProvider>().offset = 0;
            context.read<TransactionProvider>().transactions = [];
            return context
                .read<TransactionProvider>()
                .getTransactionProvider(params: {}, context: context);
          },
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, _) {
              List<TransactionData> transactions =
                  transactionProvider.transactions;
              if (transactionProvider.itemsState == TransactionState.initial ||
                  transactionProvider.itemsState == TransactionState.loading) {
                return getTransactionListShimmer();
              } else if (transactionProvider.itemsState ==
                      TransactionState.loaded ||
                  transactionProvider.itemsState ==
                      TransactionState.loadingMore) {
                return Column(
                  children: List.generate(transactions.length, (index) {
                    return getTransactionItemWidget(transactions[index]);
                  }),
                );
              } else {
                return Container();
              }
            }),
          )),
    );
  }

  getTransactionItemWidget(TransactionData transaction) {
    return Container(
        padding: EdgeInsets.all(Constant.paddingOrMargin10),
        margin: EdgeInsets.symmetric(
            vertical: Constant.paddingOrMargin5,
            horizontal: Constant.paddingOrMargin10),
        decoration: DesignConfig.boxDecoration(
          Theme.of(context).cardColor,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "ID #${transaction.txnId}",
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Widgets.getSizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Constant.paddingOrMargin5,
                      horizontal: Constant.paddingOrMargin7),
                  decoration: DesignConfig.boxDecoration(
                      transaction.status.toLowerCase() == "success"
                          ? ColorsRes.appColorGreen.withOpacity(0.1)
                          : ColorsRes.appColorRed.withOpacity(0.1),
                      5,
                      bordercolor: transaction.status.toLowerCase() == "success"
                          ? ColorsRes.appColorGreen
                          : ColorsRes.appColorRed,
                      isboarder: true,
                      borderwidth: 1),
                  child: Text(
                      GeneralMethods.setFirstLetterUppercase(
                          transaction.status),
                      style: TextStyle(
                        color: transaction.status.toLowerCase() == "success"
                            ? ColorsRes.appColorGreen
                            : ColorsRes.appColorRed,
                      )),
                ),
              ],
            ),
            Widgets.getSizedBox(height: 10),
            Divider(height: 1, color: ColorsRes.grey, thickness: 0),
            Widgets.getSizedBox(height: 10),
            Text(
              StringsRes.lblPaymentMethod,
              style: TextStyle(fontSize: 14, color: ColorsRes.grey),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 2),
            Text(
              "${transaction.type}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 20),
            Text(
              StringsRes.lblDateAndTime,
              style: TextStyle(fontSize: 14, color: ColorsRes.grey),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 2),
            Text(
              "${transaction.createdAt}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
            Widgets.getSizedBox(height: 10),
            Divider(height: 1, color: ColorsRes.grey, thickness: 0),
            Widgets.getSizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  StringsRes.lblAmount,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  softWrap: true,
                ),
                Text(
                  GeneralMethods.getCurrencyFormat(
                      double.parse(transaction.amount)),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsRes.appColor),
                  softWrap: true,
                ),
              ],
            )
          ],
        ));
  }

  getTransactionListShimmer() {
    return Column(
      children: List.generate(20, (index) => faqItemShimmer()),
    );
  }

  faqItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin5,
          horizontal: Constant.paddingOrMargin10),
      height: 180,
      width: MediaQuery.of(context).size.width,
    );
  }
}
