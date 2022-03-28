// ignore_for_file: non_constant_identifier_names

import 'dart:collection';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';


class Instructions {
  final List<Instruction> instructions;
  const Instructions({required this.instructions});

  factory Instructions.fromFS(Map<String, dynamic> value){
   List<Instruction> instructions =[];
   final Map<String,dynamic> _instructions = value["instructions"];
   for(int i =0; i< _instructions.values.length; i++){
     instructions.insert(i,Instruction.fromFS(_instructions[i.toString()]));
   }
   return Instructions(instructions: instructions);
  }

  Map<String, dynamic> toJson(){
    Map<String,dynamic> map= {};
    for(int i = 0; i < instructions.length ;i++){
      map.addAll({i.toString() : instructions[i].toJson()});
    }
    return map;
  }

  Instruction get(int i){
    if(i < instructions.length){
      return instructions[i];
    }
    else{
      throw IndexError(i, instructions);
    }
  }
  

  factory Instructions.fromMap(Map<String, dynamic> map){
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) {
      
    }
    List<Instruction> instructions = [];
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

 

    final steps = data['legs'][0]['steps'] as List;
    if(steps.isNotEmpty){
    
      for(int i = 0; i < steps.length; i++){
        final step = steps[i];
        LatLng start_point = LatLng(step['start_location']['lat'], step['start_location']['lng']);
        LatLng end_point = LatLng(step['end_location']['lat'], step['end_location']['lng']);
        String polyline = step['polyline']['points'];
        String instruction = step['html_instructions'];
        String travel_mode = step['travel_mode'];
        int distance = step['distance']['value'] ;
        int time = step['duration']['value'];
        String distance_text = step['distance']['text'];
        String time_text = step['duration']['text'];
        Instruction instruction_x = Instruction(start_loc: start_point, end_loc: end_point, 
        polyline: polyline, instruction: instruction, travel_mode : travel_mode, distance: distance, time: time,
        distance_text: distance_text, time_text: time_text);
        instructions.add(instruction_x);
      } 

    }
  return Instructions(instructions: instructions);
  }


  Instructions operator +(Instructions others){
    return Instructions(instructions: this.instructions + others.instructions);
  }

}

class Instruction {
  final LatLng start_loc;
  final LatLng end_loc;
  final String polyline;
  final String instruction;
  final String travel_mode;
  final int distance; //value in meter
  final int time; // value in seconds
  final String distance_text; //shows the 'stringified' version of distance
  final String time_text; //shows the 'stringified' version of time
  const Instruction({
    required this.start_loc,
    required this.end_loc,
    required this.polyline,
    required this.instruction,
    required this.travel_mode,
    required this.distance,
    required this.time,
    required this.distance_text,
    required this.time_text,
  });

  factory Instruction.fromFS(Map<String, dynamic> value){
    GeoPoint gp_start = value["start_loc"];
    GeoPoint gp_end = value["end_loc"];
    String poly = value["polyline"];
    String instruc = value["instruction"];
    String travel_mode = value["travel_mode"];
    int distance = value["distance"];
    int time = value["time"];
    String distance_text = value["distance_text"];
    String time_text = value["time_text"];
    LatLng start = LatLng(gp_start.latitude, gp_start.longitude);
    LatLng end = LatLng(gp_end.latitude, gp_end.longitude);

    return Instruction(start_loc: start, end_loc: end, polyline: poly, 
    instruction: instruc, travel_mode: travel_mode, distance: distance, 
    time: time, distance_text: distance_text, time_text: time_text);

  }

  Map<String,dynamic> toJson(){
    return {
      "start_loc" :  GeoPoint(start_loc.latitude, start_loc.longitude),
      "end_loc" :  GeoPoint(end_loc.latitude, end_loc.longitude),
      "polyline" : polyline,
      "instruction" : instruction,
      "travel_mode" : travel_mode,
      "distance" : distance,
      "time" : time,
      "distance_text" : distance_text,
      "time_text" : time_text,
    };
  }

  bool stillInInstruction(LatLng point){
    
    String polylineResult = encodePoint(point.latitude) + encodePoint(point.longitude); 
    if(polyline.contains(polylineResult)){
      return true;
    }
    else{
      return false;
    }
  }
}