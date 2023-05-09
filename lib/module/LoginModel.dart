class LoginModel {
  late final int id;
  late final String name;
  late final String email;
  late final String password;
  late final String country;
  late final String phone;
  late final String facebookToken;
  late final String googleToken;
  late final String token;
  late final String pic;
  late final String date;
  late final String coupon;
  late final int ban;
  late final String role;

  // late final int active;
  late final List<Subscription> subscription;

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    country = json['country'] ?? "";
    phone = json['phone'] ?? "";
    facebookToken = json['facebook_token'] ?? "";
    googleToken = json['google_token'] ?? "";
    token = json['token'];
    role = json['role'] ?? "";
    pic = json["pic"] ?? "";
    date = json['date'];
    coupon = json["coupon"] ?? "null";
    ban = json['ban'] ?? 0;
    // if (json['subscription'] != []) {
    //   subscription = <Subscription>[];
    //   json['subscription'].forEach((v) {
    //     subscription.add(Subscription.fromJson(v));
    //   });
    // }
    // else {
    //   subscription = [
    //     Subscription.fromJson({
    //       "id": 30,
    //       "user_id": 65,
    //       "amount": "200",
    //       "start_date": "2022-06-16",
    //       "expire_date": "2022-12-16",
    //       "marketer_name": null,
    //       "pay_method": "google-pay",
    //       "active": 1
    //     }),
    //     Subscription.fromJson({
    //       "id": 30,
    //       "user_id": 65,
    //       "amount": "200",
    //       "start_date": "2022-06-16",
    //       "expire_date": "2022-12-16",
    //       "marketer_name": null,
    //       "pay_method": "google-pay",
    //       "active": 1
    //     }),
    //   ];

    //   // active = subscription![0].active;
    // }
  }
}

class Subscription {
  late final int id;
  late final int userId;
  late final String amount;
  late final String startDate;
  late final String expireDate;
  late final String marketerName;
  late final String payMethod;
  late final int active;

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 1;
    userId = json['user_id'] ?? 1;
    amount = json['amount'] ?? "";
    startDate = json['start_date'] ?? "";
    expireDate = json['expire_date'] ?? "";
    marketerName = json['marketer_name'] ?? "";
    payMethod = json['pay_method'] ?? "";
    active = json['active'] ?? 0;
  }
}
