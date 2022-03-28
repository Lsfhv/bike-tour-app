import 'package:bike_tour_app/screens/groupRouting/create_group.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';

class GroupRoutingPage extends StatefulWidget {
  const GroupRoutingPage({Key? key}) : super(key: key);

  @override
  State<GroupRoutingPage> createState() => _GroupRoutingPageState();
}

class _GroupRoutingPageState extends State<GroupRoutingPage> {
  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainMap()));
                },
                backgroundColor:
                    Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.2),
              child: SizedBox(
                width: 250.0,
                height: 75.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    'CREATE GROUP',
                    style:
                        GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                  ),
                  color: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  onPressed: _createGroup,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.2),
              child: SizedBox(
                width: 250.0,
                height: 75.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    'JOIN GROUP',
                    style:
                        GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                  ),
                  color: Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  onPressed: _joinGroup,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinGroup() {}

  void _createGroup() {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => CreateGroup())));
  }
}
