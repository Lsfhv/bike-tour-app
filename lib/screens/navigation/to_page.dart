
//import 'dart:html';

import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';


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
  final _google_geocode_API = GoogleGeocodingApi("AIzaSyA75AqNa-yxMDYqffGrN0AqyUPumqkmuEs", isLogged: true); 
  Icon customIcon = const Icon(Icons.search);
  List<LatLng> list_of_destinations = <LatLng>[];
  Set<Marker>? _markers;

//for later
  //Widget _makeChild(){
  //  if(showingDestinationList){
  //    return DestinationShower(locations: locations);
  //  }
  //  else{
  //    return Destination_Retriever(
  //            onSubmitted: _handleSubmit,
  //        );
  //  }
  //}

  _handleTap(UserPosition args) {
    showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : const Text("Have you added all the places you want to visit?"),
      actions : <Widget>[
        TextButton(onPressed: () => Navigator.pop(context, "No")/*_navigateToNextPage(args)*/, child: const Text("Yes")),
        TextButton(onPressed: () => Navigator.pop(context, "No") , child: const Text("No"))
      ]
    )
    );
  }

  
  _navigateToNextPage(UserPosition args){
    Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyData(
      args, list_of_destinations
    ));

  }

  _handleSubmit(String destination) async{
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
              onSubmitted: _handleSubmit,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          ),

          body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
              markers: _markers as Set<Marker>
              
            ),
          ),
        floatingActionButton: TextButton(
            onPressed:()=> Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyData(args, list_of_destinations)), child: const Text("Lets Go!")
                ),
      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}



/*
class DestinationShower extends StatefulWidget {
  const DestinationShower({ Key? key, required this.locations }) : super(key: key);
  final List<Location>? locations;
  @override
  _DestinationShowerState createState() => _DestinationShowerState();
}
class _DestinationShowerState extends State<DestinationShower> {
  List<Widget> _generateDestinations(){
    List<Widget> widgets = [];  
  if(widget.locations != null){
    for(Location location in widget.locations as List<Location>){
      //LatLng coords
      //widgets.add(Text(location));
    }
  }
  return widgets;
}
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _generateDestinations(),
    );
  }
}

*/

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever({ Key? key, required this.onSubmitted }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
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
            )
        )
      ]
    );
  }
}