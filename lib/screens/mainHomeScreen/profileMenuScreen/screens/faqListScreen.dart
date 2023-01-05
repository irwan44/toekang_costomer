import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/faqListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/faq.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FaqListScreen extends StatefulWidget {
  FaqListScreen({Key? key}) : super(key: key);

  @override
  State<FaqListScreen> createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<FaqProvider>().hasMoreData) {
        context
            .read<FaqProvider>()
            .getFaqProvider(params: {}, context: context);
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context.read<FaqProvider>().getFaqProvider(params: {}, context: context);
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
            StringsRes.lblFAQ,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
          refreshCallback: () {
            context.read<FaqProvider>().offset = 0;
            context.read<FaqProvider>().faqs = [];
            return context
                .read<FaqProvider>()
                .getFaqProvider(params: {}, context: context);
          },
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            child: Consumer<FaqProvider>(builder: (context, faqProvider, _) {
              List<FAQ> faqs = faqProvider.faqs;
              if (faqProvider.itemsState == FaqState.initial ||
                  faqProvider.itemsState == FaqState.loading) {
                return getFaqListShimmer();
              } else if (faqProvider.itemsState == FaqState.loaded ||
                  faqProvider.itemsState == FaqState.loadingMore) {
                return Column(
                  children: List.generate(faqs.length, (index) {
                    return getFaqExpandableItem(faqs[index]);
                  }),
                );
              } else {
                return Container();
              }
            }),
          )),
    );
  }

  getFaqExpandableItem(FAQ faq) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: DesignConfig.boxDecoration(
          Theme.of(context).cardColor,
          10,
        ),
        child: ExpansionTile(
          initiallyExpanded: faq.isExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() => faq.isExpanded = expanded);
          },
          title: Text(
            faq.question,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          trailing: Icon(
            faq.isExpanded ? Icons.remove : Icons.add,
          ),
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: Constant.paddingOrMargin30,
                  top: Constant.paddingOrMargin5,
                  bottom: Constant.paddingOrMargin10,
                  end: Constant.paddingOrMargin10),
              child: Text(faq.answer),
            )
          ],
        ));
  }

  getFaqListShimmer() {
    return Column(
      children: List.generate(20, (index) => faqItemShimmer()),
    );
  }

  faqItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin5,
          horizontal: Constant.paddingOrMargin10),
      height: 50,
      width: MediaQuery.of(context).size.width,
    );
  }
}
