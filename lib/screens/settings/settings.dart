import 'package:bike_tour_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String? _email;
  String? _uid; 
  String? _firstName;
  String? _lastName;

  void generateFields() async {
    var currentUser = context.read<AuthService>().currentUser; 

    _email = currentUser!.email;
    _uid = currentUser.uid;

    var userdata = await FirebaseFirestore.instance.collection('users')
      .doc(_uid).get();

    _firstName = userdata.data()!['firstName'];
    _lastName = userdata.data()!['lastName'];
  }

  @override
  Widget build(BuildContext context) {
    generateFields();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Account Settings"),
      ),
      body: const Text("Settings"),
    );
  }
}

