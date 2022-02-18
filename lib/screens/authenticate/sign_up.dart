// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "First name",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Last name",
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      context.read<AuthService>().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                          );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
