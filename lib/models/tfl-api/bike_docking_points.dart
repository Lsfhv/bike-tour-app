import 'package:cloud_firestore/cloud_firestore.dart';
@deprecated
class BikeDockPoint {
  final double lat;
  final double lon;
  String referenceId;
  int bikes_available;
  int parking_available;

  BikeDockPoint(this.lat, this.lon,{required this.bikes_available, required this.parking_available, this.referenceId = ""});

  factory BikeDockPoint.fromSnapshot(DocumentSnapshot snapshot) {
    final newStation = BikeDockPoint.fromJson(snapshot.data() as Map<String, dynamic>);
    newStation.referenceId = snapshot.reference.id;
    return newStation;
  }
  factory BikeDockPoint.fromJson(Map<String, dynamic> json) => _BDPFromJson(json);

  Map<String, dynamic> toJson() => _BDPToJson(this);
  @override
  String toString() => 'BikeDockPoint<$lat,$lon>';
  
}

// 1
BikeDockPoint _BDPFromJson(Map<String, dynamic> json) {

  return BikeDockPoint(
    json['lat'] as double,
    json['lon'] as double,
    bikes_available: json['bikes_count'] as int,
    parking_available: json['parking_count'] as int,
  );
}
// 2
Map<String, dynamic> _BDPToJson(BikeDockPoint instance) =>
    <String, dynamic>{
      'lat': instance.lat, 
      'lon': instance.lon,
      'bikes_count': instance.bikes_available,
      'parking_count': instance.parking_available,
    };
