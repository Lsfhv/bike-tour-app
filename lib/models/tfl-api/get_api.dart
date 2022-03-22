import 'dart:convert';
import 'dart:math';

import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:bike_tour_app/models/tfl-api/model_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetApi {

  static const double RADIUS = 2000; // in metres

  GetApi(){}

  final bikesRef = FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName);
  Future<void> refreshDataBase() async{ 
    //await updateFirebase();
  }

  Future<Set<BikePointModel>> fetchBikePoints() async {
    // Stopwatch stopwatch = Stopwatch()..start();
    Set<BikePointModel> bikePoints ={};
    var response = await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/')).whenComplete(() => print("Bike Fetch Complete")).catchError((error) => print(error));
    if(response.statusCode == 429){
      await Future.delayed(Duration(seconds: 60));
      response = await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    }
    else{
      var json = jsonDecode(response.body);
      for (int i = 0; i < json.length; i++) {
        BikePointModel dock = BikePointModel.fromJson(json[i]); //create model with json first
        DocumentReference<Map<String, dynamic>> ss = bikesRef.doc(json[i]['id']);
        await dock.init_withDS(ss);
        bikePoints.add(dock); //CAN BE NULL, STATUS_CODE 429, RATE LIMIT EXCEEDED, TRY AGAIN IN XX SECONDS
      }
      // print('executed in ${stopwatch.elapsed}');
    }
    return bikePoints;
  }

  Future<Set<BikePointModel>> getNearbyParkingDocks(LatLng point, Set<BikePointModel> bikePoints, {int uses = 1}) async{
    Set<BikePointModel> nearby_docks = {};
    for(BikePointModel dock in bikePoints){
      LatLng dock_latlng = LatLng(dock.lat,dock.lon);
      double distance = _calculate_distance(from : point, to : dock_latlng);
      if(distance <= RADIUS && dock.NbEmptyDocks >= uses){
        dock.setDistance(distance);
        nearby_docks.add(dock);
      }
    }
    return nearby_docks;
  }

  Future<Set<BikePointModel>> getNearbyBikingDocks(LatLng point, Set<BikePointModel> bikePoints, {int uses = 1}) async{
    Set<BikePointModel> nearby_docks = {};
    for(BikePointModel dock in bikePoints){
      LatLng dock_latlng = LatLng(dock.lat,dock.lon);
      double distance = _calculate_distance(from : point, to : dock_latlng);
      if(distance <= RADIUS && dock.NbBikes >= uses){
        dock.setDistance(distance);
        nearby_docks.add(dock);
      }
    }
    return nearby_docks;
  }
  
  /*
  Calculating distance with LatLng
  =ACOS( SIN(from_lat*PI()/180)*SIN(to_lat*PI()/180) + COS(from_lat*PI()/180)*COS(to_lat*PI()/180)*COS(to_lon*PI()/180-from_lon*PI()/180) ) * 6371000
  */
  double _calculate_distance({required LatLng from,required LatLng to}){
      double distance = 0;
      const double RADIUS_OF_EARTH = 6371000;
      double a1 = from.latitude * pi/180;
      double a2 = to.latitude * pi/180;
      double b1 = (to.latitude - from.latitude) * pi/180;
      double b2 = (to.longitude - from.longitude) * pi/180;

      double k = sin(b1/2) * sin(b1/2) +
                cos(a1) * cos(a2) *
                sin(b2/2) * sin(b2/2);
      double c = 2 * atan2(sqrt(k), sqrt(1-k));

      distance = c * RADIUS_OF_EARTH;
      

      return distance;
   }

  increaseParkingUsed(BikePointModel dock, {int number = 1}) async{
    
    DocumentReference<Map<String, dynamic>> ss = bikesRef.doc(dock.id);
    int new_parking_uses = (ss.get().then((value) => value.get(BikeCollectionConstants.NbUsedParkings)) as int) + number;

    await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(dock.id).update({
      BikeCollectionConstants.NbUsedParkings :new_parking_uses,
    });      
    
  }

  increaseBikeUsed(BikePointModel dock,{int number = 1}) async{
    DocumentReference<Map<String, dynamic>> ss = bikesRef.doc(dock.id);
    int new_bike_uses = (ss.get().then((value) => value.get(BikeCollectionConstants.NbUsedBikes)) as int) + number;
    await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(dock.id).update({
      BikeCollectionConstants.NbUsedBikes : new_bike_uses,
    });
  }
  

  decreaseParkingUsed(BikePointModel dock, {int number = 1}) async{
    DocumentReference<Map<String, dynamic>> ss = bikesRef.doc(dock.id);
    int new_parking_uses = (ss.get().then((value) => value.get(BikeCollectionConstants.NbUsedParkings)) as int) - number;

    await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(dock.id).update({
      BikeCollectionConstants.NbUsedParkings :new_parking_uses,
    }); 
  }

  decreaseBikeUsed(BikePointModel dock,{int number = 1}) async{
    DocumentReference<Map<String, dynamic>> ss = bikesRef.doc(dock.id);
    int new_bike_uses = (ss.get().then((value) => value.get(BikeCollectionConstants.NbUsedBikes)) as int) + number;
    await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(dock.id).update({
      BikeCollectionConstants.NbUsedBikes : new_bike_uses,
    });
  }
  

  
  Future<void> initDatabase() async{
     // Stopwatch stopwatch = Stopwatch()..start();
    var response =
        await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    if(response.statusCode == 429){
      await Future.delayed(Duration(seconds: 60));
      response = await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    }
    else{
      var json = jsonDecode(response.body);
      for (int i = 0; i < json.length; i++) {
        BikePointModel dock = BikePointModel.fromJson(json[i]); //create model with json first
        bikesRef.doc(dock.id).set(dock.toDSJson()).whenComplete(() => print("done")).catchError((error) => print(error));
      }
    }

  }
}

