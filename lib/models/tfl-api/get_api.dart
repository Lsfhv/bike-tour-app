import 'dart:convert';
import 'dart:math';

import 'package:bike_tour_app/models/tfl-api/bike_point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetApi {
  Set<BikePointModel> bikePoints ={};
  static const double RADIUS = 1; // in km
  GetApi(){
  }

  Future<Set<BikePointModel>> fetchBikePoints() async {
    // Stopwatch stopwatch = Stopwatch()..start();
    var response =
        await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    var json = jsonDecode(response.body);
    for (int i = 0; i < json.length; i++) {
      bikePoints.add(BikePointModel.fromJson(json[i]));
    }
    // print('executed in ${stopwatch.elapsed}');
    return bikePoints;
  }


  Set<BikePointModel> getNearbyDocks(LatLng point){
    Set<BikePointModel> nearby_docks = {};
    for(BikePointModel dock in bikePoints){
      LatLng dock_latlng = LatLng(dock.lat,dock.lon);
      double distance = _calculate_distance(from : point, to : dock_latlng);
      if(distance <= RADIUS){
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
      distance =acos( 
        //SIN(from_lat*PI()/180)*SIN(to_lat*PI()/180)
        sin(from.latitude * pi/180) * sin(to.latitude *pi/180) ) 
        + 
        //COS(from_lat*PI()/180)*COS(to_lat*PI()/180)*COS(to_lon*PI()/180-from_lon*PI()/180)
        cos(from.latitude * pi/180) * cos(to.latitude*pi/180) * cos(to.longitude*pi/180 - from.longitude*pi/180
        ) ;


      return distance;
   }


}
