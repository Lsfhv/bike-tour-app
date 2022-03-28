import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikeMarker extends Marker {
  late BikePointModel station;
  BikeMarker({required this.station})
      : super(
            markerId: MarkerId(station.id as String),
            draggable: false,
            position: LatLng(station.lat, station.lon),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen));

  BikeMarker._fromFS(String id, LatLng pos)
      : super(
            markerId: MarkerId(id),
            draggable: false,
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen));

  factory BikeMarker.fromFS(Map<String, dynamic> value) {
    String id = value['id'];
    LatLng pos = LatLng(value['latitude'], value['longtitude']);
    return BikeMarker._fromFS(id, pos);
  }
}
