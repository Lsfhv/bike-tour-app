import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign up"),
        backgroundColor: Color.fromARGB(202, 85, 190, 56),
      ),
      body: const ForgotPasswordFrom(),
    );
  }
}
