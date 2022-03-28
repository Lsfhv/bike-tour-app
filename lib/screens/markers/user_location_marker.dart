import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class UserMarker extends Marker {
  final UserPosition user;
  UserMarker({required this.user})
      : super(
          markerId: MarkerId('current_location'),
          draggable: false,
          position: user.center as LatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(100),
        );
}
