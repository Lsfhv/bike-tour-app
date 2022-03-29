import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/destination_model.dart';


class DestinationMarker extends Marker {
  final Destination destination;
  @override
  late void Function()? tap_func;
  static defaultFunction() {}

  DestinationMarker({required this.destination, this.tap_func})
      : super(
          markerId: MarkerId(destination.name as String),
          draggable: false,
          position: destination.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(107),
          onTap: tap_func,
        );
}
