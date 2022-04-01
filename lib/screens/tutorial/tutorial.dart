import 'package:bike_tour_app/screens/tutorial/tutorial_constants.dart';
import 'package:bike_tour_app/screens/tutorial/tutorial_dynamic_navigation.dart';
import 'package:bike_tour_app/screens/tutorial/tutorial_to_page.dart';
import 'package:bike_tour_app/screens/tutorial/tutorials_from_page.dart';
import 'package:bike_tour_app/screens/tutorial/tutorials_main_map.dart';
import 'package:bike_tour_app/screens/tutorial/tutorials_route_choosing.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Tutorial extends StatefulWidget {
  
  const Tutorial({ Key? key }) : super(key: key);
  static String routeName = '/tutorial';
  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Welcome!',
          //titleWidget: Title(color: STANDARD_COLOR, child: Icon(Icons.pedal_bike)),
          //bodyWidget: TutorialMainMap(),
          body: "Press 'Plan Your Journey' to get started!",
        ),
        PageViewModel(
          title: 'Fetching Location!',
         // titleWidget: Title(color: STANDARD_COLOR, child: Icon(Icons.location_on)),
         // bodyWidget: TutorialFromPage(),
          body: "Either Key in your location, or allow us to fetch your location with the top right corner button!",
        ),
        //Topage is sophisticated, need to do more work
        PageViewModel(
          title: 'Choosing Destination!',
          //titleWidget: Title(color: STANDARD_COLOR, child: Icon(Icons.location_city_rounded)),
        /// bodyWidget: TutorialToPage(),
          body: "Enter your destinations! Tap on suggestions to checkout destination, and press the '+' icon to add suggested-destinations!",
        ),
        PageViewModel(
          title: 'Generating Route!',
          //titleWidget: Title(color: STANDARD_COLOR, child: Icon(Icons.route_outlined)),
          //bodyWidget: TutorialRoutingMap(),
          body: "Press 'Lets go' Whenever you are ready to embark on a trip!",
        ),
        PageViewModel(
          title: 'Navigating',
         // titleWidget: Title(color: STANDARD_COLOR, child: Icon(Icons.gps_fixed_rounded)),
          //bodyWidget: TutorialDynamicNavigation(),
          body: "This is the navigation Page!",
        )
      ],
    );
  }
}