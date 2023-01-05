import 'package:egrocer/helper/generalWidgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/addressListProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatefulWidget {
  final String? from;

  AddressListScreen({Key? key, this.from = ""}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<AddressProvider>().hasMoreData) {
        context.read<AddressProvider>().getAddressProvider(context: context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //fetch cartList from api
    Future.delayed(Duration.zero).then((value) async {
      await context
          .read<AddressProvider>()
          .getAddressProvider(context: context);

      scrollController.addListener(scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            StringsRes.lblAddress,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return Stack(
            children: [
              setRefreshIndicator(
                  refreshCallback: () async {
                    context.read<AddressProvider>().offset = 0;
                    context.read<AddressProvider>().addresses = [];
                    await context
                        .read<AddressProvider>()
                        .getAddressProvider(context: context);
                  },
                  child: Column(
                    children: [
                      Expanded(
                          child: (addressProvider.addressState ==
                                      AddressState.loaded ||
                                  addressProvider.addressState ==
                                      AddressState.editing)
                              ? ListView(
                                  controller: scrollController,
                                  children: [
                                    Column(
                                      children: List.generate(
                                          addressProvider.addresses.length,
                                          (index) {
                                        AddressData address =
                                            addressProvider.addresses[index];
                                        return GestureDetector(
                                          onTap: () {
                                            if (widget.from == "checkout") {
                                              Navigator.pop(context, address);
                                            } else {
                                              addressProvider
                                                  .setSelectedAddress(
                                                      address.id);
                                            }
                                          },
                                          child: Card(
                                            color: Theme.of(context).cardColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  Constant.paddingOrMargin10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    addressProvider
                                                                .selectedAddressId ==
                                                            address.id
                                                        ? Icons
                                                            .radio_button_on_outlined
                                                        : Icons
                                                            .radio_button_off_rounded,
                                                    color: addressProvider
                                                                .selectedAddressId ==
                                                            address.id
                                                        ? ColorsRes.appColor
                                                        : ColorsRes.grey,
                                                  ),
                                                  Widgets.getSizedBox(width: 5),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              address.name,
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    addressDetailScreen,
                                                                    arguments: [
                                                                      address,
                                                                      context
                                                                    ]);
                                                              },
                                                              child: Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    DesignConfig
                                                                        .boxGradient(
                                                                            5),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                margin:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child: Widgets.defaultImg(
                                                                    image:
                                                                        "edit_icon",
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                    height: 20,
                                                                    width: 20),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Widgets.getSizedBox(
                                                            height: 7),
                                                        Text(
                                                          "${address.area},${address.landmark}, ${address.address}, ${address.state}, ${address.city}, ${address.country} - ${address.pincode} ",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              /*fontSize: 18,*/
                                                              color: ColorsRes
                                                                  .subTitleTextColor),
                                                        ),
                                                        Widgets.getSizedBox(
                                                            height: 7),
                                                        Text(
                                                          address.mobile,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              /*fontSize: 18,*/
                                                              color: ColorsRes
                                                                  .subTitleTextColor),
                                                        ),
                                                        Widgets.getSizedBox(
                                                            height: 7),
                                                        GestureDetector(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    AddressProvider>()
                                                                .deleteAddress(
                                                                    address:
                                                                        address,
                                                                    context:
                                                                        context);
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: Constant
                                                                    .paddingOrMargin5,
                                                                horizontal: Constant
                                                                    .paddingOrMargin7),
                                                            decoration:
                                                                DesignConfig
                                                                    .boxDecoration(
                                                              ColorsRes
                                                                  .appColorRed,
                                                              5,
                                                              isboarder: false,
                                                            ),
                                                            child: Text(
                                                                StringsRes
                                                                    .lblDeleteAddress,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelSmall
                                                                    ?.copyWith(
                                                                        color: ColorsRes
                                                                            .appColorWhite)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    if (addressProvider.addressState ==
                                        AddressState.loadingMore)
                                      getAddressShimmer(),
                                  ],
                                )
                              : addressProvider.addressState ==
                                      AddressState.loading
                                  ? getAddressListShimmer()
                                  : addressProvider.addressState ==
                                          AddressState.error
                                      ? DefaultBlankItemMessageScreen(
                                          image: "no_address_icon",
                                          title:
                                              StringsRes.lblNoAddressFoundTitle,
                                          description: StringsRes
                                              .lblNoAddressFoundDescription,
                                        )
                                      : SizedBox.shrink()),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constant.paddingOrMargin10,
                              vertical: Constant.paddingOrMargin10),
                          child: Widgets.gradientBtnWidget(context, 10,
                              isSetShadow: false, callback: () {
                            Navigator.pushNamed(context, addressDetailScreen,
                                arguments: [null, context]);
                          }, title: StringsRes.lblAddNewAddress)),
                    ],
                  )),
              if (addressProvider.addressState == AddressState.editing)
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  start: 0,
                  bottom: 0,
                  child: Container(
                      color: ColorsRes.appColorBlack.withOpacity(0.2),
                      child: Center(child: CircularProgressIndicator())),
                )
            ],
          );
        },
      ),
    );
  }

  getAddressShimmer() {
    return CustomShimmer(
      borderRadius: Constant.paddingOrMargin10,
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.all(Constant.paddingOrMargin5),
    );
  }

  getAddressListShimmer() {
    return ListView(
      children: List.generate(10, (index) => getAddressShimmer()),
    );
  }
}
