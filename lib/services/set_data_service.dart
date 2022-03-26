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

  void generateGroup ({required String uid}) async {

    // var x = _firestore.collection('users').doc(uid);


    // print(x);
    // var y = await x.get();
    // print(y['firstName']);




    
    // _firestore.collection('users').doc(uid).collection("group1").add({
    //   "Leader":[1,2],
    // }).then((_){
    //   print("collection created");
    // }).catchError((_){
    //   print("an error occured");
    // });


    // _firestore.collection('users').doc(uid).add({"hey1":[uid]});

  }
}
