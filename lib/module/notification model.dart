class NotificationModel {
  NotificationModel({
    required this.id,
    required this.subject,
    required this.content,
    required this.date,
    required this.country,
    required this.appearanceFor,
    required this.appearanceAs,
    required this.redirect,
    required this.schedule,
    required this.media,
  });

  late final int id;
  late final String subject;
  late final String content;
  late final String date;
  late final String country;
  late final String appearanceFor;
  late final String appearanceAs;
  late final String redirect;
  late final String schedule;
  late final String media;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    subject = json['subject'] ?? "";
    content = json['content'] ?? "";
    date = json['date'] ?? "";
    country = json['country'] ?? "عام" ?? "";
    appearanceFor = json['appearance_for'] ?? "";
    appearanceAs = json['appearance_as'] ?? "";
    redirect = json['redirect'] ?? "";
    schedule = json['schedule'] ?? "";
    media = json['media'] ?? "";
  }
}
