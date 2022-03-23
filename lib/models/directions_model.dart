import 'dart:core';

import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/slides/v1.dart' hide List;

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String? totalDistance;
  final String? totalDuration;
  final Instructions instruction;
  late List waypointsOrder;
  static const default_order =[];
  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.instruction,
    this.waypointsOrder = default_order,
  });


  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) {
      //something here if route empty maybe say route not found!
    }
    List<Instruction> instructions = [];
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);
    List order;


    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String? distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }
    Instructions _instructions = Instructions.fromMap(map);
    order = data['waypoint_order'] as List;
  if(order.isNotEmpty){
    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      instruction: Instructions.fromMap(map),
      waypointsOrder: order,
    );
  }
  else{
    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      instruction: Instructions.fromMap(map),
    );
  }
  }

  List<List<double>> getPolypoints(){
    List<List<double>> coords = [];
    for(PointLatLng point in polylinePoints){
      List<double> coord = [];
      coord.add(point.latitude); 
      coord.add(point.longitude);
      coords.add(coord);
    }
    return coords;
  }
}