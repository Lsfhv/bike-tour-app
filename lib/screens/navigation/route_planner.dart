import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';

class RoutePlan extends StatefulWidget {
  const RoutePlan({Key? key}) : super(key: key);
  @override
  _RoutePlanState createState() => _RoutePlanState();
}

GlobalKey<ScaffoldState> _journeyKey = GlobalKey();

class _RoutePlanState extends State<RoutePlan> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _journeyKey,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(202, 85, 190, 56),
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, 0),
              child: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  heroTag: "Route",
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  elevation: 1,
                  child: const Icon(Icons.arrow_back),
                ); // <-- Opens drawer.
              }),
            ),
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
            const Align(
                alignment: Alignment(0, 0),
                child: Divider(
                  color: Color.fromARGB(255, 109, 103, 103),
                  thickness: 0.5,
                )),
            Align(
              alignment: const Alignment(0, 0.85),
              child: SizedBox(
                width: 225.0,
                height: 65.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    'GO',
                    style:
                        GoogleFonts.lato(color: Colors.white, fontSize: 16.5),
                  ),
                  color: const Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoutePlan()));
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
