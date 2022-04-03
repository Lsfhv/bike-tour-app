// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/models/user_model.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:bike_tour_app/services/set_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  final RegExp _validEmailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final RegExp _validPasswordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _emailKey = Key("EmailField");
  final _passwordKey = Key("PasswordField");
  final _passwordConfirmKey = Key("PasswordConfirmField");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 5)),
            Column(
              children: <Widget>[
                TextFormField(
                  key: Key("FirstNameField"),
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: "First name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5)),
                TextFormField(
                  key: Key("LastNameField"),
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5)),
                TextFormField(
                  key: _emailKey,
                  validator: (value) {
                    if (!_validEmailRegExp.hasMatch(value!)) {
                      return 'Not a valid email';
                    } else {
                      return null;
                    }
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5)),
                TextFormField(
                  key: _passwordKey,
                  validator: (value) {
                    if (!_validPasswordRegExp.hasMatch(value!)) {
                      return "Password must be at least one digit [0-9],\nat least one lowercase character [a-z],\nat least one uppercase character [A-Z],\nat least one special character[!@#\\\$&*~],\nat least 8 characters in length.";
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5)),
                TextFormField(
                  key: _passwordConfirmKey,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordConfirmationController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5)),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.green,
                          blurRadius: 2,
                          offset: Offset(2, 2),
                          spreadRadius: 1,
                        )
                      ],
                      color: Color.fromARGB(202, 85, 190, 56),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registering!')));
                        await context.read<AuthService>().signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                        User? user = context.read<AuthService>().currentUser;
                        UserData userData = UserData(
                          _firstNameController.text.trim(),
                          _lastNameController.text.trim(),
                          _emailController.text.trim(),
                        );
                        SetData()
                            .saveUserData(userData: userData, uid: user!.uid);
                        Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email already in use!')));
                        }

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
