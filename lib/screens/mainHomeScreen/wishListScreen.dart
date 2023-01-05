import 'dart:async';

import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/productGridItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/productListItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productChangeListingProvider.dart';
import 'package:egrocer/helper/provider/productWishListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<WishListScreen> {
  TextEditingController edtSearch = TextEditingController();

  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductWishListProvider>().hasMoreData) {
        callApi(isReset: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    scrollController.addListener(scrollListener);

    Future.delayed(Duration.zero).then((value) async {
      callApi(isReset: true);
    });
  }

  callApi({required isReset}) async {
    if (isReset) {
      context.read<ProductWishListProvider>().offset = 0;
      context.read<ProductWishListProvider>().wishlistProducts = [];
    }
    Map<String, String> params = await Constant.getProductsDefaultParams();

    await context
        .read<ProductWishListProvider>()
        .getProductWishListProvider(context: context, params: params);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblWishList,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [setCartCounter(context: context)]),
      body: Column(
        children: [
          getSearchWidget(context: context),
          Widgets.getSizedBox(height: 5),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin5),
            child: GestureDetector(
              onTap: () {
                context
                    .read<ProductChangeListingTypeProvider>()
                    .changeListingType();
              },
              child: context
                          .watch<ProductWishListProvider>()
                          .wishlistProducts
                          .length >
                      0
                  ? Card(
                      margin: EdgeInsets.zero,
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Widgets.defaultImg(
                              image: context
                                          .watch<
                                              ProductChangeListingTypeProvider>()
                                          .getListingType() ==
                                      false
                                  ? "grid_view_icon"
                                  : "list_view_icon",
                              height: 17,
                              width: 17,
                              padding: EdgeInsetsDirectional.only(
                                  top: 7, bottom: 7, end: 7),
                              iconColor: Theme.of(context).primaryColor),
                          Text(
                            context
                                        .watch<
                                            ProductChangeListingTypeProvider>()
                                        .getListingType() ==
                                    false
                                ? StringsRes.lblGridView
                                : StringsRes.lblListView,
                          )
                        ],
                      ))
                  : SizedBox.shrink(),
            ),
          ),
          Expanded(
              child: setRefreshIndicator(
                  refreshCallback: () async {
                    callApi(isReset: true);
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: productWidget(),
                  )))
        ],
      ),
    );
  }

  productWidget() {
    return Consumer<ProductWishListProvider>(
        builder: (context, productWishlistProvider, _) {
      List<ProductListItem> wishlistProducts =
          productWishlistProvider.wishlistProducts;
      if (productWishlistProvider.productWishListState ==
          ProductWishListState.initial) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productWishlistProvider.productWishListState ==
          ProductWishListState.loading) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productWishlistProvider.productWishListState ==
              ProductWishListState.loaded ||
          productWishlistProvider.productWishListState ==
              ProductWishListState.loadingMore) {
        return Column(
          children: [
            context.read<ProductChangeListingTypeProvider>().getListingType() ==
                    true
                ? /* GRID VIEW UI */ GridView.builder(
                    itemCount: wishlistProducts.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin10,
                        vertical: Constant.paddingOrMargin10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductGridItemContainer(
                          product: wishlistProducts[index]);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.6,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                  )
                : /* LIST VIEW UI */ Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(wishlistProducts.length, (index) {
                        return ProductListItemContainer(
                            product: wishlistProducts[index]);
                      }),
                    ),
                  ),
            if (productWishlistProvider.productWishListState ==
                ProductWishListState.loadingMore)
              getProductItemShimmer(
                  context: context,
                  isGrid: context
                      .read<ProductChangeListingTypeProvider>()
                      .getListingType()),
          ],
        );
      } else {
        return DefaultBlankItemMessageScreen(
          title: StringsRes.lblEmptyWishListMessage,
          description: StringsRes.lblEmptyWishListDescription,
          image: "empty_wishlist_icon",
        );
      }
    });
  }
}
