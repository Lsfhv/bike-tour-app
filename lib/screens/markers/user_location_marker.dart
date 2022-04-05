import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/user_data.dart';

class UserMarker extends Marker {
  final UserPosition user;
  UserMarker({required this.user})
      : super(
          markerId: MarkerId('current_location'),
          draggable: false,
          position: user.center as LatLng,
          // icon: BitmapDescriptor.defaultMarkerWithHue(100),
          icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
}
