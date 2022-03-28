import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:permission_handler/permission_handler.dart';

import '../markers/user_location_marker.dart';

class FromPage extends StatefulWidget {
  const FromPage({Key? key}) : super(key: key);
  @override
  _FromPageState createState() => _FromPageState();
}

class _FromPageState extends State<FromPage> {
  late GoogleMapController mapController;
  UserPosition? _currentPosition;
  bool locationPermission = false;
  LatLng _center = const LatLng(51.507399, -0.127689);
  Icon customIcon = const Icon(Icons.search);
  bool _fetchingLocation = false;
  Marker? _currLoc = null;
  late TextEditingController _controller;
  final _searcher =
      GoogleGeocodingApi("AIzaSyA75AqNa-yxMDYqffGrN0AqyUPumqkmuEs");
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

  Future<void> _getCurrentLocation() async{
    locationPermission = (await Permission.location.request().isGranted) || (await Permission.locationWhenInUse.serviceStatus.isEnabled);
    if(locationPermission){
      setState(() {
        _fetchingLocation = true;
      });
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          setState(() {
            LatLng pos =  LatLng(position.latitude, position.longitude);
            _center = pos;
            mapController.animateCamera(CameraUpdate.newLatLng(_center));
            _currentPosition = UserPosition(pos);
            _fetchingLocation = false;

          });
          showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
            title : Text("Your journey starts now!" ),//+tag),
            actions : <Widget>[
              TextButton(onPressed: () => _onPress(), child: const Text("Ok!"))
            ]
            )
          ); 
        }).catchError((e) {
          print(e);
        });
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(title: Text("Your journey starts now!"), //+tag),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, ToPage.routeName,
                              arguments: _currentPosition),
                          child: const Text("Ok!")),
                    ]));
      }).catchError((e) {
        print(e);
      });
    }
    else{
      //await openAppSettings();
    }
   }

  _handleSubmit(String location) async {
    String edited_loc = location + " London";
    GoogleGeocodingResponse loc = await _searcher.search(edited_loc);
    setState(() {
      LatLng pos = LatLng(loc.results.first.geometry!.location.lat,
          loc.results.first.geometry!.location.lng);
      _center = pos;
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
      _currentPosition = UserPosition(pos);
      _currLoc = UserMarker(user: _currentPosition as UserPosition);
    });
    //Pop that you are adding new destination
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text("Your journey starts now!"), //+tag),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, ToPage.routeName,
                          arguments: _currentPosition),
                      child: const Text("Ok!"))
                ]));
    //Navigate to next page
    //Navigator.pushNamed(context, ToPage.routeName, arguments : _currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(202, 85, 190, 56),
              title: LocationGetter(
                  onSubmitted: _handleSubmit, onTap: _getCurrentLocation),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: {if (_currLoc != null) _currLoc as Marker},
                    initialCameraPosition:
                        CameraPosition(target: _center, zoom: 15),
                  ),
                ),
                if (_fetchingLocation && locationPermission)
                  Center(child: CircularProgressIndicator()),
              ],
            )));
  }

  //void _generateBikeMarkers(){
  //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

class LocationGetter extends StatefulWidget {
  const LocationGetter(
      {Key? key, required this.onSubmitted, required this.onTap})
      : super(key: key);
  final onTap;
  final ValueChanged<String>? onSubmitted;
  @override
  _LocationGetterState createState() => _LocationGetterState();
}

class _LocationGetterState extends State<LocationGetter> {
  void _handleSubmit(String destination) {
    widget.onSubmitted!(destination);
  }

  void _handleTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
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
        onSubmitted: (String location) async {
          _handleSubmit(location);
        },
      )),
      IconButton(onPressed: _handleTap, icon: Icon(Icons.location_on))
    ]);
  }
}
