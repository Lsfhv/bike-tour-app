import 'package:bike_tour_app/models/journey_data_with_route_model.dart';

import 'user_data.dart';

class RouteData{
  // final Directions directions;
  // final UserPosition user_loc;
  // final Set<Marker> markers;
  // final List<LatLng> waypoints;

  final UserPosition user_loc;
  final JourneyDataWithRoute jdwr;

  RouteData({ required this.user_loc, required this.jdwr});
}