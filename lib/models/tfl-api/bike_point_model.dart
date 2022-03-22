// ignore_for_file: non_constant_identifier_names

import 'package:bike_tour_app/models/tfl-api/model_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BikePointModel {
  final id;
  final commonName;
  static const String DEFAULT_NUMBER_FOR_NO_DATA= '100';
  final lat;
  final lon;
  int NbBikes;
  int NbEmptyDocks;
  int NbDocks;
  double distance;
  int usedBikes;
  int usedParkings;

  BikePointModel({
    required this.id,
    required this.commonName,
    required this.NbBikes,
    required this.NbEmptyDocks,
    required this.NbDocks,
    required this.lat,
    required this.lon,
    this.distance = 0,
    this.usedBikes = 0,
    this.usedParkings = 0,
  });

  factory BikePointModel.fromJson(Map<String, dynamic> json) {
    return BikePointModel(
      id: json['id'],
      commonName: json['commonName'],
      NbBikes: int.parse( (json['additionalProperties'][6]['value'] as String).length == 0 ? (json['additionalProperties'][6]['value'] as String) : DEFAULT_NUMBER_FOR_NO_DATA ),
      NbEmptyDocks: int.parse((json['additionalProperties'][7]['value'] as String).length == 0 ? (json['additionalProperties'][7]['value'] as String) : DEFAULT_NUMBER_FOR_NO_DATA ),
      NbDocks: int.parse((json['additionalProperties'][8]['value'] as String).length == 0 ? (json['additionalProperties'][8]['value'] as String) : DEFAULT_NUMBER_FOR_NO_DATA ),
      lat : json['lat'],
      lon : json['lon']
    );
  }

  init_withDS(DocumentReference ss) async{
      DocumentSnapshot snapshot = await ss.get();
      this.usedBikes = snapshot.get(BikeCollectionConstants.NbUsedBikes); //ss.get(BikeCollectionConstants.NbUsedBikes);
      this.usedParkings = snapshot.get(BikeCollectionConstants.NbUsedParkings);
  }


  Map<String, Object?> toJson() {
    return {
      'id' : id,
      BikeCollectionConstants.Name: commonName,
      BikeCollectionConstants.NbBikes :  NbBikes,
      BikeCollectionConstants.NbEmptyDocks : NbEmptyDocks,
      BikeCollectionConstants.NbDocks : NbDocks,
      BikeCollectionConstants.Lat : lat,
      BikeCollectionConstants.Lon : lon,
      BikeCollectionConstants.NbUsedBikes : usedBikes,
      BikeCollectionConstants.NbUsedParkings : usedParkings,
    };
  }

  Map<String, Object?> toDSJson() {
    return {
      'id' : id,
      BikeCollectionConstants.NbUsedBikes : usedBikes,
      BikeCollectionConstants.NbUsedParkings : usedParkings,
    };
  }


  void setDistance(double distance){
    this.distance = distance;
  }

  int getNumberOfParking(){
    return this.NbEmptyDocks - this.usedParkings;
  }

  int getNumberOfBikes(){
    return this.NbBikes - this.usedBikes;
  }

  void updateStatus(Map<String, dynamic> json){
    NbBikes = json['additionalProperties'][6]['value'];
    NbEmptyDocks =  json['additionalProperties'][7]['value'];
    NbDocks = json['additionalProperties'][8]['value'];
  }
}
