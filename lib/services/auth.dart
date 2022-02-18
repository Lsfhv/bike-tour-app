import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("signed in");
      _firebaseAuth.userChanges().listen((User? user) {
        if (user == null) {
          print("no");
        } else {
          print("yes");
        }
      });
      return "Signed in";
    } on FirebaseAuthException catch (exception) {
      print("didnt work");
      return exception.toString();
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (exception) {
      return exception.toString();
    }
  }
}
