
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../navigation/to_page.dart';

class DestinationMarker extends Marker {
  final Destination destination;
  DestinationMarker({required this.destination})
    : super(markerId: MarkerId(destination.name as String) ,draggable: false, position: destination.position,icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

}
