import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/network/local/shared_pref.dart';

// ignore: must_be_immutable
class LogIn extends StatelessWidget {
  LogIn({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, ApppState>(
        listener: (context, state) async {
          var cubit = AppCubit.caller(context);
          // TODO: implement listener
          if (state is ShopLoginSuccessState ||
              state is LoginWithGoogleSuccessState) {
            buildToast(text: "تم  تسجيل الدخول بنجاح", color: Colors.black);
            CacheHelper.saveData(key: "token", value: cubit.login?.token);
            CacheHelper.saveData(key: "login", value: true);
            print("--------------------------");
            print(CacheHelper.getData(key: "token"));
            Navigator.of(context).pushReplacementNamed("main layout");
          }
          if (state is ShopLoginErrorState) {
            buildToast(text: "فشل تسجيل الدخول", color: Colors.black);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
              Scaffold(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .1,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("main layout");
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                )),
                            Text(
                              "تسجيل الدخول",
                              style: Theme.of(context).textTheme.headline1,
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(25),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  child: defaultFormField(
                                      hintText: "البريد الالكتروني",
                                      // prefixIcon: const Icon(
                                      //   Icons.email,
                                      //   color: Colors.grey,
                                      // ),
                                      controller: _emailController,
                                      type: TextInputType.emailAddress),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  height: 60,
                                  child: defaultFormField(
                                      hintText: " كلمة المرور",
                                      // prefixIcon: const Icon(
                                      //   Icons.lock,
                                      //   color: Colors.grey,
                                      // ),
                                      controller: _passwordController,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "password is to short";
                                        }
                                      },
                                      type: TextInputType.emailAddress),
                                ),

                                defaultTextButton(
                                  color: Color(0xff814269),
                                  isUpperCase: false,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed("send linke");
                                  },
                                  text: " نسيت كلمة المرور؟",
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),

                                // تسجيل الدخول
                                defaultButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      AppCubit.caller(context).userLogin(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                    }
                                  },
                                  textButton: "تسجيل الدخول",
                                  backgroundColor: secondColor,
                                  isUpperCase: false,
                                  radius: 40,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    myDivider(context),
                                    const Text(
                                      " أو",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    myDivider(context)
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                ),

                                // تسجيل الدخول بجوجل
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.blue.shade700),
                                      borderRadius: BorderRadius.circular(12)),
                                  onPressed: () {
                                    // AppCubit.caller(context).googleFunction(context);
                                    AppCubit.caller(context)
                                        .googleFunction(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        image: const AssetImage(
                                            'images/google.png'),
                                      ),
                                      Text(
                                        'تسجيل الدخول بواسطة جوجل',
                                        style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                ),
                                // تسجيل الدخول بالفيس بوك
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: const Color(0xFF3B5998),
                                  onPressed: () {
                                    AppCubit.caller(context).fblogin(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        image: const AssetImage(
                                            'images/facebook.png'),
                                      ),
                                      const Text(
                                        'تسجيل الدخول بواسطة الفيسبوك',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     myDivider(context),
                                //     Text(
                                //       " أو",
                                //       style:
                                //           Theme.of(context).textTheme.headline6,
                                //     ),
                                //     myDivider(context)
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     InkWell(
                                //       onTap: () {
                                //         AppCubit.caller(context)
                                //             .signInWithGoogle();
                                //       },
                                //       child: defaultContainerWithImage(
                                //         context: context,
                                //         image: "email.png",
                                //         text: "جوجل",
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "ليس لديك حساب ؟",
                                      style: TextStyle(
                                        color: Color(0xff814269),
                                        fontSize: 20,
                                      ),
                                    ),
                                    defaultTextButton(
                                      color: Color(0xff814269),
                                      isUpperCase: false,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("signup");
                                      },
                                      text: "انشاء حساب",
                                    ),
                                  ],
                                ),
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
