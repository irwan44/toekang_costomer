import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/productListProvider.dart';
import 'package:egrocer/helper/provider/productWishListProvider.dart';
import 'package:egrocer/helper/provider/sliderImagesProvider.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:egrocer/screens/mainHomeScreen/homeScreen/homeScreen.dart';
import 'package:egrocer/screens/mainHomeScreen/profileMenuScreen/profileMenuScreen.dart';
import 'package:egrocer/screens/mainHomeScreen/wishListScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'categoryListScreen.dart';

class HomeMainScreen extends StatefulWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.Online;
  int currentPage = 0;

  //total pageListing
  List<Widget> pages = [
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductListProvider>(
          create: (context) {
            return ProductListProvider();
          },
        ),
        ChangeNotifierProvider<SliderImagesProvider>(
            create: (context) => SliderImagesProvider())
      ],
      child: HomeScreen(),
    ),
    CategoryListScreen(),
    WishListScreen(),
    ProfileScreen()
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    checkConnectionState();
    super.initState();
  }

  //internet connection checking
  checkConnectionState() async {
    networkStatus = await GeneralMethods.checkInternet()
        ? NetworkStatus.Online
        : NetworkStatus.Offline;
    Connectivity().onConnectivityChanged.listen((status) {
      if (mounted) {
        setState(() {
          networkStatus = GeneralMethods.getNetworkStatus(status);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Widgets.homeBottomNavigation(
          currentPage, selectBottomMenu, pages.length, context),
      body: networkStatus == NetworkStatus.Online
          ? WillPopScope(
              onWillPop: () {
                if (currentPage == 0) {
                  return Future.value(true);
                } else {
                  if (mounted) {
                    setState(() {
                      currentPage = 0;
                    });
                  }
                  return Future.value(false);
                }
              },
              child: IndexedStack(
                index: currentPage,
                children: pages,
              ),
            )
          : Center(child: Text(StringsRes.lblCheckInternet)),
    );
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    if (mounted) {
      setState(() {
        if (currentPage == 2) {
          context
              .read<ProductWishListProvider>()
              .changeCurrentState(ProductWishListState.error);
        }
        currentPage = index;
      });
    }
  }
}
