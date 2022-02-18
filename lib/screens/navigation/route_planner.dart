import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_tour_app/screens/navigation/main_map.dart';

class RoutePlan extends StatefulWidget {
  const RoutePlan({Key? key}) : super(key: key);
  @override
  _RoutePlanState createState() => _RoutePlanState();
}

class _RoutePlanState extends State<RoutePlan> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainMap()));
          },
          child: Text(
            "Back to map",
            style: GoogleFonts.lato(color: Colors.black),
          ),
        )),
      ),
    );
  }
}
