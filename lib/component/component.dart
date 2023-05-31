import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mattar/component/constants.dart';
import 'package:mattar/cubit/cubit/app_cubit.dart';
import 'package:mattar/network/local/shared_pref.dart';

Future LogInDialog(BuildContext context) {
  return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
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
                        Navigator.of(context).pushReplacementNamed("login"),
                    textButton: "تسجيل الدخول",
                    backgroundColor: secondColor,
                    radius: 12)
              ],
            ),
          ),
        );
      });
}

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  bool isUpperCase = true,
  double radius = 0,
  required VoidCallback onPressed,
  required String textButton,
}) =>
    Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? textButton.toUpperCase() : textButton,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

Widget defaultTextButton({
  TextStyle? style,
  required String text,
  required VoidCallback onPressed,
  required Color color,
  required bool isUpperCase,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
    );

Widget defaultFormField({
  VoidCallback? onTap,
  String? labelText,
  String? hintText,
  bool isPassword = false,
  IconButton? suffixIcon,
  Icon? prefixIcon,
  Widget? prefix,
  required TextEditingController? controller,
  required TextInputType? type,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? onChanged,
  int minLines = 1,
}) =>
    TextFormField(
      obscureText: isPassword,
      onChanged: onChanged,
      keyboardType: type,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Color.fromARGB(255, 148, 52, 52),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: secondColor,
          ),
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        prefix: prefix,
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: secondColor,
          ),
        ),
      ),
      validator: validate,
      controller: controller,
      onTap: onTap,
      maxLines: minLines,
    );

Widget myDivider(BuildContext context) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.32,
        height: 2,
        color: Colors.grey,
      ),
    );

void navigateTo({required context, required widget}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

void navigateAndReplacement({required context, required widget}) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates states) {
  Color color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

buildToast({required String text, required Color color}) {
  return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

defaultAppBar({
  String? title,
  List<Widget>? actions,
  required BuildContext context,
}) =>
    AppBar(
      title: Text(
        title.toString(),
      ),
      actions: actions,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

Widget notiContainer(
    {required String content, required String date, required String image}) {
  return Container(
    height: 65,
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: 200,
                height: 20,
                child: Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 200,
                height: 20,
                child: Text(
                  "${DateFormat("hh:mm").format(DateTime.parse(date))} ${DateFormat("hh:mm a", "ar").format(DateTime.parse(date)).replaceAll(RegExp(r"[^a-zA-Z\u0621-\u064A]"), '')} - ${DateFormat("y.MM.d").format(DateTime.parse(date))} ",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 40,
          child: CachedNetworkImage(imageUrl: image, height: 5),
        ),
      ],
    ),
  );
}

Widget defaultWeatherExpectedRowIcon(
    {IconData? icon, var text, var onPressed, Widget? child}) {
  return Row(
    children: [
      IconButton(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                )
              : child!),
      text == null
          ? const SizedBox(
              width: 0.1,
            )
          : Text(
              "${DateFormat("y/MM/d").format(DateTime.parse(text))} / ${DateFormat("hh:mm").format(DateTime.parse(text))} ${DateFormat("hh:mm a", "ar").format(DateTime.parse(text)).replaceAll(RegExp(r"[^a-zA-Z\u0621-\u064A]"), '')}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
    ],
  );
}

Widget defaultDrawerContainer(
    {required BuildContext context, required String title, var onpressed}) {
  return InkWell(
    onTap: onpressed,
    child: Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [shadow()]),
      child: Center(
          child: Text(
        title,
        style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey[800]),
      )),
    ),
  );
}

Widget defaultIconButton({
  required VoidCallback onPressed,
  required IconData icon,
  double? iconSize,
  required Color color,
}) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
      ),
      color: color,
    );

Widget defaultContainerWithImage(
    {required BuildContext context,
    required String image,
    required String text}) {
  return Container(
    width: 300,
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: containerColor, borderRadius: BorderRadius.circular(12)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(height: 25, child: Image.asset("images/$image")),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    ),
  );
}

BoxShadow shadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 2,
    blurRadius: 5,
    offset: Offset(0, 3),

    /// changes position of shadow
  );
}

Widget countryContainer({required BuildContext context, required var model}) {
  return InkWell(
    onTap: () {
      CacheHelper.saveData(key: "countryId", value: model.id);
      CacheHelper.saveData(key: "country", value: model.country);
      print(model.country);
      print(model.id);

      AppCubit.caller(context).getSelectedWeatherPosts(countryId: model.id);

      Navigator.of(context).pushReplacementNamed("main layout");
    },
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
          boxShadow: [shadow()]),
      child: Column(
        children: [
          Image.network(
            "https://admin.rain-app.com/storage/countries/${model.icon}",
            height: 50,
          ),
          Expanded(
              child: Center(
                  child: Text(
            "${model.country}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )))
        ],
      ),
    ),
  );
}



customToast({
  required String title,
  required Color color
})
{
  Fluttertoast.showToast(
      msg: title,
      textColor: Colors.white,
      backgroundColor: color,
      gravity: ToastGravity.BOTTOM
  );

}

