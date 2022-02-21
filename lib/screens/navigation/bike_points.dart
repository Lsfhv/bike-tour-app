import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/repository/data_repository.dart';
import 'package:bike_tour_app/screens/navigation/bike_markers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final DataRepository repository = DataRepository(); //
    return MaterialApp(
      home: Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: repository.getStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              return _buildList(context, snapshot.data?.docs ?? []);
            }),
    ));
  }
}

// 1
Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    // 2
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}
// 3
Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  // 4
  final station = BikeDockPoint.fromSnapshot(snapshot);

  return BikeMarker(station : station);
}


