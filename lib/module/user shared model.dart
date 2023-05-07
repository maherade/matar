class UserSharedModel {
  late final int id;
  late final int outlookId;
  late final int userId;
  late final String comment;
  late final String reply;
  late final String date;
  late final Outlook outlook;

  UserSharedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    outlookId = json['outlook_id'] ?? 0;
    userId = json['user_id'] ?? "";
    comment = json['comment'] ?? "";
    reply = json['reply'];
    date = json['date'] ?? "";
    outlook = Outlook.fromJson(json['outlook']);
  }
}

class Outlook {
  late final int id;
  late final String title;
  late final String date;
  late final String country;
  late final String details;
  late final String schedule;
  late final String hide;
  late final int likes;
  late final int shares;

  Outlook.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    date = json['date'] ?? "";
    country = json['country'] ?? "";
    details = json['details'] ?? "";
    schedule = json['schedule'] ?? "";
    hide = json['hide'] ?? "";
    likes = json['likes'] ?? "";
    shares = json['shares'] ?? "";
  }
}
