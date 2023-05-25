class MapModel {
  late final String map;
  MapModel.fromJson(Map<String, dynamic> json) {
    map = json["sattelite-link"];
  }
}
