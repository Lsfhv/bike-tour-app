// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/screens/authenticate/forgot_password.dart';
import 'package:bike_tour_app/screens/authenticate/sign_up.dart';
import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RegExp _validEmailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final RegExp _validPasswordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 50.0, 0.0, 0.0),
              child: Text('London',
                  style:
                      TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 0.0),
              child: Text('Cycle',
                  style:
                      TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  validator: (value) {
                      if (!_validEmailRegExp.hasMatch(value!)) {
                      return 'Not a valid email';
                    }
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: 'Email',
                      prefix: Icon(
                        Icons.person_outline,
                        size: 1,
                      ),
                      fillColor: Colors.blue,
                      hintText: 'Enter valid email id as abc@gmail.com'),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                validator: (value) {
                    if (!_validPasswordRegExp.hasMatch(value!)) {
                    return 'Password must be 8 characters long, contain an Upper Case character, a Number and a Special character';
                  }
                },
                key: Key("PasswordFieldKey"),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
              child: Text("Forgot Password"),
              style: TextButton.styleFrom(
                primary: Colors.green,
              ),
            ),
            Container(
              key: Key("LoginContainer"),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color.fromARGB(202, 85, 190, 56),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trying to Log in!')));
                    String value = await context.read<AuthService>().signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                    if (value == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Email or Password is not valid')));
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, letterSpacing: 3),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text("New User? Create Account"),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(202, 85, 190, 56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
