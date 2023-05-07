import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mattar/component/component.dart';

import '../../component/constants.dart';
import 'cubit/cubit/video_cubit.dart';

class AddVideo extends StatelessWidget {
  AddVideo({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoCubit(),
      child: BlocConsumer<VideoCubit, VideoState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is uploadFileSuccessState) {
            Fluttertoast.showToast(
                msg: "تم الارسال وسيم اضافته عند الموافقه عليه",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 21, 151, 7),
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pushReplacementNamed("main layout");
          }
          if (state is uploadFileErrorState) {
            Fluttertoast.showToast(
                msg: "فشل التحميل",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 216, 10, 10),
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is uploadFileLoadingState) {
            Fluttertoast.showToast(
                msg: "جاري التحميل",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          var cubit = VideoCubit.caller(context);
          return Stack(fit: StackFit.expand, children: [
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
                        height: 25,
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
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "رجوع",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(" اضافة صورة او مقطع فيديو",
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(color: Colors.grey[800])),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: defaultFormField(
                            minLines: 3,
                            prefixIcon:
                                const Icon(Icons.camera_enhance_rounded),
                            controller: nameController,
                            type: TextInputType.text,
                            labelText: "الوصف"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: defaultFormField(
                            prefixIcon: const Icon(Icons.location_on),
                            controller: locationController,
                            type: TextInputType.text,
                            labelText: "موقع التصوير"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: defaultFormField(
                            prefixIcon: const Icon(Icons.av_timer),
                            controller: dateController,
                            type: TextInputType.text,
                            hintText:
                                "${DateFormat('HH:mm').format(DateTime.now())} | ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                            labelText: "التاريخ والوقت"),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            defaultButton(
                                              onPressed: () {
                                                cubit.fetchImage(
                                                    type: "video",
                                                    fromWhere:
                                                        ImageSource.camera);
                                              },
                                              textButton: "فيديو",
                                              backgroundColor: secondColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                            SizedBox(height: 10),
                                            defaultButton(
                                              onPressed: () {
                                                cubit.fetchImage(
                                                    type: "image",
                                                    fromWhere:
                                                        ImageSource.camera);
                                              },
                                              textButton: "صورة",
                                              backgroundColor: secondColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                            SizedBox(height: 10),
                                            defaultButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              textButton: "اغلاق",
                                              backgroundColor: exitColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: secondColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Text("الكاميرا",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 140,
                                        child: Column(
                                          children: [
                                            defaultButton(
                                              onPressed: () {
                                                cubit.fetchImage(
                                                    type: "video",
                                                    fromWhere:
                                                        ImageSource.gallery);
                                              },
                                              textButton: "فيديو",
                                              backgroundColor: secondColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                            SizedBox(height: 10),
                                            defaultButton(
                                              onPressed: () {
                                                cubit.fetchImage(
                                                    type: "image",
                                                    fromWhere:
                                                        ImageSource.gallery);
                                              },
                                              textButton: "صورة",
                                              backgroundColor: secondColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                            SizedBox(height: 10),
                                            defaultButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              textButton: "اغلاق",
                                              backgroundColor: exitColor,
                                              width: 100,
                                              radius: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: secondColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Text("المعرض",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                          height: 300,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 55),
                          color: Colors.white,
                          child: cubit.showImage()),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.uploadFiles(
                            dis: nameController.text.isEmpty
                                ? "unknown"
                                : nameController.text,
                            location: locationController.text.isEmpty
                                ? "unknown"
                                : locationController.text,
                            time: DateTime.now().toString(),
                          );
                        },
                        child: state is! uploadFileLoadingState
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                decoration: BoxDecoration(
                                    color: secondColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text("ارسال",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              )
                            : const Text("...waiting"),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                )),
          ]);
        },
      ),
    );
  }
}

// showFile(String extention, File picker) {
//   if (extention == ".mp4") {
//     return Text("hhhhhhhh");
//   } else if (extention == ".jpg") {
//     return Image.file(picker);
//   } else {
//     return Text("select an valid image");
//   }
// }
