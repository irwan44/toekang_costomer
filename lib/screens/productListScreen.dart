import 'dart:async';

import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/productGridItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/productListItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/productChangeListingProvider.dart';
import 'package:egrocer/helper/provider/productListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  final String? title;
  final String from;
  final String id;

  ProductListScreen(
      {Key? key, this.title, required this.from, required this.id})
      : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController edtSearch = TextEditingController();
  bool isFilterApplied = false;
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductListProvider>().hasMoreData) {
        callApi(isReset: false);
      }
    }
  }

  callApi({required bool isReset}) async {
    if (isReset) {
      context.read<ProductListProvider>().offset = 0;

      context.read<ProductListProvider>().products = [];
    }

    Map<String, String> params = await Constant.getProductsDefaultParams();

    params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
        context.read<ProductListProvider>().currentSortByOrderIndex];
    if (widget.from == "category") {
      params[ApiAndParams.categoryId] = widget.id.toString();
    } else {
      params[ApiAndParams.sectionId] = widget.id.toString();
    }

    params = await setFilterParams(params);

    await context
        .read<ProductListProvider>()
        .getProductListProvider(context: context, params: params);
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);

    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      callApi(isReset: true);
    });
  }

  @override
  dispose() {
    super.dispose();
    Constant.resetTempFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            widget.title ?? StringsRes.lblProducts,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [setCartCounter(context: context)]),
      body: Stack(
        children: [
          Column(
            children: [
              getSearchWidget(context: context),
              Widgets.getSizedBox(height: 10),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin5),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, productListFilterScreen,
                              arguments: [
                                context
                                    .read<ProductListProvider>()
                                    .productList
                                    .brands,
                                context
                                    .read<ProductListProvider>()
                                    .productList
                                    .maxPrice,
                                context
                                    .read<ProductListProvider>()
                                    .productList
                                    .minPrice,
                                context
                                    .read<ProductListProvider>()
                                    .productList
                                    .sizes
                              ]).then((value) async {
                            if (value == true) {
                              context.read<ProductListProvider>().offset = 0;
                              context.read<ProductListProvider>().products = [];

                              callApi(isReset: true);
                            }
                          });
                        },
                        child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Widgets.defaultImg(
                                    image: "filter_icon",
                                    height: 17,
                                    width: 17,
                                    padding: EdgeInsetsDirectional.only(
                                        top: 7, bottom: 7, end: 7),
                                    iconColor: Theme.of(context).primaryColor),
                                Text(
                                  StringsRes.lblFilter,
                                  softWrap: true,
                                )
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            shape: DesignConfig.setRoundedBorderSpecific(20,
                                istop: true),
                            builder: (BuildContext context1) {
                              return Wrap(
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start: Constant.paddingOrMargin15,
                                        end: Constant.paddingOrMargin15,
                                        top: Constant.paddingOrMargin15,
                                        bottom: Constant.paddingOrMargin15),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            StringsRes.lblSortBy,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .merge(TextStyle(
                                                letterSpacing: 0.5)),
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(
                                              ApiAndParams.productListSortTypes
                                                  .length, (index) {
                                            return ListTile(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  context
                                                      .read<
                                                          ProductListProvider>()
                                                      .products = [];

                                                  context
                                                      .read<
                                                          ProductListProvider>()
                                                      .offset = 0;

                                                  context
                                                      .read<
                                                          ProductListProvider>()
                                                      .currentSortByOrderIndex = index;

                                                  callApi(isReset: true);
                                                },
                                                title: Text(
                                                  StringsRes
                                                          .lblSortingDisplayList[
                                                      index],
                                                  softWrap: true,
                                                ),
                                                leading: context
                                                            .read<
                                                                ProductListProvider>()
                                                            .currentSortByOrderIndex ==
                                                        index
                                                    ? Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color:
                                                            ColorsRes.appColor,
                                                      )
                                                    : Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            ColorsRes.appColor,
                                                      ));
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Widgets.defaultImg(
                                    image: "sorting_icon",
                                    height: 17,
                                    width: 17,
                                    padding: EdgeInsetsDirectional.only(
                                        top: 7, bottom: 7, end: 7),
                                    iconColor: Theme.of(context).primaryColor),
                                Text(
                                  StringsRes.lblSortBy,
                                  softWrap: true,
                                )
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<ProductChangeListingTypeProvider>()
                              .changeListingType();
                        },
                        child: Card(
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
                                  softWrap: true,
                                )
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: setRefreshIndicator(
                      refreshCallback: () async {
                        context.read<ProductListProvider>().offset = 0;
                        context.read<ProductListProvider>().products = [];

                        callApi(isReset: true);
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: productWidget(),
                      )))
            ],
          ),
          Consumer<CartListProvider>(
            builder: (context, cartListProvider, child) {
              return cartListProvider.cartListState == CartListState.loading
                  ? PositionedDirectional(
                      top: 0,
                      end: 0,
                      start: 0,
                      bottom: 0,
                      child: Container(
                          color: ColorsRes.appColorBlack.withOpacity(0.2),
                          child: Center(child: CircularProgressIndicator())),
                    )
                  : SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  productWidget() {
    return Consumer<ProductListProvider>(
        builder: (context, productListProvider, _) {
      List<ProductListItem> products = productListProvider.products;
      if (productListProvider.productState == ProductState.initial) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productListProvider.productState == ProductState.loading) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productListProvider.productState == ProductState.loaded ||
          productListProvider.productState == ProductState.loadingMore) {
        return Column(
          children: [
            context.read<ProductChangeListingTypeProvider>().getListingType() ==
                    true
                ? /* GRID VIEW UI */ GridView.builder(
                    itemCount: products.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin10,
                        vertical: Constant.paddingOrMargin10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductGridItemContainer(product: products[index]);
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
                      children: List.generate(products.length, (index) {
                        return ProductListItemContainer(
                            product: products[index]);
                      }),
                    ),
                  ),
            if (productListProvider.productState == ProductState.loadingMore)
              getProductItemShimmer(
                  context: context,
                  isGrid: context
                      .read<ProductChangeListingTypeProvider>()
                      .getListingType()),
          ],
        );
      } else {
        return DefaultBlankItemMessageScreen(
          title: StringsRes.lblEmptyProductListMessage,
          description: StringsRes.lblEmptyProductListDescription,
          image: "no_product_icon",
        );
      }
    });
  }

  Future<Map<String, String>> setFilterParams(
      Map<String, String> params) async {
    params[ApiAndParams.maxPrice] = Constant.currentRangeValues.end.toString();
    params[ApiAndParams.minPrice] =
        Constant.currentRangeValues.start.toString();
    params[ApiAndParams.brandIds] =
        getFiltersItemsList(Constant.selectedBrands.toSet().toList());

    List<String> sizes = await getSizeListSizesAndIds(Constant.selectedSizes)
        .then((value) => value[0]);
    List<String> unitIds = await getSizeListSizesAndIds(Constant.selectedSizes)
        .then((value) => value[1]);

    params[ApiAndParams.sizes] = getFiltersItemsList(sizes);
    params[ApiAndParams.unitIds] = getFiltersItemsList(unitIds);

    return params;
  }

  Future<List<List<String>>> getSizeListSizesAndIds(List sizeList) async {
    List<String> sizes = [];
    List<String> unitIds = [];

    for (int i = 0; i < sizeList.length; i++) {
      if (i % 2 == 0) {
        sizes.add(sizeList[i].toString().split("-")[0]);
      } else {
        unitIds.add(sizeList[i].toString().split("-")[1]);
      }
    }
    return [sizes, unitIds];
  }

  String getFiltersItemsList(List<String> param) {
    String ids = "";
    for (int i = 0; i < param.length; i++) {
      ids += "${param[i]}${i == (param.length - 1) ? "" : ","}";
    }
    return ids;
  }
}
