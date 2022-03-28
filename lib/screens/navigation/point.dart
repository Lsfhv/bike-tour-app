class Point {
  final String name;
  final double lat;
  final double lon;
  final int bikeSpace;
  final int bikeAvailable;

  Point(this.name, this.lat, this.lon, this.bikeSpace, this.bikeAvailable);

  Point.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        lat = json["lat"],
        lon = json["lon"],
        bikeSpace = json["bike space"],
        bikeAvailable = json["bikes available"];

  Map<String>
}