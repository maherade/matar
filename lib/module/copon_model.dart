class CoponModel {
  late final int id;
  late final String coupon;
  late final String country;
  late final String days;
  late final String expireDate;
  late final int active;

  CoponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coupon = json['coupon'];
    country = json['country'] ?? "";
    days = json['days'];
    expireDate = json['expire_date'];
    active = json['active'] ?? "";
  }
}
