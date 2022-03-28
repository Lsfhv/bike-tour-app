import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repository/direction.dart';
import '../screens/markers/bike_markers.dart';
import '../screens/markers/destination_marker.dart';
import '../screens/markers/user_location_marker.dart';
import '../screens/widgets/compass.dart';
import 'bike_point_model.dart';
import 'destination_model.dart';
import 'directions_model.dart';
import 'user_data.dart';

class JourneyData {
  UserPosition currentPosition;
  List<Destination> destinations;
  List<Destination> formated_list = [];
  GetApi bike_api = GetApi();
  List<LatLng> waypoints = [];
  Set<Marker> markers = {};
  Compass compass = Compass();
  int number_of_bikers = 1;
  JourneyData(this.currentPosition, this.destinations);
  JourneyData._fromFS(this.currentPosition, this.destinations, 
                      this.formated_list, this.markers, this.waypoints
                      );
  Set<BikePointModel> bikePointsUsed ={};


  factory JourneyData.fromFS(Map<String, dynamic> value, UserPosition user){
    //destination list dealt with
    List<Destination> destinations = [];
    final Map<String,dynamic>_destdata = value["destinations"];
    for(int i =0; i< _destdata.values.length ; i++){
      destinations.insert(i,
        Destination.fromFS(_destdata[i.toString()])
      );
      i++;
    }



    //Initialise markers with data
    Set<Marker> marker = {};
    marker.add(UserMarker(user: user));
    for(Destination d in destinations){
      marker.add(DestinationMarker(destination: d));
    }
    
    final Map<String,dynamic> _bikePointsData = value["bike_points_used"];
    for(int j =0; j<_bikePointsData.values.length; j++){
      marker.add(BikeMarker.fromFS(_bikePointsData["j"]));
    }

    

    //destination list dealt with
    List<Destination> formated_list = [];
    if(destinations.length >2){
      final Map<String,dynamic> data = value["formated_list"];
      for(var v in data.values){
        formated_list.add(
          Destination.fromFS(v)
        );
      }
    }

        //destination list dealt with
    List<LatLng> waypoints = [];
    final Map<String,dynamic> w_data = value["waypoint"];
    for(int k =0; k < w_data.values.length; k++){
      waypoints.insert(k, LatLng( (w_data[k.toString()]).latitude, (w_data[k.toString()]).longitude));
    }
    
    

    return JourneyData._fromFS(user, destinations, formated_list, marker, waypoints);
    
  }

  Map<String,dynamic> toJson(){
    if(formated_list.isNotEmpty ){
      return {
        "destinations" : Map.fromIterable(destinations, 
          key : (e) => destinations.indexOf(e).toString(),
          value: (e) => (e as Destination).toJson()
        ),
        "formated_list" : Map.fromIterable(formated_list, 
          key: (e) => formated_list.indexOf(e).toString(), 
          value : (e) => (e as Destination).toJson()
        ),
        // "waypoint" :Map.fromIterable(
        //   waypoints,
        //   key: (element) => waypoints.indexOf(element),
        //   value: (e) => GeoPoint((e as LatLng).latitude, (e as LatLng).longitude),
        // ),
        'markers' : Map.fromIterable(
          markers,
          key: (e) => (e as Marker).markerId.value,
          value: (e) => [GeoPoint((e as Marker).position.latitude, (e as Marker).position.longitude), e.runtimeType],
          ),
        'bike_points_used' : Map.fromIterable(
          bikePointsUsed,
          key: (e) => (e as BikePointModel).id,
          value: (e) => GeoPoint((e as BikePointModel).lat,(e as BikePointModel).lon)
        )
      };
    }
    return {
        "destinations" : Map.fromIterable(destinations, 
          key : (e) => destinations.indexOf(e).toString(),
          value: (e) => (e as Destination).toJson()
        ),
        // "waypoint" :Map.fromIterable(
        //   waypoints,
        //   key: (element) => waypoints.indexOf(element).toString(),
        //   value: (e) => GeoPoint((e as LatLng).latitude, (e as LatLng).longitude),
        // ),
        'markers' : Map.fromIterable(
          markers,
          key: (e) => (e as Marker).markerId.toString(),
          value: (e) => GeoPoint((e as Marker).position.latitude, (e as Marker).position.longitude),
          ),
        'bike_points_used' : Map.fromIterable(
          bikePointsUsed,
          key: (e) => (e as BikePointModel).id,
          value: (e) => GeoPoint((e as BikePointModel).lat,(e as BikePointModel).lon)
        )
      };
  }
  rerouteWaypoints(Directions? args){
    List<Destination> buffer=List.of(destinations);
    //_destinations.clear();
    for(var i in args!.waypointsOrder){
      destinations.add(buffer[i]);
    }
  }

  routeOptimize() async {
    //choose the last destination
    List<LatLng> list = List<LatLng>.generate(destinations.length, (i)=> destinations[i].position);
    await DirectionsRepository().getDirections(origin: currentPosition.center as LatLng, ending_bike_dock: currentPosition.center as LatLng , destinations: list, optimize: true).
    then((value) => {
      rerouteWaypoints(value)
    });
    //get directions
    //
  }
  init() async{
       
       
       Stopwatch stopwatch = Stopwatch()..start();
    
    
    Map<String , List<BikePointModel>> bikePoints = await bike_api.fetchBikePointsGroupedByPostCode();
    if(destinations.length > 1){
      await routeOptimize();
      print('route Optimise executed in ${stopwatch.elapsed}');
    }
    waypoints = [];
    markers = {};

    //init starting loc in red 
    markers.add(UserMarker(user : UserPosition(currentPosition.center as LatLng)));
    //waypoints.add(currentPosition.center as LatLng); //think about this again yo
    
    for(int i = -1; i < destinations.length -1; i++){
      var start; 
      Destination end;
      BikePointModel? starting_dock;
      BikePointModel? ending_dock;
      if(i== -1){
        start = currentPosition;
        end = destinations[0];
        String start_postcode = await bike_api.getPostCode((start as UserPosition).center as LatLng);
        starting_dock = choosingDock(await bike_api.getNearbyBikingDocks((start as UserPosition).center as LatLng, bikePoints, start_postcode, uses: number_of_bikers));
      }
      else{
        start =  destinations[i];
        end = destinations[i+1];
        String start_postcode = await bike_api.getPostCode(LatLng((start as BikePointModel).lat,(start as BikePointModel).lon));
        starting_dock = choosingDock(await bike_api.getNearbyBikingDocks((start as Destination).position, bikePoints, start_postcode, uses: number_of_bikers));
      }
      print('starting dock choosing executed in ${stopwatch.elapsed}');
      if(starting_dock != null){
        String end_postcode = await bike_api.getPostCode((end as Destination).position);
        ending_dock = choosingDock(await bike_api.getNearbyParkingDocks(end.position, bikePoints, end_postcode,uses: number_of_bikers));
        if(ending_dock != null){
          //add starting_dock,destination,ending_dock
          waypoints.add(LatLng(starting_dock.lat, starting_dock.lon));
          waypoints.add(LatLng(ending_dock.lat,ending_dock.lon));
          waypoints.add(end.position);

          markers.add(BikeMarker(station: starting_dock));
          markers.add(DestinationMarker(destination: end));
          markers.add(BikeMarker(station: ending_dock));

          bikePointsUsed.addAll({starting_dock as BikePointModel,ending_dock as BikePointModel});

          await bike_api.increaseBikeUsed(starting_dock, number: number_of_bikers);
          await bike_api.increaseParkingUsed(ending_dock, number: number_of_bikers);
        }
        print('ending dock choosing executed in ${stopwatch.elapsed}');
      }
      else{
        waypoints.add(end.position);
        markers.add(DestinationMarker(destination: end));
      }
    } 

      print('executed in ${stopwatch.elapsed}');

  }


  
  BikePointModel? choosingDock(Set<BikePointModel> docks){ //update to accommodate number restriction
    if(docks.isEmpty){
      return null;
    }
    else{
      BikePointModel chosen = docks.first; 
      for(BikePointModel dock in docks){
        if(dock.distance < chosen.distance){
          chosen = dock;
        }
      }
      return chosen;
    }
  }

  LatLng getLastDockingStation(){
    return waypoints.last;
  }

 endTrip() async{
   for(int i =0; i < markers.length; i++){
     if(markers.elementAt(i).runtimeType == BikeMarker){
      BikePointModel starting_dock = (markers.elementAt(i) as BikeMarker).station;
      BikePointModel end_dock = (markers.elementAt(i+2) as BikeMarker).station;

      i = i+2;

      bike_api.decreaseBikeUsed(starting_dock, number: number_of_bikers);
      bike_api.decreaseParkingUsed(end_dock, number: number_of_bikers);
     }
   }
 }
}
