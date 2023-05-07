import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/constants.dart';

import '../../component/component.dart';
import 'cubit/cubit/forget_pass_cubit.dart';

class CodeVer extends StatelessWidget {
  const CodeVer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final TextEditingController _code = TextEditingController();
    final TextEditingController _password = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    return BlocProvider(
      create: (context) => ForgetPassCubit(),
      child: BlocConsumer<ForgetPassCubit, ForgetPassState>(
        listener: (context, state) {
          if (state is CheckCodeError) {
            buildToast(text: "الرمز غير صحيح", color: Colors.black);
          }
          if (state is ChangePasswordSuccess) {
            buildToast(text: "تم تغيير كلمة السر", color: Colors.black);
            Navigator.of(context).pushReplacementNamed("login");
          }
          if (state is ChangePasswordError) {
            buildToast(text: "فشل", color: Colors.black);
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
                    child: Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: const EdgeInsets.all(25),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  defaultFormField(
                                      hintText: "البريد الالكتروني",
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: mainColor,
                                      ),
                                      controller: _emailController,
                                      type: TextInputType.emailAddress),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: defaultFormField(
                                        hintText:
                                            " الرمز المرسل عبر البريد الالكتروني",
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: mainColor,
                                        ),
                                        controller: _code,
                                        type: TextInputType.emailAddress),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultFormField(
                                      hintText: "كلمة السر الجديده",
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: mainColor,
                                      ),
                                      controller: _password,
                                      type: TextInputType.emailAddress),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          ForgetPassCubit.caller(context)
                                              .checkCode(
                                                  _code.text,
                                                  _password.text,
                                                  _emailController.text);
                                        }
                                      },
                                      textButton: "تاكيد",
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
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
