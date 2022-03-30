
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:bike_tour_app/models/directions_model.dart';
import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/widgets/destination_list_viewer.dart';
import 'package:bike_tour_app/screens/widgets/loading_screen.dart';
import 'package:bike_tour_app/screens/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_place/google_place.dart';

// import '../../.env.dart';
import '../../.env.dart';
import '../../models/destination_model.dart';
import '../../models/journey_data.dart';
import '../../models/journey_data_with_route_model.dart';
import '../../models/user_data.dart';
import '../../repository/direction.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../../services/set_data_service.dart';
import '../markers/user_location_marker.dart';
import '../widgets/destination_retriever.dart';
import 'constants.dart';
import 'location_details.dart';







class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}

class _ToPageState extends State<ToPage> {
  final String IMAGE_PATH = 'assets/images/cycling.gif';

  late GoogleMapController mapController;
  bool first = true;
  LatLng _center = const LatLng(51.507399, -0.127689);
  final _google_geocode_API = GoogleGeocodingApi(googleAPIKey, isLogged: true);
  final googlePlace = GooglePlace(googleAPIKey);
  Icon customIcon = const Icon(Icons.search);
  List<Destination> list_of_destinations = <Destination>[];
  Set<Marker>? _markers;
  List<AutocompletePrediction> predictions = [];
  AutocompletePrediction? currPrediction = null;
  bool isSelected = false;
  bool _showDetail = false;
  bool _suggestionSelected = false;
  bool _viewingDestinationList = false;
  JourneyData? jd;
  DestinationMarker? _suggestedMarker = null;
  bool loading_state = false;
  String suggested_postcode = "";


  
  _handleNavigateToNextPage(UserPosition args){
    if(list_of_destinations.isNotEmpty){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
        title : const Text("Have you added all the places you want to visit?"),
        actions : <Widget>[
          TextButton(onPressed: () async => await  _navigateToNextPage(args) , child: const Text("Yes")),
          TextButton(onPressed: () => Navigator.pop(context, "No") , child: const Text("No"))
        ]
      )
      );
    }
    else{
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have not added any destinations in your plan! Please choose a destination!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );
    }
  }

  
  Future<Directions?> _generateRoute(JourneyData args) async{
    await args.init();
    LatLng origin = args.currentPosition.center as LatLng;
    LatLng destination = args.getLastDockingStation();
    final directions = await DirectionsRepository().getDirections(origin: origin, ending_bike_dock: destination, destinations: args.waypoints); 
    return directions;
  }


  _setToLoadingState(){
    Navigator.pop(context);
    setState(() {
      loading_state = true;
    });
  }

  _navigateToNextPage(UserPosition args)async{
    _setToLoadingState();
    jd = JourneyData(args, list_of_destinations);
    Directions? route = await _generateRoute(jd as JourneyData);
  
    if(mounted){
      setState(() {
        loading_state = false;
      });
      if( route == null){
          showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
          title : Text("Route is invalid!"),
          actions : <Widget>[
            TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
          ]
        )
        );
      }
      else{
        JourneyDataWithRoute journey = JourneyDataWithRoute(
          journeyData: jd as JourneyData,
          route : route, 
        );
        if(await _checkIfGroupLeader()){
          String uid = FirebaseAuth.instance.currentUser!.uid;
          String code = "";
          await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) => code = value.get("group code"));
          SetData().set_journey(journey: journey, code: code);
        }
        Navigator.pop(context, 'popped loading screen');
        Navigator.pushNamed(context, RoutingMap.routeName, arguments : journey);
      }
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
    try{
      await FirebaseFirestore.instance.collection("users").doc(uid).get().then(
        (value) => group_code = value.data()!['group code']
      );
      await FirebaseFirestore.instance.collection("group_journey").doc(group_code).get().then(
        (value) => isLeader = _isLeader(value, uid)
      );
      return isLeader;
    }
    on NullThrownError catch(_){
      return false;
    }
    on StateError catch(_){
      return false;
    }
    on TypeError catch(_){
      return false;
    }
  }

  void autoCompleteSearch(String value) async {
    String edited_value = value + "";//" london";
    var result = await googlePlace.autocomplete.get(edited_value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        _showDetail = false;
        _viewingDestinationList = false;
        predictions = result.predictions as List<AutocompletePrediction>;
      });
    }
  }

  _handleSearchBarChange(String destination) async {
    if (destination.isNotEmpty) {
      autoCompleteSearch(destination);
    } else {
      if (predictions.isNotEmpty && mounted) {
        setState(() {
          predictions = [];
        });
      }
    }
  }

  _handleSearchBarSubmit(String destination) async {
    String edited_destination = destination + " London";
    String description = ' ';
    GoogleGeocodingResponse loc =
        await _google_geocode_API.search(edited_destination, region: "uk");
    LatLng pos = LatLng(loc.results.first.geometry!.location.lat,
      loc.results.first.geometry!.location.lng);
    final GoogleGeocodingResponse verboseData = await _google_geocode_API.reverse('${pos.latitude}, ${pos.longitude}', language: 'en');
    String postcode = verboseData.results.first.addressComponents.last.longName as String;
    description = loc.results.first.formattedAddress;
    Destination dest = Destination(position: pos, name: description,postcode: postcode);
    //Pop that you are adding new destination
    bool destinationExist = false;
    for(Destination d in list_of_destinations){
      if(dest.equal(d)){
        destinationExist = true;
        break;
      }
    }

    if(destinationExist){
      setState(() {
        predictions =[];
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("You have already added " + description + " in your plan!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "No"),
                        child: const Text("Ok!"))
                  ]));
    }
    else{
      setState(() {
        Marker curr_marker = DestinationMarker(destination: dest);
        _markers?.add(curr_marker);
        _center = pos;
        list_of_destinations.add(dest);
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
        predictions =[];
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("You have added " + description + " in your plan!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "No"),
                        child: const Text("Ok!"))
                  ]));
    }
    //Navigate to next page
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _handleSuggestionTap(AutocompletePrediction prediction) async {
    GoogleGeocodingResponse loc = await _google_geocode_API
        .search(prediction.description as String, region: "uk");
    LatLng pos = LatLng(loc.results.first.geometry!.location.lat,
      loc.results.first.geometry!.location.lng);
    final GoogleGeocodingResponse verboseData = await _google_geocode_API.reverse('${pos.latitude}, ${pos.longitude}', language: 'en');
    String postcode = verboseData.results.first.addressComponents.last.longName as String;
    Destination destination =
          Destination(position: pos, name: prediction.description as String, postcode: postcode);
    setState(() {
      _suggestionSelected = true;
      _showDetail = true;
      currPrediction = prediction;
      _suggestedMarker = DestinationMarker(destination: destination);
      _markers?.add(_suggestedMarker as DestinationMarker);
      suggested_postcode = postcode;
      _center = pos;
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  _closePage() async {
    setState(() {
      _suggestionSelected = false;
      _showDetail = false;
      _center = _suggestedMarker!.position;
      if (_suggestedMarker != null) {
        _markers?.remove(_suggestedMarker);
        _suggestedMarker = null;
      }
      if(suggested_postcode.isNotEmpty){
        suggested_postcode = "";
      }
    });
    //_showDetail = false;
    //_markers?.remove(_suggestedMarker);
    //_suggestedMarker = null;
  }

  Widget _showDetailPage() {
    return DetailsPage(
        placeId: currPrediction!.placeId,
        googlePlace: googlePlace,
        closePage: _closePage);
  }

  _delete_destination_at(int index) async {
    late Destination removed;
    setState(() {

      _markers!.removeWhere((e) => e.markerId == MarkerId(list_of_destinations[index].name));
      removed = list_of_destinations.removeAt(index);
    });

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title:
                    Text("You have removed " + removed.name + "from your plan"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context, "No"),
                      child: const Text("Ok!"))
                ]));
  }

  _closeDestinationView() async {
    setState(() {
      _viewingDestinationList = false;
    });
  }

  Widget _showDestinationList() {
    // return GestureDetector(
    //   child :Dismissible(
    //     direction: DismissDirection.down,
    //     key: UniqueKey(),
    //     child: DestinationListViewer(
    //         destinations: list_of_destinations,
    //         onDismiss: _delete_destination_at),
    //     onDismissed: (direction) async {
    //       _closeDestinationView();
    //     },
    //   ),
    //   behavior: HitTestBehavior.translucent,
    // );
    return GestureDetector(
      child : DestinationListViewer(
            destinations: list_of_destinations,
            onDismiss: _delete_destination_at),
      behavior: HitTestBehavior.translucent,
    );
  }

  Widget appBar() {
    if (_suggestionSelected) {
      return TextField(
        decoration: InputDecoration(
          hintText: currPrediction!.description,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        onTap: _closePage,
        readOnly: !loading_state,
      );
    } else if (_viewingDestinationList) {
      return TextField(
        decoration: InputDecoration(
          hintText: "Destination List",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        onTap: _closeDestinationView,
        readOnly: !loading_state,
      );
    } else {
      return Destination_Retriever(
          onSubmitted: _handleSearchBarSubmit,
          onChanged: _handleSearchBarChange);
    }
  }

  _showDestinations() async {
    if (list_of_destinations.isNotEmpty) {
      setState(() {
        _showDetail = false;
        _viewingDestinationList = !_viewingDestinationList;
      });
    } else {
      //show destinations
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text(
                      "You have not added any destinations in your plan! Please choose a destination!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "No"),
                        child: const Text("Ok!"))
                  ]));
    }
  }

  _addDestination() async {
    Marker curr_marker = _suggestedMarker as Marker;
    Destination dest = Destination(position: curr_marker.position,name: currPrediction!.description as String, postcode: suggested_postcode);
    bool destination_already_exist =false;
    for(Destination d in list_of_destinations){
      if(dest.equal(d)){
        destination_already_exist = true;
        break;
      }
    }
    if(!destination_already_exist){
      setState(() {
        _markers?.add(curr_marker);
        _center = curr_marker.position;
        list_of_destinations.add(dest);
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
        _suggestedMarker = null;
        _suggestionSelected = false;
        predictions = [];
      });

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("You have added " +
                      (currPrediction!.description as String) +
                      " in your plan!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "No"),
                        child: const Text("Ok!"))
                  ]));
    }
    else{
      setState(() {
        _center = curr_marker.position;
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
        _suggestedMarker = null;
        _suggestionSelected = false;
        predictions = [];
      });

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("You have already added " +
                      (currPrediction!.description as String) +
                      " in your plan!"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, "No"),
                        child: const Text("Ok!"))
                  ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserPosition;
    _center = args.center as LatLng;
    if (args.center != null && first) {
      first = false;
      _markers = {UserMarker(user: UserPosition(args.center as LatLng))};
    }
    if(loading_state) {
      return LoadingScreen(
        destinations: list_of_destinations,
        loaderColor: STANDARD_COLOR, 
        image: Image.asset(
          IMAGE_PATH, 
          height: 125.0,
          width: 125.0,), //Image.asset('assets/images/kanye_west.jpg'),
        title: RichText(text: TextSpan(text: 'Generating Route')),
        initialMessage : 'Generating Route',
      );
    }
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: appBar(),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: STANDARD_COLOR,
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_circle_right_outlined),
                onPressed: () => _handleNavigateToNextPage(args),
              ),
              IconButton(
                  onPressed: () => _showDestinations(),
                  icon: Icon(Icons.route_outlined)),
              if (_suggestionSelected && _suggestedMarker != null)
                IconButton(
                    onPressed: () => _addDestination(), icon: Icon(Icons.add)),
            ],
          ),
        body: Stack(
          alignment: Alignment.center, 
          children: [
            Center(
              child: GestureDetector(
                child : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _center, zoom: 15),
                  markers: _markers as Set<Marker>,
                  zoomGesturesEnabled: !loading_state,
                  rotateGesturesEnabled: !loading_state,
                ),
                behavior: HitTestBehavior.translucent,
              ),
            ),

            if (!_showDetail && !_viewingDestinationList && !loading_state)
              GestureDetector(
                child :Row(
                  children: [ Expanded(
                    child: ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            tileColor: isSelected ? Colors.white : Colors.blue,
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                              backgroundColor: STANDARD_COLOR,
                            ),
                            title: TextField(
                              decoration: InputDecoration(
                                hintText: predictions[index].description as String,
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              onSubmitted: (String destination) async {
                                _handleSearchBarSubmit(destination);
                              },
                              enabled: false,
                            ),
                            onTap: () {
                              _handleSuggestionTap(predictions[index]);
                            },
                          )
                        );
                      },
                    ),
                  )
                ]),
                behavior: HitTestBehavior.translucent,
              ),

            //if(_showDetail && currPrediction != null ) _showDetailPage(),

            if(!_showDetail && _viewingDestinationList && !loading_state) _showDestinationList(),
            // if(loading_state) 
            // IgnorePointer(child: const LoadingWidget(loading_text: "Loading The Route"), ignoring: true,),
          ]
        ),
      )
    );
  }

  //void _generateBikeMarkers(){
  //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

