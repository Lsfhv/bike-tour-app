import 'package:bike_tour_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String? _email;
  String? _firstName;
  String? _lastName;
  // TODO retrieve data from cloud firestore


  void generateFields() {
    var x = context.read<AuthService>().currentUser; 

    _email = x!.email;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Account Settings"),
      ),
      body: const Text("Settings"),
    );
  }
}

