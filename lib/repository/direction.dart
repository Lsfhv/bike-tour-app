import 'dart:convert';
import 'dart:io';

// import 'package:bike_tour_app/.env.dart';
import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../.env.dart';
import '../models/directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  String destinations_string(List<LatLng> destinations,bool optimize){
    String destinations_out = '';
    if(optimize){
      destinations_out +='optimize:true|';
      for(LatLng destination in destinations){
        destinations_out += '${destination.latitude},${destination.longitude}|';     
      }
    }
    else{
      for(LatLng destination in destinations){
        destinations_out += 'via:${destination.latitude},${destination.longitude}|';     
      }
    }
    if(destinations_out.isEmpty){
      return '';
    }
    return destinations_out;
  }

  Future<Directions?> getDirections({
    required LatLng origin,
    required List<LatLng> destinations,
    required LatLng ending_bike_dock,
    bool optimize = false,
  }) async {
    final response = await _dio.get(
      DirectionsRepository._baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${ending_bike_dock.latitude},${ending_bike_dock.longitude}',
        'waypoints' : destinations_string(destinations, optimize),
        'key': googleAPIKey,
        'mode' : 'cycling',
        'region' : 'uk',
        'units' : 'metric',
      },
    );


    // Check if response is successful
    if (response.statusCode == 200) {
      if ((response.data['routes'] as List).isEmpty) return null;
      return Directions.fromMap(response.data);
    }
  }
}