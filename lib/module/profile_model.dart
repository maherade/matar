class ProfileModel {
  late final int id;
  late final String name;
  late final String email;
  late final String password;
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
  late final bool sub;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    country = json['country'] ?? "";
    phone = json['phone'] ?? "";
    facebookToken = json['facebook_token'] ?? "";
    googleToken = json['google_token'] ?? "";
    token = json['token'] ?? "";
    role = json['role'] ?? "";
    pic = json['pic'] ?? "";
    date = json['date'] ?? "";
    coupon = json['coupon'] ?? "";
    ban = json['ban'] ?? "";
    sub = json['is_subscription_active'] ?? false;
  }
}
