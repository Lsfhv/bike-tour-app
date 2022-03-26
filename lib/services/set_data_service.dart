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

  void generateGroup ({required String uid}) async{
    print(uid);


    _firestore.collection('users').doc(uid).collection("1").add({
      "key":0
    }).then((_){
      print("collection created");
    }).catchError((_){
      print("an error occured");
    });




    // _firestore.collection("you_Collection_Path").add({
    //   "key":0
    // }).then((_){
    //   print("collection created");
    // }).catchError((_){
    //   print("an error occured");
    // });


  }
}
