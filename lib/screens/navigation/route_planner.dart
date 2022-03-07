import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';
import 'package:bike_tour_app/screens/navigation/route_planner_form.dart';

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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(202, 85, 190, 56),
                ),
                child: Center(
                  child: Text(
                    'Current Journey',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Center(child: const Text('Start: X')),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Center(child: const Text('End: Y')),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
        body: Center(
            child: Stack(
          children: <Widget>[
            const Align(
                alignment: Alignment(0, -0.55),
                child: SizedBox(child: DestinationSelector())),
            Align(
              alignment: Alignment(0, -0.15),
              child: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  heroTag: "Route",
                  backgroundColor:
                      Color.fromARGB(202, 85, 190, 56).withOpacity(1),
                  elevation: 1,
                  child: const Icon(Icons.map_rounded),
                );
              }),
            ),
            Align(
              alignment: Alignment(0, 0.05),
              child: Text(
                'Popular Destinations:',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: Colors.grey,
                  fontSize: 20.5,
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(0, 0.175),
                  child: ListTile(
                    title: Text(
                      'Big Ben',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.25),
                  child: ListTile(
                    title: Text(
                      'Tower Bridge',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.325),
                  child: ListTile(
                    title: Text(
                      'The Shard',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.4),
                  child: ListTile(
                    title: Text(
                      'London Eye',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.475),
                  child: ListTile(
                    title: Text(
                      'Science Museum',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.55),
                  child: ListTile(
                    title: Text(
                      'Tower Of London',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.625),
                  child: ListTile(
                    title: Text(
                      'Emirates Air Line',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(202, 85, 190, 56),
                        fontSize: 16.5,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.11),
                  child: Text(
                    'Add them to your journey!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.red,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment(0, -0.05),
                child: Text(
                  'See Route',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.grey,
                    fontSize: 16.5,
                  ),
                )),
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
