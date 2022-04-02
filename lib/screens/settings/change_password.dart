import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({ Key? key }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }


  final RegExp _validPasswordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');


  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    User? currentUser = context.read<AuthService>().currentUser;
    String? email = currentUser?.email;

    return Scaffold(
      body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children:  <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(1.0, 50.0, 0.0, 0.0),
              child: const Text('Change Password',
                  style:
                      TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 0.0),
              child: const Text('',
                  style:
                      TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding:  EdgeInsets.only(top: 1.0),
              child: Center(
                child:  SizedBox(
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  obscureText: true,
                  controller: _oldPasswordController,
                  validator: (value) {

                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: 'Old Password',
                      prefix: Icon(
                        Icons.person_outline,
                        size: 1,
                      ),
                      fillColor: Colors.blue,
                      ),
                )),
                        Padding(
                padding: const EdgeInsets.only( top :15, left: 15, right:15),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if  (!_validPasswordRegExp.hasMatch(value!)) {
                      return 'Password must be 8 characters long, contain an Upper Case character, a Number and a Special character';
                    }
                  },
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: 'New Password',
                      prefix: Icon(
                        Icons.person_outline,
                        size: 1,
                      ),
                      fillColor: Colors.blue,
                      ),
                )),
              Padding(
                padding: const EdgeInsets.only( top :15, left: 15, right:15),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if  (!_validPasswordRegExp.hasMatch(value!)) {
                      return 'Password must be 8 characters long, contain an Upper Case character, a Number and a Special character';
                    } else if (value != _newPasswordController.text) {
                      return 'New password and new password confirmation must be equal';
                    }
                  },
                  controller: _newPasswordConfirmController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      labelText: 'Confirm New Password',
                      prefix: Icon(
                        Icons.person_outline,
                        size: 1,
                      ),
                      fillColor: Colors.blue,
                      
                      ),
                )),
              Container(
              key: const Key("LoginContainer"),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(202, 85, 190, 56),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () async {


                  if (_formKey.currentState!.validate()) {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email:  email!,
                        password: _oldPasswordController.text.trim(),
                    );
                    currentUser!.updatePassword(_newPasswordController.text.trim());

                    var result = context.read<AuthService>().signOut();
                    Navigator.pop(context);
                    Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully changed password!, Please login again')));
                  }


                },
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, letterSpacing: 3),
                ),
              ),
            ),
            
          ],
        ),
      ),
    ),
    );
  }
}