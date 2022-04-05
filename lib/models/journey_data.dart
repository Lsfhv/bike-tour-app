import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  GetApi bike_api = GetApi();
  List<LatLng> waypoints = [];
  List<dynamic> order =[];
  Set<Marker> markers = {};
  Compass compass = Compass();
  int number_of_bikers = 1;
  JourneyData(this.currentPosition, this.destinations);
  JourneyData._fromFS(this.currentPosition, this.destinations, this.markers, this.waypoints,
                      );
  Set<BikePointModel> bikePointsUsed ={};


  factory JourneyData.fromFS(Map<String, dynamic> value, UserPosition user){
    //destination list dealt with
    final Map<String,dynamic>_destdata = value["destinations"];
    List<Destination> destinations = List.empty(growable: true);
    for(int i =0; i< _destdata.values.length ; i++){
      destinations.insert(i,
        Destination.fromFS(_destdata[i.toString()])
      );
    }



    //Initialise markers with data
    Set<Marker> marker = {};
    marker.add(UserMarker(user: user));
    for(Destination d in destinations){
      marker.add(DestinationMarker(destination: d));
    }
    
    final Map<String,dynamic> _bikePointsData = value["bike_points_used"];
    
    // for(int j =0; j<_bikePointsData.values.length; j++){
    //   marker.add(BikeMarker.fromFS(_bikePointsData[j]));
    // }
    _bikePointsData.forEach(
      (key, value) => {marker.add(BikeMarker.fromFS({key : value}))}
    );

    


        //destination list dealt with
    List<LatLng> waypoints = [];
    final List<dynamic> w_data = value["waypoint"];
    for(int k =0; k < w_data.length; k++){
      waypoints.insert(k, LatLng( (w_data[k]).latitude, (w_data[k]).longitude));
      waypoints.insert(k, LatLng( (w_data[k]).latitude, (w_data[k]).longitude));
    }

    List order = value['waypointOrder'];

    
    

    final JourneyData result = JourneyData._fromFS(user, destinations, marker, waypoints);
    result.order = order;
    return result;
    
  }

  Map<String,dynamic> toJson(){
    return {
        "destinations" : Map.fromIterable(destinations, 
          key : (e) => destinations.indexOf(e).toString(),
          value: (e) => (e as Destination).toJson()
        ),
        'waypointOrder' : order,
        'waypoint' : List.generate(waypoints.length, (index) => GeoPoint( waypoints[index].latitude, waypoints[index].longitude)),
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
   List<Destination> formated_list = [];
   order = args!.waypointsOrder;
    for(var i in args.waypointsOrder){
      formated_list.add(buffer[i]);
    }
    destinations = formated_list;
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
        String start_postcode = await bike_api.getPostCode((start as Destination).position);
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

  Future<String> _getGroupCode() async{
    try {
      String uid = await FirebaseAuth.instance.currentUser!.uid;
      String group_code = "";
      await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => group_code = value.data()!['group code']);
      return group_code;
    }on StateError catch (e) {
      return "";
    }
    on TypeError catch(e){
      return "";
    }
  }
  
  Future<bool> _checkValidityOfCode(String code)async {
    try{
      bool exist = false;
      print(code);
      await FirebaseFirestore.instance.collection("group_journey").doc(code).get().then((value) => {
        if(value.exists){
          exist = true
        }
      });
      return exist;
    }
    on StateError catch (_){
      print(_);
      return false;
    }
  }

   bool _isLeader(DocumentSnapshot<Map<String, dynamic>> value, String uid){
    try{
      return uid == value.data()!["leader"];
    }
    on StateError catch (_){
      return false;
    }
  }

  Future<bool> _checkIfGroupLeader() async{
    //first check if user in a group, only leaders reach this page!
    
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String group_code ='';
    bool isLeader = false;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then(
      (value) => group_code = value.data()!['group code']
    );
    await FirebaseFirestore.instance.collection("group_journey").doc(group_code).get().then(
      (value) => isLeader = _isLeader(value, uid)
    );

  return isLeader;
  }


 endTrip() async{
  for(int i =0; i < markers.length; i++){
    if(markers.elementAt(i).runtimeType == BikeMarker){
    BikePointModel starting_dock = (markers.elementAt(i) as BikeMarker).station as BikePointModel;
    BikePointModel end_dock = (markers.elementAt(i+2) as BikeMarker).station as BikePointModel;

    i = i+2;

    await bike_api.decreaseBikeUsed(starting_dock, number: number_of_bikers);
    await bike_api.decreaseParkingUsed(end_dock, number: number_of_bikers);
    }
  }
  String group_code = await _getGroupCode();
  String uid = await FirebaseAuth.instance.currentUser!.uid;
  if(group_code.isNotEmpty && await _checkValidityOfCode(group_code)){
    if(await _checkIfGroupLeader()){
      //await FirebaseFirestore.instance.collection("group_journey").doc(group_code).update({"leader" : FieldValue.delete()}).then((value) => print("Leader removed"));
      await FirebaseFirestore.instance.collection("group_journey").doc(group_code).delete().then((value) => print("Journey deleted"));
    }
    else{
    // var val= [];
    // val.add(uid);
    // await FirebaseFirestore.instance.collection('group_journey').doc(group_code).update({'members' : FieldValue.arrayRemove(val) }).then((value) => 
    // print("Removed member from journey"));
    }
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'group code' : FieldValue.delete()}).then((value) => print("Group code for user deleted"));
  }
  //check if its group leader
 }

}
