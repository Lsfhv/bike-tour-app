import 'package:bike_tour_app/screens/authenticate/sign_in.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

/// The Wrapper.
/// The section where if user is authenticated, we show them the main screen
/// if not, they need to login

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return MainMap();
    } else {
      return const SignIn();
    }
  }
}
