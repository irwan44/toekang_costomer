import 'package:country_code_picker/country_localizations.dart';
import 'package:egrocer/firebase_options.dart';
import 'package:egrocer/helper/generalWidgets/widgets.dart';
import 'package:egrocer/helper/provider/cartListProvider.dart';
import 'package:egrocer/helper/provider/categoryProvider.dart';
import 'package:egrocer/helper/provider/faqListProvider.dart';
import 'package:egrocer/helper/provider/productChangeListingProvider.dart';
import 'package:egrocer/helper/provider/productWishListProvider.dart';
import 'package:egrocer/helper/provider/userProfileProvider.dart';
import 'package:egrocer/helper/styles/colorsRes.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/provider/cityByLatLongProvider.dart';
import 'helper/provider/homeScreenDataProvider.dart';
import 'helper/sessionManager.dart';
import 'helper/utils/appLocalization.dart';
import 'helper/utils/constant.dart';
import 'helper/utils/stringsRes.dart';
import 'screens/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() =>
      Constant.firebaseDynamicLinksInstance = FirebaseDynamicLinks.instance);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    runApp(MyApp(
      prefs: prefs,
    ));
  });
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryListProvider>(
          create: (context) {
            return CategoryListProvider();
          },
        ),
        ChangeNotifierProvider<CityByLatLongProvider>(
          create: (context) {
            return CityByLatLongProvider();
          },
        ),
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (context) {
            return HomeScreenProvider();
          },
        ),
        ChangeNotifierProvider<ProductChangeListingTypeProvider>(
          create: (context) {
            return ProductChangeListingTypeProvider();
          },
        ),
        ChangeNotifierProvider<FaqProvider>(
          create: (context) {
            return FaqProvider();
          },
        ),
        ChangeNotifierProvider<ProductWishListProvider>(
          create: (context) {
            return ProductWishListProvider();
          },
        ),
        ChangeNotifierProvider<ProductAddOrRemoveFavoriteProvider>(
          create: (context) {
            return ProductAddOrRemoveFavoriteProvider();
          },
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) {
            return UserProfileProvider();
          },
        ),
        ChangeNotifierProvider<CartListProvider>(
          create: (context) {
            return CartListProvider();
          },
        ),
      ],
      child: ChangeNotifierProvider<SessionManager>(
        create: (_) => SessionManager(prefs: widget.prefs),
        child: Consumer<SessionManager>(
            builder: (context, SessionManager sessionNotifier, child) {
          Constant.session = Provider.of<SessionManager>(context);
          Constant.searchedItemsHistoryList = Constant.session.prefs
                  .getStringList(SessionManager.keySearchHistory) ??
              [];

          Locale currLang = Constant.session.getCurrLang();

          final window = WidgetsBinding.instance.window;

          // This callback is called every time the brightness changes from the device.
          window.onPlatformBrightnessChanged = () {
            if (Constant.session.getData(SessionManager.appThemeName) ==
                Constant.themeList[0]) {
              Constant.session.setBoolData(SessionManager.isDarkTheme,
                  window.platformBrightness == Brightness.dark, true);
            }
          };

          return MaterialApp(
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: "/",
            scrollBehavior: ScrollGlowBehavior(),
            debugShowCheckedModeBanner: false,
            locale: currLang,
            title: StringsRes.appName,
            theme: ColorsRes.setAppTheme(),
            home: SplashScreen(),
            localizationsDelegates: [
              CountryLocalizations.delegate,
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Constant.supportedLanguages.map((languageCode) {
              return GeneralMethods.getLocaleFromLangCode(languageCode);
            }).toList(),
          );
        }),
      ),
    );
  }
}
