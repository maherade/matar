import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_zoom_on_move/image_zoom_on_move.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mattar/component/constants.dart';
import 'package:mattar/layout/full_map_screen.dart';
import 'package:mattar/models/mattar%20video%20and%20image/video.dart';
import 'package:mattar/models/signup.dart';
import 'package:mattar/network/local/shared_pref.dart';
import 'package:path/path.dart' as p;
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/component.dart';
import '../cubit/cubit/app_cubit.dart';
import '../module/country model.dart';
import 'ads/ads_helper.dart';

// ignore: must_be_immutable
class WeatehrExpected extends StatefulWidget {
  WeatehrExpected({Key? key}) : super(key: key);

  @override
  State<WeatehrExpected> createState() => _WeatehrExpectedState();
}

class _WeatehrExpectedState extends State<WeatehrExpected> {
  TextEditingController commentController = TextEditingController();

  bool commentEntered = false;

  Future<void> share(String? title, String? text, String? url, String? chooserTitle) async {
    await FlutterShare.share(
        title: title ?? "",
        text: text,
        linkUrl: url,
        chooserTitle: chooserTitle);
  }

  List<TargetFocus> targets = [];

  final specialKey = GlobalKey();
  final publicKey = GlobalKey();
  String statues = 'online';
  late StreamSubscription subscribtion;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
          statues = "offline";
        });
      }
    });

    targets
        .add(TargetFocus(identify: "Target 1", keyTarget: publicKey, contents: [
      TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "قسم عام",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "يقوم بعرض أخبار الطقس و الخريطة  بشكل عام ",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )
              ],
            ),
          ))
    ]));
    targets.add(
        TargetFocus(identify: "Target 2", keyTarget: specialKey, contents: [
      TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "قسم خاص",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "يقوم بعرض الأخبار  و الخريطة الخاصة بالبلد المختارة من قبل  المستخدم  ",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )
              ],
            ),
          ))
    ]));
  }

  @override
  void dispose() {
    subscribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return ConnectivityBuilder(builder: (status) {
      return statues == "offline"
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
          : MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AppCubit()
                    ..getWeatherPostes()
                    ..getSelectedWeatherPosts(
                        countryId: CacheHelper.getData(key: 'countryId'))
                    ..getPrivateAds()
                    ..initAds()
                    ..getProfileData(),
                ),
                BlocProvider(create: (_) => CountriesCubit()),
              ],
              child: DefaultTabController(
                length: 2,
                child: BlocConsumer<AppCubit, ApppState>(
                  listener: (context, state) {
                    if (state is CommentSuccessfulState) {
                      buildToast(text: "تم الارسال", color: Colors.black);
                    }
                    if (state is CommentErrorState) {
                      buildToast(text: "تعذر الارسال ", color: Colors.black);
                    }
                    if (state is LikeSuccessfulState) {
                      buildToast(text: "تم الاعجاب", color: Colors.black);
                    }
                    if (state is LikeErrorState) {
                      buildToast(
                          text: "تم الاعجاب من قبل", color: Colors.black);
                    }
                  },
                  builder: (context, state) {
                    var cubit = AppCubit.caller(context);

                    List ind = [
                      1,
                      5,
                      9,
                      13,
                      17,
                      21,
                      25,
                      29,
                      33,
                      37,
                      41,
                      45,
                      49
                    ];

                    PageController photoController = PageController();
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        leadingWidth: double.infinity,
                        leading: TabBar(
                          tabs: [
                            InkWell(
                              onTap: () {
                                showTutorial();
                              },
                              child: Tab(
                                key: publicKey,
                                child: Text(
                                  "عام",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            // Navigator.push(context, MaterialPageRoute(builder: (_){
                            //
                            //   return adsScreen();
                            //
                            // }));
                            InkWell(
                              onTap: () {
                                showTutorial();
                              },
                              child: Tab(
                                key: specialKey,
                                child:
                                    BlocBuilder<CountriesCubit, CountryModel?>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "مخصص",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Offset offs = Offset(0, 0);
                                              final RenderBox button =
                                                  context.findRenderObject()!
                                                      as RenderBox;
                                              final RenderBox overlay =
                                                  Navigator.of(context)
                                                          .overlay!
                                                          .context
                                                          .findRenderObject()!
                                                      as RenderBox;
                                              final RelativeRect position =
                                                  RelativeRect.fromRect(
                                                Rect.fromPoints(
                                                  button.localToGlobal(offs,
                                                      ancestor: overlay),
                                                  button.localToGlobal(
                                                      button.size.bottomRight(
                                                              Offset.zero) +
                                                          offs,
                                                      ancestor: overlay),
                                                ),
                                                Offset.zero & overlay.size,
                                              );
                                              showMenu(
                                                  context: context,
                                                  position: position,
                                                  items: [
                                                    PopupMenuItem(
                                                        child: Text("fdf")),
                                                    PopupMenuItem(
                                                        child: Text("fdf")),
                                                    PopupMenuItem(
                                                        child: Text("fdf")),
                                                    PopupMenuItem(
                                                        child: Text("fdf")),
                                                    PopupMenuItem(
                                                        child: Text("fdf")),
                                                  ]);
                                            },
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ))
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: const Color.fromRGBO(66, 105, 129, 1),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          PageView.builder(
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              itemCount: cubit.posts.length,
                              pageSnapping: true,
                              itemBuilder: (ctx, index) {
                                return Scaffold(
                                    body: ind.contains(index) &&
                                            cubit.profile?.sub != true
                                        ? PageView.builder(
                                            itemCount: 1,
                                            itemBuilder: (c, n) {
                                              return cubit.adsModel
                                                          .isNotEmpty &&
                                                      index == 1
                                                  ? Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 20),
                                                        Text(
                                                            cubit.adsModel[n]
                                                                .title,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1
                                                                ?.copyWith(
                                                                    color: Colors
                                                                            .grey[
                                                                        600])),
                                                        Expanded(
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                3,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .5,
                                                            color: Colors.white,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Image.network(
                                                                "https://admin.rain-app.com/storage/ads/${cubit.adsModel[n].media}",
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return const Text(
                                                                  'Your error widget...');
                                                            }),
                                                          ),
                                                        ),
                                                        defaultButton(
                                                            onPressed:
                                                                () async {
                                                              cubit.increaseAdsClick(
                                                                  cubit
                                                                      .adsModel[
                                                                          n]
                                                                      .id);
                                                              try {
                                                                await canLaunch(cubit
                                                                        .adsModel[
                                                                            n]
                                                                        .redirect)
                                                                    ? await launch(cubit
                                                                        .adsModel[
                                                                            n]
                                                                        .redirect)
                                                                    : throw "could not fiend";
                                                              } catch (e) {
                                                                return;
                                                              }
                                                            },
                                                            textButton: "اذهب",
                                                            width: 150,
                                                            radius: 15),
                                                        const SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        Flexible(
                                                          flex: 0,
                                                          child: defaultButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        "ads");
                                                              },
                                                              textButton:
                                                                  "الغاء الاعلانات"),
                                                        ),
                                                        Flexible(
                                                          child: Builder(
                                                              builder: (ctx) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .pink)),
                                                              width: double
                                                                  .infinity,
                                                              child: Center(
                                                                child: AdmobBanner(
                                                                    adUnitId:
                                                                        AdsHelper
                                                                            .getBunnerAd(),
                                                                    adSize: AdmobBannerSize
                                                                        .SMART_BANNER(
                                                                            ctx)),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    );
                                            })
                                        : Column(children: [
                                            Stack(children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.35,
                                                  // color: Colors.black,
                                                  child: PageView.builder(
                                                      controller:
                                                          photoController,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: cubit
                                                          .posts[index]
                                                          .files
                                                          .length,
                                                      itemBuilder:
                                                          (ctx, photoind) {
                                                        final extension =
                                                            p.extension(cubit
                                                                .posts[index]
                                                                .files[photoind]
                                                                .file);

                                                        return extension ==
                                                                ".mp4"
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (_) {
                                                                    return FullMapScreen(
                                                                      index:
                                                                          index,
                                                                      image:
                                                                          "https://admin.rain-app.com/storage/outlooks/${cubit.posts[index].files[photoind].file}",
                                                                    );
                                                                  }));
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.5,
                                                                        child:
                                                                            PlayV(
                                                                          "https://admin.rain-app.com/storage/outlooks/${cubit.posts[index].files[photoind].file}",
                                                                        )),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (_) {
                                                                    return FullMapScreen(
                                                                      index:
                                                                          index,
                                                                      image:
                                                                          "https://admin.rain-app.com/storage/outlooks/${cubit.posts[index].files[photoind].file}",
                                                                    );
                                                                  }));
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.35,
                                                                        child:
                                                                            InteractiveViewer(
                                                                          child:
                                                                              ImageZoomOnMove(
                                                                            image:
                                                                                Image.network(
                                                                              "https://admin.rain-app.com/storage/outlooks/${cubit.posts[index].files[photoind].file}",
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                return Text("can not load image");
                                                                              },
                                                                            ),
                                                                          ),
                                                                        )),
                                                              );
                                                      })),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceEvenly,
                                              //   children: [
                                              //     Container(
                                              //       margin:
                                              //           const EdgeInsets.only(top: 8),
                                              //       padding: const EdgeInsets.symmetric(
                                              //           vertical: 5, horizontal: 20),
                                              //       height: 50,
                                              //       decoration: BoxDecoration(
                                              //           color: const Color.fromRGBO(
                                              //               66, 105, 129, 1),
                                              //           borderRadius:
                                              //               BorderRadius.circular(12)),
                                              //       child: Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment.spaceEvenly,
                                              //         children: [
                                              //           Text(
                                              //             "${CacheHelper.getData(key: "country")}",
                                              //             style: const TextStyle(
                                              //                 fontSize: 16,
                                              //                 color: Colors.white,
                                              //                 fontWeight:
                                              //                     FontWeight.bold),
                                              //           ),
                                              //           Image.network(
                                              //             "https://admin.rain-app.com/storage/countries/${CacheHelper.getData(key: "country")}.png",
                                              //             height: 50,
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     InkWell(
                                              //       onTap: () {
                                              //         Navigator.of(context)
                                              //             .pushReplacementNamed(
                                              //                 "country page");
                                              //       },
                                              //       child: Container(
                                              //         margin:
                                              //             const EdgeInsets.only(top: 8),
                                              //         width: 120,
                                              //         height: 50,
                                              //         decoration: BoxDecoration(
                                              //             color: whiteColor,
                                              //             borderRadius:
                                              //                 BorderRadius.circular(
                                              //                     12)),
                                              //         child: const Center(
                                              //           child: Text(
                                              //             "تغيير القسم",
                                              //             style: TextStyle(
                                              //                 color: Colors.black,
                                              //                 fontSize: 16,
                                              //                 fontWeight:
                                              //                     FontWeight.bold),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              cubit.posts[index].files.length >
                                                      1
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.34,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: SmoothPageIndicator(
                                                            axisDirection: Axis
                                                                .horizontal,
                                                            effect:
                                                                const WormEffect(
                                                                    dotHeight:
                                                                        12,
                                                                    dotWidth:
                                                                        12),
                                                            controller:
                                                                photoController,
                                                            count: cubit
                                                                .posts[index]
                                                                .files
                                                                .length),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ]),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      66, 105, 129, 1)),
                                              height: 42,
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              // color: const Color.fromRGBO(66, 105, 129, 1),
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Row(
                                                  children: [
                                                    defaultWeatherExpectedRowIcon(
                                                        text: cubit
                                                            .posts[index].date,
                                                        icon: Icons
                                                            .access_time_rounded),
                                                    defaultWeatherExpectedRowIcon(
                                                      onPressed: () async {
                                                        if (CacheHelper.getData(
                                                                key: "login") ==
                                                            null) {
                                                          await LogInDialog(
                                                              context);
                                                          return;
                                                        }
                                                        cubit.posts[index]
                                                            .liked = true;
                                                        cubit.sendLike(
                                                            outlookId: cubit
                                                                .posts[index]
                                                                .id);
                                                      },
                                                      child: cubit.posts[index]
                                                              .liked!
                                                          ? const Icon(
                                                              Icons.favorite,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 25,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color:
                                                                  Colors.white,
                                                              size: 25,
                                                            ),
                                                    ),
                                                    defaultWeatherExpectedRowIcon(
                                                        icon: Icons.comment,
                                                        onPressed: () {
                                                          showFlexibleBottomSheet(
                                                            minHeight: 0,
                                                            initHeight: 0.5,
                                                            maxHeight: 1,
                                                            bottomSheetColor:
                                                                Colors
                                                                    .transparent,
                                                            context: context,
                                                            builder: (context,
                                                                    scrollController,
                                                                    offset) =>
                                                                _buildBottomSheet(
                                                                    context,
                                                                    scrollController,
                                                                    cubit,
                                                                    index),
                                                            anchors: [
                                                              0,
                                                              0.5,
                                                              1
                                                            ],
                                                            isSafeArea: true,
                                                          );
                                                        }),
                                                    defaultWeatherExpectedRowIcon(
                                                      onPressed: () {
                                                        cubit.sendShare(
                                                            outlookId: cubit
                                                                .posts[index]
                                                                .id);
                                                        share(
                                                            cubit.posts[index]
                                                                .title,
                                                            cubit.posts[index]
                                                                .details,
                                                            "https://rain-app.com/outlook/${cubit.posts[index].id}",
                                                            "");
                                                      },
                                                      icon: Icons.share,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            cubit.profile?.sub != true
                                                ? AdmobBanner(
                                                    adUnitId:
                                                        AdsHelper.getBunnerAd(),
                                                    adSize: AdmobBannerSize
                                                        .FULL_BANNER)
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            /// description
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                ),
                                                //  color: backgroundColor,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 8),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(
                                                      bottom: 15),
                                                  decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [shadow()]),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        cubit.posts[index]
                                                                    .title !=
                                                                ""
                                                            ? Text(
                                                                cubit
                                                                    .posts[
                                                                        index]
                                                                    .title,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .pink,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))
                                                            : const SizedBox(),
                                                        ReadMoreText(
                                                          cubit.posts[index]
                                                              .details,
                                                          colorClickableText:
                                                              Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          style: const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          trimLines: 4,
                                                          trimCollapsedText:
                                                              'قراءة المزيد',
                                                          trimExpandedText:
                                                              'قراءة اقل',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]));
                              }),

                          //   ---------------------------  مخصص ----------------------------------
                          PageView.builder(
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              itemCount: cubit.selectedPosts.length,
                              pageSnapping: true,
                              itemBuilder: (ctx, index) {
                                return Scaffold(
                                    body: ind.contains(index) &&
                                            cubit.profile?.sub != true
                                        ? PageView.builder(
                                            itemCount: 1,
                                            itemBuilder: (c, n) {
                                              return cubit.adsModel
                                                          .isNotEmpty &&
                                                      index == 1
                                                  ? Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 20),
                                                        Text(
                                                            cubit.adsModel[n]
                                                                .title,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1
                                                                ?.copyWith(
                                                                    color: Colors
                                                                            .grey[
                                                                        600])),
                                                        Expanded(
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                3,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .5,
                                                            color: Colors.white,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Image.network(
                                                                "https://admin.rain-app.com/storage/ads/${cubit.adsModel[n].media}",
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return const Text(
                                                                  'Your error widget...');
                                                            }),
                                                          ),
                                                        ),
                                                        defaultButton(
                                                            onPressed:
                                                                () async {
                                                              cubit.increaseAdsClick(
                                                                  cubit
                                                                      .adsModel[
                                                                          n]
                                                                      .id);
                                                              try {
                                                                await canLaunch(cubit
                                                                        .adsModel[
                                                                            n]
                                                                        .redirect)
                                                                    ? await launch(cubit
                                                                        .adsModel[
                                                                            n]
                                                                        .redirect)
                                                                    : throw "could not fiend";
                                                              } catch (e) {
                                                                return;
                                                              }
                                                            },
                                                            textButton: "اذهب",
                                                            width: 150,
                                                            radius: 15),
                                                        const SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        Flexible(
                                                          flex: 0,
                                                          child: defaultButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        "ads");
                                                              },
                                                              textButton:
                                                                  "الغاء الاعلانات"),
                                                        ),
                                                        Flexible(
                                                          child: Builder(
                                                              builder: (ctx) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .pink)),
                                                              width: double
                                                                  .infinity,
                                                              child: Center(
                                                                child: AdmobBanner(
                                                                    adUnitId:
                                                                        AdsHelper
                                                                            .getBunnerAd(),
                                                                    adSize: AdmobBannerSize
                                                                        .SMART_BANNER(
                                                                            ctx)),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    );
                                            })
                                        : Column(children: [
                                            Stack(children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.35,
                                                  // color: Colors.black,
                                                  child: PageView.builder(
                                                      controller:
                                                          photoController,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: cubit
                                                          .selectedPosts[index]
                                                          .files!
                                                          .length,
                                                      itemBuilder:
                                                          (ctx, photoind) {
                                                        final extension =
                                                            p.extension(cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .files![
                                                                    photoind]
                                                                .file!);

                                                        return extension ==
                                                                ".mp4"
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (_) {
                                                                    return FullMapScreen(
                                                                      index:
                                                                          index,
                                                                      image:
                                                                          "https://admin.rain-app.com/api/outlooks/${cubit.selectedPosts[index].files![photoind].file}",
                                                                    );
                                                                  }));
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.5,
                                                                        child:
                                                                            PlayV(
                                                                          "https://admin.rain-app.com/api/outlooks/${cubit.selectedPosts[index].files?[photoind].file}",
                                                                        )),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (_) {
                                                                    return FullMapScreen(
                                                                      index:
                                                                          index,
                                                                      image:
                                                                          "https://admin.rain-app.com/storage/outlooks/${cubit.selectedPosts[index].files?[photoind].file}",
                                                                    );
                                                                  }));
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.35,
                                                                        child:
                                                                            InteractiveViewer(
                                                                          child:
                                                                              ImageZoomOnMove(
                                                                            image:
                                                                                Image.network(
                                                                              "https://admin.rain-app.com/storage/outlooks/${cubit.selectedPosts[index].files?[photoind].file}",
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                return Text("can not load image");
                                                                              },
                                                                            ),
                                                                          ),
                                                                        )),
                                                              );
                                                      })),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5,
                                                          horizontal: 20),
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              66, 105, 129, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            "${CacheHelper.getData(key: "country")}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Image.network(
                                                            "https://admin.rain-app.com/storage/countries/${CacheHelper.getData(key: "country")}.png",
                                                            height: 50,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                "country page");
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 8),
                                                        width: 120,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: whiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: const Center(
                                                          child: Text(
                                                            "تغيير القسم",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              cubit.selectedPosts[index].files!
                                                          .length >
                                                      1
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.34,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: SmoothPageIndicator(
                                                            axisDirection: Axis
                                                                .horizontal,
                                                            effect:
                                                                const WormEffect(
                                                                    dotHeight:
                                                                        12,
                                                                    dotWidth:
                                                                        12),
                                                            controller:
                                                                photoController,
                                                            count: cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .files!
                                                                .length),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ]),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      66, 105, 129, 1)),
                                              height: 42,
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              // color: const Color.fromRGBO(66, 105, 129, 1),
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Row(
                                                  children: [
                                                    defaultWeatherExpectedRowIcon(
                                                        text: cubit
                                                            .selectedPosts[
                                                                index]
                                                            .date,
                                                        icon: Icons
                                                            .access_time_rounded),
                                                    defaultWeatherExpectedRowIcon(
                                                      onPressed: () async {
                                                        if (CacheHelper.getData(
                                                                key: "login") ==
                                                            null) {
                                                          await LogInDialog(
                                                              context);
                                                          return;
                                                        }
                                                        // cubit.selectedPosts[index].likes = true;
                                                        cubit.sendLike(
                                                            outlookId: cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .id!);
                                                      },
                                                      child: cubit
                                                                  .selectedPosts[
                                                                      index]
                                                                  .likes ==
                                                              null
                                                          ? const Icon(
                                                              Icons.favorite,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 25,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color:
                                                                  Colors.white,
                                                              size: 25,
                                                            ),
                                                    ),
                                                    defaultWeatherExpectedRowIcon(
                                                        icon: Icons.comment,
                                                        onPressed: () {
                                                          showFlexibleBottomSheet(
                                                            minHeight: 0,
                                                            initHeight: 0.5,
                                                            maxHeight: 1,
                                                            bottomSheetColor:
                                                                Colors
                                                                    .transparent,
                                                            context: context,
                                                            builder: (context,
                                                                    scrollController,
                                                                    offset) =>
                                                                _buildBottomSheet(
                                                                    context,
                                                                    scrollController,
                                                                    cubit,
                                                                    index),
                                                            anchors: [
                                                              0,
                                                              0.5,
                                                              1
                                                            ],
                                                            isSafeArea: true,
                                                          );
                                                        }),
                                                    defaultWeatherExpectedRowIcon(
                                                      onPressed: () {
                                                        cubit.sendShare(
                                                            outlookId: cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .id!);
                                                        share(
                                                            cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .title,
                                                            cubit
                                                                .selectedPosts[
                                                                    index]
                                                                .details,
                                                            "https://admin.rain-app.com/api/outlooks/${cubit.selectedPosts[index].id}",
                                                            "");
                                                      },
                                                      icon: Icons.share,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            cubit.profile?.sub != true
                                                ? AdmobBanner(
                                                    adUnitId:
                                                        AdsHelper.getBunnerAd(),
                                                    adSize: AdmobBannerSize
                                                        .FULL_BANNER)
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            /// description
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                ),
                                                //  color: backgroundColor,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 8),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 15),
                                                  decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [shadow()]),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        cubit
                                                                    .selectedPosts[
                                                                        index]
                                                                    .title !=
                                                                ""
                                                            ? Text(
                                                                cubit
                                                                    .selectedPosts[
                                                                        index]
                                                                    .title!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .pink,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))
                                                            : const SizedBox(),
                                                        ReadMoreText(
                                                          cubit
                                                              .selectedPosts[
                                                                  index]
                                                              .details!,
                                                          colorClickableText:
                                                              Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          style: const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          trimLines: 4,
                                                          trimCollapsedText:
                                                              'قراءة المزيد',
                                                          trimExpandedText:
                                                              'قراءة اقل',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]));
                              }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
    });
  }

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
        statues = "offline";
      });
    }
  }

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(
        targets: targets,
        // List<TargetFocus>
        colorShadow: Colors.red,
        // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        // textSkip: "SKIP",
        // paddingFocus: 10,
        // focusAnimationDuration: Duration(milliseconds: 500),
        // unFocusAnimationDuration: Duration(milliseconds: 500),
        // pulseAnimationDuration: Duration(milliseconds: 500),
        // pulseVariation: Tween(begin: 1.0, end: 0.99),
        // showSkipInLastTarget: false,
        onFinish: () {
          print("finish");
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickTarget: (target) {
          print(target);
        },
        onSkip: () {
          print("skip");
        })
      ..show(context: context);

    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(); // call next target programmatically
    // tutorial.previous(); // call previous target programmatically
  }

  Widget _buildBottomSheet(BuildContext context,
      ScrollController scrollController, AppCubit cubit, int postIndex) {
    var commentsAndReplay = cubit.posts[postIndex].comments
        .where(((element) =>
            element.user.token == CacheHelper.getData(key: "token")))
        .toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: Colors.grey.shade200,
      ),
      child: GestureDetector(
        onVerticalDragDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              flex: 0,
              child: Text(
                "التعليقات",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            cubit.profile?.role == "admin"
                ? Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListView.builder(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: cubit.posts[postIndex].comments.length,
                    itemBuilder: (__, ind) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(200)),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(200),
                                  child: Image.asset("images/avatar.png"),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            right: 8),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                cubit
                                                    .posts[postIndex]
                                                    .comments[ind]
                                                    .user
                                                    .name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        66,
                                                        105,
                                                        129,
                                                        1))),
                                            Text(
                                                cubit
                                                    .posts[postIndex]
                                                    .comments[ind]
                                                    .comment,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18)),
                                          ],
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                TextEditingController
                                                replayController =
                                                TextEditingController();
                                                return AlertDialog(
                                                  actions: [
                                                    Form(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Flexible(
                                                            child:
                                                            Container(
                                                              color: Colors
                                                                  .white,
                                                              width: MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                                  0.6,
                                                              child: defaultFormField(
                                                                  prefixIcon:
                                                                  const Icon(Icons
                                                                      .comment),
                                                                  controller:
                                                                  replayController,
                                                                  type: TextInputType
                                                                      .text),
                                                            ),
                                                          ),
                                                          defaultIconButton(
                                                              onPressed:
                                                                  () {
                                                                cubit.sendReplay(
                                                                    outlookId: cubit
                                                                        .posts[
                                                                    postIndex]
                                                                        .id,
                                                                    commentId: cubit
                                                                        .posts[
                                                                    postIndex]
                                                                        .comments[
                                                                    ind]
                                                                        .id
                                                                        .toInt(),
                                                                    reply: replayController
                                                                        .text,
                                                                    context:
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: Icons
                                                                  .send,
                                                              color:
                                                              mainColor)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          "رد",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          cubit.post[postIndex].comments[ind].reply != ""
                              ? Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(200)),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(200),
                                  child: Image.asset(
                                      "images/icon.png"),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin:
                                          const EdgeInsets.only(
                                              right: 8),
                                          padding:
                                          const EdgeInsets.all(
                                              4),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10)),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text("ادمن",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color
                                                          .fromRGBO(
                                                          66,
                                                          105,
                                                          129,
                                                          1))),
                                              Text(
                                                  "${cubit.post[postIndex].comments[ind].reply}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize:
                                                      18)),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                              : const SizedBox(),
                        ],
                      );
                    }),
              ),
            )
                : const SizedBox(),
            commentsAndReplay.isNotEmpty && cubit.profile?.role != "admin"
                ? Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    itemCount: commentsAndReplay.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(200)),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(200),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(200),
                                    child: cubit.profile?.pic != null &&
                                        cubit.profile?.pic != ""
                                        ? CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                        CachedNetworkImageProvider(
                                            "https://admin.rain-app.com/storage/users/${cubit.profile?.pic}"))
                                        : Image.asset(
                                        "images/avatar.png"),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 8),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        commentsAndReplay[
                                                        index]
                                                            .user
                                                            .name,
                                                        style:
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            color: Color
                                                                .fromRGBO(
                                                                66,
                                                                105,
                                                                129,
                                                                1))),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                        intl.DateFormat.yMd()
                                                            .format(DateTime.parse(
                                                            commentsAndReplay[
                                                            index]
                                                                .date)),
                                                        style:
                                                        const TextStyle(
                                                            color: Colors
                                                                .grey,
                                                            fontSize:
                                                            12)),
                                                  ],
                                                ),
                                                Text(
                                                    commentsAndReplay[index]
                                                        .comment,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                              ],
                                            )),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          commentsAndReplay[index].reply == ""
                              ? const SizedBox(
                            height: 1,
                          )
                              : Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(200)),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(200),
                                  child: Image.asset(
                                      "images/icon.png"),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin:
                                          const EdgeInsets.only(
                                              right: 8),
                                          padding:
                                          const EdgeInsets.all(
                                              4),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10)),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text("ادمن",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color
                                                          .fromRGBO(
                                                          66,
                                                          105,
                                                          129,
                                                          1))),
                                              Text(
                                                  "${commentsAndReplay[index].reply}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize:
                                                      18)),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }),
              ),
            )
                : const SizedBox(),
            cubit.profile?.role != "admin"
                ? Flexible(
              flex: 0,
              child: Container(
                child: StatefulBuilder(builder: (context, setState) {
                  return TextField(
                    controller: commentController,
                    onChanged: (value) {
                      if (value.length == 1) {
                        setState(() => commentEntered = true);
                      }

                      if (value.isEmpty) {
                        setState(() => commentEntered = false);
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "اكتب تعليق ..",
                        prefixIcon: GestureDetector(
                          onTap: commentEntered
                              ? () {
                            if (CacheHelper.getData(key: "login") !=
                                null) {
                              cubit.profile?.sub != true
                                  ? cubit.admobInitSt.show()
                                  : SizedBox();
                              cubit.addComment(
                                  postIndex,
                                  commentController.text,
                                  cubit.posts[postIndex].id,
                                  cubit.profile!.id);
                              cubit.sendComment(
                                  outlookId:
                                  cubit.posts[postIndex].id,
                                  comment: commentController.text);
                            } else {
                              LogInDialog(context);
                            }
                          }
                              : null,
                          child: Icon(
                            Icons.send,
                            color: commentEntered
                                ? Color.fromRGBO(66, 105, 129, 1)
                                : Colors.grey,
                            textDirection: TextDirection.ltr,
                          ),
                        )),
                  );
                }),
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}