import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

class FromPage extends StatefulWidget {
  const FromPage({Key? key}) : super(key: key);
  @override
  _FromPageState createState() => _FromPageState();
}

class _FromPageState extends State<FromPage> {
  late GoogleMapController mapController;
  UserPosition _currentPosition = UserPosition.place_id("ChIJd8BlQ2BZwokRAFUEcm_qrcA");
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
  Future<void> _getCurrentLocation() async{
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
        setState(() {
          _currentPosition = UserPosition.position(position.toJson());
        });
      }).catchError((e) {
        print(e);
      });
  }
  void _generateLocation(String location) async{
    GoogleGeocodingApi _searcher = GoogleGeocodingApi("AIzaSyBIF3s1kX5QoK8Oe-wORMoupH1pHcQWJx0");
    GoogleGeocodingResponse loc =  await _searcher.search(location, region: "London");
    _currentPosition = UserPosition.place_id(loc.results.first.placeId);
  }

  _handleSubmit(String location){
      String tag;
      if(_currentPosition != null){ 
        print("got location");
      }
      else{
        _generateLocation(location );
      }
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
          title : LocationGetter(onSubmitted: _handleSubmit ),
          automaticallyImplyLeading: false,
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

class LocationGetter extends StatefulWidget {
  const LocationGetter({ Key? key, required this.onSubmitted  }) : super(key: key);

  final ValueChanged<String>? onSubmitted;  
  @override
  _LocationGetterState createState() => _LocationGetterState();
}

class _LocationGetterState extends State<LocationGetter> {


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
              onSubmitted: (String location) async {_handleSubmit(location);},
            )
        )
      ]
    );
  }
}





