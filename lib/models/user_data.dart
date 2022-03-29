import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class UserPosition {
  final LatLng? center;
  //final String user_id;

  UserPosition(this.center); //,{this.place_id});
  //UserPosition.position(this.map_controller,this.position, {this.place_id , this.center});//this.user_id);
  //UserPosition.place_id(this.map_controller,this.place_id, { this.position, this.center});//this.user_id);
  Map<String,dynamic> toJson(){
    return {
      'location' : new GeoPoint(center!.latitude, center!.longitude),
    };
  }

}