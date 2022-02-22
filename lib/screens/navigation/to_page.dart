import 'package:bike_tour_app/models/tfl-api/bike_docking_points.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bike_markers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/from_page.dart';


class UserPosition {
  final Position? _position;
  final String user_id;

  UserPosition(this._position,this.user_id);
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
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserPosition;
    return MaterialApp(
      routes: {
        ToPage.routeName : (context) =>
        const ToPage(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
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
          onSubmitted: (String value) async {
            Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RoutingMap()));
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

}




