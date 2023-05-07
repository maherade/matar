import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mattar/component/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("main layout"),
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  )),
              Text(
                "تطبيقات ومواقع مفيدة",
                style: Theme.of(context).textTheme.headline1,
              )
            ],
          ),
          InkWell(
            onTap: () async {
              try {
                await canLaunch("https://www.gheym.com/")
                    ? await launch("https://www.gheym.com/")
                    : throw "could not fiend";
              } catch (e) {
                return;
              }
            },
            child: Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    "موقع غيم",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          if (defaultTargetPlatform == TargetPlatform.android)
            InkWell(
              onTap: () async {
                try {
                  await canLaunch(
                          "https://play.google.com/store/apps/details?id=com.izzedineeita.ghym")
                      ? await launch(
                          "https://play.google.com/store/apps/details?id=com.izzedineeita.ghym")
                      : throw "could not fiend";
                } catch (e) {
                  return;
                }
              },
              child: Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "تطبيق غيم",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )
        ],
      ),
    );
  }
}
