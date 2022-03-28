import 'package:bike_tour_app/models/directions_model.dart';
import 'package:bike_tour_app/models/user_data.dart';

import 'journey_data.dart';

class JourneyDataWithRoute {
  final JourneyData journeyData;
  final Directions? route;

  JourneyDataWithRoute({required this.journeyData, required this.route});

  factory JourneyDataWithRoute.fromFS(Map<String, dynamic> value, UserPosition user){
    return JourneyDataWithRoute(
      journeyData: JourneyData.fromFS(value['journey']["journey data"],user), 
      route: Directions.fromFS(value['journey']["directions"]));
  }

  Map<String, dynamic> toJson(){
    //store markers,destinations and directions for navigation
    return {
      "journey data" : journeyData.toJson(),
      'directions' : route!.toJson(),
    };
    
  }
}