import 'package:flutter/material.dart';

class LocationGetter extends StatefulWidget {
  const LocationGetter({ Key? key, required this.onSubmitted, required this.onTap}) : super(key: key);
  final onTap;
  final ValueChanged<String>? onSubmitted;  
  @override
  _LocationGetterState createState() => _LocationGetterState();
}

class _LocationGetterState extends State<LocationGetter> {


  void _handleSubmit(String destination){
    widget.onSubmitted!(destination);
  }

  void _handleTap(){
    widget.onTap();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children : <Widget> [
        Expanded(
          child:
            TextField(
              decoration: InputDecoration(
              hintText: 'Where are you?',
              hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              ),
              style: TextStyle(
              color: Colors.white,
              ),
              onSubmitted: (String location) async {_handleSubmit(location);},
            )
        ),
        IconButton(onPressed: _handleTap, icon: Icon(Icons.location_on))
      ]
    );
  }
}




