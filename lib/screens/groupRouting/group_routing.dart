import 'package:bike_tour_app/screens/groupRouting/create_group.dart';
import 'package:bike_tour_app/screens/groupRouting/join_page.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';

class GroupRoutingPage extends StatefulWidget {
  const GroupRoutingPage({ Key? key }) : super(key: key);

  @override
  State<GroupRoutingPage> createState() => _GroupRoutingPageState();
}

class _GroupRoutingPageState extends State<GroupRoutingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Group Routing",),
      ),
      body: Center(
  child:  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      TextButton(onPressed: _joinGroup, child: const Text("Join a group?"),
        style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.black,
                      textStyle: const TextStyle(fontSize: 20),
                    ),),
      TextButton(onPressed: _createGroup, child: const Text("Create a group"),
      style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                  ),),
    ],
  ),
)
    );
  }

  void _joinGroup () {
    Navigator.pushNamed(context, JoiningPage.routeName);
  }

  void _createGroup () {
      Navigator.push(context, MaterialPageRoute(builder: ((context) => CreateGroup())));
  }


}