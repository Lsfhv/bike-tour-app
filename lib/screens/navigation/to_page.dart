
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/chat/v1.dart' hide TextButton;





class UserPosition {
  final Map<String, dynamic>? position;
  final String? place_id;
  //final String user_id;

  UserPosition.position(this.position, {this.place_id });//this.user_id);
  UserPosition.place_id(this.place_id, { this.position,});//this.user_id);
}

class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}




class _ToPageState extends State<ToPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(51.507399, -0.127689);

  Icon customIcon = const Icon(Icons.search);
  List<String> list_of_destinations = <String>[];

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

  _handleSubmit(String destination){
      list_of_destinations.add(destination);
      //Pop that you are adding new destination
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