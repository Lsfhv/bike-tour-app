import 'package:bike_tour_app/screens/authenticate/sign_in.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const MainMap();
    } else {
      return const SignIn();
    }
  }
}
