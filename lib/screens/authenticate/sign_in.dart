// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/main.dart';
import 'package:bike_tour_app/screens/authenticate/sign_in_form.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/authenticate/sign_up.dart';
import 'package:bike_tour_app/services/auth.dart';
// import 'package:bike_tour_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // final AuthService _auth = AuthService();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_auth.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SignInForm(),
    );
  }
}
