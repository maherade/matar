import 'package:flutter/material.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/network/local/shared_pref.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Image.asset(
          "images/start.jpg",
          color: Colors.white.withOpacity(0.5),
          colorBlendMode: BlendMode.modulate,
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
            margin: const EdgeInsets.only(top: 70),
            width: 276,
            height: 99,
            decoration: BoxDecoration(
                color: secondColor, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                "تطبيق مطر لمعرفة أحوال الطقس بالبلدان العربية",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 40,
          width: 110,
          decoration: BoxDecoration(
              color: mainColor, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
              onPressed: () {
                CacheHelper.saveData(key: "onBoarding", value: false);
                Navigator.of(context).pushReplacementNamed("country page2");
              },
              icon: const Icon(Icons.arrow_forward)),
        )
      ],
    ));
  }
}
