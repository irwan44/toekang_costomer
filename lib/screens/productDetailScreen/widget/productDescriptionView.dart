import 'package:egrocer/helper/provider/productDetailProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

class ProductDescriptionView extends StatelessWidget {
  final String description;
  final BuildContext context;

  ProductDescriptionView(
      {Key? key, required this.context, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: Constant.paddingOrMargin5, end: Constant.paddingOrMargin5),
      child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: Constant.paddingOrMargin10,
                end: Constant.paddingOrMargin10,
                top: Constant.paddingOrMargin10),
            child: Column(
              children: [
                context.read<ProductDetailProvider>().seeMore == false
                    ? Container(
                        height: 300,
                        child: ClipRRect(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [getHtmlWidget()],
                          ),
                        ),
                      )
                    : getHtmlWidget(),
                GestureDetector(
                  onTap: () => context
                      .read<ProductDetailProvider>()
                      .expandCollapseProductDescriptionView(),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: Constant.paddingOrMargin10,
                        bottom: Constant.paddingOrMargin10,
                        top: Constant.paddingOrMargin10),
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.read<ProductDetailProvider>().seeMore
                                ? StringsRes.lblHideDetail
                                : StringsRes.lblShowDetail,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.appColor),
                          ),
                          Icon(
                            context.read<ProductDetailProvider>().seeMore
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: ColorsRes.appColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  getHtmlWidget() {
    return HtmlWidget(
      description,
      isSelectable: false,
      enableCaching: true,
      renderMode: RenderMode.column,
      buildAsync: false,
      textStyle: TextStyle(color: ColorsRes.mainTextColor),
    );
  }
}
