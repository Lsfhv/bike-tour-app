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

  Future<void> refreshDataBase() async{ 
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    updateFirebase(snapshot);
  }

  Future<Set<BikePointModel>> fetchBikePoints() async {
    // Stopwatch stopwatch = Stopwatch()..start();
    Set<BikePointModel> bikePoints ={};
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    if(!snapshot.hasData){
      return updateFirebase(snapshot);
    }

    else{ 
       for(QueryDocumentSnapshot doc in snapshot.data!.docs){
          bikePoints.add(BikePointModel.fromDS(doc));
       }
    }
    return bikePoints;
  }

  Future<Set<BikePointModel>> getNearbyParkingDocks(LatLng point,{int uses = 1}) async{
    Set<BikePointModel> nearby_docks = {};
    Set<BikePointModel> bikePoints ={};
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    for(QueryDocumentSnapshot doc in snapshot.data!.docs){
          bikePoints.add(BikePointModel.fromDS(doc));
    }
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

  Future<Set<BikePointModel>> getNearbyBikingDocks(LatLng point, {int uses = 1}) async{
    Set<BikePointModel> nearby_docks = {};
    Set<BikePointModel> bikePoints ={};
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    for(QueryDocumentSnapshot doc in snapshot.data!.docs){
          bikePoints.add(BikePointModel.fromDS(doc));
    }
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
    
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    bool empty = snapshot.hasData;
    if(!empty){
      QueryDocumentSnapshot  doc = snapshot.data!.docs[snapshot.data!.docs.indexWhere((element) => element.id == dock.id)];
        int new_parking_uses = doc.get(BikeCollectionConstants.NbUsedParkings) + number;
        int constant_bike_use = doc.get(BikeCollectionConstants.NbUsedBikes);

        await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(doc.id).update({
          BikeCollectionConstants.Lat: dock.lat,
          BikeCollectionConstants.Lon: dock.lon,
          BikeCollectionConstants.Name: dock.commonName,
          BikeCollectionConstants.NbBikes: (dock.NbBikes - constant_bike_use <=0 ) ? 0 : dock.NbBikes - constant_bike_use,
          BikeCollectionConstants.NbEmptyDocks: (dock.NbEmptyDocks - new_parking_uses <= 0) ? 0 : dock.NbEmptyDocks - new_parking_uses,
          BikeCollectionConstants.NbDocks: dock.NbDocks,
          BikeCollectionConstants.NbUsedBikes : constant_bike_use,
          BikeCollectionConstants.NbUsedParkings :new_parking_uses,
        });

      
    }
  }

  increaseBikeUsed(BikePointModel dock,{int number = 1}) async{
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    bool empty = snapshot.hasData;
    if(!empty){
      QueryDocumentSnapshot  doc = snapshot.data!.docs[snapshot.data!.docs.indexWhere((element) => element.id == dock.id)];
        int new_bike_uses = doc.get(BikeCollectionConstants.NbUsedBikes) + number;
        int constant_parking_use = doc.get(BikeCollectionConstants.NbUsedParkings);

        await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(doc.id).update({
          BikeCollectionConstants.Lat: dock.lat,
          BikeCollectionConstants.Lon: dock.lon,
          BikeCollectionConstants.Name: dock.commonName,
          BikeCollectionConstants.NbBikes: (dock.NbBikes - new_bike_uses <=0 ) ? 0 : dock.NbBikes - new_bike_uses,
          BikeCollectionConstants.NbEmptyDocks: (dock.NbEmptyDocks - constant_parking_use <= 0) ? 0 : dock.NbEmptyDocks - constant_parking_use,
          BikeCollectionConstants.NbDocks: dock.NbDocks,
          BikeCollectionConstants.NbUsedBikes : new_bike_uses,
          BikeCollectionConstants.NbUsedParkings :constant_parking_use,
        });

      
    }
  }

  decreaseParkingUsed(BikePointModel dock, {int number = 1}) async{
    
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    bool empty = snapshot.hasData;
    if(!empty){
      QueryDocumentSnapshot  doc = snapshot.data!.docs[snapshot.data!.docs.indexWhere((element) => element.id == dock.id)];
        
        int new_parking_uses = 
        (doc.get(BikeCollectionConstants.NbUsedParkings) - number < 0)?
        0:
        doc.get(BikeCollectionConstants.NbUsedParkings) - number;
        
        int constant_bike_use = doc.get(BikeCollectionConstants.NbUsedBikes);

        await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(doc.id).update({
          BikeCollectionConstants.Lat: dock.lat,
          BikeCollectionConstants.Lon: dock.lon,
          BikeCollectionConstants.Name: dock.commonName,
          BikeCollectionConstants.NbBikes: (dock.NbBikes - constant_bike_use <=0 ) ? 0 : dock.NbBikes - constant_bike_use,
          BikeCollectionConstants.NbEmptyDocks: (dock.NbEmptyDocks - new_parking_uses <= 0) ? 0 : dock.NbEmptyDocks - new_parking_uses,
          BikeCollectionConstants.NbDocks: dock.NbDocks,
          BikeCollectionConstants.NbUsedBikes : constant_bike_use,
          BikeCollectionConstants.NbUsedParkings :new_parking_uses,
        });

      
    }
  }

  decreaseBikeUsed(BikePointModel dock,{int number = 1}) async{
    QuerySnapshot ss = await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).snapshots().first;
    AsyncSnapshot<QuerySnapshot> snapshot = await AsyncSnapshot.withData(ConnectionState.active, ss);
    bool empty = snapshot.hasData;
    if(!empty){
      QueryDocumentSnapshot  doc = snapshot.data!.docs[snapshot.data!.docs.indexWhere((element) => element.id == dock.id)];
        
        int new_bike_uses = 
        (doc.get(BikeCollectionConstants.NbUsedBikes) - number < 0)? 
        0 : 
        doc.get(BikeCollectionConstants.NbUsedBikes) - number;

        int constant_parking_use = doc.get(BikeCollectionConstants.NbUsedParkings);

        await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(doc.id).update({
          BikeCollectionConstants.Lat: dock.lat,
          BikeCollectionConstants.Lon: dock.lon,
          BikeCollectionConstants.Name: dock.commonName,
          BikeCollectionConstants.NbBikes: (dock.NbBikes - new_bike_uses <=0 ) ? 0 : dock.NbBikes - new_bike_uses,
          BikeCollectionConstants.NbEmptyDocks: (dock.NbEmptyDocks - constant_parking_use <= 0) ? 0 : dock.NbEmptyDocks - constant_parking_use,
          BikeCollectionConstants.NbDocks: dock.NbDocks,
          BikeCollectionConstants.NbUsedBikes : new_bike_uses,
          BikeCollectionConstants.NbUsedParkings :constant_parking_use,
        });

      
    }
  }

  _update_to_firestore(AsyncSnapshot<QuerySnapshot> snapshot,Map<String, dynamic> json)async{

      int current_bike_use = 0; //default values
      int current_parking_use = 0; //default values
      if(snapshot.hasData){
        current_parking_use = snapshot.data!.docs.singleWhere((element) => element.id == json['id'])[BikeCollectionConstants.NbUsedParkings];
        current_bike_use =snapshot.data!.docs.singleWhere((element) => element.id == json['id'])[BikeCollectionConstants.NbUsedBikes];
      }
      await FirebaseFirestore.instance.collection(BikeCollectionConstants.collectionName).doc(json['id']).set({
          BikeCollectionConstants.Lat: json['lat'],
          BikeCollectionConstants.Lon: json['lon'],
          BikeCollectionConstants.Name: json['commonName'],
          BikeCollectionConstants.NbBikes: (json['additionalProperties'][6]['value'] - current_bike_use <=0 ) ? 0 : json['additionalProperties'][6]['value'] - current_bike_use,
          BikeCollectionConstants.NbEmptyDocks: (json['additionalProperties'][7]['value'] - current_parking_use <= 0) ? 0 : json['additionalProperties'][7]['value'] - current_parking_use,
          BikeCollectionConstants.NbDocks: json['additionalProperties'][8]['value'],
          BikeCollectionConstants.NbUsedBikes : current_bike_use,
          BikeCollectionConstants.NbUsedParkings :current_parking_use,
        }, SetOptions(merge: true));
  }

  Future<Set<BikePointModel>> updateFirebase(AsyncSnapshot<QuerySnapshot> snapshot) async{
    Set<BikePointModel> bikePoints = {};
    var response =
        await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    if(response.statusCode == 429){
      await Future.delayed(Duration(seconds: 60));
      response = await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    }
    else{
      var json = jsonDecode(response.body);
      for (int i = 0; i < json.length; i++) {
        bikePoints.add(BikePointModel.fromJson(json[i])); //CAN BE NULL, STATUS_CODE 429, RATE LIMIT EXCEEDED, TRY AGAIN IN XX SECONDS
        await _update_to_firestore(snapshot, json[i]);
      }
      // print('executed in ${stopwatch.elapsed}');
    }
    return bikePoints;
  }
  
}
