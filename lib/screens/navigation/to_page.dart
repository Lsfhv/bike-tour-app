//import 'dart:html';
/*
import 'dart:ui';

import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_place/google_place.dart';
import 'package:expandable/expandable.dart';
import '../../.env.dart';
import 'location_details.dart';


class UserPosition {
  final Map<String, dynamic>? position;
  //final String? place_id;
  final map_controller;
  final LatLng? center;
  //final String user_id;

  UserPosition(this.map_controller, this.center ,{this.position});//,{this.place_id});
  //UserPosition.position(this.map_controller,this.position, {this.place_id , this.center});//this.user_id);
  //UserPosition.place_id(this.map_controller,this.place_id, { this.position, this.center});//this.user_id);

}

class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}




class _ToPageState extends State<ToPage> {
  late GoogleMapController mapController;
  bool first = true;
  LatLng _center = const LatLng(51.507399, -0.127689);
  final _google_geocode_API = GoogleGeocodingApi(googleAPIKey, isLogged: true); 
  final googlePlace = GooglePlace(googleAPIKey);
  Icon customIcon = const Icon(Icons.search);
  List<LatLng> list_of_destinations = <LatLng>[];
  Set<Marker>? _markers;
  List<AutocompletePrediction> predictions = [];
  bool isSelected = false;
  bool _showDetail = false;
  AutocompletePrediction? currPrediction = null;
  _handleNavigateToNextPage(UserPosition args){
    if(list_of_destinations.isNotEmpty){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
        title : const Text("Have you added all the places you want to visit?"),
        actions : <Widget>[
          TextButton(onPressed: () => Navigator.pop(context, "No")/*_navigateToNextPage(args)*/, child: const Text("Yes")),
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

  
  _navigateToNextPage(UserPosition args){
    Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyData(
      args, list_of_destinations
    ));

  }

  void autoCompleteSearch(String value) async {
    String edited_value = value + " london";
    var result = await googlePlace.autocomplete.get(edited_value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions as List<AutocompletePrediction>;
      });
    }
  }
  
  _handleSearchBarChange(String destination) async{
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

  _handleSearchBarSubmit(String destination) async{
      String edited_destination = destination + " London"; 
      GoogleGeocodingResponse loc = await _google_geocode_API.search(edited_destination, region: "uk");
      //Pop that you are adding new destination
      setState(() {
        LatLng pos = LatLng(loc.results.first.geometry!.location.lat, loc.results.first.geometry!.location.lng);
        Marker curr_marker = Marker(markerId: MarkerId(destination), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), position : pos);
        _markers?.add(curr_marker);
        _center = pos;
        list_of_destinations.add(pos);
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
      });
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have added " + destination + " in your plan!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );

      //Navigate to next page
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _handleSuggestionTap(AutocompletePrediction prediction){
    _showDetail = true;
    currPrediction = prediction;
    print(prediction.description as String);
  }

  Widget _showDetailPage(){
    return DetailsPage(placeId: currPrediction!.placeId, googlePlace: googlePlace, closePage: () => 
      setState(() {
        _showDetail = false;
      })
    );
 }

 Widget _getPotentialSearches(BuildContext context, int index) {
  return Card(
    color : Colors.white, 
    child :ListTile(
      tileColor: isSelected ? Colors.white : Colors.blue,
      leading: CircleAvatar(
        child: Icon(
          Icons.pin_drop,
          color: Colors.white,
        ),
      ),
      title:  Text(predictions[index].description as String),
      onTap: _handleSuggestionTap(predictions[index])  
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserPosition;
    _center = args.center as LatLng;
    if(args.center!=null && first) {
      first = false;
      _markers = {Marker(markerId:const MarkerId("current location"), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), position : args.center as LatLng)};
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Destination_Retriever(
              onSubmitted: _handleSearchBarSubmit,
              onChanged: _handleSearchBarChange,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          ),

          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _center, zoom: 15),
                  markers: _markers as Set<Marker>,
                  
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index){
                    return Card(
                      color : Colors.white, 
                      child :ListTile(
                        tileColor: isSelected ? Colors.white : Colors.blue,
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(predictions[index].description as String),
                        onTap: _handleSuggestionTap(predictions[index])  
                      ),
                    );
                  }
                )
              ),
              TextButton(
                onPressed: _handleNavigateToNextPage(args), 
                child: const Text("Lets Go!")
              ),
              
              if(_showDetail) _showDetailPage(),
            ]
          ),
      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever({ Key? key,required this.onSubmitted ,required this.onChanged }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  _Destination_RetrieverState createState() => _Destination_RetrieverState();
}

class _Destination_RetrieverState extends State<Destination_Retriever> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String destination){
    widget.onSubmitted!(destination);
  }

  void _handleChange(String destination){
    if(destination.length > 3){
      widget.onChanged!(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children : <Widget> [
        Expanded(
          child:
            TextField(
              decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              ),
              style: TextStyle(
              color: Colors.white,
              ),
              controller: _controller,
              onSubmitted: (String destination) async {_handleSubmit(destination);},
              onChanged: (String destination) async {_handleChange(destination);},
            )
        )
      ]
    );
  }
}

*/
import 'dart:math';
import 'dart:ui';

import 'package:bike_tour_app/models/directions_model.dart';
import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/widgets/destination_list_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_place/google_place.dart';

// import '../../.env.dart';
import '../../.env.dart';
import '../../repository/direction.dart';

import '../markers/user_location_marker.dart';
import 'constants.dart';
import 'location_details.dart';



class UserPosition {
  final LatLng? center;
  //final String user_id;

  UserPosition(this.center); //,{this.place_id});
  //UserPosition.position(this.map_controller,this.position, {this.place_id , this.center});//this.user_id);
  //UserPosition.place_id(this.map_controller,this.place_id, { this.position, this.center});//this.user_id);

}

class Destination {
  LatLng position;
  String name;
  Destination({required this.position, required this.name});


  bool equal(Destination other){
    const int tolerance = 20; // consider anywhere within 5 min to be the same destination
    return _calculate_distance(from : this.position, to : other.position) <= tolerance;

  }

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
}

class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}

class _ToPageState extends State<ToPage> {
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

  
  _handleNavigateToNextPage(UserPosition args){
    if(list_of_destinations.isNotEmpty){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
        title : const Text("Have you added all the places you want to visit?"),
        actions : <Widget>[
          TextButton(onPressed: () =>_navigateToNextPage(args), child: const Text("Yes")),
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
    //error here    
    return directions;
  }

  _navigateToNextPage(UserPosition args)async{
    Navigator.pop(context);
    setState(() {
      loading_state = true;
    });
    jd = JourneyData(args, list_of_destinations);
    Directions? route = await _generateRoute(jd as JourneyData);
    setState(() {
      loading_state = false;
    });
    if( route == null){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have not added any destinations in your plan! Please choose a destination!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );
    }
    else{
      Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyDataWithRoute(
        journeyData: jd as JourneyData,
        route : route, 
      ));
    }
  }

  void autoCompleteSearch(String value) async {
    String edited_value = value + " london";
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
    //Pop that you are adding new destination
    setState(() {
      LatLng pos = LatLng(loc.results.first.geometry!.location.lat,
          loc.results.first.geometry!.location.lng);
      description = loc.results.first.formattedAddress;
      Destination dest = Destination(position: pos, name: description);
      Marker curr_marker = DestinationMarker(destination: dest);
      _markers?.add(curr_marker);
      _center = pos;
      list_of_destinations.add(dest);
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
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

    //Navigate to next page
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _handleSuggestionTap(AutocompletePrediction prediction) async {
    GoogleGeocodingResponse loc = await _google_geocode_API
        .search(prediction.description as String, region: "uk");
    setState(() {
      _suggestionSelected = true;
      _showDetail = true;
      currPrediction = prediction;
      LatLng pos = LatLng(loc.results.first.geometry!.location.lat,
          loc.results.first.geometry!.location.lng);
      Destination destination =
          Destination(position: pos, name: prediction.description as String);
      _suggestedMarker = DestinationMarker(destination: destination);
      _markers?.add(_suggestedMarker as DestinationMarker);
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
      print(list_of_destinations.length);
      removed = list_of_destinations.removeAt(index);
      print(list_of_destinations.length);
      print('removed');
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
    return Dismissible(
      direction: DismissDirection.down,
      key: UniqueKey(),
      child: DestinationListViewer(
          destinations: list_of_destinations,
          onDismiss: _delete_destination_at),
      onDismissed: (direction) async {
        _closeDestinationView();
      },
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
    Destination dest = Destination(position: curr_marker.position,name: currPrediction!.description as String);
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
        _viewingDestinationList = false;
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
      body: Stack(alignment: Alignment.center, children: [
        Center(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            markers: _markers as Set<Marker>,
            myLocationEnabled: false,
          ),
        ),

        if (!_showDetail && !_viewingDestinationList)
          Row(children: [
            Expanded(
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
                      ));
                },
              ),
            )
          ]),

        //if(_showDetail && currPrediction != null ) _showDetailPage(),

              if(!_showDetail && _viewingDestinationList) _showDestinationList(),
              if(loading_state) CircularProgressIndicator(),
            ]
          ),
          
      )
    );
  }

  //void _generateBikeMarkers(){
  //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever(
      {Key? key, required this.onSubmitted, required this.onChanged})
      : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  _Destination_RetrieverState createState() => _Destination_RetrieverState();
}

class _Destination_RetrieverState extends State<Destination_Retriever> {
  late TextEditingController _controller;
  final String hintText = 'Where do you want to go?';
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String destination) {
    widget.onSubmitted!(destination);
    _controller.clear();
  }

  void _handleChange(String destination) {
    widget.onChanged!(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        controller: _controller,
        onSubmitted: (String destination) async {
          _handleSubmit(destination);
        },
        onChanged: (String destination) async {
          _handleChange(destination);
        },
      ))
    ]);
  }
}
