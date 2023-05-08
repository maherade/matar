import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/models/mattar%20video%20and%20image/cubit/cubit/video_cubit.dart';
import 'package:mattar/network/local/shared_pref.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
        centerTitle: true,
        leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("main layout");
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () {
                CacheHelper.removeData(key: "login");
                CacheHelper.removeData(key: "token");
                CacheHelper.removeData(key: "subscibtion");
                // CacheHelper.removeData(key: "cop");
                // if (CacheHelper.getData(key: "google") !=
                //     null) {
                //   cubit.googleSignOut();
                // }
                Navigator.of(context).pushNamed("main layout");
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => AppCubit()..getProfileData(),
          child: BlocConsumer<AppCubit, ApppState>(
            listener: (context, state) {
              if (state is uploadFileSuccessState) {
                buildToast(text: "تم التعديل", color: Colors.green);
              }
              if (state is uploadFileErrorState) {
                buildToast(text: "فشل التعديل", color: Colors.red);
              }
              if (state is UpdateUserError) {
                buildToast(text: "فشل التعديل", color: Colors.red);
              }
              if (state is UpdateUserLoading) {
                buildToast(
                    text: "جاري التعديل الرجاء الانتظار", color: mainColor);
              }
            },
            builder: (context, state) {
              final cubit = AppCubit.caller(context);
              if (state is GetProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(66, 105, 129, 1),
                  ),
                );
              }
              if (state is GetProfileSuccessful || state is UpdateUserError) {
                final TextEditingController _nameController =
                TextEditingController(text: cubit.profile?.name);
                final TextEditingController _emailController =
                TextEditingController(text: cubit.profile?.email);
                final TextEditingController _countryControler =
                TextEditingController(text: cubit.profile?.country);
                final TextEditingController _phoneControler =
                TextEditingController(text: cubit.profile?.phone);
                final TextEditingController _passwordControler =
                TextEditingController();

                return Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          child: Stack(children: [
                            CachedNetworkImage(
                                imageUrl:
                                "https://admin.rain-app.com/storage/users/${cubit.profile?.pic}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(66, 105, 129, 1),
                                    )),
                                errorWidget: (_, __, ___) =>
                                    Image.asset("images/avatar.png")),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(250),
                            //   child: AppCubit.caller(context).profile?.pic !=
                            //               null &&
                            //           AppCubit.caller(context).profile?.pic !=
                            //               ""
                            //       ? Image.network(errorBuilder:
                            //               (BuildContext context,
                            //                   Object exception,
                            //                   StackTrace? stackTrace) {
                            //           return const Text('Your error widget...');
                            //         },
                            //           "https://admin.rain-app.com/storage/users/${cubit.profile?.pic}")
                            //       : Image.asset("images/avatar.png"),
                            // ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white70,
                                child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          useRootNavigator: true,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20)),
                                              content: SizedBox(
                                                height: 150,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    defaultButton(
                                                      onPressed: () {
                                                        cubit.picImage(
                                                            fromWhere:
                                                            ImageSource
                                                                .camera,
                                                            name: _nameController
                                                                .text,
                                                            email:
                                                            _emailController
                                                                .text,
                                                            phone:
                                                            _phoneControler
                                                                .text,
                                                            location:
                                                            _countryControler
                                                                .text,
                                                            password:
                                                            _passwordControler
                                                                .text);
                                                        Navigator.pop(context);
                                                      },
                                                      textButton: "الكاميرا",
                                                      backgroundColor:
                                                      secondColor,
                                                      width: 100,
                                                      radius: 12,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    defaultButton(
                                                      onPressed: () {
                                                        cubit.picImage(
                                                            fromWhere:
                                                            ImageSource
                                                                .gallery,
                                                            name: _nameController
                                                                .text,
                                                            email:
                                                            _emailController
                                                                .text,
                                                            phone:
                                                            _phoneControler
                                                                .text,
                                                            location:
                                                            _countryControler
                                                                .text,
                                                            password:
                                                            _passwordControler
                                                                .text);
                                                        Navigator.pop(context);
                                                      },
                                                      textButton: "المعرض",
                                                      backgroundColor:
                                                      secondColor,
                                                      width: 100,
                                                      radius: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: const Icon(CupertinoIcons.camera)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        CacheHelper.getData(key: "token") != null
                            ? Text(
                          " ${cubit.profile?.name}",
                          style: const TextStyle(fontSize: 20),
                        )
                            : const SizedBox(
                          height: 1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                            prefixIcon: const Icon(Icons.person),
                            controller: _nameController,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 4,
                        ),
                        defaultFormField(
                            prefixIcon: const Icon(Icons.email),
                            controller: _emailController,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            LogInDialog(context);
                          },
                          child: defaultFormField(
                              prefixIcon: const Icon(Icons.location_on),
                              controller: _countryControler,
                              type: TextInputType.text),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        defaultFormField(
                            prefixIcon: const Icon(Icons.phone),
                            controller: _phoneControler,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 4,
                        ),
                        defaultFormField(
                            prefixIcon: const Icon(Icons.lock),
                            controller: _passwordControler,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                            onPressed: () async {
                              await cubit.updateUser(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneControler.text,
                                  location: _countryControler.text,
                                  password: _passwordControler.text);
                            },
                            textButton: "حفظ",
                            backgroundColor: secondColor,
                            radius: 8,
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  List<Widget> Action = [
                                    TextButton(
                                      onPressed: () async {
                                        // await ShopDioHelper.deleteUser(
                                        //     'https://admin.rain-app.com/api/request-delete-account',
                                        //     '${AppCubit.caller(context).login?.id}',
                                        //     '${AppCubit.caller(context).login?.token}');
                                        // Navigator.pop(context);
                                        // Navigator.of(context).pushReplacementNamed("main layout");
                                        // setState(() {
                                        //
                                        // });
                                      },
                                      child: const Text(
                                        'نعم',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ];
                                  Action.add(
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'إلغاء',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  );
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      'هل تريد حذف الحساب؟',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    actions: Action,
                                  );
                                },
                              );

                              // await ShopDioHelper.deleteData(url: 'https://admin.rain-app.com/api/request-delete-account',token: CacheHelper.getData(key: "token") );
                            },
                            textButton: "حذف الحساب",
                            backgroundColor: Colors.red,
                            radius: 8,
                            width: double.infinity),
                      ],
                    ),
                  ),
                );
              }

              return const Center(
                  child: Text(
                    "حدث خطاء ما!",
                    style: TextStyle(fontSize: 18),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
