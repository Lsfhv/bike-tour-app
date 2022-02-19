import 'package:bike_tour_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetData {
  var _firestore;

  SetData() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<String> saveUserData(
      {required UserData userData, required String uid}) async {
    await _firestore.collection('users').doc(uid).set(userData.toJson());
    // add proper success and error message handling
    return "Success";
  }
}
