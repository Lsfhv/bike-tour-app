// ignore_for_file: prefer_const_constructors

import 'package:bike_tour_app/screens/navigation/to_page.dart';
import 'package:flutter/material.dart';




class DestinationSelector extends StatefulWidget {
  const DestinationSelector({Key? key}) : super(key: key);
  static const String routeName = '/destination';
  @override
  _DestinationSelectorState createState() => _DestinationSelectorState();
}

class _DestinationSelectorState extends State<DestinationSelector> {
  final _startController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _startController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start Here',
                      hintText: 'Enter your starting Location'),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 35, bottom: 0),
              child: TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add destination',
                    hintText: 'Enter a destination for your route'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
