import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tfl-api/bike_docking_points.dart';

class DataRepository {

  final CollectionReference collection = 
    FirebaseFirestore.instance.collection('bike_docking_stations');


  Stream<QuerySnapshot> getStream(){
    return collection.snapshots();
  }

  Future<DocumentReference> addBikePoints(BikeDockPoint station) {
    return collection.add(station.toJson());
  }

  void updateBikePoints(BikeDockPoint station) async{
    await collection.doc(station.referenceId).update(station.toJson());
  }

  void deleteBikePoints(BikeDockPoint station) async {
    await collection.doc(station.referenceId).delete();
  }
}