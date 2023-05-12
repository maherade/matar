import 'package:admob_flutter/admob_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/dio%20helper/dio_helper.dart';
import 'package:mattar/layout/main%20layout.dart';
import 'package:mattar/layout/subscribing_screen.dart';
import 'package:mattar/models/country/counteryScreen2.dart';
import 'package:mattar/models/country/cubit/cubit/country_cubit.dart';
import 'package:mattar/models/drawer_screens/aboutScreen.dart';
import 'package:mattar/models/drawer_screens/ads_screen.dart';
import 'package:mattar/models/drawer_screens/my_copon_screen.dart';
import 'package:mattar/models/drawer_screens/notification%20=_details.dart';
import 'package:mattar/models/drawer_screens/problems.dart';
import 'package:mattar/models/forget%20password/code_verfication_screen.dart';
import 'package:mattar/models/forget%20password/send_link_screen.dart';
import 'package:mattar/models/login.dart';
import 'package:mattar/models/map/maps.dart';
import 'package:mattar/models/mattar%20video%20and%20image/add_video.dart';
import 'package:mattar/models/notification%20screen.dart';
import 'package:mattar/models/signup.dart';
import 'package:mattar/models/starting_page.dart';
import 'package:mattar/models/user_account/user%20acount.dart';

import 'component/constants.dart';
import 'models/country/country screen.dart';
import 'models/drawer_screens/appScreen.dart';
import 'models/drawer_screens/social_media.dart';
import 'models/mattar video and image/cubit/cubit/video_cubit.dart';
import 'network/local/shared_pref.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ShopDioHelper.shopDioInit();
  await CacheHelper.init();
  Admob.initialize();
  print(CacheHelper.getData(key: "token"));
  print(DateTime.now().add(Duration(days: 5)));
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  print("$onBoarding");
  String? countrySkaped = CacheHelper.getData(key: 'country');
  runApp(MyApp(onBoarding, countrySkaped));
}

class MyApp extends StatelessWidget {
  bool? onBoarding;
  String? countrySkaped;

  MyApp(this.onBoarding, this.countrySkaped);

  late Widget widget;

  @override
  Widget build(BuildContext context) {
    if (onBoarding != null) {
      if (onBoarding == true) {
        widget = const StartingPage();
      } else {
        if (countrySkaped != null) {
          widget = const MainLayout();
        } else {
          widget = const CountryScreen();
        }
      }
    } else {
      widget = const StartingPage();
    }
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AppCubit()..initAds()),
          BlocProvider(create: (ctx) => VideoCubit()),
          BlocProvider(create: (ctx) => CountryCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
                headline1: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
                bodyText1: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale("ar", "AE")],
          locale: const Locale("ar", "AE"),
          home: AnimatedSplashScreen(
              backgroundColor: mainColor,
              splash: 'images/splash.png',
              nextScreen: widget,
              splashTransition: SplashTransition.rotationTransition),
          routes: {
            "login": (context) => LogIn(),
            "signup": (context) => SignUp(),
            "main layout": (context) => const MainLayout(),
            "country page": (context) => const CountryScreen(),
            "country page2": (context) => const CountryScreen2(),
            "notification": (context) => NotificationScreen(),
            "user acount": (context) => UserAccount(),
            "addvideo": (context) => AddVideo(),
            "problem": (context) => ProblemsScreen(),
            "about": (context) => const AboutScreen(),
            "apps": (context) => const AppsScreen(),
            "social": (context) => const SocialMedia(),
            "myCopons": (context) => const MyCopons(),
            "noti details": (context) => const NotiDetails(),
            'ads': (context) => adsScreen(),
            'sub': (context) => SubscribingScreen(),
            "map": (context) => Maps(),
            "send linke": (context) => const SendLinke(),
            "code ver": (context) => const CodeVer(),
          },
        ));
  }
}
