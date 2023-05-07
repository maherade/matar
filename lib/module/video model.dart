class VideoModel {
  late final int id;
  late final String photographer;
  late final String location;
  late final String date;
  late final String schedule;
  late final String hide;
  late final int shares;
  late final String media;

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    photographer = json['photographer'] ?? "";
    location = json['location'] ?? "";
    date = json['date'] ?? "";
    schedule = json['schedule'] ?? "";
    hide = json['hide'] ?? "";
    shares = json['shares'] ?? "";
    media = json['media'] ?? "";
  }
}
