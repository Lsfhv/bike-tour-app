// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'package:bike_tour_app/screens/groupRouting/group_routing.dart';
import 'package:bike_tour_app/models/tfl-api/get_api.dart';
import 'package:bike_tour_app/screens/settings/settings.dart';
import 'package:bike_tour_app/screens/widgets/tutorial_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/from_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
//import 'package:bike_tour_app/screens/navigation/route_planner.dart';
import 'package:location/location.dart';

// ignore: unused_import
import '../../live_test/live_navigation/src/DynamicTestingNavigation.dart';

class TutorialMainMap extends StatefulWidget {
  const TutorialMainMap({Key? key}) : super(key: key);
  static final GetApi getApi = GetApi();
  static final routeName = '/TutorialMainMap';
  @override
  _TutorialMainMapState createState() => _TutorialMainMapState();
}

class _TutorialMainMapState extends State<TutorialMainMap> {
  final LatLng _initialcameraposition = LatLng(51.507399, -0.127689);
  late GoogleMapController _controller;
  final Location _location = Location();
  final introKey = GlobalKey<IntroductionScreenState>();
  
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
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
                child: TutorialWrapper(
                  tutorialText: "Press this to join a group or create a group!",
                  child: FloatingActionButton(
                  heroTag: "Persons",
                  onPressed: () {
                    // person
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => GroupRoutingPage())));
                  },
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  child: const Icon(Icons.person),
                ),
                )
              ),
              Align(
                alignment: Alignment(0, 0.63),
                child: SizedBox(
                  width: 250.0,
                  height: 75.0,
                  // ignore: deprecated_member_use
                  child: TutorialWrapper(
                    tutorialText: "Press 'Plan Journey' to start a journey!",
                    child: RaisedButton(
                      child: Text(
                        'Plan Journey',
                        style:
                            GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                      ),
                      color: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                      onPressed: () async {
                          
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FromPage()));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
