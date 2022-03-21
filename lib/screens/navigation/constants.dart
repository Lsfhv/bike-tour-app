import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Color STANDARD_COLOR = Color.fromARGB(202, 85, 190, 56).withOpacity(1);
const REACHED_LOC = const LatLng(0,0);
const Instruction REACHED_INSTRUCTION =   Instruction(
    start_loc : REACHED_LOC ,
    end_loc : REACHED_LOC,
    polyline :"",
    instruction : "You Have Reached Your Destination",
    travel_mode : "",
    distance : 0,
    time : 0,
    distance_text : "0m",
    time_text : "0s",
  );