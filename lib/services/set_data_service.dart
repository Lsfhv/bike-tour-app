/// "service" to save data into firebase firestore

import 'package:bike_tour_app/models/user_model.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
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
    //create group route data
    await _firestore.collection('group_journey').doc(code).set({
      "leader" : uid,
      "members" : [],
    });
  //set leader's code
   await  _firestore.collection('users').doc(uid).update({
      'group code' : code,
    });
  }

  void join_group({required String uid, required String code}) async {
    await  _firestore.collection('group_journey').doc(code).collection('members').update({
      'member $uid' : uid,
    }).then((_){
      
    }).catchError((_){
      print("handle this error pls");
    });
    //set member group code
    await  _firestore.collection('users').doc(uid).update({
      'group code' : code,
    });
  }

  set_journey({required JourneyDataWithRoute journey, required String code}) async{
    await _firestore.collection('group_journey').doc(code).set({
      'journey' : journey.toJson(),
    });
  }

  delete_journey({required String code}) async{
    await _firestore.collection('group_journey').doc(code).delete();
  }


}
