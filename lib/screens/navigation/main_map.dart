// ignore_for_file: prefer_const_constructors
import 'package:bike_tour_app/screens/groupRouting/group_routing.dart';
import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:bike_tour_app/screens/markers/bike_markers.dart';
import 'package:bike_tour_app/screens/settings/settings.dart';
import 'package:bike_tour_app/screens/widgets/check_wifi.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/from_page.dart';
//import 'package:bike_tour_app/screens/navigation/route_planner.dart';
import 'package:location/location.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);
  static final GetApi getApi = GetApi();
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final LatLng _initialcameraposition = LatLng(51.507399, -0.127689);
  late GoogleMapController _controller;
  final Location _location = Location();

  final Set<Marker> bikePoints = new Set();

  BitmapDescriptor mapMarker = BitmapDescriptor.defaultMarkerWithHue(107);
  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/bike-marker.png');
  }

  final CheckWifi checkWifi = CheckWifi();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });

    @override
    void dispose() {
      _cntlr.dispose();
      super.dispose();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    checkWifi.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
                markers: getmarkers(),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
              ),
              Align(
                alignment: Alignment(0.8, -0.8),
                child: FloatingActionButton(
                  heroTag: "Settings",
                  onPressed: () {
                    // the settings button
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  child: const Icon(Icons.settings),
                ),
              ),
              Align(
                alignment: Alignment(-0.8, -0.8),
                child: FloatingActionButton(
                  heroTag: "Persons",
                  onPressed: () {
                    // person
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => GroupRoutingPage())));
                  },
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  child: const Icon(Icons.person),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.63),
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
                          MaterialPageRoute(builder: (context) => FromPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    setState(() {
      bikePoints.add(Marker(
        //add first marker
        markerId: MarkerId("Santander Cycles, Bush House."),
        position: LatLng(51.515164, -0.117833), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Santander Cycles: Sardinia House',
          snippet: 'Bikes Available: X  Free Spaces: Y',
        ),
        icon: mapMarker, //Icon for Marker
      ));

      bikePoints.add(Marker(
        //add second marker
        markerId: MarkerId("2"),
        position: LatLng(51.509941, -0.117634), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Santander Cycles: Somerset House',
          snippet: 'Bikes Available: X  Free Spaces: Y',
        ),
        icon: mapMarker, //Icon for Marker
      ));

      bikePoints.add(Marker(
        //add third marker
        markerId: MarkerId("3"),
        position: LatLng(51.509625, -0.119038), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Santander Cycles: Embankment',
          snippet: 'Bikes Available: X  Free Spaces: Y',
        ),
        icon: mapMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return bikePoints;
  }
}
