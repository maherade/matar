import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/layout/subscribing_screen.dart';
import 'package:mattar/network/local/shared_pref.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowMainPage extends StatelessWidget {
  const ShowMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        onStart: (index, key) {
          log('onStart: $index, $key');
        },
        onComplete: (index, key) {
          log('onComplete: $index, $key');
          if (index == 4) {
            CacheHelper.saveData(key: 'isShow', value: true);
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
            );
          }
        },
        blurValue: 1,
        builder: Builder(
            builder: (context) => CacheHelper.getData(key: 'isShow') == true
                ? NewMainLayout()
                : MainLayout()),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey _one = GlobalKey();

  final GlobalKey _two = GlobalKey();

  final GlobalKey _three = GlobalKey();

  final GlobalKey _four = GlobalKey();

  final GlobalKey _five = GlobalKey();

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    //Start showcase view after current widget frames are drawn.
    //NOTE: remove ambiguate function if you are using
    //flutter version greater than 3.x and direct use WidgetsBinding.instance
    (WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five]),
    );

    CacheHelper.saveData(key: 'isShow', value: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..checkCopon()
        ..getProfileData(),
      child: BlocConsumer<AppCubit, ApppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.caller(context);
          List title = [
            "التوقعات ومتابعة الحالات",
            "خرائط الطقس",
            "صور ومقاطع الطقس"
          ];

          return Scaffold(
            drawer: Showcase(
              key: _five,
              title: "قائمة جانبية",
              description:
                  'قائمة يوجد بها العديد من المميزات المفيدة و التي تسهل عليك التجرية',
              onBarrierClick: () => debugPrint('Barrier clicked'),
              child: InkWell(
                onTap: () {},
                child: Drawer(
                  backgroundColor: backgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        height: 90,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: AppCubit.caller(context).profile?.pic != null &&
                                AppCubit.caller(context).profile?.pic != ""
                            ? CachedNetworkImage(
                                imageUrl:
                                    "https://admin.rain-app.com/storage/users/${cubit.profile?.pic}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      color: Color.fromRGBO(66, 105, 129, 1),
                                    )),
                                errorWidget: (_, __, ___) =>
                                    Image.asset("images/avatar.png"))
                            : const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Image(
                                  image: AssetImage("images/avatar.png"),
                                  height: 55,
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CacheHelper.getData(key: "token") != null &&
                              cubit.profile?.name != null
                          ? Text("مرحبا ${cubit.profile?.name}")
                          : const SizedBox(
                              height: 1,
                            ),
                      const SizedBox(
                        height: 0,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            if (CacheHelper.getData(
                                      key: "login",
                                    ) ==
                                    false ||
                                CacheHelper.getData(
                                      key: "login",
                                    ) ==
                                    null)
                              defaultDrawerContainer(
                                  context: context,
                                  title: "تسجيل الدخول",
                                  onpressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("login");
                                  })
                            else
                              defaultDrawerContainer(
                                  context: context,
                                  title: "زيارة الملف الشخصي",
                                  onpressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("user acount");
                                  }),
                            defaultDrawerContainer(
                                context: context,
                                title: "إشتراك",
                                onpressed: () =>
                                    Navigator.of(context).pushNamed("sub")),
                            defaultDrawerContainer(
                                context: context,
                                title: "الكوبونات",
                                onpressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("myCopons");
                                }),
                            defaultDrawerContainer(
                                context: context,
                                title: "عن التطبيق",
                                onpressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("about");
                                }),
                            defaultDrawerContainer(
                                context: context,
                                title: "بلغ عن مشكلة",
                                onpressed: () => Navigator.of(context)
                                    .pushReplacementNamed("problem")),
                            defaultDrawerContainer(
                                context: context,
                                title: "تقييم التطبيق",
                                onpressed: () {}),
                            defaultDrawerContainer(
                                context: context,
                                title: "مشاركة التطبيق",
                                onpressed: () {}),
                            defaultDrawerContainer(
                                context: context,
                                title: "تطبيقات ومواقع مفيدة",
                                onpressed: () => Navigator.of(context)
                                    .pushReplacementNamed("apps")),
                            defaultDrawerContainer(
                                context: context,
                                title: "تابعنا عبر وسائل التواصل الاجتماعي ",
                                onpressed: () => Navigator.of(context)
                                    .pushReplacementNamed("social")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                title[cubit.currentIndex],
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                CacheHelper.getData(key: "index") == 1
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("main layout");
                        },
                        icon: const Icon(Icons.refresh_rounded)),
                Showcase(
                  key: _one,
                  title: "قسم التنبيهات ",
                  description:
                      ' امكانية وصول التنبيهات الي المستخدم عند وجود اشعار جديد',
                  onBarrierClick: () => debugPrint('Barrier clicked'),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("notification");
                      },
                      icon: const Icon(Icons.notifications_active)),
                )
              ],
              backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
            ),
            body: cubit.bottomNavScreen[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: whiteColor,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                onTap: (index) {
                  cubit.changeBottomNavIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Showcase(
                        key: _two,
                        title: "التوقعات و متابعة الحالات الجوية ",
                        description:
                            'ينقسم الي قسمين (قسم عام, قسم مخصص) قسم عام يحتوي علي أخبار و حالات الجو في جميع البلدان العربية أما قسم مخصص يقوم بعرض الحالات الجوية و الأخبار الخاصه بالدولة المختارة(يجب الإشتراك أو مشاهدة إعلان) ',
                        onBarrierClick: () => debugPrint('Barrier clicked'),
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: cubit.currentIndex == 0
                                    ? const Color.fromRGBO(66, 105, 129, 1)
                                    : null),
                            child: Image.asset(
                              "images/weather.png",
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                      label: "التوقعات ومتابعة الحالات"),
                  BottomNavigationBarItem(
                      icon: Showcase(
                        key: _three,
                        title: "خرائط الطقس",
                        description:
                            'يتم فيه عرض صور من القمر الصناعي لحالات الجو',
                        onBarrierClick: () => debugPrint('Barrier clicked'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: cubit.currentIndex == 1
                                  ? const Color.fromRGBO(66, 105, 129, 1)
                                  : null),
                          child: Image.asset(
                            "images/satellite.png",
                            height: 25,
                          ),
                        ),
                      ),
                      label: title[1]),
                  BottomNavigationBarItem(
                      label: title[2],
                      icon: Showcase(
                        key: _four,
                        title: "صور و مقاطع الطقس",
                        description:
                            'يتم فيه عرض صور و فيديوهات لحالات الطقس من البلاد',
                        onBarrierClick: () => debugPrint('Barrier clicked'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: cubit.currentIndex == 2
                                  ? const Color.fromRGBO(66, 105, 129, 1)
                                  : null),
                          child: Image.asset(
                            "images/camera.png",
                            height: 25,
                          ),
                        ),
                      )),
                ]),
          );
        },
      ),
    );
  }
}

class NewMainLayout extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..checkCopon()
        ..getProfileData(),
      child: BlocConsumer<AppCubit, ApppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.caller(context);
          List title = [
            "التوقعات ومتابعة الحالات",
            "خرائط الطقس",
            "صور ومقاطع الطقس"
          ];

          return Scaffold(
            drawer: InkWell(
              onTap: () {},
              child: Drawer(
                backgroundColor: backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: AppCubit.caller(context).profile?.pic != null &&
                          AppCubit.caller(context).profile?.pic != ""
                          ? CachedNetworkImage(
                              imageUrl:
                                  "https://admin.rain-app.com/storage/users/${cubit.profile?.pic}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                    color: Color.fromRGBO(66, 105, 129, 1),
                                  )),
                              errorWidget: (_, __, ___) =>
                                  Image.asset("images/avatar.png"))
                          : const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Image(
                                image: AssetImage("images/avatar.png"),
                                height: 55,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CacheHelper.getData(key: "token") != null &&
                            cubit.profile?.name != null
                        ? Text("مرحبا ${cubit.profile?.name}")
                        : const SizedBox(
                            height: 1,
                          ),
                    const SizedBox(
                      height: 0,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          if (CacheHelper.getData(
                                    key: "login",
                                  ) ==
                                  false ||
                              CacheHelper.getData(
                                    key: "login",
                                  ) ==
                                  null)
                            defaultDrawerContainer(
                                context: context,
                                title: "تسجيل الدخول",
                                onpressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("login");
                                })
                          else
                            defaultDrawerContainer(
                                context: context,
                                title: "زيارة الملف الشخصي",
                                onpressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("user acount");
                                }),
                          defaultDrawerContainer(
                              context: context,
                              title: "إشتراك",
                              onpressed: () =>
                                  Navigator.of(context).pushNamed("sub")),
                          defaultDrawerContainer(
                              context: context,
                              title: "الكوبونات",
                              onpressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("myCopons");
                              }),
                          defaultDrawerContainer(
                              context: context,
                              title: "عن التطبيق",
                              onpressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("about");
                              }),
                          defaultDrawerContainer(
                              context: context,
                              title: "بلغ عن مشكلة",
                              onpressed: () => Navigator.of(context)
                                  .pushReplacementNamed("problem")),
                          defaultDrawerContainer(
                              context: context,
                              title: "تقييم التطبيق",
                              onpressed: () {}),
                          defaultDrawerContainer(
                              context: context,
                              title: "مشاركة التطبيق",
                              onpressed: () {}),
                          defaultDrawerContainer(
                              context: context,
                              title: "تطبيقات ومواقع مفيدة",
                              onpressed: () => Navigator.of(context)
                                  .pushReplacementNamed("apps")),
                          defaultDrawerContainer(
                              context: context,
                              title: "تابعنا عبر وسائل التواصل الاجتماعي ",
                              onpressed: () => Navigator.of(context)
                                  .pushReplacementNamed("social")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                title[cubit.currentIndex],
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                CacheHelper.getData(key: "index") == 1
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("main layout");
                        },
                        icon: const Icon(Icons.refresh_rounded)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("notification");
                    },
                    icon: const Icon(Icons.notifications_active))
              ],
              backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
            ),
            body: cubit.bottomNavScreen[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: whiteColor,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                onTap: (index) {
                  cubit.changeBottomNavIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: cubit.currentIndex == 0
                                  ? const Color.fromRGBO(66, 105, 129, 1)
                                  : null),
                          child: Image.asset(
                            "images/weather.png",
                            height: 25,
                          ),
                        ),
                      ),
                      label: "التوقعات ومتابعة الحالات"),
                  BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: cubit.currentIndex == 1
                                ? const Color.fromRGBO(66, 105, 129, 1)
                                : null),
                        child: Image.asset(
                          "images/satellite.png",
                          height: 25,
                        ),
                      ),
                      label: title[1]),
                  BottomNavigationBarItem(
                      label: title[2],
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: cubit.currentIndex == 2
                                ? const Color.fromRGBO(66, 105, 129, 1)
                                : null),
                        child: Image.asset(
                          "images/camera.png",
                          height: 25,
                        ),
                      )),
                ]),
          );
        },
      ),
    );
  }
}
