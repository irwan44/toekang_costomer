import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/homeScreenDataProvider.dart';
import 'package:egrocer/helper/provider/sliderImagesProvider.dart';
import 'package:egrocer/helper/provider/userProfileProvider.dart';
import 'package:egrocer/helper/repositories/appSettingsApi.dart';
import 'package:egrocer/helper/repositories/userDetailApi.dart';
import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/styles/designConfig.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/notificationUtility.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/models/homeScreenData.dart';
import 'package:egrocer/models/productListItem.dart';
import 'package:egrocer/screens/mainHomeScreen/homeScreen/widget/homeScreenProductListItem.dart';
import 'package:egrocer/screens/mainHomeScreen/widget/categoryItemContainer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/offerImagesWidget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sliderCurrentIndex = 0;
  TextEditingController edtSearch = TextEditingController();
  Map<String, List<String>> map = {};

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      await getAppSettings(context: context);

      NotificationUtility.setUpNotificationService(context);

      Map<String, String> params = await Constant.getProductsDefaultParams();
      await context
          .read<HomeScreenProvider>()
          .getHomeScreenApiProvider(context: context, params: params)
          .then((homeScreenData) async {
        map = await getSliderImages(homeScreenData);
      });

      if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
        await getUserDetail(context: context).then((value) {
          if (value[ApiAndParams.status] == 1) {
            context.read<UserProfileProvider>().updateUserDataInSession(value);
          }
        });
      }
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        final Uri deepLink = initialLink.link;
        if (deepLink.path.split("/")[1] == "product") {
          Navigator.pushNamed(context, productDetailScreen,
              arguments: [deepLink.path.split("/")[2].toString(), StringsRes.lblProductDetail, null]);
        }
      }

      await Constant.firebaseDynamicLinksInstance.onLink
          .listen((dynamicLinkData) {
        if (dynamicLinkData.link.path.split("/")[1] == "product") {
          Navigator.pushNamed(context, productDetailScreen, arguments: [
            dynamicLinkData.link.path.split("/")[2].toString(),
            StringsRes.lblProductDetail,
            null
          ]);
        }
      });
    });
  }

  Future<Map<String, List<String>>> getSliderImages(
      HomeScreenData homeScreenData) async {
    Map<String, List<String>> map = {};

    for (int i = 0; i < homeScreenData.offers.length; i++) {
      Offers offerImage = homeScreenData.offers[i];
      if (offerImage.position == "top") {
        addOfferImagesIntoMap(map, "top", offerImage.imageUrl);
      } else if (offerImage.position == "below_category") {
        addOfferImagesIntoMap(map, "below_category", offerImage.imageUrl);
      } else if (offerImage.position == "below_slider") {
        addOfferImagesIntoMap(map, "below_slider", offerImage.imageUrl);
      } else if (offerImage.position == "below_section") {
        addOfferImagesIntoMap(map,
            "below_section-${offerImage.sectionPosition}", offerImage.imageUrl);
      }
    }
    return map;
  }

  Map<String, List<String>> addOfferImagesIntoMap(
      Map<String, List<String>> map, String key, String imageUrl) {
    if (map.containsKey(key)) {
      map[key]?.add(imageUrl);
    } else {
      map[key] = [];
      map[key]?.add(imageUrl);
    }
    return map;
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
            title: deliverAddressWidget(),
            centerTitle: false,
            actions: [setCartCounter(context: context)]),
        body: Stack(
          children: [
            Column(
              children: [
                getSearchWidget(context: context),
                Expanded(
                  child: setRefreshIndicator(
                    refreshCallback: () async {
                      Map<String, String> params =
                          await Constant.getProductsDefaultParams();
                      return await context
                          .read<HomeScreenProvider>()
                          .getHomeScreenApiProvider(
                              context: context, params: params)
                          .then((homeScreenData) async {
                        map = await getSliderImages(homeScreenData);
                      });
                    },
                    child: SingleChildScrollView(
                      child: Consumer<HomeScreenProvider>(
                        builder: (context, homeScreenProvider, _) {
                          return homeScreenProvider.homeScreenState ==
                                  HomeScreenState.loaded
                              ? Column(
                                  children: [
                                    //top offer images
                                    if (map.containsKey("top"))
                                      getOfferImages(map["top"]!.toList()),
                                    sliderWidget(homeScreenProvider
                                        .homeScreenData.sliders),
                                    //below slider offer images
                                    if (map.containsKey("below_slider"))
                                      getOfferImages(
                                          map["below_slider"]!.toList()),
                                    categoryWidget(homeScreenProvider
                                        .homeScreenData.category),
                                    //below category offer images
                                    if (map.containsKey("below_category"))
                                      getOfferImages(
                                          map["below_category"]!.toList()),
                                    sectionWidget(homeScreenProvider
                                        .homeScreenData.sections)
                                  ],
                                )
                              : (homeScreenProvider.homeScreenState ==
                                          HomeScreenState.loading ||
                                      homeScreenProvider.homeScreenState ==
                                          HomeScreenState.initial)
                                  ? getHomeScreenShimmer()
                                  : Container();
                        },
                      ),
                    ),
                  ),
                )
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
        ));
  }

  // APP BAR UI STARTS
  deliverAddressWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, getLocationScreen, arguments: "location");
      },
      child: ListTile(
        contentPadding: EdgeInsetsDirectional.zero,
        horizontalTitleGap: 0,
        leading: Widgets.getDarkLightIcon(
            image: "home_map",
            height: 35,
            width: 35,
            padding: EdgeInsetsDirectional.only(
                top: Constant.paddingOrMargin10,
                bottom: Constant.paddingOrMargin10,
                end: Constant.paddingOrMargin10)),
        title: Text(
          StringsRes.lblDeliverTo,
          softWrap: true,
        ),
        subtitle: Constant.session.getData(SessionManager.keyAddress).isNotEmpty
            ? Text(
                Constant.session.getData(SessionManager.keyAddress),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                StringsRes.lblAddNewAddress,
                softWrap: true,
              ),
      ),
    );
  }

  // APP BAR UI ENDS

  // HOME PAGE UI STARTS
  //slider ui
  sliderWidget(List<Sliders> sliders) {
    return Consumer<SliderImagesProvider>(
      builder: (context, sliderImagesProvider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                if (mounted) {
                  if (sliders[sliderImagesProvider.currentSliderImageIndex]
                          .type ==
                      "slider_url") {
                    if (await canLaunchUrl(Uri.parse(
                        sliders[sliderImagesProvider.currentSliderImageIndex]
                            .sliderUrl))) {
                      await launchUrl(
                          Uri.parse(sliders[sliderImagesProvider
                                  .currentSliderImageIndex]
                              .sliderUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch ${sliders[sliderImagesProvider.currentSliderImageIndex].sliderUrl}';
                    }
                  } else if (sliders[
                              sliderImagesProvider.currentSliderImageIndex]
                          .type ==
                      "category") {
                    Navigator
                        .pushNamed(context, productListScreen, arguments: [
                      "category",
                      sliders[sliderImagesProvider.currentSliderImageIndex]
                          .typeId
                          .toString(),
                      sliders[sliderImagesProvider.currentSliderImageIndex]
                          .typeName
                    ]);
                  } else if (sliders[
                              sliderImagesProvider.currentSliderImageIndex]
                          .type ==
                      "product") {
                    Navigator
                        .pushNamed(context, productDetailScreen, arguments: [
                      sliders[sliderImagesProvider.currentSliderImageIndex]
                          .typeId
                          .toString(),
                      sliders[sliderImagesProvider.currentSliderImageIndex]
                          .typeName,
                      null
                    ]);
                  }
                }
              },
              child: CarouselSlider(
                items: List.generate(sliders.length, (index) {
                  Sliders sliderData = sliders[index];
                  return ClipRRect(
                      borderRadius: Constant.borderRadius10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Widgets.setNetworkImg(
                          image: sliderData.imageUrl, boxFit: BoxFit.fill));
                }), //Slider Container properties
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    sliderImagesProvider.setSliderCurrentIndexImage(index);
                  },
                  aspectRatio: 1.5 / 2.5,
                  height: 205.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOut,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 1.5,
                ),
              ),
            ),
            Widgets.getSizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(sliders.length, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 10,
                    width:
                        sliderImagesProvider.currentSliderImageIndex == index
                            ? 25
                            : 10,
                    margin: EdgeInsets.symmetric(
                        horizontal: Constant.paddingOrMargin5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: sliderImagesProvider.currentSliderImageIndex ==
                                index
                            ? Theme.of(context).primaryColor
                            : ColorsRes.mainTextColor,
                        shape: BoxShape.rectangle),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  //categoryList ui
  categoryWidget(List<Category>? categories) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
            color: Theme.of(context).cardColor,
            elevation: 0,
            margin: EdgeInsets.symmetric(
                horizontal: Constant.paddingOrMargin10,
                vertical: Constant.paddingOrMargin10),
            child: GridView.builder(
              itemCount: (categories!.length / 3) >= 6 ? 6 : 3,
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingOrMargin10,
                  vertical: Constant.paddingOrMargin10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Category category = categories[index];
                return CategoryItemContainer(
                    category: category,
                    voidCallBack: () {
                      Navigator.pushNamed(context, productListScreen,
                          arguments: [
                            "category",
                            category.id.toString(),
                            category.name
                          ]);
                    });
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ))
      ],
    );
  }

//sectionList ui
  sectionWidget(List<Sections>? sections) {
    return Column(
      children: List.generate(sections!.length, (index) {
        Sections section = sections[index];
        return section.products.isNotEmpty
            ? Column(
                children: [
                  Card(
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      margin: EdgeInsets.symmetric(
                          horizontal: Constant.paddingOrMargin10,
                          vertical: Constant.paddingOrMargin5),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constant.paddingOrMargin10,
                            vertical: Constant.paddingOrMargin10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section.title,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ColorsRes.appColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Widgets.getSizedBox(height: 5),
                                Text(
                                  section.shortDescription,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, productListScreen,
                                    arguments: [
                                      "sections",
                                      section.id.toString(),
                                      section.title
                                    ]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: DesignConfig.boxDecoration(
                                    ColorsRes.appColorLightHalfTransparent, 5,
                                    bordercolor: ColorsRes.appColor,
                                    isboarder: true,
                                    borderwidth: 1),
                                child: Text(StringsRes.lblSeeAll,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: ColorsRes.mainTextColor)),
                              ),
                            )
                          ],
                        ),
                      )),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(section.products.length, (index) {
                        ProductListItem product = section.products[index];
                        return HomeScreenProductListItem(
                          product: product,
                          position: index,
                        );
                      }),
                    ),
                  ),
                  //below section offer images

                  if (map.containsKey("below_section-${section.id}"))
                    getOfferImages(
                        map["below_section-${section.id}"]?.toList()),
                ],
              )
            : Container();
      }),
    );
  }

  Widget getHomeScreenShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Constant.paddingOrMargin10,
          horizontal: Constant.paddingOrMargin10),
      child: Column(
        children: [
          CustomShimmer(
            height: 180,
            width: MediaQuery.of(context).size.width,
          ),
          Widgets.getSizedBox(
            height: 10,
          ),
          CustomShimmer(
            height: 10,
            width: MediaQuery.of(context).size.width,
          ),
          Widgets.getSizedBox(
            height: 10,
          ),
          getCategoryShimmer(
              context: context, count: 6, padding: EdgeInsets.zero),
          Widgets.getSizedBox(
            height: 10,
          ),
          Column(
            children: List.generate(5, (index) {
              return Column(
                children: [
                  CustomShimmer(height: 50),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Constant.paddingOrMargin10,
                              horizontal: Constant.paddingOrMargin5),
                          child: CustomShimmer(
                            height: 210,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                        );
                      }),
                    ),
                  )
                ],
              );
            }),
          )
        ],
      ),
    );
  }

// HOME PAGE UI ENDS
}
