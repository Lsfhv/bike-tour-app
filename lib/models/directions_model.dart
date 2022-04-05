import 'dart:collection';
import 'dart:core';

import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late List<dynamic> waypointsOrder;
  static const List<dynamic> default_order =[];
  late String polypointsEncoded;
  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.instruction,
    this.waypointsOrder = default_order,
    this.polypointsEncoded = "",
  });

  factory Directions.fromFS(Map<String,dynamic> value){
  // Bounds
    
    final northeast = value['bounds']['northeast'];
    final southwest = value['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast.latitude, northeast.longitude),
      southwest: LatLng(southwest.latitude, southwest.longitude),
    );
    
    //polypoints
    // List<PointLatLng> points =[];
    // final Map<String,dynamic> _points = value["polylinePoints"];
    // for(var v in _points.values){
    //   points.add(PointLatLng(v.latitude, v.longitude));
    // }
    String encodedPolyPoints = value['polyPoints_encoding'] as String;


    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(encodedPolyPoints),
      totalDistance: value['total Distance'],
      totalDuration: value['total Duration'],
      instruction: Instructions.fromFS(value),
      waypointsOrder : value['waypointsOrder'] as List<dynamic>,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "bounds" : {
        "northeast" : GeoPoint(bounds.northeast.latitude, bounds.northeast.longitude),
        "southwest" : GeoPoint(bounds.southwest.latitude,bounds.southwest.longitude),
      },
      // ignore: prefer_for_elements_to_map_fromiterable
      "polylinePoints" : Map.fromIterable(
                            polylinePoints, 
                            key : (e) => polylinePoints.indexOf(e).toString(), 
                            value : (e) =>GeoPoint((e as PointLatLng).latitude, (e as PointLatLng).longitude)
                            ),
      "polyPoints_encoding" : polypointsEncoded,
      "total Distance" : totalDistance,
      "total Duration" : totalDuration,
      "instructions" : instruction.toJson(),
      "waypointsOrder" : waypointsOrder//Map.fromIterable(waypointsOrder, key :(e) => waypointsOrder.indexOf(e).toString(), value: (e) => e )
    };
  }


  factory Directions.fromMap(Map<String, dynamic> map) {
    
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) {
      //something here if route empty maybe say route not found!
    }
    List<Instruction> instructions = [];
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);
    List<dynamic> order = [];


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
    order = data['waypoint_order'];
  // if(order.isNotEmpty){
    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      instruction: Instructions.fromMap(map),
      waypointsOrder: order,
      polypointsEncoded : data['overview_polyline']['points'] as String
    );
  // }
  // else{
  //   return Directions(
  //     bounds: bounds,
  //     polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
  //     totalDistance: distance,
  //     totalDuration: duration,
  //     instruction: Instructions.fromMap(map),
  //     polypointsEncoded : data['overview_polyline']['points'] as String
  //   );
  // }
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