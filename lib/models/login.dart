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
          if (state is ShopLoginSuccessState || state is LoginWithGoogleSuccessState) {
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
              Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
              ),
              Scaffold(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                         SizedBox(
                          height: MediaQuery.of(context).size.height*.2,
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
                                Container(
                                  height: 50,
                                  child: defaultFormField(
                                      hintText: " الرقم السري",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: mainColor,
                                      ),
                                      controller: _passwordController,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "password is to short";
                                        }
                                      },
                                      type: TextInputType.emailAddress),
                                ),
                                 SizedBox(
                                  height: MediaQuery.of(context).size.height*.04,
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
                                  radius: 15,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*.02,
                                ),
                                // تسجيل الدخول بجوجل
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                    color: Color(0xFFF44336),
                                  onPressed: (){
                                    // AppCubit.caller(context).googleFunction(context);
                                    AppCubit.caller(context).googleFunction(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('جوجل',style: const TextStyle(color: Colors.white, fontSize: 18),),
                                      SizedBox(width: MediaQuery.of(context).size.height*.02,),
                                      Image(
                                        height: MediaQuery.of(context).size.height*.06,
                                        image: AssetImage('images/gmail.png'),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.height*.02,
                                ),
                                // تسجيل الدخول بالفيس بوك
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  color: Color(0xFF3B5998),
                                  onPressed: (){},
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('فيس بوك',style: const TextStyle(color: Colors.white, fontSize: 18),),
                                      SizedBox(width: MediaQuery.of(context).size.height*.02,),
                                      Image(
                                        height: MediaQuery.of(context).size.height*.06,
                                        image: AssetImage('images/facebook.png'),
                                      )
                                    ],
                                  ),
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
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    defaultTextButton(
                                        color: const Color.fromRGBO(
                                            66, 105, 129, 1),
                                        isUpperCase: false,
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed("signup");
                                        },
                                        text: "انشاء حساب"),
                                  ],
                                ),
                                defaultTextButton(
                                    color: Colors.black,
                                    isUpperCase: false,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("send linke");
                                    },
                                    text: "هل نسيت كلمة السر ؟"),
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
