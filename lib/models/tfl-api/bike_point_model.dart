// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class BikePointModel {
  final id;
  final commonName;

  final lat;
  final lon;
  final NbBikes;
  final NbEmptyDocks;
  final NbDocks;
  late double distance;

  BikePointModel({
    required this.id,
    required this.commonName,
    required this.NbBikes,
    required this.NbEmptyDocks,
    required this.NbDocks,
    required this.lat,
    required this.lon,
    distance,
  });

  factory BikePointModel.fromJson(Map<String, dynamic> json) {
    return BikePointModel(
        id: json['id'],
        commonName: json['commonName'],
        NbBikes: json['additionalProperties'][6]['value'],
        NbEmptyDocks: json['additionalProperties'][7]['value'],
        NbDocks: json['additionalProperties'][8]['value'],
        lat: json['lat'],
        lon: json['lon']);
  }

  get additionalProperties => null;

  void setDistance(double distance) {
    this.distance = distance;
  }
}
