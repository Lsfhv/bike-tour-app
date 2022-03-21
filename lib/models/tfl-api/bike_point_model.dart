// ignore_for_file: non_constant_identifier_names

import 'package:bike_tour_app/models/tfl-api/model_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BikePointModel {
  final id;
  final commonName;
  
  final lat;
  final lon;
  int NbBikes;
  int NbEmptyDocks;
  int NbDocks;
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
      lat : json['lat'],
      lon : json['lon']
    );
  }

  factory BikePointModel.fromDS(QueryDocumentSnapshot ss) {
    return BikePointModel(
      id: ss.get('id'),
      commonName: ss.get(BikeCollectionConstants.Name),
      NbBikes: ss.get(BikeCollectionConstants.NbBikes) - ss.get(BikeCollectionConstants.NbUsedBikes),
      NbEmptyDocks: ss.get(BikeCollectionConstants.NbEmptyDocks) - ss.get(BikeCollectionConstants.NbUsedParkings),
      NbDocks: ss.get(BikeCollectionConstants.NbDocks),
      lat : ss.get(BikeCollectionConstants.Lat),
      lon : ss.get(BikeCollectionConstants.Lon),
    );
  }




  void setDistance(double distance){
    this.distance = distance;
  }

  void updateStatus(Map<String, dynamic> json){
    NbBikes = json['additionalProperties'][6]['value'];
    NbEmptyDocks =  json['additionalProperties'][7]['value'];
    NbDocks = json['additionalProperties'][8]['value'];
  }
}
