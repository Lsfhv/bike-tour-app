/// "service" to save data into firebase firestore

import 'package:bike_tour_app/models/user_model.dart';
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

  void generateGroup ({required String uid, required String code}) async {
    _firestore.collection('users').doc(uid).update({
      "Group $code":[uid,],
    }).then((_){
      
    }).catchError((_){
      print("handle this error pls");
    });
  }

}
