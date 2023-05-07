// ignore: file_names
class CountryModel {
  late final int id;
  late final String country;
  late final String icon;

  CountryModel({required this.id, required this.country, required this.icon});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    country = json['country'] ?? "";
    icon = json['icon'] ?? "";
  }
}
