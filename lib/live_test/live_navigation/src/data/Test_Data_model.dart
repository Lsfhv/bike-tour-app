import 'package:bike_tour_app/models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestData{
  final RouteData data;
  final List<LatLng> locationStream;

  TestData({required this.data, required this.locationStream});

}