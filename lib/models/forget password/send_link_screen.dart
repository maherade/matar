import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/constants.dart';

import '../../component/component.dart';
import 'cubit/cubit/forget_pass_cubit.dart';

class SendLinke extends StatelessWidget {
  const SendLinke({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    return BlocProvider(
      create: (context) => ForgetPassCubit(),
      child: BlocConsumer<ForgetPassCubit, ForgetPassState>(
        listener: (context, state) {
          if (state is SendLinkeSuccess) {
            buildToast(text: "تم  ارسال الرمز", color: Colors.black);
            Navigator.of(context).pushReplacementNamed("code ver");
          }
          if (state is SendLinkeError) {
            buildToast(text: "فشل", color: Colors.black);
          }
          if (state is SendLinkeLoading) {
            buildToast(text: "جار ارسال الرمز", color: Colors.black);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
              ),
              Scaffold(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                )),
                            Text(
                              "اعادة تعيين كلمة السر",
                              style: Theme.of(context).textTheme.headline1,
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(25),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  child: defaultFormField(
                                      hintText: "البريد الالكتروني",
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: mainColor,
                                      ),
                                      controller: _emailController,
                                      type: TextInputType.emailAddress),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                    "سيتم ارسال كود الي بريدك الالكتروني"),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ForgetPassCubit.caller(context)
                                            .sendVerLinke(
                                                _emailController.text);
                                      }
                                    },
                                    textButton: "ارسال",
                                    backgroundColor:
                                        const Color.fromRGBO(66, 105, 129, 1),
                                    isUpperCase: false,
                                    radius: 15,
                                    width: 150),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
