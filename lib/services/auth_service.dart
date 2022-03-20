// ignore_for_file: avoid_print

/// The authentication service provider for firebase to authenticate
/// users to sign in, register and more.

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  // signed in or not
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (exception) {
      print(exception.toString());
      return "";
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (exception) {
      print(exception.toString());
      return "";
    }
  }

  String resetPassword({required String email}) {
    _firebaseAuth.sendPasswordResetEmail(email: email);
    
    return "Success";
    // add then and on error catches
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
