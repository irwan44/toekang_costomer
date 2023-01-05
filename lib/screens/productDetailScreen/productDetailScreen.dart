import 'dart:async';

import 'package:egrocer/helper/generalWidgets/productCartButton.dart';
import 'package:egrocer/helper/generalWidgets/productWishListIcon.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/productDetailProvider.dart';
import 'package:egrocer/helper/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/ProductDetail.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'widget/otherImagesBoxDecoration.dart';
import 'widget/productDescriptionView.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? title;
  final String id;
  final ProductListItem? productListItem;

  ProductDetailScreen(
      {Key? key, this.title, required this.id, this.productListItem})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int currentImage;
  late List<String> images;

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      params[ApiAndParams.id] = widget.id;

      await context
          .read<ProductDetailProvider>()
          .getProductDetailProvider(context: context, params: params)
          .then((value) async {
        if (value) {
          currentImage = 0;
          setOtherImages(currentImage,
              context.read<ProductDetailProvider>().productDetail.data);
        }
      });
    });
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
            widget.title ?? StringsRes.lblProducts,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
        ),
        body: Stack(
          children: [
            Consumer<ProductDetailProvider>(
                builder: (context, productDetailProvider, child) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    productDetailProvider.productDetailState ==
                            ProductDetailState.loaded
                        ? ChangeNotifierProvider<SelectedVariantItemProvider>(
                            create: (context) => SelectedVariantItemProvider(),
                            child: productDetailWidget(
                                productDetailProvider.productDetail.data),
                          )
                        : productDetailProvider.productDetailState ==
                                ProductDetailState.loading
                            ? getProductDetailShimmer(context: context)
                            : SizedBox.shrink(),
                  ],
                ),
              );
            }),
            PositionedDirectional(
              top: 0,
              end: 0,
              start: 0,
              bottom: 0,
              child: Consumer<CartListProvider>(
                builder: (context, cartListProvider, child) {
                  return cartListProvider.cartListState == CartListState.loading
                      ? Container(
                          color: ColorsRes.appColorBlack.withOpacity(0.2),
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox.shrink();
                },
              ),
            )
          ],
        ));
  }

  productDetailWidget(Data? product) {
    List<ProductDetailVariants> variants = product!.variants;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Constant.paddingOrMargin10,
              horizontal: Constant.paddingOrMargin10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, fullScreenProductImageScreen,
                  arguments: [currentImage, images]);
            },
            child: Consumer<SelectedVariantItemProvider>(
              builder: (context, selectedVariantItemProvider, child) {
                return Stack(
                  children: [
                    ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Widgets.setNetworkImg(
                          boxFit: BoxFit.fill,
                          image: images[currentImage],
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                        )),
                    if (product
                            .variants[
                                selectedVariantItemProvider.getSelectedIndex()]
                            .status ==
                        0)
                      PositionedDirectional(
                          top: 0,
                          end: 0,
                          start: 0,
                          bottom: 0,
                          child: getOutOfStockWidget(
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width)),
                    PositionedDirectional(
                        bottom: 5,
                        end: 5,
                        child: Column(
                          children: [
                            if (product.indicator == 1)
                              Widgets.defaultImg(
                                  height: 35,
                                  width: 35,
                                  image: "veg_indicator"),
                            if (product.indicator == 2)
                              Widgets.defaultImg(
                                  height: 35,
                                  width: 35,
                                  image: "non_veg_indicator"),
                          ],
                        )),
                  ],
                );
              },
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                List.generate(images.length > 1 ? images.length : 0, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentImage = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: getOtherImagesBoxDecoration(
                        isActive: currentImage == index),
                    child: ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Widgets.setNetworkImg(
                            height: 60,
                            width: 60,
                            image: images[index],
                            boxFit: BoxFit.fill)),
                  ),
                ),
              );
            }),
          ),
        ),
        Widgets.getSizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProductWishListIcon(
                            product: Constant.session.isUserLoggedIn()
                                ? widget.productListItem ?? null
                                : null,
                            isListing: false,
                          ),
                          Text(
                            StringsRes.lblWishList,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await GeneralMethods.createDynamicLink(
                            shareUrl:
                                "${Constant.hostUrl}product/${product.id}",
                            imageUrl: product.imageUrl,
                            title: product.name,
                            description:
                                "<h1>${product.name}</h1><br><br><h2>${product.variants[0].measurement} ${product.variants[0].stockUnitName}</h2>")
                        .then(
                      (value) async => await Share.share(
                          "${product.name}\n\n$value",
                          subject: "Share app"),
                    );
                  },
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Widgets.defaultImg(
                            image: "share_icon",
                            height: 17,
                            width: 17,
                            padding: EdgeInsetsDirectional.only(
                                top: 7, bottom: 7, end: 7),
                            iconColor: Theme.of(context).primaryColor),
                        Text(
                          StringsRes.lblShare,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (Constant.session.isUserLoggedIn()) {
                      Navigator.pushNamed(context, cartScreen);
                    } else {
                      GeneralMethods.showSnackBarMsg(context,
                          StringsRes.lblRequiredLoginMessageForCartRedirect,
                          requiredAction: true);
                    }
                  },
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Widgets.defaultImg(
                            image: "cart_icon",
                            height: 17,
                            width: 17,
                            padding: EdgeInsetsDirectional.only(
                                top: 7, bottom: 7, end: 7),
                            iconColor: Theme.of(context).primaryColor),
                        Text(
                          StringsRes.lblGoToCart,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Widgets.getSizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.paddingOrMargin10,
              vertical: Constant.paddingOrMargin10),
          margin: EdgeInsets.symmetric(horizontal: Constant.paddingOrMargin10),
          decoration:
              DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
          child: Consumer<SelectedVariantItemProvider>(
            builder: (context, selectedVariantItemProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    softWrap: true,
                  ),
                  Widgets.getSizedBox(height: Constant.paddingOrMargin15),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            variants.length > 1 ? Constant.paddingOrMargin5 : 0,
                        horizontal: variants.length > 1
                            ? Constant.paddingOrMargin5
                            : 0),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: Constant.borderRadius5,
                        border: Border(
                            left: BorderSide(
                                color: variants.length > 1
                                    ? ColorsRes.appColor
                                    : Colors.transparent,
                                width: 1),
                            right: BorderSide(
                                color: variants.length > 1
                                    ? ColorsRes.appColor
                                    : Colors.transparent,
                                width: 1),
                            top: BorderSide(
                                color: variants.length > 1
                                    ? ColorsRes.appColor
                                    : Colors.transparent,
                                width: 1),
                            bottom: BorderSide(
                                color: variants.length > 1
                                    ? ColorsRes.appColor
                                    : Colors.transparent,
                                width: 1))),
                    child: GestureDetector(
                      onTap: () {
                        if (variants.length > 1) {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            shape: DesignConfig.setRoundedBorderSpecific(20,
                                istop: true),
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.paddingOrMargin15,
                                    end: Constant.paddingOrMargin15,
                                    top: Constant.paddingOrMargin15,
                                    bottom: Constant.paddingOrMargin15),
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.paddingOrMargin15,
                                          end: Constant.paddingOrMargin15),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  Constant.borderRadius10,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Widgets.setNetworkImg(
                                                  boxFit: BoxFit.fill,
                                                  image: product.imageUrl,
                                                  height: 70,
                                                  width: 70)),
                                          Widgets.getSizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              softWrap: true,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.paddingOrMargin15,
                                          end: Constant.paddingOrMargin15,
                                          top: Constant.paddingOrMargin15,
                                          bottom: Constant.paddingOrMargin15),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: variants.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: RichText(
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        // maxLines: 1,
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                decorationThickness:
                                                                    2),
                                                            text:
                                                                "${variants[index].measurement} ",
                                                          ),
                                                          WidgetSpan(
                                                            child: Text(
                                                              variants[index]
                                                                  .stockUnitName,
                                                              softWrap: true,
                                                              //superscript is usually smaller in size
                                                              // textScaleFactor: 0.7,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                              text: variants[index]
                                                                          .discountedPrice !=
                                                                      0
                                                                  ? " | "
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: ColorsRes
                                                                      .mainTextColor)),
                                                          TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationThickness:
                                                                    2),
                                                            text: variants[index]
                                                                        .discountedPrice !=
                                                                    0
                                                                ? GeneralMethods
                                                                    .getCurrencyFormat(
                                                                        variants[index]
                                                                            .price)
                                                                : "",
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                    Text(
                                                      variants[index]
                                                                  .discountedPrice !=
                                                              0
                                                          ? GeneralMethods
                                                              .getCurrencyFormat(
                                                                  variants[
                                                                          index]
                                                                      .discountedPrice)
                                                          : GeneralMethods
                                                              .getCurrencyFormat(
                                                                  variants[
                                                                          index]
                                                                      .price),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: ColorsRes
                                                              .appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ProductCartButton(
                                                productId:
                                                    product.id.toString(),
                                                productVariantId:
                                                    variants[index]
                                                        .id
                                                        .toString(),
                                                count: variants[index].status ==
                                                        0
                                                    ? -1
                                                    : variants[index].cartCount,
                                                isUnlimitedStock:
                                                    product.isUnlimitedStock ==
                                                        1,
                                                maximumAllowedQuantity:
                                                    double.parse(product
                                                        .totalAllowedQuantity
                                                        .toString()),
                                                availableStock:
                                                    variants[index].stock,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    Constant.paddingOrMargin7),
                                            child: Divider(
                                              color: ColorsRes.grey,
                                              height: 5,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: RichText(
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        // maxLines: 1,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsRes.mainTextColor,
                                  decorationThickness: 2),
                              text: "${variants[0].measurement} ",
                            ),
                            WidgetSpan(
                              child: Text(
                                variants[0].stockUnitName,
                                softWrap: true,
                                //superscript is usually smaller in size
                                // textScaleFactor: 0.7,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  variants[0].discountedPrice != 0 ? " | " : "",
                              style: TextStyle(color: ColorsRes.mainTextColor),
                            ),
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 13,
                                  color: ColorsRes.mainTextColor,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2),
                              text: variants[0].discountedPrice != 0
                                  ? GeneralMethods.getCurrencyFormat(
                                      variants[0].price)
                                  : "",
                            ),
                            if (variants.length > 1)
                              WidgetSpan(
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(height: Constant.paddingOrMargin15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          variants[selectedVariantItemProvider
                                          .getSelectedIndex()]
                                      .discountedPrice !=
                                  0
                              ? GeneralMethods.getCurrencyFormat(variants[
                                      selectedVariantItemProvider
                                          .getSelectedIndex()]
                                  .discountedPrice)
                              : GeneralMethods.getCurrencyFormat(variants[
                                      selectedVariantItemProvider
                                          .getSelectedIndex()]
                                  .price),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17,
                              color: ColorsRes.appColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ProductCartButton(
                        count: variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                    .status ==
                                0
                            ? -1
                            : variants[selectedVariantItemProvider
                                    .getSelectedIndex()]
                                .cartCount,
                        productVariantId: variants[
                                selectedVariantItemProvider.getSelectedIndex()]
                            .id
                            .toString(),
                        productId: product.id.toString(),
                        maximumAllowedQuantity: double.parse(
                            product.totalAllowedQuantity.toString()),
                        isUnlimitedStock: product.isUnlimitedStock == 1,
                        availableStock: variants[
                                selectedVariantItemProvider.getSelectedIndex()]
                            .stock,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Widgets.getSizedBox(height: Constant.paddingOrMargin10),
        ProductDescriptionView(
            context: context, description: product.description.toString())
      ],
    );
  }

  getProductDetailShimmer({required BuildContext context}) {
    return CustomShimmer(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }

  setOtherImages(int currentIndex, Data product) {
    currentImage = 0;
    images = [];
    images.add(product.imageUrl);
    if (product.variants[currentIndex].images.isNotEmpty) {
      images.addAll(product.variants[currentIndex].images);
    } else {
      images.addAll(product.images);
    }
    context.read<ProductDetailProvider>().notify();
  }
}
