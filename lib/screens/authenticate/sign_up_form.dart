// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/models/user_data.dart';
import 'package:bike_tour_app/services/auth.dart';
import 'package:bike_tour_app/services/set_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final RegExp _vaidEmailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final RegExp _validPasswordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: "First name",
                  ),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last name",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (!_vaidEmailRegExp.hasMatch(value!)) {
                      return 'Not a valid email';
                    }
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (!_validPasswordRegExp.hasMatch(value!)) {
                      return 'Password must contain an upper case character, a number and a special character';
                    }
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                  },
                  controller: passwordConfirmationController,
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
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registering!')));
                        await context.read<AuthService>().signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                        User? user = context.read<AuthService>().currentUser;
                        UserData userData = UserData(
                          firstNameController.text.trim(),
                          lastNameController.text.trim(),
                          emailController.text.trim(),
                        );
                        SetData()
                            .saveUserData(userData: userData, uid: user!.uid);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter valid credentials')));
                      }
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
