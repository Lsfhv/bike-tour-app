import 'package:bike_tour_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ForgotPasswordFrom extends StatefulWidget {
  const ForgotPasswordFrom({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFromState createState() => _ForgotPasswordFromState();
}

class _ForgotPasswordFromState extends State<ForgotPasswordFrom> {
  final _emailController = TextEditingController();

  final RegExp _vaidEmailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void dispose() {
    _emailController.dispose();
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
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                validator: (value) {
                  if (!_vaidEmailRegExp.hasMatch(value!)) {
                    return 'Not a valid email';
                  }
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  var result = context
                      .read<AuthService>()
                      .resetPassword(email: _emailController.text);
                  if (result == "Success") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please check your email to reset you password')));
                  }
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
