import 'package:bike_tour_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _uid;

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<AuthService>().currentUser;

    _uid = currentUser!.uid;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = snapshot.data;
            return SettingsList(
              sections: [
                SettingsSection(
                  title: const Text(
                    'ACCOUNT SETTINGS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  ),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: const Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17 / 0.9,
                            color: Color.fromARGB(202, 85, 190, 56)),
                      ),
                      // leading: const Icon(Icons.language),
                      value: Text(
                        data['firstName'] + " " + data['lastName'],
                      ),
                    ),
                    SettingsTile.navigation(
                      value: Text(data['email']),
                      title: const Text(
                        'E-mail',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17 / 0.9,
                            color: Color.fromARGB(202, 85, 190, 56)),
                      ),
                    ),
                    SettingsTile.navigation(
                      title: const Text(
                        'Routing History',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17 / 0.9,
                            color: Color.fromARGB(202, 85, 190, 56)),
                      ),
                      value: const Text('Routes will go here...'),
                    ),
                    SettingsTile.navigation(
                      title: const Text(
                        'Group History',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17 / 0.9,
                            color: Color.fromARGB(202, 85, 190, 56)),
                      ),
                      value: const Text('Groups will go here...'),
                    ),
                    SettingsTile.navigation(
                      title: TextButton(
                          onPressed: () {
                            var result = context.read<AuthService>().signOut();
                            Navigator.pop(context);
                          },
                          child: const Text("Logout")),
                    )
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
