import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/models/drawer_screens/aboutScreen.dart';
import 'package:mattar/network/local/shared_pref.dart';

import '../../component/component.dart';
import '../../component/constants.dart';
import '../../cubit/cubit/app_cubit.dart';

class MyCopons extends StatelessWidget {
  const MyCopons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, ApppState>(listener: (context, state) {
      if (state is PostCoponSuccessful) {
        buildToast(text: "تم ادخال الكوبون بنجاح", color: secondColor);
      }
      if (state is PostCoponError) {
        buildToast(text: "كوبون غير صالح", color: Colors.red);
      }
    }, builder: (context, state) {
      final TextEditingController _codeController = TextEditingController();
      return Scaffold(
        body: CacheHelper.getData(key: "login") == null
            ? Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "يجب عليك تسجيل الدخول اولا",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed("login"),
                        textButton: "تسجيل الدخول",
                        backgroundColor: secondColor,
                        radius: 12)
                  ],
                ),
              )
            : Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed("main layout"),
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.black,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "الكوبونات",
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                rowDesign("كوبوناتي"),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "ادخل الكود   ",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 50,
                  child: defaultFormField(
                      controller: _codeController, type: TextInputType.text),
                ),
                const SizedBox(
                  height: 10,
                ),
                defaultButton(
                    onPressed: () {
                      AppCubit.caller(context)
                          .sendCopon(copon: _codeController.text);
                    },
                    textButton: "ارسال",
                    backgroundColor: secondColor,
                    radius: 15,
                    width: 200),
              ]),
      );
    });
  }
}
