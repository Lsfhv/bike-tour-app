import 'dart:html';
import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bike_markers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/from_page.dart';
import 'package:geolocator/geolocator.dart';

class FromPage extends StatefulWidget {
  const FromPage({Key? key}) : super(key: key);
  @override
  _FromPageState createState() => _FromPageState();
}

class _FromPageState extends State<FromPage> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final LatLng _center = const LatLng(51.507399, -0.127689);
  Icon customIcon = const Icon(Icons.search);

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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
        ToPage.routeName : (context) =>  ToPage(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
          decoration: InputDecoration(
          hintText: 'Where are you?',
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
          onSubmitted: (String value) async {
            Navigator.pushNamed(context,
                        ToPage.routeName,
                        arguments :UserPosition(_currentPosition, "XXX")
                        );
            //await showDialog<void>(
            //  context: context,
            //  builder: (BuildContext context) {
            //    return AlertDialog(
            //      title: const Text('Thanks!'),
            //      content: Text(
            //          'You typed "$value", which has length ${value.characters.length}.'),
            //      actions: <Widget>[
            //        TextButton(
            //          onPressed: () {
            //            Navigator.pop(context);
            //          },
            //          child: const Text('OK'),
            //        ),
            //      ],
            //    );
            //  },
            //);
          },
        ),
          automaticallyImplyLeading: false,
          actions: [
           IconButton(
           onPressed: () {},
           icon: customIcon,
           )
           
          ],
          centerTitle: true,
          ),

          body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            ),
          ),
      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

    void _getCurrentLocation() {
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });
  }
}





