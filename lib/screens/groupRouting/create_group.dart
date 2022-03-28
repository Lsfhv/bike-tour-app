import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bike_tour_app/screens/groupRouting/group_routing.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/set_data_service.dart';

import 'dart:math';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup>
    with TickerProviderStateMixin {
  String? uid;
  String _code = "";
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void preComputation() {
    // not sure why this keeps getting built
    if (_code.length == 4) {
      return;
    }

    User? user = context.read<AuthService>().currentUser;
    uid = user?.uid;

    var rng = Random();
    for (int i = 0; i < 4; i++) {
      _code += rng.nextInt(9).toString();
    }

    SetData().generateGroup(uid: uid!, code: _code);
  }

  @override
  Widget build(BuildContext context) {
    preComputation();
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(-0.9, -0.85),
            child: FloatingActionButton(
              heroTag: "Home",
              onPressed: () {
                // the settings button
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupRoutingPage()));
              },
              backgroundColor: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Text(
              'Give this code to your friends: $_code',
              style: GoogleFonts.lato(
                  color: Color.fromARGB(202, 85, 190, 56), fontSize: 22.5),
            ),
          ),
          // LinearProgressIndicator(
          //   value: controller.value,
          //   semanticsLabel: 'Linear progress indicator',
          // ),
        ],
      ),
    ));
  }
}
