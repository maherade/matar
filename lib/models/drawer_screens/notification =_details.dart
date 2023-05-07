import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mattar/component/component.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../module/notification model.dart';

class NotiDetails extends StatelessWidget {
  const NotiDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationModel data =
        ModalRoute.of(context)?.settings.arguments as NotificationModel;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed("main layout"),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.content,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat("dd-MM-yyyy").format(DateTime.parse(data.date)),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey, fontSize: 16),
                ),
                Text(DateFormat.Hm().format(DateTime.parse(data.date)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 12),
                Container(
                    width: double.infinity,
                    child: data.media != ""
                        ? Image.network(
                            "https://admin.rain-app.com/storage/notifications/${data.media}")
                        : const SizedBox()),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  data.content,
                  style: TextStyle(fontSize: 21),
                ),
                Center(
                  child: defaultButton(
                      onPressed: () async {
                        try {
                          await canLaunch(data.redirect)
                              ? await launch(data.redirect)
                              : throw "could not fiend";
                        } catch (e) {}
                      },
                      textButton: "اذهب",
                      radius: 12,
                      width: 150),
                )
              ],
            ),
          ),
        ));
  }
}
