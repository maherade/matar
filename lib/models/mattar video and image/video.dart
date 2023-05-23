import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/models/ads/ads_helper.dart';
import 'package:mattar/models/mattar%20video%20and%20image/cubit/cubit/video_cubit.dart';
import 'package:mattar/network/local/shared_pref.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Videos extends StatefulWidget {
  Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  String statues = 'online';

  @override
  Widget build(BuildContext context) {
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
                        Navigator.of(context)
                            .pushReplacementNamed("main layout");
                      },
                      textButton: "اعادة المحاولة",
                      width: 150,
                      backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
                      radius: 12)
                ],
              ),
            ))
          : BlocProvider(
              create: (context) => VideoCubit()
                ..getVideoPostes()
                ..getPrivateAds(),
              child: BlocConsumer<VideoCubit, VideoState>(
                listener: (context, state) {},
                builder: (context, state) {
                  PageController controller = PageController();
                  var cubit = VideoCubit.caller(context);
                  List ind = [1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49];
                  Future<void> share(String title, String text, String url,
                      String chooserTitle) async {
                    await FlutterShare.share(
                        title: title,
                        text: text,
                        linkUrl: url,
                        chooserTitle: chooserTitle);
                  }

                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: cubit.posts.length,
                    controller: controller,
                    // onPageChanged: (__) {
                    //   print(
                    //       "the number of ggggggggggggggggggggggggggggggggggggg ${controller.position}");
                    // },
                    itemBuilder: (ctx, index) {
                      if (ind.contains(index) == false) {}
                      final extension = p.extension(cubit.posts[index].media);
                      return ind.contains(index) &&
                                  CacheHelper.getData(key: "subscibtion") !=
                                      true ||
                              ind.contains(index) &&
                                  CacheHelper.getData(key: "subscibtion") !=
                                      true ||
                              ind.contains(index) &&
                                  CacheHelper.getData(key: "subscibtion") !=
                                      true
                          ? PageView.builder(
                              itemCount: 1,
                              itemBuilder: (c, n) {
                                return cubit.adsModel.isNotEmpty && index == 1
                                    ? Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(cubit.adsModel[n].title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                      color: Colors.grey[600])),
                                          Expanded(
                                            child: Container(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(10),
                                              child: Image.network(
                                                  "https://admin.rain-app.com/storage/ads/${cubit.adsModel[n].media}",
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return const Text(
                                                    'Your error widget...');
                                              }),
                                            ),
                                          ),
                                          defaultButton(
                                              onPressed: () async {
                                                try {
                                                  await canLaunch(cubit
                                                          .adsModel[n].redirect)
                                                      ? await launch(cubit
                                                          .adsModel[n].redirect)
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
                                          defaultButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed("ads");
                                              },
                                              textButton: "الغاء الاعلانات"),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                250,
                                            width: double.infinity,
                                            child: Center(
                                              child: AdmobBanner(
                                                  adUnitId:
                                                      AdsHelper.getBunnerAd(),
                                                  adSize: AdmobBannerSize
                                                      .MEDIUM_RECTANGLE),
                                            ),
                                          ),
                                        ],
                                      );
                              })
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  extension == ".mp4"
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: PlayVideo(
                                            "https://admin.rain-app.com/storage/weather-shots/${cubit.posts[index].media}",
                                          ),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            "https://admin.rain-app.com/storage/weather-shots/${cubit.posts[index].media}",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                  Positioned(
                                      bottom: 70,
                                      right: 8,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // boxShadow: [shadow()],
                                            ),
                                            child: defaultIconButton(
                                                onPressed: () {
                                                  if (CacheHelper.getData(
                                                          key: "token") ==
                                                      null) {
                                                    LogInDialog(context);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            "addvideo");
                                                  }
                                                },
                                                icon: Icons.add,
                                                color: Colors.black,
                                                iconSize: 30),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [shadow()],
                                            ),
                                            child: defaultIconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      builder:
                                                          (BuildContext ctx) {
                                                        return AlertDialog(
                                                          content: SizedBox(
                                                            height: 170,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  rowAndIcon(
                                                                      icon: Icons
                                                                          .camera_enhance_rounded,
                                                                      text: cubit
                                                                          .posts[
                                                                              index]
                                                                          .photographer),
                                                                  rowAndIcon(
                                                                      icon: Icons
                                                                          .location_city,
                                                                      text: cubit
                                                                          .posts[
                                                                              index]
                                                                          .location),
                                                                  rowAndIcon(
                                                                      icon: Icons
                                                                          .av_timer_sharp,
                                                                      text: cubit
                                                                          .posts[
                                                                              index]
                                                                          .date),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  defaultButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            ctx),
                                                                    textButton:
                                                                        "أغلاق",
                                                                    backgroundColor:
                                                                        exitColor,
                                                                    width: 100,
                                                                    radius: 12,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: Icons.info,
                                                color: Colors.black,
                                                iconSize: 30),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [shadow()],
                                            ),
                                            child: defaultIconButton(
                                                onPressed: () {
                                                  share(
                                                      cubit.posts[index]
                                                          .photographer,
                                                      "",
                                                      "https://rain-app.com/shot/${cubit.posts[index].id}",
                                                      "chooserTitle");
                                                  cubit.sendShare(
                                                      id: cubit
                                                          .posts[index].id);
                                                },
                                                icon: Icons.share,
                                                color: Colors.black,
                                                iconSize: 30),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            );
                    },
                  );
                },
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
}

Widget rowAndIcon({required IconData icon, required String text}) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.black,
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(
          maxLines: 10,
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

class PlayVideo extends StatefulWidget {
  late String url;

  // late int ratioHeight;
  // late int ratioWidth;
  PlayVideo(this.url);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();

    // chewieController = ChewieController(
    //   videoPlayerController: videoController,
    //   autoInitialize: true,

    //   autoPlay: true,
    //   // aspectRatio: widget.ratioWidth / widget.ratioHeight,
    //   allowFullScreen: true,
    //   looping: false,
    // );
    super.initState();
  }

  void dispose() {
    videoController..dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: videoController.value.isInitialized
          ? VideoPlayer(videoController)
          : Container(),
    );
  }
}

class PlayV extends StatefulWidget {
  late String url;

  // late int ratioHeight;
  // late int ratioWidth;
  PlayV(this.url);

  @override
  State<PlayV> createState() => _PlayVState();
}

class _PlayVState extends State<PlayV> {
  @override
  late VideoPlayerController videoController;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();

    // chewieController = ChewieController(
    //   videoPlayerController: videoController,
    //   autoInitialize: true,

    //   autoPlay: true,
    //   // aspectRatio: widget.ratioWidth / widget.ratioHeight,
    //   allowFullScreen: true,
    //   looping: false,
    // );
    super.initState();
  }

  void dispose() {
    videoController..dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: videoController.value.isInitialized
          ? VideoPlayer(videoController)
          : Container(),
    );
  }
}
