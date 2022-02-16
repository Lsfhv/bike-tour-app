// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                  onPressed: () {},
                  backgroundColor: Color.fromARGB(202, 85, 190, 56),
                  child: const Icon(Icons.settings),
                ),
              ),
              Align(
                alignment: Alignment(-0.8, -0.8),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color.fromARGB(202, 85, 190, 56),
                  child: const Icon(Icons.person),
                ),
              ),
            ],
          )),
    );
  }
}
