import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/network/local/shared_pref.dart';

import '../../cubit/cubit/app_cubit.dart';

class ProblemsScreen extends StatelessWidget {
  ProblemsScreen({Key? key}) : super(key: key);
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, ApppState>(
      listener: (context, state) {
        if (state is PostCoponSuccessful) {
          buildToast(text: "تم الارسال", color: secondColor);
        }
        if (state is PostCoponError) {
          buildToast(text: "حاول مرة اخري", color: Colors.red);
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  "رجوع",
                  style: Theme.of(context).textTheme.headline1,
                ),
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("main layout"),
                )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ما هي مشكلتك ؟",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: defaultFormField(
                    controller: _contentController,
                    type: TextInputType.text,
                    minLines: 10,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  child: defaultButton(
                    onPressed: () {
                      CacheHelper.getData(key: "token") != null
                          ? AppCubit.caller(context)
                              .sendproblem(content: _contentController.text)
                          : LogInDialog(context);
                    },
                    textButton: "ارسال",
                    backgroundColor: secondColor,
                    radius: 15,
                    width: 150,
                  ),
                )
              ],
            ));
      },
    );
  }
}
