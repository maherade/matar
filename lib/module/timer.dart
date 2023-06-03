/// country : "51"
/// is_registered_user : false
/// user_id : "898389a333285ca82c2ac82c1bcb8d87"
/// expires_at : "2023-06-01T15:21:26.882268Z"
/// updated_at : "2023-06-01T13:21:26.000000Z"
/// created_at : "2023-06-01T13:21:26.000000Z"
/// id : 9

class TimerCount {
  TimerCount({
    this.country,
    this.isRegisteredUser,
    this.userId,
    this.expiresAt,
    this.updatedAt,
    this.createdAt,
    this.id,});

  TimerCount.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    isRegisteredUser = json['is_registered_user'];
    userId = json['user_id'];
    expiresAt = json['expires_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  String? country;
  bool? isRegisteredUser;
  String? userId;
  String? expiresAt;
  String? updatedAt;
  String? createdAt;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = country;
    map['is_registered_user'] = isRegisteredUser;
    map['user_id'] = userId;
    map['expires_at'] = expiresAt;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }

}