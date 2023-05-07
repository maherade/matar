import 'package:flutter/material.dart';
import 'package:mattar/component/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

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
                "وسائل التواصل الاجتماعي",
                style: Theme.of(context).textTheme.headline1,
              )
            ],
          ),
          InkWell(
            onTap: () async {
              try {
                await canLaunch("https://twitter.com/db5pp")
                    ? await launch("https://twitter.com/db5pp")
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
                    "تابعنا علي تويتر",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          InkWell(
            onTap: () async {
              try {
                await canLaunch("https://www.instagram.com/db5pp/")
                    ? await launch("https://www.instagram.com/db5pp/")
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
                    "تابعنا علي انستجرام",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
