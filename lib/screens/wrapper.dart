// import 'dart:html';

import 'package:bike_tour_app/screens/authenticate/sign_in.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

/// The Wrapper.
/// The section where if user is authenticated, we show them the main screen
/// if not, they need to login

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  final AuthCredential credential = AuthCredential(providerId: EmailAuthProvider.PROVIDER_ID, signInMethod: EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD );



  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    //final isNewUser = ModalRoute.of(context)!.settings.arguments as String;
    if (firebaseUser != null) {
      return const MainMap();
    }
    // else if(isNewUser){
    //   return const TutorialMainMap();
    // }
    else {
      return const SignIn();
    }
  }
}
