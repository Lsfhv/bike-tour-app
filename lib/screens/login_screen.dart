// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("London Cycle"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text("Login"),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Sign up"),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
