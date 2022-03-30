import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:bike_tour_app/screens/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/user_data.dart';
import '../markers/user_location_marker.dart';
import '../widgets/location_getter.dart';

class TutorialFromPage extends StatefulWidget {
  const TutorialFromPage({Key? key}) : super(key: key);
  @override
  _TutorialFromPageState createState() => _TutorialFromPageState();
}

class _TutorialFromPageState extends State<TutorialFromPage> {
  late GoogleMapController mapController;
  UserPosition? _currentPosition;
  bool locationPermission = false;
  LatLng _center = const LatLng(51.507399, -0.127689);
  Icon customIcon = const Icon(Icons.search);
  bool _fetchingLocation = false;
  Marker? _currLoc = null; 
  late TextEditingController _controller;
  final _searcher = GoogleGeocodingApi("AIzaSyA75AqNa-yxMDYqffGrN0AqyUPumqkmuEs");
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
    }
    else{
      //await openAppSettings();
    }
   }

  _onPress(){
    Navigator.pop(context); 
    Navigator.pushNamed(context, ToPage.routeName, arguments : _currentPosition);
  }


  _handleSubmit(String location) async{
    String edited_loc = location + " London";
    GoogleGeocodingResponse loc =  await _searcher.search(edited_loc);
    setState(() {
      LatLng pos = LatLng(loc.results.first.geometry!.location.lat, loc.results.first.geometry!.location.lng);
      _center = pos;
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
      _currentPosition = UserPosition( pos);
      _currLoc = UserMarker(user: _currentPosition as UserPosition);

    });
    //Pop that you are adding new destination
    showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("Your journey starts now!" ),//+tag),
      actions : <Widget>[
        TextButton(onPressed: () => Navigator.pushNamed(context, ToPage.routeName, arguments : _currentPosition), child: const Text("Ok!"))
      ]
    )
    );
    //Navigate to next page
    //Navigator.pushNamed(context, ToPage.routeName, arguments : _currentPosition);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title : LocationGetter(onSubmitted: _handleSubmit, onTap : () async => _getCurrentLocation()),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: STANDARD_COLOR,
          ),

          body: Stack(alignment: Alignment.center,
          children: [
            Center(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: {if (_currLoc != null) _currLoc as Marker},
                initialCameraPosition: CameraPosition(target: _center, zoom: 15),
              ),
            ),
            if(_fetchingLocation && locationPermission) Center(child: LoadingWidget(loading_text: "Finding Your Location",)),
            
          ]
          ,) 

      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}




}


