import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/models/ads/ads_helper.dart';
import 'package:mattar/network/local/shared_pref.dart';
import '../../cubit/cubit/app_cubit.dart';
import 'cubit/map_cubit_cubit.dart';

class Maps extends StatefulWidget {
  Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      MapCubitCubit()
        ..getmapDetails(),
      child: BlocConsumer<MapCubitCubit, MapCubitState>(
          listener: (context, state) {
            if (state is PostCoponSuccessful) {
              buildToast(text: "تم ادخال الكوبون بنجاح", color: secondColor);
            }
            if (state is PostCoponError) {
              buildToast(text: "كوبون غير صالح", color: Colors.red);
            }
          }, builder: (context, state) {
        String url = MapCubitCubit
            .caller(context)
            .mapModel
            ?.map ??
            "https://www.windy.com/?26.883,40.957,5";
        var h = CacheHelper.getData(key: "subscibtion") == null
            ? MediaQuery
            .of(context)
            .size
            .height -
            (AdmobBannerSize.FULL_BANNER.height + 180)
            : null;
        var w = MediaQuery
            .of(context)
            .size
            .width;
        return Stack(children: [
          ConditionalBuilder(
              condition: state is GetMapLoading,
              builder: (context) =>
              const Center(
                child: CircularProgressIndicator(),
              ),
              fallback: (context) => mapMethod(url, h, w, context)),
          const Tafseer(),
        ]);
      }),
    );
  }

  Widget mapMethod(String url, double? h, double w, BuildContext context) {
    return Column(
      children: [
        CacheHelper.getData(key: "subscibtion") == null
            ? AdmobBanner(
            adUnitId: AdsHelper.getBunnerAd(),
            adSize: AdmobBannerSize.FULL_BANNER)
            : const SizedBox(),
        Flexible(
          child: LayoutBuilder(builder: (context, constraint) {
            return Html(
                shrinkWrap: false,
                data:
                '<body style="margin-top: -250px;"><iframe  src="$url" style="overflow:hidden;" height="${h ??
                    constraint.maxHeight}" width="$w"></iframe></body>');
          }),
        )
      ],
    );
  }
}

class Tafseer extends StatefulWidget {
  const Tafseer({Key? key}) : super(key: key);

  @override
  State<Tafseer> createState() => _TafseerState();
}

class _TafseerState extends State<Tafseer> {
  String statues = '';
  late StreamSubscription subscribtion;

  Future checkConnection() async {
    final connictionState = await Connectivity().checkConnectivity();
    if (connictionState == ConnectivityResult.mobile) {
      setState(() {
        statues = "online";
      });
    } else if (connictionState == ConnectivityResult.wifi) {
      setState(() {
        statues = "online";
      });
    } else {
      setState(() {
        statues = "ofline";
      });
    }
  }

  @override
  void initState() {
    checkConnection();
    subscribtion = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        setState(() {
          statues = "online";
        });
      } else if (event == ConnectivityResult.wifi) {
        setState(() {
          statues = "online";
        });
      } else {
        setState(() {
          statues = "ofline";
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return statues == "ofline"
        ? Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "فشل الاتصال بالانترنت",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  "الرجاء التاكد من أن جهازك متصل بالانترنت ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "وحاول مرة اخري",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              defaultButton(
                  onPressed: () {
                    checkConnection();
                  },
                  textButton: "اعادة المحاولة",
                  width: 150,
                  backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
                  radius: 12)
            ],
          ),
        ))
        : const SizedBox();
  }
}