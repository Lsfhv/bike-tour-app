import 'dart:io';

import 'package:bike_tour_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/binaryauthorization/v1.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';


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
    print("hey there");
    print(_email);
    print(_uid);
    var userdata = await FirebaseFirestore.instance.collection('users')
      .doc(_uid).get();
    print("did this work");
    _firstName = userdata.data()!['firstName'];
    print("1");
    print(_firstName);
    _lastName = userdata.data()!['lastName'];
    print("2");
    print(_lastName);
  }

  @override
  Widget build(BuildContext context) {   
    var currentUser = context.read<AuthService>().currentUser; 

    _email = currentUser!.email;
    _uid = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Account Settings"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(_uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
          if (!snapshot.hasData) {
            return const Text("loading, your internet is probably not working if you ever see this");
          } else {
            var x = snapshot.data;
            return SettingsList(
        sections: [
        SettingsSection(
          title: const Text('ACCOUNT SETTINGS'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              // leading: const Icon(Icons.language),
              title: Text(x['firstName'] + " " + x['lastName']),
              value: const Text('Name'),
            ),
            SettingsTile.navigation(
              title: Text(x['email']),
              value: const Text('Email'),
            ),
                        SettingsTile.navigation(
              title: const Text("routing history"),
              value: const Text('and store ur routes history here'),
            ),
          ],
        ),
      ],
    )           ;
          }
        },),
    );
  }
}

