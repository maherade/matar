import 'dart:math';

class WeatherModel {
  WeatherModel({
    required this.id,
    required this.title,
    required this.date,
    required this.country,
    required this.details,
    required this.schedule,
    required this.hide,
    required this.likes,
    required this.shares,
    required this.files,
    required this.comments,
  });

  late final int id;
  late final String title;
  late final String date;
  late final String country;
  late final String details;
  late final String schedule;
  late final String hide;
  late final int likes;
  late final int shares;
  late final List<Files> files;
  late final List<Comments> comments;

  // List<bool> liked = List.generate(1000, (index) => Random().nextBool());
  bool? liked = false;

  WeatherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    date = json['date'] ?? "";
    country = json['country'] ?? "";
    details = json['details'] ?? "";
    schedule = json['schedule'] ?? "";
    hide = json['hide'] ?? "";
    likes = json['likes'] ?? "";
    shares = json['shares'] ?? "";
    files = List.from(json['files']).map((e) => Files.fromJson(e)).toList();
    comments =
        List.from(json['comments']).map((e) => Comments.fromJson(e)).toList();
    liked = json['liked'] ?? false;
  }
}

class Files {
  Files({
    required this.id,
    required this.outlookId,
    required this.file,
  });

  late final int id;
  late final String outlookId;
  late final String file;

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    outlookId = json['outlook_id'] ?? "";
    file = json['file'] ?? "";
  }
}

class Comments {
  Comments({
    required this.id,
    required this.outlookId,
    required this.userId,
    required this.comment,
    required this.reply,
    required this.date,
    required this.user,
  });

  late final int id;
  late final int outlookId;
  late final int userId;
  late final String comment;
  late final String reply;
  late final String date;
  late final UserC user;

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    outlookId = json['outlook_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    comment = json['comment'] ?? "";
    reply = json['reply'] ?? "";
    date = json['date'] ?? "";
    user = UserC.fromJson(json['user'] ??
        {
          "id": 532698,
          "name": "غير معروف",
          "email": "unKnoen@gmail.com",
          "country": "",
          "phone": "",
          "facebookToken": "",
          "googleToken": "",
          "token": "gfhghjghjgjgjghj",
          "role": "",
          "pic": "",
          "date": "",
          "coupon": "",
          "ban": 0
        });
  }
}

class UserC {
  UserC({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.phone,
    required this.facebookToken,
    required this.googleToken,
    required this.token,
    required this.role,
    required this.pic,
    required this.date,
    required this.coupon,
    required this.ban,
  });

  late final int id;
  late final String name;
  late final String email;
  late final String country;
  late final String phone;
  late final String facebookToken;
  late final String googleToken;
  late final String token;
  late final String role;
  late final String pic;
  late final String date;
  late final String coupon;
  late final int ban;

  UserC.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    country = json['country'] ?? "";
    phone = json['phone'] ?? "";
    facebookToken = json['facebook_token'] ?? "";
    googleToken = json['google_token'] ?? "";
    token = json['token'] ?? "";
    role = json['role'] ?? "user";
    pic = json["pic"] ?? "";
    date = json['date'];
    coupon = json["coupon"] ?? "";
    ban = json['ban'] ?? 0;
  }
}

//  cubit.profile?.role == "admin"
//                                             ? Expanded(
//                                                 child: Container(
//                                                   margin:
//                                                       EdgeInsets.only(
//                                                           bottom: 8),
//                                                   child:
//                                                       ListView.builder(
//                                                           itemCount: cubit
//                                                               .post[
//                                                                   index]
//                                                               .comments
//                                                               .length,
//                                                           itemBuilder:
//                                                               (__,
//                                                                   ind) {
//                                                             return Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     Container(
//                                                                       height: 40,
//                                                                       width: 40,
//                                                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(200)),
//                                                                       child: ClipRRect(
//                                                                         borderRadius: BorderRadius.circular(200),
//                                                                         child: AppCubit.caller(context).profile?.pic != null && AppCubit.caller(context).profile?.pic != ""
//                                                                             ? Image.network(errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
//                                                                                 return const Text('Your error widget...');
//                                                                               }, "https://admin.rain-app.com/storage/users/${AppCubit.caller(context).profile?.pic}")
//                                                                             : Image.asset("images/avatar.png"),
//                                                                       ),
//                                                                     ),
//                                                                     Container(
//                                                                       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                                                                       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//                                                                       child: Column(
//                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             cubit.post[index].comments[ind].user.name,
//                                                                             style: const TextStyle(color: const Color.fromRGBO(66, 105, 129, 1), fontWeight: FontWeight.bold),
//                                                                           ),
//                                                                           Flexible(
//                                                                             fit: FlexFit.tight,
//                                                                             child: Container(
//                                                                               child: SingleChildScrollView(
//                                                                                 child: Text(
//                                                                                   cubit.post[index].comments[ind].comment,
//                                                                                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           Row(
//                                                                             children: [
//                                                                               Text(
//                                                                                 "${DateFormat.yMd().format(DateTime.parse(cubit.post[index].comments[ind].date))}",
//                                                                                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
//                                                                               ),
//                                                                               SizedBox(
//                                                                                 width: 10,
//                                                                               ),
//                                                                               InkWell(
//                                                                                 onTap: () {
//                                                                                   showDialog(
//                                                                                       context: context,
//                                                                                       builder: (BuildContext context) {
//                                                                                         TextEditingController replayController = TextEditingController();
//                                                                                         return AlertDialog(
//                                                                                           actions: [
//                                                                                             Form(
//                                                                                               child: Row(
//                                                                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                                                                 children: [
//                                                                                                   Container(
//                                                                                                     color: Colors.white,
//                                                                                                     width: MediaQuery.of(context).size.width * 0.7,
//                                                                                                     margin: const EdgeInsets.only(top: 1, right: 10),
//                                                                                                     child: defaultFormField(prefixIcon: const Icon(Icons.comment), controller: replayController, type: TextInputType.text),
//                                                                                                   ),
//                                                                                                   defaultIconButton(
//                                                                                                       onPressed: () {
//                                                                                                         cubit.sendReplay(outlookId: cubit.posts[index].id, commentId: cubit.posts[index].comments[ind].id.toInt(), reply: replayController.text);
//                                                                                                         Navigator.pop(context);
//                                                                                                       },
//                                                                                                       icon: Icons.send,
//                                                                                                       color: mainColor)
//                                                                                                 ],
//                                                                                               ),
//                                                                                             )
//                                                                                           ],
//                                                                                         );
//                                                                                       });
//                                                                                 },
//                                                                                 child: Text(
//                                                                                   "رد علي التعليق",
//                                                                                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 cubit.posts[index].comments[ind].reply.isEmpty
//                                                                     ? const SizedBox()
//                                                                     : Row(
//                                                                         children: [
//                                                                           Container(
//                                                                             height: 35,
//                                                                             width: 35,
//                                                                             child: ClipRRect(
//                                                                               borderRadius: BorderRadius.circular(200),
//                                                                               child: Image.asset("images/icon.png"),
//                                                                             ),
//                                                                           ),
//                                                                           Flexible(
//                                                                             fit: FlexFit.tight,
//                                                                             child: Container(
//                                                                               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                                                                               child: SingleChildScrollView(
//                                                                                 child: Text(
//                                                                                   cubit.post[index].comments[ind].reply,
//                                                                                   style: const TextStyle(fontSize: 18, color: Colors.grey),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                               ],
//                                                             );
//                                                           }),
//                                                 ),
//                                               )
//                                             : const Text(
//                                                 "tttttttttttttt"),
