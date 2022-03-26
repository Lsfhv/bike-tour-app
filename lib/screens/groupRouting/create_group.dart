import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/set_data_service.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({ Key? key }) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  String? uid;

  void preComputation() {
    User? user = context.read<AuthService>().currentUser;
    uid = user?.uid;

    SetData().generateGroup(uid: uid!);
  }

  @override
  Widget build(BuildContext context) {
    preComputation();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Create A Group"),
      ),
      body: Center(child: TextFormField(

      )
      ),
    );
  }
}