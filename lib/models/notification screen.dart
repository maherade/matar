import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/network/local/shared_pref.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  GlobalKey<RefreshIndicatorState> refreshControl =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getNotificationData(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final dio = Dio();
                  final cancelToken = CancelToken();
                  if (dio.options.responseType == 200) {
                    await dio.get(
                        'https://admin.rain-app.com/storage/notifications',
                        cancelToken: cancelToken);
                  } else {
                    print(
                        'Something Went wrong:::::${dio.options.responseType.toString()}');
                  }
                },
                icon: const Icon(Icons.notifications_off))
          ],
          title: Text(
            "التنبيهات",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
        ),
        body: SafeArea(
          child: BlocBuilder<AppCubit, ApppState>(
            builder: (context, state) {
              var cubit = AppCubit.caller(context);
              var notiFilterData;
              notiFilterData = cubit.notificationData.where((e) {
                if (CacheHelper.getData(key: "login") != true) {
                  return e.appearanceFor.contains("public") ||
                      e.country.contains("عام") ||
                      e.appearanceFor.contains("duo") ||
                      e.country
                          .contains(CacheHelper.getData(key: "Noticountry"));
                } else {
                  return e.appearanceFor.contains("accounts") ||
                      e.country.contains("عام") ||
                      e.appearanceFor.contains("duo") ||
                      e.country
                          .contains(CacheHelper.getData(key: "Noticountry"));
                }
              }).toList();

              return RefreshIndicator(
                onRefresh: () => cubit.getNotificationData(),
                color: Color.fromRGBO(66, 105, 129, 1),
                key: refreshControl,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: notiFilterData.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          "noti details",
                                          arguments: notiFilterData[index]);
                                      // try {
                                      //   await canLaunch(cubit
                                      //           .notificationData[index].redirect)
                                      //       ? await launch(
                                      //           enableJavaScript: true,
                                      //           forceWebView: true,
                                      //           cubit
                                      //               .notificationData[index].redirect)
                                      //       : throw "could not fiend";
                                      // } catch (e) {}
                                    },
                                    child: notiContainer(
                                        content: notiFilterData[index].content,
                                        date: notiFilterData[index].date,
                                        image:
                                        "https://admin.rain-app.com/storage/notifications/${notiFilterData[index].media}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                    child: Divider(color: Colors.black.withOpacity(.5),),
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
