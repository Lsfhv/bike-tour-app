import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ForgotPasswordFrom extends StatefulWidget {
  const ForgotPasswordFrom({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFromState createState() => _ForgotPasswordFromState();
}

class _ForgotPasswordFromState extends State<ForgotPasswordFrom> {
  final _emailController = TextEditingController();
  final RegExp _validEmailRegExp = RegExp(
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
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 25),
              child: TextFormField(
                validator: (value) {
                  if (!_validEmailRegExp.hasMatch(value!)) {
                    return 'Not a valid email';
                  }
                },
                key: const Key("EmailKey"),
                controller: _emailController,
                decoration: const InputDecoration(
                  //border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ),
            Container(
              key: const Key("ResetKey"),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(202, 85, 190, 56),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await context
                        .read<AuthService>()
                        .resetPassword(email: _emailController.text);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Please check your email to reset you password',
                      )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Email doesn\'t exist',
                      )));
                    }
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
