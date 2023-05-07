class MapModel {
  late final String map;

  MapModel.fromJson(Map<String, dynamic> json) {
    map = json["satellite_link"];
  }
}
