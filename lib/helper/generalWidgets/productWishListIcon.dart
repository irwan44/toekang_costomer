import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productWishListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductWishListIcon extends StatelessWidget {
  final bool? isListing;
  final ProductListItem? product;

  ProductWishListIcon({
    Key? key,
    this.isListing,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductAddOrRemoveFavoriteProvider>(
      builder: (providerContext, value, child) {
        return GestureDetector(
          onTap: () async {
            if (Constant.session.isUserLoggedIn()) {
              Map<String, String> params = {};
              params[ApiAndParams.productId] = product?.id.toString() ?? "0";

              await providerContext
                  .read<ProductAddOrRemoveFavoriteProvider>()
                  .getProductAddOrRemoveFavorite(
                      params: params, context: context, productId: product?.id ?? 0)
                  .then((value) {
                if (value) {
                  context
                      .read<ProductWishListProvider>()
                      .addRemoveFavoriteProduct(product ?? null);
                }
              });
            } else {
              GeneralMethods.showSnackBarMsg(
                  context, StringsRes.lblRequiredLoginMessageForWishlist,
                  requiredAction: true);
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: isListing == false
                ? BoxDecoration(color: Theme.of(context).cardColor)
                : BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        )
                      ]),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Constant.paddingOrMargin7,
                    horizontal: Constant.paddingOrMargin7),
                child: (providerContext
                                .read<ProductAddOrRemoveFavoriteProvider>()
                                .productAddRemoveFavoriteState ==
                            ProductAddRemoveFavoriteState.loading &&
                        providerContext
                                .read<ProductAddOrRemoveFavoriteProvider>()
                                .stateId ==
                            (product?.id ?? 0))
                    ? Widgets.getLoadingIndicator()
                    : Widgets.getDarkLightIcon(
                        iconColor: ColorsRes.appColor,
                        isActive: Constant.session.isUserLoggedIn()
                            ? providerContext
                                .read<ProductAddOrRemoveFavoriteProvider>()
                                .favoriteList
                                .contains(product?.id ?? 0)
                            : false,
                        image: "wishlist")),
          ),
        );
      },
    );
  }
}
