import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinInformation {
  String pinPath;
  String avatarPath;
  LatLng location;
  String locationName;
  Color labelColor;

  PinInformation(
      {required this.pinPath,
      required this.avatarPath,
      required this.location,
      required this.locationName,
      required this.labelColor});
}
