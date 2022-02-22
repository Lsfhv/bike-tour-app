// ignore_for_file: prefer_const_constructors
import 'package:bike_tour_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/route_planner.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(51.507399, -0.127689);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            ),
          ),
          floatingActionButton: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(1, -0.8),
                child: FloatingActionButton(
                  heroTag: "Persons",
                  onPressed: () {
                    // the settings button
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage()));
                  },
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  child: const Icon(Icons.settings),
                ),
              ),
              Align(
                alignment: Alignment(-0.8, -0.8),
                child: FloatingActionButton(
                  heroTag: "Settings",
                  onPressed: () {
                    // person
                  },
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  child: const Icon(Icons.person),
                ),
              ),
              Align(
                alignment: Alignment(0.2, 0.63),
                child: SizedBox(
                  width: 250.0,
                  height: 75.0,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: Text(
                      'Plan Journey',
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                    ),
                    color: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RoutePlan()));
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
