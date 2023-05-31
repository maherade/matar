import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/module/country%20model.dart';

import '../cubit/cubit/app_cubit.dart';
import '../data/country data.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController nameControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CountriesCubit()),
        BlocProvider(
          create: (context) => AppCubit(),
        )
      ],
      child: BlocConsumer<AppCubit, ApppState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SignUpSuccessState) {
            Fluttertoast.showToast(
                msg: "تم انشاء الحساب بنجاح",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 16, 16, 16),
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pushReplacementNamed("login");
          }
          if (state is SignUpErrorState) {
            Fluttertoast.showToast(
                msg: "هذا الايميل مسجل من قبل",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 16, 16, 16),
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
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
                              "انشاء حساب جديد ",
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
                                  child: defaultFormField(
                                      labelText: "الاسم",
                                      controller: nameControl,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "يجب عليك ادخال اسمك";
                                        }
                                      },
                                      type: TextInputType.emailAddress),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: defaultFormField(
                                      labelText: "البريد الالكتروني",
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "يجب عليك ادخال بريدك الالكتروني";
                                        }
                                      },
                                      controller: emailControl,
                                      type: TextInputType.emailAddress),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: defaultFormField(
                                      labelText: "كلمة المرور",
                                      controller: passwordControler,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "يجب عليك ادخال كلمة سر قوية";
                                        }
                                      },
                                      type: TextInputType.emailAddress),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: defaultFormField(
                                      labelText: "اعادة كتابة كلمة المرور",
                                      controller: passwordControler,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "يجب عليك ادخال كلمة سر قوية";
                                        }
                                      },
                                      type: TextInputType.emailAddress),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                BlocBuilder<CountriesCubit, CountryModel?>(
                                  builder: (context, state) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2<CountryModel>(
                                        hint: Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'اختر الدولة',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: state,
                                        onChanged: context
                                            .read<CountriesCubit>()
                                            .changeCountry,
                                        // customButton: Icon(
                                        //   Icons.location_on,
                                        //   color: mainColor,),
                                        items: countryData.map<
                                                DropdownMenuItem<CountryModel>>(
                                            (e) {
                                          return DropdownMenuItem(
                                              value: e,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "images/${e.icon}",
                                                    height: 40,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    e.country,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ));
                                        }).toList(),
                                        buttonStyleData: ButtonStyleData(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 3),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 8,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (context
                                              .read<CountriesCubit>()
                                              .state ==
                                          null) return;
                                      AppCubit.caller(context).userSignUp(
                                          email: emailControl.text,
                                          password: passwordControler.text,
                                          name: nameControl.text,
                                          country: context
                                              .read<CountriesCubit>()
                                              .state
                                              ?.country);
                                    }
                                  },
                                  textButton: "تسجيل",
                                  backgroundColor: secondColor,
                                  isUpperCase: false,
                                  radius: 40,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    myDivider(context),
                                    Text(
                                      " أو",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    myDivider(context)
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     defaultContainerWithImage(
                                //         context: context,
                                //         image: "email.png",
                                //         text: "جوجل"),
                                //     defaultContainerWithImage(
                                //         context: context,
                                //         image: "facebook.png",
                                //         text: "فيسبوك"),
                                //   ],
                                // ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        image: const AssetImage(
                                            'images/google.png'),
                                      ),
                                      Text(
                                        'تسجيل بواسطة جوجل',
                                        style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        image: const AssetImage(
                                            'images/facebook.png'),
                                      ),
                                      const Text(
                                        'تسجيل بواسطة الفيسبوك',
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "لديك حساب ؟",
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
                                              .pushReplacementNamed("login");
                                        },
                                        text: "قم بتسجيل الدخول")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

class CountriesCubit extends Cubit<CountryModel?> {
  CountriesCubit() : super(null);

  void changeCountry(CountryModel? country) {
    if (country == null) {
      return;
    }
    emit(country);
  }
}
