import 'package:bike_tour_app/screens/navigation/.env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
        //"Access-Control-Allow-Origin": "*", // Required for CORS support to work
        //"Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
        //"Access-Control-Allow-Headers": googleAPIKey,
        //"Access-Control-Allow-Methods": "GET, OPTIONS"
      },
    );
    print(response);
    // Check if response is successful
    if (response.statusCode == 200) {
      if ((response.data['routes'] as List).isEmpty) return null;
      return Directions.fromMap(response.data);
    }
  }
}