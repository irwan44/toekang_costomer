import 'dart:async';

import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/productGridItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/productListItemContainer.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/productChangeListingProvider.dart';
import 'package:egrocer/helper/provider/productSearchProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ProductSearchScreen extends StatefulWidget {
  ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductSearchScreen> {
  // search provider controller
  final TextEditingController edtSearch = TextEditingController();
  SpeechToText _speechToText = SpeechToText();

//give delay to live search
  Timer? delayTimer;

  ScrollController scrollController = ScrollController();

  scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductSearchProvider>().hasMoreData) {
        Map<String, String> params = await Constant.getProductsDefaultParams();

        params[ApiAndParams.search] = edtSearch.text.trim();

        await context
            .read<ProductSearchProvider>()
            .getProductSearchProvider(context: context, params: params);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    edtSearch.addListener(searchTextListener);
    scrollController.addListener(scrollListener);
    _initSpeech();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      callApi(isReset: true);
    });
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  //
  void searchTextListener() {
    if (edtSearch.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 300), () {
      if (edtSearch.text.isNotEmpty) {
        if (edtSearch.text.length !=
            context.read<ProductSearchProvider>().searchedTextLength) {
          callApi(isReset: true);
          //
          context.read<ProductSearchProvider>().setSearchLength(edtSearch.text);
        }
      } else {
        context.read<ProductSearchProvider>().setSearchLength("");
        callApi(isReset: true);
      }
    });
  }

  callApi({required bool isReset}) async {
    if (isReset) {
      context.read<ProductSearchProvider>().offset = 0;

      context.read<ProductSearchProvider>().products = [];
    }

    Map<String, String> params = await Constant.getProductsDefaultParams();

    params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
        context.read<ProductSearchProvider>().currentSortByOrderIndex];
    params[ApiAndParams.search] = edtSearch.text.trim().toString();

    await context
        .read<ProductSearchProvider>()
        .getProductSearchProvider(context: context, params: params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(
          context: context,
          title: Text(StringsRes.lblSearch,
              softWrap: true, style: TextStyle(color: ColorsRes.mainTextColor)),
          actions: [setCartCounter(context: context)]),
      body: Stack(
        children: [
          Column(
            children: [
              searchWidget(),
              Widgets.getSizedBox(height: 10),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin5),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            // context and builder are
                            // required properties in this widget
                            context: context,
                            isScrollControlled: true,
                            shape: DesignConfig.setRoundedBorderSpecific(20,
                                istop: true),
                            builder: (BuildContext context1) {
                              return Wrap(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Constant.paddingOrMargin15,
                                        horizontal: Constant.paddingOrMargin15),
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
                                                          ProductSearchProvider>()
                                                      .products = [];

                                                  context
                                                      .read<
                                                          ProductSearchProvider>()
                                                      .offset = 0;

                                                  context
                                                      .read<
                                                          ProductSearchProvider>()
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
                                                                ProductSearchProvider>()
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
                        context.read<ProductSearchProvider>().offset = 0;
                        context.read<ProductSearchProvider>().products = [];

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
          ),
          Consumer<ProductSearchProvider>(
            builder: (context, productSearchProvider, child) {
              return productSearchProvider.isSearchingByVoice == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius:
                              BorderRadius.circular(Constant.paddingOrMargin10),
                        ),
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: AlignmentDirectional.topEnd,
                              child: IconButton(
                                splashRadius: 0.1,
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<ProductSearchProvider>()
                                        .enableDisableSearchByVoice(false);
                                  });
                                },
                                icon: Icon(Icons.close_rounded),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(StringsRes.lblVoiceSearchProductMessage,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  Widgets.getSizedBox(height: 20),
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: ColorsRes.appColor,
                                    child: GestureDetector(
                                      onLongPress: () {
                                        _startListening();
                                      },
                                      onLongPressUp: () {
                                        _stopListening();
                                      },
                                      child: Icon(
                                        Icons.mic_rounded,
                                        size: 60,
                                        color: ColorsRes.appColorWhite,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  //Start search widget
  searchWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(
          horizontal: Constant.paddingOrMargin10,
          vertical: Constant.paddingOrMargin10),
      child: Row(children: [
        Expanded(
            child: Container(
          decoration: DesignConfig.boxDecoration(
              Theme.of(context).scaffoldBackgroundColor, 10),
          child: ListTile(
            title: TextField(
              autofocus: true,
              controller: edtSearch,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: StringsRes.lblProductSearchHint,
              ),
              // onChanged: onSearchTextChanged,
            ),
            contentPadding: EdgeInsetsDirectional.only(start: 10),
            trailing: IconButton(
              padding: EdgeInsets.zero,
              icon: Consumer<ProductSearchProvider>(
                builder: (context, productSearchProvider, _) {
                  return Icon(context
                              .watch<ProductSearchProvider>()
                              .searchedTextLength ==
                          0
                      ? Icons.search
                      : Icons.cancel);
                },
              ),
              onPressed: () {
                if (edtSearch.text.toString().isNotEmpty) {
                  edtSearch.clear();
                }
                callApi(isReset: true);
              },
            ),
          ),
        )),
        SizedBox(width: 10),
        Consumer<ProductSearchProvider>(
          builder: (context, productSearchProvider, child) {
            return GestureDetector(
              onTap: () {
                productSearchProvider.enableDisableSearchByVoice(true);
              },
              child: Container(
                decoration: DesignConfig.boxGradient(10),
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.paddingOrMargin14,
                    vertical: Constant.paddingOrMargin14),
                child: Widgets.defaultImg(
                    image: "voice_search_icon", iconColor: Colors.white),
              ),
            );
          },
        )
      ]),
    );
  }

  //callback of voice search
  voiceToTextResult(String text) {
    edtSearch.text = text;
  }

  //End search widget

  productWidget() {
    return Consumer<ProductSearchProvider>(
        builder: (context, ProductSearchProvider, _) {
      List<ProductListItem> products = ProductSearchProvider.products;
      if (ProductSearchProvider.productSearchState ==
          ProductSearchState.initial) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (ProductSearchProvider.productSearchState ==
          ProductSearchState.loading) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (ProductSearchProvider.productSearchState ==
              ProductSearchState.loaded ||
          ProductSearchProvider.productSearchState ==
              ProductSearchState.loadingMore) {
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
            if (ProductSearchProvider.productSearchState ==
                ProductSearchState.loadingMore)
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

//  Speech to text service

  /// This has to happen only once per app
  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(seconds: 60),
        cancelOnError: true,
        listenMode: ListenMode.search);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      edtSearch.text = result.recognizedWords;
      context.read<ProductSearchProvider>().enableDisableSearchByVoice(false);
    });
  }
}
