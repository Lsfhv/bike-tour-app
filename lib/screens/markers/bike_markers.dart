import 'package:bike_tour_app/models/bike_point_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikeMarker extends Marker {
  BikePointModel? station;
  BikeMarker({required this.station})
// <<<<<<< tutorial_page
    : super(markerId: MarkerId(station!.id as String) ,draggable: false, position: LatLng(station.lat, station.lon),
    icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
// =======
//       : super(
//             markerId: MarkerId(station.id as String),
//             draggable: false,
//             position: LatLng(station.lat, station.lon),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueGreen));
// >>>>>>> main

  BikeMarker._fromFS(String id, LatLng pos)
      : super(
            markerId: MarkerId(id),
            draggable: false,
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen));

// <<<<<<< tutorial_page
  factory BikeMarker.fromFS(Map<String, dynamic> value){
    String id = value.keys.first;
    LatLng pos = LatLng((value.values.first as GeoPoint).latitude, (value.values.first as GeoPoint).longitude);
// =======
//   factory BikeMarker.fromFS(Map<String, dynamic> value) {
//     String id = value['id'];
//     LatLng pos = LatLng(value['latitude'], value['longtitude']);
// >>>>>>> main
    return BikeMarker._fromFS(id, pos);
  }
}
