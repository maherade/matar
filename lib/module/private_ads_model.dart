class AdsModel {
  late final int id;
  late final String title;
  late final String redirect;
  late final String hide;
  late final String location;
  late final String country;
  late final String media;
  late final List<dynamic> details;

  AdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    redirect = json['redirect'];
    hide = json['hide'];
    location = json['location'];
    country = json['country'];
    media = json['media'];
    details = List.castFrom<dynamic, dynamic>(json['details']);
  }
}
